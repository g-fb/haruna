import QtQuick 2.13
import QtQuick.Window 2.13
import mpv 1.0

MpvObject {
    id: root

    property int mx
    property int my
    property alias scrollPositionTimer: scrollPositionTimer
    signal setSubtitle(int id)
    signal setAudio(int id)

    function toggleFullScreen() {
        if (window.visibility !== Window.FullScreen) {
            window.showFullScreen()
            header.visible = false
            footer.visible = false
            fullscreenFooter.visible = false
            footer.footerRow.parent = fullscreenFooter
        } else {
            if (window.preFullScreenVisibility === Window.Windowed) {
                window.showNormal()
            }
            if (window.preFullScreenVisibility == Window.Maximized) {
                window.show()
                window.showMaximized()
            }
            header.visible = true
            footer.visible = true
            fullscreenFooter.visible = false
            footer.footerRow.parent = footer
        }
    }

    function setPlayListScrollPosition() {
        if (playList.tableView.rows <= 0) {
            return;
        }
        playList.tableView.contentY = 0
        // scroll playlist to loaded file
        var rowsAbove = videoList.getPlayingVideo()
        // 50 is row height, 1 is space between rows
        var scrollDistance = (rowsAbove * 50) + (rowsAbove * 1)
        var scrollAvailableDistance =
                ((playList.tableView.rows * 50) + (playList.tableView.rows * 1)) - root.height
        if (scrollDistance > scrollAvailableDistance) {
            if (scrollAvailableDistance < root.height) {
                playList.tableView.contentY = 0
            } else {
                playList.tableView.contentY = scrollAvailableDistance
            }
        } else {
            playList.tableView.contentY = scrollDistance
        }
    }

    anchors.fill: parent

    onSetSubtitle: {
        if (id !== -1) {
            root.setProperty("sid", id)
        } else {
            root.setProperty("sid", "no")
        }
    }

    onSetAudio: {
        root.setProperty("aid", id)
    }

    onReady: {
        root.setProperty("sub-file-paths", app.pathSetting("General", "SubtitlesFolders").join(":"))

        // open last played file, paused and
        // at the position when player was closed or last saved
        window.openFile(app.setting("General", "lastPlayedFile"), false, true)
        root.setProperty("start", "+" + app.setting("General", "lastPlayedPosition"))
        // set progress bar position
        footer.progressBar.from = 0;
        footer.progressBar.to = app.setting("General", "lastPlayedDuration")
        footer.progressBar.value = app.setting("General", "lastPlayedPosition")

        footer.timeInfo.currentTime = mpv.formatTime(app.setting("General", "lastPlayedPosition"))
        footer.timeInfo.totalTime = mpv.formatTime(app.setting("General", "lastPlayedDuration"))
    }

    onFileLoaded: {
        footer.progressBar.chapters = root.getProperty("chapter-list")
        header.audioTracks = root.getProperty("track-list").filter(track => track["type"] === "audio")
        header.subtitleTracks = root.getProperty("track-list").filter(track => track["type"] === "sub")
    }

    onDurationChanged: {
        footer.progressBar.from = 0;
        footer.progressBar.to = duration
        app.setSetting("General", "lastPlayedDuration", duration)

        footer.timeInfo.totalTime = mpv.formatTime(duration)
    }

    onPositionChanged: {
        if (!footer.progressBar.seekStarted) {
            footer.progressBar.value = position
        }
        footer.timeInfo.currentTime = mpv.formatTime(position)
    }

    onRemainingChanged: {
        footer.timeInfo.remainingTime = mpv.formatTime(remaining)
    }

    onEndOfFile: {
        var nextFileRow = videoList.getPlayingVideo() + 1
        if (nextFileRow < playList.tableView.rows) {
            var nextFile = videoList.getPath(nextFileRow)
            window.openFile(nextFile, true, false)
            videoList.setPlayingVideo(nextFileRow)
        }
    }

    onPauseChanged: {
        if (pause) {
            footer.playPauseButton.icon.name = "media-playback-start"
        } else {
            footer.playPauseButton.icon.name = "media-playback-pause"
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
        id: hideCursorTimer

        property int tx: mx
        property int ty: my
        property int timeNotMoved: 0

        interval: 50; running: true; repeat: true

        onTriggered: {
            if (window.visibility !== Window.FullScreen) {
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
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent
        hoverEnabled: true

        onEntered: hideCursorTimer.running = true

        onExited: hideCursorTimer.running = false

        onMouseXChanged: {
            root.focus = true
            mx = mouseX
            if (mouseX > root.width - 50 && playList.tableView.rows > 1) {
                playList.state = "visible"
            }
            if (mouseX < root.width - playList.width) {
                playList.state = "hidden"
            }
        }

        onMouseYChanged: {
            root.focus = true
            my = mouseY
            if (mouseY > window.height - footer.height && window.visibility === Window.FullScreen) {
                fullscreenFooter.visible = true
            } else if (mouseY < window.height - footer.height && window.visibility === Window.FullScreen) {
                fullscreenFooter.visible = false
            }
        }

        onClicked: {
            focus = true
            if (mouse.button === Qt.RightButton) {
                root.play_pause()
            }
        }

        onDoubleClicked: {
            if (mouse.button === Qt.LeftButton) {
                toggleFullScreen()
                setPlayListScrollPosition()
                app.showCursor()
            }
        }
    }

    DropArea {
        id: dropArea
        anchors.fill: parent
        keys: ["text/uri-list"]

        onDropped: {
            window.openFile(drop.urls[0], true, true)
        }
    }
}
