import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

Item {
    id: root

    property alias contentHeight: content.height

    visible: false
    height: parent.height

    ColumnLayout {
        id: content

        CheckBox {
            checked: settings.get("Playlist", "CanToogleWithMouse")
            text: qsTr("Toggle with mouse")
            onCheckStateChanged: {
                settings.set("Playlist", "CanToogleWithMouse", checked)
                playList.canToggleWithMouse = checked
            }
        }
        RowLayout {
            Label {
                text: "Playlist Position"
            }
            ComboBox {
                textRole: "key"
                Layout.fillWidth: true
                model: ListModel {
                    id: leftButtonModel
                    ListElement { key: "Left"; value: "left" }
                    ListElement { key: "Right"; value: "right" }
                }
                Component.onCompleted: {
                    for (var i = 0; i < model.count; ++i) {
                        if (model.get(i).value === settings.get("Playlist", "Position")) {
                            currentIndex = i
                            break
                        }
                    }
                }
                onActivated: {
                    settings.set("Playlist", "Position", model.get(index).value)
                    playList.position = model.get(index).value
                }
            }
        }

        RowLayout {

            Label {
                text: "Playlist Row Height"
            }

            SpinBox {
                from: 10
                to: 100
                value: settings.get("Playlist", "RowHeight")
                onValueChanged: {
                    settings.set("Playlist", "RowHeight", value)
                    playList.rowHeight = value
                    playList.tableView.forceLayout()
                }
            }

        }

        RowLayout {

            Label {
                text: "Playlist Row Spacing"
            }

            SpinBox {
                from: 0
                to: 100
                value: settings.get("Playlist", "RowSpacing")
                onValueChanged: {
                    settings.set("Playlist", "RowSpacing", value)
                    playList.rowSpacing = value
                }
            }

        }

    }
}
