import QtQuick 2.13
import QtQuick.Controls 2.13

Item {
    id: root
    property alias configureAction: configureAction
    property alias playPauseAction: playPauseAction
    property alias quitApplicationAction: quitApplicationAction
    property alias configureShortcutsAction: configureShortcutsAction
    property alias openUrlAction: openUrlAction

    property alias seekForwardSmallAction: seekForwardSmallAction
    property alias seekBackwardSmallAction: seekBackwardSmallAction
    property alias seekForwardMediumAction: seekForwardMediumAction
    property alias seekBackwardMediumAction: seekBackwardMediumAction
    property alias seekForwardBigAction: seekForwardBigAction
    property alias seekBackwardBigAction: seekBackwardBigAction
    property alias seekNextSubtitleAction: seekNextSubtitleAction
    property alias seekPreviousSubtitleAction: seekPrevSubtitleAction

    property alias frameStepAction: frameStepAction
    property alias frameBackStepAction: frameBackStepAction
    property alias increasePlayBackSpeedAction: increasePlayBackSpeedAction
    property alias decreasePlayBackSpeedAction: decreasePlayBackSpeedAction
    property alias resetPlayBackSpeedAction: resetPlayBackSpeedAction
    property alias openAction: openAction
    property alias muteAction: muteAction
    property alias playNextAction: playNextAction
    property alias playPreviousAction: playPreviousAction

    Action {
        id: muteAction
        property var qaction: app.action("mute")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
        onTriggered: {
            mpv.setProperty("mute", !mpv.getProperty("mute"))
            if (mpv.getProperty("mute")) {
                text = qsTr("Unmute")
                icon.name = "player-volume-muted"
            } else {
                text = qaction.text
                icon.name = app.iconName(qaction.icon)
            }
        }
    }

    Action {
        id: playNextAction
        property var qaction: app.action("playNext")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
        onTriggered: {
            var nextFileRow = videoList.getPlayingVideo() + 1
            if (nextFileRow < playList.tableView.rows) {
                var nextFile = videoList.getPath(nextFileRow)
                window.openFile(nextFile, true, false)
                videoList.setPlayingVideo(nextFileRow)
            }
        }
    }

    Action {
        id: playPreviousAction
        property var qaction: app.action("playPrevious")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
        onTriggered: {
            if (videoList.getPlayingVideo() !== 0) {
                var previousFileRow = videoList.getPlayingVideo() - 1
                var nextFile = videoList.getPath(previousFileRow)
                window.openFile(nextFile, true, false)
                videoList.setPlayingVideo(previousFileRow)
            }
        }
    }
    Action {
        id: openAction
        text: qsTr("Open File")
        icon.name: "folder-videos-symbolic"
        shortcut: StandardKey.Open
        onTriggered: fileDialog.open()
    }

    Action {
        id: openUrlAction
        property var qaction: app.action("openUrl")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
        onTriggered: {
            if (openUrlPopup.visible) {
                openUrlPopup.close()
            } else {
                openUrlPopup.open()
            }
        }
    }

    Action {
        id: seekForwardSmallAction
        property var qaction: app.action("seekForwardSmall")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
        onTriggered: mpv.command(["seek", "+" + app.setting("General", "SeekStepSmall", "5"), "exact"])
    }

    Action {
        id: seekBackwardSmallAction
        property var qaction: app.action("seekBackwardSmall")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
        onTriggered: mpv.command(["seek", "-" + app.setting("General", "SeekStepSmall", "5"), "exact"])
    }

    Action {
        id: seekForwardMediumAction
        property var qaction: app.action("seekForwardMedium")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
        onTriggered: mpv.command(["seek", "+" + app.setting("General", "SeekStepMedium", "10"), "exact"])
    }

    Action {
        id: seekBackwardMediumAction
        property var qaction: app.action("seekBackwardMedium")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
        onTriggered: mpv.command(["seek", "-" + app.setting("General", "SeekStepMedium", "10"), "exact"])
    }

    Action {
        id: seekForwardBigAction
        property var qaction: app.action("seekForwardBig")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
        onTriggered: mpv.command(["seek", "+" + app.setting("General", "SeekStepBig", "20"), "exact"])
    }

    Action {
        id: seekBackwardBigAction
        property var qaction: app.action("seekBackwardBig")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
        onTriggered: mpv.command(["seek", "-" + app.setting("General", "SeekStepBig", "20"), "exact"])
    }

    Action {
        id: seekNextSubtitleAction
        property var qaction: app.action("seekNextSubtitle")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
        onTriggered: {
            if (mpv.getProperty("sid") !== false) {
                mpv.command(["sub-seek", "1"])
            } else {
                seekForwardSmallAction.trigger()
            }
        }
    }

    Action {
        id: seekPrevSubtitleAction
        property var qaction: app.action("seekPreviousSubtitle")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
        onTriggered: {
             if (mpv.getProperty("sid") !== false) {
                 mpv.command(["sub-seek", "-1"])
             } else {
                 seekBackwardSmallAction.trigger()
             }
         }
    }

    Action {
        id: frameStepAction
        property var qaction: app.action("frameStep")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
        onTriggered: mpv.command(["frame-step"])
    }

    Action {
        id: frameBackStepAction
        property var qaction: app.action("frameBackStep")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
        onTriggered: mpv.command(["frame-back-step"])
    }

    Action {
        id: increasePlayBackSpeedAction
        property var qaction: app.action("increasePlayBackSpeed")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
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
        property var qaction: app.action("decreasePlayBackSpeed")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
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
        property var qaction: app.action("resetPlayBackSpeed")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)
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
        property var qaction: app.action("options_configure_keybinding")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut
        onTriggered: qaction.trigger()
    }

    Action {
        id: quitApplicationAction
        property var qaction: app.action("file_quit")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut
        onTriggered: qaction.trigger()
    }

    Action {
        id: configureAction
        property var qaction: app.action("configure")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut
        onTriggered: qaction.trigger()
    }

}
