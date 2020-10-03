/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "mousesettings.h"
#include "../_debug.h"

#include <KConfig>
#include <KConfigGroup>
#include <QVariant>

MouseSettings::MouseSettings(QObject *parent)
    : Settings(parent)
{
    CONFIG_GROUP = QStringLiteral("Mouse");
    m_defaultSettings = {
        {"Left",                  QVariant(QStringLiteral())},
        {"Left.x2",               QVariant(QStringLiteral("toggleFullscreenAction"))},
        {"Middle",                QVariant(QStringLiteral("muteAction"))},
        {"Middle.x2",             QVariant(QStringLiteral("configureAction"))},
        {"Right",                 QVariant(QStringLiteral("playPauseAction"))},
        {"Right.x2",              QVariant(QStringLiteral())},
        {"ScrollUp",              QVariant(QStringLiteral("volumeUpAction"))},
        {"ScrollDown",            QVariant(QStringLiteral("volumeDownAction"))}
    };
}

QString MouseSettings::leftAction()
{
    return get("Left").toString();
}

void MouseSettings::setLeftAction(const QString &action)
{
    if (action == leftAction()) {
        return;
    }
    set("Left", action);
    emit leftActionChanged();
}

QString MouseSettings::leftx2Action()
{
    return get("Left.x2").toString();
}

void MouseSettings::setLeftx2Action(const QString &action)
{
    if (action == leftx2Action()) {
        return;
    }
    set("Left.x2", action);
    emit leftx2ActionChanged();
}

QString MouseSettings::rightAction()
{
    return get("Right").toString();
}

void MouseSettings::setRightAction(const QString &action)
{
    if (action == rightAction()) {
        return;
    }
    set("Right", action);
    emit rightActionChanged();
}

QString MouseSettings::rightx2Action()
{
    return get("Right.x2").toString();
}

void MouseSettings::setRightx2Action(const QString &action)
{
    if (action == rightx2Action()) {
        return;
    }
    set("Right.x2", action);
    emit rightx2ActionChanged();
}

QString MouseSettings::middleAction()
{
    return get("Middle").toString();
}

void MouseSettings::setMiddleAction(const QString &action)
{
    if (action == middleAction()) {
        return;
    }
    set("Middle", action);
    emit middleActionChanged();
}

QString MouseSettings::middlex2Action()
{
    return get("Middle.x2").toString();
}

void MouseSettings::setMiddlex2Action(const QString &action)
{
    if (action == middlex2Action()) {
        return;
    }
    set("Middle.x2", action);
    emit middlex2ActionChanged();
}

QString MouseSettings::scrollUpAction()
{
    return get("ScrollUp").toString();
}

void MouseSettings::setScrollUpAction(const QString &action)
{
    if (&action == scrollUpAction()) {
        return;
    }
    set("ScrollUp", action);
    emit scrollUpActionChanged();
}

QString MouseSettings::scrollDownAction()
{
    return get("ScrollDown").toString();
}

void MouseSettings::setScrollDownAction(const QString &action)
{
    if (action == scrollDownAction()) {
        return;
    }
    set("ScrollDown", action);
    emit scrollDownActionChanged();
}
