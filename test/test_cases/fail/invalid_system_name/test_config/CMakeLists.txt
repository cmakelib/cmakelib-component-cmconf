## Test configuration that tries to initialize system with invalid name
#
# This should generate a fatal error when CMCONF_INIT_SYSTEM is called with invalid system name
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_INVALID_SYSTEM_NAME_TEST_CONFIG)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../../CMCONF.cmake")

CMCONF_INIT_SYSTEM("INVALID-SYSTEM")
