# Common methods for building static c++ libraries

# Global Library Configuration Header
configure_file(
	"${PROJECT_SOURCE_DIR}/${LIB_NAME}/config.hpp.in"
	"${PROJECT_SOURCE_DIR}/${LIB_NAME}/config.hpp")

# Glob Source and Header Files
# ============================



file(GLOB_RECURSE SOURCES_ABS ${PROJECT_SOURCE_DIR}/*.cpp)
foreach(s ${SOURCES_ABS})
	#MESSAGE("${s} ${CMAKE_SOURCE_DIR}${PROJECT_SOURCE_DIR}")	
	file(RELATIVE_PATH s ${CMAKE_SOURCE_DIR} ${s})
	set(SOURCES ${SOURCES} ${s})
endforeach()
#MESSAGE("${SOURCES}")



file(GLOB_RECURSE FILES_HPP_ABS ${PROJECT_SOURCE_DIR}/*.hpp)
file(GLOB_RECURSE FILES_GLSL_ABS ${PROJECT_SOURCE_DIR}/*.glsl)

set(HEADERS_ABS ${FILES_HPP_ABS} ${FILES_GLSL_ABS})

foreach(s ${HEADERS_ABS})
	#MESSAGE("${s} ${CMAKE_SOURCE_DIR}${PROJECT_SOURCE_DIR}")	
	file(RELATIVE_PATH s ${CMAKE_SOURCE_DIR}/${PROJECT_SOURCE_DIR} ${s})
	set(HEADERS ${HEADERS} ${s})
endforeach()
#MESSAGE("${HEADERS}")


add_library(${LIB_NAME} ${SOURCES})

# install library
install(
	TARGETS ${LIB_NAME}
	DESTINATION "${INSTALL_LIB_DIR}"
	EXPORT ${PROJECT_name}Targets
	RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin
	LIBRARY DESTINATION "${INSTALL_LIB_DIR}" COMPONENT shlib
	PUBLIC_HEADER DESTINATION "${INSTALL_INCLUDE_DIR}/${LIB_NAME}" COMPONENT dev
)

# install headers
foreach(h ${HEADERS})
	get_filename_component(f ${h} PATH)
	#MESSAGE("${h} ${f}")
	install(FILES ${PROJECT_SOURCE_DIR}/${h} DESTINATION include/${f})
endforeach()



