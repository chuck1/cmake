cmake_minimum_required (VERSION 2.6)

project(CMakeHelper)

set(INSTALL_CMAKE_DIR $ENV{HOME}/usr/lib/cmake/${PROJECT_NAME})

install(FILES src/doc/Doxyfile.in			DESTINATION ${INSTALL_CMAKE_DIR}/doc)
install(FILES src/doc/doc.cmake				DESTINATION ${INSTALL_CMAKE_DIR}/doc)

install(FILES src/static/library.cmake			DESTINATION ${INSTALL_CMAKE_DIR}/static)
install(FILES src/static/libraryConfig.cmake.in		DESTINATION ${INSTALL_CMAKE_DIR}/static)
install(FILES src/static/libraryConfigVersion.cmake.in	DESTINATION ${INSTALL_CMAKE_DIR}/static)
install(FILES src/package.cmake				DESTINATION ${INSTALL_CMAKE_DIR})


