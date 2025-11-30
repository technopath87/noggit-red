function(windeployqt target)
  if(NOT WIN32)
    return()
  endif()

  find_program(WINDEPLOYQT_EXECUTABLE
    NAMES windeployqt windeployqt.exe
    HINTS "$ENV{Qt5_DIR}" "$ENV{QTDIR}" "$ENV{QT_ROOT}"
    PATH_SUFFIXES bin
  )

  if(NOT WINDEPLOYQT_EXECUTABLE)
    message(WARNING "windeployqt executable not found; skipping Qt runtime deployment for ${target}.")
    return()
  endif()

  add_custom_command(TARGET ${target} POST_BUILD
    COMMAND "${WINDEPLOYQT_EXECUTABLE}" --no-translations "$<TARGET_FILE:${target}>"
    COMMENT "Deploying Qt runtime for ${target}"
  )
endfunction()
