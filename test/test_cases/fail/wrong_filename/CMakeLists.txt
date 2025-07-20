## Main
#
# Test CMCONF_INIT_SYSTEM error when config filename doesn't match system name
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_WRONG_FILENAME_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../TEST.cmake")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../config_templates/config_template.cmake")

EXECUTE_PROCESS(
    COMMAND "${CMAKE_COMMAND}" -DCMCONF_INSTALL_AS_SYMLINK=ON -P "${CMCONF_TEST_WRONG_CONFIG_FILE}"
    RESULT_VARIABLE install_result
    ERROR_VARIABLE install_error
    OUTPUT_VARIABLE install_output
)
IF(install_result EQUAL 0)
    MESSAGE(FATAL_ERROR "Expected installation to fail due to filename mismatch, but it succeeded")
ENDIF()
IF(NOT install_error MATCHES "CMCONF\\[TEST\\] - Cannot install configuration.*file name must be.*CMCONF_TESTConfig.cmake.*Not.*CMCONF_TEST_WRONGConfig.cmake")
    MESSAGE(FATAL_ERROR "Expected error message not found in output: ${install_error}")
ENDIF()
