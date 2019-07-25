import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

ToolBar {
    id: root
    position: ToolBar.Header

    RowLayout {
        id: headerRow
        width: parent.width

        RowLayout {
            id: headerRowLeft
            Layout.alignment: Qt.AlignLeft
            ToolButton {
                action: openAction
            }
        }

        RowLayout {
            id: headerRowCenter
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            id: headerRowRight
            Layout.alignment: Qt.AlignRight

            ToolButton {
                text: qsTr("Playlist")
                onClicked: (playList.state === "hidden") ? playList.state = "visible" : playList.state = "hidden"
            }

            ToolButton {
                action: appQuitAction
            }
        }
    }
}
