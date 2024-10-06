include(ExternalProject)

include_guard(GLOBAL)

# cmake 3.27版本使用-S选项会报错，回退3.16编译正常
ExternalProject_Add(
    glew
    URL https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.tgz
    URL_MD5 3579164bccaef09e36c0af7f4fd5c7c7
    DOWNLOAD_NAME "glew.tar.gz"
    PREFIX ${CMAKE_BINARY_DIR}
    DOWNLOAD_DIR ${DEPS_DOWNLOAD_DIR}
    SOURCE_DIR "${DEPS_SOURCE_DIR}/glew"
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CMAKE_ARGS
        -S ${DEPS_SOURCE_DIR}/glew/build/cmake
        -DCMAKE_BUILD_TYPE=Release
        -DBUILD_UTILS=OFF
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
)

# -DBUILD_UTILS=ON