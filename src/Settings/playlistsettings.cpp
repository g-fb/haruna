#include "playlistsettings.h"

PlaylistSettings::PlaylistSettings(QObject *parent)
    : Settings(parent)
{
    CONFIG_GROUP = QStringLiteral("Playlist");
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
    return get("Position").toString();
}

void PlaylistSettings::setPosition(const QString &pos)
{
    if (pos == position()) {
        return;
    }
    set("Position", pos);
    emit positionChanged();
}

int PlaylistSettings::rowHeight()
{
    return get("RowHeight").toInt();
}

void PlaylistSettings::setRowHeight(int height)
{
    if (height == rowHeight()) {
        return;
    }
    set("RowHeight", QString::number(height));
    emit rowHeightChanged();
}

bool PlaylistSettings::showRowNumber()
{
    return get("ShowRowNumber").toBool();
}

void PlaylistSettings::setShowRowNumber(bool show)
{
    if (show == showRowNumber()) {
        return;
    }
    set("ShowRowNumber", QVariant(show).toString());
    emit showRowNumberChanged();
}

bool PlaylistSettings::canToggleWithMouse()
{
    return get("CanToggleWithMouse").toBool();
}

void PlaylistSettings::setCanToggleWithMouse(bool toggleWithMouse)
{
    if (toggleWithMouse == canToggleWithMouse()) {
        return;
    }
    set("CanToggleWithMouse", QVariant(toggleWithMouse).toString());
    emit canToggleWithMouseChanged();
}

bool PlaylistSettings::bigFontFullscreen()
{
    return get("BigFontFullscreen").toBool();
}

void PlaylistSettings::setBigFontFullscreen(bool bigFont)
{
    if (bigFont == bigFontFullscreen()) {
        return;
    }
    set("BigFontFullscreen", QVariant(bigFont).toString());
    emit bigFontFullscreenChanged();
}
