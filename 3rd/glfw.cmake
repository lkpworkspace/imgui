include(ExternalProject)

include_guard(GLOBAL)

ExternalProject_Add(
    glfw
    URL https://github.com/glfw/glfw/archive/refs/tags/3.4.tar.gz
    URL_MD5 7470db601fcf36f0604d32b537281a70
    DOWNLOAD_NAME "glfw.tar.gz"
    PREFIX ${CMAKE_BINARY_DIR}
    DOWNLOAD_DIR ${DEPS_DOWNLOAD_DIR}
    SOURCE_DIR "${DEPS_SOURCE_DIR}/glfw"
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=Release
        -DBUILD_SHARED_LIBS=ON
        -DGLFW_BUILD_EXAMPLES=OFF
        -DGLFW_BUILD_TESTS=OFF
        -DGLFW_BUILD_DOCS=OFF
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
)
