
# gather all files matching
#     ${PROJECT_SOURCE_DIR}/${folder}/*${extension}
# and install them in
#     ${CMAKE_INSTALL_PREFIX}/${folder}

FUNCTION(cmh_file_glob_source varname)
	
	SET(${varname} PARENT_SCOPE)
	
	SET(exts "c" "cc" "cpp" "cxx")
	FOREACH(e ${exts})
		FILE(GLOB_RECURSE files_abs ${PROJECT_SOURCE_DIR}/src/*.${e})
		FOREACH(f ${files_abs})
			FILE(RELATIVE_PATH f_rel ${PROJECT_SOURCE_DIR} ${f})
			SET(files ${files} ${f_rel})
		ENDFOREACH()
		
		#MESSAGE(STATUS "found in ${PROJECT_SOURCE_DIR}: ${files_abs_tmp}")
		
		FILE(GLOB_RECURSE files_abs ${PROJECT_BINARY_DIR}/src/*.${e})
		FOREACH(f ${files_abs})
			FILE(RELATIVE_PATH f_rel ${PROJECT_SOURCE_DIR} ${f})
			SET(files ${files} ${f_rel})
		ENDFOREACH()
		#MESSAGE(STATUS "found in ${PROJECT_BINARY_DIR}: ${files_abs_tmp}")
	ENDFOREACH()
	
	SET(${varname} ${files} PARENT_SCOPE)
	#MESSAGE(STATUS "returning: ${files}")
ENDFUNCTION()

FUNCTION(install_glob_source folder extension)
	FILE(GLOB_RECURSE files_abs ${PROJECT_SOURCE_DIR}/${folder}/*.${extension})
	FOREACH(f ${files_abs})
		FILE(RELATIVE_PATH r ${PROJECT_SOURCE_DIR}/${folder} ${f})
		GET_FILENAME_COMPONENT(d ${r} PATH)
		INSTALL(FILES ${PROJECT_SOURCE_DIR}/${folder}/${r} DESTINATION include/${PROJECT_NAME}/${d})
	ENDFOREACH()
ENDFUNCTION()


# gather all files matching
#     ${PROJECT_BINARY_DIR}/${folder}/*${extension}
# and install them in
#     ${CMAKE_INSTALL_PREFIX}/${folder}

FUNCTION(install_glob_binary folder extension)
	FILE(GLOB_RECURSE files_abs ${PROJECT_BINARY_DIR}/${folder}/*.${extension})
	FOREACH(f ${files_abs})
		FILE(RELATIVE_PATH r ${PROJECT_BINARY_DIR}/${folder} ${f})
		GET_FILENAME_COMPONENT(d ${r} PATH)
		INSTALL(FILES ${PROJECT_BINARY_DIR}/${folder}/${r} DESTINATION ${d})
	ENDFOREACH()
ENDFUNCTION()



FUNCTION(configure_glob extension)
	FILE(GLOB_RECURSE files_abs ${PROJECT_SOURCE_DIR}/*.${extension})
	FOREACH(f ${files_abs})
		FILE(RELATIVE_PATH r ${PROJECT_SOURCE_DIR} ${f})

		STRING(REGEX REPLACE "\\.${extension}$" "" r ${r})

		CONFIGURE_FILE(
			"${PROJECT_SOURCE_DIR}/${r}.${extension}"
			"${PROJECT_BINARY_DIR}/${r}"
			@ONLY)
	ENDFOREACH()
ENDFUNCTION()


FUNCTION(dot_glob output_format)

	SET(dot_command "dot")

	FILE(GLOB_RECURSE files_abs ${PROJECT_SOURCE_DIR}/*.dot)
	FOREACH(f ${files_abs})
		FILE(RELATIVE_PATH rs ${PROJECT_SOURCE_DIR} ${f})
		FILE(RELATIVE_PATH rb ${PROJECT_BINARY_DIR} ${f})

		GET_FILENAME_COMPONENT(we ${f} NAME_WE)
		GET_FILENAME_COMPONENT(ps ${rs} PATH)
		GET_FILENAME_COMPONENT(pb ${rb} PATH)

		SET(inputs ${ps}/${we}.dot)
		SET(inputb ${pb}/${we}.dot)
		SET(output ${ps}/${we}.${output_format})

		ADD_CUSTOM_COMMAND(
			OUTPUT ${output}
			COMMAND ${dot_command} -T${output_format} -o${output} ${inputb}
			DEPENDS ${inputs})

		SET_SOURCE_FILES_PROPERTIES(${output} PROPERTIES GENERATED TRUE)

		SET(dot_output_files ${dot_output_files} ${output})
	ENDFOREACH()

	ADD_CUSTOM_TARGET(dot DEPENDS ${dot_output_files})

ENDFUNCTION()


FUNCTION(link_exe)
	MESSAGE(STATUS "configure executable: ${PROJECT_NAME}")
	#MESSAGE(STATUS "source_dir: ${PROJECT_SOURCE_DIR}")
	#MESSAGE(STATUS "binary_dir: ${PROJECT_BINARY_DIR}")
	MESSAGE(STATUS "link to ${libs}")

	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -std=c++0x -Werror -Wall -Wno-unknown-pragmas -Wno-unused-local-typedefs -rdynamic -pthread -fmax-errors=5" PARENT_SCOPE)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -std=c++0x -Werror -Wall -Wno-unknown-pragmas -Wno-unused-local-typedefs -rdynamic -pthread -fmax-errors=5")
	
	SET(source_files)
	cmh_file_glob_source(source_files)

	#MESSAGE(STATUS "source files: ${source_files}")

	ADD_EXECUTABLE(${PROJECT_NAME} ${source_files})
	
	SET(libs_tmp ${libs} ${libs} ${libs})

	TARGET_LINK_LIBRARIES(${PROJECT_NAME} ${libs_tmp})
ENDFUNCTION()

FUNCTION(cmh_build_type)

	FILE(RELATIVE_PATH r ${PROJECT_SOURCE_DIR} ${PROJECT_BINARY_DIR})
	
	STRING(REGEX REPLACE "\\.\\./" "" r ${r})
	
	STRING(REGEX MATCH "^[A-Za-z0-9]+" r ${r})

	SET(CMAKE_BUILD_TYPE ${r} PARENT_SCOPE)
	
	#STRING(COMPARE EQUAL ${CMAKE_BUILD_TYPE} "Debug" DEBUG)

	#SET(DEBUG ${DEBUG} PARENT_SCOPE)

ENDFUNCTION()



FUNCTION(cmh_vars_from_file filename)
	FILE(STRINGS ${filename} vars)

	FOREACH(v ${vars})
		STRING(FIND ${v} "=" p)
		MATH(EXPR s "${p} + 1")
		STRING(SUBSTRING ${v} 0 ${p} left)
		STRING(SUBSTRING ${v} ${s} -1 right)

		SET(${left} ${right} PARENT_SCOPE)

		MESSAGE(STATUS "'${left}' '${right}'")
	ENDFOREACH()
ENDFUNCTION()

FUNCTION(cmh_process_debug parent var)
	IF(NOT DEFINED ${var})
		SET(${var} 0)
	ELSE()
		MATH(EXPR ${var} "${${parent}} & ${${var}}")
	ENDIF()
	IF(${${var}})
		MESSAGE(STATUS "-D${var}")
		ADD_DEFINITIONS("-D${var}=${${var}}")
	ENDIF()
	SET(${var} ${${var}} PARENT_SCOPE)
ENDFUNCTION()
FUNCTION(cmh_package_common config_file configversion_file)
	
	
	# Config.cmake for build tree
	set(CONF_INCLUDE_DIR  "${PROJECT_SOURCE_DIR}/include")
	set(CONF_INCLUDE_DIRS "${${PROJECT_NAME}_INCLUDE_DIRS}")
	set(CONF_TARGETS_FILE "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake")
	SET(CONF_LIBRARY_DIR  "${PROJECT_BINARY_DIR}")

	set(${PROJECT_NAME}_LIBRARY_DIR ${PROJECT_BINARY_DIR})

	configure_file(
		${config_file}
		"${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
		@ONLY)


	# Config.cmake for install tree
	set(CONF_INCLUDE_DIR  "\${${PROJECT_NAME}_INSTALL_PREFIX}/include/${PROJECT_NAME}")
	set(CONF_INCLUDE_DIRS "\${${PROJECT_NAME}_INSTALL_PREFIX}/include/${PROJECT_NAME}" ${${PROJECT_NAME}_INCLUDE_DIRS})
	set(CONF_TARGETS_FILE "\${${PROJECT_NAME}_INSTALL_PREFIX}/bin/${PROJECT_NAME}Targets.cmake")
	SET(CONF_LIBRARY_DIR  "\${${PROJECT_NAME}_INSTALL_PREFIX}/lib")
	
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



