# CMake-lib Configuration Component

Linux: ![buildbadge_github], Windows: ![buildbadge_github], Mac OS: ![buildbadge_github]

CMCONF aka **CMake-lib Global Configuration**

CMake-lib provides centralized configuration management for systems of related CMake projects.
It utilizes CMake user package registry to define environment-specific settings that can be shared across multiple projects.

## Requirements

CMCONF is intended to be used thru [CMLIB].

CMCONF is not supposed to be used separately.

To use the library install [CMLIB] and call `FIND_PACKAGE(CMLIB COMPONENTS CMCONF)`

## General

The library enables centralized configuration management for systems of related CMake projects.

### Definition of System

A **SYSTEM** is a non-empty, finite set of CMake-based projects that share common settings and are considered as part of a functional whole without practical use when used separately.

For example - Producer, Consumer and MQTTBroker projects that form a MQTT communication system:
- Producer connects to MQTTBroker and sends data
- Consumer connects to MQTTBroker and receives data
- Producer and Consumer are useless without MQTTBroker
- Therefore Producer, Consumer and MQTTBroker form a SYSTEM

Projects that are not part of the SYSTEM are considered External Dependencies.

### Configuration Management

CMCONF allows defining shared configuration variables (like dependency URIs, build settings) in a central configuration file that can be used by all projects in the system. This eliminates copy-pasting and ensures consistency across projects.

Configuration variables are stored as CMake cache variables and installed to CMake user package registry, allowing multiple systems to coexist on the same machine.

## Usage

```cmake
FIND_PACKAGE(CMLIB COMPONENTS CMCONF)
```

### Create Configuration File

Create a configuration file named `CMCONF_<SYSTEM_NAME>Config.cmake`:

```cmake
FIND_PACKAGE(CMLIB REQUIRED COMPONENTS CMCONF)

CMCONF_INIT_SYSTEM("EXAMPLE")

CMCONF_SET("OPENSSL_URI" "https://github.com/openssl/openssl.git")
CMCONF_SET("PAHOMQTT_URI" "https://github.com/eclipse/paho.mqtt.c.git")
```

### Install Configuration

Install the configuration to CMake user package registry:

```bash
cmake -DCMCONF_INSTALL_AS_SYMLINK=ON -P CMCONF_EXAMPLEConfig.cmake
```

### Use Configuration in Projects

In each project that belongs to the system:

```cmake
FIND_PACKAGE(CMLIB COMPONENTS CMCONF REQUIRED)

CMCONF_INIT_SYSTEM("EXAMPLE")

CMCONF_GET("OPENSSL_URI")
CMCONF_GET("PAHOMQTT_URI")

# Variables are now available: ${OPENSSL_URI}, ${PAHOMQTT_URI}
```

Examples can be found at [example] directory.

## Function list

Each entry in list represents one feature for CMake.

Detailed documentation for each function can be found at the appropriate module.

- [CMCONF_INIT_SYSTEM] - set name of the system and optionally install configuration
- [CMCONF_GET] - get value of the configuration variable
- [CMCONF_SET] - set value of the configuration variable

## Documentation

Every function has comprehensive documentation written as part of the function definition.

Context documentation is located at [CMCONF.cmake]

## License

Project is licensed under [MIT](LICENSE)

[CMLIB]: https://github.com/cmakelib/cmakelib
[CMCONF.cmake]: CMCONF.cmake
[CMCONF_INIT_SYSTEM]: CMCONF.cmake
[CMCONF_GET]: CMCONF.cmake
[CMCONF_SET]: CMCONF.cmake
[example]: example/
[buildbadge_github]: https://github.com/cmakelib/cmakelib-component-cmconf/actions/workflows/tests.yml/badge.svg