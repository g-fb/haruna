import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import org.kde.kirigami 2.11 as Kirigami

RowLayout {
    id: root

    property string text: ""

    Rectangle {
        height: 1
        color: Kirigami.Theme.alternateBackgroundColor
        Layout.fillWidth: true
    }

    Kirigami.Heading {
        text: root.text
    }

    Rectangle {
        height: 1
        color: Kirigami.Theme.alternateBackgroundColor
        Layout.fillWidth: true
    }
}
