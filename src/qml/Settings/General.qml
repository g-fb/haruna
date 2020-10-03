/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import org.kde.kirigami 2.11 as Kirigami

import GeneralSettings 1.0

Item {
    id: root

    property bool hasHelp: false
    property string helpFile: ""

    visible: false

    GridLayout {
        id: content

        width: parent.width
        columns: 2

        // OSD Font Size
        Label {
            text: qsTr("Osd font size")
            Layout.alignment: Qt.AlignRight
        }

        Item {
            height: osdFontSize.height
            SpinBox {
                id: osdFontSize
                editable: true
                from: 0
                to: 100
                value: GeneralSettings.osdFontSize
                onValueChanged: {
                    // runs on start-up so only execute when state is visible
                    if (root.visible) {
                        osd.label.font.pointSize = osdFontSize.value
                        osd.message("Test osd font size")
                        GeneralSettings.osdFontSize = osdFontSize.value
                    }
                }
            }
            Layout.fillWidth: true
        }

        // Volume Step
        Label {
            text: qsTr("Volume step")
            Layout.alignment: Qt.AlignRight
        }

        Item {
            height: volumeStep.height
            SpinBox {
                id: volumeStep
                editable: true
                from: 0
                to: 100
                value: GeneralSettings.volumeStep
                onValueChanged: {
                    if (root.visible) {
                        GeneralSettings.volumeStep = volumeStep.value
                    }
                }
            }
            Layout.fillWidth: true
        }

        Item {
            Layout.columnSpan: 2
            height: 5
            Rectangle {
                y: 2
                width: content.width
                height: 1
                color: Kirigami.Theme.alternateBackgroundColor
            }
        }

        // Seek Small Step
        Label {
            text: qsTr("Seek Small Step")
            Layout.alignment: Qt.AlignRight
        }

        Item {
            height: seekSmallStep.height
            SpinBox {
                id: seekSmallStep
                editable: true
                from: 0
                to: 100
                value: GeneralSettings.seekSmallStep
                onValueChanged: GeneralSettings.seekSmallStep = seekSmallStep.value
            }
            Layout.fillWidth: true
        }

        // Seek Medium Step
        Label {
            text: qsTr("Seek Medium Step")
            Layout.alignment: Qt.AlignRight
        }

        Item {
            height: seekMediumStep.height
            SpinBox {
                id: seekMediumStep
                editable: true
                from: 0
                to: 100
                value: GeneralSettings.seekMediumStep
                onValueChanged: GeneralSettings.seekMediumStep = seekMediumStep.value
            }
            Layout.fillWidth: true
        }

        // Seek Big Step
        Label {
            text: qsTr("Seek Big Step")
            Layout.alignment: Qt.AlignRight
        }

        Item {
            height: seekBigStep.height
            SpinBox {
                id: seekBigStep
                editable: true
                from: 0
                to: 100
                value: GeneralSettings.seekBigStep
                onValueChanged: GeneralSettings.seekBigStep = seekBigStep.value
            }
            Layout.fillWidth: true
        }

        Item {
            Layout.columnSpan: 2
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        CheckBox {
            text: qsTr("Show MenuBar")
            checked: GeneralSettings.showMenuBar
            onCheckedChanged: GeneralSettings.showMenuBar = checked
            Layout.columnSpan: 2
        }

        CheckBox {
            text: qsTr("Show Header")
            checked: GeneralSettings.showHeader
            onCheckedChanged: GeneralSettings.showHeader = checked
            Layout.columnSpan: 2
        }

    }

    Connections {
        target: settingsEditor
        onVisibleChanged: visible = settingsEditor.visible
    }
}
