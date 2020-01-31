import QtQuick 2.13
import QtQuick.Controls 2.13

Menu {
    id: root

    title: qsTr("&View")

    MenuItem {
        action: actions["toggleMenuBarAction"]
        text: menuBar.visible ? qsTr("Hide Menu Bar") : qsTr("Show Menu Bar")
    }
    MenuItem {
        action: actions["toggleHeaderAction"]
        text: header.visible ? qsTr("Hide Header") : qsTr("Show Header")
    }
}
