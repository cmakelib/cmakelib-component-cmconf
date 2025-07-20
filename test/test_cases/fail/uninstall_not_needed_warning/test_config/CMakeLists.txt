## Test configuration that tries to uninstall non-existent configuration
#
# This should generate a warning when trying to uninstall non-existent package
#

IF(NOT DEFINED CMAKE_SCRIPT_MODE_FILE)
    CMAKE_MINIMUM_REQUIRED(VERSION 3.22)
    PROJECT(CMCONF_UNINSTALL_NOT_NEEDED_WARNING_TEST_CONFIG)
ENDIF()

FIND_PACKAGE(CMLIB REQUIRED)

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../../CMCONF.cmake")

FIND_PACKAGE(NONEXISTENT QUIET)
IF(NONEXISTENT_FOUND)
    MESSAGE(FATAL_ERROR "NONEXISTENT package is installed. Prerequisity check failed!")
ENDIF()

SET(CMCONF_UNINSTALL ON CACHE BOOL "" FORCE)
CMCONF_INIT_SYSTEM("NONEXISTENT")
