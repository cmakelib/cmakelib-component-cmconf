## Main
#
# Test CMCONF_GET error when variable is already defined in calling scope
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_VARIABLE_ALREADY_EXISTS_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../TEST.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../test_cmconf_helpers.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../config_templates/config_template.cmake")

TEST_CMCONF_CHECK_AND_INSTALL_CONFIG("${CMCONF_TEST_CONFIG_FILE}" "TEST")

TEST_RUN_AND_CHECK_OUTPUT("test_config"
    FATAL_ERROR_MESSAGE "CMCONF\\\\[TEST\\\\] - Variable 'VARIABLE_A' is already defined\\..*Cannot override.*existing context variable\\."
)

TEST_CMCONF_UNINSTALL_CONFIG("${CMCONF_TEST_CONFIG_FILE}" "TEST")
