# Basic Packaging
# ===============

# Add all targets to the build-tree export set

# Export the package for use from the build-tree
# (this registers the build-tree with a global CMake-registry)
export(PACKAGE ${PROJECT_NAME})


# ProjectConfig.cmake
# ===================
#file(RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}" "${INSTALL_INCLUDE_DIR}")

#set(CMAKE_CONFIG_FILE ${PROJECT_NAME}Config.cmake.in)
set(CONFIG_FILE ${CMakeHelper_INCLUDE_DIR}/CMakeHelper/package_cmh/Config.cmake.in)


# difference between build tree and install tree below is the include directory paths
# listed in the config file. Don't know why this is needed; seems like just the install
# tree is needed; perhaps it is for sub_directories that call find_package when this package isnt yet installed... (a diagram might be nice...)

# ... for the build tree
set(CONF_INCLUDE_DIR "${PROJECT_SOURCE_DIR}/include")
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/include" "${PROJECT_BINARY_DIR}/include")
configure_file(
	${CONFIG_FILE}
	"${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
	@ONLY)

# ... for the install tree
set(CONF_INCLUDE_DIR "\${${PROJECT_NAME}_INSTALL_PREFIX}/include")
set(CONF_INCLUDE_DIRS "\${${PROJECT_NAME}_INSTALL_PREFIX}/include")
configure_file(
	${CONFIG_FILE}
	"${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PROJECT_NAME}Config.cmake"
	@ONLY)


# projectConfigVersion.cmake
# ==========================

#set(CMAKE_CONFIGVERSION_FILE ${PROJECT_NAME}ConfigVersion.cmake.in)
set(CMAKE_CONFIGVERSION_FILE ${CMakeHelper_INCLUDE_DIR}/CMakeHelper/package_cmh/ConfigVersion.cmake.in)

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
	DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME}" COMPONENT dev)


# Install the export set for use with the install-tree
#MESSAGE("${INSTALL_CMAKE_DIR}")





