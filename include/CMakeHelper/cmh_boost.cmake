
IF(${STATIC})
	unset(Boost_INCLUDE_DIR CACHE)
	unset(Boost_LIBRARY_DIRS CACHE)
	unset(Boost_LIBRARIES CACHE)

	set(Boost_USE_STATIC_LIBS ON)
	set(Boost_USE_STATIC_RUNTIME ON)
ELSEIF(${SHARED})
	unset(Boost_INCLUDE_DIR CACHE)
	unset(Boost_LIBRARY_DIRS CACHE)
	unset(Boost_LIBRARIES CACHE)

	set(Boost_USE_STATIC_LIBS OFF)
	set(Boost_USE_STATIC_RUNTIME OFF)
	add_definitions(-DBOOST_ALL_DYN_LINK)
ENDIF()

