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

        ColumnLayout {
            Label {
                text: qsTr("Preferred audio language")
                color: systemPalette.text
            }
            TextField {
                text: settings.get("Audio", "PreferredLanguage")
                placeholderText: "eng, ger etc."
                onTextEdited: {
                    settings.set("Audio", "PreferredLanguage", text)
                    mpv.setProperty("alang", text)
                }
            }
        }
        RowLayout {
            Label {
                text: qsTr("Preferred audio track")
                color: systemPalette.text
            }
            SpinBox {
                from: 0
                to: 100
                value: settings.get("Audio", "PreferredTrack")
                onValueChanged: {
                    if (value === 0) {
                        settings.set("Audio", "PreferredTrack", value)
                        mpv.setProperty("aid", "auto")
                        return
                    }

                    settings.set("Audio", "PreferredTrack", value)
                    mpv.setProperty("aid", value)
                }
            }
        }
    }
}
