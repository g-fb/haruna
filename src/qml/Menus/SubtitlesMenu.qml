import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQml 2.13

Menu {
    id: subtitlesMenu

    title: qsTr("&Subtitles")

    MenuItem { action: actions["subtitleQuickenAction"] }
    MenuItem { action: actions["subtitleDelayAction"] }
    MenuItem { action: actions["subtitleToggleAction"] }
}
