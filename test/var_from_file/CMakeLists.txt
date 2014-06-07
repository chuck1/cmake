CMAKE_MINIMUM_REQUIRED(VERSION 2.8.8)

project(test)

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

cmh_vars_from_file("${PROJECT_BINARY_DIR}/vars1.txt")

#MESSAGE(STATUS "debug_foo = ${debug_foo}")

SET(CMAKE_BUILD_TYPE ${PROJECT_BINARY_DIR})
STRING(COMPARE EQUAL ${CMAKE_BUILD_TYPE} "Debug" debug)

MESSAGE(STATUS "debug=${debug}")

SET(debug_foo 1)

cmh_process_debug(debug debug_foo)
cmh_process_debug(debug debug_bar)







