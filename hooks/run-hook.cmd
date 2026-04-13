\
@echo off
setlocal
set "SCRIPT_DIR=%~dp0"
set "PS1_FILE=%SCRIPT_DIR%session-start.ps1"

if not exist "%PS1_FILE%" (
  echo {"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"公文项目写作助手已加载，但入口 hook 脚本缺失。请优先调用 official-doc-writing-skill:using-official-docs。"}}
  exit /b 0
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1_FILE%" %*
exit /b %ERRORLEVEL%
