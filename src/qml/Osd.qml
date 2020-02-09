/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.13
import QtQuick.Controls 2.13

Item {
    id: root

    property alias label: label

    Label {
        id: label
        x: mpv.x + 10
        y: mpv.y + 10
        visible: false
        background: Rectangle {
            color: systemPalette.base
        }
        padding: 5
        font.pixelSize: parseInt(settings.get("General", "OsdFontSize"))
    }

    Timer {
        id: timer
        running: false
        repeat: false
        interval: 3000

        onTriggered: {
            label.visible = false
        }
    }

    function message(text) {
        var osdFontSize = parseInt(settings.get("General", "OsdFontSize"))
        label.text = text
        if (osdFontSize === 0) {
            return;
        }

        if(label.visible) {
            timer.restart()
        } else {
            timer.start()
        }
        label.visible = true
    }

}
