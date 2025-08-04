## Main
#
# Run all CMCONF tests
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22 FATAL_ERROR)
    PROJECT(CMCONF_TEST)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../CMCONF.cmake")

INCLUDE(${CMAKE_CURRENT_LIST_DIR}/TEST.cmake)
INCLUDE(${CMAKE_CURRENT_LIST_DIR}/cache_var.cmake)

TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/pass/basic_get")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/pass/cache_variable_behavior")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/pass/case_insensitive")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/pass/different_system_names")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/pass/multiple_variables")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/pass/uninstall_verification")

TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/config_not_installed")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/config_already_installed")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/get_after_set")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/install_from_cmake_project")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/install_project_execution_failure")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/invalid_system_name")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/invalid_variable_name")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/package_exists_different_location")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/set_after_get")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/system_name_change_attempt")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/system_not_set")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/uninstall_from_cmake_project")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/uninstall_install_conflict")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/uninstall_not_needed_warning")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/variable_already_exists")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/variable_not_defined")
TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/wrong_filename")

IF(UNIX)
    TEST_RUN("${CMAKE_CURRENT_LIST_DIR}/test_cases/fail/unix_home_missing")
ENDIF()

