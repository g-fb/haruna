import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13

Pane {
    id: root

    x: -width; y: 0; z: 50
    width: 600
    height: mpv.height
    padding: 10
    state: "hidden"

    RowLayout {
        anchors.fill: parent
        Navigation {
            id: nav
            width: root.width * 0.3 - root.padding
            Layout.fillHeight: true
        }

        Flickable {
            id: flick
            clip: true
            height: root.height
            contentHeight: settingsViewLoader.item.contentHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            ScrollBar.vertical: ScrollBar { id: scrollbar }
            Loader {
                id: settingsViewLoader
                sourceComponent: generalSettings
            }
        }
    }

    Component {
        id: generalSettings
        General {
            width: root.width * 0.7 - root.padding
        }
    }
    Component {
        id: colorAdjustmentsSettings
        ColorAdjustments {
            width: root.width * 0.7 - root.padding
        }
    }
    Component {
        id: mouseSettings
        Mouse {
            width: root.width * 0.7 - root.padding
        }
    }
    Component {
        id: playlistSettings
        Playlist {
            width: root.width * 0.7 - root.padding
        }
    }
    Component {
        id: audioSettings
        Audio {
            width: root.width * 0.7 - root.padding
        }
    }
    Component {
        id: subtitlesSettings
        Subtitles {
            width: root.width * 0.7 - root.padding
        }
    }
    Component {
        id: playbackSettings
        Playback {
            width: root.width * 0.7 - root.padding
        }
    }


    states: [
        State {
            name: "hidden"
            PropertyChanges { target: root; x: -width; visible: false }
        },
        State {
            name : "visible"
            PropertyChanges { target: root; x: 0; visible: true }
        }
    ]

    transitions: Transition {
        PropertyAnimation { properties: "x"; easing.type: Easing.Linear; duration: 100 }
    }
}
