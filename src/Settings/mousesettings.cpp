#include "mousesettings.h"
#include "../_debug.h"

#include <KConfig>
#include <KConfigGroup>
#include <QVariant>

MouseSettings::MouseSettings(QObject *parent)
    : Settings(parent)
{
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
    return get("Mouse", "Left").toString();
}

void MouseSettings::setLeftAction(const QString &action)
{
    if (action == leftAction()) {
        return;
    }
    set("Mouse", "Left", action);
    emit leftActionChanged();
}

QString MouseSettings::leftx2Action()
{
    return get("Mouse", "Left.x2").toString();
}

void MouseSettings::setLeftx2Action(const QString &action)
{
    if (action == leftx2Action()) {
        return;
    }
    set("Mouse", "Left.x2", action);
    emit leftx2ActionChanged();
}

QString MouseSettings::rightAction()
{
    return get("Mouse", "Right").toString();
}

void MouseSettings::setRightAction(const QString &action)
{
    if (action == rightAction()) {
        return;
    }
    set("Mouse", "Right", action);
    emit rightActionChanged();
}

QString MouseSettings::rightx2Action()
{
    return get("Mouse", "Right.x2").toString();
}

void MouseSettings::setRightx2Action(const QString &action)
{
    if (action == rightx2Action()) {
        return;
    }
    set("Mouse", "Right.x2", action);
    emit rightx2ActionChanged();
}

QString MouseSettings::middleAction()
{
    return get("Mouse", "Middle").toString();
}

void MouseSettings::setMiddleAction(const QString &action)
{
    if (action == middleAction()) {
        return;
    }
    set("Mouse", "Middle", action);
    emit middleActionChanged();
}

QString MouseSettings::middlex2Action()
{
    return get("Mouse", "Middle.x2").toString();
}

void MouseSettings::setMiddlex2Action(const QString &action)
{
    if (action == middlex2Action()) {
        return;
    }
    set("Mouse", "Middle.x2", action);
    emit middlex2ActionChanged();
}

QString MouseSettings::scrollUpAction()
{
    return get("Mouse", "ScrollUp").toString();
}

void MouseSettings::setScrollUpAction(const QString &action)
{
    if (&action == scrollUpAction()) {
        return;
    }
    set("Mouse", "ScrollUp", action);
    emit scrollUpActionChanged();
}

QString MouseSettings::scrollDownAction()
{
    return get("Mouse", "ScrollDown").toString();
}

void MouseSettings::setScrollDownAction(const QString &action)
{
    if (action == scrollDownAction()) {
        return;
    }
    set("Mouse", "ScrollDown", action);
    emit scrollDownActionChanged();
}
