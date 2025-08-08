## Main
#
# Test that ENV variables override config values
#
# This test validates that when both a configuration variable and an environment
# variable are defined, the environment variable takes precedence.
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_ENV_VARIABLE_OVERRIDE_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../TEST.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../cache_var.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../CMCONF.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../test_cmconf_helpers.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../config_templates/config_template.cmake")


TEST_CMCONF_CHECK_AND_INSTALL_CONFIG("${CMCONF_TEST_CONFIG_FILE}" "TEST")

CMCONF_INIT_SYSTEM(TEST)

SET(ENV{TEST_VARIABLE_A} "env_override_value")
CMCONF_GET(VARIABLE_A)

TEST_VAR_DEFINED(VARIABLE_A)
TEST_VAR_EQUALS_LITERAL(VARIABLE_A "env_override_value")

UNSET(ENV{TEST_VARIABLE_A})
TEST_CMCONF_UNINSTALL_CONFIG("${CMCONF_TEST_CONFIG_FILE}" "TEST")
