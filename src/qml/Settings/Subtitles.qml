import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

Item {
    id: root
    ColumnLayout {

        spacing: 25

        SubtitlesFolders {
            id: subtitleFolders
            _width: root.width
        }

        ColumnLayout {
            Label {
                text: "Preferred subtitle language"
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
                text: "Preferred subtitle track"
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
