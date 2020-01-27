import QtQml 2.13
import QtQuick 2.13
import QtQuick.Controls 2.13

Menu {
    id: subtitlesMenu

    title: qsTr("&Subtitles")

    Menu {
        id: subtitleMenu

        title: qsTr("&Primary Track")

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
        Connections {
            target: mpv
            onFileLoaded: {
                subtitleMenuInstantiator.model = mpv.subtitleTracksModel()
            }
        }
    }

    MenuSeparator {}

    MenuItem { action: actions["subtitleQuickenAction"] }
    MenuItem { action: actions["subtitleDelayAction"] }
    MenuItem { action: actions["subtitleToggleAction"] }
}
