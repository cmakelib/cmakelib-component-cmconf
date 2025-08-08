## Main
#
# Test that config values are used when ENV variables are not set
#
# This test validates that when no environment variable is defined,
# CMCONF_GET falls back to the configuration value, maintaining
# backward compatibility.
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_ENV_VARIABLE_FALLBACK_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../TEST.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../cache_var.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../CMCONF.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../test_cmconf_helpers.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../config_templates/config_template.cmake")

TEST_CMCONF_CHECK_AND_INSTALL_CONFIG("${CMCONF_TEST_CONFIG_FILE}" "TEST")

CMCONF_INIT_SYSTEM(TEST)

# Ensure no ENV variable is set for TEST_VARIABLE_A
UNSET(ENV{TEST_VARIABLE_A})

CMCONF_GET(VARIABLE_A)

TEST_VAR_DEFINED(VARIABLE_A)
TEST_VAR_EQUALS_LITERAL(VARIABLE_A "test_value_a")

TEST_CMCONF_UNINSTALL_CONFIG("${CMCONF_TEST_CONFIG_FILE}" "TEST")
