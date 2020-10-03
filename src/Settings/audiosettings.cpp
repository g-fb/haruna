#include "audiosettings.h"

AudioSettings::AudioSettings(QObject *parent)
    : Settings(parent)
{
    CONFIG_GROUP = QStringLiteral("Audio");
    m_defaultSettings = {
        {"PreferredLanguage", QVariant(QStringLiteral())},
        {"PreferredTrack",    QVariant(0)}
    };
}

QString AudioSettings::preferredLanguage()
{
    return get("PreferredLanguage").toString();
}

void AudioSettings::setPreferredLanguage(const QString &lang)
{
    if (lang == preferredLanguage()) {
        return;
    }
    set("PreferredLanguage", lang);
    emit preferredLanguageChanged();
}

int AudioSettings::preferredTrack()
{
    return get("PreferredTrack").toInt();
}

void AudioSettings::setPreferredTrack(int track)
{
    if (track == preferredTrack()) {
        return;
    }
    set("PreferredTrack", QString::number(track));
    emit preferredTrackChanged();
}
