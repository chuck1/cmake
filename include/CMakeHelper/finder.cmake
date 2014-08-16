

FUNCTION(cmh_finder PKG_NAME PKG_COMPONENTS)

	# clear variables
	SET(${PKG_NAME}_LIBRARIES)

	# preliminaries
	STRING(TOLOWER ${PKG_NAME} PKG_NAME_LOWER)
	
	IF(${PKG_NAME}_SHARED)
	        SET(shared_postfix "_shared")
	ENDIF()
	
	MESSAGE(STATUS "Find ${PKG_NAME}")
	
	#FOREACH(c ${PKG_COMPONENT})
	FOREACH(c ${${PKG_NAME}_FIND_COMPONENTS})
	
		#MESSAGE(STATUS "c ${c}")

	        #LIST(FIND ${PKG_NAME}_FIND_COMPONENTS "${c}" idx_${c})
		LIST(FIND PKG_COMPONENTS "${c}" idx_${c})
	
	        STRING(COMPARE EQUAL ${idx_${c}} "-1" not_${c})
	
	        IF(NOT ${not_${c}})
			SET(comp ${PKG_NAME_LOWER}_${c}${shared_postfix})
			
			FIND_PACKAGE(${comp} REQUIRED)
	
			MESSAGE(STATUS "    ${comp}")
			MESSAGE(STATUS "    ${comp}_LIBRARIES: ${${comp}_LIBRARIES}")
			
			LIST(APPEND ${PKG_NAME}_LIBRARIES ${${comp}_LIBRARIES})
			LIST(REMOVE_DUPLICATES ${PKG_NAME}_LIBRARIES)

		ELSE()
			MESSAGE(FATAL_ERROR "${c} not found")
			#MESSAGE(FATAL_ERROR "
	        ENDIF()
	
	        MESSAGE(STATUS "${PKG_NAME}_LIBRARIES ${${PKG_NAME}_LIBRARIES}")       
	
	ENDFOREACH()
	
	#MESSAGE(STATUS "${PKG_NAME}_LIBRARIES ${${PKG_NAME}_LIBRARIES}")       
	#MESSAGE(STATUS "libs ${libs}")       
	
	# set in parent scope
        SET(${PKG_NAME}_LIBRARIES ${${PKG_NAME}_LIBRARIES} PARENT_SCOPE)

ENDFUNCTION()

