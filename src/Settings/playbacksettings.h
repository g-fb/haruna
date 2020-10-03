#ifndef PLAYBACKSETTINGS_H
#define PLAYBACKSETTINGS_H

#include "settings.h"

class PlaybackSettings : public Settings
{
    Q_OBJECT
    Q_PROPERTY(bool skipChapters
               READ skipChapters
               WRITE setSkipChapters
               NOTIFY skipChaptersChanged)

    Q_PROPERTY(QString chaptersToSkip
               READ chaptersToSkip
               WRITE setChaptersToSkip
               NOTIFY chaptersToSkipChanged)

    Q_PROPERTY(bool showOsdOnSkipChapters
               READ showOsdOnSkipChapters
               WRITE setShowOsdOnSkipChapters
               NOTIFY showOsdOnSkipChaptersChanged)

    Q_PROPERTY(QString ytdlFormat
               READ ytdlFormat
               WRITE setYtdlFormat
               NOTIFY ytdlFormatChanged)

public:
    explicit PlaybackSettings(QObject *parent = nullptr);

    bool skipChapters();
    void setSkipChapters(bool skip);

    QString chaptersToSkip();
    void setChaptersToSkip(const QString &chapters);

    bool showOsdOnSkipChapters();
    void setShowOsdOnSkipChapters(bool show);

    QString ytdlFormat();
    void setYtdlFormat(const QString &format);

    static PlaybackSettings *provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        return new PlaybackSettings();
    }

signals:
    void skipChaptersChanged();
    void chaptersToSkipChanged();
    void showOsdOnSkipChaptersChanged();
    void ytdlFormatChanged();

};

#endif // PLAYBACKSETTINGS_H
