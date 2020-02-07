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
                text: "Contrast " + contrastSlider.value.toFixed(0)
            }
            Slider {
                id: contrastSlider
                from: -100
                to: 100
                value: mpv.contrast
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
                text: "Brightness " + brightnessSlider.value.toFixed(0)
            }
            Slider {
                id: brightnessSlider
                from: -100
                to: 100
                value: mpv.brightness
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
                text: "Gamma " + gammaSlider.value.toFixed(0)
            }
            Slider {
                id: gammaSlider
                from: -100
                to: 100
                value: mpv.gamma
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
                text: "Saturation " + saturationSlider.value.toFixed(0)
            }
            Slider {
                id: saturationSlider
                from: -100
                to: 100
                value: mpv.saturation
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
            text: "Middle click on the sliders to reset them"
        }
    }
}
