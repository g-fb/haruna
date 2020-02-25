import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.11 as Kirigami

Popup {
    id: root

    property int actionIndex: -1

    signal actionSelected(string actionName)

    implicitHeight: parent.height * 0.9
    implicitWidth: parent.width* 0.9
    modal: true
    anchors.centerIn: parent

    onOpened: {
        filterActionsField.text = ""
        filterActionsField.forceActiveFocus(Qt.MouseFocusReason)
    }

    ColumnLayout {
        anchors.fill: parent

        TextField {
            id: filterActionsField

            placeholderText: qsTr("Type to filter...")
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            onTextChanged: {
                const menuModel = actionsListView.actionsList
                actionsListView.model = menuModel.filter(action => action.toLowerCase().includes(text))
            }
        }
        Kirigami.BasicListItem {
            height: 30
            width: parent.width
            label: qsTr("None")
            reserveSpaceForIcon: false

            onDoubleClicked: {
                console.log(222)
                actionSelected("")
                root.close()
            }
        }

        ListView {
            id: actionsListView

            property var actionsList: Object.keys(actions.list).sort()

            implicitHeight: 30 * model.count
            model: actionsList
            spacing: 1
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop
            delegate: Kirigami.BasicListItem {
                height: 30
                width: parent.width
                label: modelData
                reserveSpaceForIcon: false

                onDoubleClicked: {
                    console.log(222)
                    actionSelected(modelData)
                    root.close()
                }
            }
        }
    }
}
