

FUNCTION(install_glob extension folder)
	FILE(GLOB_RECURSE files_abs ${PROJECT_SOURCE_DIR}/${folder}/*.${extension})
	FOREACH(f ${files_abs})
		FILE(RELATIVE_PATH r ${PROJECT_SOURCE_DIR}/${folder} ${f})
		GET_FILENAME_COMPONENT(d ${r} PATH)
		INSTALL(FILES ${PROJECT_SOURCE_DIR}/${folder}/${r} DESTINATION include/${d})
	ENDFOREACH()
ENDFUNCTION()


FUNCTION(configure_glob)
	FILE(GLOB_RECURSE files_abs ${PROJECT_SOURCE_DIR}/*.in)
	FOREACH(f ${files_abs})
		FILE(RELATIVE_PATH r ${PROJECT_SOURCE_DIR} ${f})
		
		STRING(REGEX REPLACE "\\.in$" "" r ${r})
		
		CONFIGURE_FILE(
			"${PROJECT_SOURCE_DIR}/${r}.in"
			"${PROJECT_BINARY_DIR}/${r}")
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


