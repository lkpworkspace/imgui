# repos

## 使用示例
* 编写下载安装依赖库CMakeLists.txt，可以参考本仓库CMakeLists.txt
```sh
# CMAKE_INSTALL_PREFIX：指定依赖库安装位置
# DEPS_DOWNLOAD_DIR：指定依赖库源码包下载位置
# DEPS_SOURCE_DIR：指定依赖库源码所在位置
# 交叉编译时使用该选项：
#   -DCMAKE_TOOLCHAIN_FILE=toolchain-aarch64.cmake.example
# 配置依赖库

# for unix like
cd 3rd
cmake -S . -B build \
    -DCMAKE_INSTALL_PREFIX=../output \
    -DDEPS_DOWNLOAD_DIR=./pkg \
    -DDEPS_SOURCE_DIR=./src

# for windows
cmake -S . -B build `
    -DCMAKE_INSTALL_PREFIX="../output" `
    -DDEPS_DOWNLOAD_DIR=pkg `
    -DDEPS_SOURCE_DIR=src

# 构建依赖库
cmake --build build -j --config Release
```

* 依赖库生成完成即可构建主库
```sh
# 配置构建主库
cmake -S . -B build -DCMAKE_INSTALL_PREFIX="./output" -DCMAKE_PREFIX_PATH="./output"
cmake --build build -j --config Release --target install
```
