## CMCONF Test Helper Functions
#
# Provides reusable functions for CMCONF test cases to handle
# configuration installation and uninstallation with proper validation
#

##
# Check prerequisites and install CMCONF configuration
#
# Verifies that the configuration package is not already installed,
# then installs it to the CMake user package registry.
#
# <function>(
#     <config_file_path>    # Absolute path to Config.cmake file to install
#     <system_name>         # Name of the system (e.g., TEST, TEST_SYSTEM)
# )
#
FUNCTION(TEST_CMCONF_CHECK_AND_INSTALL_CONFIG config_file_path system_name)
    GET_FILENAME_COMPONENT(config_filename "${config_file_path}" NAME)
    SET(package_name "CMCONF_${system_name}")
    
    IF(NOT EXISTS "${config_file_path}")
        MESSAGE(FATAL_ERROR "Configuration file does not exist: ${config_file_path}")
    ENDIF()
    
    FIND_PACKAGE(${package_name} QUIET)
    IF(${package_name}_FOUND)
        MESSAGE(FATAL_ERROR "Prerequisite failed: ${package_name} package is already installed. Clean user package registry first by delete ~/.cmake/packages/${package_name} or by running 'cmake -DCMCONF_UNINSTALL=ON -P ${config_file_path}'")
    ENDIF()
    
    EXECUTE_PROCESS(
        COMMAND "${CMAKE_COMMAND}" -DCMCONF_INSTALL_AS_SYMLINK=ON -P "${config_file_path}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
        RESULT_VARIABLE install_result
        ERROR_VARIABLE install_error
        OUTPUT_VARIABLE install_output
    )
    
    IF(NOT install_result EQUAL 0)
        MESSAGE(FATAL_ERROR "Failed to install configuration ${config_filename}: ${install_error}")
    ENDIF()
ENDFUNCTION()

##
# Uninstall CMCONF configuration from CMake user package registry
#
# Removes the configuration package from the user package registry.
# Issues fatal error if uninstallation fails.
#
# <function>(
#     <config_file_path>    # Absolute path to Config.cmake file to uninstall
#     <system_name>         # Name of the system (e.g., TEST, TEST_SYSTEM)
# )
#
FUNCTION(TEST_CMCONF_UNINSTALL_CONFIG config_file_path system_name)
    IF(NOT EXISTS "${config_file_path}")
        MESSAGE(FATAL_ERROR "Configuration file does not exist for uninstall: ${config_file_path}")
        RETURN()
    ENDIF()
    
    GET_FILENAME_COMPONENT(config_filename "${config_file_path}" NAME)
    SET(package_name "CMCONF_${system_name}")
    
    EXECUTE_PROCESS(
        COMMAND "${CMAKE_COMMAND}" -DCMCONF_UNINSTALL=ON -P "${config_file_path}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
        RESULT_VARIABLE uninstall_result
        ERROR_VARIABLE uninstall_error
        OUTPUT_VARIABLE uninstall_output
    )
    
    IF(NOT uninstall_result EQUAL 0)
        MESSAGE(FATAL_ERROR "Failed to uninstall configuration ${config_filename}: ${uninstall_error}")
    ENDIF()
ENDFUNCTION()
