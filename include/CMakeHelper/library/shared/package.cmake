# Packaging
# =========

# function to configure and install Config.cmake and ConfigVersion.cmake for all project types

FUNCTION(cmh_package_shared_library)

	SET(pkgname ${PROJECT_NAME})

	MESSAGE(STATUS "generate package: ${pkgname}")
	MESSAGE(STATUS "install prefix:   ${CMAKE_INSTALL_PREFIX}")
	
	SET(targets ${pkgname})
	FOREACH(l ${libs})
		IF(TARGET ${l})
			MESSAGE(STATUS "${l} is a target")
			GET_PROPERTY(imp TARGET ${l} PROPERTY IMPORTED)
			IF(${imp})
				MESSAGE(STATUS "${l} is an imported target")
			ELSE()
				MESSAGE(STATUS "${l} is not an imported target")
				LIST(APPEND targets ${l})
			ENDIF()
			
		ENDIF()
	ENDFOREACH()

	MESSAGE(STATUS "targets:          ${targets}")

	export(TARGETS ${targets}
		FILE "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake")
	export(TARGETS ${targets}
		FILE "${CMAKE_INSTALL_PREFIX}/bin/${PROJECT_NAME}Targets.cmake")

	# Export the package for use from the build-tree
	# (this registers the build-tree with a global CMake-registry)
	export(PACKAGE ${pkgname})

	# files to configure
	set(config_file		${CMakeHelper_INCLUDE_DIR}/CMakeHelper/library/shared/Config.cmake.in)
	set(configversion_file	${CMakeHelper_INCLUDE_DIR}/CMakeHelper/library/shared/ConfigVersion.cmake.in)

	cmh_package_common(${config_file} ${configversion_file})

	install(
		TARGETS ${PROJECT_NAME}
		EXPORT ${PROJECT_NAME}Targets
		DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" COMPONENT dev)
		

	# Install the export set for use with the install-tree
	#install(
	#	EXPORT ${pkgname}Targets
	#	DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/${pkgname}" COMPONENT dev)

ENDFUNCTION()

