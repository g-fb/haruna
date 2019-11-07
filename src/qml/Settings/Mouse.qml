import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

Item {
    id: root
    height: parent.height

    GridLayout {
        id: grid

        width: parent.width
        columns: 2

        ////////////////////////////////////////////////////////
        //
        // Left mouse button
        //
        ////////////////////////////////////////////////////////
        Label {
            color: systemPalette.text
            text: "Left mouse button"
            Layout.alignment: Qt.AlignRight
        }
        Item {
            height: leftMouseButton.height
            ComboBox {
                id: leftMouseButton
                textRole: "key"
                model: ListModel {
                    id: leftMouseButtonModel
                    ListElement { key: "None"; value: "none" }
                    ListElement { key: "Play/Pause"; value: "playPauseAction" }
                }
                Component.onCompleted: {
                    for (var i = 0; i < model.count; ++i) {
                        if (model.get(i).value === settings.get("Mouse", "LeftButtonAction")) {
                            currentIndex = i
                            break
                        }
                    }
                }
                onActivated: {
                    settings.set("Mouse", "LeftButtonAction", model.get(index).value)
                }
            }
            Layout.fillWidth: true
        }

        ////////////////////////////////////////////////////////
        //
        // Right mouse button
        //
        ////////////////////////////////////////////////////////

        Label {
            color: systemPalette.text
            text: "Left mouse button"
            Layout.alignment: Qt.AlignRight
        }
        Item {
            height: rightMouseButton.height
            ComboBox {
                id: rightMouseButton
                textRole: "key"
                model: ListModel {
                    id: rightMouseButtonModel
                    ListElement { key: "None"; value: "none" }
                    ListElement { key: "Play/Pause"; value: "playPauseAction" }
                    ListElement { key: "Mute/Unmute"; value: "muteAction" }
                    ListElement { key: "Open context menu"; value: "none" }
                }
                Component.onCompleted: {
                    for (var i = 0; i < model.count; ++i) {
                        if (model.get(i).value === settings.get("Mouse", "RightButtonAction")) {
                            currentIndex = i
                            break
                        }
                    }
                }
                onActivated: {
                    settings.set("Mouse", "RightButtonAction", model.get(index).value)
                }
            }
            Layout.fillWidth: true
        }

        ////////////////////////////////////////////////////////
        //
        // Middle mouse button
        //
        ////////////////////////////////////////////////////////

        Label {
            color: systemPalette.text
            text: "Middle mouse button"
            Layout.alignment: Qt.AlignRight
        }
        Item {
            height: middleMouseButton.height
            ComboBox {
                id: middleMouseButton
                textRole: "key"
                model: ListModel {
                    id: middleMouseButtonModel
                    ListElement { key: "None"; value: "none" }
                    ListElement { key: "Play/Pause"; value: "playPauseAction" }
                    ListElement { key: "Mute/Unmute"; value: "muteAction" }
                    ListElement { key: "Open context menu"; value: "none" }
                }
                Component.onCompleted: {
                    for (var i = 0; i < model.count; ++i) {
                        if (model.get(i).value === settings.get("Mouse", "MiddleButtonAction")) {
                            currentIndex = i
                            break
                        }
                    }
                }
                onActivated: {
                    settings.set("Mouse", "MiddleButtonAction", model.get(index).value)
                }
            }
            Layout.fillWidth: true
        }
    }
}
