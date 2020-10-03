/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

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
