#include "subtitlessettings.h"

#include <KConfigGroup>

SubtitlesSettings::SubtitlesSettings(QObject *parent)
    : Settings(parent)
{
    CONFIG_GROUP = QStringLiteral("Subtitles");
    m_defaultSettings = {
        {"SubtitlesFolders",  QVariant(QStringLiteral("subs"))},
        {"PreferredLanguage", QVariant(QStringLiteral())},
        {"PreferredTrack",    QVariant(0)}
    };
}

QStringList SubtitlesSettings::subtitlesFolders()
{
    return m_config->group("Subtitles").readPathEntry("Folders", QStringList());
}

void SubtitlesSettings::setSubtitlesFolders(const QStringList &folders)
{
    if (folders == subtitlesFolders()) {
        return;
    }
    m_config->group("Subtitles").writePathEntry("Folders", folders);
    m_config->sync();
    emit subtitlesFoldersChanged();
}

QString SubtitlesSettings::preferredLanguage()
{
    return get("PreferredLanguage").toString();
}

void SubtitlesSettings::setPreferredLanguage(const QString &language)
{
    if (language == preferredLanguage()) {
        return;
    }
    set("PreferredLanguage", language);
    emit preferredLanguageChanged();
}

int SubtitlesSettings::preferredTrack()
{
    return get("PreferredTrack").toInt();
}

void SubtitlesSettings::setPreferredTrack(int track)
{
    if (track == preferredTrack()) {
        return;
    }
    set("PreferredTrack", QString::number(track));
    emit preferredTrackChanged();
}
