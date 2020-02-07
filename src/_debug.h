/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef __DEBUG_H
#define __DEBUG_H

#include <QDebug>

#define DEBUG qDebug() << Q_FUNC_INFO << ':'

#endif

