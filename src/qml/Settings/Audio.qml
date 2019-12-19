import QtQuick 2.0
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

Item {
    id: root

    visible: false

    ColumnLayout {
        ColumnLayout {
            Label {
                text: "Preferred audio language"
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
                text: "Preferred audio track"
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
