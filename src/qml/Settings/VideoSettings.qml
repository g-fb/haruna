/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import org.kde.kirigami 2.11 as Kirigami
import com.georgefb.haruna 1.0
import Haruna.Components 1.0

SettingsBasePage {
    id: root

    hasHelp: true
    helpFile: ":/VideoSettings.html"

    GridLayout {
        id: content

        columns: 2

        SettingsHeader {
            text: qsTr("Screenshots")
            topMargin: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true
        }

        // ------------------------------------
        // Screenshot Format
        // ------------------------------------
        Label {
            text: qsTr("Format")
            Layout.alignment: Qt.AlignRight
        }

        Item {
            height: screenshotFormat.height
            ComboBox {
                id: screenshotFormat
                textRole: "key"
                model: ListModel {
                    id: leftButtonModel
                    ListElement { key: "PNG"; }
                    ListElement { key: "JPG"; }
                    ListElement { key: "WebP"; }
                }

                onActivated: {
                    VideoSettings.screenshotFormat = model.get(index).key
                    VideoSettings.save()
                    mpv.setProperty("screenshot-format", VideoSettings.screenshotFormat)
                }

                Component.onCompleted: {
                    if (VideoSettings.screenshotFormat === "PNG") {
                        currentIndex = 0
                    }
                    if (VideoSettings.screenshotFormat === "JPG") {
                        currentIndex = 1
                    }
                    if (VideoSettings.screenshotFormat === "WebP") {
                        currentIndex = 2
                    }
                }
            }
            Layout.fillWidth: true
        }

        // ------------------------------------
        // Screenshot template
        // ------------------------------------
        Label {
            text: qsTr("Template")
            Layout.alignment: Qt.AlignRight
        }

        Item {
            height: screenshotTemplate.height
            TextField {
                id: screenshotTemplate
                text: VideoSettings.screenshotTemplate
                onEditingFinished: {
                    VideoSettings.screenshotTemplate = text
                    VideoSettings.save()
                    mpv.setProperty("screenshot-template", VideoSettings.screenshotTemplate)
                }
                Layout.fillWidth: true
            }
        }

        SettingsHeader {
            text: qsTr("Color adjustments")
            Layout.columnSpan: 2
            Layout.fillWidth: true
        }


        // ------------------------------------
        // CONTRAST
        // ------------------------------------
        Label {
            text: qsTr("Contrast %1").arg(contrastSlider.value.toFixed(0))
            width: contrastTextMetrics.width
            Layout.preferredWidth: contrastTextMetrics.width
            Layout.alignment: Qt.AlignRight
            Layout.topMargin: Kirigami.Units.largeSpacing

            TextMetrics {
                id:contrastTextMetrics
                text: qsTr("Contrast 0000")
            }

        }

        Slider {
            id: contrastSlider
            from: -100
            to: 100
            value: mpv.contrast
            wheelEnabled: true
            stepSize: 1
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing
            onValueChanged: {
                mpv.contrast = contrastSlider.value.toFixed(0)
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.MiddleButton
                onClicked: contrastSlider.value = 0
            }

            Component.onCompleted: background.activeControl = ""
        }

        // ------------------------------------
        // BRIGHTNESS
        // ------------------------------------
        Label {
            text: qsTr("Brightness %1").arg(brightnessSlider.value.toFixed(0))
            width: brightnessTextMetrics.width
            Layout.preferredWidth: brightnessTextMetrics.width
            Layout.alignment: Qt.AlignRight
            Layout.topMargin: Kirigami.Units.largeSpacing

            TextMetrics {
                id: brightnessTextMetrics
                text: qsTr("Brightness 0000")
            }
        }

        Slider {
            id: brightnessSlider
            from: -100
            to: 100
            value: mpv.brightness
            wheelEnabled: true
            stepSize: 1
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing
            onValueChanged: {
                mpv.brightness = brightnessSlider.value.toFixed(0)
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.MiddleButton
                onClicked: brightnessSlider.value = 0
            }

            Component.onCompleted: background.activeControl = ""
        }

        // ------------------------------------
        // GAMMA
        // ------------------------------------
        Label {
            text: qsTr("Gamma %1").arg(gammaSlider.value.toFixed(0))
            width: gammaTextMetrics.width
            Layout.preferredWidth: gammaTextMetrics.width
            Layout.alignment: Qt.AlignRight
            Layout.topMargin: Kirigami.Units.largeSpacing

            TextMetrics {
                id: gammaTextMetrics
                text: qsTr("Gamma 0000")
            }

        }

        height: gammaSlider.height

        Slider {
            id: gammaSlider
            from: -100
            to: 100
            value: mpv.gamma
            wheelEnabled: true
            stepSize: 1
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing
            onValueChanged: {
                mpv.gamma = gammaSlider.value.toFixed(0)
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.MiddleButton
                onClicked: gammaSlider.value = 0
            }

            Component.onCompleted: background.activeControl = ""
        }

        // ------------------------------------
        // SATURATION
        // ------------------------------------
        Label {
            text: qsTr("Saturation %1").arg(saturationSlider.value.toFixed(0))
            width: saturationTextMetrics.width
            Layout.preferredWidth: saturationTextMetrics.width
            Layout.alignment: Qt.AlignRight
            Layout.topMargin: Kirigami.Units.largeSpacing

            TextMetrics {
                id: saturationTextMetrics
                text: qsTr("Saturation 0000")
            }

        }

        Slider {
            id: saturationSlider
            from: -100
            to: 100
            value: mpv.saturation
            wheelEnabled: true
            stepSize: 1
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing
            onValueChanged: {
                mpv.saturation = saturationSlider.value.toFixed(0)
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.MiddleButton
                onClicked: saturationSlider.value = 0
            }

            Component.onCompleted: background.activeControl = ""
        }

        Label {
            text: qsTr("Middle click on the sliders to reset them")
            Layout.columnSpan: 2
            Layout.topMargin: Kirigami.Units.largeSpacing
        }

    }
}
