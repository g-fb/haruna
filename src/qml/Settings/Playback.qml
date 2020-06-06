/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import AppSettings 1.0

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
                checked: AppSettings.playbackSkipChapters
                onCheckedChanged: AppSettings.playbackSkipChapters = checked
            }

            Label {
                text: qsTr("Skip chapters containing the following words")
                enabled: skipChaptersCheckBox.checked
            }

            TextField {
                text: AppSettings.playbackChaptersToSkip
                enabled: skipChaptersCheckBox.checked
                Layout.fillWidth: true
                onEditingFinished: AppSettings.playbackChaptersToSkip = text
            }

            CheckBox {
                text: qsTr("Show an osd message when skipping chapters")
                enabled: skipChaptersCheckBox.checked
                checked: AppSettings.playbackShowOsdOnSkipChapters
                onCheckedChanged: AppSettings.playbackShowOsdOnSkipChapters = checked
            }
        }

    }

}
