# Common methods for building static c++ libraries


#MESSAGE("CMAKE_BINARY_DIR      ${CMAKE_BINARY_DIR}")
#MESSAGE("CMAKE_FILES_DIRECTORY ${CMAKE_FILES_DIRECTORY}")
#MESSAGE("PROJECT_SOURCE_DIR    ${PROJECT_SOURCE_DIR}")
#MESSAGE("PROJECT_BINARY_DIR    ${PROJECT_BINARY_DIR}")
#MESSAGE("INSTALL_BIN_DIR       ${INSTALL_BIN_DIR}")
#MESSAGE("INSTALL_LIB_DIR       ${INSTALL_LIB_DIR}")

set(CMAKE_HELPER_INSTALL_DIR $ENV{HOME}/usr/lib/cmake/CMakeHelper)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -std=c++0x -Werror -Wall -Wno-unknown-pragmas -Wno-unused-local-typedefs -rdynamic -pthread")

string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

set(CMAKE_INSTALL_PREFIX $ENV{HOME}/usr)

set(INSTALL_LIB_DIR     ${CMAKE_INSTALL_PREFIX}/lib)
set(INSTALL_BIN_DIR     ${CMAKE_INSTALL_PREFIX}/bin)
set(INSTALL_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include/${PROJECT_NAME})
set(INSTALL_CMAKE_DIR   ${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME})


include_directories("${PROJECT_SOURCE_DIR}/src" "${PROJECT_BINARY_DIR}/src")


# Make relative paths absolute (needed later on)
foreach(p LIB BIN INCLUDE CMAKE)
	set(var INSTALL_${p}_DIR)
	if(NOT IS_ABSOLUTE "${${var}}")
		set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
	endif()
endforeach()


include(${CMAKE_HELPER_INSTALL_DIR}/doc/doc.cmake)


# Global Library Configuration Header
configure_file(
	"${PROJECT_SOURCE_DIR}/src/${PROJECT_NAME}/config.hpp.in"
	"${PROJECT_BINARY_DIR}/src/${PROJECT_NAME}/config.hpp")

install(
	FILES ${PROJECT_BINARY_DIR}/src/${PROJECT_NAME}/config.hpp
	DESTINATION include/${PROJECT_NAME})

# Glob Source and Header Files
# ============================

file(GLOB_RECURSE SOURCES_ABS ${PROJECT_SOURCE_DIR}/src/*.cpp)
foreach(s ${SOURCES_ABS})
	file(RELATIVE_PATH r ${PROJECT_SOURCE_DIR} ${s})
	set(SOURCES ${SOURCES} ${r})

	#MESSAGE("${s} ${PROJECT_SOURCE_DIR} ${r}")	
endforeach()
#MESSAGE("${SOURCES}")


set(INCLUDE_EXTENSIONS ${INCLUDE_EXTENSIONS} hpp glsl)
foreach(e ${INCLUDE_EXTENSIONS})
	file(GLOB_RECURSE f ${PROJECT_SOURCE_DIR}/src/*.${e})
	set(HEADERS_ABS ${HEADERS_ABS} ${f})
endforeach()

foreach(s ${HEADERS_ABS})
	file(RELATIVE_PATH r ${PROJECT_SOURCE_DIR}/src ${s})
	set(HEADERS ${HEADERS} ${r})
	
	#MESSAGE("${s} ${PROJECT_SOURCE_DIR}/src ${r}")
endforeach()
#MESSAGE("${HEADERS}")


add_library(${PROJECT_NAME} STATIC ${SOURCES})

# install library
install(
	TARGETS ${PROJECT_NAME}
	DESTINATION "${INSTALL_LIB_DIR}"
	EXPORT ${PROJECT_NAME}Targets
	RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin
	LIBRARY DESTINATION "${INSTALL_LIB_DIR}" COMPONENT shlib
	PUBLIC_HEADER DESTINATION "${INSTALL_INCLUDE_DIR}/${PROJECT_NAME}" COMPONENT dev
)

# install headers
foreach(h ${HEADERS})
	get_filename_component(f ${h} PATH)
	#MESSAGE("${h} ${f}")
	install(FILES ${PROJECT_SOURCE_DIR}/src/${h} DESTINATION include/${f})
endforeach()




# Config
# uses:
#	INSTALL_CMAKE_DIR
#	INSTALL_INCLUDE_DIR
include(${CMAKE_HELPER_INSTALL_DIR}/package.cmake)






