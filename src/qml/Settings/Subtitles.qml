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

        spacing: 25

        SubtitlesFolders {
            id: subtitleFolders
            implicitWidth: root.width
        }

        ColumnLayout {
            Label {
                text: qsTr("Preferred subtitle language")
                color: systemPalette.text
            }
            TextField {
                text: settings.get("Subtitle", "PreferredLanguage")
                placeholderText: "eng, ger etc."
                onTextEdited: {
                    settings.set("Subtitle", "PreferredLanguage", text)
                    mpv.setProperty("slang", text)
                }
            }
        }

        RowLayout {
            Label {
                text: qsTr("Preferred subtitle track")
                color: systemPalette.text
            }
            SpinBox {
                from: 0
                to: 100
                value: settings.get("Subtitle", "PreferredTrack")
                onValueChanged: {
                    if (value === 0) {
                        settings.set("Subtitle", "PreferredTrack", value)
                        mpv.setProperty("sid", "auto")
                        return
                    }

                    settings.set("Subtitle", "PreferredTrack", value)
                    mpv.setProperty("sid", value)
                }
            }
        }
    }
}
