import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

Slider {
    id: root

    property bool seekStarted: false
    property int seekValue: 0

    SystemPalette { id: systemPalette; colorGroup: SystemPalette.Active }

    background: Rectangle {
        color: systemPalette.base
        implicitWidth: 200
        implicitHeight: 25
        height: implicitHeight
        radius: 0
        width: availableWidth
        x: leftPadding
        y: topPadding + availableHeight / 2 - height / 2

        Rectangle {
            color: systemPalette.highlight
            radius: 0
            height: parent.height
            width: visualPosition * parent.width
        }
    }

    handle: Rectangle {
        border.color: systemPalette.light
        color: systemPalette.light
        implicitWidth: 0
        implicitHeight: 35
        radius: 0
        x: leftPadding + visualPosition * (availableWidth - width)
        y: topPadding + availableHeight / 2 - height / 2
    }

    onValueChanged: {
        if (seekStarted) {
            seekValue = value
        }
        settings.lastPlayedPosition = value
    }

    onPressedChanged: {
        if (pressed) {
            seekStarted = true;
            seekValue = value
        } else {
            mpv.command(["seek", value, "absolute"])
            seekStarted = false;
        }
    }
}
