

#MESSAGE(STATUS                     "install prefix: ${CMAKE_INSTALL_PREFIX}")
#MESSAGE(STATUS                     "source dir:     ${PROJECT_SOURCE_DIR}")
#MESSAGE(STATUS                     "binary dir:     ${PROJECT_BINARY_DIR}")
#MESSAGE(STATUS                     "binary dir:     ${CMAKE_CURRENT_LIST_DIR}")

INCLUDE(cmh_cpp_build)

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



#MESSAGE(STATUS "libs:           ${libs}")

if(${SHARED})
	add_library(${PROJECT_NAME} SHARED ${SOURCES})
	MESSAGE(STATUS "linking: ${shared_libs}")
	target_link_libraries(${PROJECT_NAME} ${shared_libs})
else()
	add_library(${PROJECT_NAME} STATIC ${SOURCES})
endif()

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




get_property(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
foreach(dir ${dirs})
	#message(STATUS "dir='${dir}'")
endforeach()
SET(${PROJECT_NAME}_INCLUDE_DIRS ${dirs})

INCLUDE(cmh_library_package)


# add this library to libs so that subsequent call to line_exe() links to this library
LIST(APPEND shared_libs ${PROJECT_NAME}.so)
LIST(REMOVE_DUPLICATES shared_libs)

LIST(APPEND static_libs ${PROJECT_NAME}.a)
LIST(REMOVE_DUPLICATES static_libs)

MESSAGE(STATUS "shared_libs: ${shared_libs}")
MESSAGE(STATUS "static_libs: ${static_libs}")



