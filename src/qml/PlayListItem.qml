/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Window 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13

Item {
    id: root

    property string path: model.path

    implicitHeight: playList.rowHeight + label.font.pixelSize / 2

    Rectangle {
        anchors.fill: parent

        color: {
            if (model.isHovered && model.isPlaying) {
                let color = systemPalette.base
                Qt.hsla(color.hslHue, color.hslSaturation, color.hslLightness, 0.8)
            } else if (model.isHovered && !model.isPlaying) {
                let color = systemPalette.base
                Qt.hsla(color.hslHue, color.hslSaturation, color.hslLightness, 0.8)
            } else if (!model.isHovered && model.isPlaying) {
                systemPalette.highlight
            } else {
                let color = systemPalette.alternateBase
                Qt.hsla(color.hslHue, color.hslSaturation, color.hslLightness, 0.7)
            }
        }

        Label {
            id: label

            anchors.fill: parent
            color: systemPalette.text
            horizontalAlignment: column === 1 ? Qt.AlignLeft : Qt.AlignCenter
            verticalAlignment: Qt.AlignVCenter
            elide: Text.ElideRight
            font.bold: true
            text: model.name
            leftPadding: 10
            rightPadding: column === 2 ? scrollBar.width : 10
            layer.enabled: true
            font.pointSize: {
                if (window.visibility === Window.FullScreen && playList.bigFont) {
                    return 18
                }
                return 12
            }
            ToolTip {
                id: toolTip
                delay: 250
                visible: false
                text: model.name
            }
        }
    }

    MouseArea {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            playListModel.setHoveredVideo(row)
            if (column === 1 && label.truncated) {
                toolTip.visible = true
            }
        }

        onExited: {
            playListModel.clearHoveredVideo(row)
            toolTip.visible = false
        }

        onDoubleClicked: {
            if (mouse.button === Qt.LeftButton) {
                window.openFile(model.path, true, false)
                playListModel.setPlayingVideo(row)
            }
        }
    }
}
