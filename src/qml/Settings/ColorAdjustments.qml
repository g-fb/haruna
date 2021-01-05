/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import org.kde.kirigami 2.11 as Kirigami

import "../Components"

SettingsFlickable {
    id: root

    property bool hasHelp: false
    property string helpFile: ""

    visible: false
    contentHeight: content.implicitHeight

    ColumnLayout {
        id: content

        anchors.fill: parent
        spacing: Kirigami.Units.largeSpacing

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
                    mpv.contrast = contrastSlider.value.toFixed(0)
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
                    mpv.brightness = brightnessSlider.value.toFixed(0)
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
                    mpv.gamma = gammaSlider.value.toFixed(0)
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
                    mpv.saturation = saturationSlider.value.toFixed(0)
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.MiddleButton
                    onClicked: saturationSlider.value = 0
                }
            }
        }

        Item {
            width: Kirigami.Units.gridUnit
            height: Kirigami.Units.gridUnit
        }

        Label {
            text: qsTr("Middle click on the sliders to reset them")
        }

        Item {
            width: Kirigami.Units.gridUnit
            height: Kirigami.Units.gridUnit
        }
    }
}
