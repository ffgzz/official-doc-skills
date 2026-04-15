@echo off
setlocal
set "SCRIPT_DIR=%~dp0"
set "PS1_FILE=%SCRIPT_DIR%session-start.ps1"

if not exist "%PS1_FILE%" (
  echo {"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"official-doc-writing-skill loaded. Prefer official-doc-writing-skill:using-official-docs."}}
  exit /b 0
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1_FILE%" %*
exit /b %ERRORLEVEL%
