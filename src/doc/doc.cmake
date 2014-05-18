
# Doxygen
# =======
find_package(Doxygen)
if(DOXYGEN_FOUND)

	find_package(Graphviz)
	if(Graphviz_FOUND)
		set(HAVE_DOT YES)
	else()
		set(HAVE_DOT NO)
	endif()

	set(CMAKE_DOXYFILE_FILE "${CMAKE_HELPER_INSTALL_DIR}/doc/Doxyfile.in")
	
	configure_file(
		${CMAKE_DOXYFILE_FILE}
		${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
	
	set(WORKDIR ${CMAKE_CURRENT_BINARY_DIR})
	set(WORKDIR ${CMAKE_CURRENT_SOURCE_DIR})

	add_custom_target(doc
		${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
		WORKING_DIRECTORY ${WORKDIR}
		COMMENT "Generating API documentation with Doxygen" VERBATIM
		)


endif(DOXYGEN_FOUND)

