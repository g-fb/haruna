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
                id: leftButtonModel
                ListElement { key: "Left"; value: "left" }
                ListElement { key: "Right"; value: "right" }
            }
            Component.onCompleted: {
                for (let i = 0; i < model.count; ++i) {
                    if (model.get(i).value === AppSettings.playlistPosition) {
                        currentIndex = i
                        break
                    }
                }
            }
            onActivated: {
                AppSettings.playlistPosition = model.get(index).value
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
            value: AppSettings.playlistRowHeight
            onValueChanged: {
                AppSettings.playlistRowHeight = value
                playList.rowHeight = value
                playList.tableView.forceLayout()
            }
        }

        CheckBox {
            checked: AppSettings.playlistCanToggleWithMouse
            text: qsTr("Toggle with mouse")
            Layout.columnSpan: 2
            onCheckStateChanged: {
                AppSettings.playlistCanToggleWithMouse = checked
                playList.canToggleWithMouse = checked
            }
        }

        CheckBox {
            text: qsTr("Increase font size when fullscreen")
            checked: AppSettings.playlistBigFontFullscreen
            Layout.columnSpan: 2
            onCheckStateChanged: {
                AppSettings.playlistBigFontFullscreen = checked
                playList.bigFont = checked
                playList.tableView.forceLayout()
            }
        }

    }
}
