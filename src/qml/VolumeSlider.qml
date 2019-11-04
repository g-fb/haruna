import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQml 2.13
import QtQuick.Shapes 1.13
import QtGraphicalEffects 1.13

Slider {
    id: root

    from: 0
    to: 100
    implicitWidth: 100
    implicitHeight: 25
    wheelEnabled: true
    stepSize: settings.get("General", "VolumeStep")

    background: Rectangle {
        id: harunaSliderBG
        color: systemPalette.base

        Rectangle {
            color: systemPalette.highlight
            height: parent.height
            width: visualPosition * parent.width
        }
    }

    Label {
        id: progressBarToolTip
        text: root.value
        anchors.centerIn: root
        layer.enabled: true
        layer.effect: DropShadow { verticalOffset: 1; color: "#111"; radius: 5; spread: 0.3; samples: 17 }
    }

    onPressedChanged: {
        if (!pressed) {
            mpv.setProperty("volume", value.toFixed(0))
        }
    }
    onValueChanged: {

        mpv.setProperty("volume", value.toFixed(0))
        settings.set("General", "volume", value.toFixed(0))
    }

    Connections {
        target: mpv
        onVolumeChanged: value = mpv.volume
    }
    Connections {
        target: app
        onSettingsChanged: stepSize = settings.get("General", "VolumeStep")
    }
}
