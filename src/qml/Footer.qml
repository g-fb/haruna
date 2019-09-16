import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

ToolBar {
    id: root

    property alias progressBar: progressBar
    property alias footerRow: footerRow
    property alias timeInfo: timeInfo

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
    }
}
