/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import org.kde.kirigami 2.11 as Kirigami
import com.georgefb.haruna 1.0

import "../Components"

SettingsFlickable {
    id: root

    property bool hasHelp: false
    property string helpFile: ""

    visible: false
    contentHeight: content.implicitHeight

    GridLayout {
        id: content

        anchors.fill: parent
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
            text: SubtitlesSettings.preferredLanguage
            placeholderText: "eng, ger etc."
            Layout.fillWidth: true
            onTextEdited: {
                SubtitlesSettings.preferredLanguage = text
                SubtitlesSettings.save()
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
            value: SubtitlesSettings.preferredTrack
            editable: true
            onValueChanged: {
                SubtitlesSettings.preferredTrack = value
                SubtitlesSettings.save()
                if (value === 0) {
                    mpv.setProperty("sid", "auto")
                } else {
                    mpv.setProperty("sid", value)
                }
            }
        }

        Item {
            width: Kirigami.Units.gridUnit
            height: Kirigami.Units.gridUnit
        }
    }
}
