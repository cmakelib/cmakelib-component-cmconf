##
#
# Test configuration with wrong system name
#

#FIND_PACKAGE(CMLIB REQUIRED COMPONENTS CMCONF)
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../CMCONF.cmake")

CMCONF_INIT_SYSTEM("TEST")

CMCONF_SET("VARIABLE_A" "test_value_a")
