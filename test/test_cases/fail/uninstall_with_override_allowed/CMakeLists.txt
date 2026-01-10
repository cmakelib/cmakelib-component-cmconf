## Main
#
# Test CMCONF uninstallation error when CMCONF_SYSTEM_NAME_OVERRIDE_ALLOWED is ON
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_UNINSTALL_WITH_OVERRIDE_ALLOWED_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../TEST.cmake")

EXECUTE_PROCESS(
    COMMAND "${CMAKE_COMMAND}" -DCMCONF_UNINSTALL=ON -DCMCONF_SYSTEM_NAME_OVERRIDE_ALLOWED=ON -P "${CMAKE_CURRENT_LIST_DIR}/../../../config_templates/CMCONF_TEST_SYSTEMConfig.cmake"
    RESULT_VARIABLE uninstall_result
    ERROR_VARIABLE uninstall_error
    OUTPUT_VARIABLE uninstall_output
)

IF(uninstall_result EQUAL 0)
    MESSAGE(FATAL_ERROR "Expected uninstallation to fail when CMCONF_SYSTEM_NAME_OVERRIDE_ALLOWED=ON but it succeeded")
ENDIF()

IF(NOT uninstall_error MATCHES "CMCONF_SYSTEM_NAME_OVERRIDE_ALLOWED is not allowed during CMCONF config.*uninstallation")
    MESSAGE(FATAL_ERROR "Expected error message not found in output: ${uninstall_error}")
ENDIF()

