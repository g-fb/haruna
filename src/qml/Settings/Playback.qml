import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

Item {
    id: root

    property alias contentHeight: content.height

    visible: false

    ColumnLayout {
        id: content

        width: parent.width
        spacing: 25

        ColumnLayout {

            Label {
                text: "Skip chapters containing the following words"
            }

            TextField {
                text: settings.get("Playback", "SkipChaptersWordList")
                Layout.fillWidth: true
                onEditingFinished: {
                    settings.set("Playback", "SkipChaptersWordList", text)
                }
            }

            CheckBox {
                text: "Show an osd message when skipping chapters"
                checked: settings.get("Playback", "ShowOsdOnSkipChapters")
                onCheckedChanged: {
                    settings.set("Playback", "ShowOsdOnSkipChapters", checked)
                }
            }

        }

    }

}
