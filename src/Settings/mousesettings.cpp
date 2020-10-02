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

QString MouseSettings::mouseLeftAction()
{
    return get("Mouse", "Left").toString();
}

void MouseSettings::setMouseLeftAction(const QString &action)
{
    if (action == mouseLeftAction()) {
        return;
    }
    set("Mouse", "Left", action);
    emit mouseLeftActionChanged();
}

QString MouseSettings::mouseLeftx2Action()
{
    return get("Mouse", "Left.x2").toString();
}

void MouseSettings::setMouseLeftx2Action(const QString &action)
{
    if (action == mouseLeftx2Action()) {
        return;
    }
    set("Mouse", "Left.x2", action);
    emit mouseLeftx2ActionChanged();
}

QString MouseSettings::mouseRightAction()
{
    return get("Mouse", "Right").toString();
}

void MouseSettings::setMouseRightAction(const QString &action)
{
    if (action == mouseRightAction()) {
        return;
    }
    set("Mouse", "Right", action);
    emit mouseRightActionChanged();
}

QString MouseSettings::mouseRightx2Action()
{
    return get("Mouse", "Right.x2").toString();
}

void MouseSettings::setMouseRightx2Action(const QString &action)
{
    if (action == mouseRightx2Action()) {
        return;
    }
    set("Mouse", "Right.x2", action);
    emit mouseRightx2ActionChanged();
}

QString MouseSettings::mouseMiddleAction()
{
    return get("Mouse", "Middle").toString();
}

void MouseSettings::setMouseMiddleAction(const QString &action)
{
    if (action == mouseMiddleAction()) {
        return;
    }
    set("Mouse", "Middle", action);
    emit mouseMiddleActionChanged();
}

QString MouseSettings::mouseMiddlex2Action()
{
    return get("Mouse", "Middle.x2").toString();
}

void MouseSettings::setMouseMiddlex2Action(const QString &action)
{
    if (action == mouseMiddlex2Action()) {
        return;
    }
    set("Mouse", "Middle.x2", action);
    emit mouseMiddlex2ActionChanged();
}

QString MouseSettings::mouseScrollUpAction()
{
    return get("Mouse", "ScrollUp").toString();
}

void MouseSettings::setMouseScrollUpAction(const QString &action)
{
    if (&action == mouseScrollUpAction()) {
        return;
    }
    set("Mouse", "ScrollUp", action);
    emit mouseScrollUpActionChanged();
}

QString MouseSettings::mouseScrollDownAction()
{
    return get("Mouse", "ScrollDown").toString();
}

void MouseSettings::setMouseScrollDownAction(const QString &action)
{
    if (action == mouseScrollDownAction()) {
        return;
    }
    set("Mouse", "ScrollDown", action);
    emit mouseScrollDownActionChanged();
}
