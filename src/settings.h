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

    Q_PROPERTY(QString subtitlesFolders
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

    Q_PROPERTY(bool playlistCanToggleWithMouse
               READ playlistCanToggleWithMouse
               WRITE setPlaylistCanToggleWithMouse
               NOTIFY playlistCanToggleWithMouseChanged)

    Q_PROPERTY(bool playlistBigFontFullscreen
               READ playlistBigFontFullscreen
               WRITE setPlaylistBigFontFullscreen
               NOTIFY playlistBigFontFullscreenChanged)

    Q_PROPERTY(QString mouseLeftAction
               READ mouseLeftAction
               WRITE setMouseLeftAction
               NOTIFY mouseLeftActionChanged)

    Q_PROPERTY(QString mouseLeftx2Action
               READ mouseLeftx2Action
               WRITE setMouseLeftx2Action
               NOTIFY mouseLeftx2ActionChanged)

    Q_PROPERTY(QString mouseRightAction
               READ mouseRightAction
               WRITE setMouseRightAction
               NOTIFY mouseRightActionChanged)

    Q_PROPERTY(QString mouseRightx2Action
               READ mouseRightx2Action
               WRITE setMouseRightx2Action
               NOTIFY mouseRightx2ActionChanged)

    Q_PROPERTY(QString mouseMiddleAction
               READ mouseMiddleAction
               WRITE setMouseMiddleAction
               NOTIFY mouseMiddleActionChanged)

    Q_PROPERTY(QString mouseMiddlex2Action
               READ mouseMiddlex2Action
               WRITE setMouseMiddlex2Action
               NOTIFY mouseMiddlex2ActionChanged)

    Q_PROPERTY(QString mouseScrollUpAction
               READ mouseScrollUpAction
               WRITE setMouseScrollUpAction
               NOTIFY mouseScrollUpActionChanged)

    Q_PROPERTY(QString mouseScrollDownAction
               READ mouseScrollDownAction
               WRITE setMouseScrollDownAction
               NOTIFY mouseScrollDownActionChanged)

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
    void setSkipChaptersWordList(const QString &wordList);

    bool showOsdOnSkipChapters();
    void setShowOsdOnSkipChapters(bool show);

    int volumeStep();
    void setVolumeStep(int step);

    int osdFontSize();
    void setOsdFontSize(int fontSize);

    QString audioPreferredLanguage();
    void setAudioPreferredLanguage(const QString &lang);

    int audioPreferredTrack();
    void setAudioPreferredTrack(int track);

    QString subtitlesFolders();
    void setSubtitlesFolders(const QString &folders);

    QString subtitlesPreferredLanguage();
    void setSubtitlesPreferredLanguage(const QString &preferredLanguage);

    int subtitlesPreferredTrack();
    void setSubtitlesPreferredTrack(int preferredTrack);

    QString playlistPosition();
    void setPlaylistPosition(const QString &position);

    int playlistRowHeight();
    void setPlaylistRowHeight(int height);

    int playlistRowSpacing();
    void setPlaylistRowSpacing(int spacing);

    bool playlistCanToggleWithMouse();
    void setPlaylistCanToggleWithMouse(bool toggleWithMouse);

    bool playlistBigFontFullscreen();
    void setPlaylistBigFontFullscreen(bool bigFont);

    QString mouseLeftAction();
    void setMouseLeftAction(const QString &action);

    QString mouseLeftx2Action();
    void setMouseLeftx2Action(const QString &action);

    QString mouseRightAction();
    void setMouseRightAction(const QString &action);

    QString mouseRightx2Action();
    void setMouseRightx2Action(const QString &action);

    QString mouseMiddleAction();
    void setMouseMiddleAction(const QString &action);

    QString mouseMiddlex2Action();
    void setMouseMiddlex2Action(const QString &action);

    QString mouseScrollUpAction();
    void setMouseScrollUpAction(const QString &action);

    QString mouseScrollDownAction();
    void setMouseScrollDownAction(const QString &action);

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
    void subtitlesFoldersChanged();
    void subtitlesPreferredLanguageChanged();
    void subtitlesPreferredTrackChanged();
    void playlistPositionChanged();
    void playlistRowHeightChanged();
    void playlistRowSpacingChanged();
    void playlistCanToggleWithMouseChanged();
    void playlistBigFontFullscreenChanged();
    void mouseLeftActionChanged();
    void mouseLeftx2ActionChanged();
    void mouseRightActionChanged();
    void mouseRightx2ActionChanged();
    void mouseMiddleActionChanged();
    void mouseMiddlex2ActionChanged();
    void mouseScrollUpActionChanged();
    void mouseScrollDownActionChanged();

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
