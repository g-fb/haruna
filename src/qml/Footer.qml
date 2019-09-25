import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

ToolBar {
    id: root

    property alias progressBar: progressBar
    property alias footerRow: footerRow
    property alias timeInfo: timeInfo
    property alias playPauseButton: playPauseButton
    property var muteVolume: app.action("mute")
    property var playNext: app.action("playNext")
    property var playPrevious: app.action("playPrevious")

    contentHeight: 40
    contentWidth: window.width
    position: ToolBar.Footer

    RowLayout {
        id: footerRow
        anchors.fill: parent

        ToolButton {
            id: playPauseButton
            action: playPauseAction
            text: ""
            icon.name: "media-playback-start"
        }

        ToolButton {
            id: playPreviousFile
            action: playPreviousAction
            text: ""

            ToolTip {
                text: qsTr("Play Previous File")
            }
        }

        ToolButton {
            id: playNextFile
            action: playNextAction
            text: ""

            ToolTip {
                text: qsTr("Play Next File")
            }
        }

        Label {
            id: timeInfo
            property string totalTime
            property string currentTime
            property string remainingTime

            text: currentTime + " / " + totalTime

            ToolTip {
                id: timeToolTip
                visible: false
                timeout: -1
                text: qsTr("Remaining: ") + timeInfo.remainingTime
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: timeToolTip.visible = true
                onExited: timeToolTip.visible = false
            }
        }

        VideoProgressBar {
            id: progressBar
            Layout.fillWidth: true
        }

        ToolButton {
            id: mute
            action: muteAction
            text: ""

            ToolTip {
                text: muteAction.text
            }
        }

        Action {
            id: muteAction
            text: muteVolume.text
            shortcut: muteVolume.shortcut
            icon.name: app.iconName(muteVolume.icon)
            onTriggered: {
                mpv.setProperty("mute", !mpv.getProperty("mute"))
                if (mpv.getProperty("mute")) {
                    text = qsTr("Unmute")
                    icon.name = "player-volume-muted"
                } else {
                    text = muteVolume.text
                    icon.name = app.iconName(muteVolume.icon)
                }
            }
        }

        Action {
            id: playNextAction
            text: playNext.text
            shortcut: playNext.shortcut
            icon.name: app.iconName(playNext.icon)
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
            text: playPrevious.text
            shortcut: playPrevious.shortcut
            icon.name: app.iconName(playPrevious.icon)
            onTriggered: {
                if (videoList.getPlayingVideo() !== 0) {
                    var previousFileRow = videoList.getPlayingVideo() - 1
                    var nextFile = videoList.getPath(previousFileRow)
                    window.openFile(nextFile, true, false)
                    videoList.setPlayingVideo(previousFileRow)
                }
            }
        }
    }
}
