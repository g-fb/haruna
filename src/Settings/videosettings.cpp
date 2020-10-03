/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "videosettings.h"
#include "../_debug.h"

#include <KConfig>
#include <KConfigGroup>
#include <QVariant>

VideoSettings::VideoSettings(QObject *parent)
    : Settings(parent)
{
    CONFIG_GROUP = QStringLiteral("Video");
    m_defaultSettings = {
        {"ScreenshotFormat",          QVariant(QStringLiteral("jpg"))},
        {"ScreenshotTemplate",        QVariant(QStringLiteral("%x/screenshots/%n"))},
    };
    m_config = KSharedConfig::openConfig("georgefb/haruna.conf");
}


QString VideoSettings::screenshotTemplate()
{
    return get("ScreenshotTemplate").toString();
}

void VideoSettings::setScreenshotTemplate(QString ssTemplate)
{
    if (ssTemplate == screenshotTemplate()) {
        return;
    }
    set("ScreenshotTemplate", ssTemplate);
    emit screenshotTemplateChanged();
}

QString VideoSettings::screenshotFormat()
{
    return get("ScreenshotFormat").toString();
}

void VideoSettings::setScreenshotFormat(QString format)
{
    if (format == screenshotFormat()) {
        return;
    }
    set("ScreenshotFormat", format);
    emit screenshotFormatChanged();
}
