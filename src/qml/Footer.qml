import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

ToolBar {
    id: root

    property alias progressBar: progressBar
    property alias footerRow: footerRow
    property alias timeInfo: timeInfo
    property alias playPauseButton: playPauseButton
    property alias volume: volume

    anchors.left: parent.left
    anchors.right: parent.right
    y: mpv.height
    padding: 5
    position: ToolBar.Footer

    RowLayout {
        id: footerRow
        anchors.fill: parent

        ToolButton {
            icon.name: "application-menu"
            visible: !menuBar.visible
            onClicked: {
                if (mpvContextMenu.visible) {
                    return
                }

                mpvContextMenu.visible = !mpvContextMenu.visible
                var menuHeight = mpvContextMenu.count * mpvContextMenu.itemAt(0).height
                mpvContextMenu.popup(footer, 0, -menuHeight)
            }
        }

        ToolButton {
            id: playPauseButton
            action: actions.playPauseAction
            text: ""
            icon.name: "media-playback-start"

            ToolTip {
                id: playPauseButtonToolTip
                Connections {
                    target: mpv
                    onPauseChanged: {
                        if (mpv.pause) {
                            playPauseButtonToolTip.text = "Start Playback"
                        } else {
                            playPauseButtonToolTip.text = "Pause Playback"
                        }
                    }
                }
            }
        }

        ToolButton {
            id: playPreviousFile
            action: actions.playPreviousAction
            text: ""

            ToolTip {
                text: qsTr("Play Previous File")
            }
        }

        ToolButton {
            id: playNextFile
            action: actions.playNextAction
            text: ""

            ToolTip {
                text: qsTr("Play Next File")
            }
        }

        HProgressBar {
            id: progressBar
            Layout.fillWidth: true
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

            Connections {
                target: mpv
                onDurationChanged: {
                    timeInfo.totalTime = mpv.formatTime(mpv.duration)
                }
                onPositionChanged: {
                    timeInfo.currentTime = mpv.formatTime(mpv.position)
                }
                onRemainingChanged: {
                    timeInfo.remainingTime = mpv.formatTime(mpv.remaining)
                }
            }
        }

        ToolButton {
            id: mute
            action: actions.muteAction
            text: ""

            ToolTip {
                text: actions.muteAction.text
            }
        }

        VolumeSlider { id: volume }
    }
}
