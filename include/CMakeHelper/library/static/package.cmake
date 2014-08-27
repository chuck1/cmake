# Packaging
# =========

FUNCTION(cmh_package_static_library)

	#MESSAGE(STATUS "generate package: ${PROJECT_NAME}")
	#MESSAGE(STATUS "install prefix:   ${CMAKE_INSTALL_PREFIX}")

	export(TARGETS ${PROJECT_NAME} FILE "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake")
	export(TARGETS ${PROJECT_NAME} FILE "${CMAKE_INSTALL_PREFIX}/bin/${PROJECT_NAME}Targets.cmake")

	# Export the package for use from the build-tree
	# (this registers the build-tree with a global CMake-registry)
	export(PACKAGE ${PROJECT_NAME})

	# files to configure
	set(config_file		${CMakeHelper_INCLUDE_DIR}/CMakeHelper/library/static/Config.cmake.in)
	set(configversion_file	${CMakeHelper_INCLUDE_DIR}/CMakeHelper/library/static/ConfigVersion.cmake.in)

	cmh_package_common(${config_file} ${configversion_file})

	# Install the export set for use with the install-tree
	install(
		EXPORT ${PROJECT_NAME}Targets
		DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME}" COMPONENT dev)

ENDFUNCTION()


