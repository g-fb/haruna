/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.13
import QtQuick.Controls 2.13

Menu {
    id: root

    title: qsTr("&File")

    MenuItem { action: actions["openAction"] }
    MenuItem { action: actions["openUrlAction"] }

    MenuSeparator {}

    MenuItem { action: actions["quitApplicationAction"] }
}
