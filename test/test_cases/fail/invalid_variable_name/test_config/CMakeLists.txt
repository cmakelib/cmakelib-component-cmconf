## Test configuration that tries to get a variable with invalid name
#
# This should generate a fatal error when CMCONF_GET is called with invalid variable name
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_INVALID_VARIABLE_NAME_TEST_CONFIG)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../../CMCONF.cmake")

CMCONF_INIT_SYSTEM("TEST")

# Try to get a variable with invalid name (contains hyphen)
CMCONF_GET("INVALID-VAR")
