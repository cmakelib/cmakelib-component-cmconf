## Main
#
# Test that ENV variables cannot override non-defined config variables
#
# This test validates that even when an environment variable is set,
# CMCONF_GET still requires the variable to be defined in the configuration.
# ENV variables cannot be used to define new variables that don't exist in config.
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_ENV_VARIABLE_CONFIG_REQUIRED_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../TEST.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../cache_var.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../CMCONF.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../test_cmconf_helpers.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../config_templates/config_template.cmake")

TEST_CMCONF_CHECK_AND_INSTALL_CONFIG("${CMCONF_TEST_CONFIG_FILE}" "TEST")

TEST_RUN_AND_CHECK_OUTPUT("test_config"
    FATAL_ERROR_MESSAGE "CMCONF\\\\[TEST\\\\] - Variable 'UNDEFINED_VARIABLE' is not defined in.*configuration for system 'TEST'"
)

TEST_CMCONF_UNINSTALL_CONFIG("${CMCONF_TEST_CONFIG_FILE}" "TEST")
