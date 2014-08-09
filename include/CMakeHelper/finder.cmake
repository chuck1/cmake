

FUNCTION(cmh_finder PKG_NAME PKG_COMPONENTS)
	
	STRING(TOLOWER ${PKG_NAME} PKG_NAME_LOWER)
	
	
	IF(${PKG_NAME_LOWER}_SHARED)
	        SET(SHARED_POSTFIX "_shared")
	ENDIF()
	
	MESSAGE(STATUS "Find ${PKG_NAME}")
	
	
	#FOREACH(c ${PKG_COMPONENT})
	FOREACH(c ${${PKG_NAME}_FIND_COMPONENTS})
	
		MESSAGE(STATUS "c ${c}")

	        #LIST(FIND ${PKG_NAME}_FIND_COMPONENTS "${c}" idx_${c})
		LIST(FIND PKG_COMPONENTS "${c}" idx_${c})
	
	        STRING(COMPARE EQUAL ${idx_${c}} "-1" not_${c})
	
	        IF(NOT ${not_${c}})


			FIND_PACKAGE(${PKG_NAME_LOWER}_${c}${shared_postfix} REQUIRED)
	
			MESSAGE(STATUS "    ${c}")
	                MESSAGE(STATUS "    libs: ${${PKG_NAME_LOWER}_${c}_LIBRARIES}")

			SET(
	                        ${PKG_NAME}_LIBRARIES
	                        ${${PKG_NAME}_LIBRARIES}
				${${PKG_NAME_LOWER}_${c}_LIBRARIES})
	                SET(
	                        ${PKG_NAME}_LIBRARIES
	                        ${${PKG_NAME}_LIBRARIES}
				${${PKG_NAME_LOWER}_${c}_LIBRARIES} PARENT_SCOPE)
		ELSE()
			MESSAGE(FATAL_ERROR "${c} not found")
			#MESSAGE(FATAL_ERROR "
	        ENDIF()
	
	        MESSAGE(STATUS "${PKG_NAME}_LIBRARIES ${${PKG_NAME}_LIBRARIES}")       
	
	ENDFOREACH()

ENDFUNCTION()

