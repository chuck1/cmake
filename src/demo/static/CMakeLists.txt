cmake_minimum_required (VERSION 2.8.9)

project(proj)

# find_package

# include_directories

find_package(freetype)

include_directories("/usr/include/freetype2")

# custom include extensions
set(INCLUDE_EXTENSIONS obj)

SET(GRU_VERSION 0.1.1)


# common methods for static library
# =================================
include($ENV{HOME}/usr/lib/cmake/CMakeHelper/static/library.cmake)


add_subdirectory(test)


