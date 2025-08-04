# CMCONF Test Suite

Comprehensive test suite for the CMCONF (CMake Configuration Framework) component library.

## Test Modules

Currently tested functionality

- **`CMCONF_SET`** - Configuration variable setting
- **`CMCONF_GET`** - Configuration variable retrieval
- **`CMCONF_INIT_SYSTEM`** - System name configuration
- **`INSTALL Feature`** - Configuration installation
- **`UNINSTALL Feature`** - Configuration uninstallation

Not covered functionality

- Edge cases for Windows OS regard of `reg` command behaviour.
  It is expected that this command is available on Windows be default.
  If not, not only CMake but also Windows itself is broken.  

### Test Structure

Tests are organized into subdirectories within `test_cases`, separated into:

- **`pass/`** - Tests that verify correct functionality and expected behavior
- **`fail/`** - Tests that verify proper error handling and validation

Each test case directory contains a `CMakeLists.txt` file that tests specific functionality.

Configuration templates and test resources are placed in the `config_templates` directory.

## Test Framework

- `TEST.cmake` - Common test macros. It is reused from CMLIB.
- `cache_var.cmake` - Macros to force set and restore cache variables. It is reused from CMLIB.
- `test_cmconf_helpers.cmake` - CMCONF-specific test helper functions and macros

### Test Resource Creation and Maintenance

When external resources are needed to test functionality:

- Configuration templates are provided in the `config_templates` directory
- Test configurations are created from predefined templates
- There are no external dependencies to download or install
- There shall be no dynamic creation of test resources during a test run (exceptions can apply if reasoned)

## Running Tests

**All tests are designed to be run from a clean source tree.**

CMCONF is consistent and functional only when all tests pass.

Any test failure indicates CMCONF is not working as expected, even if the failure seems unrelated to required functionality. Complete system consistency is essential for reliable operation.

### Run All Tests

Tests shall be run in Project and Script mode.

```bash
# Project mode
git clean -xfd .
cmake .

# Script mode
git clean -xfd .
cmake -P ./test/CMakeLists.txt
```

### Clean Up

```bash
git clean -xfd .
```

## Platform Considerations

Tests are designed to run on Linux-based systems as the main development platform. Platform-specific behavior is tested where applicable, particularly for:

- Unix home directory handling
- System-specific configuration paths (windows vs unix)
- Platform-specific variable behaviors