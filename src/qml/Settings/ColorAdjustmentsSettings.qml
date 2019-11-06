import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

Item {
    ColumnLayout {
        width: parent.width
        spacing: 5
        Component.onCompleted: console.log(width)

        Item { height: 10 }

        Label {
            text: "Contrast " + contrastSlider.value.toFixed(0)
        }
        Slider {
            id: contrastSlider
            from: -100
            to: 100
            value: 0
            Layout.fillWidth: true
            onValueChanged: {
                mpv.setProperty("contrast", contrastSlider.value.toFixed(0))
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.MiddleButton
                onClicked: contrastSlider.value = 0
            }
        }
        Rectangle {
            height: 1
            color: systemPalette.base
            Layout.fillWidth: true
        }
        Item { height: 50 }



        Label {
            text: "Brightness " + brightnessSlider.value.toFixed(0)
        }
        Slider {
            id: brightnessSlider
            from: -100
            to: 100
            value: 0
            Layout.fillWidth: true
            onValueChanged: {
                mpv.setProperty("brightness", brightnessSlider.value.toFixed(0))
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.MiddleButton
                onClicked: brightnessSlider.value = 0
            }
        }

        Rectangle {
            height: 1
            color: systemPalette.base
            Layout.fillWidth: true
        }
        Item { height: 50 }



        Label {
            text: "Gamma " + gammaSlider.value.toFixed(0)
        }
        Slider {
            id: gammaSlider
            from: -100
            to: 100
            value: 0
            Layout.fillWidth: true
            onValueChanged: {
                mpv.setProperty("gamma", gammaSlider.value.toFixed(0))
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.MiddleButton
                onClicked: gammaSlider.value = 0
            }
        }
        Rectangle {
            height: 1
            color: systemPalette.base
            Layout.fillWidth: true
        }
        Item { height: 50 }



        Label {
            text: "Saturation " + saturationSlider.value.toFixed(0)
        }
        Slider {
            id: saturationSlider
            from: -100
            to: 100
            value: 0
            Layout.fillWidth: true
            onValueChanged: {
                mpv.setProperty("saturation", saturationSlider.value.toFixed(0))
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.MiddleButton
                onClicked: saturationSlider.value = 0
            }
        }
    }

}
