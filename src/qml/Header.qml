import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQml 2.13

ToolBar {
    id: root

    property var audioTracks
    property var subtitleTracks

    position: ToolBar.Header
    visible: settings.get("View", "HeaderVisible")

    RowLayout {
        id: headerRow

        width: parent.width

        RowLayout {
            id: headerRowLeft

            Layout.alignment: Qt.AlignLeft

            ToolButton {
                action: actions.configureAction
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
                    color: systemPalette.text
                }
            }

            ToolButton {
                icon.name: "media-view-subtitles-symbolic"
                text: qsTr("Subtitles")

                onClicked: {
                    if (subtitleMenu.visible) {
                        subtitleMenu.close()
                    } else {
                        subtitleMenu.open()
                    }

                    subtitleMenuInstantiator.model = mpv.subtitleTracksModel()
                }

                Menu {
                    id: subtitleMenu

                    y: parent.height

                    Instantiator {
                        id: subtitleMenuInstantiator

                        model: 0
                        onObjectAdded: subtitleMenu.insertItem( index, object )
                        onObjectRemoved: subtitleMenu.removeItem( object )
                        delegate: MenuItem {
                            id: subtitleMenuItem
                            checkable: true
                            checked: model.selected
                            text: model.text
                            onTriggered: {
                                mpv.setSubtitle(model.id)
                                mpv.subtitleTracksModel().updateSelectedTrack(model.index)
                            }
                        }
                    }
                }
            }

            ToolButton {
                icon.name: "audio-volume-high"
                text: qsTr("Audio")

                onClicked: {
                    if (audioMenu.visible) {
                        audioMenu.close()
                    } else {
                        audioMenu.open()
                    }

                    audioMenuInstantiator.model = mpv.audioTracksModel()
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
                            checked: model.selected
                            text: model.text
                            onTriggered: {
                                mpv.setAudio(model.id)
                                mpv.audioTracksModel().updateSelectedTrack(model.index)
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
