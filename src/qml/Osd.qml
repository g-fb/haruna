import QtQuick 2.13
import QtQuick.Controls 2.13

Item {
    property alias timer: osdTimer
    property alias label: root

    function message(text) {
        osd.label.text = text
        if(osd.label.visible) {
            osd.timer.restart()
        } else {
            osd.timer.start()
        }
        osd.label.visible = true
    }

    Label {
        id: root
        x: 10
        y: 10
        visible: false
        background: Rectangle {
            color: systemPalette.base
        }
        text: ""
        padding: 5
    }

    Timer {
        id: osdTimer
        running: false
        repeat: false

        onTriggered: {
            root.visible = false
        }
    }

}
