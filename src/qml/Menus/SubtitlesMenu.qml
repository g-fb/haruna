/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQml 2.13
import QtQuick 2.13
import QtQuick.Controls 2.13

Menu {
    id: root

    title: qsTr("&Subtitles")

    Menu {
        id: primarySubtitleMenu

        title: qsTr("Primary Subtitle")
        onOpened: primarySubtitleMenuInstantiator.model = mpv.subtitleTracksModel()

        Instantiator {
            id: primarySubtitleMenuInstantiator
            model: 0
            onObjectAdded: primarySubtitleMenu.insertItem( index, object )
            onObjectRemoved: primarySubtitleMenu.removeItem( object )
            delegate: MenuItem {
                enabled: model.id !== mpv.secondarySubtitleId || model.id === 0
                checkable: true
                checked: model.id === mpv.subtitleId
                text: model.text
                onTriggered: mpv.setSubtitle(id)
            }
        }
    }

    Menu {
        id: secondarySubtitleMenu

        title: qsTr("Secondary Subtitle")
        onOpened: secondarySubtitleMenuInstantiator.model = mpv.subtitleTracksModel()

        Instantiator {
            id: secondarySubtitleMenuInstantiator
            model: 0
            onObjectAdded: secondarySubtitleMenu.insertItem( index, object )
            onObjectRemoved: secondarySubtitleMenu.removeItem( object )
            delegate: MenuItem {
                enabled: model.id !== mpv.subtitleId || model.id === 0
                checkable: true
                checked: model.id === mpv.secondarySubtitleId
                text: model.text
                onTriggered: mpv.setSecondarySubtitle(id)
            }
        }
    }

    MenuSeparator {}

    MenuItem { action: actions["subtitleQuickenAction"] }
    MenuItem { action: actions["subtitleDelayAction"] }
    MenuItem { action: actions["subtitleToggleAction"] }
}
