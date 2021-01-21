/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQml 2.12
import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import org.kde.kirigami 2.11 as Kirigami
import com.georgefb.haruna 1.0
import Haruna.Components 1.0

SettingsBasePage {
    id: root

    hasHelp: false
    helpFile: ""

    ColumnLayout {
        id: content

        spacing: Kirigami.Units.largeSpacing

        ListModel {
            id: mouseActionsModel

            ListElement {
                label: "Left"
                key: "left"
            }
            ListElement {
                label: "Left.x2"
                key: "leftx2"
            }
            ListElement {
                label: "Right"
                key: "right"
            }
            ListElement {
                label: "Right.x2"
                key: "rightx2"
            }
            ListElement {
                label: "Middle"
                key: "middle"
            }
            ListElement {
                label: "Middle.x2"
                key: "middlex2"
            }
            ListElement {
                label: "ScrollUp"
                key: "scrollUp"
            }
            ListElement {
                label: "ScrollDown"
                key: "scrollDown"
            }
        }

        ListView {
            id: buttonsView

            implicitHeight: 50 * (buttonsView.count + 1)
            model: mouseActionsModel
            header: RowLayout {
                Kirigami.ListSectionHeader {
                    text: qsTr("Button")
                    Layout.leftMargin: 5
                    Layout.preferredWidth: 100
                }

                Kirigami.ListSectionHeader {
                    text: qsTr("Action")
                    Layout.leftMargin: 5
                    Layout.fillWidth: true
                }
            }

            delegate: Kirigami.BasicListItem {
                id: delegate

                width: content.width
                height: 50

                onDoubleClicked: openSelectActionPopup()

                contentItem: RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Label {
                        text: model.label
                        padding: 10
                        Layout.preferredWidth: 100
                        Layout.fillHeight: true
                    }

                    Label {
                        text: MouseSettings[model.key]
                        Layout.fillWidth: true
                    }

                    Button {
                        flat: true
                        icon.name: "configure"
                        Layout.alignment: Qt.AlignRight
                        onClicked: openSelectActionPopup()
                    }

                    Connections {
                        target: selectActionPopup
                        onActionSelected: {
                            if (selectActionPopup.buttonIndex === model.index) {
                                MouseSettings[model.key] = actionName
                                MouseSettings.save()
                            }
                        }
                    }
                }

                function openSelectActionPopup() {
                    selectActionPopup.buttonIndex = model.index
                    selectActionPopup.headerTitle = model.label
                    selectActionPopup.open()
                }
            }
        }

        Label {
            text: qsTr("Double click to edit actions")
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
        }

        Item {
            width: Kirigami.Units.gridUnit
            height: Kirigami.Units.gridUnit
        }

        SelectActionPopup { id: selectActionPopup }
    }
}
