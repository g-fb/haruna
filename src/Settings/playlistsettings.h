/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef PLAYLISTSETTINGS_H
#define PLAYLISTSETTINGS_H

#include "settings.h"

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

    Q_PROPERTY(bool repeat
               READ repeat
               WRITE setRepeat
               NOTIFY repeatChanged)

    Q_PROPERTY(bool loadSiblings
               READ loadSiblings
               WRITE setLoadSiblings
               NOTIFY loadSiblingsChanged)

public:
    explicit PlaylistSettings(QObject *parent = nullptr);

    QString position();
    void setPosition(const QString &value);

    int rowHeight();
    void setRowHeight(int value);

    bool showRowNumber();
    void setShowRowNumber(bool value);

    bool canToggleWithMouse();
    void setCanToggleWithMouse(bool value);

    bool bigFontFullscreen();
    void setBigFontFullscreen(bool value);

    bool repeat();
    void setRepeat(bool value);

    bool loadSiblings();
    void setLoadSiblings(bool value);

    static QObject *provider(QQmlEngine *engine, QJSEngine *scriptEngine)
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
    void repeatChanged();
    void loadSiblingsChanged();

};

#endif // PLAYLISTSETTINGS_H
