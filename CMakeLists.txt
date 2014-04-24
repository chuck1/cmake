cmake_minimum_required (VERSION 2.6)

project(CMakeHelper)

set(INSTALL_CMAKE_DIR $ENV{HOME}/usr/lib/cmake/${PROJECT_NAME})

set(SL_FILES
	src/doc/Doxyfile.in
	src/static/library.cmake
	src/static/libraryConfig.cmake.in
	src/static/libraryConfigVersion.cmake.in
	src/package.cmake
	)


install(FILES ${SL_FILES}
	DESTINATION ${INSTALL_CMAKE_DIR}
	)

