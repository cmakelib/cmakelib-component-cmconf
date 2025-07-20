
# CMCONF Example

This directory contains example of usage of CMCONF component.

The example consists of two parts:

- `config/CMCONF_EXAMPLEConfig.cmake` - configuration file
- `CMakeLists.txt` - project file which uses the configuration

## Usage

### Install Configuration

- Configuration file is installed by running CMake in script mode.

```
cmake -DCMCONF_INSTALL_AS_SYMLINK=ON -P config/CMCONF_EXAMPLEConfig.cmake
cmake -P ./CMakeLists.txt
mkdir _build && cd _build
cmake ..
```

### Uninstall Configuration

```
cmake -DCMCONF_UNINSTALL=ON -P config/CMCONF_EXAMPLEConfig.cmake
```

### Use In CMake Project

Example project can be found in [CMakeLists.txt] file.

```cmake
FIND_PACKAGE(CMLIB COMPONENTS CMCONF REQUIRED)

CMCONF_INIT_SYSTEM("EXAMPLE")

CMCONF_GET("VARIABLE_A")
CMCONF_GET(IS_IT_OK)
CMCONF_GET(GOOGLE_URI)

MESSAGE(STATUS "VARIABLE_A: ${VARIABLE_A}")
MESSAGE(STATUS "IS_IT_OK:   ${IS_IT_OK}")
MESSAGE(STATUS "GOOGLE_URI: ${GOOGLE_URI}")
```


[CmakeLists.txt]: ./CMakeLists.txt
