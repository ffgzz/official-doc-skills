param(
  [Parameter(Mandatory = $true)]
  [string]$FilePath
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:PYTHONIOENCODING = "utf-8"

python "$PSScriptRoot/style_check.py" $FilePath
exit $LASTEXITCODE
