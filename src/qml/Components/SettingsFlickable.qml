import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQml 2.12

import org.kde.kirigami 2.11 as Kirigami

Flickable {
    id: root

    property int scrollStepSize: 30
    property int scrollBarWidth: scrollbar.width

    width: parent.width
    height: parent.height
    contentWidth: width - scrollBarWidth - Kirigami.Units.largeSpacing
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    flickableDirection: Flickable.VerticalFlick

    ScrollBar.vertical: ScrollBar {
        id: scrollbar
        policy: ScrollBar.AlwaysOn
        stepSize: scrollStepSize/contentHeight
    }

    MouseArea {
        anchors.fill: parent
        onWheel: {
            if (wheel.angleDelta.y > 0) {
                scrollbar.decrease()
            } else {
                scrollbar.increase()
            }
        }
    }
}
