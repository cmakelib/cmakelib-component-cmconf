## Main
#
# Test that CMCONF uninstallation actually removes the package from registry
#
# Strategy: Single file for sequential state-dependent test
# Steps must execute in exact order with shared state.
# Splitting would require complex state passing and risk inconsistent cleanup on failures.
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_UNINSTALL_VERIFICATION_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../TEST.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../cache_var.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../CMCONF.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../test_cmconf_helpers.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../config_templates/config_template.cmake")

TEST_CMCONF_CHECK_AND_INSTALL_CONFIG("${CMCONF_TEST_CONFIG_FILE}" "TEST")

SET(package_name "CMCONF_TEST")
FIND_PACKAGE(${package_name} QUIET)
IF(NOT ${package_name}_FOUND)
    MESSAGE(FATAL_ERROR "Package ${package_name} should be found after installation, but it was not found")
ENDIF()

CMCONF_INIT_SYSTEM(TEST)
CMCONF_GET(VARIABLE_A)
TEST_VAR_DEFINED(VARIABLE_A)
TEST_VAR_EQUALS_LITERAL(VARIABLE_A "test_value_a")

TEST_CMCONF_UNINSTALL_CONFIG("${CMCONF_TEST_CONFIG_FILE}" "TEST")

UNSET(${package_name}_FOUND CACHE)
UNSET(${package_name}_DIR CACHE)
UNSET(${package_name}_CONFIG CACHE)

FIND_PACKAGE(${package_name} QUIET)
IF(${package_name}_FOUND)
    MESSAGE(FATAL_ERROR "Package ${package_name} should NOT be found after uninstallation, but it was still found at: ${${package_name}_DIR}")
ENDIF()
