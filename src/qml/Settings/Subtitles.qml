/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

Item {
    id: root

    property alias contentHeight: content.height

    visible: false

    GridLayout {
        id: content

        width: parent.width
        columns: 2

        SubtitlesFolders {
            id: subtitleFolders
            implicitWidth: root.width
            Layout.fillWidth: true
            Layout.columnSpan: 2
        }

        Label {
            text: qsTr("Preferred language")
            Layout.alignment: Qt.AlignRight
        }
        TextField {
            text: settings.get("Subtitle", "PreferredLanguage")
            placeholderText: "eng, ger etc."
            Layout.fillWidth: true
            onTextEdited: {
                settings.set("Subtitle", "PreferredLanguage", text)
                mpv.setProperty("slang", text)
            }
        }

        Label {
            text: qsTr("Preferred track")
            Layout.alignment: Qt.AlignRight
        }
        SpinBox {
            from: 0
            to: 100
            value: settings.get("Subtitle", "PreferredTrack")
            editable: true
            onValueChanged: {
                if (value === 0) {
                    settings.set("Subtitle", "PreferredTrack", value)
                    mpv.setProperty("sid", "auto")
                    return
                }

                settings.set("Subtitle", "PreferredTrack", value)
                mpv.setProperty("sid", value)
            }
        }
    }
}
