param(
  [Parameter(Mandatory = $true)]
  [string]$ProjectSlug,

  [switch]$Force
)

$templateDirName = "chapter-prompts"
$generationDirName = "generated-drafts"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$templateRoot = Join-Path $repoRoot $templateDirName
$generationRoot = Join-Path $repoRoot $generationDirName
$projectRoot = Join-Path $generationRoot $ProjectSlug

if (-not (Test-Path $templateRoot)) {
  throw "Template root not found: $templateRoot"
}

New-Item -ItemType Directory -Force -Path $generationRoot | Out-Null
New-Item -ItemType Directory -Force -Path $projectRoot | Out-Null

$createdDirs = New-Object System.Collections.Generic.List[string]
$createdFiles = New-Object System.Collections.Generic.List[string]
$copiedReadmes = New-Object System.Collections.Generic.List[string]

$items = Get-ChildItem -Path $templateRoot -Recurse -Force | Sort-Object FullName
foreach ($item in $items) {
  $relativePath = $item.FullName.Substring($templateRoot.Length).TrimStart('\', '/')
  if (-not $relativePath) {
    continue
  }

  $targetPath = Join-Path $projectRoot $relativePath

  if ($item.PSIsContainer) {
    if (-not (Test-Path $targetPath)) {
      New-Item -ItemType Directory -Force -Path $targetPath | Out-Null
      $createdDirs.Add($relativePath) | Out-Null
    } else {
      New-Item -ItemType Directory -Force -Path $targetPath | Out-Null
    }
    continue
  }

  $targetDir = Split-Path -Parent $targetPath
  if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
  }

  if ($item.Name -eq "README.md") {
    if ($Force -or -not (Test-Path $targetPath)) {
      Copy-Item -LiteralPath $item.FullName -Destination $targetPath -Force
      $copiedReadmes.Add($relativePath) | Out-Null
    }
    continue
  }

  if ($Force -or -not (Test-Path $targetPath)) {
    Set-Content -Path $targetPath -Value $null -Encoding UTF8
    $createdFiles.Add($relativePath) | Out-Null
  }
}

Write-Host "Generation tree initialized at: $projectRoot"
Write-Host "Created directories: $($createdDirs.Count)"
Write-Host "Created files: $($createdFiles.Count)"
Write-Host "Copied README files: $($copiedReadmes.Count)"
