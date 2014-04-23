# Common methods for building static c++ libraries


#MESSAGE("CMAKE_BINARY_DIR      ${CMAKE_BINARY_DIR}")
#MESSAGE("CMAKE_FILES_DIRECTORY ${CMAKE_FILES_DIRECTORY}")
#MESSAGE("PROJECT_SOURCE_DIR    ${PROJECT_SOURCE_DIR}")
#MESSAGE("PROJECT_BINARY_DIR    ${PROJECT_BINARY_DIR}")
#MESSAGE("INSTALL_BIN_DIR       ${INSTALL_BIN_DIR}")
#MESSAGE("INSTALL_LIB_DIR       ${INSTALL_LIB_DIR}")

set(CMAKE_HELPER_INSTALL_DIR $ENV{HOME}/usr/lib/cmake/CMakeHelper)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -std=c++0x -Werror -Wall -Wno-unknown-pragmas -Wno-unused-local-typedefs -rdynamic -pthread")

string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

set(CMAKE_INSTALL_PREFIX $ENV{HOME}/usr)

set(INSTALL_LIB_DIR     ${CMAKE_INSTALL_PREFIX}/lib)
set(INSTALL_BIN_DIR     ${CMAKE_INSTALL_PREFIX}/bin)
set(INSTALL_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include/${PROJECT_NAME})
set(INSTALL_CMAKE_DIR   ${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME})


include_directories("${PROJECT_SOURCE_DIR}/src" "${PROJECT_BINARY_DIR}/src")


# Make relative paths absolute (needed later on)
foreach(p LIB BIN INCLUDE CMAKE)
	set(var INSTALL_${p}_DIR)
	if(NOT IS_ABSOLUTE "${${var}}")
		set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
	endif()
endforeach()


# Doxygen
# =======
find_package(Doxygen)
if(DOXYGEN_FOUND)

	find_package(Graphviz)
	if(Graphviz_FOUND)
		set(HAVE_DOT YES)
	else()
		set(HAVE_DOT NO)
	endif()

	set(CMAKE_DOXYFILE_FILE "${CMAKE_HELPER_INSTALL_DIR}/Doxyfile.in")
	
	configure_file(
		${CMAKE_DOXYFILE_FILE}
		${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
	
	set(WORKDIR ${CMAKE_CURRENT_BINARY_DIR})
	set(WORKDIR ${CMAKE_CURRENT_SOURCE_DIR})

	add_custom_target(doc
		${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
		WORKING_DIRECTORY ${WORKDIR}
		COMMENT "Generating API documentation with Doxygen" VERBATIM
		)


endif(DOXYGEN_FOUND)



# Global Library Configuration Header
configure_file(
	"${PROJECT_SOURCE_DIR}/src/${PROJECT_NAME}/config.hpp.in"
	"${PROJECT_BINARY_DIR}/src/${PROJECT_NAME}/config.hpp")

install(
	FILES ${PROJECT_BINARY_DIR}/src/${PROJECT_NAME}/config.hpp
	DESTINATION include/${PROJECT_NAME})

# Glob Source and Header Files
# ============================

file(GLOB_RECURSE SOURCES_ABS ${PROJECT_SOURCE_DIR}/src/*.cpp)
foreach(s ${SOURCES_ABS})
	file(RELATIVE_PATH r ${PROJECT_SOURCE_DIR} ${s})
	set(SOURCES ${SOURCES} ${r})

	#MESSAGE("${s} ${PROJECT_SOURCE_DIR} ${r}")	
endforeach()
#MESSAGE("${SOURCES}")


set(INCLUDE_EXTENSIONS ${INCLUDE_EXTENSIONS} hpp glsl)
foreach(e ${INCLUDE_EXTENSIONS})
	file(GLOB_RECURSE f ${PROJECT_SOURCE_DIR}/src/*.${e})
	set(HEADERS_ABS ${HEADERS_ABS} ${f})
endforeach()

foreach(s ${HEADERS_ABS})
	file(RELATIVE_PATH r ${PROJECT_SOURCE_DIR}/src ${s})
	set(HEADERS ${HEADERS} ${r})
	
	#MESSAGE("${s} ${PROJECT_SOURCE_DIR}/src ${r}")
endforeach()
#MESSAGE("${HEADERS}")


add_library(${PROJECT_NAME} ${SOURCES})

# install library
install(
	TARGETS ${PROJECT_NAME}
	DESTINATION "${INSTALL_LIB_DIR}"
	EXPORT ${PROJECT_NAME}Targets
	RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin
	LIBRARY DESTINATION "${INSTALL_LIB_DIR}" COMPONENT shlib
	PUBLIC_HEADER DESTINATION "${INSTALL_INCLUDE_DIR}/${PROJECT_NAME}" COMPONENT dev
)

# install headers
foreach(h ${HEADERS})
	get_filename_component(f ${h} PATH)
	#MESSAGE("${h} ${f}")
	install(FILES ${PROJECT_SOURCE_DIR}/src/${h} DESTINATION include/${f})
endforeach()


# Packaging
# =========

# Add all targets to the build-tree export set

#export(TARGETS ${PROJECT_NAME} FILE "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake")
export(TARGETS ${PROJECT_NAME} FILE "${INSTALL_BIN_DIR}/${PROJECT_NAME}Targets.cmake")

# Export the package for use from the build-tree
# (this registers the build-tree with a global CMake-registry)
export(PACKAGE ${PROJECT_NAME_UPPER})


# projectConfig.cmake
# ===================
file(RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}" "${INSTALL_INCLUDE_DIR}")

#set(CMAKE_CONFIG_FILE ${PROJECT_NAME}Config.cmake.in)
set(CMAKE_CONFIG_FILE ${CMAKE_HELPER_INSTALL_DIR}/static_libraryConfig.cmake.in)

# ... for the build tree
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}")
configure_file(
	${CMAKE_CONFIG_FILE}
	"${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
	@ONLY)

# ... for the install tree
set(CONF_INCLUDE_DIRS "\${${PROJECT_NAME_UPPER}_CMAKE_DIR}/${REL_INCLUDE_DIR}")
configure_file(
	${CMAKE_CONFIG_FILE}
	"${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PROJECT_NAME}Config.cmake"
	@ONLY)


# projectConfigVersion.cmake
# ==========================

#set(CMAKE_CONFIGVERSION_FILE ${PROJECT_NAME}ConfigVersion.cmake.in)
set(CMAKE_CONFIGVERSION_FILE ${CMAKE_HELPER_INSTALL_DIR}/static_libraryConfigVersion.cmake.in)

# Create ConfigVersion.cmake file
configure_file(
	${CMAKE_CONFIGVERSION_FILE}
	"${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
	@ONLY)


# Install
# =======

# Install the foobarConfig.cmake and foobarConfigVersion.cmake
install(FILES
	"${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PROJECT_NAME}Config.cmake"
	"${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
	DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)

# Install the export set for use with the install-tree
#MESSAGE("${INSTALL_CMAKE_DIR}")

install(
	EXPORT ${PROJECT_NAME}Targets
	DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)


