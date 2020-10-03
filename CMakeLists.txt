#
# SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

cmake_minimum_required(VERSION 3.15)

project(haruna LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(ECM 1.0.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(KDEInstallDirs)
include(ECMInstallIcons)
include(FeatureSummary)

find_package(Qt5Core REQUIRED)
set_package_properties(Qt5Core PROPERTIES
    TYPE REQUIRED)

find_package(Qt5Quick REQUIRED)
set_package_properties(Qt5Quick PROPERTIES
    TYPE REQUIRED)

find_package(Qt5QuickControls2 REQUIRED)
set_package_properties(Qt5QuickControls2 PROPERTIES
    TYPE REQUIRED)

find_package(KF5Config REQUIRED)
set_package_properties(KF5Config PROPERTIES
    TYPE REQUIRED
    URL "https://api.kde.org/frameworks/kconfig/html/index.html")

find_package(KF5CoreAddons REQUIRED)
set_package_properties(KF5CoreAddons PROPERTIES
    TYPE REQUIRED
    URL "https://api.kde.org/frameworks/kcoreaddons/html/index.html")

find_package(KF5FileMetaData REQUIRED)
set_package_properties(KF5FileMetaData PROPERTIES
    TYPE REQUIRED
    URL "https://api.kde.org/frameworks/kfilemetadata/html/index.html")

find_package(KF5I18n REQUIRED)
set_package_properties(KF5I18n PROPERTIES
    TYPE REQUIRED
    URL "https://api.kde.org/frameworks/ki18n/html/index.html")

find_package(KF5XmlGui REQUIRED)
set_package_properties(KF5XmlGui PROPERTIES
    TYPE REQUIRED
    URL "https://api.kde.org/frameworks/kxmlgui/html/index.html")

set(${PROJECT_NAME}_SRC
    src/application.cpp
    src/haction.cpp
    src/lockmanager.cpp
    src/main.cpp
    src/mpvobject.cpp
    src/qthelper.h
    src/playlist/playlistitem.cpp
    src/playlist/playlistmodel.cpp
    src/Settings/audiosettings.cpp
    src/Settings/generalsettings.cpp
    src/Settings/mousesettings.cpp
    src/Settings/playbacksettings.cpp
    src/Settings/playlistsettings.cpp
    src/Settings/settings.cpp
    src/Settings/subtitlessettings.cpp
    src/Settings/videosettings.cpp
    src/subtitlesfoldersmodel.cpp
    src/track.cpp
    src/tracksmodel.cpp
    src/worker.cpp
    src/qml.qrc
    help/help.qrc
)

qt5_add_dbus_interface(${PROJECT_NAME}_SRC org.freedesktop.ScreenSaver.xml screensaverdbusinterface)
add_executable(${PROJECT_NAME} ${${PROJECT_NAME}_SRC})
target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt5::Core
    Qt5::Quick
    Qt5::QuickControls2

    KF5::ConfigGui
    KF5::CoreAddons
    KF5::FileMetaData
    KF5::I18n
    KF5::XmlGui
    mpv
)

ecm_install_icons(ICONS data/256-apps-com.georgefb.haruna.svg DESTINATION ${KDE_INSTALL_ICONDIR})
install(TARGETS ${PROJECT_NAME} DESTINATION ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
install(FILES data/com.georgefb.haruna.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})
install(PROGRAMS data/com.georgefb.haruna.desktop DESTINATION ${KDE_INSTALL_APPDIR})

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
