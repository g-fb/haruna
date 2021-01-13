/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.10
import QtQuick.Window 2.1
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

import org.kde.kirigami 2.11 as Kirigami
import com.georgefb.haruna 1.0 as Haruna

Window {
    id: root

    signal skipChaptersChanged(bool checked)

    width: 700
    height: mpv.height
    color: Kirigami.Theme.backgroundColor

    RowLayout {
        anchors.fill: parent
        anchors.bottomMargin: Kirigami.Units.largeSpacing
        spacing: 0

        Navigation {
            id: nav

            width: Math.round(root.width * 0.3)
            Layout.fillHeight: true

            Rectangle {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                width: 1
                color: Kirigami.Theme.alternateBackgroundColor
            }

        }

        ColumnLayout {
            spacing: 0
            width: Math.round(root.width * 0.7) - 1

            Loader {
                id: settingsPageLoader

                sourceComponent: generalSettings

                Layout.fillHeight: true
                Layout.leftMargin: Kirigami.Units.largeSpacing
                Layout.topMargin: Kirigami.Units.largeSpacing
                Layout.rightMargin: 0
                Layout.bottomMargin: Kirigami.Units.largeSpacing
            }

            RowLayout {
                Button {
                    id: settingsHelpButton

                    text: qsTr("Help!")
                    icon.name: "system-help"
                    enabled: settingsPageLoader.item.hasHelp
                    onClicked: settingsPageLoader.item.hasHelp ? helpWindow.show() : undefined
                    Layout.alignment: Qt.AlignBottom
                    Layout.leftMargin: 10
                    Layout.rightMargin: 5
                }

                Button {
                    id: openConfigButton

                    text: qsTr("Open Config")
                    icon.name: "folder"
                    onClicked: openConfigMenu.visible ? openConfigMenu.close() : openConfigMenu.open()
                    Layout.alignment: Qt.AlignBottom
                    Layout.rightMargin: 5

                    Menu {
                        id: openConfigMenu

                        MenuItem {
                            text: qsTr("Folder")
                            onTriggered: Qt.openUrlExternally(app.configFolderPath)
                        }

                        MenuItem {
                            text: qsTr("File")
                            onTriggered: Qt.openUrlExternally(app.configFilePath)
                        }
                    }
                }
            }
        }
    }

    Component {
        id: generalSettings
        General {
            width: root.width * 0.7
        }
    }
    Component {
        id: videoSettings
        VideoSettings {
            width: root.width * 0.7
        }
    }
    Component {
        id: colorAdjustmentsSettings
        ColorAdjustments {
            width: root.width * 0.7
        }
    }
    Component {
        id: mouseSettings
        Mouse {
            width: root.width * 0.7
        }
    }
    Component {
        id: playlistSettings
        Playlist {
            width: root.width * 0.7
        }
    }
    Component {
        id: audioSettings
        Audio {
            width: root.width * 0.7
        }
    }
    Component {
        id: subtitlesSettings
        Subtitles {
            width: root.width * 0.7
        }
    }
    Component {
        id: playbackSettings
        Playback {
            width: root.width * 0.7
        }
    }


    Window {
        id: helpWindow

        width: 700
        height: 600
        title: qsTr("Help")
        color: Kirigami.Theme.backgroundColor
        onVisibleChanged: info.text = app.getFileContent(settingsPageLoader.item.helpFile)

        Flickable {
            id: scrollView

            property int scrollStepSize: 100

            anchors.fill: parent
            contentHeight: info.height

            ScrollBar.vertical: ScrollBar {
                id: scrollbar
                policy: ScrollBar.AlwaysOn
                stepSize: scrollView.scrollStepSize/scrollView.contentHeight
            }

            MouseArea {
                anchors.fill: parent
                onWheel: {
                    if (wheel.angleDelta.y > 0) {
                        scrollbar.decrease()
                    } else {
                        scrollbar.increase()
                    }
                }
            }

            TextArea {
                id: info

                background: Rectangle {
                    color: "transparent"
                    border.color: "transparent"
                }
                width: parent.width
                color: Kirigami.Theme.textColor
                readOnly: true
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                selectByMouse: true
                rightPadding: scrollbar.width
                onLinkActivated: Qt.openUrlExternally(link)
                onHoveredLinkChanged: hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
            }
        }
    }
}
