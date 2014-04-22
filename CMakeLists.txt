cmake_minimum_required (VERSION 2.6)

project(CMakeHelper)

set(INSTALL_CMAKE_DIR $ENV{HOME}/usr/lib/cmake/${PROJECT_NAME})

set(SL_FILES
	src/Doxyfile.in
	src/static_library.cmake
	src/static_libraryConfig.cmake.in
	src/static_libraryConfigVersion.cmake.in
	)


install(FILES ${SL_FILES}
	DESTINATION ${INSTALL_CMAKE_DIR}
	)

