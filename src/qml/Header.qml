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
import AppSettings 1.0

import "Menus"

ToolBar {
    id: root

    property var audioTracks
    property var subtitleTracks

    position: ToolBar.Header
    visible: !window.isFullScreen() && AppSettings.viewIsHeaderVisible

    RowLayout {
        id: headerRow

        width: parent.width

        RowLayout {
            id: headerRowLeft

            Layout.alignment: Qt.AlignLeft

            ToolButton {
                action: actions.configureAction
                checkable: true
                checked: settingsEditor.state === "visible"
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
                    if (primarySubtitleMenuInstantiator.model === 0) {
                        primarySubtitleMenuInstantiator.model = mpv.subtitleTracksModel()
                    }
                    if(secondarySubtitleMenuInstantiator.model === 0) {
                        secondarySubtitleMenuInstantiator.model = mpv.subtitleTracksModel()
                    }

                    subtitleMenu.visible = !subtitleMenu.visible
                }

                Menu {
                    id: subtitleMenu

                    y: parent.height

                    Menu {
                        id: secondarySubtitleMenu

                        title: qsTr("Secondary Subtitle")

                        Instantiator {
                            id: secondarySubtitleMenuInstantiator
                            model: 0
                            onObjectAdded: secondarySubtitleMenu.insertItem( index, object )
                            onObjectRemoved: secondarySubtitleMenu.removeItem( object )
                            delegate: MenuItem {
                                enabled: model.id !== mpv.subtitleId || model.id === 0
                                checkable: true
                                checked: model.id === mpv.secondarySubtitleId
                                text: model.text
                                onTriggered: mpv.setSecondarySubtitle(model.id)
                            }
                        }
                    }

                    MenuSeparator {}

                    MenuItem {
                        text: qsTr("Primary Subtitle")
                        hoverEnabled: false
                    }

                    Instantiator {
                        id: primarySubtitleMenuInstantiator
                        model: 0
                        onObjectAdded: subtitleMenu.addItem( object )
                        onObjectRemoved: subtitleMenu.removeItem( object )
                        delegate: MenuItem {
                            enabled: model.id !== mpv.secondarySubtitleId || model.id === 0
                            checkable: true
                            checked: model.id === mpv.subtitleId
                            text: model.text
                            onTriggered: mpv.setSubtitle(model.id)
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
                            checked: model.id === mpv.audioId
                            text: model.text
                            onTriggered: mpv.setAudio(model.id)
                        }
                    }
                }
            }
        }

        RowLayout {
            id: headerRowRight

            Layout.alignment: Qt.AlignRight

            ToolButton {
                // using `action: actions.quitApplicationAction` breaks the action
                // doens't work on the first try in certain circumstances
                text: actions.quitApplicationAction.text
                icon: actions.quitApplicationAction.icon
                onClicked: actions.quitApplicationAction.trigger()
            }
        }
    }
}
