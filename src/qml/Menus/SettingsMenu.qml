import QtQuick 2.13
import QtQuick.Controls 2.13

Menu {
    id: root

    title: qsTr("&Settings")

    MenuItem { action: actions["configureAction"] }
    MenuItem { action: actions["configureShortcutsAction"] }
}
