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
    state: "visible"

    Item {
        id: nav
        width: root.width * 0.3 - root.padding
        height: parent.height
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Rectangle {
            width: 1
            height: parent.height
            anchors.right: parent.right
            color: systemPalette.base
        }

        ColumnLayout {
            width: parent.width - root.padding
            Button {
                text: "General"
                Layout.fillWidth: true
                onClicked: {
                    settingsViewLoader.sourceComponent = generalSettings
                }
            }
            Button {
                text: "Color Adjustments"
                Layout.fillWidth: true
                onClicked: {
                    settingsViewLoader.sourceComponent = colorAdjustmentsSettings
                }
            }
        }
    }

    Loader {
        id: settingsViewLoader
        anchors.left: nav.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: root.padding
//        anchors.rightMargin: root.padding
        sourceComponent: generalSettings
    }

    Component {
        id: generalSettings
        GeneralSettings {
            width: root.width * 0.7 - root.padding
        }
    }
    Component {
        id: colorAdjustmentsSettings
        ColorAdjustmentsSettings {
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
