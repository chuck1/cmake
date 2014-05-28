cmake_minimum_required (VERSION 2.6)

PROJECT(CMakeHelper)
SET(PACKAGE_VERSION 0.0.1)

# workaround for circular dependency of this project on itself...
SET(CMAKE_INSTALL_PREFIX $ENV{HOME}/usr)
SET(CMakeHelper_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include)

include(${PROJECT_SOURCE_DIR}/include/CMakeHelper/functions.cmake)

include(${PROJECT_SOURCE_DIR}/include/CMakeHelper/package_basic/package.cmake)

dot_glob(pdf)

configure_glob("in_cmh")

install_glob_source(include "in")
install_glob_source(include "cmake")



