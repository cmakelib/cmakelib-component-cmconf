## Test configuration that tries to use CMCONF_GET without setting system
#
# This should generate a fatal error when CMCONF_GET is called without CMCONF_INIT_SYSTEM
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_SYSTEM_NOT_SET_TEST_CONFIG)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../../CMCONF.cmake")

CMCONF_GET("TEST_VAR")
