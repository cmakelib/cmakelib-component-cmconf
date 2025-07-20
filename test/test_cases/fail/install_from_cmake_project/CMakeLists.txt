## Main
#
# Test CMCONF_INIT_SYSTEM error when trying to install from CMake project context
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_INSTALL_FROM_CMAKE_PROJECT_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../TEST.cmake")

# Create temporary build directory
SET(temp_build_dir "${CMAKE_CURRENT_LIST_DIR}/_tmp")
FILE(MAKE_DIRECTORY "${temp_build_dir}")

# Try to configure the project (this should fail)
EXECUTE_PROCESS(
    COMMAND "${CMAKE_COMMAND}" "${CMAKE_CURRENT_LIST_DIR}/test_config"
    WORKING_DIRECTORY "${temp_build_dir}"
    RESULT_VARIABLE configure_result
    ERROR_VARIABLE configure_error
    OUTPUT_VARIABLE configure_output
)

# Clean up temporary build directory
FILE(REMOVE_RECURSE "${temp_build_dir}")

IF(configure_result EQUAL 0)
    MESSAGE(FATAL_ERROR "Expected configuration to fail due to installation from project context, but it succeeded")
ENDIF()

IF(NOT configure_error MATCHES "Cannot install configuration\\.  Installation can be invoked\n  only as 'cmake -DCMCONF_INSTALL_AS_SYMLINK=ON -P <CONFIG_FILE>\\.'")
    MESSAGE(FATAL_ERROR "Expected error message not found in output: ${configure_error}")
ENDIF()
