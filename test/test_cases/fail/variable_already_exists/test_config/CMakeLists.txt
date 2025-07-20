## Test configuration that tries to get a variable that's already defined in scope
#
# This should generate a fatal error when CMCONF_GET is called for a variable already defined
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_VARIABLE_ALREADY_EXISTS_TEST_CONFIG)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../../CMCONF.cmake")

CMCONF_INIT_SYSTEM("TEST")

SET(VARIABLE_A "already_defined_value")

CMCONF_GET("VARIABLE_A")
