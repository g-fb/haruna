import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Window 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13
import Qt.labs.platform 1.0 as PlatformDialog

import mpv 1.0

ApplicationWindow {
    id: window

    property var configure: app.action("configure")

    property int preFullScreenVisibility

    function openFile(path, startPlayback, loadSiblings) {
        mpv.loadFile(path)

        if (startPlayback) {
            mpv.setProperty("pause", false)
        } else {
            mpv.setProperty("pause", true)
        }

        if (loadSiblings) {
            videoList.getVideos(path)
        }

        app.setSetting("General", "lastPlayedFile", path)
    }

    visible: true
    title: qsTr("Haruna")
    width: 1280
    height: 720

    onVisibilityChanged: {
        if (visibility !== Window.FullScreen) {
            preFullScreenVisibility = visibility
        }
    }

    Actions { id: actions }
    SystemPalette { id: systemPalette; colorGroup: SystemPalette.Active }

    header: Header { id: header }

    footer: Footer { id: footer }

    MpvVideo { id: mpv }

    PlayList { id: playList }

    Rectangle {
        id: fullscreenFooter
        anchors.bottom: mpv.bottom
        width: window.width
        height: footer.height
        visible: false
        color: "#31363B"
    }

    Osd { id: osd }

    PlatformDialog.FileDialog {
        id: fileDialog
        folder: PlatformDialog.StandardPaths.writableLocation(PlatformDialog.StandardPaths.MoviesLocation)
        title: "Select file"
        fileMode: PlatformDialog.FileDialog.OpenFile

        onAccepted: {
            openFile(fileDialog.file, true, true)
            // the timer scrolls the playlist to the playing file
            // once the table view rows are loaded
            mpv.scrollPositionTimer.start()
            mpv.focus = true
        }
        onRejected: mpv.focus = true
    }

    Popup {
        id: openUrlPopup
        anchors.centerIn: Overlay.overlay
        width: mpv.width * 0.7

        onOpened: {
            openUrlPopup.focus = true
            openUrlTextField.focus = true
            openUrlTextField.selectAll()
        }

        RowLayout {
            anchors.fill: parent
            TextField {
                id: openUrlTextField
                Layout.fillWidth: true
                text: app.setting("General", "lastUrl")

                Keys.onPressed: {
                    if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                        openFile(openUrlTextField.text, true, false)
                        openUrlPopup.close()
                        app.setSetting("General", "lastUrl", openUrlTextField.text)
                        openUrlTextField.text = ""
                    }
                    if (event.key === Qt.Key_Escape) {
                        openUrlPopup.close()
                    }
                }
            }
            Button {
                id: openUrlButton
                text: qsTr("Open")

                onClicked: {
                    openFile(openUrlTextField.text, true, false)
                    openUrlPopup.close()
                    app.setSetting("General", "lastUrl", openUrlTextField.text)
                    openUrlTextField.text = ""
                }
            }
        }
    }
}
