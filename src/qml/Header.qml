import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQml 2.13

ToolBar {
    id: root
    property var audioTracks
    property var subtitleTracks
    position: ToolBar.Header

    RowLayout {
        id: headerRow
        width: parent.width

        RowLayout {
            id: headerRowLeft
            Layout.alignment: Qt.AlignLeft

            ToolButton {
                icon.name: "document-open"
                text: qsTr("Open")

                onReleased: {
                    openMenu.open()
                    mpv.focus = true
                }

                Menu {
                    id: openMenu
                    y: parent.height

                    MenuItem {
                        action: openAction
                    }

                    MenuItem {
                        action: openUrlAction
                    }
                }
            }

            ToolButton {
                icon.name: "media-view-subtitles-symbolic"
                text: qsTr("Subtitles")

                onReleased: {
                    subtitleMenu.open()
                    mpv.focus = true
                }

                Menu {
                    id: subtitleMenu
                    y: parent.height

                    Instantiator {
                        id: subtitleMenuInstantiator
                        model: subtitleTracks
                        onObjectAdded: subtitleMenu.insertItem( index, object )
                        onObjectRemoved: subtitleMenu.removeItem( object )
                        delegate: MenuItem {
                            id: subtitleMenuItem
                            checkable: true
                            checked: modelData.selected
                            text: `${modelData.lang}: ${modelData.title} ${modelData.codec}`
                            onTriggered: {
                                mpv.setSubtitle(modelData.id, checked)
                                subtitleTracks = mpv.getProperty("track-list").filter(t => t["type"] === "sub")
                            }
                        }
                    }
                }
            }

            ToolButton {
                icon.name: "audio-volume-high"
                text: qsTr("Audio")

                onReleased: {
                    audioMenu.open()
                    mpv.focus = true
                }

                Menu {
                    id: audioMenu
                    y: parent.height

                    Instantiator {
                        id: audioMenuInstantiator
                        model: audioTracks
                        onObjectAdded: audioMenu.insertItem( index, object )
                        onObjectRemoved: audioMenu.removeItem( object )
                        delegate: MenuItem {
                            id: audioMenuItem
                            checkable: true
                            checked: modelData.selected
                            text: `${modelData.lang}: ${modelData.title} ${modelData.codec}`
                            onTriggered: {
                                mpv.setAudio(modelData.id)
                                audioTracks = mpv.getProperty("track-list").filter(t => t["type"] === "audio")
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
                icon.name: "view-media-playlist"
                text: qsTr("Playlist")
                onClicked: (playList.state === "hidden") ? playList.state = "visible" : playList.state = "hidden"
                onReleased: mpv.focus = true
            }

            ToolButton {
                action: appQuitAction
            }
        }
    }
}
