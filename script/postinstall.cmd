@echo off
setlocal EnableDelayedExpansion
setlocal EnableExtensions

:: Skip the postinstall script if we're already rebuilding,
:: to avoid an endless, recursive postinstall loop.
if defined APM_ALREADY_REBUILDING (
  echo ^>^> Postinstall script is already being run. Skipping recursive call.
  exit 0
)

echo ^>^> Downloading bundled Node
node .\script\download-node.js

echo.
for /f "delims=" %%i in ('.\bin\node.exe -p "process.version + ' ' + process.arch"') do set bundledVersion=%%i
echo ^>^> Rebuilding apm dependencies with bundled Node !bundledVersion!
set APM_ALREADY_REBUILDING=true
call .\bin\npm.cmd rebuild

if defined NO_APM_DEDUPE (
    echo.
    echo ^>^> Deduplication disabled
) else (
    echo.
    echo ^>^> Deduping apm dependencies
    call .\bin\npm.cmd dedupe
)