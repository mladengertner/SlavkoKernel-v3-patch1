$ErrorActionPreference = "Stop"
$MODEL_LOCAL = "slavkokernel-v3"

function Ensure-Ollama {
  if (-not (Get-Command ollama -ErrorAction SilentlyContinue)) {
    Write-Host "[setup] Installing Ollama…"
    # Preporuka: instaliraj kroz winget (Windows 11) ili MSI
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id Ollama.Ollama -e --source winget
    } else {
      Write-Host "Otvorite https://ollama.com/download i instalirajte MSI pa ponovno pokrenite ovu skriptu."
      exit 1
    }
  }
}

function Create-Model {
  Write-Host "[create] Building local model: $MODEL_LOCAL"
  ollama create $MODEL_LOCAL -f Modelfile
}

function Verify-Checksums {
  Write-Host "[verify] Generating checksums"
  # Generate SHA256 of files (PowerShell way)
  $files = @("Modelfile") + (Get-ChildItem -Path "replay_tests" -File -Recurse | Select-Object -ExpandProperty FullName)
  $lines = foreach ($f in $files) {
    $hash = (Get-FileHash -Algorithm SHA256 -Path $f).Hash.ToLower()
    $rel = Resolve-Path -Relative $f
    "$hash $rel"
  }
  Set-Content -Encoding UTF8 -Path "checksums.txt" -Value ($lines -join "`n")

  if (Test-Path "expected_checksums.txt" -and (Get-Content expected_checksums.txt | Where-Object { $_ -match '^\w{64}\s' })) {
    Write-Host "[verify] Comparing with expected checksums"
    $diff = Compare-Object (Get-Content checksums.txt) (Get-Content expected_checksums.txt)
    if ($diff) {
      Write-Host "[verify] Differences found:" -ForegroundColor Yellow
      $diff | Format-Table | Out-Host
      throw "Checksum mismatch"
    } else {
      Write-Host "[verify] Checksums match."
    }
  } else {
    Write-Host "[verify] Bootstrapping expected_checksums.txt"
    Copy-Item checksums.txt expected_checksums.txt -Force
  }
}

function Run-ReplayTests {
  Write-Host "[test] Running replay tests"
  & ".\replay_tests\run_all.ps1"
}

function Start-Kernel {
  Write-Host "[run] Starting kernel"
  ollama run $MODEL_LOCAL
}

Ensure-Ollama
Create-Model
Verify-Checksums
Run-ReplayTests
Start-Kernel
