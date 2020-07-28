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
        {"ScreenshotTemplate",    QVariant(QStringLiteral("%x/screenshots/%n"))},
    };
    m_config = KSharedConfig::openConfig("georgefb/haruna.conf");
}


QString VideoSettings::screenshotTemplate()
{
    return get("General", "ScreenshotTemplate").toString();
}

void VideoSettings::setScreenshotTemplate(QString ssTemplate)
{
    if (ssTemplate == screenshotTemplate()) {
        return;
    }
    set("General", "ScreenshotTemplate", ssTemplate);
    emit screenshotTemplateChanged();
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
