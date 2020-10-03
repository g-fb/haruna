#include "playlistsettings.h"

PlaylistSettings::PlaylistSettings(QObject *parent)
    : Settings(parent)
{
    m_defaultSettings = {
        {"CanToggleWithMouse", QVariant(true)},
        {"ShowRowNumber",      QVariant(true)},
        {"Position",           QVariant(QStringLiteral("right"))},
        {"RowHeight",          QVariant(10)},
        {"BigFontFullscreen",  QVariant(true)},
    };
}

QString PlaylistSettings::position()
{
    return get("Playlist", "Position").toString();
}

void PlaylistSettings::setPosition(const QString &pos)
{
    if (pos == position()) {
        return;
    }
    set("Playlist", "Position", pos);
    emit positionChanged();
}

int PlaylistSettings::rowHeight()
{
    return get("Playlist", "RowHeight").toInt();
}

void PlaylistSettings::setRowHeight(int height)
{
    if (height == rowHeight()) {
        return;
    }
    set("Playlist", "RowHeight", QString::number(height));
    emit rowHeightChanged();
}

bool PlaylistSettings::showRowNumber()
{
    return get("Playlist", "ShowRowNumber").toBool();
}

void PlaylistSettings::setShowRowNumber(bool show)
{
    if (show == showRowNumber()) {
        return;
    }
    set("Playlist", "ShowRowNumber", QVariant(show).toString());
    emit showRowNumberChanged();
}

bool PlaylistSettings::canToggleWithMouse()
{
    return get("Playlist", "CanToggleWithMouse").toBool();
}

void PlaylistSettings::setCanToggleWithMouse(bool toggleWithMouse)
{
    if (toggleWithMouse == canToggleWithMouse()) {
        return;
    }
    set("Playlist", "CanToggleWithMouse", QVariant(toggleWithMouse).toString());
    emit canToggleWithMouseChanged();
}

bool PlaylistSettings::bigFontFullscreen()
{
    return get("Playlist", "BigFontFullscreen").toBool();
}

void PlaylistSettings::setBigFontFullscreen(bool bigFont)
{
    if (bigFont == bigFontFullscreen()) {
        return;
    }
    set("Playlist", "BigFontFullscreen", QVariant(bigFont).toString());
    emit bigFontFullscreenChanged();
}
