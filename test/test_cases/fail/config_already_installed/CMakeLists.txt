## Main
#
# Test CMCONF_GET behavior when configuration is already installed
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_GET_CONFIG_ALREADY_INSTALLED_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../TEST.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../cache_var.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../CMCONF.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../test_cmconf_helpers.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../config_templates/config_template.cmake")

TEST_CMCONF_CHECK_AND_INSTALL_CONFIG("${CMCONF_TEST_CONFIG_FILE}" "TEST")

CMCONF_INIT_SYSTEM(TEST)
CMCONF_GET(VARIABLE_A)
TEST_VAR_DEFINED(VARIABLE_A)
TEST_VAR_EQUALS_LITERAL(VARIABLE_A "test_value_a")

UNSET(VARIABLE_A)

EXECUTE_PROCESS(
    COMMAND "${CMAKE_COMMAND}" -DCMCONF_INSTALL_AS_SYMLINK=ON -P "${CMCONF_TEST_CONFIG_FILE}"
    RESULT_VARIABLE install_result
    ERROR_VARIABLE install_error
    OUTPUT_VARIABLE install_output
)
IF(NOT install_result EQUAL 0)
    MESSAGE(FATAL_ERROR "Duplicate installation failed unexpectedly: ${install_error}")
ENDIF()
IF(NOT install_error MATCHES "Configuration for TEST already installed.  Skipping.")
    MESSAGE(FATAL_ERROR "Duplicate installation warning not found in output: ${install_output}")
ENDIF()

CMCONF_GET(VARIABLE_A)
TEST_VAR_DEFINED(VARIABLE_A)
TEST_VAR_EQUALS_LITERAL(VARIABLE_A "test_value_a")

TEST_CMCONF_UNINSTALL_CONFIG("${CMCONF_TEST_CONFIG_FILE}" "TEST")
