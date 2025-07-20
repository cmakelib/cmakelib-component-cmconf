## Test configuration that tries to get a variable that doesn't exist
#
# This should generate a fatal error when CMCONF_GET is called for a non-existent variable
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_VARIABLE_NOT_DEFINED_TEST_CONFIG)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../../CMCONF.cmake")

CMCONF_INIT_SYSTEM("TEST")
CMCONF_GET("NONEXISTENT_VAR")
