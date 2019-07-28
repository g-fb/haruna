import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQml 2.13

ToolBar {
    id: root
    position: ToolBar.Header

    RowLayout {
        id: headerRow
        width: parent.width

        RowLayout {
            id: headerRowLeft
            Layout.alignment: Qt.AlignLeft
            ToolButton {
                action: openAction
            }

            ToolButton {
                icon.name: "media-view-subtitles-symbolic"
                text: qsTr("Subtitles")
                onClicked: {
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
                            text: `${model.language}: ${model.title} ${model.codec}`
                            onTriggered: {
                                mpv.setSubtitle(model.id, checked)
                                mpv.subtitleTracksModel().updateSelectedTrack(model.id)
                            }
                        }
                    }
                }

                onReleased: subtitleMenu.open()
            }

            ToolButton {
                icon.name: "audio-volume-high"
                text: qsTr("Audio")
                onClicked: {
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
                            text: `${model.language}: ${model.title} ${model.codec}`
                            onTriggered: {
                                mpv.setAudio(model.id)
                                mpv.audioTracksModel().updateSelectedTrack(model.id)
                            }
                        }
                    }
                }

                onReleased: audioMenu.open()
            }
        }

        RowLayout {
            id: headerRowRight
            Layout.alignment: Qt.AlignRight

            ToolButton {
                icon.name: "view-media-playlist"
                text: qsTr("Playlist")
                onClicked: (playList.state === "hidden") ? playList.state = "visible" : playList.state = "hidden"
            }

            ToolButton {
                action: appQuitAction
            }
        }
    }
}
