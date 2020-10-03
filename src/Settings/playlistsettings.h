#ifndef PLAYLISTSETTINGS_H
#define PLAYLISTSETTINGS_H

#include "../settings.h"

class PlaylistSettings : public Settings
{
    Q_OBJECT
    Q_PROPERTY(QString position
               READ position
               WRITE setPosition
               NOTIFY positionChanged)

    Q_PROPERTY(int rowHeight
               READ rowHeight
               WRITE setRowHeight
               NOTIFY rowHeightChanged)

    Q_PROPERTY(bool showRowNumber
               READ showRowNumber
               WRITE setShowRowNumber
               NOTIFY showRowNumberChanged)

    Q_PROPERTY(bool canToggleWithMouse
               READ canToggleWithMouse
               WRITE setCanToggleWithMouse
               NOTIFY canToggleWithMouseChanged)

    Q_PROPERTY(bool bigFontFullscreen
               READ bigFontFullscreen
               WRITE setBigFontFullscreen
               NOTIFY bigFontFullscreenChanged)

public:
    explicit PlaylistSettings(QObject *parent = nullptr);

    QString position();
    void setPosition(const QString &position);

    int rowHeight();
    void setRowHeight(int height);

    bool showRowNumber();
    void setShowRowNumber(bool showRowNumber);

    bool canToggleWithMouse();
    void setCanToggleWithMouse(bool toggleWithMouse);

    bool bigFontFullscreen();
    void setBigFontFullscreen(bool bigFont);

    static PlaylistSettings *provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        return new PlaylistSettings();
    }

signals:
    void positionChanged();
    void rowHeightChanged();
    void showRowNumberChanged();
    void canToggleWithMouseChanged();
    void bigFontFullscreenChanged();

};

#endif // PLAYLISTSETTINGS_H
