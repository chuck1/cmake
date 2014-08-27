
# Compiler-specific C++11 activation.
if ("${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU")
	execute_process(
		COMMAND ${CMAKE_CXX_COMPILER} -dumpversion OUTPUT_VARIABLE GCC_VERSION)
	if (NOT (GCC_VERSION VERSION_GREATER ${GCC_MINIMUM} OR GCC_VERSION VERSION_EQUAL ${GCC_MINIMUM}))
		message(FATAL_ERROR "${PROJECT_NAME} requires g++ ${GCC_MINIMUM} or greater.")
	endif ()
elseif ("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
else ()
	message(FATAL_ERROR "Your C++ compiler does not support C++11.")
endif ()

# flags
set(CMAKE_CXX_FLAGS		"-std=c++0x -rdynamic -pthread -Wall -Wno-unknown-pragmas -Wno-unused-local-typedefs -fmax-errors=5")
set(CMAKE_CXX_FLAGS_DEBUG	"-O0 -g -pg -D_DEBUG -Wall -Werror -Wno-unknown-pragmas -Wno-unused-local-typedefs -fmax-errors=5")
set(CMAKE_CXX_FLAGS_RELEASE	"-O4 -DNDEBUG")


# messages
#MESSAGE(STATUS           "bin dir:     ${project_binary_dir_relative}")
#MESSAGE(STATUS           "debug flags: ${CMAKE_CXX_FLAGS_DEBUG}")

include_directories("${PROJECT_SOURCE_DIR}/include" "${PROJECT_BINARY_DIR}/include")


