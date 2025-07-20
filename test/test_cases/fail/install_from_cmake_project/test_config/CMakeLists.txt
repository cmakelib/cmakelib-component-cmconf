## Test Configuration
#
# This CMakeLists.txt attempts to install from within a CMake project context
# which should trigger the "Installation can be invoked only as..." error
#

CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
PROJECT(TEMP_INSTALL_TEST)

FIND_PACKAGE(CMLIB REQUIRED)
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../../CMCONF.cmake")

SET(CMCONF_INSTALL_AS_SYMLINK ON)
CMCONF_INIT_SYSTEM(TEST)
CMCONF_SET(VARIABLE_A "test_value_a")
