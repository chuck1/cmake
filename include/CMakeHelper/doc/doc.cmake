
include(${CMakeHelper_INCLUDE_DIR}/CMakeHelper/color.cmake)

FUNCTION(cmh_doc)

find_package(Doxygen REQUIRED)

if(DOXYGEN_FOUND)

	find_package(Graphviz QUIET)
	if(Graphviz_FOUND)
		set(HAVE_DOT YES)
	else()
		MESSAGE(WARNING "${BoldYellow}Graphviz not found${ColourReset}")
		set(HAVE_DOT NO)
	endif()

	# condition tagfiles list
	STRING(REPLACE ";" " " DOX_TAGFILES1 "${DOX_TAGFILES}")

	SET(DOX_TAGFILES ${DOX_TAGFILES1})

	configure_file(
		"${CMakeHelper_INCLUDE_DIR}/CMakeHelper/doc/Doxyfile.in"
		${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
		@ONLY)

	#set(WORKDIR ${CMAKE_CURRENT_BINARY_DIR})
	set(WORKDIR ${PROJECT_SOURCE_DIR}/doc/${PROJECT_NAME}/doxygen)

	FILE(MAKE_DIRECTORY ${WORKDIR})

	#MESSAGE("list dir: ${CMAKE_CURRENT_LIST_DIR}")
	#MESSAGE("dox exe:  ${DOXYGEN_EXECUTABLE}")
	#MESSAGE("work dir: ${WORKDIR}")
	#MESSAGE("dox file: ${PROJECT_BINARY_DIR}/Doxyfile")

	# inform object projects that include this project via FIND_PACKAGE of the location of the .tag file
	SET(DOX_TAGFILE ${WORKDIR}/${PROJECT_NAME}.tag PARENT_SCOPE)

	add_custom_target(${PROJECT_NAME}_doc
		${DOXYGEN_EXECUTABLE} ${PROJECT_BINARY_DIR}/Doxyfile
		WORKING_DIRECTORY ${WORKDIR}
		COMMENT "Generating API documentation with Doxygen" VERBATIM)

else()
	MESSAGE(WARNING "${BoldYellow}Doxygen not found${ColourReset}")
endif()

ENDFUNCTION()









