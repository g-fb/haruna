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
        {"SeekSmallStep",         QVariant(5)},
        {"SeekMediumStep",        QVariant(15)},
        {"SeekBigStep",           QVariant(30)},
        {"VolumeStep",            QVariant(5)},
        {"OsdFontSize",           QVariant(25)},
        {"SubtitlesFolders",      QVariant(QStringLiteral("subs"))},
        {"LastPlayedFile",        QVariant(QStringLiteral())},
        {"LastUrl",               QVariant(QStringLiteral())},
        {"Volume",                QVariant(75)},
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
        {"PreferredTrack",        QVariant(0)},
        // view
        {"IsMenuBarVisible",      QVariant(true)},
        {"IsHeaderVisible",       QVariant(true)},
    };

    m_config = KSharedConfig::openConfig("georgefb/haruna.conf");
}

// *********************************************
//   GENERAL
// *********************************************
int Settings::osdFontSize()
{
    return get("General", "OsdFontSize").toInt();
}

void Settings::setOsdFontSize(int fontSize)
{
    if (fontSize == osdFontSize()) {
        return;
    }
    set("General", "OsdFontSize", QString::number(fontSize));
    emit osdFontSizeChanged();
}

int Settings::volumeStep()
{
    return get("General", "VolumeStep").toInt();
}

void Settings::setVolumeStep(int step)
{
    if (step == volumeStep()) {
        return;
    }
    set("General", "VolumeStep", QString::number(step));
    emit volumeStepChanged();
}

int Settings::seekSmallStep()
{
    return get("General", "SeekSmallStep").toInt();
}

void Settings::setSeekSmallStep(int step)
{
    if (step == seekSmallStep()) {
        return;
    }
    set("General", "SeekSmallStep", QString::number(step));
    emit seekSmallStep();
}

int Settings::seekMediumStep()
{
    return get("General", "SeekMediumStep").toInt();
}

void Settings::setSeekMediumStep(int step)
{
    if (step == seekMediumStep()) {
        return;
    }
    set("General", "SeekMediumStep", QString::number(step));
    emit seekMediumStep();
}

int Settings::seekBigStep()
{
    return get("General", "SeekBigStep").toInt();
}

void Settings::setSeekBigStep(int step)
{
    if (step == seekBigStep()) {
        return;
    }
    set("General", "SeekBigStep", QString::number(step));
    emit seekBigStep();
}

int Settings::volume()
{
    return get("General", "Volume").toInt();
}

void Settings::setVolume(int vol)
{
    if (vol == volume()) {
        return;
    }
    set("General", "Volume", QString::number(vol));
    emit volumeChanged();
}

QString Settings::lastPlayedFile()
{
    return get("General", "LastPlayedFile").toString();
}

void Settings::setLastPlayedFile(const QString &file)
{
    if (file == lastPlayedFile()) {
        return;
    }
    set("General", "LastPlayedFile", file);
    emit lastPlayedFileChanged();
}

QString Settings::lastUrl()
{
    return get("General", "LastUrl").toString();
}

void Settings::setLastUrl(const QString &url)
{
    if (url == lastUrl()) {
        return;
    }
    set("General", "LastUrl", url);
    emit lastUrlChanged();
}

// *********************************************
//   AUDIO
// *********************************************
QString Settings::audioPreferredLanguage()
{
    return get("Audio", "PreferredLanguage").toString();
}

void Settings::setAudioPreferredLanguage(const QString &lang)
{
    if (lang == audioPreferredLanguage()) {
        return;
    }
    set("Audio", "PreferredLanguage", lang);
    emit audioPreferredLanguageChanged();
}

int Settings::audioPreferredTrack()
{
    return get("Audio", "PreferredTrack").toInt();
}

void Settings::setAudioPreferredTrack(int track)
{
    if (track == audioPreferredTrack()) {
        return;
    }
    set("Audio", "PreferredTrack", QString::number(track));
    emit audioPreferredTrackChanged();
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

// *********************************************
//   VIEW
// *********************************************
bool Settings::viewIsMenuBarVisible()
{
    return get("View", "IsMenuBarVisible").toBool();
}

void Settings::setViewIsMenuBarVisible(bool isVisible)
{
    if (isVisible == viewIsMenuBarVisible()) {
        return;
    }
    set("View", "IsMenuBarVisible", QVariant(isVisible).toString());
    emit viewIsMenuBarVisibleChanged();
}

bool Settings::viewIsHeaderVisible()
{
    return get("View", "IsHeaderVisible").toBool();
}

void Settings::setViewIsHeaderVisible(bool isVisible)
{
    if (isVisible == viewIsHeaderVisible()) {
        return;
    }
    set("View", "IsHeaderVisible", QVariant(isVisible).toString());
    emit viewIsHeaderVisibleChanged();
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
