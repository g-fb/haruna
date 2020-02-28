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

find_package(Qt5 COMPONENTS
    Core
    Quick
    QuickControls2
)
find_package(KF5 COMPONENTS
    Config
    CoreAddons
    XmlGui
    FileMetaData
    I18n
)

set(${PROJECT_NAME}_SRC
    src/main.cpp
    src/application.cpp
    src/settings.cpp
    src/lockmanager.cpp
    src/mpvobject.cpp
    src/subtitlesfoldersmodel.cpp
    src/track.cpp
    src/tracksmodel.cpp
    src/worker.cpp
    src/qml.qrc
)

add_subdirectory(src/playlist)

qt5_add_dbus_interface(${PROJECT_NAME}_SRC org.freedesktop.ScreenSaver.xml screensaverdbusinterface)
add_executable(${PROJECT_NAME} ${${PROJECT_NAME}_SRC})
target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt5::Core
    Qt5::Quick
    Qt5::QuickControls2
    KF5::ConfigCore
    KF5::CoreAddons
    KF5::FileMetaData
    KF5::XmlGui
    KF5::I18n
    mpv
)

ecm_install_icons(ICONS data/256-apps-com.georgefb.haruna.svg DESTINATION ${KDE_INSTALL_ICONDIR})
install(TARGETS ${PROJECT_NAME} DESTINATION ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
install(FILES data/com.georgefb.haruna.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})
install(PROGRAMS data/com.georgefb.haruna.desktop DESTINATION ${KDE_INSTALL_APPDIR})
