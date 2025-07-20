
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../../../CMCONF.cmake")

# Override template to point to malformed template BEFORE calling CMCONF_INIT_SYSTEM
# It needs to be done here because INTERNAL implies FORCE!
SET(CMCONF_INSTALL_CMAKELISTS_TEMPLATE_FILE 
    "${CMAKE_CURRENT_LIST_DIR}/../malformed_template.cmake.in"
    CACHE INTERNAL 
    "Malformed template for testing install project failure"
)

CMCONF_INIT_SYSTEM("TEST")

CMCONF_SET("VARIABLE_A" "test_value_a")
