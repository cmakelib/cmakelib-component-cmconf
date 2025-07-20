## Test configuration that calls CMCONF_SET with a fresh variable then CMCONF_GET
#
# This should generate a fatal error when CMCONF_GET is called after CMCONF_SET
# Uses a fresh variable that's definitely not already defined
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_GET_AFTER_SET_FRESH_VAR_TEST_CONFIG)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../../CMCONF.cmake")

CMCONF_INIT_SYSTEM("TEST")

# Set a variable that's definitely not already defined
CMCONF_SET("FRESH_NEW_VAR" "fresh_value")

# Then try to call CMCONF_GET - this should fail
CMCONF_GET("ANOTHER_VAR")
