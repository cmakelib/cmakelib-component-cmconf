## Main
#
# Test CMCONF_INIT_SYSTEM error when system name contains invalid characters
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_INVALID_SYSTEM_NAME_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../TEST.cmake")

TEST_RUN_AND_CHECK_OUTPUT("test_config"
    FATAL_ERROR_MESSAGE "CMCONF - Invalid system name 'INVALID-SYSTEM'\\..*It can contain only.*\\\\[a-zA-Z_\\\\] characters\\."
)
