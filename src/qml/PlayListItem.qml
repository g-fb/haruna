import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Window 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13

Item {
    id: root

    property string path: model.path

    implicitHeight: playList.rowHeight + label.font.pixelSize / 2

    Rectangle {
        anchors.fill: parent
        color: {
            if (model.isHovered && model.isPlaying) {
                Qt.rgba(0.19, 0.21, 0.23, 1)
            } else if (model.isHovered && !model.isPlaying) {
                Qt.rgba(0.19, 0.21, 0.23, 1)
            } else if (!model.isHovered && model.isPlaying) {
                Qt.rgba(0.24, 0.68, 0.91, 1)
            } else {
                Qt.rgba(0.14, 0.15, 0.16, 0.5)
            }
        }

        Label {
            id: label

            anchors.fill: parent
            horizontalAlignment: column === 1 ? Qt.AlignLeft : Qt.AlignCenter
            elide: Text.ElideRight
            font.bold: true
            font.pointSize: {
                if (window.visibility === Window.FullScreen && playList.bigFont) {
                    return 18
                }
                return 12
            }
            layer.enabled: true
            color: "#fff"
            layer.effect: DropShadow { verticalOffset: 1; color: "#111"; radius: 5; spread: 0.3; samples: 17 }
            leftPadding: 10
            rightPadding: column === 2 ? scrollBar.width : 10

            text: model.name

            ToolTip {
                id: toolTip
                delay: 250
                visible: false
                text: model.name
            }
        }
    }

    MouseArea {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            playListModel.setHoveredVideo(row)
            if (column === 1 && label.truncated) {
                toolTip.visible = true
            }
        }

        onExited: {
            playListModel.clearHoveredVideo(row)
            toolTip.visible = false
        }

        onDoubleClicked: {
            if (mouse.button === Qt.LeftButton) {
                window.openFile(model.path, true, false)
                playListModel.setPlayingVideo(row)
            }
        }
    }
}
