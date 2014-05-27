cmake_minimum_required (VERSION 2.6)

PROJECT(CMakeHelper)

include(${PROJECT_SOURCE_DIR}/src/functions.cmake)


set(INSTALL_CMAKE_DIR $ENV{HOME}/usr/lib/cmake/${PROJECT_NAME})

dot_glob(pdf)

configure_glob()

install(FILES src/doc/Doxyfile.in			DESTINATION ${INSTALL_CMAKE_DIR}/doc)
install(FILES src/doc/doc.cmake				DESTINATION ${INSTALL_CMAKE_DIR}/doc)

install(FILES src/static/library.cmake			DESTINATION ${INSTALL_CMAKE_DIR}/static)
install(FILES src/static/libraryConfig.cmake.in		DESTINATION ${INSTALL_CMAKE_DIR}/static)
install(FILES src/static/libraryConfigVersion.cmake.in	DESTINATION ${INSTALL_CMAKE_DIR}/static)
install(FILES src/package.cmake				DESTINATION ${INSTALL_CMAKE_DIR})
install(FILES src/color.cmake				DESTINATION ${INSTALL_CMAKE_DIR})
install(FILES src/functions.cmake			DESTINATION ${INSTALL_CMAKE_DIR})


