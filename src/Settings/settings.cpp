/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "settings.h"
#include "../_debug.h"

#include <KConfig>
#include <KConfigGroup>
#include <QFileInfo>
#include <QVariant>

Settings::Settings(QObject *parent) : QObject(parent)
{
    m_config = KSharedConfig::openConfig("georgefb/haruna.conf");
}

QUrl Settings::configFilePath()
{
    auto configPath = QStandardPaths::writableLocation(m_config->locationType());
    auto configFilePath = configPath.append(QStringLiteral("/")).append(m_config->name());
    QUrl url(configFilePath);
    url.setScheme("file");
    return url;
}

QUrl Settings::configFolderPath()
{
    auto configPath = QStandardPaths::writableLocation(m_config->locationType());
    auto configFilePath = configPath.append(QStringLiteral("/")).append(m_config->name());
    QFileInfo fileInfo(configFilePath);
    QUrl url(fileInfo.absolutePath());
    url.setScheme("file");
    return url;
}

QVariant Settings::get(const QString &key)
{
    return m_config->group(CONFIG_GROUP).readEntry(key, m_defaultSettings[key]);
}

void Settings::set(const QString &key, const QString &value)
{
    m_config->group(CONFIG_GROUP).writeEntry(key, value);
    m_config->sync();

    emit settingsChanged();
}
