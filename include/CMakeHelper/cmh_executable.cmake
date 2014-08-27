


INCLUDE(cmh_cpp_build)

SET(source_files)
cmh_file_glob_source(source_files)

ADD_EXECUTABLE(${PROJECT_NAME} ${source_files})

SET(libs_tmp ${libs} ${libs} ${libs})

TARGET_LINK_LIBRARIES(${PROJECT_NAME} ${libs_tmp})


