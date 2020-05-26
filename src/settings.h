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
    Q_PROPERTY(bool skipChapters
               READ skipChapters
               WRITE setSkipChapters
               NOTIFY skipChaptersChanged)

    Q_PROPERTY(QString skipChaptersWordList
               READ skipChaptersWordList
               WRITE setSkipChaptersWordList
               NOTIFY skipChaptersWordListChanged)

    Q_PROPERTY(bool showOsdOnSkipChapters
               READ showOsdOnSkipChapters
               WRITE setShowOsdOnSkipChapters
               NOTIFY showOsdOnSkipChaptersChanged)

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

    Q_PROPERTY(int volumeStep
               READ volumeStep
               WRITE setVolumeStep
               NOTIFY volumeStepChanged)

    Q_PROPERTY(int osdFontSize
               READ osdFontSize
               WRITE setOsdFontSize
               NOTIFY osdFontSizeChanged)

    Q_PROPERTY(QString audioPreferredLanguage
               READ audioPreferredLanguage
               WRITE setAudioPreferredLanguage
               NOTIFY audioPreferredLanguageChanged)

    Q_PROPERTY(int audioPreferredTrack
               READ audioPreferredTrack
               WRITE setAudioPreferredTrack
               NOTIFY audioPreferredTrackChanged)

    Q_PROPERTY(QString playlistPosition
               READ playlistPosition
               WRITE setPlaylistPosition
               NOTIFY playlistPositionChanged)

    Q_PROPERTY(int playlistRowHeight
               READ playlistRowHeight
               WRITE setPlaylistRowHeight
               NOTIFY playlistRowHeightChanged)

    Q_PROPERTY(int playlistRowSpacing
               READ playlistRowSpacing
               WRITE setPlaylistRowSpacing
               NOTIFY playlistRowSpacingChanged)

    Q_PROPERTY(bool playlistCanToogleWithMouse
               READ playlistCanToogleWithMouse
               WRITE setPlaylistCanToogleWithMouse
               NOTIFY playlistCanToogleWithMouseChanged)

    Q_PROPERTY(bool playlistBigFontFullscreen
               READ playlistBigFontFullscreen
               WRITE setPlaylistBigFontFullscreen
               NOTIFY playlistBigFontFullscreenChanged)

public:
    explicit Settings(QObject *parent = nullptr);

    int seekSmallStep();
    void setSeekSmallStep(int step);

    int seekMediumStep();
    void setSeekMediumStep(int step);

    int seekBigStep();
    void setSeekBigStep(int step);

    bool skipChapters();
    void setSkipChapters(bool skip);

    QString skipChaptersWordList();
    void setSkipChaptersWordList(QString wordList);

    bool showOsdOnSkipChapters();
    void setShowOsdOnSkipChapters(bool show);

    int volumeStep();
    void setVolumeStep(int step);

    int osdFontSize();
    void setOsdFontSize(int fontSize);

    QString audioPreferredLanguage();
    void setAudioPreferredLanguage(QString lang);

    int audioPreferredTrack();
    void setAudioPreferredTrack(int track);

    QString playlistPosition();
    void setPlaylistPosition(QString position);

    int playlistRowHeight();
    void setPlaylistRowHeight(int height);

    int playlistRowSpacing();
    void setPlaylistRowSpacing(int spacing);

    bool playlistCanToogleWithMouse();
    void setPlaylistCanToogleWithMouse(bool toggleWithMouse);

    bool playlistBigFontFullscreen();
    void setPlaylistBigFontFullscreen(bool bigFont);

    static QObject *provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        Settings *example = new Settings();
        return example;
    }

signals:
    void settingsChanged();
    void seekSmallStepChanged();
    void seekMediumStepChanged();
    void seekBigStepChanged();
    void skipChaptersChanged();
    void skipChaptersWordListChanged();
    void showOsdOnSkipChaptersChanged();
    void volumeStepChanged();
    void osdFontSizeChanged();
    void brightnessChanged();
    void gammaChanged();
    void saturationChanged();
    void audioPreferredLanguageChanged();
    void audioPreferredTrackChanged();
    void playlistPositionChanged();
    void playlistRowHeightChanged();
    void playlistRowSpacingChanged();
    void playlistCanToogleWithMouseChanged();
    void playlistBigFontFullscreenChanged();

public slots:
    QVariant get(const QString &group, const QString &key);
    void set(const QString &group, const QString &key, const QString &value);
    QVariant getPath(const QString &group, const QString &key);
    void setPath(const QString &group, const QString &key, const QString &value);
private:
    QVariant defaultSetting(const QString &key);
    QHash<QString, QVariant> m_defaultSettings;
    KSharedConfig::Ptr m_config;
};

#endif // SETTINGS_H
