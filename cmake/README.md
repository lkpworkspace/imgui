# imgui

## 构建
```sh
mypm install -p ${PWD}/output --one_folder glfw,3.4
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=output -DCMAKE_PREFIX_PATH=output -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=TRUE
cmake --build build -j --config Release --target install
```
