# Common methods for building static c++ libraries


#MESSAGE("CMAKE_BINARY_DIR      ${CMAKE_BINARY_DIR}")
#MESSAGE("CMAKE_FILES_DIRECTORY ${CMAKE_FILES_DIRECTORY}")
#MESSAGE("PROJECT_SOURCE_DIR    ${PROJECT_SOURCE_DIR}")
#MESSAGE("PROJECT_BINARY_DIR    ${PROJECT_BINARY_DIR}")
#MESSAGE("INSTALL_BIN_DIR       ${INSTALL_BIN_DIR}")
#MESSAGE("INSTALL_LIB_DIR       ${INSTALL_LIB_DIR}")


# Global Library Configuration Header
configure_file(
	"${PROJECT_SOURCE_DIR}/src/${LIB_NAME}/config.hpp.in"
	"${PROJECT_SOURCE_DIR}/src/${LIB_NAME}/config.hpp")

# Glob Source and Header Files
# ============================



file(GLOB_RECURSE SOURCES_ABS ${PROJECT_SOURCE_DIR}/src/*.cpp)
foreach(s ${SOURCES_ABS})
	file(RELATIVE_PATH r ${PROJECT_SOURCE_DIR} ${s})
	set(SOURCES ${SOURCES} ${r})

	#MESSAGE("${s} ${PROJECT_SOURCE_DIR} ${r}")	
endforeach()
#MESSAGE("${SOURCES}")



file(GLOB_RECURSE FILES_HPP_ABS ${PROJECT_SOURCE_DIR}/src/*.hpp)
file(GLOB_RECURSE FILES_GLSL_ABS ${PROJECT_SOURCE_DIR}/src/*.glsl)

set(HEADERS_ABS ${FILES_HPP_ABS} ${FILES_GLSL_ABS})

foreach(s ${HEADERS_ABS})
	file(RELATIVE_PATH r ${PROJECT_SOURCE_DIR}/src ${s})
	set(HEADERS ${HEADERS} ${r})
	
	#MESSAGE("${s} ${PROJECT_SOURCE_DIR}/src ${r}")
endforeach()
#MESSAGE("${HEADERS}")


add_library(${LIB_NAME} ${SOURCES})

# install library
install(
	TARGETS ${LIB_NAME}
	DESTINATION "${INSTALL_LIB_DIR}"
	EXPORT ${PROJECT_name}Targets
	RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin
	LIBRARY DESTINATION "${INSTALL_LIB_DIR}" COMPONENT shlib
	PUBLIC_HEADER DESTINATION "${INSTALL_INCLUDE_DIR}/${LIB_NAME}" COMPONENT dev
)

# install headers
foreach(h ${HEADERS})
	get_filename_component(f ${h} PATH)
	#MESSAGE("${h} ${f}")
	install(FILES ${PROJECT_SOURCE_DIR}/src/${h} DESTINATION include/${f})
endforeach()


# The interesting stuff goes here
# ===============================

# Add all targets to the build-tree export set

#export(TARGETS ${LIB_NAME} FILE "${PROJECT_BINARY_DIR}/${PROJECT_name}Targets.cmake")
export(TARGETS ${LIB_NAME} FILE "${INSTALL_BIN_DIR}/${PROJECT_name}Targets.cmake")

# Export the package for use from the build-tree
# (this registers the build-tree with a global CMake-registry)
export(PACKAGE ${PROJECT_NAME})

# Create the FooBarConfig.cmake and FooBarConfigVersion files
file(RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}" "${INSTALL_INCLUDE_DIR}")

# ... for the build tree
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}")
configure_file(
	${PROJECT_name}Config.cmake.in
	"${PROJECT_BINARY_DIR}/${PROJECT_name}Config.cmake"
	@ONLY)

# ... for the install tree
set(CONF_INCLUDE_DIRS "\${FOOBAR_CMAKE_DIR}/${REL_INCLUDE_DIR}")
configure_file(
	${PROJECT_name}Config.cmake.in
	"${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PROJECT_name}Config.cmake"
	@ONLY)

# ... for both
configure_file(
	${PROJECT_name}ConfigVersion.cmake.in
	"${PROJECT_BINARY_DIR}/${PROJECT_name}ConfigVersion.cmake"
	@ONLY)

# Install the FooBarConfig.cmake and FooBarConfigVersion.cmake
install(FILES
	"${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PROJECT_name}Config.cmake"
	"${PROJECT_BINARY_DIR}/${PROJECT_name}ConfigVersion.cmake"
	DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)

# Install the export set for use with the install-tree
#MESSAGE("${INSTALL_CMAKE_DIR}")

install(
	EXPORT ${PROJECT_name}Targets
	DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)


