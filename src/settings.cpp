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
        {"SubtitlesFolders",      QVariant(QStringLiteral("subs"))},
        // playback
        {"SkipChaptersWordList",  QVariant(QStringLiteral())},
        {"ShowOsdOnSkipChapters", QVariant(true)},
        {"SkipChapters",          QVariant(false)},
        {"YtdlFormat",            QVariant(QStringLiteral())},
        // audio
        {"PreferredLanguage",     QVariant(QStringLiteral())},
        {"PreferredTrack",        QVariant(0)},
        // subtitle
        {"PreferredLanguage",     QVariant(QStringLiteral())},
        {"PreferredTrack",        QVariant(0)}
    };

    m_config = KSharedConfig::openConfig("georgefb/haruna.conf");
}

// *********************************************
//   SUBTITLES
// *********************************************
QStringList Settings::subtitlesFolders()
{
    return m_config->group("Subtitles").readPathEntry("Folders", QStringList());
}

void Settings::setSubtitlesFolders(const QStringList &folders)
{
    if (folders == subtitlesFolders()) {
        return;
    }
    m_config->group("Subtitles").writePathEntry("Folders", folders);
    m_config->sync();
    emit subtitlesFoldersChanged();
}

QString Settings::subtitlesPreferredLanguage()
{
    return get("Subtitles", "PreferredLanguage").toString();
}

void Settings::setSubtitlesPreferredLanguage(const QString &preferredLanguage)
{
    if (preferredLanguage == subtitlesPreferredLanguage()) {
        return;
    }
    set("Subtitles", "PreferredLanguage", preferredLanguage);
    emit subtitlesPreferredLanguageChanged();
}

int Settings::subtitlesPreferredTrack()
{
    return get("Subtitles", "PreferredTrack").toInt();
}

void Settings::setSubtitlesPreferredTrack(int preferredTrack)
{
    if (preferredTrack == subtitlesPreferredTrack()) {
        return;
    }
    set("Subtitles", "PreferredTrack", QString::number(preferredTrack));
    emit subtitlesPreferredTrackChanged();
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
