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
    height: parent.height

    ColumnLayout {
        id: content

        CheckBox {
            checked: settings.get("Playlist", "CanToogleWithMouse")
            text: qsTr("Toggle with mouse")
            onCheckStateChanged: {
                settings.set("Playlist", "CanToogleWithMouse", checked)
                playList.canToggleWithMouse = checked
            }
        }
        RowLayout {
            Label {
                text: qsTr("Playlist Position")
                color: systemPalette.text
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
                    for (var i = 0; i < model.count; ++i) {
                        if (model.get(i).value === settings.get("Playlist", "Position")) {
                            currentIndex = i
                            break
                        }
                    }
                }
                onActivated: {
                    settings.set("Playlist", "Position", model.get(index).value)
                    playList.position = model.get(index).value
                }
            }
        }

        RowLayout {

            Label {
                text: qsTr("Playlist Row Height")
                color: systemPalette.text
            }

            SpinBox {
                from: 10
                to: 100
                value: settings.get("Playlist", "RowHeight")
                onValueChanged: {
                    settings.set("Playlist", "RowHeight", value)
                    playList.rowHeight = value
                    playList.tableView.forceLayout()
                }
            }

        }

        RowLayout {

            Label {
                text: qsTr("Playlist Row Spacing")
                color: systemPalette.text
            }

            SpinBox {
                from: 0
                to: 100
                value: settings.get("Playlist", "RowSpacing")
                onValueChanged: {
                    settings.set("Playlist", "RowSpacing", value)
                    playList.rowSpacing = value
                }
            }

        }

        CheckBox {
            text: qsTr("Increase font size when fullscreen")
            checked: settings.get("Playlist", "BigFontFullscreen")
            onCheckStateChanged: {
                settings.set("Playlist", "BigFontFullscreen", checked)
                playList.bigFont = checked
                playList.tableView.forceLayout()
            }
        }

    }
}
