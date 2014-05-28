# Doxygen
# =======

include(${CMakeHelper_INCLUDE_DIR}/CMakeHelper/color.cmake)

find_package(Doxygen REQUIRED)

if(DOXYGEN_FOUND)

	find_package(Graphviz QUIET)
	if(Graphviz_FOUND)
		set(HAVE_DOT YES)
	else()
		MESSAGE(WARNING "${BoldYellow}Graphviz not found${ColourReset}")
		set(HAVE_DOT NO)
	endif()

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


	add_custom_target(doc
		${DOXYGEN_EXECUTABLE} ${PROJECT_BINARY_DIR}/Doxyfile
		WORKING_DIRECTORY ${WORKDIR}
		COMMENT "Generating API documentation with Doxygen" VERBATIM)

else()
	MESSAGE(WARNING "${BoldYellow}Doxygen not found${ColourReset}")
endif()

