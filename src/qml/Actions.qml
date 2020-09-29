/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import AppSettings 1.0

Item {
    id: root
    property var list: ({})

    property alias configureAction: configureAction
    property alias configureShortcutsAction: configureShortcutsAction
    property alias openAction: openAction
    property alias openUrlAction: openUrlAction
    property alias playPauseAction: playPauseAction
    property alias quitApplicationAction: quitApplicationAction

    property alias seekForwardSmallAction: seekForwardSmallAction
    property alias seekBackwardSmallAction: seekBackwardSmallAction
    property alias seekForwardMediumAction: seekForwardMediumAction
    property alias seekBackwardMediumAction: seekBackwardMediumAction
    property alias seekForwardBigAction: seekForwardBigAction
    property alias seekBackwardBigAction: seekBackwardBigAction
    property alias seekPreviousChapterAction: seekPreviousChapterAction
    property alias seekNextChapterAction: seekNextChapterAction
    property alias seekNextSubtitleAction: seekNextSubtitleAction
    property alias seekPreviousSubtitleAction: seekPrevSubtitleAction

    property alias frameStepAction: frameStepAction
    property alias frameBackStepAction: frameBackStepAction
    property alias increasePlayBackSpeedAction: increasePlayBackSpeedAction
    property alias decreasePlayBackSpeedAction: decreasePlayBackSpeedAction
    property alias resetPlayBackSpeedAction: resetPlayBackSpeedAction
    property alias volumeUpAction: volumeUpAction
    property alias volumeDownAction: volumeDownAction
    property alias muteAction: muteAction
    property alias playNextAction: playNextAction
    property alias playPreviousAction: playPreviousAction
    property alias subtitleQuickenAction: subtitleQuickenAction
    property alias subtitleDelayAction: subtitleDelayAction
    property alias subtitleToggleAction: subtitleToggleAction

    property alias contrastUpAction: contrastUpAction
    property alias contrastDownAction: contrastDownAction
    property alias brightnessUpAction: brightnessUpAction
    property alias brightnessDownAction: brightnessDownAction
    property alias gammaUpAction: gammaUpAction
    property alias gammaDownAction: gammaDownAction
    property alias saturationUpAction: saturationUpAction
    property alias saturationDownAction: saturationDownAction

    property alias toggleMenuBarAction: toggleMenuBarAction
    property alias toggleHeaderAction: toggleHeaderAction

    Action {
        id: openContextMenuAction
        property var qaction: app.action("openContextMenu")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["openContextMenuAction"] = openContextMenuAction

        onTriggered: mpvContextMenu.popup()
    }

    Action {
        id: togglePlaylistAction
        property var qaction: app.action("togglePlaylist")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["togglePlaylistAction"] = togglePlaylistAction

        onTriggered: {
            if (playList.state === "visible") {
                playList.state = "hidden"
            } else {
                playList.state = "visible"
            }
        }
    }

    Action {
        id: volumeUpAction
        property var qaction: app.action("volumeUp")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["volumeUpAction"] = volumeUpAction

        onTriggered: {
            const currentVolume = parseInt(mpv.getProperty("volume"))
            const volumeStep = parseInt(AppSettings.volumeStep)
            const newVolume = currentVolume + volumeStep
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
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["volumeDownAction"] = volumeDownAction

        onTriggered: {
            const currentVolume = parseInt(mpv.getProperty("volume"))
            const volumeStep = parseInt(AppSettings.volumeStep)
            const newVolume = currentVolume - volumeStep
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
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["muteAction"] = muteAction

        onTriggered: {
            mpv.setProperty("mute", !mpv.getProperty("mute"))
            if (mpv.getProperty("mute")) {
                text = qsTr("Unmute")
                icon.name = "player-volume-muted"
            } else {
                text = qaction.text
                icon.name = qaction.iconName()
            }
        }
    }

    Action {
        id: playNextAction
        property var qaction: app.action("playNext")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["playNextAction"] = playNextAction

        onTriggered: {
            const nextFileRow = playListModel.getPlayingVideo() + 1
            if (nextFileRow < playList.playlistView.count) {
                const nextFile = playListModel.getPath(nextFileRow)
                window.openFile(nextFile, true, false)
                playListModel.setPlayingVideo(nextFileRow)
            }
        }
    }

    Action {
        id: playPreviousAction
        property var qaction: app.action("playPrevious")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["playPreviousAction"] = playPreviousAction

        onTriggered: {
            if (playListModel.getPlayingVideo() !== 0) {
                const previousFileRow = playListModel.getPlayingVideo() - 1
                const previousFile = playListModel.getPath(previousFileRow)
                window.openFile(previousFile, true, false)
                playListModel.setPlayingVideo(previousFileRow)
            }
        }
    }

    Action {
        id: openAction
        property var qaction: app.action("openFile")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["openAction"] = openAction

        onTriggered: fileDialog.open()
    }

    Action {
        id: openUrlAction
        property var qaction: app.action("openUrl")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["openUrlAction"] = openAction

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
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["seekForwardSmallAction"] = seekForwardSmallAction

        onTriggered: mpv.command(["seek", AppSettings.seekSmallStep, "exact"])
    }

    Action {
        id: seekBackwardSmallAction
        property var qaction: app.action("seekBackwardSmall")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["seekBackwardSmallAction"] = seekBackwardSmallAction

        onTriggered: mpv.command(["seek", -AppSettings.seekSmallStep, "exact"])
    }

    Action {
        id: seekForwardMediumAction
        property var qaction: app.action("seekForwardMedium")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["seekForwardMediumAction"] = seekForwardMediumAction

        onTriggered: mpv.command(["seek", AppSettings.seekMediumStep, "exact"])
    }

    Action {
        id: seekBackwardMediumAction
        property var qaction: app.action("seekBackwardMedium")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["seekBackwardMediumAction"] = seekBackwardMediumAction

        onTriggered: mpv.command(["seek", -AppSettings.seekMediumStep, "exact"])
    }

    Action {
        id: seekForwardBigAction
        property var qaction: app.action("seekForwardBig")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["seekForwardBigAction"] = seekForwardBigAction

        onTriggered: mpv.command(["seek", AppSettings.seekBigStep, "exact"])
    }

    Action {
        id: seekBackwardBigAction
        property var qaction: app.action("seekBackwardBig")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["seekBackwardBigAction"] = seekBackwardBigAction

        onTriggered: mpv.command(["seek", -AppSettings.seekBigStep, "exact"])
    }

    Action {
        id: seekPreviousChapterAction
        property var qaction: app.action("seekPreviousChapter")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["seekPreviousChapterAction"] = seekPreviousChapterAction

        onTriggered: {
            mpv.command(["add", "chapter", "-1"])
        }
    }

    Action {
        id: seekNextChapterAction
        property var qaction: app.action("seekNextChapter")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["seekNextChapterAction"] = seekNextChapterAction

        onTriggered: {
            const chapters = mpv.getProperty("chapter-list")
            const currentChapter = mpv.getProperty("chapter")
            const nextChapter = currentChapter + 1
            if (nextChapter === chapters.length) {
                playNextAction.trigger()
                return
            }
            mpv.command(["add", "chapter", "1"])
        }
    }

    Action {
        id: seekNextSubtitleAction
        property var qaction: app.action("seekNextSubtitle")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["seekNextSubtitleAction"] = seekNextSubtitleAction

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
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["seekPrevSubtitleAction"] = seekPrevSubtitleAction

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
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["frameStepAction"] = frameStepAction

        onTriggered: mpv.command(["frame-step"])
    }

    Action {
        id: frameBackStepAction
        property var qaction: app.action("frameBackStep")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["frameBackStepAction"] = frameBackStepAction

        onTriggered: mpv.command(["frame-back-step"])
    }

    Action {
        id: increasePlayBackSpeedAction
        property var qaction: app.action("increasePlayBackSpeed")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["increasePlayBackSpeedAction"] = increasePlayBackSpeedAction

        onTriggered: {
            mpv.setProperty("speed", mpv.getProperty("speed") + 0.1)
            osd.message(`Speed: ${mpv.getProperty("speed").toFixed(2)}`)
        }
    }

    Action {
        id: decreasePlayBackSpeedAction
        property var qaction: app.action("decreasePlayBackSpeed")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["decreasePlayBackSpeedAction"] = decreasePlayBackSpeedAction

        onTriggered: {
            mpv.setProperty("speed", mpv.getProperty("speed") - 0.1)
            osd.message(`Speed: ${mpv.getProperty("speed").toFixed(2)}`)
        }
    }

    Action {
        id: resetPlayBackSpeedAction
        property var qaction: app.action("resetPlayBackSpeed")
        text: qaction.text
        shortcut: qaction.shortcutName()
        icon.name: qaction.iconName()

        Component.onCompleted: list["resetPlayBackSpeedAction"] = resetPlayBackSpeedAction

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

        Component.onCompleted: list["playPauseAction"] = playPauseAction

        onTriggered: mpv.setProperty("pause", !mpv.getProperty("pause"))
    }

    Action {
        id: configureShortcutsAction
        property var qaction: app.action("options_configure_keybinding")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["configureShortcutsAction"] = configureShortcutsAction

        onTriggered: qaction.trigger()
    }

    Action {
        id: quitApplicationAction
        property var qaction: app.action("file_quit")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["quitApplicationAction"] = quitApplicationAction

        onTriggered: {
            if (mpv.position < mpv.duration - 10) {
                mpv.command(["quit-watch-later"])
            }
            qaction.trigger()
        }
    }

    Action {
        id: configureAction
        property var qaction: app.action("configure")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["configureAction"] = configureAction

        onTriggered: {
            if (settingsEditor.state === "visible") {
                settingsEditor.state = "hidden"
            } else {
                settingsEditor.state = "visible"
            }
        }
    }

    Action {
        id: subtitleQuickenAction
        property var qaction: app.action("subtitleQuicken")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["subtitleQuickenAction"] = subtitleQuickenAction

        onTriggered: {
            mpv.setProperty("sub-delay", mpv.getProperty("sub-delay") - 0.1)
            osd.message(`Subtitle timing: ${mpv.getProperty("sub-delay").toFixed(2)}`)
        }
    }

    Action {
        id: subtitleDelayAction
        property var qaction: app.action("subtitleDelay")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["subtitleDelayAction"] = subtitleDelayAction

        onTriggered: {
            mpv.setProperty("sub-delay", mpv.getProperty("sub-delay") + 0.1)
            osd.message(`Subtitle timing: ${mpv.getProperty("sub-delay").toFixed(2)}`)
        }
    }

    Action {
        id: subtitleToggleAction
        property var qaction: app.action("subtitleToggle")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["subtitleToggleAction"] = subtitleToggleAction

        onTriggered: {
            const visible = mpv.getProperty("sub-visibility")
            const message = visible ? "Subtitles off" : "Subtitles on"
            mpv.setProperty("sub-visibility", !visible)
            osd.message(message)
        }
    }

    Action {
        id: audioCycleUpAction
        property var qaction: app.action("audioCycleUp")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["audioCycleUpAction"] = audioCycleUpAction

        onTriggered: {
            const tracks = mpv.getProperty("track-list")
            let audioTracksCount = 0
            tracks.forEach(t => { if(t.type === "audio") ++audioTracksCount })

            if (audioTracksCount > 1) {
                mpv.command(["cycle", "aid", "up"])
                const currentTrackId = mpv.getProperty("aid")

                if (currentTrackId === false) {
                    audioCycleUpAction.trigger()
                    return
                }
                const track = tracks.find(t => t.type === "audio" && t.id === currentTrackId)
                const message = `Audio: ${currentTrackId} (${track.lang})`
                osd.message(message)
            }
        }
    }

    Action {
        id: audioCycleDownAction
        property var qaction: app.action("audioCycleDown")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["audioCycleDownAction"] = audioCycleDownAction

        onTriggered: {
            const tracks = mpv.getProperty("track-list")
            let audioTracksCount = 0
            tracks.forEach(t => { if(t.type === "audio") ++audioTracksCount })

            if (audioTracksCount > 1) {
                mpv.command(["cycle", "aid", "down"])
                const currentTrackId = mpv.getProperty("aid")

                if (currentTrackId === false) {
                    audioCycleDownAction.trigger()
                    return
                }
                const track = tracks.find(t => t.type === "audio" && t.id === currentTrackId)
                const message = `Audio: ${currentTrackId} (${track.lang})`
                osd.message(message)
            }
        }
    }

    Action {
        id: subtitleCycleUpAction
        property var qaction: app.action("subtitleCycleUp")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["subtitleCycleUpAction"] = subtitleCycleUpAction

        onTriggered: {
            mpv.command(["cycle", "sid", "up"])
            const currentTrackId = mpv.getProperty("sid")
            let message;
            if (currentTrackId === false) {
                message = `Subtitle: None`
            } else {
                const tracks = mpv.getProperty("track-list")
                const track = tracks.find(t => t.type === "sub" && t.id === currentTrackId)
                message = `Subtitle: ${currentTrackId} (${track.lang})`
            }
            osd.message(message)
        }
    }

    Action {
        id: subtitleCycleDownAction
        property var qaction: app.action("subtitleCycleDown")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["subtitleCycleDownAction"] = subtitleCycleDownAction

        onTriggered: {
            mpv.command(["cycle", "sid", "down"])
            const currentTrackId = mpv.getProperty("sid")
            let message;
            if (currentTrackId === false) {
                message = `Subtitle: None`
            } else {
                const tracks = mpv.getProperty("track-list")
                const track = tracks.find(t => t.type === "sub" && t.id === currentTrackId)
                message = `Subtitle: ${currentTrackId} (${track.lang})`
            }
            osd.message(message)
        }
    }

    Action {
        id: contrastUpAction
        property var qaction: app.action("contrastUp")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["contrastUpAction"] = contrastUpAction

        onTriggered: {
            const contrast = parseInt(mpv.getProperty("contrast")) + 1
            mpv.setProperty("contrast", `${contrast}`)
            osd.message(`Contrast: ${contrast}`)
        }
    }
    Action {
        id: contrastDownAction
        property var qaction: app.action("contrastDown")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["contrastDownAction"] = contrastDownAction

        onTriggered: {
            const contrast = parseInt(mpv.getProperty("contrast")) - 1
            mpv.setProperty("contrast", `${contrast}`)
            osd.message(`Contrast: ${contrast}`)
        }
    }
    Action {
        id: contrastResetAction
        property var qaction: app.action("contrastReset")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["contrastResetAction"] = contrastResetAction

        onTriggered: {
            mpv.setProperty("contrast", `0`)
            osd.message(`Contrast: 0`)
        }
    }

    Action {
        id: brightnessUpAction
        property var qaction: app.action("brightnessUp")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["brightnessUpAction"] = brightnessUpAction

        onTriggered: {
            const brightness = parseInt(mpv.getProperty("brightness")) + 1
            mpv.setProperty("brightness", `${brightness}`)
            osd.message(`Brightness: ${brightness}`)
        }
    }
    Action {
        id: brightnessDownAction
        property var qaction: app.action("brightnessDown")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["brightnessDownAction"] = brightnessDownAction

        onTriggered: {
            const brightness = parseInt(mpv.getProperty("brightness")) - 1
            mpv.setProperty("brightness", `${brightness}`)
            osd.message(`Brightness: ${brightness}`)
        }
    }
    Action {
        id: brightnessResetAction
        property var qaction: app.action("brightnessReset")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["brightnessResetAction"] = brightnessResetAction

        onTriggered: {
            mpv.setProperty("brightness", `0`)
            osd.message(`Brightness: 0`)
        }
    }
    Action {
        id: gammaUpAction
        property var qaction: app.action("gammaUp")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["gammaUpAction"] = gammaUpAction

        onTriggered: {
            const gamma = parseInt(mpv.getProperty("gamma")) + 1
            mpv.setProperty("gamma", `${gamma}`)
            osd.message(`Gamma: ${gamma}`)
        }
    }
    Action {
        id: gammaDownAction
        property var qaction: app.action("gammaDown")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["gammaDownAction"] = gammaDownAction

        onTriggered: {
            const gamma = parseInt(mpv.getProperty("gamma")) - 1
            mpv.setProperty("gamma", `${gamma}`)
            osd.message(`Gamma: ${gamma}`)
        }
    }
    Action {
        id: gammaResetAction
        property var qaction: app.action("gammaReset")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["gammaResetAction"] = gammaResetAction

        onTriggered: {
            mpv.setProperty("gamma", `0`)
            osd.message(`Gamma: 0`)
        }
    }
    Action {
        id: saturationUpAction
        property var qaction: app.action("saturationUp")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["saturationUpAction"] = saturationUpAction

        onTriggered: {
            const saturation = parseInt(mpv.getProperty("saturation")) + 1
            mpv.setProperty("saturation", `${saturation}`)
            osd.message(`Saturation: ${saturation}`)
        }
    }
    Action {
        id: saturationDownAction
        property var qaction: app.action("saturationDown")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["saturationDownAction"] = saturationDownAction

        onTriggered: {
            const saturation = parseInt(mpv.getProperty("saturation")) - 1
            mpv.setProperty("saturation", `${saturation}`)
            osd.message(`Saturation: ${saturation}`)
        }
    }
    Action {
        id: saturationResetAction
        property var qaction: app.action("saturationReset")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["saturationResetAction"] = saturationResetAction

        onTriggered: {
            mpv.setProperty("saturation", `0`)
            osd.message(`Saturation: 0`)
        }
    }

    Action {
        id: zoomInAction
        property var qaction: app.action("zoomIn")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["zoomInAction"] = zoomInAction

        onTriggered: {
            const zoom = mpv.getProperty("video-zoom") + 0.1
            mpv.setProperty("video-zoom", zoom)
            osd.message(`Zoom: ${zoom.toFixed(2)}`)
        }
    }

    Action {
        id: zoomOutAction
        property var qaction: app.action("zoomOut")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["zoomOutAction"] = zoomOutAction

        onTriggered: {
            const zoom = mpv.getProperty("video-zoom") - 0.1
            mpv.setProperty("video-zoom", zoom)
            osd.message(`Zoom: ${zoom.toFixed(2)}`)
        }
    }
    Action {
        id: zoomResetAction
        property var qaction: app.action("zoomReset")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["zoomResetAction"] = zoomResetAction

        onTriggered: {
            mpv.setProperty("video-zoom", 0)
            osd.message(`Zoom: 0`)
        }
    }


    Action {
        id: videoPanXLeftAction
        property var qaction: app.action("videoPanXLeft")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["videoPanXLeftAction"] = videoPanXLeftAction

        onTriggered: {
            const pan = mpv.getProperty("video-pan-x") - 0.01
            mpv.setProperty("video-pan-x", pan)
            osd.message(`Video pan x: ${pan.toFixed(2)}`)
        }
    }
    Action {
        id: videoPanXRightAction
        property var qaction: app.action("videoPanXRight")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["videoPanXRightAction"] = videoPanXRightAction

        onTriggered: {
            const pan = mpv.getProperty("video-pan-x") + 0.01
            mpv.setProperty("video-pan-x", pan)
            osd.message(`Video pan x: ${pan.toFixed(2)}`)
        }
    }
    Action {
        id: videoPanYUpAction
        property var qaction: app.action("videoPanYUp")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["videoPanYUpAction"] = videoPanYUpAction

        onTriggered: {
            const pan = mpv.getProperty("video-pan-y") - 0.01
            mpv.setProperty("video-pan-y", pan)
            osd.message(`Video pan x: ${pan.toFixed(2)}`)
        }
    }
    Action {
        id: videoPanYDownAction
        property var qaction: app.action("videoPanYDown")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["videoPanYDownAction"] = videoPanYDownAction

        onTriggered: {
            const pan = mpv.getProperty("video-pan-y") + 0.01
            mpv.setProperty("video-pan-y", pan)
            osd.message(`Video pan x: ${pan.toFixed(2)}`)
        }
    }

    Action {
        id: toggleFullscreenAction
        property var qaction: app.action("toggleFullscreen")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["toggleFullscreenAction"] = toggleFullscreenAction

        onTriggered: {
            mpv.toggleFullScreen()
        }
    }

    Action {
        id: toggleMenuBarAction
        property var qaction: app.action("toggleMenuBar")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["toggleMenuBarAction"] = toggleMenuBarAction

        onTriggered: {
            menuBar.visible = !menuBar.visible
            AppSettings.viewIsMenuBarVisible = menuBar.visible
        }
    }

    Action {
        id: toggleHeaderAction
        property var qaction: app.action("toggleHeader")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["toggleHeaderAction"] = toggleHeaderAction

        onTriggered: {
            header.visible = !header.visible
            AppSettings.viewIsHeaderVisible = header.visible
        }
    }

    Action {
        id: screenshotAction
        property var qaction: app.action("screenshot")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["screenshotAction"] = screenshotAction

        onTriggered: mpv.command(["screenshot"])
    }

    Action {
        id: setLoopAction
        property var qaction: app.action("setLoop")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["setLoopAction"] = setLoopAction

        onTriggered: {
            var a = mpv.getProperty("ab-loop-a")
            var b = mpv.getProperty("ab-loop-b")

            var aIsSet = a !== "no"
            var bIsSet = b !== "no"

            if (!aIsSet && !bIsSet) {
                mpv.setProperty("ab-loop-a", mpv.position)
                footer.progressBar.loopIndicator.startPosition = mpv.position
                osd.message("Loop start: " + app.formatTime(mpv.position))
            } else if (aIsSet && !bIsSet) {
                mpv.setProperty("ab-loop-b", mpv.position)
                footer.progressBar.loopIndicator.endPosition = mpv.position
                osd.message(`Loop: ${app.formatTime(a)} - ${app.formatTime(mpv.position)}`)
            } else if (aIsSet && bIsSet) {
                mpv.setProperty("ab-loop-a", "no")
                mpv.setProperty("ab-loop-b", "no")
                footer.progressBar.loopIndicator.startPosition = -1
                footer.progressBar.loopIndicator.endPosition = -1
                osd.message("Loop cleared")
            }
        }
    }

    Action {
        id: increaseSubtitleFontSizeAction
        property var qaction: app.action("increaseSubtitleFontSize")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["increaseSubtitleFontSizeAction"] = increaseSubtitleFontSizeAction

        onTriggered: {
            mpv.command(["add", "sub-scale", "+0.1"])
            osd.message(qsTr("Subtitle scale: " + mpv.getProperty("sub-scale").toFixed(1)))
        }
    }

    Action {
        id: decreaseSubtitleFontSizeAction
        property var qaction: app.action("decreaseSubtitleFontSize")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["decreaseSubtitleFontSizeAction"] = decreaseSubtitleFontSizeAction

        onTriggered: {
            mpv.command(["add", "sub-scale", "-0.1"])
            osd.message(qsTr("Subtitle scale: " + mpv.getProperty("sub-scale").toFixed(1)))
        }
    }

    Action {
        id: subtitlePositionUpAction
        property var qaction: app.action("subtitlePositionUp")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["subtitlePositionUpAction"] = subtitlePositionUpAction

        onTriggered: {
            mpv.command(["add", "sub-pos", "-1"])
        }
    }

    Action {
        id: subtitlePositionDownAction
        property var qaction: app.action("subtitlePositionDown")
        text: qaction.text
        icon.name: qaction.iconName()
        shortcut: qaction.shortcutName()

        Component.onCompleted: list["subtitlePositionDownAction"] = subtitlePositionDownAction

        onTriggered: {
            mpv.command(["add", "sub-pos", "+1"])
        }
    }
}
