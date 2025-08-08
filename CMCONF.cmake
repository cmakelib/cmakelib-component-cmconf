##
#
# CMCONF aka Global Configuration.
# It utilizes CMake user package registry to define an environment
# specific for each system used to add ability for simultaneous use of
# multiple systems at the same machine, user.
#
# As a SYSTEM the non empty, finite set of CMake-based project is meant.
# These projects share common settings and are considered as part of the functional whole
# without practical use when used separately.
#
# [Functions]
#
# CMCONF_INIT_SYSTEM(<system_name>) - set name of the system and optionally install configuration
# CMCONF_GET(<variable_name>) - get value of the configuration variable
# CMCONF_SET(<variable_name> <value>) - set value of the configuration variable
# variable_name and system_name do not need to be enclosed in quotes.
#
# [Example]
#
# Let Producer, Consumer and MQTTBroker are projects.
# Producer connects to MQTTBroker and sends data.
# Consumer connects to MQTTBroker and receives data.
# Producer and Consumer are useless without MQTTBroker.
# Therefore Producer, Consumer and MQTTBroker form a SYSTEM.
#
# Projects which are not part of the SYSTEM are considered as External Dependencies
# or just Dependencies.
#
# Let SYSTEM be a system from example above.
# There are three CMake projects:
# - Producer
# - Consumer
# - MQTTBroker
#
# Producer and Consumer use OpenSSL and Pahomqtt libraries to connect to MQTTBroker.
# OpenSSL and Pahomqtt are not part of the SYSTEM therefore they are Dependencies.
#
# Dependencies are not part of the operating system and need to be downloaded.
#
# Let OpenSSL_URI and Pahomqtt_URI are valid URIs of the OpenSSL and Pahomqtt libraries
# Without loss of generality let OpenSSL and Pahomqtt are downloaded from remote repository
# and be usable directly by each respective CMake project.
#
# OpenSSL_URI and PahoMQTT_URI can change over time and therefore need to be defined
# in a central place to avoid copy-pasting madness.
#
# Define Global Config
# - Choose a SYSTEM name. Let system name be MQTTCOMM
# - Create CMCONF_MQTTCOMMConfig.cmake file. The prefix is important!
#   - call FIND_PACKAGE(CMLIB COMPONENTS CMCONF)
#   - Use CMCONF_INIT_SYSTEM(MQTTCOMM) to set system name.
#   - Define variables by CMCONF_SET:
#     `CMCONF_SET(OPENSSL_URI "NiceOpenSSLURI")`
#     `CMCONF_SET(PAHOMQTT_URI "PahoMQTTURI")`
#   - call `cmake -DCMCONF_INSTALL_AS_SYMLINK=ON -P ./CMCONF_MQTTCOMMConfig.cmake`
#     This will install configuration to CMake user package registry
#
# Use Global Config
# - In each project call `FIND_PACKAGE(CMLIB COMPONENTS CMCONF)`
# - Call CMCONF_INIT_SYSTEM(MQTTCOMM) to set system name.
# - Get variables by CMCONF_GET:
#   `CMCONF_GET(OPENSSL_URI)`
#   `CMCONF_GET(PAHOMQTT_URI)`
# - Voilà OPENSSL_URI and PAHOMQTT_URI are defined and contain values set in CMCONF_MQTTCOMMConfig.cmake
#
# [Configuration File]
#
# Configuration file is CMake script with name <CMCONF_PACKAGE_NAME_PREFIX><SYSTEM_NAME>Config.cmake.
# The configuration file is sometimes refered to as Config.cmake file.
#
# It must call CMCONF_INIT_SYSTEM(<system_name>) to set system name
# and CMCONF_SET(<VARIABLE_NAME> <VALUE>) to define CMCONF variables of the SYSTEM.
#
# [Configuration Installation]
#
# ```
# cmake -DCMCONF_INSTALL_AS_SYMLINK=ON -P ./CMCONF_<SYSTEM_NAME>Config.cmake
# ```
#
# The installation is performed automatically by CMCONF_INIT_SYSTEM when CMCONF_INSTALL_AS_SYMLINK is ON
# to simplify maintenance.
#
# The installation installs given project as a package to CMake user package registry.
# - It is installed by EXPORT(PACKAGE <SYSTEM_NAME>). The directory containing Config.cmake
#   is registered in CMake user package registry
#
# [Configuation Uninstall]
#
# Uninstallation is not supported by CMCONF at the time.
#
# It needs to be done manually by removing the package from CMake user package registry.
#
# [Definitions]
#
# - variable_name or system_name can contain only [a-zA-Z_] chars.
# - variable_name or system_name are case insensitive. Example: the "OpenSSL_URI" is equivalent to "openSSl_uri"
# - SYSTEM NAME is uppercase version of system_name.
# - CMCONF_SET cannot be called in project where CMCONF_GET is called and vice versa if it
#   is not called from Config.cmake file.
# 
# Variables are stored as CMake cache variables.
# Variable name is constructed as `uppercase system_name` + "_" + `uppercase variable_name`.
# If the cache variable is already defined, subsequent CMCONF_SET calls are ignored (first value wins).
# The system_name can be used to establish CMake Variables grouping in GUI like configuration tools. 
#
# 
#

INCLUDE_GUARD(GLOBAL)

FIND_PACKAGE(CMLIB REQUIRED)

SET(CMCONF_SYSTEM_NAME ""
    CACHE STRING
    "Name of the system for which the configuration is intended."
)

SET(CMCONF_INSTALL_AS_SYMLINK OFF
    CACHE BOOL
    "If set the configuration is installed as symlink to CMake user package registry. If OFF install is skipped."
)

SET(CMCONF_UNINSTALL OFF
    CACHE BOOL
    "If set to ON the configuration is uninstalled from CMake user package registry. If OFF uninstall is not performed."
)

SET(CMCONF_CMAKE_PROJECT_ALLOW_INSTALL OFF
    CACHE INTERNAL
    "Set by resource/CMakeLists.txt.in. Do not set manually. COntrols whetnever CMake project is allowed to install the configuration."
)

SET(CMCONF_PACKAGE_NAME_PREFIX "CMCONF_"
    CACHE INTERNAL
    "Prefix for CMake user package name."
)

SET(CMCONF_INSTALL_PROCEEDED OFF
    CACHE INTERNAL
    "It is set to ON when installation of configuration is already proceeded and succeeded."
)

SET(CMCONF_GET_CALLED OFF
    CACHE INTERNAL
    "It is set to ON when CMCONF_GET is called at least once. OFF otherwise."
)

SET(CMCONF_SET_CALLED OFF
    CACHE INTERNAL
    "It is set to ON when CMCONF_SET is called at least once. OFF otherwise."
)

SET(CMCONF_SCRIPT_DIR "${CMAKE_CURRENT_LIST_DIR}"
    CACHE INTERNAL
    "Directory where CMCONF.cmake is located."
)

SET(CMCONF_INSTALL_CMAKELISTS_TEMPLATE_FILE "${CMCONF_SCRIPT_DIR}/resource/CMakeLists.txt.in"
    CACHE INTERNAL
    "Template file for CMakeLists.txt used to install configuration."
)



##
# Set the name of the system for global configuration management and optionally install configuration
#
# Sets the system name that will be used to group configuration variables
# and identify the configuration package in the CMake user package registry.
# The system name can only be set once per configuration session.
#
# If CMCONF_INSTALL_AS_SYMLINK is ON, this function will automatically install
# the configuration to the CMake user package registry as a symlink, making it
# available for other projects to find via FIND_PACKAGE.
#
# The system name is normalized to uppercase and validated to contain only
# [a-zA-Z_] characters. Once set, attempting to change it will result in
# a fatal error.
#
# Installation Process (when CMCONF_INSTALL_AS_SYMLINK=ON):
# - Validates that no conflicting package exists in a different location
# - In script mode: validates filename matches CMCONF_<SYSTEM_NAME>Config.cmake pattern
# - Registers the package using EXPORT(PACKAGE) command
# - Installation is performed only once per session
#
# System name cannot be changed once is set.
#
# <function>(
#		<system_name>		# Name of the system. Will be converted to uppercase,
#							# must contain only [a-zA-Z_] characters.
# )
#
FUNCTION(CMCONF_INIT_SYSTEM system_name)
    _CMCONF_CHECK_AND_NORMALIZE_SYSTEM_NAME("${system_name}" system_name_upper)
    IF(CMCONF_SYSTEM_NAME)
        IF(NOT CMCONF_SYSTEM_NAME STREQUAL "${system_name_upper}")
            _CMCONF_MESSAGE(FATAL_ERROR "System name already set. Cannot change system name from '${CMCONF_SYSTEM_NAME}' to '${system_name_upper}'")
        ENDIF()
    ENDIF()
    SET_PROPERTY(CACHE CMCONF_SYSTEM_NAME PROPERTY VALUE "${system_name_upper}")

    IF(NOT DEFINED CMAKE_FIND_PACKAGE_NAME)
        IF(CMCONF_UNINSTALL AND CMCONF_INSTALL_AS_SYMLINK)
            _CMCONF_MESSAGE(FATAL_ERROR "Uninstall nad Install cannot be preformed at one time. Set either CMCONF_UNINSTALL or CMCONF_INSTALL_AS_SYMLINK to OFF.")
        ENDIF()

        IF(CMCONF_UNINSTALL)
            _CMCONF_UNINSTALL(${CMCONF_SYSTEM_NAME})
        ENDIF()
        IF(CMCONF_INSTALL_AS_SYMLINK)
            IF(CMCONF_INSTALL_PROCEEDED)
                RETURN()
            ENDIF()
            _CMCONF_DEFERED_CALL_FOR_INSTALL(${CMCONF_SYSTEM_NAME})
            SET_PROPERTY(CACHE CMCONF_INSTALL_PROCEEDED PROPERTY VALUE ON)
        ENDIF()
    ENDIF()
ENDFUNCTION()



##
# Retrieve a configuration variable value from the system configuration
#
# Retrieves the value of a configuration variable that was previously set
# using CMCONF_SET in the system configuration. The variable is set in the
# calling scope with the exact name provided.
#
# This function finds the configuration package for the current system and
# retrieves the requested variable. The actual variable name in the cache
# is constructed as SYSTEM_NAME_VARIABLE_NAME (both uppercase).
#
# It finds the configuration package by calling FIND_PACKAGE with
# package name constructed as CMCONF_PACKAGE_NAME_PREFIX + SYSTEM_NAME.
# FIND_PACKAGE is called every time CMCONF_GET is called.
#
# The variable can be specified by environment variable or by -D cmdline option as CMake cache variable.
# The variable name is constructed as SYSTEM_NAME_VARIABLE_NAME (both uppercase).
#
# Restrictions:
# - System name must be set before calling this function
# - Cannot be called after CMCONF_SET has been used in the same session.
#   Exception: CMCONF_GET can be called from <CMCONF_PACKAGE_NAME_PREFIX><SYSTEM_NAME>Config.cmake file
#   Which is found by CMake when FIND_PACKAGE is called.
# - Variable must not already be defined in the calling scope
# - Configuration package must be installed and findable
#
# <function>(
#		<var_name>			# Name of the variable to retrieve. Case insensitive.
#							# Must contain only [a-zA-Z_] characters.
# )
#
FUNCTION(CMCONF_GET var_name)
    _CMCONF_CHECK_SYSTEM_IS_SET()

    IF(DEFINED ${var_name})
        _CMCONF_MESSAGE(FATAL_ERROR "Variable '${var_name}' is already defined. Cannot override existing context variable." )
    ENDIF()

    IF(NOT DEFINED CMAKE_FIND_PACKAGE_NAME AND NOT CMCONF_INSTALL_AS_SYMLINK)
        IF(CMCONF_SET_CALLED)
            _CMCONF_MESSAGE(FATAL_ERROR "CMCONF_GET cannot be called once CMCONF_SET is called.")
        ENDIF()
        SET_PROPERTY(CACHE CMCONF_GET_CALLED PROPERTY VALUE ON)
    ENDIF()

    _CMCONF_CHECK_AND_GET_ACTUAL_VAR_NAME("${CMCONF_SYSTEM_NAME}" "${var_name}" actual_var_name)
    IF(NOT DEFINED ${actual_var_name})
        SET(pack_name "${CMCONF_PACKAGE_NAME_PREFIX}${CMCONF_SYSTEM_NAME}")
        FIND_PACKAGE(${pack_name} QUIET)
        IF(NOT ${pack_name}_FOUND)
            _CMCONF_MESSAGE(FATAL_ERROR "Cannot find configuration for system '${CMCONF_SYSTEM_NAME}'. Is the configuration installed?")
        ENDIF()
        IF(NOT DEFINED ${actual_var_name})
            _CMCONF_MESSAGE(FATAL_ERROR "Variable '${var_name}' is not defined in configuration for system '${CMCONF_SYSTEM_NAME}'.")
        ENDIF()
    ENDIF()
    IF(DEFINED ENV{${actual_var_name}})
        SET(${var_name} "$ENV{${actual_var_name}}" PARENT_SCOPE)
    ELSE()
        SET(${var_name} "${${actual_var_name}}" PARENT_SCOPE)
    ENDIF()
ENDFUNCTION()



##
# Set a configuration variable value in the system configuration
#
# Sets a configuration variable that can later be retrieved using CMCONF_GET.
# The variable is stored as a CMake cache variable with the name constructed
# as <SYSTEM_NAME>_<VARIABLE_NAME> (both uppercase).
#
# Restrictions:
# - System name must be set before calling this function
# - Cannot be called after CMCONF_GET has been used in the same session
#   Exception: CMCONF_SET and CMCONF_GET can be called simultaneously from
#   <CMCONF_PACKAGE_NAME_PREFIX><_SYSTEM_NAME>Config.cmake file which is
#   found by CMake when FIND_PACKAGE is called. 
# - Variable must not already be defined
#
# <function>(
#		<var_name>			# Name of the variable to set. Case insensitive,
#							# must contain only [a-zA-Z_] characters.
#		<value>				# Value to assign to the variable
# )
#
FUNCTION(CMCONF_SET var_name value)
    _CMCONF_CHECK_SYSTEM_IS_SET()
 
    _CMCONF_CHECK_AND_GET_ACTUAL_VAR_NAME("${CMCONF_SYSTEM_NAME}" "${var_name}" actual_var_name) 
    IF(NOT DEFINED CMAKE_FIND_PACKAGE_NAME AND NOT CMCONF_INSTALL_AS_SYMLINK)
        IF(CMCONF_GET_CALLED)
            _CMCONF_MESSAGE(FATAL_ERROR "Cannot call CMCONF_SET after CMCONF_GET")
        ENDIF()
        SET_PROPERTY(CACHE CMCONF_SET_CALLED PROPERTY VALUE ON)
    ENDIF()

    # This check is problematic. It is not simple task to implement wanted behaviour.
    # What if the variable is defined from cmd line? etc.
    #IF(NOT ${actual_var_name} STREQUAL "${value}")
    #    _CMCONF_MESSAGE(WARNING "Setting variable ${actual_var_name} value from ${${actual_var_name}} to ${value} will no take any effect because CMCONF variables are stored as CMake CACHE varibles.")
    #ENDIF()

    SET(${actual_var_name} "${value}"
        CACHE STRING
        "CMCONF setting variable"
    )
ENDFUNCTION()



## HELPER
#
# Install current active configuration to CMake user package registry
#
# This macro is called automatically by CMCONF_SET when CMCONF_INSTALL_AS_SYMLINK
# is ON. It installs the configuration package to the CMake user package registry
# so that other projects can find it using FIND_PACKAGE.
#
# Requirements for Installation to Proceed:
# - CMCONF_INSTALL_AS_SYMLINK must be ON
# - CMCONF_SYSTEM_NAME must be set
# - No conflicting package with same name in different location
# - In script mode: filename must match CMCONF_<SYSTEM_NAME>Config.cmake pattern
#
# The installation is run in two phases
# - Validate prerequisites and generate CMakeLists.txt from template resource/CMakeLists.txt.in.
#   The CMakeLists.txt is generated in CMAKE_CURRENT_BINARY_DIR eg. where the Config.cmake is located.
# - Run CMake in CMAKE_CURRENT_BINARY_DIR to install the package because
#   the package is installed by EXPORT(PACKAGE) command which is available only in project mode.
#   After installation the generated CMakeLists.txt is removed together with all other generated files.
#
# <function>(
#       <system_name> # SYSTEM NAME, uppercase
# )
#
FUNCTION(_CMCONF_DEFERED_CALL_FOR_INSTALL system_name)
    IF(NOT CMCONF_INSTALL_AS_SYMLINK)
        RETURN()
    ENDIF()
    
    _CMCONF_GET_PACKAGE_NAME(${system_name} package_name)
    _CMCONF_GET_PACKAGE_CONFIG_FILENAME(${system_name} package_filename)

    FIND_PACKAGE(${package_name} QUIET)
    IF(${package_name}_DIR)
        SET(installed_package_path ${${package_name}_DIR})
        GET_FILENAME_COMPONENT(filepath_script  "${installed_package_path}" REALPATH)
        GET_FILENAME_COMPONENT(filepath_current "${CMAKE_CURRENT_LIST_DIR}" REALPATH)
        FILE(TO_CMAKE_PATH "${filepath_script}"  filepath_script)
        FILE(TO_CMAKE_PATH "${filepath_current}" filepath_current)
        IF(filepath_script STREQUAL "${filepath_current}")
            _CMCONF_MESSAGE(WARNING "Configuration for ${system_name} already installed. Skipping.")
            RETURN()
        ENDIF()
        _CMCONF_MESSAGE(FATAL_ERROR "Cannot install configuration. Package '${package_name}' already exists in '${${package_name}_DIR}'.")
    ENDIF()

    _CMCONF_MESSAGE(STATUS "Installing configuration for ${system_name} as symlink")

    IF(DEFINED CMAKE_SCRIPT_MODE_FILE)
        GET_FILENAME_COMPONENT(filename "${CMAKE_SCRIPT_MODE_FILE}" NAME)
        IF(NOT filename STREQUAL "${package_filename}")
            _CMCONF_MESSAGE(FATAL_ERROR "Cannot install configuration. The file name must be '${package_filename}'. Not '${filename}'.")
        ENDIF()
        _CMCONF_RUN_INSTALL_PROJECT("${system_name}")
    ELSE()
        IF(NOT CMCONF_CMAKE_PROJECT_ALLOW_INSTALL)
            _CMCONF_MESSAGE(FATAL_ERROR "Cannot install configuration. Installation can be invoked only as 'cmake -DCMCONF_INSTALL_AS_SYMLINK=ON -P <CONFIG_FILE>.'")
        ENDIF()
        SET(CMAKE_EXPORT_PACKAGE_REGISTRY ON)
        EXPORT(PACKAGE "${package_name}")
    ENDIF()
    _CMCONF_MESSAGE(STATUS "Installing configuration for ${system_name} as symlink: DONE")
ENDFUNCTION()



## HELPER
#
# It tries to uninstall configuration package from CMake user package registry.
#
# The function assumes the system behaves as stated in CMake documetnation.
# In some specific caseses/systems is possible the uninstallation will fail.
#
# <function>(
#		<system_name> # SYSTEM NAME, uppercase
# )
#
FUNCTION(_CMCONF_UNINSTALL system_name)
    _CMCONF_GET_PACKAGE_NAME("${system_name}" package_name)

    IF(NOT CMAKE_SCRIPT_MODE_FILE)
        _CMCONF_MESSAGE(FATAL_ERROR "Cannot uninstall configuration. Uninstalation can be invoked only as 'cmake -DCMCONF_UNINSTALL=ON -P <CONFIG_FILE>.'")
    ENDIF()

    SET(package_registry_path)
    IF(WIN32)
        SET(winreg_path "HKCU\\Software\\Kitware\\CMake\\Packages\\${package_name}")
        FIND_PROGRAM(reg_exe reg)
        IF(NOT reg_exe)
            _CMCONF_MESSAGE(FATAL_ERROR "Cannot uninstall configuration. 'reg' executable not found.")
        ENDIF()
        EXECUTE_PROCESS(
            COMMAND "${reg_exe}" query "${winreg_path}"
            RESULT_VARIABLE winreg_exist
            ERROR_VARIABLE errout
            OUTPUT_VARIABLE stdout
        )
        IF(NOT winreg_exist EQUAL 0)
            _CMCONF_MESSAGE(WARNING "No need to uninstall configuration for ${system_name}. It is not installed.")  
            RETURN()
        ENDIF()
        EXECUTE_PROCESS(
            COMMAND "${reg_exe}" delete "${winreg_path}" /f
            RESULT_VARIABLE result_var
            ERROR_VARIABLE errout
            OUTPUT_VARIABLE stdout
        )
        IF(NOT result_var EQUAL 0)
            _CMCONF_MESSAGE(FATAL_ERROR "Failed to uninstall configuration for system ${system_name}: ${errout}\n${stdout}")
        ENDIF()
    ELSEIF(UNIX)
        SET(userhome "$ENV{HOME}")
        IF(NOT userhome)
            _CMCONF_MESSAGE(FATAL_ERROR "Cannot uninstall configuration. HOME environment variable is not set.")
        ENDIF()
        FILE(TO_CMAKE_PATH "${userhome}" userhome)
        SET(package_registry_path "${userhome}/.cmake/packages/${package_name}")

        FIND_PACKAGE(${package_name} QUIET)
        IF(NOT ${package_name}_FOUND)
            _CMCONF_MESSAGE(WARNING "No need to uninstall configuration for ${system_name}. It is not installed.")
            RETURN()
        ENDIF()
        FILE(REMOVE_RECURSE "${package_registry_path}")
    ELSE()
        _CMCONF_MESSAGE(FATAL_ERROR "Cannot uninstall configuration. Unsupported platform.")
    ENDIF()

    _CMCONF_MESSAGE(STATUS "Uninstalled configuration for system ${system_name} succeeded.")
ENDFUNCTION()



## HELPER
#
# It actually install the configuration package.
#
# Because EXPORT(PACKAGE ...) cannot be called from script mode,
# we need to run CMake in project mode to install the package.
# This function generates CMakeLists.txt in CMAKE_CURRENT_BINARY_DIR
# and runs CMake in that directory to install the package.
# After installation the generated CMakeLists.txt is removed together
# with all other generated files.
#
# <function>(
#       <system_name>       # SYSTEM NAME, uppercase
# )
#
FUNCTION(_CMCONF_RUN_INSTALL_PROJECT system_name)
    GET_FILENAME_COMPONENT(script_dir "${CMAKE_SCRIPT_MODE_FILE}" DIRECTORY)
    SET(cmakelist_template "${CMCONF_INSTALL_CMAKELISTS_TEMPLATE_FILE}")
    SET(cmakelist_path     "${script_dir}/CMakeLists.txt")

    FILE(GLOB already_present_files "${script_dir}/*")
    SET(TO_REPLACE_CMCONF_SYSTEM_NAME "${system_name}")
    CONFIGURE_FILE("${cmakelist_template}" "${cmakelist_path}" @ONLY)

    EXECUTE_PROCESS(
        COMMAND "${CMAKE_COMMAND}" -DCMCONF_INSTALL_AS_SYMLINK=ON .
        WORKING_DIRECTORY "${script_dir}"
        RESULT_VARIABLE result_var
        ERROR_VARIABLE errout
        OUTPUT_VARIABLE stdout
    )
    IF(NOT result_var EQUAL 0)
        MESSAGE(FATAL_ERROR "Failed to run install project: ${errout}\n${stdout}")
    ENDIF()

    FILE(GLOB all_files_after_install "${script_dir}/*")
    FOREACH(file IN LISTS all_files_after_install)
        IF(NOT file IN_LIST already_present_files)
            FILE(REMOVE_RECURSE "${file}")
        ENDIF()
    ENDFOREACH()
ENDFUNCTION()



## HELPER
#
# Sets/generates package name to output variable
#
# <function>(
#       <system_name>       # SYSTEM NAME, uppercase
# 		<output_var>		# Variable name to store the package name
# )
#
FUNCTION(_CMCONF_GET_PACKAGE_NAME system_name output_var)
    SET(${output_var} "${CMCONF_PACKAGE_NAME_PREFIX}${system_name}" PARENT_SCOPE)
ENDFUNCTION()



## HELPER
#
# Sets/generates package config file name to output variable
#
# <function>(
# 		<output_var>		# Variable name to store the package config file name
# )
#
FUNCTION(_CMCONF_GET_PACKAGE_CONFIG_FILENAME system_name output_var)
    _CMCONF_GET_PACKAGE_NAME(${system_name} package_name)
    SET(${output_var} "${package_name}Config.cmake" PARENT_SCOPE)
ENDFUNCTION()



## HELPER
#
# Validate and normalize system name to uppercase
#
# Validates that the system name contains only [a-zA-Z_] characters
# and converts it to uppercase. Outputs the normalized name to the
# specified output variable.
#
# <function>(
#		<system_name>		# System name to validate and normalize
#		<output_var>		# Variable name to store the normalized system name
# )
#
FUNCTION(_CMCONF_CHECK_AND_NORMALIZE_SYSTEM_NAME system_name output_var)
    IF(NOT system_name MATCHES "^[a-zA-Z_]+$")
        _CMCONF_MESSAGE(FATAL_ERROR "Invalid system name '${system_name}'. It can contain only [a-zA-Z_] characters.")
    ENDIF()
    STRING(TOUPPER "${system_name}" system_name_upper)
    SET(${output_var} "${system_name_upper}" PARENT_SCOPE)
ENDFUNCTION()



## HELPER
#
# Construct the actual cache variable name from system and variable names
#
# Creates the actual cache variable name by combining the system name
# and variable name in uppercase, separated by an underscore.
# The format is: SYSTEM_NAME_VARIABLE_NAME
#
# Validates that the variable name contains only [a-zA-Z_] characters.
#
# <function>(
#		<system_name>		# System name to use in construction
#		<var_name>			# Variable name to validate and use in construction
#		<output_var>		# Variable name to store the constructed cache variable name
# )
#
FUNCTION(_CMCONF_CHECK_AND_GET_ACTUAL_VAR_NAME system_name var_name output_var)
    IF(NOT var_name MATCHES "^[a-zA-Z_]+$")
        _CMCONF_MESSAGE(FATAL_ERROR "Invalid variable name '${var_name}'. It can contain only [a-zA-Z_] characters.")
    ENDIF()
    STRING(TOUPPER "${system_name}" system_name_upper)
    STRING(TOUPPER "${var_name}" var_name_upper)
    SET(_var "${system_name_upper}_${var_name_upper}")
    SET(${output_var} "${_var}" PARENT_SCOPE)
ENDFUNCTION()



## HELPER
#
# Verify that the system name has been set
#
# Checks if CMCONF_SYSTEM_NAME is defined and not empty. If not set,
# generates a fatal error instructing to call CMCONF_SET_SYSTEM_NAME first.
#
# <macro>()
#
MACRO(_CMCONF_CHECK_SYSTEM_IS_SET)
    IF(NOT CMCONF_SYSTEM_NAME)
        _CMCONF_MESSAGE(FATAL_ERROR "System name is not set. Call CMCONF_INIT_SYSTEM before using CMCONF_GET or CMCONF_SET")
    ENDIF()
ENDMACRO() 



## HELPER
#
# Output formatted message with CMCONF prefix and system name
#
# Outputs a message with consistent CMCONF formatting. If a system name
# is set, includes it in the message prefix as "CMCONF[SYSTEM_NAME]".
# Otherwise uses just "CMCONF" as the prefix.
#
# <macro>(
#		<level>				# Message level (STATUS, WARNING, FATAL_ERROR, etc.)
#		<msg>				# Message content to display
# )
#
MACRO(_CMCONF_MESSAGE level msg)
    IF(CMCONF_SYSTEM_NAME)
        MESSAGE(${level} "CMCONF[${CMCONF_SYSTEM_NAME}] - ${msg}")
    ELSE()
        MESSAGE(${level} "CMCONF - ${msg}")
    ENDIF()
ENDMACRO()