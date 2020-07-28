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
        // ------------------------------------
        // Screenshot template
        // ------------------------------------
        ColumnLayout {
            Label {
                text: qsTr("Screenshot Template")
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
