/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "settings.h"
#include "_debug.h"

#include <KConfig>
#include <KConfigGroup>
#include <QVariant>

Settings::Settings(QObject *parent) : QObject(parent)
{
    m_defaultSettings = {
        // playback
        {"SkipChaptersWordList",  QVariant(QStringLiteral())},
        {"ShowOsdOnSkipChapters", QVariant(true)},
        {"SkipChapters",          QVariant(false)},
        {"YtdlFormat",            QVariant(QStringLiteral())},
    };

    m_config = KSharedConfig::openConfig("georgefb/haruna.conf");
}

// *********************************************
//   PLAYBACK
// *********************************************
bool Settings::playbackSkipChapters()
{
    return get("Playback", "SkipChapters").toBool();
}

void Settings::setPlaybackSkipChapters(bool skip)
{
    if (playbackSkipChapters() == skip)
        return;
    set("Playback", "SkipChapters", QVariant(skip).toString());
    emit playbackSkipChaptersChanged();
}

QString Settings::playbackChaptersToSkip()
{
    return get("Playback", "SkipChaptersWordList").toString();
}

void Settings::setPlaybackChaptersToSkip(const QString &wordList)
{
    if (wordList == playbackChaptersToSkip()) {
        return;
    }
    set("Playback", "SkipChaptersWordList", wordList);
    emit playbackChaptersToSkipChanged();
}

bool Settings::playbackShowOsdOnSkipChapters()
{
    return get("Playback", "ShowOsdOnSkipChapters").toBool();
}

void Settings::setPlaybackShowOsdOnSkipChapters(bool show)
{
    if (playbackShowOsdOnSkipChapters() == show) {
        return;
    }
    set("Playback", "ShowOsdOnSkipChapters", QVariant(show).toString());
    emit playbackShowOsdOnSkipChaptersChanged();
}

QString Settings::playbackYtdlFormat()
{
    return get("Playback", "YtdlFormat").toString();
}

void Settings::setPlaybackYtdlFormat(const QString &format)
{
    if (format == playbackYtdlFormat()) {
        return;
    }
    set("Playback", "YtdlFormat", format);
    emit playbackYtdlFormatChanged();
}

QVariant Settings::get(const QString &group, const QString &key)
{
    return m_config->group(group).readEntry(key, m_defaultSettings[key]);
}

void Settings::set(const QString &group, const QString &key, const QString &value)
{
    m_config->group(group).writeEntry(key, value);
    m_config->sync();

    emit settingsChanged();
}
