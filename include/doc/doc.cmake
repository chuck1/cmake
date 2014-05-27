# Doxygen
# =======

include(${CMAKE_HELPER_INSTALL_DIR}/color.cmake)

find_package(Doxygen QUIET)

if(Doxygen_FOUND)

	find_package(Graphviz QUIET)
	if(Graphviz_FOUND)
		set(HAVE_DOT YES)
	else()
		MESSAGE(WARNING "${BoldYellow}Graphviz not found${ColourReset}")
		set(HAVE_DOT NO)
	endif()

	set(CMAKE_DOXYFILE_FILE "${CMAKE_HELPER_INSTALL_DIR}/doc/Doxyfile.in")
	
	configure_file(
		${CMAKE_DOXYFILE_FILE}
		${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
	
	set(WORKDIR ${CMAKE_CURRENT_BINARY_DIR})
	set(WORKDIR ${CMAKE_CURRENT_LIST_DIR}/doc/${PROJECT_NAME}/doxygen)
	
	add_custom_target(doc
		${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
		WORKING_DIRECTORY ${WORKDIR}
		COMMENT "Generating API documentation with Doxygen" VERBATIM)

else()
	MESSAGE(WARNING "Doxygen not found")
endif()

