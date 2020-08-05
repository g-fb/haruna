#include "haction.h"

#include <QKeySequence>

HAction::HAction(QObject *parent) : QAction(parent)
{

}

QString HAction::shortcutName()
{
    return shortcut().toString();
}

QString HAction::iconName()
{
    return icon().name();
}
