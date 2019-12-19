import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

Item {
    id: root

    property int iconSize: 32
    property var active: general

    height: parent.height
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom

    Rectangle {
        width: 1
        height: parent.height
        anchors.right: parent.right
        color: systemPalette.base
    }

    ColumnLayout {
        width: parent.width
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

                settingsViewLoader.item.visible = false
                settingsViewLoader.sourceComponent = generalSettings
                settingsViewLoader.item.visible = true
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

                settingsViewLoader.item.visible = false
                settingsViewLoader.sourceComponent = colorAdjustmentsSettings
                settingsViewLoader.item.visible = true
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

                settingsViewLoader.item.visible = false
                settingsViewLoader.sourceComponent = mouseSettings
                settingsViewLoader.item.visible = true
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

                settingsViewLoader.item.visible = false
                settingsViewLoader.sourceComponent = playlistSettings
                settingsViewLoader.item.visible = true
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

                settingsViewLoader.item.visible = false
                settingsViewLoader.sourceComponent = audioSettings
                settingsViewLoader.item.visible = true
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

                settingsViewLoader.item.visible = false
                settingsViewLoader.sourceComponent = subtitlesSettings
                settingsViewLoader.item.visible = true
                active.checked = false
                active = this
            }
        }
    }
}
