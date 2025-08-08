## Test configuration that should fail when trying to get undefined variable
#
# This attempts to use CMCONF_GET with an ENV variable set for a variable
# that is not defined in the configuration, which should generate a fatal error.
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_ENV_VARIABLE_CONFIG_REQUIRED_TEST_CONFIG)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../../CMCONF.cmake")

SET(ENV{TEST_UNDEFINED_VARIABLE} "env_value")

CMCONF_INIT_SYSTEM("TEST")
CMCONF_GET(UNDEFINED_VARIABLE)
