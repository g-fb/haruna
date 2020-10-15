/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef SUBTITLESSETTINGS_H
#define SUBTITLESSETTINGS_H

#include "settings.h"

class SubtitlesSettings : public Settings
{
    Q_OBJECT
    Q_PROPERTY(QStringList subtitlesFolders
               READ subtitlesFolders
               WRITE setSubtitlesFolders
               NOTIFY subtitlesFoldersChanged)

    Q_PROPERTY(QString preferredLanguage
               READ preferredLanguage
               WRITE setPreferredLanguage
               NOTIFY preferredLanguageChanged)

    Q_PROPERTY(int preferredTrack
               READ preferredTrack
               WRITE setPreferredTrack
               NOTIFY preferredTrackChanged)

public:
    explicit SubtitlesSettings(QObject *parent = nullptr);

    QStringList subtitlesFolders();
    void setSubtitlesFolders(const QStringList &folders);

    QString preferredLanguage();
    void setPreferredLanguage(const QString &language);

    int preferredTrack();
    void setPreferredTrack(int track);

    static QObject *provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        return new SubtitlesSettings();
    }

signals:
    void subtitlesFoldersChanged();
    void preferredLanguageChanged();
    void preferredTrackChanged();

};

#endif // SUBTITLESSETTINGS_H
