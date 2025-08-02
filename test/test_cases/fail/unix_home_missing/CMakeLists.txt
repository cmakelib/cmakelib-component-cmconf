## Main
#
# Test CMCONF_INIT_SYSTEM error when HOME is not set on Unix
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_UNIX_HOME_MISSING_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../TEST.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../test_cmconf_helpers.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../config_templates/config_template.cmake")

TEST_CMCONF_CHECK_AND_INSTALL_CONFIG("${CMCONF_TEST_CONFIG_FILE}" "TEST")

EXECUTE_PROCESS(
    COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_LIST_DIR}/test_config/CMakeLists.txt"
    RESULT_VARIABLE result
    ERROR_VARIABLE error_output
    OUTPUT_VARIABLE output
)
IF(result EQUAL 0)
    MESSAGE(FATAL_ERROR "Expected test to fail but it succeeded")
ENDIF()
IF(NOT error_output MATCHES "CMCONF\\[TEST\\] - Cannot uninstall configuration\\..*HOME environment variable.*is not set\\.")
    MESSAGE(FATAL_ERROR "Expected error message not found in output: ${error_output}")
ENDIF()

TEST_CMCONF_UNINSTALL_CONFIG("${CMCONF_TEST_CONFIG_FILE}" "TEST")
