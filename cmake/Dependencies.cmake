include(FetchContent)
include(${CMAKE_CURRENT_LIST_DIR}/FetchContentFast.cmake)

set(NOGGIT_FASTNOISE2_REPOSITORY "https://github.com/Auburn/FastNoise2.git")
set(NOGGIT_FASTNOISE2_TAG "v0.10.0-alpha")

function(noggit_ensure_fastnoise2)
  if(TARGET FastNoise)
    return()
  endif()

  find_package(FastNoise2 QUIET)
  if(FastNoise2_FOUND)
    return()
  endif()

  FetchContent_Declare(
    FastNoise2
    GIT_REPOSITORY ${NOGGIT_FASTNOISE2_REPOSITORY}
    GIT_TAG ${NOGGIT_FASTNOISE2_TAG}
  )

  noggit_fetchcontent_make_available(FastNoise2)
endfunction()
