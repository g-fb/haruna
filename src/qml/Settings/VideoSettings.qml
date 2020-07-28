/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import org.kde.kirigami 2.11 as Kirigami
import VideoSettings 1.0

Item {
    id: root

    anchors.fill: parent

    ColumnLayout {
        width: parent.width

        RowLayout {
            Label {
                text: qsTr("Screenshots")
            }
            Rectangle {
                height: 1
                color: Kirigami.Theme.alternateBackgroundColor
                Layout.fillWidth: true
            }
        }

        // ------------------------------------
        // Screenshot Format
        // ------------------------------------
        RowLayout {
            Label { text: qsTr("Format") }

            ComboBox {
                id: screenshotFormat
                textRole: "key"
                valueRole: "value"
                model: ListModel {
                    id: leftButtonModel
                    ListElement { key: "PNG"; value: "png" }
                    ListElement { key: "JPG"; value: "jpg" }
                    ListElement { key: "WebP"; value: "webp" }
                }

                onActivated: {
                    VideoSettings.screenshotFormat = model.get(index).value
                    mpv.setProperty("screenshot-format", VideoSettings.screenshotFormat)
                }

                Component.onCompleted: {
                    let i = indexOfValue(VideoSettings.screenshotFormat)
                    currentIndex = (i === -1) ? 0 : i
                }
            }
        }

        // ------------------------------------
        // Screenshot template
        // ------------------------------------
        ColumnLayout {
            Label {
                text: qsTr("Template")
            }

            TextField {
                text: VideoSettings.screenshotTemplate
                onEditingFinished: {
                    VideoSettings.screenshotTemplate = text
                    mpv.setProperty("screenshot-template", VideoSettings.screenshotTemplate)
                }
                Layout.fillWidth: true
            }
        }
    }
}
