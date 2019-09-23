import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Window 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13
import Qt.labs.platform 1.0 as PlatformDialog

import mpv 1.0

ApplicationWindow {
    id: window

    property var quitApplication: app.action("file_quit")
    property var configureShortcuts: app.action("options_configure_keybinding")
    property var openUrl: app.action("openUrl")
    property var seekForward: app.action("seekForward")
    property var seekBackward: app.action("seekBackward")
    property var seekNextSubtitle: app.action("seekNextSubtitle")
    property var seekPreviousSubtitle: app.action("seekPreviousSubtitle")
    property var frameStep: app.action("frameStep")
    property var frameBackStep: app.action("frameBackStep")
    property var increasePlayBackSpeed: app.action("increasePlayBackSpeed")
    property var decreasePlayBackSpeed: app.action("decreasePlayBackSpeed")
    property var resetPlayBackSpeed: app.action("resetPlayBackSpeed")
    property var configure: app.action("configure")

    property int preFullScreenVisibility

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

        app.setSetting("General", "lastPlayedFile", path)
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
        color: "#31363B"
    }

    Osd { id: osd }

    SystemPalette { id: systemPalette; colorGroup: SystemPalette.Active }

    PlatformDialog.FileDialog {
        id: fileDialog
        folder: PlatformDialog.StandardPaths.writableLocation(PlatformDialog.StandardPaths.MoviesLocation)
        title: "Select file"
        fileMode: PlatformDialog.FileDialog.OpenFile

        onAccepted: {
            openFile(fileDialog.file, true, true)
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
                text: app.setting("General", "lastUrl")

                Keys.onPressed: {
                    if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                        openFile(openUrlTextField.text, true, false)
                        openUrlPopup.close()
                        app.setSetting("General", "lastUrl", openUrlTextField.text)
                        openUrlTextField.text = ""
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
                    app.setSetting("General", "lastUrl", openUrlTextField.text)
                    openUrlTextField.text = ""
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
        onTriggered: mpv.command(["seek", "+5", "exact"])
    }

    Action {
        id: seekBackwardAction
        text: seekBackward.text
        shortcut: seekBackward.shortcut
        icon.name: app.iconName(seekBackward.icon)
        onTriggered: mpv.command(["seek", "-5", "exact"])
    }

    Action {
        id: seekNextSubtitleAction
        text: seekNextSubtitle.text
        shortcut: seekNextSubtitle.shortcut
        icon.name: app.iconName(seekNextSubtitle.icon)
        onTriggered: {
            if (mpv.getProperty("sid") !== false) {
                mpv.command(["sub-seek", "1"])
            } else {
                seekForwardAction.trigger()
            }
        }
    }

    Action {
        id: seekPrevSubtitleAction
        text: seekPreviousSubtitle.text
        shortcut: seekPreviousSubtitle.shortcut
        icon.name: app.iconName(seekPreviousSubtitle.icon)
        onTriggered: {
             if (mpv.getProperty("sid") !== false) {
                 mpv.command(["sub-seek", "-1"])
             } else {
                 seekBackwardAction.trigger()
             }
         }
    }

    Action {
        id: frameStepAction
        text: frameStep.text
        shortcut: frameStep.shortcut
        icon.name: app.iconName(frameStep.icon)
        onTriggered: mpv.command(["frame-step"])
    }

    Action {
        id: frameBackStepAction
        text: frameBackStep.text
        shortcut: frameBackStep.shortcut
        icon.name: app.iconName(frameBackStep.icon)
        onTriggered: mpv.command(["frame-back-step"])
    }

    Action {
        id: increasePlayBackSpeedAction
        text: increasePlayBackSpeed.text
        shortcut: increasePlayBackSpeed.shortcut
        icon.name: app.iconName(increasePlayBackSpeed.icon)
        onTriggered: {
            mpv.setProperty("speed", mpv.getProperty("speed") + 0.1)
            osd.label.text = `Speed: ${mpv.getProperty("speed").toFixed(2)}`
            if(osd.label.visible) {
                osd.timer.restart()
            } else {
                osd.timer.start()
            }
            osd.label.visible = true
        }
    }

    Action {
        id: decreasePlayBackSpeedAction
        text: decreasePlayBackSpeed.text
        shortcut: decreasePlayBackSpeed.shortcut
        icon.name: app.iconName(decreasePlayBackSpeed.icon)
        onTriggered: {
            mpv.setProperty("speed", mpv.getProperty("speed") - 0.1)
            osd.label.text = `Speed: ${mpv.getProperty("speed").toFixed(2)}`
            if(osd.label.visible) {
                osd.timer.restart()
            } else {
                osd.timer.start()
            }
            osd.label.visible = true
        }
    }

    Action {
        id: resetPlayBackSpeedAction
        text: resetPlayBackSpeed.text
        shortcut: resetPlayBackSpeed.shortcut
        icon.name: app.iconName(resetPlayBackSpeed.icon)
        onTriggered: {
            mpv.setProperty("speed", 1.0)
            osd.label.text = `Speed: ${mpv.getProperty("speed").toFixed(2)}`
            if(osd.label.visible) {
                osd.timer.restart()
            } else {
                osd.timer.start()
            }
            osd.label.visible = true
         }
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

    Action {
        id: configureAction
        text: configure.text
        icon.name: app.iconName(configure.icon)
        shortcut: configure.shortcut
        onTriggered: configure.trigger()
    }

}
