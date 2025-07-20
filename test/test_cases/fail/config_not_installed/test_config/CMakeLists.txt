## Test configuration that tries to get a variable from non-installed configuration
#
# This should generate a fatal error when CMCONF_GET is called for a system with no configuration
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_CONFIG_NOT_INSTALLED_TEST_CONFIG)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../../CMCONF.cmake")

CMCONF_INIT_SYSTEM("NONEXISTENT_SYSTEM")
CMCONF_GET("ANY_VAR")
