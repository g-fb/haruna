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
import Haruna.Components 1.0

SettingsBasePage {
    id: root

    hasHelp: false
    helpFile: ""

    GridLayout {
        id: content

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
                PlaylistSettings.save()
                playList.position = model.get(index).value
            }
        }

        Label {
            text: qsTr("Row height")
            Layout.alignment: Qt.AlignRight
        }

        SpinBox {
            from: 0
            to: 100
            value: PlaylistSettings.rowHeight
            onValueChanged: {
                PlaylistSettings.rowHeight = value
                PlaylistSettings.save()
                playList.rowHeight = value
                playList.playlistView.forceLayout()
            }
        }

        CheckBox {
            checked: PlaylistSettings.showThumbnails
            text: qsTr("Show thumbnails")
            Layout.columnSpan: 2
            onCheckStateChanged: {
                PlaylistSettings.showThumbnails = checked
                PlaylistSettings.save()
            }
        }

        CheckBox {
            checked: PlaylistSettings.showMediaTitle
            text: qsTr("Show media title instead of file name")
            Layout.columnSpan: 2
            onCheckStateChanged: {
                PlaylistSettings.showMediaTitle = checked
                PlaylistSettings.save()
            }
        }

        CheckBox {
            checked: PlaylistSettings.loadSiblings
            text: qsTr("Auto load videos from same folder")
            Layout.columnSpan: 2
            onCheckStateChanged: {
                PlaylistSettings.loadSiblings = checked
                PlaylistSettings.save()
            }
        }

        CheckBox {
            checked: PlaylistSettings.repeat
            text: qsTr("Repeat")
            Layout.columnSpan: 2
            onCheckStateChanged: {
                PlaylistSettings.repeat = checked
                PlaylistSettings.save()
            }
        }

        CheckBox {
            checked: PlaylistSettings.showRowNumber
            text: qsTr("Show row number")
            Layout.columnSpan: 2
            onCheckStateChanged: {
                PlaylistSettings.showRowNumber = checked
                PlaylistSettings.save()
            }
        }

        CheckBox {
            checked: PlaylistSettings.canToggleWithMouse
            text: qsTr("Toggle with mouse")
            Layout.columnSpan: 2
            onCheckStateChanged: {
                PlaylistSettings.canToggleWithMouse = checked
                PlaylistSettings.save()
                playList.canToggleWithMouse = checked
            }
        }

        CheckBox {
            text: qsTr("Increase font size when fullscreen")
            checked: PlaylistSettings.bigFontFullscreen
            Layout.columnSpan: 2
            onCheckStateChanged: {
                PlaylistSettings.bigFontFullscreen = checked
                PlaylistSettings.save()
                playList.bigFont = checked
                playList.playlistView.forceLayout()
            }
        }

        Item {
            width: Kirigami.Units.gridUnit
            height: Kirigami.Units.gridUnit
        }
    }
}
