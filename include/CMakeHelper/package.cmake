# Packaging
# =========

# Add all targets to the build-tree export set

FUNCTION(cmh_package)

	MESSAGE(STATUS "generate package: ${PROJECT_NAME}")

	#export(TARGETS ${PROJECT_NAME} FILE "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake")
	export(TARGETS ${PROJECT_NAME} FILE "${CMAKE_INSTALL_PREFIX}/bin/${PROJECT_NAME}Targets.cmake")

	# Export the package for use from the build-tree
	# (this registers the build-tree with a global CMake-registry)
	export(PACKAGE ${PROJECT_NAME})


	# ProjectConfig.cmake
	# ===================
	set(CONFIG_FILE ${CMakeHelper_INCLUDE_DIR}/CMakeHelper/static/libraryConfig.cmake.in)


	# difference between build tree and install tree below is the include directory paths
	# listed in the config file. Don't know why this is needed; seems like just the install
	# tree is needed; perhaps it is for sub_directories that call find_package when this package isnt yet installed... (a diagram might be nice...)

	# ... for the build tree
	set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}")
	configure_file(
		${CONFIG_FILE}
		"${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
		@ONLY)

	# ... for the install tree
	set(CONF_INCLUDE_DIRS "\${${PROJECT_NAME_UPPER}_INSTALL_PREFIX}/include")
	configure_file(
		${CONFIG_FILE}
		"${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PROJECT_NAME}Config.cmake"
		@ONLY)


	# projectConfigVersion.cmake
	# ==========================

	#set(CMAKE_CONFIGVERSION_FILE ${PROJECT_NAME}ConfigVersion.cmake.in)
	set(CMAKE_CONFIGVERSION_FILE ${CMakeHelper_INCLUDE_DIR}/CMakeHelper/static/libraryConfigVersion.cmake.in)

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

	install(
		EXPORT ${PROJECT_NAME}Targets
		DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME}" COMPONENT dev)

ENDFUNCTION()


