#include "playbacksettings.h"
#include "../_debug.h"

PlaybackSettings::PlaybackSettings(QObject *parent)
    : Settings(parent)
{
    CONFIG_GROUP = QStringLiteral("Playback");
    m_defaultSettings = {
        {"SkipChaptersWordList",  QVariant(QStringLiteral())},
        {"ShowOsdOnSkipChapters", QVariant(true)},
        {"SkipChapters",          QVariant(false)},
        {"YtdlFormat",            QVariant(QStringLiteral())},
    };
}

bool PlaybackSettings::skipChapters()
{
    return get("SkipChapters").toBool();
}

void PlaybackSettings::setSkipChapters(bool skip)
{
    if (skip == skipChapters())
        return;
    set("SkipChapters", QVariant(skip).toString());
    emit skipChaptersChanged();
}

QString PlaybackSettings::chaptersToSkip()
{
    return get("SkipChaptersWordList").toString();
}

void PlaybackSettings::setChaptersToSkip(const QString &wordList)
{
    if (wordList == chaptersToSkip()) {
        return;
    }
    set("SkipChaptersWordList", wordList);
    emit chaptersToSkipChanged();
}

bool PlaybackSettings::showOsdOnSkipChapters()
{
    return get("ShowOsdOnSkipChapters").toBool();
}

void PlaybackSettings::setShowOsdOnSkipChapters(bool show)
{
    if (show == showOsdOnSkipChapters()) {
        return;
    }
    set("ShowOsdOnSkipChapters", QVariant(show).toString());
    emit showOsdOnSkipChaptersChanged();
}

QString PlaybackSettings::ytdlFormat()
{
    return get("YtdlFormat").toString();
}

void PlaybackSettings::setYtdlFormat(const QString &format)
{
    if (format == ytdlFormat()) {
        return;
    }
    set("YtdlFormat", format);
    emit ytdlFormatChanged();
}
