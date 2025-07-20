## Main
#
# Test _CMCONF_RUN_INSTALL_PROJECT error when install project execution fails
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_INSTALL_PROJECT_EXECUTION_FAILURE_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../TEST.cmake")

SET(config_dir "${CMAKE_CURRENT_LIST_DIR}/test_config")
FILE(GLOB already_present_files "${config_dir}/*")

EXECUTE_PROCESS(
    COMMAND "${CMAKE_COMMAND}" -DCMCONF_INSTALL_AS_SYMLINK=ON -P "${config_dir}/CMCONF_TESTConfig.cmake"
    RESULT_VARIABLE install_result
    ERROR_VARIABLE install_error
    OUTPUT_VARIABLE install_output
)

FILE(GLOB all_files_after_install "${config_dir}/*")
FOREACH(file IN LISTS all_files_after_install)
    IF(NOT file IN_LIST already_present_files)
        FILE(REMOVE_RECURSE "${file}")
    ENDIF()
ENDFOREACH()

IF(install_result EQUAL 0)
    MESSAGE(FATAL_ERROR "Expected installation to fail due to malformed template, but it succeeded")
ENDIF()

IF(NOT install_error MATCHES "Failed to run install project:.*")
    MESSAGE(FATAL_ERROR "Expected 'Failed to run install project' error message not found in output: ${install_error}")
ENDIF()
