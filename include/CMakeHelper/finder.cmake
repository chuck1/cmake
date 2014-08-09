

FUNCTION(cmh_finder PKG_NAME PKG_COMPONENTS)
	
	STRING(TOLOWER ${PKG_NAME} PKG_NAME_LOWER)
	
	
	IF(${PKG_NAME_LOWER}_SHARED)
	        SET(SHARED_POSTFIX "_shared")
	ENDIF()
	
	MESSAGE(STATUS "Find ${PKG_NAME}")
	
	
	#FOREACH(c ${PKG_COMPONENT})
	FOREACH(c ${${PKG_NAME}_FIND_COMPONENTS})
	
	        #LIST(FIND ${PKG_NAME}_FIND_COMPONENTS "${c}" idx_${c})
	        LIST(FIND PKG_COMPONENT "${c}" idx_${c})
	
	        STRING(COMPARE EQUAL ${idx_${c}} "-1" not_${c})
	
	        IF(NOT ${not_${c}})
	                MESSAGE(STATUS "    ${c}")
	                FIND_PACKAGE(${PKG_NAME_LOWER}_${c}${shared_postfix})
	
	                SET(
	                        ${PKG_NAME}_LIBRARIES
	                        ${${PKG_NAME}_LIBRARIES}
	                        ${${PKG_NAME_LOWER}_${c}_LIBRARIES})
	
	        ENDIF()
	
	        #MESSAGE(STATUS "${pkg_name}_LIBRARIES ${${pkg_name}_LIBRARIES}")       
	
	ENDFOREACH()

ENDFOREACH()

