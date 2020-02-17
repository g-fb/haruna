/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

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

            CheckBox {
                id: skipChaptersCheckBox
                text: qsTr("Skip chapters")
                checked: settings.get("Playback", "SkipChapters")
                onCheckedChanged: {
                    settings.set("Playback", "SkipChapters", checked)
                    hSettings.skipChaptersChanged(checked)
                }

                Connections {
                    target: hSettings
                    onSkipChaptersChanged: skipChaptersCheckBox.checked = checked
                }
            }

            Label {
                text: qsTr("Skip chapters containing the following words")
                color: systemPalette.text
                enabled: skipChaptersCheckBox.checked
            }

            TextField {
                text: settings.get("Playback", "SkipChaptersWordList")
                enabled: skipChaptersCheckBox.checked
                Layout.fillWidth: true
                onEditingFinished: {
                    settings.set("Playback", "SkipChaptersWordList", text)
                }
            }

            CheckBox {
                text: qsTr("Show an osd message when skipping chapters")
                enabled: skipChaptersCheckBox.checked
                checked: settings.get("Playback", "ShowOsdOnSkipChapters")
                onCheckedChanged: {
                    settings.set("Playback", "ShowOsdOnSkipChapters", checked)
                }
            }
        }

    }

}
