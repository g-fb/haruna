import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13

Item {
    id: root

    property string path: model.path

    implicitHeight: playList.rowHeight

    Rectangle {
        anchors.fill: parent
        color: {
            if (model.isHovered && model.isPlaying) {
                Qt.rgba(0.14, 0.15, 0.16, 0.9)
            } else if (model.isHovered && !model.isPlaying) {
                Qt.rgba(0.14, 0.15, 0.16, 0.8)
            } else if (!model.isHovered && model.isPlaying) {
                Qt.rgba(0.14, 0.5, 0.5, 0.5)
            } else {
                Qt.rgba(0.14, 0.15, 0.16, 0.5)
            }
        }

        Label {
            id: label
            anchors.centerIn: {if (column === 0) {parent} else {undefined}}
            anchors.left: {if (column === 1) {parent.left} else {undefined}}
            anchors.right: {if (column === 2) {parent.right} else {undefined}}
            anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideRight
            font.bold: true
            font.pointSize: 12
            layer.enabled: true
            color: "#fff"
            layer.effect: DropShadow { verticalOffset: 1; color: "#111"; radius: 5; spread: 0.3; samples: 17 }
            leftPadding: 10
            rightPadding: column === 2 ? 20 + scrollBar.width : 10

            text: model.name
            width: {if (column === 1) {tableView.columnWidths[column]}}

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
            if (column === 1 && label.truncated) {
                toolTip.visible = true
            }
        }

        onExited: {
            toolTip.visible = false
        }

        onDoubleClicked: {
            if (mouse.button === Qt.LeftButton) {
                window.openFile(model.path, true, false)
                videoList.setPlayingVideo(row)
            }
        }
    }
}
