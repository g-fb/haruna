import QtQuick 2.13
import QtQuick.Controls 2.13

Item {
    id: root

    function message(text) {
        label.text = text
        if(label.visible) {
            timer.restart()
        } else {
            timer.start()
        }
        label.visible = true
    }

    Label {
        id: label
        x: 10
        y: 10
        visible: false
        background: Rectangle {
            color: systemPalette.base
        }
        padding: 5
    }

    Timer {
        id: timer
        running: false
        repeat: false

        onTriggered: {
            label.visible = false
        }
    }

}
