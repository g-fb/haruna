import QtQuick 2.13
import QtQuick.Controls 2.13

Item {
    id: root

    function message(text) {
        var osdFontSize = parseInt(app.setting("General", "OsdFontSize", 25))
        label.text = text
        label.font.pixelSize = osdFontSize
        console.log(osdFontSize)
        if (osdFontSize === 0) {
            return;
        }

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
        font.pixelSize: parseInt(app.setting("General", "OsdFontSize", 25))
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
