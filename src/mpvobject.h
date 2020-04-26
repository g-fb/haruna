/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef MPVOBJECT_H
#define MPVOBJECT_H

#include <QtQuick/QQuickFramebufferObject>

#include <mpv/client.h>
#include <mpv/render_gl.h>
#include "qthelper.h"

class MpvRenderer;
class Track;
class TracksModel;

class MpvObject : public QQuickFramebufferObject
{
    Q_OBJECT
    Q_PROPERTY(QString title        MEMBER m_title      NOTIFY titleChanged)
    Q_PROPERTY(double  position     MEMBER m_position   NOTIFY positionChanged)
    Q_PROPERTY(double  duration     MEMBER m_duration   NOTIFY durationChanged)
    Q_PROPERTY(double  remaining    MEMBER m_remaining  NOTIFY remainingChanged)
    Q_PROPERTY(double  volume       MEMBER m_volume     NOTIFY volumeChanged)
    Q_PROPERTY(bool    pause        MEMBER m_pause      NOTIFY pauseChanged)
    Q_PROPERTY(int     contrast     MEMBER m_contrast   NOTIFY contrastChanged)
    Q_PROPERTY(int     brightness   MEMBER m_brightness NOTIFY brightnessChanged)
    Q_PROPERTY(int     gamma        MEMBER m_gamma      NOTIFY gammaChanged)
    Q_PROPERTY(int     saturation   MEMBER m_saturation NOTIFY saturationChanged)
    Q_PROPERTY(int     chapter      MEMBER m_chapter    NOTIFY chapterChanged)

    mpv_handle *mpv;
    mpv_render_context *mpv_gl;

    friend class MpvRenderer;
    void handle_mpv_event(mpv_event *event);
public:
    MpvObject(QQuickItem * parent = 0);
    virtual ~MpvObject();
    virtual Renderer *createRenderer() const;

public slots:
    void eventHandler();
    static void on_mpv_events(void *ctx);
    QVariant command(const QVariant& params);
    int setProperty(const QString& name, const QVariant& value);
    QVariant getProperty(const QString &name);
    TracksModel *audioTracksModel() const;
    TracksModel *subtitleTracksModel() const;

signals:
    void titleChanged();
    void positionChanged();
    void durationChanged();
    void remainingChanged();
    void volumeChanged();
    void pauseChanged();
    void chapterChanged();
    void contrastChanged();
    void brightnessChanged();
    void gammaChanged();
    void saturationChanged();
    void fileLoaded();
    void endOfFile();
    void ready();

private:
    TracksModel *m_audioTracksModel;
    TracksModel *m_subtitleTracksModel;
    QMap<int, Track*> m_subtitleTracks;
    QMap<int, Track*> m_audioTracks;
    QVariant m_chapters;
    QString m_title;
    double m_position {};
    double m_duration {};
    double m_remaining {};
    double m_volume {};
    bool m_pause {};
    int m_chapter {};
    int m_contrast {};
    int m_brightness {};
    int m_gamma {};
    int m_saturation {};

    void loadTracks();
};

class MpvRenderer : public QQuickFramebufferObject::Renderer
{
public:
    MpvRenderer(MpvObject *new_obj);
    ~MpvRenderer() = default;

    MpvObject *obj;

    // This function is called when a new FBO is needed.
    // This happens on the initial frame.
    QOpenGLFramebufferObject * createFramebufferObject(const QSize &size);

    void render();
};

#endif // MPVOBJECT_H
