param(
  [Parameter(Mandatory = $true)]
  [string]$ProjectSlug,

  [string]$OutputFileName = "",

  [switch]$SkipMissing
)

function Read-Utf8Text {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Path
  )

  # Avoid host-dependent defaults: Windows PowerShell misreads UTF-8 without BOM.
  $utf8 = New-Object System.Text.UTF8Encoding($false, $true)
  $reader = New-Object System.IO.StreamReader($Path, $utf8, $true)
  try {
    return $reader.ReadToEnd()
  }
  finally {
    $reader.Dispose()
  }
}

function Write-Utf8Text {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [AllowEmptyString()]
    [string]$Content
  )

  # Write BOM for better compatibility with Windows PowerShell and common editors.
  $utf8 = New-Object System.Text.UTF8Encoding($true)
  [System.IO.File]::WriteAllText($Path, $Content, $utf8)
}

$templateDirName = "chapter-prompts"
$generationDirName = "generated-drafts"
$defaultOutputName = ([string]::Concat([char[]](0x5B8C, 0x6574, 0x6587, 0x7A3F))) + ".md"

if ([string]::IsNullOrWhiteSpace($OutputFileName)) {
  $OutputFileName = $defaultOutputName
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$templateRoot = Join-Path $repoRoot $templateDirName
$projectRoot = Join-Path (Join-Path $repoRoot $generationDirName) $ProjectSlug
$outputPath = Join-Path $projectRoot $OutputFileName

if (-not (Test-Path $templateRoot)) {
  throw "Template root not found: $templateRoot"
}

if (-not (Test-Path $projectRoot)) {
  throw "Generated project directory not found: $projectRoot"
}

$outputDir = Split-Path -Parent $outputPath
if (-not (Test-Path $outputDir)) {
  New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
}

$templateFiles = Get-ChildItem -Path $templateRoot -Recurse -File -Filter *.md |
  Where-Object { $_.Name -ne "README.md" } |
  Sort-Object FullName

$assembledParts = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

foreach ($templateFile in $templateFiles) {
  $relativePath = $templateFile.FullName.Substring($templateRoot.Length).TrimStart('\', '/')
  $generatedPath = Join-Path $projectRoot $relativePath

  if (-not (Test-Path $generatedPath)) {
    $message = "Missing generated file: $relativePath"
    if ($SkipMissing) {
      $warnings.Add($message) | Out-Null
      continue
    }
    throw $message
  }

  $content = Read-Utf8Text -Path $generatedPath
  if ([string]::IsNullOrWhiteSpace($content)) {
    $warnings.Add("Empty generated file skipped: $relativePath") | Out-Null
    continue
  }

  $assembledParts.Add($content.Trim()) | Out-Null
}

if ($assembledParts.Count -eq 0) {
  throw "No non-empty generated markdown files were found under: $projectRoot"
}

$assembledContent = $assembledParts -join "`r`n`r`n"
Write-Utf8Text -Path $outputPath -Content $assembledContent

Write-Host "Assembled markdown written to: $outputPath"
Write-Host "Content files included: $($assembledParts.Count)"

if ($warnings.Count -gt 0) {
  foreach ($warning in $warnings) {
    Write-Warning $warning
  }
}
