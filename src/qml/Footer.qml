import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

ToolBar {
    id: root

    property alias progressBar: progressBar
    property alias footerRow: footerRow

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
        }

        ToolButton {
            id: seekBackwardButton
            action: seekBackwardAction
            text: ""
        }

        ToolButton {
            id: seekForwardButton
            action: seekForwardAction
            text: ""
        }

        VideoProgressBar {
            id: progressBar
            Layout.fillWidth: true
            rightPadding: 10
        }

        Text {
            id: time
            property string formattedDuration
            property string formattedPosition
            property string toolTipText

            Layout.preferredWidth: 120
            color: "#fff"
            text: formattedPosition + " / " + formattedDuration

            ToolTip {
                id: timeToolTip
                visible: false
                text: qsTr("Remaining: ") + time.toolTipText
            }

            Connections {
                target: window
                onPositionChanged: {
                    var p = mpv.formatTime(position)
                    time.formattedPosition = p
                }
            }

            Connections {
                target: window
                onRemainingChanged: {
                    var r = mpv.formatTime(remaining)
                    time.toolTipText = r
                }
            }

            Connections {
                target: window
                onDurationChanged: {
                    var d = mpv.formatTime(duration)
                    time.formattedDuration = d
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: timeToolTip.visible = true
                onExited: timeToolTip.visible = false
            }
        }
    }
}
