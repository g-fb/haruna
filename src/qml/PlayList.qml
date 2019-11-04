import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Window 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13

Rectangle {
    id: root

    property alias tableView: tableView

    height: mpv.height
    width: (parent.width * 0.33) < 550 ? 550 : parent.width * 0.33
    x: parent.width

    onWidthChanged: {
        tableView.columnWidthProvider = function (column) { return tableView.columnWidths[column] }
    }

    TableView {
        id: tableView
        property var columnWidths: [50, parent.width - 150, 110]

        anchors.fill: parent
        clip: true
        columnSpacing: 1
        columnWidthProvider: function (column) { return columnWidths[column] }
        delegate: PlayListItem {}
        rowSpacing: 1
        model: videoListModel
        z: 20
        ScrollBar.vertical: ScrollBar { id: scrollBar }
    }

    MouseArea {
        anchors.fill: parent
        onWheel: wheel.accepted = true
    }

    ShaderEffectSource {
        id: shaderEffect
        anchors.fill: parent
        sourceItem: mpv
        sourceRect: Qt.rect(mpv.width - width, mpv.height - height, parent.width, parent.height)
    }

    FastBlur {
        anchors.fill: shaderEffect
        radius: 100
        source: shaderEffect
        z: 10
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges { target: playList; x: parent.width }
        },
        State {
            name : "visible"
            PropertyChanges { target: playList; x: parent.width - root.width }
        }
    ]

    transitions: Transition {
        PropertyAnimation { properties: "x"; easing.type: Easing.Linear; duration: 100 }
    }
}
