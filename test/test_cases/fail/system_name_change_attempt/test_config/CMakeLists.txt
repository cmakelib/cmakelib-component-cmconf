## Test configuration that tries to change system name after it's already set
#
# This should generate a fatal error when CMCONF_INIT_SYSTEM is called with different system name
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_SYSTEM_NAME_CHANGE_ATTEMPT_TEST_CONFIG)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../../CMCONF.cmake")

CMCONF_INIT_SYSTEM("FIRST_SYSTEM")

CMCONF_INIT_SYSTEM("SECOND_SYSTEM")
