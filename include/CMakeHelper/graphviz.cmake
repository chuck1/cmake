

FUNCTION(dot_glob output_format)
	FILE(GLOB_RECURSE files_abs ${PROJECT_SOURCE_DIR}/*.dot)
	FOREACH(f ${files_abs})
		FILE(RELATIVE_PATH r ${PROJECT_SOURCE_DIR} ${f})
		
		GET_FILENAME_COMPONENT(root ${r} NAME_WE)
		
		SET(input  ${PROJECT_SOURCE_DIR}/${root}.dot)
		SET(output ${PROJECT_BINARY_DIR}/${root}.${output_format})
		
		ADD_CUSTOM_COMMAND(
			OUTPUT ${output}
			COMMAND ${DOT_COMMAND} -T${output_format} -o${output})

		SET_SOURCE_FILES_PROPERTIES(${output} PROPERTIES GENERATED TRUE)

		SET(dot_output_files ${dot_output_files} ${output})
	ENDFOREACH()
	
	ADD_CUSTOM_TARGET(dot DEPENDS ${dot_output_files})
	
ENDFUNCTION()



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


