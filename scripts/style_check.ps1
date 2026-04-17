param(
  [Parameter(Mandatory = $true)]
  [string]$FilePath
)

python "$PSScriptRoot/style_check.py" $FilePath
