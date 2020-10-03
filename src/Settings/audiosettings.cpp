#include "audiosettings.h"

AudioSettings::AudioSettings(QObject *parent)
    : Settings(parent)
{
    m_defaultSettings = {
        {"PreferredLanguage", QVariant(QStringLiteral())},
        {"PreferredTrack",    QVariant(0)}
    };
}

QString AudioSettings::preferredLanguage()
{
    return get("Audio", "PreferredLanguage").toString();
}

void AudioSettings::setPreferredLanguage(const QString &lang)
{
    if (lang == preferredLanguage()) {
        return;
    }
    set("Audio", "PreferredLanguage", lang);
    emit preferredLanguageChanged();
}

int AudioSettings::preferredTrack()
{
    return get("Audio", "PreferredTrack").toInt();
}

void AudioSettings::setPreferredTrack(int track)
{
    if (track == preferredTrack()) {
        return;
    }
    set("Audio", "PreferredTrack", QString::number(track));
    emit preferredTrackChanged();
}
