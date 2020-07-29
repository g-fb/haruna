/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import org.kde.kirigami 2.11 as Kirigami

import AppSettings 1.0

Item {
    id: root

    property bool hasHelp: true
    property string helpFile: ":/PlaybackSettings.html"

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

            // ------------------------------------
            // Youtube-dl format settings
            // ------------------------------------
            Item { height: 20 }

            Label { text: qsTr("Youtube-dl format selection") }
            RowLayout {
                ComboBox {
                    id: ytdlFormatComboBox
                    textRole: "key"
                    valueRole: "value"
                    model: ListModel {
                        id: leftButtonModel
                        ListElement { key: "Custom"; value: "" }
                        ListElement { key: "2160"; value: "bestvideo[height<=2160]+bestaudio/best" }
                        ListElement { key: "1440"; value: "bestvideo[height<=1440]+bestaudio/best" }
                        ListElement { key: "1080"; value: "bestvideo[height<=1080]+bestaudio/best" }
                        ListElement { key: "720"; value: "bestvideo[height<=720]+bestaudio/best" }
                        ListElement { key: "480"; value: "bestvideo[height<=480]+bestaudio/best" }
                    }
                    ToolTip {
                        text: qsTr("Selects the best video with a height lower than or equal to the selected value.")
                    }

                    onActivated: {
                        if (index === 0) {
                            ytdlFormatField.text = AppSettings.playbackYtdlFormat
                        }
                        if(index > 0) {
                            ytdlFormatField.focus = true
                            ytdlFormatField.text = model.get(index).value
                        }
                    }

                    Component.onCompleted: {
                        let i = indexOfValue(AppSettings.playbackYtdlFormat)
                        currentIndex = (i === -1) ? 0 : i
                    }
                }
            }
            TextField {
                id: ytdlFormatField
                text: AppSettings.playbackYtdlFormat
                Layout.fillWidth: true
                onEditingFinished: AppSettings.playbackYtdlFormat = text
                placeholderText: qsTr("bestvideo+bestaudio/best")

                onTextChanged: {
                    if (ytdlFormatComboBox.currentValue !== ytdlFormatField.text) {
                        ytdlFormatComboBox.currentIndex = 0
                        return;
                    }
                    if (ytdlFormatComboBox.indexOfValue(ytdlFormatField.text) !== -1) {
                        ytdlFormatComboBox.currentIndex = ytdlFormatComboBox.indexOfValue(ytdlFormatField.text)
                        return;
                    }
                }
            }
            TextEdit {
                text: qsTr("Leave empty for default value: <i>bestvideo+bestaudio/best</i>")
                color: Kirigami.Theme.textColor
                readOnly: true
                wrapMode: Text.WordWrap
                textFormat: TextEdit.RichText
                selectByMouse: true
                Layout.fillWidth: true
            }
            // ------------------------------------
            // END - Youtube-dl format settings
            // ------------------------------------
        }
    }
}
