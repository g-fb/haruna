#include "playbacksettings.h"
#include "../_debug.h"

PlaybackSettings::PlaybackSettings(QObject *parent)
    : Settings(parent)
{
    m_defaultSettings = {
        {"SkipChaptersWordList",  QVariant(QStringLiteral())},
        {"ShowOsdOnSkipChapters", QVariant(true)},
        {"SkipChapters",          QVariant(false)},
        {"YtdlFormat",            QVariant(QStringLiteral())},
    };
}

bool PlaybackSettings::skipChapters()
{
    return get("Playback", "SkipChapters").toBool();
}

void PlaybackSettings::setSkipChapters(bool skip)
{
    if (skip == skipChapters())
        return;
    set("Playback", "SkipChapters", QVariant(skip).toString());
    emit skipChaptersChanged();
}

QString PlaybackSettings::chaptersToSkip()
{
    return get("Playback", "SkipChaptersWordList").toString();
}

void PlaybackSettings::setChaptersToSkip(const QString &wordList)
{
    if (wordList == chaptersToSkip()) {
        return;
    }
    set("Playback", "SkipChaptersWordList", wordList);
    emit chaptersToSkipChanged();
}

bool PlaybackSettings::showOsdOnSkipChapters()
{
    return get("Playback", "ShowOsdOnSkipChapters").toBool();
}

void PlaybackSettings::setShowOsdOnSkipChapters(bool show)
{
    if (show == showOsdOnSkipChapters()) {
        return;
    }
    set("Playback", "ShowOsdOnSkipChapters", QVariant(show).toString());
    emit showOsdOnSkipChaptersChanged();
}

QString PlaybackSettings::ytdlFormat()
{
    return get("Playback", "YtdlFormat").toString();
}

void PlaybackSettings::setYtdlFormat(const QString &format)
{
    if (format == ytdlFormat()) {
        return;
    }
    set("Playback", "YtdlFormat", format);
    emit ytdlFormatChanged();
}
