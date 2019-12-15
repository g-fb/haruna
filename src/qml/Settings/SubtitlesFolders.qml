import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

// Subtitles Folders
Item {
    id: root

    property int _width
    // prevent creating multiple empty items
    // until the new one has been saved
    property bool canAddFolder: true

    Layout.columnSpan: 2
    Layout.fillWidth: true
    width: _width
    height: sectionTitle.height + sfListView.height + sfAddFolder.height + 25

    Label {
        id: sectionTitle
        color: systemPalette.text
        bottomPadding: 10
        text: "Subtitles folders"
    }

    ListView {
        id: sfListView
        property int sfDelegateHeight: 40
        property int rows: subsFoldersModel.rowCount()
        anchors.top: sectionTitle.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: rows > 5
                ? 5 * sfListView.sfDelegateHeight + (sfListView.spacing * 4)
                : rows * sfListView.sfDelegateHeight + (sfListView.spacing * (rows - 1))
        spacing: 5
        clip: true
        model: subsFoldersModel
        ScrollBar.vertical: ScrollBar { id: scrollBar }
        delegate: Rectangle {
            id: sfDelegate
            width: _width
            height: sfListView.sfDelegateHeight
            color: systemPalette.base

            Loader {
                id: sfLoader
                anchors.fill: parent
                sourceComponent: model.display === "" ? sfEditComponent : sfDisplayComponent
            }

            Component {
                id: sfDisplayComponent

                RowLayout {

                    Label {
                        id: sfLabel
                        text: model.display
                        leftPadding: 10
                        Layout.fillWidth: true
                    }

                    Button {
                        icon.name: "edit-entry"
                        flat: true
                        onClicked: {
                            sfLoader.sourceComponent = sfEditComponent
                        }
                    }

                    Item { width: scrollBar.width }
                }
            } // Component: display

            Component {
                id: sfEditComponent

                RowLayout {

                    TextField {
                        id: editField
                        leftPadding: 10
                        text: model.display
                        Layout.leftMargin: 5
                        Layout.fillWidth: true
                        Component.onCompleted: editField.forceActiveFocus(Qt.MouseFocusReason)
                    }

                    Button {
                        property bool canDelete: editField.text === ""
                        icon.name: "delete"
                        flat: true
                        onClicked: {
                            if (!canDelete) {
                                text = "Click again to delete"
                                canDelete = true
                                return
                            }

                            if (model.row === subsFoldersModel.rowCount() - 1) {
                                root.canAddFolder = true
                            }
                            subsFoldersModel.deleteFolder(model.row)
                            var rows = subsFoldersModel.rowCount()
                            sfListView.height = rows > 5
                                    ? 5 * sfListView.sfDelegateHeight + (sfListView.spacing * 4)
                                    : rows * sfListView.sfDelegateHeight + (sfListView.spacing * (rows - 1))

                        }
                        ToolTip {
                            text: "Delete this folder from list"
                        }
                    }

                    Button {
                        icon.name: "dialog-ok"
                        flat: true
                        enabled: editField.text !== "" ? true : false
                        onClicked: {
                            subsFoldersModel.updateFolder(editField.text, model.row)
                            sfLoader.sourceComponent = sfDisplayComponent
                            if (model.row === subsFoldersModel.rowCount() - 1) {
                                root.canAddFolder = true
                            }
                        }
                        ToolTip {
                            text: "Save changes"
                        }
                    }

                    Item { width: scrollBar.width }
                }
            } // Component: edit
        } // delegate: Rectangle
    }

    Item {
        id: spacer
        anchors.top: sfListView.bottom
        height: 5
    }

    Button {
        id: sfAddFolder
        anchors.top: spacer.bottom
        icon.name: "list-add"
        text: "Add new folder"
        enabled: root.canAddFolder
        onClicked: {
            subsFoldersModel.addFolder()
            var rows = subsFoldersModel.rowCount()
            sfListView.height = rows > 5
                    ? 5 * sfListView.sfDelegateHeight + (sfListView.spacing * 4)
                    : rows * sfListView.sfDelegateHeight + (sfListView.spacing * (rows - 1))
            root.canAddFolder = false
        }
        ToolTip {
            text: "Add new subtitles folder to the list"
        }
    }
}
