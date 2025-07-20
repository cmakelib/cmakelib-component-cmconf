## Main
#
# Test CMCONF_GET error when called after CMCONF_SET
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_GET_AFTER_SET_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../TEST.cmake")

TEST_RUN_AND_CHECK_OUTPUT("test_config"
    FATAL_ERROR_MESSAGE "CMCONF\\\\[TEST\\\\] - CMCONF_GET cannot be called once CMCONF_SET is called\\."
)

# Test with fresh variable that's not already set
TEST_RUN_AND_CHECK_OUTPUT("test_config_fresh_var"
    FATAL_ERROR_MESSAGE "CMCONF\\\\[TEST\\\\] - CMCONF_GET cannot be called once CMCONF_SET is called\\."
)
