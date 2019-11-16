import QtQuick 2.13
import QtQuick.Controls 2.13

Item {
    id: root
    property var actions: {"": ""}
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
    property alias volumeUpAction: volumeUpAction
    property alias volumeDownAction: volumeDownAction
    property alias muteAction: muteAction
    property alias playNextAction: playNextAction
    property alias playPreviousAction: playPreviousAction
    property alias subtitleQuickenAction: subtitleQuickenAction
    property alias subtitleDelayAction: subtitleDelayAction

    property alias contrastUpAction: contrastUpAction
    property alias contrastDownAction: contrastDownAction
    property alias brightnessUpAction: brightnessUpAction
    property alias brightnessDownAction: brightnessDownAction
    property alias gammaUpAction: gammaUpAction
    property alias gammaDownAction: gammaDownAction
    property alias saturationUpAction: saturationUpAction
    property alias saturationDownAction: saturationDownAction

    Action {
        id: volumeUpAction
        property var qaction: app.action("volumeUp")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)

        Component.onCompleted: actions["volumeUpAction"] = volumeUpAction

        onTriggered: {
            var currentVolume = parseInt(mpv.getProperty("volume"))
            var volumeStep = parseInt(settings.get("General", "VolumeStep"))
            var newVolume = currentVolume + volumeStep
            if (currentVolume < 100) {
                if (newVolume > 100) {
                    mpv.setProperty("volume", 100)
                } else {
                    mpv.setProperty("volume", newVolume)
                }
            }
            osd.message(`Volume: ${parseInt(mpv.getProperty("volume"))}`)
        }
    }
    Action {
        id: volumeDownAction
        property var qaction: app.action("volumeDown")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)

        Component.onCompleted: actions["volumeDownAction"] = volumeDownAction

        onTriggered: {
            var currentVolume = parseInt(mpv.getProperty("volume"))
            var volumeStep = parseInt(settings.get("General", "VolumeStep"))
            var newVolume = currentVolume - volumeStep
            if (currentVolume >= 0) {
                if (newVolume < 0) {
                    mpv.setProperty("volume", 0)
                } else {
                    mpv.setProperty("volume", newVolume)
                }
            }
            osd.message(`Volume: ${parseInt(mpv.getProperty("volume"))}`)
        }
    }
    Action {
        id: muteAction
        property var qaction: app.action("mute")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)

        Component.onCompleted: actions["muteAction"] = muteAction

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

        Component.onCompleted: actions["playNextAction"] = playNextAction

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

        Component.onCompleted: actions["playPreviousAction"] = playPreviousAction

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

        Component.onCompleted: actions["openAction"] = openAction

        onTriggered: fileDialog.open()
    }

    Action {
        id: openUrlAction
        property var qaction: app.action("openUrl")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)

        Component.onCompleted: actions["openUrlAction"] = openAction

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

        Component.onCompleted: actions["seekForwardSmallAction"] = seekForwardSmallAction

        onTriggered: mpv.command(["seek", settings.get("General", "SeekSmallStep"), "exact"])
    }

    Action {
        id: seekBackwardSmallAction
        property var qaction: app.action("seekBackwardSmall")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)

        Component.onCompleted: actions["seekBackwardSmallAction"] = seekBackwardSmallAction

        onTriggered: mpv.command(["seek", -settings.get("General", "SeekSmallStep"), "exact"])
    }

    Action {
        id: seekForwardMediumAction
        property var qaction: app.action("seekForwardMedium")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)

        Component.onCompleted: actions["seekForwardMediumAction"] = seekForwardMediumAction

        onTriggered: mpv.command(["seek", settings.get("General", "SeekMediumStep"), "exact"])
    }

    Action {
        id: seekBackwardMediumAction
        property var qaction: app.action("seekBackwardMedium")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)

        Component.onCompleted: actions["seekBackwardMediumAction"] = seekBackwardMediumAction

        onTriggered: mpv.command(["seek", -settings.get("General", "SeekMediumStep"), "exact"])
    }

    Action {
        id: seekForwardBigAction
        property var qaction: app.action("seekForwardBig")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)

        Component.onCompleted: actions["seekForwardBigAction"] = seekForwardBigAction

        onTriggered: mpv.command(["seek", settings.get("General", "SeekBigStep"), "exact"])
    }

    Action {
        id: seekBackwardBigAction
        property var qaction: app.action("seekBackwardBig")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)

        Component.onCompleted: actions["seekBackwardBigAction"] = seekBackwardBigAction

        onTriggered: mpv.command(["seek", -settings.get("General", "SeekBigStep"), "exact"])
    }

    Action {
        id: seekNextSubtitleAction
        property var qaction: app.action("seekNextSubtitle")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)

        Component.onCompleted: actions["seekNextSubtitleAction"] = seekNextSubtitleAction

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

        Component.onCompleted: actions["seekPrevSubtitleAction"] = seekPrevSubtitleAction

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

        Component.onCompleted: actions["frameStepAction"] = frameStepAction

        onTriggered: mpv.command(["frame-step"])
    }

    Action {
        id: frameBackStepAction
        property var qaction: app.action("frameBackStep")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)

        Component.onCompleted: actions["frameBackStepAction"] = frameBackStepAction

        onTriggered: mpv.command(["frame-back-step"])
    }

    Action {
        id: increasePlayBackSpeedAction
        property var qaction: app.action("increasePlayBackSpeed")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)

        Component.onCompleted: actions["increasePlayBackSpeedAction"] = increasePlayBackSpeedAction

        onTriggered: {
            mpv.setProperty("speed", mpv.getProperty("speed") + 0.1)
            osd.message(`Speed: ${mpv.getProperty("speed").toFixed(2)}`)
        }
    }

    Action {
        id: decreasePlayBackSpeedAction
        property var qaction: app.action("decreasePlayBackSpeed")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)

        Component.onCompleted: actions["decreasePlayBackSpeedAction"] = decreasePlayBackSpeedAction

        onTriggered: {
            mpv.setProperty("speed", mpv.getProperty("speed") - 0.1)
            osd.message(`Speed: ${mpv.getProperty("speed").toFixed(2)}`)
        }
    }

    Action {
        id: resetPlayBackSpeedAction
        property var qaction: app.action("resetPlayBackSpeed")
        text: qaction.text
        shortcut: qaction.shortcut
        icon.name: app.iconName(qaction.icon)

        Component.onCompleted: actions["resetPlayBackSpeedAction"] = resetPlayBackSpeedAction

        onTriggered: {
            mpv.setProperty("speed", 1.0)
            osd.message(`Speed: ${mpv.getProperty("speed").toFixed(2)}`)
         }
    }

    Action {
        id: playPauseAction
        text: qsTr("Play/Pause")
        icon.name: "media-playback-pause"
        shortcut: "Space"

        Component.onCompleted: actions["playPauseAction"] = playPauseAction

        onTriggered: mpv.play_pause()
    }

    Action {
        id: configureShortcutsAction
        property var qaction: app.action("options_configure_keybinding")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["configureShortcutsAction"] = configureShortcutsAction

        onTriggered: qaction.trigger()
    }

    Action {
        id: quitApplicationAction
        property var qaction: app.action("file_quit")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["quitApplicationAction"] = quitApplicationAction

        onTriggered: qaction.trigger()
    }

    Action {
        id: configureAction
        property var qaction: app.action("configure")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["configureAction"] = configureAction

        onTriggered: {
            if (hSettings.state === "visible") {
                hSettings.state = "hidden"
            } else {
                hSettings.state = "visible"
            }
        }
    }

    Action {
        id: subtitleQuickenAction
        property var qaction: app.action("subtitleQuicken")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["subtitleQuickenAction"] = subtitleQuickenAction

        onTriggered: {
            mpv.setProperty("sub-delay", mpv.getProperty("sub-delay") + 0.1)
            osd.message(`Subtitle timing (delay): ${mpv.getProperty("sub-delay").toFixed(2)}`)
        }
    }

    Action {
        id: subtitleDelayAction
        property var qaction: app.action("subtitleDelay")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["subtitleDelayAction"] = subtitleDelayAction

        onTriggered: {
            mpv.setProperty("sub-delay", mpv.getProperty("sub-delay") - 0.1)
            osd.message(`Subtitle timing (quicken): ${mpv.getProperty("sub-delay").toFixed(2)}`)
        }
    }

    Action {
        id: subtitleToggleAction
        property var qaction: app.action("subtitleToggle")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["subtitleToggleAction"] = subtitleToggleAction

        onTriggered: {
            var visible = mpv.getProperty("sub-visibility")
            var message = visible ? "Subtitles off" : "Subtitles on"
            mpv.setProperty("sub-visibility", !visible)
            osd.message(message)
        }
    }

    Action {
        id: contrastUpAction
        property var qaction: app.action("contrastUp")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["contrastUpAction"] = contrastUpAction

        onTriggered: {
            var contrast = parseInt(mpv.getProperty("contrast")) + 1
            mpv.setProperty("contrast", `${contrast}`)
            osd.message(`Contrast: ${contrast}`)
        }
    }
    Action {
        id: contrastDownAction
        property var qaction: app.action("contrastDown")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["contrastDownAction"] = contrastDownAction

        onTriggered: {
            var contrast = parseInt(mpv.getProperty("contrast")) - 1
            mpv.setProperty("contrast", `${contrast}`)
            osd.message(`Contrast: ${contrast}`)
        }
    }
    Action {
        id: contrastResetAction
        property var qaction: app.action("contrastReset")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["contrastResetAction"] = contrastResetAction

        onTriggered: {
            mpv.setProperty("contrast", `0`)
            osd.message(`Contrast: 0`)
        }
    }

    Action {
        id: brightnessUpAction
        property var qaction: app.action("brightnessUp")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["brightnessUpAction"] = brightnessUpAction

        onTriggered: {
            var brightness = parseInt(mpv.getProperty("brightness")) + 1
            mpv.setProperty("brightness", `${brightness}`)
            osd.message(`Brightness: ${brightness}`)
        }
    }
    Action {
        id: brightnessDownAction
        property var qaction: app.action("brightnessDown")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["brightnessDownAction"] = brightnessDownAction

        onTriggered: {
            var brightness = parseInt(mpv.getProperty("brightness")) - 1
            mpv.setProperty("brightness", `${brightness}`)
            osd.message(`Brightness: ${brightness}`)
        }
    }
    Action {
        id: brightnessResetAction
        property var qaction: app.action("brightnessReset")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["brightnessResetAction"] = brightnessResetAction

        onTriggered: {
            mpv.setProperty("brightness", `0`)
            osd.message(`Brightness: 0`)
        }
    }
    Action {
        id: gammaUpAction
        property var qaction: app.action("gammaUp")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["gammaUpAction"] = gammaUpAction

        onTriggered: {
            var gamma = parseInt(mpv.getProperty("gamma")) + 1
            mpv.setProperty("gamma", `${gamma}`)
            osd.message(`Gamma: ${gamma}`)
        }
    }
    Action {
        id: gammaDownAction
        property var qaction: app.action("gammaDown")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["gammaDownAction"] = gammaDownAction

        onTriggered: {
            var gamma = parseInt(mpv.getProperty("gamma")) - 1
            mpv.setProperty("gamma", `${gamma}`)
            osd.message(`Gamma: ${gamma}`)
        }
    }
    Action {
        id: gammaResetAction
        property var qaction: app.action("gammaReset")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["gammaResetAction"] = gammaResetAction

        onTriggered: {
            mpv.setProperty("gamma", `0`)
            osd.message(`Gamma: 0`)
        }
    }
    Action {
        id: saturationUpAction
        property var qaction: app.action("saturationUp")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["saturationUpAction"] = saturationUpAction

        onTriggered: {
            var saturation = parseInt(mpv.getProperty("saturation")) + 1
            mpv.setProperty("saturation", `${saturation}`)
            osd.message(`Saturation: ${saturation}`)
        }
    }
    Action {
        id: saturationDownAction
        property var qaction: app.action("saturationDown")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["saturationDownAction"] = saturationDownAction

        onTriggered: {
            var saturation = parseInt(mpv.getProperty("saturation")) - 1
            mpv.setProperty("saturation", `${saturation}`)
            osd.message(`Saturation: ${saturation}`)
        }
    }
    Action {
        id: saturationResetAction
        property var qaction: app.action("saturationReset")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["saturationResetAction"] = saturationResetAction

        onTriggered: {
            mpv.setProperty("saturation", `0`)
            osd.message(`Saturation: 0`)
        }
    }

    Action {
        id: zoomInAction
        property var qaction: app.action("zoomIn")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["zoomInAction"] = zoomInAction

        onTriggered: {
            var zoom = mpv.getProperty("video-zoom") + 0.1
            mpv.setProperty("video-zoom", zoom)
            osd.message(`Zoom: ${zoom.toFixed(2)}`)
        }
    }

    Action {
        id: zoomOutAction
        property var qaction: app.action("zoomOut")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["zoomOutAction"] = zoomOutAction

        onTriggered: {
            var zoom = mpv.getProperty("video-zoom") - 0.1
            mpv.setProperty("video-zoom", zoom)
            osd.message(`Zoom: ${zoom.toFixed(2)}`)
        }
    }
    Action {
        id: zoomResetAction
        property var qaction: app.action("zoomReset")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["zoomResetAction"] = zoomResetAction

        onTriggered: {
            mpv.setProperty("video-zoom", 0)
            osd.message(`Zoom: 0`)
        }
    }


    Action {
        id: videoPanXLeftAction
        property var qaction: app.action("videoPanXLeft")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["videoPanXLeftAction"] = videoPanXLeftAction

        onTriggered: {
            var pan = mpv.getProperty("video-pan-x") + 0.1
            mpv.setProperty("video-pan-x", pan)
            osd.message(`Video pan x: ${pan.toFixed(2)}`)
        }
    }
    Action {
        id: videoPanXRightAction
        property var qaction: app.action("videoPanXRight")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["videoPanXRightAction"] = videoPanXRightAction

        onTriggered: {
            var pan = mpv.getProperty("video-pan-x") - 0.1
            mpv.setProperty("video-pan-x", pan)
            osd.message(`Video pan x: ${pan.toFixed(2)}`)
        }
    }
    Action {
        id: videoPanYUpAction
        property var qaction: app.action("videoPanYUp")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["videoPanYUpAction"] = videoPanYUpAction

        onTriggered: {
            var pan = mpv.getProperty("video-pan-y") + 0.1
            mpv.setProperty("video-pan-y", pan)
            osd.message(`Video pan x: ${pan.toFixed(2)}`)
        }
    }
    Action {
        id: videoPanYDownAction
        property var qaction: app.action("videoPanYDown")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["videoPanYDownAction"] = videoPanYDownAction

        onTriggered: {
            var pan = mpv.getProperty("video-pan-y") - 0.1
            mpv.setProperty("video-pan-y", pan)
            osd.message(`Video pan x: ${pan.toFixed(2)}`)
        }
    }

    Action {
        id: fullscreenAction
        property var qaction: app.action("fullscreen")
        text: qaction.text
        icon.name: app.iconName(qaction.icon)
        shortcut: qaction.shortcut

        Component.onCompleted: actions["fullscreenAction"] = fullscreenAction

        onTriggered: {
            mpv.toggleFullScreen()
        }
    }
}
