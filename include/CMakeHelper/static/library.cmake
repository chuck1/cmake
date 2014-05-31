# Common methods for building static c++ libraries

include(${CMakeHelper_INCLUDE_DIR}/CMakeHelper/package.cmake)

#MESSAGE("CMAKE_BINARY_DIR      ${CMAKE_BINARY_DIR}")
#MESSAGE("CMAKE_FILES_DIRECTORY ${CMAKE_FILES_DIRECTORY}")
#MESSAGE("PROJECT_SOURCE_DIR    ${PROJECT_SOURCE_DIR}")
#MESSAGE("PROJECT_BINARY_DIR    ${PROJECT_BINARY_DIR}")

#set(CMakeHelper_INSTALL_PREFIX @CMAKE_INSTALL_PREFIX@)


#steps
# 1. cxx flags
# 2. configure .in files
# 3. set project include dirs




FUNCTION(cmh_static_library)

	MESSAGE(STATUS "setup static library: ${PROJECT_NAME}")


	# Initialize CXXFLAGS.
	set(CMAKE_CXX_FLAGS                "-Wall -std=c++11" PARENT_SCOPE)
	set(CMAKE_CXX_FLAGS_DEBUG          "-O0 -g" PARENT_SCOPE)
	set(CMAKE_CXX_FLAGS_MINSIZEREL     "-Os -DNDEBUG" PARENT_SCOPE)
	set(CMAKE_CXX_FLAGS_RELEASE        "-O4 -DNDEBUG" PARENT_SCOPE)
	set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g" PARENT_SCOPE)

	# Compiler-specific C++11 activation.
	if ("${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU")
		execute_process(
			COMMAND ${CMAKE_CXX_COMPILER} -dumpversion OUTPUT_VARIABLE GCC_VERSION)
		if (NOT (GCC_VERSION VERSION_GREATER 4.7 OR GCC_VERSION VERSION_EQUAL 4.7))
			message(FATAL_ERROR "${PROJECT_NAME} requires g++ 4.7 or greater.")
		endif ()
	elseif ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++" PARENT_SCOPE)
	else ()
		message(FATAL_ERROR "Your C++ compiler does not support C++11.")
	endif ()



	INCLUDE(${CMakeHelper_INCLUDE_DIR}/CMakeHelper/functions.cmake)

	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -std=c++0x -Werror -Wall -Wno-unknown-pragmas -Wno-unused-local-typedefs -rdynamic -pthread -fmax-errors=5")

	set(CMAKE_INSTALL_PREFIX $ENV{HOME}/usr PARENT_SCOPE)

	#set(INSTALL_CMAKE_DIR   ${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME})

	include_directories("${PROJECT_SOURCE_DIR}/include" "${PROJECT_BINARY_DIR}/include")

	include(${CMakeHelper_INCLUDE_DIR}/CMakeHelper/doc/doc.cmake)

	configure_glob("in")

	install(
		FILES ${PROJECT_BINARY_DIR}/src/${PROJECT_NAME}/config.hpp
		DESTINATION include/${PROJECT_NAME})

	# Glob Source and Header Files
	# ============================

	file(GLOB_RECURSE SOURCES_ABS_CPP ${PROJECT_SOURCE_DIR}/src/*.cpp)
	file(GLOB_RECURSE SOURCES_ABS_CC ${PROJECT_SOURCE_DIR}/src/*.cc)
	set(SOURCES_ABS ${SOURCES_ABS_CC} ${SOURCES_ABS_CPP})

	foreach(s ${SOURCES_ABS})
		file(RELATIVE_PATH r ${PROJECT_SOURCE_DIR} ${s})
		set(SOURCES ${SOURCES} ${r})

		#MESSAGE("${s} ${PROJECT_SOURCE_DIR} ${r}")	
	endforeach()
	#MESSAGE("${SOURCES}")



	#set(CMAKE_CPP_CREATE_STATIC_LIBRARY on)

	add_library(${PROJECT_NAME} STATIC ${SOURCES})

	#SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE CPP)


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

	cmh_package()


ENDFUNCTION()



