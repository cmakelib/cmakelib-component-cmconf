## Test Configuration
#
# This CMakeLists.txt attempts to uninstall from within a CMake project context
# which should trigger the "Uninstalation can be invoked only as..." error
#

CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
PROJECT(TEMP_UNINSTALL_TEST)

FIND_PACKAGE(CMLIB REQUIRED)
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../../CMCONF.cmake")

SET(CMCONF_UNINSTALL ON)
CMCONF_INIT_SYSTEM(TEST)
