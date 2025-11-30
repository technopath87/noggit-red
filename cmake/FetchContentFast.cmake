include(FetchContent)

option(FAST_BUILD_FETCHCONTENT "Skip FetchContent check when existing source directories are available" OFF)

function(noggit_fetchcontent_make_available name)
  FetchContent_GetProperties(${name})

  if(FAST_BUILD_FETCHCONTENT AND NOT ${name}_POPULATED)
    if(DEFINED ${name}_SOURCE_DIR AND EXISTS "${${name}_SOURCE_DIR}")
      message(STATUS "Reusing existing source directory for ${name}: ${${name}_SOURCE_DIR}")
      if(NOT DEFINED ${name}_BINARY_DIR)
        set(${name}_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/${name}-build")
      endif()
      add_subdirectory("${${name}_SOURCE_DIR}" "${${name}_BINARY_DIR}")
      return()
    endif()
  endif()

  if(NOT ${name}_POPULATED)
    FetchContent_MakeAvailable(${name})
  elseif(NOT TARGET ${name})
    FetchContent_MakeAvailable(${name})
  endif()
endfunction()
