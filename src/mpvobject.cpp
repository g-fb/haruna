#include "_debug.h"

#include <QObject>
#include <QtGlobal>
#include <QOpenGLContext>
#include <QGuiApplication>

#include <QOpenGLFramebufferObject>

#include <QQuickWindow>
#include <QQuickView>
#include <QDateTime>

#include "mpvobject.h"
#include "track.h"
#include "tracksmodel.h"


namespace
{
void on_mpv_events(void *ctx)
{
    Q_UNUSED(ctx)
}

void on_mpv_redraw(void *ctx)
{
    MpvObject::on_update(ctx);
}

static void *get_proc_address_mpv(void *ctx, const char *name)
{
    Q_UNUSED(ctx)

    QOpenGLContext *glctx = QOpenGLContext::currentContext();
    if (!glctx) return nullptr;

    return reinterpret_cast<void *>(glctx->getProcAddress(QByteArray(name)));
}

}

class MpvRenderer : public QQuickFramebufferObject::Renderer
{
    MpvObject *obj;

public:
    MpvRenderer(MpvObject *new_obj)
        : obj{new_obj}
    {
        mpv_set_wakeup_callback(obj->mpv, on_mpv_events, nullptr);
    }

    virtual ~MpvRenderer()
    {}

    // This function is called when a new FBO is needed.
    // This happens on the initial frame.
    QOpenGLFramebufferObject * createFramebufferObject(const QSize &size)
    {
        // init mpv_gl:
        if (!obj->mpv_gl)
        {
            mpv_opengl_init_params gl_init_params{get_proc_address_mpv, nullptr, nullptr};
            mpv_render_param params[]{
                {MPV_RENDER_PARAM_API_TYPE, const_cast<char *>(MPV_RENDER_API_TYPE_OPENGL)},
                {MPV_RENDER_PARAM_OPENGL_INIT_PARAMS, &gl_init_params},
                {MPV_RENDER_PARAM_INVALID, nullptr}
            };

            if (mpv_render_context_create(&obj->mpv_gl, obj->mpv, params) < 0)
                throw std::runtime_error("failed to initialize mpv GL context");
            mpv_render_context_set_update_callback(obj->mpv_gl, on_mpv_redraw, obj);
            emit obj->ready();
        }

        return QQuickFramebufferObject::Renderer::createFramebufferObject(size);
    }

    void render()
    {
        obj->window()->resetOpenGLState();

        QOpenGLFramebufferObject *fbo = framebufferObject();
        mpv_opengl_fbo mpfbo{.fbo = static_cast<int>(fbo->handle()), .w = fbo->width(), .h = fbo->height(), .internal_format = 0};
        int flip_y{0};

        mpv_render_param params[] = {
            // Specify the default framebuffer (0) as target. This will
            // render onto the entire screen. If you want to show the video
            // in a smaller rectangle or apply fancy transformations, you'll
            // need to render into a separate FBO and draw it manually.
            {MPV_RENDER_PARAM_OPENGL_FBO, &mpfbo},
            // Flip rendering (needed due to flipped GL coordinate system).
            {MPV_RENDER_PARAM_FLIP_Y, &flip_y},
            {MPV_RENDER_PARAM_INVALID, nullptr}
        };
        // See render_gl.h on what OpenGL environment mpv expects, and
        // other API details.
        mpv_render_context_render(obj->mpv_gl, params);

        obj->window()->resetOpenGLState();
    }
};

MpvObject::MpvObject(QQuickItem * parent)
    : QQuickFramebufferObject(parent)
    , mpv{mpv_create()}, mpv_gl(nullptr)
    , m_subtitleTracksModel(new TracksModel)
    , m_audioTracksModel(new TracksModel)
{
    if (!mpv)
        throw std::runtime_error("could not create mpv context");

    mpv_observe_property(mpv, 0, "time-pos", MPV_FORMAT_DOUBLE);
    mpv_observe_property(mpv, 0, "time-remaining", MPV_FORMAT_DOUBLE);
    mpv_observe_property(mpv, 0, "duration", MPV_FORMAT_DOUBLE);
    mpv_observe_property(mpv, 0, "chapter-list", MPV_FORMAT_NODE);

    if (mpv_initialize(mpv) < 0)
        throw std::runtime_error("could not initialize mpv context");

    connect(this, &MpvObject::onUpdate, this, &MpvObject::doUpdate,
            Qt::QueuedConnection);

}

MpvObject::~MpvObject()
{ // only initialized if something got drawn
    if (mpv_gl) {
        mpv_render_context_free(mpv_gl);
    }

    mpv_terminate_destroy(mpv);
}

void MpvObject::on_update(void *ctx)
{
    MpvObject *self = (MpvObject *)ctx;
    emit self->onUpdate();
}

// connected to onUpdate(); signal makes sure it runs on the GUI thread
void MpvObject::doUpdate()
{
    update();
    while (mpv) {
        mpv_event *event = mpv_wait_event(mpv, 0);
        if (event->event_id == MPV_EVENT_NONE) {
            break;
        }
        switch (event->event_id) {
        case MPV_EVENT_PROPERTY_CHANGE: {
            mpv_event_property *prop = (mpv_event_property *)event->data;
            if (strcmp(prop->name, "time-pos") == 0) {
                if (prop->format == MPV_FORMAT_DOUBLE) {
                    double position = *(double *)prop->data;
                    m_position = position;

                    emit onPositionChanged(position);
                }
            } else if (strcmp(prop->name, "time-remaining") == 0) {
                if (prop->format == MPV_FORMAT_DOUBLE) {
                    double remaining = *(double *)prop->data;
                    m_remaining = remaining;

                    emit onRemainingChanged(remaining);
                }
            } else if (strcmp(prop->name, "duration") == 0) {
                if (prop->format == MPV_FORMAT_DOUBLE) {
                    double duration = *(double *)prop->data;
                    m_duration = duration;

                    emit onDurationChanged(duration);
                }
            } else if (strcmp(prop->name, "chapter-list") == 0) {
                if (prop->format == MPV_FORMAT_NODE) {
                    QVariant v = mpv::qt::node_to_variant((mpv_node *)prop->data);
                    m_chapters = v.toList();
                    emit onChaptersChanged();
                }
            }
            break;
        }
        case MPV_EVENT_FILE_LOADED: {
            loadTracks();
            break;
        }
        case MPV_EVENT_END_FILE: {
            auto prop = (mpv_event_end_file *)event->data;
            if (prop->reason == MPV_END_FILE_REASON_EOF) {
                emit endOfFile();
            }
            break;
        }
        default: ;
            // Ignore uninteresting or unknown events.
        }
    }
}

void MpvObject::loadTracks()
{
    m_subtitleTracks.clear();
    m_audioTracks.clear();
    QVariant tracks = getProperty("track-list");
    for (auto track : tracks.toList()) {
        if (track.toMap()["type"] == "sub") {
            const auto t = track.toMap();
            auto *track = new Track();
            track->setCodec(t["codec"].toString());
            track->setType(t["type"].toString());
            track->setDefaut(t["default"].toBool());
            track->setDependent(t["dependent"].toBool());
            track->setForced(t["forced"].toBool());
            track->setSelected(t["selected"].toBool());
            track->setId(t["id"].toLongLong());
            track->setSrcId(t["src-id"].toLongLong());
            track->setFfIndex(t["ff-index"].toLongLong());
            track->setLang(t["lang"].toString());
            track->setTitle(t["title"].toString());

            m_subtitleTracks << track;
        }
        if (track.toMap()["type"] == "audio") {
            const auto t = track.toMap();
            auto *track = new Track();
            track->setCodec(t["codec"].toString());
            track->setType(t["type"].toString());
            track->setDefaut(t["default"].toBool());
            track->setDependent(t["dependent"].toBool());
            track->setForced(t["forced"].toBool());
            track->setSelected(t["selected"].toBool());
            track->setId(t["id"].toLongLong());
            track->setSrcId(t["src-id"].toLongLong());
            track->setFfIndex(t["ff-index"].toLongLong());
            track->setLang(t["lang"].toString());
            track->setTitle(t["title"].toString());

            m_audioTracks << track;
        }
    }
    m_subtitleTracksModel->setTracks(m_subtitleTracks);
    m_audioTracksModel->setTracks(m_audioTracks);
}

TracksModel *MpvObject::subtitleTracksModel() const
{
    return m_subtitleTracksModel;
}

TracksModel *MpvObject::audioTracksModel() const
{
    return m_audioTracksModel;
}

void MpvObject::command(const QVariant& params)
{
    mpv::qt::command(mpv, params);
}

void MpvObject::setProperty(const QString& name, const QVariant& value)
{
    mpv::qt::set_property(mpv, name, value);
}

QVariant MpvObject::getProperty(const QString& name)
{
    auto value = mpv::qt::get_property(mpv, name);
    return value;
}

QQuickFramebufferObject::Renderer *MpvObject::createRenderer() const
{
    window()->setPersistentOpenGLContext(true);
    window()->setPersistentSceneGraph(true);
    return new MpvRenderer(const_cast<MpvObject *>(this));
}

QString MpvObject::formatTime(double time)
{
    QDateTime d = QDateTime::fromTime_t(time).toUTC();
    QString formattedTime = d.toString("hh:mm:ss");
    return formattedTime;

}

void MpvObject::play_pause()
{
    const bool paused = mpv::qt::get_property(mpv, "pause").toBool();
    setProperty("pause", !paused);
}

void MpvObject::loadFile(const QString &file)
{
    QString filepath = QUrl(file).toLocalFile().isEmpty() ? file : QUrl(file).toLocalFile();
    setProperty("start", "+0");
    command(QVariant(QStringList() << "loadfile" << filepath));
}
