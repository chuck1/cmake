cmake_minimum_required (VERSION 2.6)

IF(UNIX)
	INCLUDE($ENV{HOME}/.config.cmake)
ELSEIF(WIN32)
	INCLUDE($ENV{HOMEPATH}\\.config.cmake)
ENDIF()

PROJECT(CMakeHelper)
SET(PACKAGE_VERSION 0.0.1)

# workaround for circular dependency of this project on itself...
SET(CMakeHelper_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include)

include(${PROJECT_SOURCE_DIR}/include/CMakeHelper/functions.cmake)
include(${PROJECT_SOURCE_DIR}/include/CMakeHelper/package_cmh/package.cmake)

dot_glob(pdf)

configure_glob("in_cmh")

install_glob_source(include "in")
install_glob_source(include "cmake")



