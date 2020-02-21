/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

Item {
    id: root

    property alias contentHeight: content.height

    visible: false

    ColumnLayout {
        id: content

        width: parent.width
        spacing: 30

        ////////////////////////////////////////////////////////
        //
        // CONTRAST
        //
        ////////////////////////////////////////////////////////
        ColumnLayout {
            Label {
                text: qsTr("Contrast %1").arg(contrastSlider.value.toFixed(0))
            }
            Slider {
                id: contrastSlider
                from: -100
                to: 100
                value: mpv.contrast
                wheelEnabled: true
                stepSize: 1
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
        }

        ////////////////////////////////////////////////////////
        //
        // BRIGHTNESS
        //
        ////////////////////////////////////////////////////////
        ColumnLayout {
            Label {
                text: qsTr("Brightness %1").arg(brightnessSlider.value.toFixed(0))
            }
            Slider {
                id: brightnessSlider
                from: -100
                to: 100
                value: mpv.brightness
                wheelEnabled: true
                stepSize: 1
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
        }

        ////////////////////////////////////////////////////////
        //
        // GAMMA
        //
        ////////////////////////////////////////////////////////
        ColumnLayout {
            Label {
                text: qsTr("Gamma %1").arg(gammaSlider.value.toFixed(0))
            }
            Slider {
                id: gammaSlider
                from: -100
                to: 100
                value: mpv.gamma
                wheelEnabled: true
                stepSize: 1
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
        }

        ////////////////////////////////////////////////////////
        //
        // SATURATION
        //
        ////////////////////////////////////////////////////////
        ColumnLayout {
            Label {
                text: qsTr("Saturation %1").arg(saturationSlider.value.toFixed(0))
            }
            Slider {
                id: saturationSlider
                from: -100
                to: 100
                value: mpv.saturation
                wheelEnabled: true
                stepSize: 1
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

        Label {
            text: qsTr("Middle click on the sliders to reset them")
        }
    }
}
