@echo off
setlocal EnableDelayedExpansion

set "PATH=%~dp0;%PATH%"

:: Force npm to use its builtin node-gyp
set npm_config_node_gyp=

:: Find bundled npm under this package's node_modules,
:: or in a node_modules one level above this package
:: (for when apm is a dependency)
if exist "%~dp0\..\node_modules\.bin\npm.cmd" (
    "%~dp0\..\node_modules\.bin\npm.cmd" %*
) else if exist "%~dp0\..\..\.bin\npm.cmd" (
    "%~dp0\..\..\.bin\npm.cmd" %*
) else (
    rem "error: apm couldn't find its bundled npm."
    exit /B 2
)
