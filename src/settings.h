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
