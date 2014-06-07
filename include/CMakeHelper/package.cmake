# Packaging
# =========

# function to configure and install Config.cmake and ConfigVersion.cmake for all project types
FUNCTION(cmh_package_common config_file configversion_file)
	
	
	# Config.cmake for build tree
	set(CONF_INCLUDE_DIR "${PROJECT_SOURCE_DIR}/include")
	set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/include" "${PROJECT_BINARY_DIR}/include")
	configure_file(
		${config_file}
		"${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
		@ONLY)


	# Config.cmake for install tree
	set(CONF_INCLUDE_DIR "\${${PROJECT_NAME_UPPER}_INSTALL_PREFIX}/include")
	set(CONF_INCLUDE_DIRS "\${${PROJECT_NAME_UPPER}_INSTALL_PREFIX}/include")
	configure_file(
		${config_file}
		"${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PROJECT_NAME}Config.cmake"
		@ONLY)


	# ConfigVersion.cmake
	configure_file(
		${configversion_file}
		"${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
		@ONLY)


	# Install config files
	install(FILES
		"${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PROJECT_NAME}Config.cmake"
		"${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
		DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME}" COMPONENT dev)

ENDFUNCTION()


FUNCTION(cmh_package_static_library)

	MESSAGE(STATUS "generate package: ${PROJECT_NAME}")

	#export(TARGETS ${PROJECT_NAME} FILE "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake")
	export(TARGETS ${PROJECT_NAME} FILE "${CMAKE_INSTALL_PREFIX}/bin/${PROJECT_NAME}Targets.cmake")

	# Export the package for use from the build-tree
	# (this registers the build-tree with a global CMake-registry)
	export(PACKAGE ${PROJECT_NAME})

	# files to configure
	set(config_file		${CMakeHelper_INCLUDE_DIR}/CMakeHelper/static/libraryConfig.cmake.in)
	set(configversion_file	${CMakeHelper_INCLUDE_DIR}/CMakeHelper/static/libraryConfigVersion.cmake.in)

	cmh_package_common(${config_file} ${configversion_file})

	# Install the export set for use with the install-tree
	install(
		EXPORT ${PROJECT_NAME}Targets
		DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME}" COMPONENT dev)

ENDFUNCTION()


