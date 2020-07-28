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

VideoSettings::VideoSettings()
{
    m_defaultSettings = {
        {"ScreenshotFormat",          QVariant(QStringLiteral("jpg"))},
        {"ScreenshotTemplate",        QVariant(QStringLiteral("%x/screenshots/%n"))},
    };
    m_config = KSharedConfig::openConfig("georgefb/haruna.conf");
}


QString VideoSettings::screenshotTemplate()
{
    return get("Video", "ScreenshotTemplate").toString();
}

void VideoSettings::setScreenshotTemplate(QString ssTemplate)
{
    if (ssTemplate == screenshotTemplate()) {
        return;
    }
    set("Video", "ScreenshotTemplate", ssTemplate);
    emit screenshotTemplateChanged();
}

QString VideoSettings::screenshotFormat()
{
    return get("Video", "ScreenshotFormat").toString();
}

void VideoSettings::setScreenshotFormat(QString format)
{
    if (format == screenshotFormat()) {
        return;
    }
    set("Video", "ScreenshotFormat", format);
    emit screenshotFormatChanged();
}

QVariant VideoSettings::get(const QString &group, const QString &key)
{
    return m_config->group(group).readEntry(key, m_defaultSettings[key]);
}

void VideoSettings::set(const QString &group, const QString &key, const QString &value)
{
    m_config->group(group).writeEntry(key, value);
    m_config->sync();

    emit settingsChanged();
}
