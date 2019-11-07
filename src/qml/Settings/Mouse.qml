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
        rowSpacing: 20

        ////////////////////////////////////////////////////////
        //
        // Left Button
        //
        ////////////////////////////////////////////////////////
        Label {
            color: systemPalette.text
            text: "Left Button"
            Layout.alignment: Qt.AlignRight
        }
        Item {
            height: leftButton.height
            Layout.fillWidth: true
            ComboBox {
                id: leftButton
                textRole: "key"
                model: ListModel {
                    id: leftButtonModel
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
        }

        ////////////////////////////////////////////////////////
        //
        // Right Button
        //
        ////////////////////////////////////////////////////////
        Label {
            color: systemPalette.text
            text: "Right Button"
            Layout.alignment: Qt.AlignRight
        }
        Item {
            height: rightButton.height
            Layout.fillWidth: true
            ComboBox {
                id: rightButton
                textRole: "key"
                model: ListModel {
                    id: rightButtonModel
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
        }

        ////////////////////////////////////////////////////////
        //
        // Middle Button
        //
        ////////////////////////////////////////////////////////
        Label {
            color: systemPalette.text
            text: "Middle Button"
            Layout.alignment: Qt.AlignRight
        }
        Item {
            height: middleButton.height
            Layout.fillWidth: true
            ComboBox {
                id: middleButton
                textRole: "key"
                model: ListModel {
                    id: middleButtonModel
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
        }

        ////////////////////////////////////////////////////////
        //
        // Scroll Up
        //
        ////////////////////////////////////////////////////////
        Label {
            color: systemPalette.text
            text: "Scroll Up"
            Layout.alignment: Qt.AlignRight
        }
        Item {
            height: scrollUp.height
            Layout.fillWidth: true
            ComboBox {
                id: scrollUp
                textRole: "key"
                model: ListModel {
                    id: scrollUpModel
                    ListElement { key: "None"; value: "none" }
                    ListElement { key: "Volume Up"; value: "volumeUpAction" }
                    ListElement { key: "Zoom In"; value: "zoomInAction" }
                }
                Component.onCompleted: {
                    for (var i = 0; i < model.count; ++i) {
                        if (model.get(i).value === settings.get("Mouse", "ScrollUpAction")) {
                            currentIndex = i
                            break
                        }
                    }
                }
                onActivated: {
                    settings.set("Mouse", "ScrollUpAction", model.get(index).value)
                }
            }
        }

        ////////////////////////////////////////////////////////
        //
        // Scroll Down
        //
        ////////////////////////////////////////////////////////
        Label {
            color: systemPalette.text
            text: "Scroll Down"
            Layout.alignment: Qt.AlignRight
        }
        Item {
            height: scrollDown.height
            Layout.fillWidth: true
            ComboBox {
                id: scrollDown
                textRole: "key"
                model: ListModel {
                    id: scrollDownDownModel
                    ListElement { key: "None"; value: "none" }
                    ListElement { key: "Volume Down"; value: "volumeDownAction" }
                    ListElement { key: "Zoom Out"; value: "zoomOutAction" }
                }
                Component.onCompleted: {
                    for (var i = 0; i < model.count; ++i) {
                        if (model.get(i).value === settings.get("Mouse", "ScrollDownAction")) {
                            currentIndex = i
                            break
                        }
                    }
                }
                onActivated: {
                    settings.set("Mouse", "ScrollDownAction", model.get(index).value)
                }
            }
        }
    }
}
