import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

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
        Button {
            text: "Mouse"
            Layout.fillWidth: true
            onClicked: {
                settingsViewLoader.sourceComponent = mouseSettings
            }
        }
    }
}
