#
# SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

if(InstallColorSchemes)
    install(FILES Breeze.colors
        DESTINATION ${DATA_INSTALL_DIR}/color-schemes/)
    install(FILES BreezeDark.colors
            DESTINATION ${DATA_INSTALL_DIR}/color-schemes/)
    install(FILES BreezeHighContrast.colors
            DESTINATION ${DATA_INSTALL_DIR}/color-schemes/)
    install(FILES BreezeLight.colors
            DESTINATION ${DATA_INSTALL_DIR}/color-schemes/)
endif()
