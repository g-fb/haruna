import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

Item {
    id: root

    property alias contentHeight: content.height

    visible: false
    height: parent.height

    ColumnLayout {
        id: content

        width: parent.width
        spacing: 20

        ////////////////////////////////////////////////////////
        //
        // Left Button
        //
        ////////////////////////////////////////////////////////
        ColumnLayout {
            Label {
                color: systemPalette.text
                text: "Left Button"
            }
            RowLayout {
                TextField {
                    id: leftButton
                    text: settings.get("Mouse", "LeftButtonAction")
                    onTextEdited: {
                        settings.set("Mouse", "LeftButtonAction", leftButton.text)
                    }
                    onTextChanged: {
                        settings.set("Mouse", "LeftButtonAction", leftButton.text)
                    }
                }
                ComboBox {
                    textRole: "key"
                    Layout.fillWidth: true
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
                        leftButton.text = model.get(index).value
                    }
                }
            }
        }

        ////////////////////////////////////////////////////////
        //
        // Right Button
        //
        ////////////////////////////////////////////////////////
        ColumnLayout {
            Label {
                color: systemPalette.text
                text: "Right Button"
            }
            RowLayout {
                TextField {
                    id: rightButton
                    text: settings.get("Mouse", "RightButtonAction")
                    onTextEdited: {
                        settings.set("Mouse", "RightButtonAction", rightButton.text)
                    }
                    onTextChanged: {
                        settings.set("Mouse", "RightButtonAction", rightButton.text)
                    }
                }
                ComboBox {
                    textRole: "key"
                    Layout.fillWidth: true
                    model: ListModel {
                        id: rightButtonModel
                        ListElement { key: "None"; value: "none" }
                        ListElement { key: "Play/Pause"; value: "playPauseAction" }
                        ListElement { key: "Mute/Unmute"; value: "muteAction" }
                        ListElement { key: "Open context menu"; value: "openContextMenuAction" }
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
                        rightButton.text = model.get(index).value
                    }
                }
            }
        }

        ////////////////////////////////////////////////////////
        //
        // Middle Button
        //
        ////////////////////////////////////////////////////////
        ColumnLayout {
            Label {
                color: systemPalette.text
                text: "Middle Button"
            }
            RowLayout {
                TextField {
                    id: middleButton
                    text: settings.get("Mouse", "MiddleButtonAction")
                    onTextEdited: {
                        settings.set("Mouse", "MiddleButtonAction", middleButton.text)
                    }
                    onTextChanged: {
                        settings.set("Mouse", "MiddleButtonAction", middleButton.text)
                    }
                }
                ComboBox {
                    textRole: "key"
                    Layout.fillWidth: true
                    model: ListModel {
                        id: middleButtonModel
                        ListElement { key: "None"; value: "none" }
                        ListElement { key: "Play/Pause"; value: "playPauseAction" }
                        ListElement { key: "Mute/Unmute"; value: "muteAction" }
                        ListElement { key: "Open context menu"; value: "openContextMenuAction" }
                        ListElement { key: "Toggle fullscreen"; value: "fullscreenAction" }
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
                        middleButton.text = model.get(index).value
                    }
                }
            }
        }

        ////////////////////////////////////////////////////////
        //
        // Scroll Up
        //
        ////////////////////////////////////////////////////////
        ColumnLayout {
            Label {
                color: systemPalette.text
                text: "Scroll Up"
            }
            RowLayout {
                TextField {
                    id: scrollUp
                    text: settings.get("Mouse", "ScrollUpAction")
                    onTextEdited: {
                        settings.set("Mouse", "ScrollUpAction", scrollUp.text)
                    }
                    onTextChanged: {
                        settings.set("Mouse", "ScrollUpAction", scrollUp.text)
                    }
                }
                ComboBox {
                    height: scrollUp.height
                    textRole: "key"
                    Layout.fillWidth: true
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
                        scrollUp.text = model.get(index).value
                    }
                }
            }
        }

        ////////////////////////////////////////////////////////
        //
        // Scroll Down
        //
        ////////////////////////////////////////////////////////
        ColumnLayout {
            Label {
                color: systemPalette.text
                text: "Scroll Down"
            }
            RowLayout {
                TextField {
                    id: scrollDown
                    text: settings.get("Mouse", "ScrollDownAction")
                    onTextEdited: {
                        settings.set("Mouse", "ScrollDownAction", scrollDown.text)
                    }
                    onTextChanged: {
                        settings.set("Mouse", "ScrollDownAction", scrollDown.text)
                    }
                }
                ComboBox {
                    textRole: "key"
                    Layout.fillWidth: true
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
                        scrollDown.text = model.get(index).value
                    }
                }
            }
        }
    }
}
