cmake_minimum_required(VERSION 3.21)
project(QHUD VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Quick
    QuickControls2
)

qt_add_executable(QHUD
    main.cpp
    resources/qml.qrc
    # Config
    config/AppConfig.h
    config/AppConfig.cpp
    config/ThemeConfig.h
    config/ThemeConfig.cpp
    config/MapConfig.h
    config/MapConfig.cpp
    # Model
    model/TelemetryTypes.h
    model/RouteCalculator.h
    model/RouteCalculator.cpp
    model/TelemetryEngine.h
    model/TelemetryEngine.cpp
    model/PlaylistModel.h
    model/PlaylistModel.cpp
    # ViewModel
    viewmodel/BaseViewModel.h
    viewmodel/TelemetryViewModel.h
    viewmodel/TelemetryViewModel.cpp
    viewmodel/MediaViewModel.h
    viewmodel/MediaViewModel.cpp
    viewmodel/ScreenViewModel.h
    viewmodel/ScreenViewModel.cpp
)

target_include_directories(QHUD PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(QHUD PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::QuickControls2
)

set_target_properties(QHUD PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

install(TARGETS QHUD
    BUNDLE DESTINATION .
    RUNTIME DESTINATION bin
)
