##
# cache_var.cmake are shared with CMLIB to avoid unnecesssary dependencies.
# cache_var.cmake is properly validated.
#

FIND_PACKAGE(CMLIB REQUIRED)

IF(NOT EXISTS "${CMLIB_DIR}")
	MESSAGE(FATAL_ERROR "Cannot find CMLIB_DIR '${CMLIB_DIR}'")
ENDIF()

INCLUDE("${CMLIB_DIR}/test/cache_var.cmake")