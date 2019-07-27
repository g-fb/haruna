cmake_minimum_required(VERSION 3.1)

project(haruna LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_definitions(-D_UNICODE)
find_package(ECM 1.0.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(KDEInstallDirs)

find_package(Qt5 COMPONENTS
    Core
    Quick
    QuickControls2
)
find_package(KF5 COMPONENTS
    Config
    XmlGui
    I18n
)

set(${PROJECT_NAME}_SRC
    src/main.cpp
    src/application.cpp
    src/mpvobject.cpp
    src/track.cpp
    src/tracksmodel.cpp
    src/videolistmodel.cpp
    src/videolist.cpp
    src/videoitem.cpp
    src/worker.cpp
    src/qml.qrc
)

kconfig_add_kcfg_files(${PROJECT_NAME}_SRC GENERATE_MOC settings.kcfgc)

add_executable(${PROJECT_NAME} ${${PROJECT_NAME}_SRC})
target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt5::Core
    Qt5::Quick
    Qt5::QuickControls2
    KF5::ConfigCore
    KF5::XmlGui
    KF5::I18n
    mpv
    mediainfo
)

install(TARGETS ${PROJECT_NAME} DESTINATION ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
install(FILES settings.kcfg DESTINATION ${KCFG_INSTALL_DIR})
