/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import AppSettings 1.0

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
            text: AppSettings.subtitlesPreferredLanguage
            placeholderText: "eng, ger etc."
            Layout.fillWidth: true
            onTextEdited: {
                AppSettings.subtitlesPreferredLanguage = text
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
            value: AppSettings.subtitlesPreferredTrack
            editable: true
            onValueChanged: {
                AppSettings.subtitlesPreferredTrack = value
                if (value === 0) {
                    mpv.setProperty("sid", "auto")
                } else {
                    mpv.setProperty("sid", value)
                }
            }
        }
    }
}
