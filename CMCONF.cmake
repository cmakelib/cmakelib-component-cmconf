##
#
# CMCONF aka Global Configuration.
# It utilies local CMake package registry to define an environment
# specific for each system used to add ability for simultaneos use of
# multiple systems at the same machine, user.
#
# As a SYSTEM the non empty, finite set of CMake-based project is meant.
# These projects share common settings and are considered as part of the functional whole
# without practical use when used separately.
#
# Example:
# Let be projects Producer and Consumer and MQTTBroker.
# Producer connects to MQTTBroker and sends data.
# Consumer connects to MQTTBroker and receives data.
# Producer and Consumer are useless without MQTTBroker.
# Therefore Producer, Consumer and MQTTBroker form a SYSTEM.
#
# Projects which are not part of the SYSTEM are considered as External Dependencies
# or just Dependencies.
#
# [Functions]
#
# CMCONF_SET_SYSTEM_NAME(<system_name>) - set name of the system
# CMCONF_GET(<variable_name>) - get value of the configuration variable
# CMCONF_SET(<variable_name> <value>) - set value of the configuration variable
# variable_name and system_name are not needed to be strings.
#
# [Usage]
#
# Lets SYSTEM is a system from example above.
# There are three CMake projects:
# - Producer
# - Consumer
# - MQTTBroker
#
# Producer and Consumer uses OpenSSL and Pahomqtt libraries to connect to MQTTBroker.
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
# - Create CMCONF_MQTTCOMConfig.cmake file. The prefix is important!
#   - call FIND_PACKAGE(CMLIB COMPONENTS CMCONF)
#   - Use CMCONF_SET_SYSTEM_NAME(MQTTCOMM) to set system name.
#   - Define variables by CMCONF_SET:
#     `CMCONF_SET(OPENSSL_URI "NiceOpenSSLURI")`
#     `CMCONF_SET(PAHOMQTT_URI "PahoMQTTURI")`
#   - call `cmake -DCMCONF_INSTALL_AS_SYMLINK=ON -P ./MQTTCOMConfig.cmake`
#     This will install configuration to local CMake package registry 
#
# Use Global Config
# - In each project call `FIND_PACKAGE(CMLIB COMPONENTS CMCONF)`
# - Call CMCONF_SET_SYSTEM_NAME(MQTTCOMM) to set system name.
# - Get variables by CMCONF_GET:
#   `CMCONF_GET(OPENSSL_URI)`
#   `CMCONF_GET(PAHOMQTT_URI)`
# - Woalaa OPENSSL_URI and PAHOMQTT_URI are defined and contains values defined in MQTTCOMConfig.cmake
#
# [Restrictions]
#
# - variable_name or system_name can contain only [a-aA-Z_] chars.
# - variable_name or system_name are case insensitive. Example: the "OpenSSL_URI" is equivalent to "openSSl_uri"
# - CMCONF_SET cannot be called in project where CMCONF_GET is called and vice versa.
# - CMCONF_GET check if the variables are already defined in a calling scope
#   under name passed to CMCONF_GET as an first argument.
#   If yes it omits FATAL_ERROR.
# - CMCONF_GET sets variable with name passed to CMCONF_GET as an first argument without any modification.
#   Then CMCONF_GET(OpenSSL_URI), CMCOFF_GET(openssl_uri), CMCONF_GET(openSSl_URI), ... set variables
#   OpenSSL_URI, openssl_uri, openSSl_URI and all of these holds the same value.
# 
# Variables are stored as CMake cache variables.
# Variable name is constructed as `uppercase system_name` + "_" + `uppercase variable_name`.
# If the Variable of that name is already defined the CMCONF_SET omits FATAL_ERROR.
# The system_name can be used to establish CMake Variables grouping in GUI like configuration tools. 
#

INCLUDE_GUARD(GLOBAL)

FIND_PACKAGE(CMLIB REQUIRED)

SET(CMCONF_SYSTEM_NAME ""
    CACHE STRING
    "Name of the system for which the configuration is intended."
)

SET(CMCONF_INSTALL_AS_SYMLINK OFF
    CACHE BOOL
    "If set the configuration is installed as symlink to local CMake package registry. If OFF install is skipped."
)

SET(CMCONF_PACKAGE_NAME_PREFIX "CMCONF_"
    CACHE INTERNAL
    "Prefix for local CMake package name."
)

SET(CMCONF_DEFER_CALL_ID ""
    CACHE INTERNAL
    "ID of the defer call for install."
)

SET(CMCONF_GET_CALLED OFF
    CACHE INTERNAL
    "It is set to ON when CMCONF_GET is called at least once. OFF otherwise."
)

SET(CMCONF_SET_CALLED OFF
    CACHE INTERNAL
    "It is set to ON when CMCONF_SET is called at least once. OFF otherwise."
)



##
#
#
FUNCTION(CMCONF_SET_SYSTEM_NAME system_name)
    _CMCONF_CHECK_AND_NORMALIZE_SYSTEM_NAME("${system_name}" system_name_upper)
    IF(CMCONF_SYSTEM_NAME)
        IF(NOT CMCONF_SYSTEM_NAME STREQUAL "${system_name_upper}")
            _CMCONF_MESSAGE(FATAL_ERROR "System name already set. Cannot change system name from '${CMCONF_SYSTEM_NAME}' to '${system_name_upper}'")
        ENDIF()
    ENDIF()
    SET_PROPERTY(CACHE CMCONF_SYSTEM_NAME PROPERTY VALUE "${system_name_upper}")
ENDFUNCTION()



##
#
#
FUNCTION(CMCONF_GET var_name)
    _CMCONF_CHECK_SYSTEM_IS_SET()
    IF(CMCONF_SET_CALLED)
        _CMCONF_MESSAGE(FATAL_ERROR "CMCONF_GET cannot be called once CMCONF_SET is called.")
    ENDIF()
    IF(DEFINED ${var_name})
        _CMCONF_MESSAGE(FATAL_ERROR "Variable '${var_name}' is already defined. Cannot override existing context variable.")
    ENDIF()

    SET(pack_name "${CMCONF_PACKAGE_NAME_PREFIX}${CMCONF_SYSTEM_NAME}")
    FIND_PACKAGE(PACKAGE ${pack_name})
    IF(NOT ${pack_name}_FOUND)
        _CMCONF_MESSAGE(FATAL_ERROR "Cannot find configuration for system '${CMCONF_SYSTEM_NAME}'. Is the configuration installed?")
    ENDIF()

    _CMCONF_CHECK_AND_GET_ACTUAL_VAR_NAME("${var_name}" actual_var_name)
    IF(NOT DEFINED ${actual_var_name})
        _CMCONF_MESSAGE(FATAL_ERROR "Variable '${var_name}' is not defined in configuration for system '${CMCONF_SYSTEM_NAME}'.")
    ENDIF()
    SET_PROPERTY(CACHE CMCONF_GET_CALLED PROPERTY VALUE ON)
    SET(${var_name} "${${actual_var_name}}" PARENT_SCOPE)
ENDFUNCTION()



##
#
#
FUNCTION(CMCONF_SET var_name value)
    _CMCONF_CHECK_SYSTEM_IS_SET()
    IF(CMCONF_GET_CALLED)
        _CMCONF_MESSAGE(FATAL_ERROR "Cannot call CMCONF_SET after CMCONF_GET")
    ENDIF()
    _CMCONF_CHECK_AND_GET_ACTUAL_VAR_NAME("${var_name}" actual_var_name) 
    IF(DEFINED ${actual_var_name})
        _CMCONF_MESSAGE(FATAL_ERROR "Cannot set variable '${var_name}' because it is already defined.")
    ENDIF()
    
    SET_PROPERTY(CACHE CMCONF_SET_CALLED PROPERTY VALUE ON)
    SET(${actual_var_name} "${value}"
        CACHE STRING
        "CMCONF setting variable"
    )

    IF(CMCONF_INSTALL_AS_SYMLINK)
        IF(CMCONF_DEFER_CALL_ID)
            RETURN()
        ENDIF()
        CMAKE_LANGUAGE(DEFER IDVAR id CALL _CMCONF_DEFERED_CALL_FOR_INSTALL)
        SET_PROPERTY(CACHE CMCONF_DEFER_CALL_ID PROPERTY VALUE ${id})
    ENDIF()
ENDFUNCTION()



## Helper
# Install current active configuration to local CMake package registry.
#
# Control Variables
# Exacly one of the following must be set to ON otherwise install is skipped.
# - CMCONF_INSTALL_AS_SYMLINK - installs configuration by creating a symlink to 
#
MACRO(_CMCONF_DEFERED_CALL_FOR_INSTALL)
    IF(NOT CMCONF_INSTALL_AS_SYMLINK)
        RETURN()
    ENDIF()
    _CMCONF_MESSAGE(STATUS "Installing configuration for ${CMCONF_SYSTEM_NAME} as symlink")
    SET(CMAKE_EXPORT_PACKAGE_REGISTRY ON)
    INSTALL(PACKAGE "${CMCONF_PACKAGE_NAME_PREFIX}${CMCONF_SYSTEM_NAME}")
ENDMACRO()



## Helper
#
#
FUNCTION(_CMCONF_CHECK_AND_NORMALIZE_SYSTEM_NAME system_name output_var)
    IF(NOT system_name MATCHES "^[^a-zA-Z_]$")
        _CMCONF_MESSAGE(FATAL_ERROR "Invalid system name '${system_name}'. It can contain only [a-zA-Z_] characters.")
    ENDIF()
    STRING(TOUPPER "${system_name}" system_name_upper)
    SET(${output_var} "${system_name_upper}" PARENT_SCOPE)
ENDFUNCTION()



## Helper
#
#
FUNCTION(_CMCONF_CHECK_AND_GET_ACTUAL_VAR_NAME var_name output_var)
    IF(NOT var_name MATCHES "^[^a-zA-Z_]$")
        _CMCONF_MESSAGE(FATAL_ERROR "Invalid variable name '${var_name}'. It can contain only [a-zA-Z_] characters.")
    ENDIF()
    STRING(TOUPPER "${CMCONF_SYSTEM_NAME}" system_name_upper)
    SET(_var "${system_name_upper}_${var_name}" PARENT_SCOPE)
    SET(${output_var} "${_var}" PARENT_SCOPE)
ENDFUNCTION()



## Helper
#
#
MACRO(_CMCONF_CHECK_SYSTEM_IS_SET)
    IF(NOT CMCONF_SYSTEM_NAME)
        _CMCONF_MESSAGE(FATAL_ERROR "System name is not set. Call CMCONF_SET_SYSTEM_NAME before using CMCONF_GET or CMCONF_SET")
    ENDIF()
ENDMACRO() 



## Helper
#
#
#
MACRO(_CMCONF_MESSAGE level msg)
    IF(CMCONF_SYSTEM_NAME)
        MESSAGE(${level} "CMCONF[${CMCONF_SYSTEM_NAME}] - ${msg}")
    ELSE()
        MESSAGE(${level} "CMCONF - ${msg}")
    ENDIF()
ENDMACRO()