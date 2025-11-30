cmake_minimum_required(VERSION 3.20)

if(NOT DEFINED _noggit_revision_template_file OR NOT DEFINED _noggit_revision_output_file)
  message(FATAL_ERROR "GenerateRevision.cmake requires template and output paths to be set.")
endif()

if(NOT DEFINED _noggit_revision_state_file)
  set(_noggit_revision_state_file "")
endif()

if(NOT DEFINED GIT_EXECUTABLE)
  message(FATAL_ERROR "GIT_EXECUTABLE must be provided to GenerateRevision.cmake")
endif()

execute_process(
  COMMAND ${GIT_EXECUTABLE} describe --always --dirty --long --tags
  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/.."
  OUTPUT_VARIABLE _noggit_git_version
  OUTPUT_STRIP_TRAILING_WHITESPACE
  ERROR_QUIET
)

if(NOT _noggit_git_version)
  set(_noggit_git_version "unknown")
endif()

set(_previous_state "")
if(_noggit_revision_state_file AND EXISTS "${_noggit_revision_state_file}")
  file(READ "${_noggit_revision_state_file}" _previous_state)
endif()

if(NOT _previous_state STREQUAL _noggit_git_version)
  get_filename_component(_output_dir "${_noggit_revision_output_file}" DIRECTORY)
  if(NOT IS_DIRECTORY "${_output_dir}")
    file(MAKE_DIRECTORY "${_output_dir}")
  endif()

  set(NOGGIT_GIT_VERSION_STRING "${_noggit_git_version}")
  configure_file("${_noggit_revision_template_file}" "${_noggit_revision_output_file}" @ONLY)

  if(_noggit_revision_state_file)
    file(WRITE "${_noggit_revision_state_file}" "${_noggit_git_version}")
  endif()
endif()
