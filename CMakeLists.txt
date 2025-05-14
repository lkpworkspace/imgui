cmake_minimum_required(VERSION 3.10)
if (POLICY CMP0091)
  cmake_policy(SET CMP0091 NEW)
endif()
# see: cmake --help-policy CMP0072
if (POLICY CMP0072)
  cmake_policy(SET CMP0072 NEW)
endif()
project(imgui VERSION 1.91.9.1)

### option
option(IMGUI_WITH_DEMO "with demo" OFF)

### cmake module
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

### compile option
set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 11)
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/source-charset:utf-8>")

### install path
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
set(IMGUI_BIN_DIR "bin")
set(IMGUI_INC_DIR "include")
set(IMGUI_LIB_DIR "lib")

### deps
if (IMGUI_WITH_DEMO)
  find_package(OpenGL REQUIRED)
  find_package(glfw3 REQUIRED)
endif()

### config
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/imconfig.h.in ${CMAKE_CURRENT_SOURCE_DIR}/imconfig.h)

### source
set(imgui_srcs
  imgui_draw.cpp
  imgui_tables.cpp
  imgui_widgets.cpp
  imgui.cpp
)

### lib
add_library(${PROJECT_NAME} ${imgui_srcs})
target_include_directories(${PROJECT_NAME}
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  INTERFACE
  $<INSTALL_INTERFACE:include>
)
set_target_properties(${PROJECT_NAME} PROPERTIES VERSION ${PROJECT_VERSION})
set_target_properties(${PROJECT_NAME} PROPERTIES SOVERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR})

### demo
if (IMGUI_WITH_DEMO)
  add_executable(imgui_demo
    imgui_demo.cpp
    backends/imgui_impl_glfw.cpp
    backends/imgui_impl_opengl3.cpp
    examples/example_glfw_opengl3/main.cpp
  )
  target_include_directories(imgui_demo
    PRIVATE
    backends
  )
  target_link_libraries(imgui_demo
    PRIVATE
    ${PROJECT_NAME}
    OpenGL::GL
    glfw
    ${CMAKE_DL_LIBS}
  )
endif ()

### export file
include (GenerateExportHeader)
generate_export_header (${PROJECT_NAME}
  EXPORT_MACRO_NAME IMGUI_EXPORT
  EXPORT_FILE_NAME "${CMAKE_CURRENT_SOURCE_DIR}/export.h"
)

### install
file(GLOB imgui_header_files
  export.h
  imconfig.h
  imgui_internal.h
  imgui.h
  imstb_rectpack.h
  imstb_textedit.h
  imstb_truetype.h
)
install(FILES 
  ${imgui_header_files}
  PERMISSIONS
  OWNER_READ OWNER_WRITE
  GROUP_READ
  WORLD_READ
  DESTINATION ${IMGUI_INC_DIR}/${PROJECT_NAME}
)
install(TARGETS ${PROJECT_NAME}
  EXPORT "${PROJECT_NAME}Targets"
  LIBRARY DESTINATION ${IMGUI_LIB_DIR}
  ARCHIVE DESTINATION ${IMGUI_LIB_DIR}
  RUNTIME DESTINATION ${IMGUI_BIN_DIR}
)
if (IMGUI_WITH_DEMO)
  install(TARGETS imgui_demo
    LIBRARY DESTINATION ${IMGUI_LIB_DIR}
    ARCHIVE DESTINATION ${IMGUI_LIB_DIR}
    RUNTIME DESTINATION ${IMGUI_BIN_DIR}
  )
endif()

### install config
include(InstallingConfigs)

### package
include(Packing)
