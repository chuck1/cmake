# Common methods for building static c++ libraries
INCLUDE(${CMakeHelper_INCLUDE_DIR}/CMakeHelper/functions.cmake)
include(${CMakeHelper_INCLUDE_DIR}/CMakeHelper/library/static/package.cmake)
include(${CMakeHelper_INCLUDE_DIR}/CMakeHelper/doc/doc.cmake)
include(${CMakeHelper_INCLUDE_DIR}/CMakeHelper/color.cmake)

#MESSAGE("CMAKE_BINARY_DIR      ${CMAKE_BINARY_DIR}")
#MESSAGE("CMAKE_FILES_DIRECTORY ${CMAKE_FILES_DIRECTORY}")
#MESSAGE("PROJECT_SOURCE_DIR    ${PROJECT_SOURCE_DIR}")
#MESSAGE("PROJECT_BINARY_DIR    ${PROJECT_BINARY_DIR}")

#set(CMakeHelper_INSTALL_PREFIX @CMAKE_INSTALL_PREFIX@)


#steps
# 1. cxx flags
# 2. configure .in files
# 3. set project include dirs


SET(GCC_MINIMUM 4.7)

FUNCTION(cmh_static_library)

	cmh_build_type()
	SET(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} PARENT_SCOPE)

	# Compiler-specific C++11 activation.
	if ("${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU")
		execute_process(
			COMMAND ${CMAKE_CXX_COMPILER} -dumpversion OUTPUT_VARIABLE GCC_VERSION)
		if (NOT (GCC_VERSION VERSION_GREATER ${GCC_MINIMUM} OR GCC_VERSION VERSION_EQUAL ${GCC_MINIMUM}))
			message(FATAL_ERROR "${PROJECT_NAME} requires g++ ${GCC_MINIMUM} or greater.")
		endif ()
	elseif ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++" PARENT_SCOPE)
	else ()
		message(FATAL_ERROR "Your C++ compiler does not support C++11.")
	endif ()
	
	set(CMAKE_CXX_FLAGS		"-std=c++0x -rdynamic -pthread -Wall -Wno-unknown-pragmas -Wno-unused-local-typedefs -fmax-errors=5" PARENT_SCOPE)
	set(CMAKE_CXX_FLAGS_DEBUG	"-O0 -g -pg -D_DEBUG -Wall -Werror" PARENT_SCOPE)
	set(CMAKE_CXX_FLAGS_RELEASE	"-O4 -DNDEBUG" PARENT_SCOPE)

	# messages
	MESSAGE(STATUS "${Blue}${ColourBold}Project:        ${PROJECT_NAME}${ColourReset}")
	MESSAGE(STATUS                     "install prefix: ${CMAKE_INSTALL_PREFIX}")
	#MESSAGE(STATUS                     "source dir:     ${PROJECT_SOURCE_DIR}")
	#MESSAGE(STATUS                     "binary dir:     ${PROJECT_BINARY_DIR}")
	#MESSAGE(STATUS                     "binary dir:     ${CMAKE_CURRENT_LIST_DIR}")
	MESSAGE(STATUS                     "build type:     ${CMAKE_BUILD_TYPE}")
	MESSAGE(STATUS                     "static library: ${PROJECT_NAME}")
	MESSAGE(STATUS                     "libs:           ${libs}")




	include_directories("${PROJECT_SOURCE_DIR}/include" "${PROJECT_BINARY_DIR}/include")
	
	cmh_doc()

	configure_glob("in")

	# Glob Source and Header Files
	# ============================

	file(GLOB_RECURSE SOURCES_ABS_CPP ${PROJECT_SOURCE_DIR}/src/*.cpp)
	file(GLOB_RECURSE SOURCES_ABS_CC ${PROJECT_SOURCE_DIR}/src/*.cc)
	set(SOURCES_ABS ${SOURCES_ABS_CC} ${SOURCES_ABS_CPP})

	foreach(s ${SOURCES_ABS})
		file(RELATIVE_PATH r ${PROJECT_SOURCE_DIR} ${s})
		set(SOURCES ${SOURCES} ${r})
	endforeach()

	add_library(${PROJECT_NAME} STATIC ${SOURCES})
	

	# install library
	install(
		TARGETS ${PROJECT_NAME}
		DESTINATION "${CMAKE_INSTALL_PREFIX}/lib"
		EXPORT ${PROJECT_NAME}Targets
		RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" COMPONENT bin
		LIBRARY DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" COMPONENT shlib
		PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_PREFIX}/include/${PROJECT_NAME}" COMPONENT dev
		)
	
	FOREACH(e ${include_extensions} hpp hh h glsl)
		install_glob_source("include" ${e})
	ENDFOREACH()
	FOREACH(e ${include_extensions} hpp hh h glsl)
		install_glob_binary("include" ${e})
	ENDFOREACH()

	cmh_package_static_library()

	# add this library to libs so that subsequent call to line_exe() links to this library
	LIST(APPEND libs_tmp ${PROJECT_NAME} ${libs})
	LIST(REMOVE_DUPLICATES libs_tmp)

	#MESSAGE(STATUS "libs_tmp ${libs_tmp}")
	
	SET(libs ${libs_tmp} PARENT_SCOPE)
ENDFUNCTION()



