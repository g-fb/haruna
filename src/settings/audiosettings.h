/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef AUDIOSETTINGS_H
#define AUDIOSETTINGS_H

#include "settings.h"

class AudioSettings : public Settings
{
    Q_OBJECT
    Q_PROPERTY(QString preferredLanguage
               READ preferredLanguage
               WRITE setPreferredLanguage
               NOTIFY preferredLanguageChanged)

    Q_PROPERTY(int preferredTrack
               READ preferredTrack
               WRITE setPreferredTrack
               NOTIFY preferredTrackChanged)

public:
    explicit AudioSettings(QObject *parent = nullptr);

    QString preferredLanguage();
    void setPreferredLanguage(const QString &lang);

    int preferredTrack();
    void setPreferredTrack(int track);

    static QObject *provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        return new AudioSettings();
    }

signals:
    void preferredLanguageChanged();
    void preferredTrackChanged();

};

#endif // AUDIOSETTINGS_H
