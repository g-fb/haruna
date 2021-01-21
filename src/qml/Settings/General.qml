/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import org.kde.kirigami 2.11 as Kirigami
import com.georgefb.haruna 1.0

import Haruna.Components 1.0

SettingsBasePage {
    id: root

    hasHelp: true
    helpFile: ":/GeneralSettings.html"

    visible: false

    GridLayout {
        id: content

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
                        GeneralSettings.save()
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
                        GeneralSettings.save()
                    }
                }
            }
            Layout.fillWidth: true
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
                onValueChanged: {
                    GeneralSettings.seekSmallStep = seekSmallStep.value
                    GeneralSettings.save()
                }
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
                onValueChanged: {
                    GeneralSettings.seekMediumStep = seekMediumStep.value
                    GeneralSettings.save()
                }
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
                onValueChanged: {
                    GeneralSettings.seekBigStep = seekBigStep.value
                    GeneralSettings.save()
                }
            }
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("File dialog location")
            Layout.alignment: Qt.AlignRight
        }

        Item {
            height: fileDialogLocation.height
            Layout.fillWidth: true

            TextField {
                id: fileDialogLocation

                text: GeneralSettings.fileDialogLocation
                onEditingFinished: {
                    GeneralSettings.fileDialogLocation = fileDialogLocation.text
                    GeneralSettings.save()
                }

                ToolTip {
                    text: qsTr("If empty the file dialog will remember the last opened location.")
                }
            }
        }

        SettingsHeader {
            text: qsTr("Interface")
            Layout.columnSpan: 2
            Layout.fillWidth: true
        }

        CheckBox {
            text: qsTr("Show MenuBar")
            checked: GeneralSettings.showMenuBar
            onCheckedChanged: {
                GeneralSettings.showMenuBar = checked
                GeneralSettings.save()
            }
            Layout.row: 8
            Layout.column: 1
        }

        CheckBox {
            text: qsTr("Show Header")
            checked: GeneralSettings.showHeader
            onCheckedChanged: {
                GeneralSettings.showHeader = checked
                GeneralSettings.save()
            }
            Layout.row: 9
            Layout.column: 1
        }

        CheckBox {
            text: qsTr("Show Chapter Markers")
            checked: GeneralSettings.showChapterMarkers
            onCheckedChanged: {
                GeneralSettings.showChapterMarkers = checked
                GeneralSettings.save()
            }
            Layout.row: 10
            Layout.column: 1
        }

        Label {
            text: qsTr("Color Scheme")
            Layout.alignment: Qt.AlignRight
        }

        ComboBox {
            id: colorThemeSwitcher

            textRole: "display"
            model: app.colorSchemesModel
            delegate: ItemDelegate {
                Kirigami.Theme.colorSet: Kirigami.Theme.View
                width: parent.width
                highlighted: model.display === GeneralSettings.colorScheme
                contentItem: RowLayout {
                    Kirigami.Icon {
                        source: model.decoration
                        Layout.preferredHeight: Kirigami.Units.iconSizes.small
                        Layout.preferredWidth: Kirigami.Units.iconSizes.small
                    }
                    Label {
                        text: model.display
                        color: highlighted ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
                        Layout.fillWidth: true
                    }
                }
            }

            onActivated: {
                GeneralSettings.colorScheme = colorThemeSwitcher.textAt(index)
                GeneralSettings.save()
                app.activateColorScheme(GeneralSettings.colorScheme)
            }

            Component.onCompleted: currentIndex = find(GeneralSettings.colorScheme)
        }

        CheckBox {
            text: qsTr("Use Breeze icon theme")
            checked: GeneralSettings.useBreezeIconTheme
            onCheckedChanged: {
                GeneralSettings.useBreezeIconTheme = checked
                GeneralSettings.save()
            }
            Layout.row: 14
            Layout.column: 1

            ToolTip {
                text: qsTr("Sets the icon theme to breeze.\nRequires restart.")
            }
        }
        CheckBox {
            text: qsTr("Use Breeze GUI style")
            checked: GeneralSettings.useBreezeGuiStyle
            enabled: app.isBreezeStyleAvailable
            onCheckedChanged: {
                GeneralSettings.useBreezeGuiStyle = checked
                GeneralSettings.save()
            }
            Layout.row: 15
            Layout.column: 1

            ToolTip {
                text: qsTr("Sets the GUI style to breeze.\nRequires restart.")
            }
        }

        TextArea {
            text: qsTr("Breeze style is not installed.")
            visible: !app.isBreezeStyleAvailable
            width: parent.width
            color: Kirigami.Theme.textColor
            readOnly: true
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            selectByMouse: true
            rightPadding: scrollbar.width
            onLinkActivated: Qt.openUrlExternally(link)
            onHoveredLinkChanged: hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
            background: Rectangle {
                color: "transparent"
                border.color: "transparent"
            }
            Layout.columnSpan: 2
        }

        Item {
            width: Kirigami.Units.gridUnit
            height: Kirigami.Units.gridUnit
        }
    }
}
