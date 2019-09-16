#ifndef MPVOBJECT_H
#define MPVOBJECT_H

#include <QtQuick/QQuickFramebufferObject>

#include <mpv/client.h>
#include <mpv/render_gl.h>
#include <mpv/qthelper.hpp>

class MpvRenderer;
class Track;
class TracksModel;

class MpvObject : public QQuickFramebufferObject
{
    Q_OBJECT
    Q_PROPERTY(double position MEMBER m_position NOTIFY onPositionChanged)
    Q_PROPERTY(double duration MEMBER m_duration NOTIFY onDurationChanged)
    Q_PROPERTY(double remaining MEMBER m_remaining NOTIFY onRemainingChanged)
    Q_PROPERTY(bool pause MEMBER m_pause NOTIFY onPauseChanged)

    mpv_handle *mpv;
    mpv_render_context *mpv_gl;

    friend class MpvRenderer;
    void handle_mpv_event(mpv_event *event);
public:
    static void on_update(void *ctx);

    MpvObject(QQuickItem * parent = 0);
    virtual ~MpvObject();
    virtual Renderer *createRenderer() const;

public slots:
    void loadFile(const QString &file);
    void play_pause();
    void command(const QVariant& params);
    void setProperty(const QString& name, const QVariant& value);
    QVariant getProperty(const QString &name);
    QString formatTime(double time);
    TracksModel *audioTracksModel() const;
    TracksModel *subtitleTracksModel() const;

signals:
    void onUpdate();
    void onPositionChanged(double);
    void onDurationChanged(double);
    void onRemainingChanged(double);
    void onPauseChanged(bool);
    void fileLoaded();
    void endOfFile();
    void ready();

private slots:
    void doUpdate();
private:
    TracksModel *m_audioTracksModel;
    TracksModel *m_subtitleTracksModel;
    QMap<int, Track*> m_subtitleTracks;
    QMap<int, Track*> m_audioTracks;
    double m_position;
    double m_duration;
    double m_remaining;
    QVariant m_chapters;
    bool m_pause;

    void loadTracks();
};

#endif // MPVOBJECT_H
