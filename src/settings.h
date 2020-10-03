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
    //   GENERAL
    // *********************************************
    Q_PROPERTY(int osdFontSize
               READ osdFontSize
               WRITE setOsdFontSize
               NOTIFY osdFontSizeChanged)

    Q_PROPERTY(int volumeStep
               READ volumeStep
               WRITE setVolumeStep
               NOTIFY volumeStepChanged)

    Q_PROPERTY(int seekSmallStep
               READ seekSmallStep
               WRITE setSeekSmallStep
               NOTIFY seekSmallStepChanged)

    Q_PROPERTY(int seekMediumStep
               READ seekMediumStep
               WRITE setSeekMediumStep
               NOTIFY seekMediumStepChanged)

    Q_PROPERTY(int seekBigStep
               READ seekBigStep
               WRITE setSeekBigStep
               NOTIFY seekBigStepChanged)

    // no gui settings
    Q_PROPERTY(int volume
               READ volume
               WRITE setVolume
               NOTIFY volumeChanged)

    Q_PROPERTY(QString lastPlayedFile
               READ lastPlayedFile
               WRITE setLastPlayedFile
               NOTIFY lastPlayedFileChanged)

    Q_PROPERTY(QString lastUrl
               READ lastUrl
               WRITE setLastUrl
               NOTIFY lastUrlChanged)

    // *********************************************
    //   AUDIO
    // *********************************************
    Q_PROPERTY(QString audioPreferredLanguage
               READ audioPreferredLanguage
               WRITE setAudioPreferredLanguage
               NOTIFY audioPreferredLanguageChanged)

    Q_PROPERTY(int audioPreferredTrack
               READ audioPreferredTrack
               WRITE setAudioPreferredTrack
               NOTIFY audioPreferredTrackChanged)

    // *********************************************
    //   SUBTITLES
    // *********************************************
    Q_PROPERTY(QStringList subtitlesFolders
               READ subtitlesFolders
               WRITE setSubtitlesFolders
               NOTIFY subtitlesFoldersChanged)

    Q_PROPERTY(QString subtitlesPreferredLanguage
               READ subtitlesPreferredLanguage
               WRITE setSubtitlesPreferredLanguage
               NOTIFY subtitlesPreferredLanguageChanged)

    Q_PROPERTY(int subtitlesPreferredTrack
               READ subtitlesPreferredTrack
               WRITE setSubtitlesPreferredTrack
               NOTIFY subtitlesPreferredTrackChanged)

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

    // *********************************************
    //   VIEW
    // *********************************************
    Q_PROPERTY(bool viewIsMenuBarVisible
               READ viewIsMenuBarVisible
               WRITE setViewIsMenuBarVisible
               NOTIFY viewIsMenuBarVisibleChanged)

    Q_PROPERTY(bool viewIsHeaderVisible
               READ viewIsHeaderVisible
               WRITE setViewIsHeaderVisible
               NOTIFY viewIsHeaderVisibleChanged)


public:
    explicit Settings(QObject *parent = nullptr);

    // *********************************************
    //   GENERAL
    // *********************************************
    int osdFontSize();
    void setOsdFontSize(int fontSize);

    int volumeStep();
    void setVolumeStep(int step);

    int seekSmallStep();
    void setSeekSmallStep(int step);

    int seekMediumStep();
    void setSeekMediumStep(int step);

    int seekBigStep();
    void setSeekBigStep(int step);

    int volume();
    void setVolume(int vol);

    QString lastPlayedFile();
    void setLastPlayedFile(const QString &file);

    QString lastUrl();
    void setLastUrl(const QString &url);

    // *********************************************
    //   AUDIO
    // *********************************************
    QString audioPreferredLanguage();
    void setAudioPreferredLanguage(const QString &lang);

    int audioPreferredTrack();
    void setAudioPreferredTrack(int track);

    // *********************************************
    //   SUBTITLES
    // *********************************************
    QStringList subtitlesFolders();
    void setSubtitlesFolders(const QStringList &folders);

    QString subtitlesPreferredLanguage();
    void setSubtitlesPreferredLanguage(const QString &preferredLanguage);

    int subtitlesPreferredTrack();
    void setSubtitlesPreferredTrack(int preferredTrack);

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

    // *********************************************
    //   VIEW
    // *********************************************
    bool viewIsMenuBarVisible();
    void setViewIsMenuBarVisible(bool isVisible);

    bool viewIsHeaderVisible();
    void setViewIsHeaderVisible(bool isVisible);

    static QObject *provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        return new Settings();
    }

signals:
    void settingsChanged();
    // *********************************************
    //   GENERAL
    // *********************************************
    void osdFontSizeChanged();
    void volumeStepChanged();
    void seekSmallStepChanged();
    void seekMediumStepChanged();
    void seekBigStepChanged();
    void volumeChanged();
    void lastPlayedFileChanged();
    void lastUrlChanged();
    // *********************************************
    //   AUDIO
    // *********************************************
    void audioPreferredLanguageChanged();
    void audioPreferredTrackChanged();
    // *********************************************
    //   SUBTITLES
    // *********************************************
    void subtitlesFoldersChanged();
    void subtitlesPreferredLanguageChanged();
    void subtitlesPreferredTrackChanged();
    // *********************************************
    //   PLAYBACK
    // *********************************************
    void playbackSkipChaptersChanged();
    void playbackChaptersToSkipChanged();
    void playbackShowOsdOnSkipChaptersChanged();
    void playbackYtdlFormatChanged();
    // *********************************************
    //   VIEW
    // *********************************************
    void viewIsMenuBarVisibleChanged();
    void viewIsHeaderVisibleChanged();

public slots:
    QVariant get(const QString &group, const QString &key);
    void set(const QString &group, const QString &key, const QString &value);
protected:
    QHash<QString, QVariant> m_defaultSettings;
    KSharedConfig::Ptr m_config;
};

#endif // SETTINGS_H
