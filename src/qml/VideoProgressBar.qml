import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQml 2.13
import QtQuick.Shapes 1.13

Slider {
    id: root

    property var chapters
    property bool seekStarted: false
    property int seekValue: 0

    SystemPalette { id: systemPalette; colorGroup: SystemPalette.Active }

    background: Rectangle {
        id: slider
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

    Instantiator {
        id: chaptersInstantiator
        model: chapters
        delegate: Shape {
            id: shape
            property int h: ((((modelData.time * 100) / root.to) * slider.width) / 100)
            antialiasing: true
            parent: slider
            ShapePath {
                strokeWidth: 1
                strokeColor: systemPalette.text
                startX: shape.h
                startY: root.height
                fillColor: systemPalette.text
                PathLine { x: shape.h; y: -1 }
                PathLine { x: shape.h + 6; y: -7 }
                PathLine { x: shape.h - 7; y: -7 }
                PathLine { x: shape.h-1; y: -1 }
            }
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
