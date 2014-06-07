INCLUDE(${CMakeHelper_INCLUDE_DIR}/CMakeHelper/package.cmake)

FUNCTION(cmh_header_only_package)

	MESSAGE(STATUS "generate package: ${PROJECT_NAME}")

	# Export the package for use from the build-tree
	# (this registers the build-tree with a global CMake-registry)
	export(PACKAGE ${PROJECT_NAME})

	# ProjectConfig.cmake
	# ===================
	set(CONFIG_FILE )

	# files to configure
	set(config_file		${CMakeHelper_INCLUDE_DIR}/CMakeHelper/header_only/Config.cmake.in)
	set(configversion_file	${CMakeHelper_INCLUDE_DIR}/CMakeHelper/header_only/ConfigVersion.cmake.in)

	cmh_package_common(${config_file} ${configversion_file})


ENDFUNCTION()


