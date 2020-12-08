/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtQuick.Window 2.12
import mpv 1.0

import com.georgefb.haruna 1.0

MpvObject {
    id: root

    property int mx
    property int my
    property string file
    property alias scrollPositionTimer: scrollPositionTimer

    signal setSubtitle(int id)
    signal setSecondarySubtitle(int id)
    signal setAudio(int id)

    width: parent.width
    height: parent.height - footer.height
    anchors.left: settingsEditor.right
    anchors.right: parent.right
    anchors.fill: window.isFullScreen() ? parent : undefined
    volume: GeneralSettings.volume

    onFileChanged: {
        setProperty("ytdl-format", PlaybackSettings.ytdlFormat)
        command(["loadfile", file])
        GeneralSettings.lastPlayedFile = file
        GeneralSettings.save()
    }

    onSetSubtitle: {
        setProperty("sid", id)
    }

    onSetSecondarySubtitle: {
        setProperty("secondary-sid", id)
    }

    onSetAudio: {
        setProperty("aid", id)
    }

    onReady: {
        setProperty("screenshot-template", VideoSettings.screenshotTemplate)
        setProperty("screenshot-format", VideoSettings.screenshotFormat)
        const preferredAudioTrack = AudioSettings.preferredTrack
        setProperty("aid", preferredAudioTrack === 0 ? "auto" : preferredAudioTrack)
        setProperty("alang", AudioSettings.preferredLanguage)

        const preferredSubTrack = SubtitlesSettings.preferredTrack
        setProperty("sid", preferredSubTrack === 0 ? "auto" : preferredSubTrack)
        setProperty("slang", SubtitlesSettings.preferredLanguage)
        setProperty("sub-file-paths", SubtitlesSettings.subtitlesFolders.join(":"))

        if (app.argument(0) !== "") {
            window.openFile(app.argument(0), true, PlaylistSettings.loadSiblings)
        } else {
            // open last played file, paused and
            // at the position when player was closed or last saved
            window.openFile(GeneralSettings.lastPlayedFile, false, PlaylistSettings.loadSiblings)
        }
    }

    onFileLoaded: {
        header.audioTracks = getProperty("track-list").filter(track => track["type"] === "audio")
        header.subtitleTracks = getProperty("track-list").filter(track => track["type"] === "sub")

        if (playList.playlistView.count <= 1) {
            setProperty("loop-file", "inf")
        }

        setProperty("ab-loop-a", "no")
        setProperty("ab-loop-b", "no")
    }

    onChapterChanged: {
        if (!PlaybackSettings.skipChapters) {
            return
        }

        const chapters = mpv.getProperty("chapter-list")
        const chaptersToSkip = PlaybackSettings.chaptersToSkip
        if (chapters.length === 0 || chaptersToSkip === "") {
            return
        }

        const words = chaptersToSkip.split(",")
        for (let i = 0; i < words.length; ++i) {
            if (chapters[mpv.chapter] && chapters[mpv.chapter].title.toLowerCase().includes(words[i].trim())) {
                actions.seekNextChapterAction.trigger()
                if (PlaybackSettings.showOsdOnSkipChapters) {
                    osd.message(qsTr("Skipped chapter: %1").arg(chapters[mpv.chapter-1].title))
                }
                // a chapter title can match multiple words
                // return to prevent skipping multiple chapters
                return
            }
        }
    }

    onEndOfFile: {
        const nextFileRow = playListModel.getPlayingVideo() + 1
        if (nextFileRow < playList.playlistView.count) {
            const nextFile = playListModel.getPath(nextFileRow)
            mpv.command(["loadfile", nextFile])
            playListModel.setPlayingVideo(nextFileRow)
        } else {
            // Last file in playlist
            if (PlaylistSettings.repeat) {
                mpv.command(["loadfile", playListModel.getPath(0)])
                playListModel.setPlayingVideo(0)
            }
        }
    }

    onPauseChanged: {
        if (pause) {
            footer.playPauseButton.icon.name = "media-playback-start"
            lockManager.setInhibitionOff()
        } else {
            footer.playPauseButton.icon.name = "media-playback-pause"
            lockManager.setInhibitionOn()
        }
    }

    Timer {
        id: scrollPositionTimer
        interval: 50; running: true; repeat: true

        onTriggered: {
            setPlayListScrollPosition()
            scrollPositionTimer.stop()
        }
    }

    Timer {
        id: saveWatchLaterFileTimer
        interval: 1000
        running: !mpv.pause
        repeat: true

        onTriggered: {
            if (mpv.position < mpv.duration - 10) {
                command(["write-watch-later-config"])
            }
        }
    }

    Timer {
        id: hideCursorTimer

        property int tx: mx
        property int ty: my
        property int timeNotMoved: 0

        interval: 50; running: true; repeat: true

        onTriggered: {
            if (!window.isFullScreen()) {
                return;
            }
            if (mx === tx && my === ty) {
                if (timeNotMoved > 2000) {
                    app.hideCursor()
                }
            } else {
                app.showCursor()
                timeNotMoved = 0
            }
            tx = mx
            ty = my
            timeNotMoved += interval
        }
    }

    MouseArea {
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        anchors.fill: parent
        hoverEnabled: true

        onEntered: hideCursorTimer.running = true

        onExited: hideCursorTimer.running = false

        onMouseXChanged: {
            mx = mouseX
            if (playList.position === "right") {
                if (mouseX > width - 50 && playList.playlistView.count > 1) {
                    if (playList.canToggleWithMouse) {
                        playList.state = "visible"
                    }
                }
                if (mouseX < width - playList.width) {
                    if (playList.canToggleWithMouse) {
                        playList.state = "hidden"
                    }
                }
            } else {
                if (mouseX < 50 && playList.playlistView.count > 1) {
                    if (playList.canToggleWithMouse) {
                        playList.state = "visible"
                    }
                }
                if (mouseX > playList.width) {
                    if (playList.canToggleWithMouse) {
                        playList.state = "hidden"
                    }
                }
            }
        }

        onMouseYChanged: {
            my = mouseY
        }

        onWheel: {
            if (wheel.angleDelta.y > 0) {
                if (MouseSettings.scrollUp) {
                    actions[MouseSettings.scrollUp].trigger()
                }
            } else if (wheel.angleDelta.y) {
                if (MouseSettings.scrollDown) {
                    actions[MouseSettings.scrollDown].trigger()
                }
            }
        }

        onPressed: {
            focus = true
            if (mouse.button === Qt.LeftButton) {
                if (MouseSettings.left) {
                    actions[MouseSettings.left].trigger()
                }
            } else if (mouse.button === Qt.MiddleButton) {
                if (MouseSettings.middle) {
                    actions[MouseSettings.middle].trigger()
                }
            } else if (mouse.button === Qt.RightButton) {
                if (MouseSettings.right) {
                    actions[MouseSettings.right].trigger()
                }
            }
        }

        onDoubleClicked: {
            if (mouse.button === Qt.LeftButton) {
                if (MouseSettings.leftx2) {
                    actions[MouseSettings.leftx2].trigger()
                }
            } else if (mouse.button === Qt.MiddleButton) {
                if (MouseSettings.middlex2) {
                    actions[MouseSettings.middlex2].trigger()
                }
            } else if (mouse.button === Qt.RightButton) {
                if (MouseSettings.rightx2) {
                    actions[MouseSettings.rightx2].trigger()
                }
            }
        }
    }

    DropArea {
        id: dropArea
        anchors.fill: parent
        keys: ["text/uri-list"]

        onDropped: {
            window.openFile(drop.urls[0], true, PlaylistSettings.loadSiblings)
        }
    }

    function toggleFullScreen() {
        if (!window.isFullScreen()) {
            settingsEditor.state = "hidden"
            window.showFullScreen()
        } else {
            if (window.preFullScreenVisibility === Window.Windowed) {
                window.showNormal()
            }
            if (window.preFullScreenVisibility === Window.Maximized) {
                window.show()
                window.showMaximized()
            }
        }
        app.showCursor()
        scrollPositionTimer.start()
    }

    function setPlayListScrollPosition() {
        playList.playlistView.positionViewAtIndex(playListModel.playingVideo, ListView.Beginning)
    }

}
