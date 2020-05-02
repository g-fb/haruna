/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQml 2.13
import org.kde.kirigami 2.11 as Kirigami

import "Menus"

ToolBar {
    id: root

    property var audioTracks
    property var subtitleTracks
    property bool isVisible: settings.get("View", "HeaderVisible")

    position: ToolBar.Header
    visible: !window.isFullScreen() && isVisible

    RowLayout {
        id: headerRow

        width: parent.width

        RowLayout {
            id: headerRowLeft

            Layout.alignment: Qt.AlignLeft

            ToolButton {
                action: actions.configureAction
                checkable: true
                checked: hSettings.state === "visible"
            }
            ToolButton {
                action: actions.openAction
            }

            ToolButton {
                action: actions.openUrlAction
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.MiddleButton
                    onClicked: {
                        openUrlTextField.clear()
                        openUrlTextField.paste()
                        window.openFile(openUrlTextField.text, true, false)
                    }
                }
            }

            ToolSeparator {
                padding: vertical ? 10 : 2
                topPadding: vertical ? 2 : 10
                bottomPadding: vertical ? 2 : 10

                contentItem: Rectangle {
                    implicitWidth: parent.vertical ? 1 : 24
                    implicitHeight: parent.vertical ? 24 : 1
                    color: Kirigami.Theme.textColor
                }
            }

            ToolButton {
                icon.name: "media-view-subtitles-symbolic"
                text: qsTr("Subtitles")

                onClicked: {
                    if (primaryMenuItems.model === 0) {
                        primaryMenuItems.model = mpv.subtitleTracksModel()
                        secondaryMenuItems.model = mpv.subtitleTracksModel()
                    }

                    subtitleMenu.visible = !subtitleMenu.visible
                }

                Menu {
                    id: subtitleMenu

                    y: parent.height

                    Menu {
                        id: secondarySubtitleMenu

                        title: qsTr("Secondary Subtitle")

                        TrackMenuItems {
                            id: secondaryMenuItems

                            menu: secondarySubtitleMenu
                            isFirst: false
                            onSubtitleChanged: {
                                mpv.setSecondarySubtitle(id)
                                mpv.subtitleTracksModel().updateSecondTrack(index)
                            }
                        }
                    }

                    MenuSeparator {}

                    MenuItem {
                        text: qsTr("Primary Subtitle")
                        hoverEnabled: false
                    }

                    TrackMenuItems {
                        id: primaryMenuItems
                        menu: subtitleMenu
                        isFirst: true

                        onSubtitleChanged: {
                            mpv.setSubtitle(id)
                            mpv.subtitleTracksModel().updateFirstTrack(index)
                        }
                    }
                }
            }

            ToolButton {
                icon.name: "audio-volume-high"
                text: qsTr("Audio")

                onClicked: {
                    if (audioMenuInstantiator.model === 0) {
                        audioMenuInstantiator.model = mpv.audioTracksModel()
                    }
                    audioMenu.visible = !audioMenu.visible
                }

                Menu {
                    id: audioMenu

                    y: parent.height

                    Instantiator {
                        id: audioMenuInstantiator

                        model: 0
                        onObjectAdded: audioMenu.insertItem( index, object )
                        onObjectRemoved: audioMenu.removeItem( object )
                        delegate: MenuItem {
                            id: audioMenuItem
                            checkable: true
                            checked: model.isFirstTrack
                            text: model.text
                            onTriggered: {
                                mpv.setAudio(model.id)
                                mpv.audioTracksModel().updateFirstTrack(model.index)
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            id: headerRowRight

            Layout.alignment: Qt.AlignRight

            ToolButton {
                action: actions.quitApplicationAction
            }
        }
    }
}
