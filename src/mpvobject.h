#ifndef MPVOBJECT_H
#define MPVOBJECT_H

#include <QtQuick/QQuickFramebufferObject>

#include <mpv/client.h>
#include <mpv/render_gl.h>
#include <mpv/qthelper.hpp>

class MpvRenderer;

class MpvObject : public QQuickFramebufferObject
{
    Q_OBJECT
    Q_PROPERTY(double position MEMBER m_position NOTIFY onPositionChanged)
    Q_PROPERTY(double duration MEMBER m_duration NOTIFY onDurationChanged)

    mpv_handle *mpv;
    mpv_render_context *mpv_gl;

    double m_position;
    double m_duration;

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

signals:
    void onUpdate();
    void onPositionChanged(double);
    void onDurationChanged(double);
    void endOfFile();
    void ready();

private slots:
    void doUpdate();
};

#endif // MPVOBJECT_H
