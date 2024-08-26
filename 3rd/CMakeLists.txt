cmake_minimum_required(VERSION 3.10)
if (POLICY CMP0091)
  cmake_policy(SET CMP0091 NEW)
endif()
project(imgui_3rd VERSION 1.0.0)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}")

set(DEPS_SOURCE_DIR ${CMAKE_SOURCE_DIR}/src CACHE PATH "package source dir")
set(DEPS_DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}/pkg CACHE PATH "package tgz dir")
set(DEPS_PATCH_DIR ${CMAKE_SOURCE_DIR}/patch CACHE PATH "package tgz dir")

# include(glew)
include(glfw)
