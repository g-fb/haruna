import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Window 2.13
import QtQuick.Layouts 1.13
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.13
import Qt.labs.settings 1.0

import mpv 1.0
import Application 1.0
import VideoPlayList 1.0

ApplicationWindow {
    id: window

    property var quitApplication: app.action("file_quit")
    property var configureShortcuts: app.action("options_configure_keybinding")
    property var openUrl: app.action("openUrl")
    property var seekForward: app.action("seekForward")
    property var seekBackward: app.action("seekBackward")
    property var seekNextSubtitle: app.action("seekNextSubtitle")
    property var seekPreviousSubtitle: app.action("seekPreviousSubtitle")
    property int preFullScreenVisibility

    signal setHovered(int row)
    signal removeHovered(int row)
    signal durationChanged(double duration)
    signal positionChanged(double position)

    function openFile(path, startPlayback, loadSiblings) {
        mpv.loadFile(path)

        if (startPlayback) {
            mpv.setProperty("pause", false)
        } else {
            mpv.setProperty("pause", true)
        }

        if (loadSiblings) {
            videoList.getVideos(path)
        }

        settings.lastPlayedFile = path
    }

    visible: true
    title: qsTr("Haruna")
    width: 1280
    height: 720

    onVisibilityChanged: {
        if (visibility !== Window.FullScreen) {
            preFullScreenVisibility = visibility
        }
    }

    Settings {
        id: settings
        property string lastPlayedFile
        property double lastPlayedPosition
        property double lastPlayedDuration
        property int playingFileYPosition
        property alias lastUrl: openUrlTextField.text
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
    }

    header: Header { id: header }

    footer: Footer { id: footer }

    MpvVideo { id: mpv }

    PlayList { id: playList }

    Rectangle {
        id: fullscreenFooter
        anchors.bottom: mpv.bottom
        width: window.width
        height: footer.height
        visible: false
        color: Qt.rgba(0.14, 0.15, 0.16, 0.8)

        ShaderEffectSource {
            id: effectSource
            sourceItem: mpv
            anchors.fill: parent
            sourceRect: Qt.rect(footer.x, footer.y, footer.width, footer.height)
        }

        FastBlur {
            id: blur
            anchors.fill: effectSource
            source: effectSource
            radius: 100
        }
    }

    FileDialog {
        id: fileDialog
        folder: shortcuts.movies
        title: "Select file"
        selectMultiple: false

        onAccepted: {
            openFile(fileDialog.fileUrl, true, true)
            // the timer scrolls the playlist to the playing file
            // once the table view rows are loaded
            mpv.scrollPositionTimer.start()
            mpv.focus = true
        }
        onRejected: mpv.focus = true
    }

    Popup {
        id: openUrlPopup
        anchors.centerIn: Overlay.overlay
        width: mpv.width * 0.7

        onOpened: {
            openUrlPopup.focus = true
            openUrlTextField.focus = true
            openUrlTextField.selectAll()
        }

        RowLayout {
            anchors.fill: parent
            TextField {
                id: openUrlTextField
                Layout.fillWidth: true

                Keys.onPressed: {
                    if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                        openFile(openUrlTextField.text, true, false)
                        openUrlPopup.close()
                    }
                    if (event.key === Qt.Key_Escape) {
                        openUrlPopup.close()
                    }
                }
            }
            Button {
                id: openUrlButton
                text: qsTr("Open")

                onClicked: {
                    openFile(openUrlTextField.text, true, false)
                    openUrlPopup.close()
                }
            }
        }
    }

    Action {
        id: openAction
        text: qsTr("Open File")
        icon.name: "document-open"
        shortcut: StandardKey.Open
        onTriggered: fileDialog.open()
    }

    Action {
        id: openUrlAction
        text: openUrl.text
        shortcut: openUrl.shortcut
        icon.name: app.iconName(openUrl.icon)
        onTriggered: openUrlPopup.open()
    }

    Action {
        id: seekForwardAction
        text: seekForward.text
        shortcut: seekForward.shortcut
        icon.name: app.iconName(seekForward.icon)
        onTriggered: mpv.command(["seek", "+5"])
    }

    Action {
        id: seekBackwardAction
        text: seekBackward.text
        shortcut: seekBackward.shortcut
        icon.name: app.iconName(seekBackward.icon)
        onTriggered: mpv.command(["seek", "-5"])
    }

    Action {
        id: seekNextSubtitleAction
        text: seekNextSubtitle.text
        shortcut: seekNextSubtitle.shortcut
        icon.name: app.iconName(seekNextSubtitle.icon)
        onTriggered: mpv.command(["sub-seek", "1"])
    }
    Action {
        id: seekPrevSubtitleAction
        text: seekPreviousSubtitle.text
        shortcut: seekPreviousSubtitle.shortcut
        icon.name: app.iconName(seekPreviousSubtitle.icon)
        onTriggered: mpv.command(["sub-seek", "-1"])
    }

    Action {
        id: playPauseAction
        text: qsTr("Play/Pause")
        icon.name: "media-playback-pause"
        shortcut: "Space"
        onTriggered: mpv.play_pause()
    }

    Action {
        id: configureShortcutsAction
        text: configureShortcuts.text
        icon.name: app.iconName(configureShortcuts.icon)
        shortcut: configureShortcuts.shortcut
        onTriggered: configureShortcuts.trigger()
    }

    Action {
        id: appQuitAction
        text: quitApplication.text
        icon.name: app.iconName(quitApplication.icon)
        shortcut: quitApplication.shortcut
        onTriggered: quitApplication.trigger()
    }

}
