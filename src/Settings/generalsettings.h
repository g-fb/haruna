#ifndef GENERALSETTINGS_H
#define GENERALSETTINGS_H

#include "settings.h"

class GeneralSettings : public Settings
{
    Q_OBJECT
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

    // toggle component visibility
    Q_PROPERTY(bool showMenuBar
               READ showMenuBar
               WRITE setShowMenuBar
               NOTIFY showMenuBarChanged)

    Q_PROPERTY(bool showHeader
               READ showHeader
               WRITE setShowHeader
               NOTIFY showHeaderChanged)

public:
    explicit GeneralSettings(QObject *parent = nullptr);

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

    bool showMenuBar();
    void setShowMenuBar(bool isVisible);

    bool showHeader();
    void setShowHeader(bool isVisible);

    static GeneralSettings *provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        return new GeneralSettings();
    }

signals:
    void osdFontSizeChanged();
    void volumeStepChanged();
    void seekSmallStepChanged();
    void seekMediumStepChanged();
    void seekBigStepChanged();
    void volumeChanged();
    void lastPlayedFileChanged();
    void lastUrlChanged();
    void showMenuBarChanged();
    void showHeaderChanged();

};

#endif // GENERALSETTINGS_H
