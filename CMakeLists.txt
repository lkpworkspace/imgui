cmake_minimum_required(VERSION 3.10)
if (POLICY CMP0091)
  cmake_policy(SET CMP0091 NEW)
endif()
# see: cmake --help-policy CMP0072
if (POLICY CMP0072)
  cmake_policy(SET CMP0072 NEW)
endif()
project(imgui VERSION 1.91.0)

### option
option(IMGUI_USE_OPENGL_LOADER_CUSTOM "Using custom opengl loader" OFF)

### cmake module
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

### compile option
set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
if (CMAKE_CXX_STANDARD_REQUIRED)
  message(STATUS "Set cxx standard ${CMAKE_CXX_STANDARD}")
else()
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
  set(CMAKE_CXX_STANDARD 17)
  message(STATUS "Set default cxx standard 17")
endif()
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/source-charset:utf-8>")

### install path
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  message(STATUS "Set default install prefix ${CMAKE_INSTALL_PREFIX}")
else()
  message(STATUS "Set install prefix ${CMAKE_INSTALL_PREFIX}")
endif()
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
set(IMGUI_BIN_DIR "bin")
set(IMGUI_INC_DIR "include")
set(IMGUI_LIB_DIR "lib")
set(IMGUI_CONF_DIR "conf")

### deps
find_package(OpenGL REQUIRED)
find_package(glfw3 REQUIRED)
if (IMGUI_USE_OPENGL_LOADER_CUSTOM)
  find_package(glew REQUIRED)
endif()

### config
configure_file (${CMAKE_CURRENT_SOURCE_DIR}/imconfig.h.in ${CMAKE_CURRENT_SOURCE_DIR}/imconfig.h)

### source
aux_source_directory(. __srcs)
list(APPEND __srcs "backends/imgui_impl_glfw.cpp" "backends/imgui_impl_opengl3.cpp")
message(STATUS "imgui src file: ${__srcs}")

### lib
add_library(${PROJECT_NAME} ${__srcs})
target_include_directories(${PROJECT_NAME}
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  INTERFACE
  $<INSTALL_INTERFACE:include>
)
target_link_libraries(${PROJECT_NAME}
  PRIVATE
  ${CMAKE_DL_LIBS}
  PUBLIC
  OpenGL::GL
  glfw
)
if (IMGUI_USE_OPENGL_LOADER_CUSTOM)
  target_link_libraries(${PROJECT_NAME}
    PUBLIC
    GLEW::glew
  )
endif ()
set_target_properties(${PROJECT_NAME} PROPERTIES VERSION ${PROJECT_VERSION})
set_target_properties(${PROJECT_NAME} PROPERTIES SOVERSION ${PROJECT_VERSION_MAJOR})

### exec
if (NOT IMGUI_USE_OPENGL_LOADER_CUSTOM)
  add_executable(imgui_demo "examples/example_glfw_opengl3/main.cpp")
  target_include_directories(imgui_demo
    PRIVATE
    backends
  )
  target_link_libraries(imgui_demo
    PRIVATE
    ${PROJECT_NAME}
  )
endif ()

### export file
include (GenerateExportHeader)
generate_export_header (${PROJECT_NAME}
  EXPORT_MACRO_NAME IMGUI_EXPORT
  EXPORT_FILE_NAME "${CMAKE_CURRENT_SOURCE_DIR}/export.h"
)

### install
file(GLOB header_files
  imconfig.h
  imgui_internal.h
  export.h
  imgui.h
  imstb_rectpack.h
  imstb_textedit.h
  imstb_truetype.h
  backends/imgui_impl_glfw.h
  backends/imgui_impl_opengl3.h
)
if (NOT IMGUI_USE_OPENGL_LOADER_CUSTOM)
  list(APPEND header_files backends/imgui_impl_opengl3_loader.h)
endif()
install(FILES 
  ${header_files}
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
if (NOT IMGUI_USE_OPENGL_LOADER_CUSTOM)
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
