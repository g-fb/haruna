/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import com.georgefb.haruna 1.0

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
            text: qsTr("Position")
            Layout.alignment: Qt.AlignRight
        }

        ComboBox {
            textRole: "key"
            Layout.fillWidth: true
            model: ListModel {
                ListElement { key: "Left"; value: "left" }
                ListElement { key: "Right"; value: "right" }
            }
            Component.onCompleted: {
                for (let i = 0; i < model.count; ++i) {
                    if (model.get(i).value === PlaylistSettings.position) {
                        currentIndex = i
                        break
                    }
                }
            }
            onActivated: {
                PlaylistSettings.position = model.get(index).value
                playList.position = model.get(index).value
            }
        }

        Label {
            text: qsTr("Row Height")
            Layout.alignment: Qt.AlignRight
        }

        SpinBox {
            from: 0
            to: 100
            value: PlaylistSettings.rowHeight
            onValueChanged: {
                PlaylistSettings.rowHeight = value
                playList.rowHeight = value
                playList.playlistView.forceLayout()
            }
        }

        CheckBox {
            checked: PlaylistSettings.showMediaTitle
            text: qsTr("Show media title instead of file name")
            Layout.columnSpan: 2
            onCheckStateChanged: PlaylistSettings.showMediaTitle = checked
        }

        CheckBox {
            checked: PlaylistSettings.loadSiblings
            text: qsTr("Auto load videos from same folder")
            Layout.columnSpan: 2
            onCheckStateChanged: PlaylistSettings.loadSiblings = checked
        }

        CheckBox {
            checked: PlaylistSettings.repeat
            text: qsTr("Repeat")
            Layout.columnSpan: 2
            onCheckStateChanged: PlaylistSettings.repeat = checked
        }

        CheckBox {
            checked: PlaylistSettings.showRowNumber
            text: qsTr("Show row number")
            Layout.columnSpan: 2
            onCheckStateChanged: PlaylistSettings.showRowNumber = checked
        }

        CheckBox {
            checked: PlaylistSettings.canToggleWithMouse
            text: qsTr("Toggle with mouse")
            Layout.columnSpan: 2
            onCheckStateChanged: {
                PlaylistSettings.canToggleWithMouse = checked
                playList.canToggleWithMouse = checked
            }
        }

        CheckBox {
            text: qsTr("Increase font size when fullscreen")
            checked: PlaylistSettings.bigFontFullscreen
            Layout.columnSpan: 2
            onCheckStateChanged: {
                PlaylistSettings.bigFontFullscreen = checked
                playList.bigFont = checked
                playList.playlistView.forceLayout()
            }
        }

    }
}
