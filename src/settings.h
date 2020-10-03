/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QHash>
#include <KSharedConfig>
#include <QQmlEngine>

class Settings : public QObject
{
    Q_OBJECT
    // *********************************************
    //   PLAYBACK
    // *********************************************
    Q_PROPERTY(bool playbackSkipChapters
               READ playbackSkipChapters
               WRITE setPlaybackSkipChapters
               NOTIFY playbackSkipChaptersChanged)

    Q_PROPERTY(QString playbackChaptersToSkip
               READ playbackChaptersToSkip
               WRITE setPlaybackChaptersToSkip
               NOTIFY playbackChaptersToSkipChanged)

    Q_PROPERTY(bool playbackShowOsdOnSkipChapters
               READ playbackShowOsdOnSkipChapters
               WRITE setPlaybackShowOsdOnSkipChapters
               NOTIFY playbackShowOsdOnSkipChaptersChanged)

    Q_PROPERTY(QString playbackYtdlFormat
               READ playbackYtdlFormat
               WRITE setPlaybackYtdlFormat
               NOTIFY playbackYtdlFormatChanged)



public:
    explicit Settings(QObject *parent = nullptr);

    // *********************************************
    //   PLAYBACK
    // *********************************************
    bool playbackSkipChapters();
    void setPlaybackSkipChapters(bool skip);

    QString playbackChaptersToSkip();
    void setPlaybackChaptersToSkip(const QString &chapters);

    bool playbackShowOsdOnSkipChapters();
    void setPlaybackShowOsdOnSkipChapters(bool show);

    QString playbackYtdlFormat();
    void setPlaybackYtdlFormat(const QString &format);

    static QObject *provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        return new Settings();
    }

signals:
    void settingsChanged();
    // *********************************************
    //   PLAYBACK
    // *********************************************
    void playbackSkipChaptersChanged();
    void playbackChaptersToSkipChanged();
    void playbackShowOsdOnSkipChaptersChanged();
    void playbackYtdlFormatChanged();

public slots:
    QVariant get(const QString &group, const QString &key);
    void set(const QString &group, const QString &key, const QString &value);
protected:
    QHash<QString, QVariant> m_defaultSettings;
    KSharedConfig::Ptr m_config;
};

#endif // SETTINGS_H
