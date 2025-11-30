include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)

function(_noggit_flag_cache_key language flag out_var)
  string(REGEX REPLACE "[^A-Za-z0-9]" "_" _sanitized "${flag}")
  string(TOUPPER "${language}" _lang_upper)
  set(${out_var} "NOGGIT_${_lang_upper}_FLAG_${_sanitized}" PARENT_SCOPE)
endfunction()

function(noggit_target_flag_if_supported target language flag)
  _noggit_flag_cache_key(${language} "${flag}" _cache_var)
  if(NOT DEFINED ${_cache_var})
    if(language STREQUAL "CXX")
      check_cxx_compiler_flag("${flag}" ${_cache_var})
    else()
      check_c_compiler_flag("${flag}" ${_cache_var})
    endif()
  endif()

  if(${${_cache_var}})
    target_compile_options(${target} PRIVATE $<$<COMPILE_LANGUAGE:${language}>:${flag}>)
  endif()
endfunction()

function(noggit_target_flags_if_supported target language)
  foreach(flag IN LISTS ARGN)
    if(flag)
      noggit_target_flag_if_supported(${target} ${language} "${flag}")
    endif()
  endforeach()
endfunction()

function(noggit_apply_common_compile_options target)
  target_compile_features(${target} PRIVATE cxx_std_20)

  set(_cxx_suppressed_warnings
    -Wno-c++98-compat
    -Wno-c++98-compat-pedantic
    -Wno-gnu-anonymous-struct
    -Wno-variadic-macros
    -Wno-vla
    -Wno-vla-extension
    -Wno-zero-length-array
    -Wno-gnu-zero-variadic-macro-arguments
    -Wno-nested-anon-types
    -Wno-four-char-constants
    -Wno-exit-time-destructors
    -Wno-global-constructors
    -Wno-disabled-macro-expansion
    -Wno-weak-vtables
    -Wno-weak-template-vtables
    -Wno-date-time
    -Wno-padded
    -Werror=mismatched-tags
    -Wno-multichar
  )

  noggit_target_flags_if_supported(${target} CXX "${_cxx_suppressed_warnings}")
  noggit_target_flags_if_supported(${target} C "-Wno-implicit-function-declaration")

  if(MSVC)
    set(_msvc_warnings
      /we4099
      /EHa
      /MP
      /bigobj
    )
    noggit_target_flags_if_supported(${target} CXX "${_msvc_warnings}")
  endif()
endfunction()

function(noggit_enable_name_reuse_errors target)
  if(MSVC)
    noggit_target_flags_if_supported(${target} CXX "/we4456" "/we4457" "/we4458" "/we4459")
  endif()
endfunction()

function(noggit_enable_additional_msvc_optimizations target)
  if(MSVC)
    noggit_target_flags_if_supported(${target} CXX "/Ob2" "/Oi" "/Ot" "/GL")
  endif()
endfunction()

function(noggit_enable_all_warnings target)
  if(MSVC)
    noggit_target_flags_if_supported(${target} CXX "/W4")
  else()
    noggit_target_flags_if_supported(${target} CXX "-Wall" "-Wextra")
  endif()
endfunction()

function(noggit_enable_warnings_as_errors target)
  if(MSVC)
    noggit_target_flags_if_supported(${target} CXX "/WX")
  else()
    noggit_target_flags_if_supported(${target} CXX "-Werror")
  endif()
endfunction()
