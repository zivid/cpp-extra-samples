option(WARNINGS "Enable compiler warnings" ON)

if(WARNINGS)
    option(WARNINGS_AS_ERRORS "Treat compiler warnings as errors" OFF)
endif()

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    if(WARNINGS)
        if(WARNINGS_AS_ERRORS)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")
        endif()
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Weverything")
    else()
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -w")
    endif()
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    if(WARNINGS)
        if(WARNINGS_AS_ERRORS)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")
        endif()
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")
    else()
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -w")
    endif()
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    if(WARNINGS)
        if(WARNINGS_AS_ERRORS)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /WX")
        endif()

        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Wall")
    else()
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /w")
    endif()
else()
    message(FATAL_ERROR "Unknown compiler: ${CMAKE_CXX_COMPILER_ID}")
endif()
