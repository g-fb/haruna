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

find_package(KF5KIO REQUIRED)
set_package_properties(KF5KIO PROPERTIES
    TYPE REQUIRED
    URL "https://api.kde.org/frameworks/kio/html/index.html")

add_subdirectory(src)

install(FILES data/com.georgefb.haruna.desktop DESTINATION ${KDE_INSTALL_APPDIR})
install(FILES data/com.georgefb.haruna.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})
ecm_install_icons(ICONS data/256-apps-com.georgefb.haruna.svg DESTINATION ${KDE_INSTALL_ICONDIR})

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
