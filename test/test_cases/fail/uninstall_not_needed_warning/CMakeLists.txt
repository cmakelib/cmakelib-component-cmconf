## Main
#
# Test CMCONF_INIT_SYSTEM warning when trying to uninstall non-existent configuration
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_UNINSTALL_NOT_NEEDED_WARNING_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../TEST.cmake")

# Run the test config in script mode to trigger uninstall warning
EXECUTE_PROCESS(
    COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_LIST_DIR}/test_config/CMakeLists.txt"
    WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
    RESULT_VARIABLE uninstall_result
    ERROR_VARIABLE uninstall_error
    OUTPUT_VARIABLE uninstall_output
)

# The uninstall should succeed (return 0) but generate a warning
IF(NOT uninstall_result EQUAL 0)
    MESSAGE(FATAL_ERROR "Expected uninstall to succeed with warning, but it failed: ${uninstall_error}")
ENDIF()

# Check for the expected warning message
IF(NOT uninstall_error MATCHES "CMCONF\\[NONEXISTENT\\] - No need to uninstall configuration for NONEXISTENT\\..*It is not installed\\.")
    MESSAGE(FATAL_ERROR "Expected warning message not found in output: ${uninstall_error}")
ENDIF()
