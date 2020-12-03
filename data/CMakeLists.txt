#
# SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

add_subdirectory(color-schemes)

install(FILES com.georgefb.haruna.desktop DESTINATION ${KDE_INSTALL_APPDIR})
install(FILES com.georgefb.haruna.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})
ecm_install_icons(ICONS 256-apps-com.georgefb.haruna.svg DESTINATION ${KDE_INSTALL_ICONDIR})
