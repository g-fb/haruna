/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef VIDEOSETTINGS_H
#define VIDEOSETTINGS_H

#include "settings.h"

class VideoSettings : public Settings
{
    Q_OBJECT
    Q_PROPERTY(QString screenshotTemplate
               READ screenshotTemplate
               WRITE setScreenshotTemplate
               NOTIFY screenshotTemplateChanged)

    Q_PROPERTY(QString screenshotFormat
               READ screenshotFormat
               WRITE setScreenshotFormat
               NOTIFY screenshotFormatChanged)

public:
    explicit VideoSettings(QObject *parent = nullptr);

    QString screenshotTemplate();
    void setScreenshotTemplate(QString ssTemplate);

    QString screenshotFormat();
    void setScreenshotFormat(QString format);


    static VideoSettings *provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        return new VideoSettings();
    }

signals:
    void screenshotTemplateChanged();
    void screenshotFormatChanged();

};

#endif // VIDEOSETTINGS_H
