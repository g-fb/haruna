import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13

Pane {
    id: root

    x: -350; y: 0; z: 50
    width: 350
    height: mpv.height
    padding: 10

    Component.onCompleted: state = "hidden"

    GridLayout {
        id: grid
        columns: 2
        anchors.fill: parent

        // OSD Font Size
        Label {
            color: systemPalette.text
            text: "Osd font size"
            Layout.alignment: Qt.AlignRight
        }

        Item {
            height: osdFontSize.height
            SpinBox {
                id: osdFontSize
                editable: true
                from: 0
                to: 100
                value: settings.get("General", "OsdFontSize")
                onValueChanged: {
                    // runs on start-up so only execute when state is visible
                    if (root.state === "visible") {
                        osd.label.font.pixelSize = osdFontSize.value
                        osd.message("Test osd font size")
                        settings.set("General", "OsdFontSize", osdFontSize.value)
                    }
                }
            }
            Layout.fillWidth: true
        }

        // Volume Step
        Label {
            color: systemPalette.text
            text: "Volume step"
            Layout.alignment: Qt.AlignRight
        }

        Item {
            height: volumeStep.height
            SpinBox {
                id: volumeStep
                editable: true
                from: 0
                to: 100
                value: settings.get("General", "VolumeStep")
                onValueChanged: {
                    if (root.state === "visible") {
                        settings.set("General", "VolumeStep", volumeStep.value)
                    }
                }
            }
            Layout.fillWidth: true
        }


        ToolSeparator {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            orientation: Qt.Horizontal
            contentItem: Rectangle {
                implicitHeight: parent.vertical ? 24 : 1
                color: systemPalette.base
            }
        }

        // Seek Small Step
        Label {
            color: systemPalette.text
            text: "Seek Small Step"
            Layout.alignment: Qt.AlignRight
        }

        Item {
            height: seekSmallStep.height
            SpinBox {
                id: seekSmallStep
                editable: true
                from: 0
                to: 100
                value: settings.get("General", "SeekSmallStep")
                onValueChanged: {
                    if (root.state === "visible") {
                        settings.set("General", "SeekSmallStep", seekSmallStep.value)
                    }
                }
            }
            Layout.fillWidth: true
        }

        // Seek Medium Step
        Label {
            color: systemPalette.text
            text: "Seek Medium Step"
            Layout.alignment: Qt.AlignRight
        }

        Item {
            height: seekMediumStep.height
            SpinBox {
                id: seekMediumStep
                editable: true
                from: 0
                to: 100
                value: settings.get("General", "SeekMediumStep")
                onValueChanged: {
                    if (root.state === "visible") {
                        settings.set("General", "SeekMediumStep", seekMediumStep.value)
                    }
                }
            }
            Layout.fillWidth: true
        }

        // Seek Big Step
        Label {
            color: systemPalette.text
            text: "Seek Big Step"
            Layout.alignment: Qt.AlignRight
        }

        Item {
            height: seekBigStep.height
            SpinBox {
                id: seekBigStep
                editable: true
                from: 0
                to: 100
                value: settings.get("General", "SeekBigStep")
                onValueChanged: {
                    if (root.state === "visible") {
                        settings.set("General", "SeekBigStep", seekBigStep.value)
                    }
                }
            }
            Layout.fillWidth: true
        }

        ToolSeparator {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            orientation: Qt.Horizontal
            contentItem: Rectangle {
                implicitHeight: parent.vertical ? 24 : 1
                color: systemPalette.base
            }
        }

        SubtitlesFolders {
            id: subtitleFolders
            _width: grid.width
        }

        Item {
            Layout.columnSpan: 2
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

    }

    states: [
        State {
            name: "hidden"
            PropertyChanges { target: root; x: -350; visible: false }
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
