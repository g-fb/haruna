/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

Flickable {
    id: root

    property int iconSize: 32
    property var active: general

    clip: true
    contentHeight: sidebar.height
    ScrollBar.vertical: ScrollBar { id: scrollbar }

    ColumnLayout {
        id: sidebar

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: scrollbar.width
        anchors.rightMargin: scrollbar.width

        ToolButton {
            id: general

            text: "General"
            checkable: true
            checked: true
            icon.name: "configure"
            icon.width: root.iconSize
            icon.height: root.iconSize
            display: AbstractButton.TextUnderIcon
            Layout.fillWidth: true
            onClicked: {
                if (active === general) {
                    checked = true
                    return
                }

                settingsPageLoader.item.visible = false
                settingsPageLoader.sourceComponent = generalSettings
                settingsPageLoader.item.visible = true
                active.checked = false
                active = general
            }
        }
        ToolButton {
            id: colors

            text: "Color Adjustments"
            checkable: true
            icon.name: "color-management"
            icon.width: root.iconSize
            icon.height: root.iconSize
            display: AbstractButton.TextUnderIcon
            Layout.fillWidth: true
            onClicked: {
                if (active === this) {
                    checked = true
                    return
                }

                settingsPageLoader.item.visible = false
                settingsPageLoader.sourceComponent = colorAdjustmentsSettings
                settingsPageLoader.item.visible = true
                active.checked = false
                active = this
            }
        }
        ToolButton {
            id: mouse

            text: "Mouse"
            checkable: true
            icon.name: "input-mouse"
            icon.width: root.iconSize
            icon.height: root.iconSize
            display: AbstractButton.TextUnderIcon
            Layout.fillWidth: true
            onClicked: {
                if (active === this) {
                    checked = true
                    return
                }

                settingsPageLoader.item.visible = false
                settingsPageLoader.sourceComponent = mouseSettings
                settingsPageLoader.item.visible = true
                active.checked = false
                active = this
            }
        }
        ToolButton {
            id: playlist

            text: "Playlist"
            checkable: true
            icon.name: "view-media-playlist"
            icon.width: root.iconSize
            icon.height: root.iconSize
            display: AbstractButton.TextUnderIcon
            Layout.fillWidth: true
            onClicked: {
                if (active === this) {
                    checked = true
                    return
                }

                settingsPageLoader.item.visible = false
                settingsPageLoader.sourceComponent = playlistSettings
                settingsPageLoader.item.visible = true
                active.checked = false
                active = this
            }
        }
        ToolButton {
            id: audio

            text: "Audio"
            checkable: true
            icon.name: "audio-speakers-symbolic"
            icon.width: root.iconSize
            icon.height: root.iconSize
            display: AbstractButton.TextUnderIcon
            Layout.fillWidth: true
            onClicked: {
                if (active === this) {
                    checked = true
                    return
                }

                settingsPageLoader.item.visible = false
                settingsPageLoader.sourceComponent = audioSettings
                settingsPageLoader.item.visible = true
                active.checked = false
                active = this
            }
        }
        ToolButton {
            id: subtitles

            text: "Subtitles"
            checkable: true
            icon.name: "media-view-subtitles-symbolic"
            icon.width: root.iconSize
            icon.height: root.iconSize
            display: AbstractButton.TextUnderIcon
            Layout.fillWidth: true
            onClicked: {
                if (active === this) {
                    checked = true
                    return
                }

                settingsPageLoader.item.visible = false
                settingsPageLoader.sourceComponent = subtitlesSettings
                settingsPageLoader.item.visible = true
                active.checked = false
                active = this
            }
        }
        ToolButton {
            id: playback

            text: "Playback"
            checkable: true
            icon.name: "media-playback-start"
            icon.width: root.iconSize
            icon.height: root.iconSize
            display: AbstractButton.TextUnderIcon
            Layout.fillWidth: true
            onClicked: {
                if (active === this) {
                    checked = true
                    return
                }

                settingsPageLoader.item.visible = false
                settingsPageLoader.sourceComponent = playbackSettings
                settingsPageLoader.item.visible = true
                active.checked = false
                active = this
            }
        }
        ToolButton {
            id: shortcuts

            text: "Shortcuts"
            icon.name: "configure-shortcuts"
            icon.width: root.iconSize
            icon.height: root.iconSize
            display: AbstractButton.TextUnderIcon
            Layout.fillWidth: true
            action: actions.configureShortcutsAction
        }
    }
}
