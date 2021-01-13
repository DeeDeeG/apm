@echo off
setlocal EnableDelayedExpansion

set "PATH=%~dp0;%PATH%"

:: Force npm to use its builtin node-gyp
set npm_config_node_gyp=

echo Looking for npm at "%~dp0..\node_modules\.bin\npm.cmd"
if exist "%~dp0..\node_modules\.bin\npm.cmd" (
  echo Found npm at "%~dp0..\node_modules\.bin\npm.cmd"
  "%~dp0..\node_modules\.bin\npm.cmd" %*
) else (
  echo Looking for npm at "%~dp0..\..\..\node_modules\.bin\npm.cmd"
  if exist "%~dp0..\..\..\node_modules\.bin\npm.cmd" (
    echo Found npm at "%~dp0..\..\..\node_modules\.bin\npm.cmd"
    "%~dp0..\..\..\node_modules\.bin\npm.cmd" %*
  ) else (
    echo Couldn't find npm
  )
)