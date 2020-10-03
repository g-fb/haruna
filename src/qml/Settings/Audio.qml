/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import AudioSettings 1.0

Item {
    id: root

    property bool hasHelp: false
    property string helpFile: ""

    visible: false

    GridLayout {
        id: content

        width: parent.width
        columns: 2

        Label {
            text: qsTr("Preferred language")
            Layout.alignment: Qt.AlignRight
        }
        TextField {
            text: AudioSettings.preferredLanguage
            placeholderText: "eng, ger etc."
            Layout.fillWidth: true
            onTextEdited: {
                AudioSettings.preferredLanguage = text
                mpv.setProperty("alang", text)
            }
        }


        Label {
            text: qsTr("Preferred track")
            Layout.alignment: Qt.AlignRight
        }
        SpinBox {
            from: 0
            to: 100
            value: AudioSettings.preferredTrack
            editable: true
            onValueChanged: {
                if (value === 0) {
                    AudioSettings.preferredTrack = value
                    mpv.setProperty("aid", "auto")
                    return
                }

                AudioSettings.preferredTrack = value
                mpv.setProperty("aid", value)
            }
        }
    }
}
