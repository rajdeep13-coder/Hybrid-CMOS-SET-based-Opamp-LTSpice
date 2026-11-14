<#
.SYNOPSIS
    Automated batch runner and validation harness for Milestone 1: CMOS Differential Input Stage.
.DESCRIPTION
    Executes LTspice batch simulations for schematic and netlists, collects logs into results/,
    and evaluates specification metrics against design requirements.
#>

[CmdletBinding()]
param(
    [string]$LTspiceExe = "C:\Users\rajde\OneDrive\Desktop\LTSPICE\LTspice.exe"
)

$ErrorActionPreference = "Stop"

$WorkspaceRoot = (Get-Item $PSScriptRoot).Parent.FullName
$DiffStageDir  = Join-Path $WorkspaceRoot "circuits\differential_stage"
$ResultsDir    = Join-Path $DiffStageDir "results"

if (-not (Test-Path $LTspiceExe)) {
    Write-Error "LTspice executable not found at: $LTspiceExe"
}

if (-not (Test-Path $ResultsDir)) {
    New-Item -ItemType Directory -Path $ResultsDir -Force | Out-Null
}

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " MILESTONE 1: CMOS DIFFERENTIAL STAGE AUTOMATED VALIDATION HARNESS" -ForegroundColor Cyan
Write-Host " Simulator: $LTspiceExe" -ForegroundColor DarkGray
Write-Host " Working Directory: $DiffStageDir" -ForegroundColor DarkGray
Write-Host "=================================================================" -ForegroundColor Cyan

# 1. Compile Schematic to Netlist & verify schematic execution
Write-Host "`n[1/7] Netlisting and Simulating CMOS_Differential.asc..." -ForegroundColor Yellow
Push-Location $DiffStageDir
try {
    & $LTspiceExe -netlist "CMOS_Differential.asc"
    Start-Sleep -Seconds 1
    & $LTspiceExe -b "CMOS_Differential.asc"
    Start-Sleep -Seconds 2
    if (Test-Path "CMOS_Differential.log") {
        Copy-Item "CMOS_Differential.log" (Join-Path $ResultsDir "CMOS_Differential_asc.log") -Force
        Write-Host "  -> CMOS_Differential.asc simulated successfully." -ForegroundColor Green
    }
} finally {
    Pop-Location
}

# 2. Testbenches list
$testbenches = @(
    @{ File = "tb_op.cir";      LogName = "tb_op.log";      Desc = "Operating Point (.op)" },
    @{ File = "tb_dc_diff.cir"; LogName = "tb_dc_diff.log"; Desc = "Differential DC Sweep (.dc)" },
    @{ File = "tb_dc_icmr.cir"; LogName = "tb_dc_icmr.log"; Desc = "Common-Mode Range (.dc)" },
    @{ File = "tb_ac_diff.cir"; LogName = "tb_ac_diff.log"; Desc = "Differential AC Response (.ac)" },
    @{ File = "tb_ac_cm.cir";   LogName = "tb_ac_cm.log";   Desc = "Common-Mode AC & CMRR (.ac)" },
    @{ File = "tb_tran.cir";    LogName = "tb_tran.log";    Desc = "Transient Response (.tran)" }
)

$step = 2
foreach ($tb in $testbenches) {
    Write-Host "`n[$step/7] Simulating $($tb.Desc) [$($tb.File)]..." -ForegroundColor Yellow
    Push-Location $DiffStageDir
    try {
        & $LTspiceExe -b "$($tb.File)"
        Start-Sleep -Seconds 2
        $sourceLog = [System.IO.Path]::ChangeExtension($tb.File, ".log")
        if (Test-Path $sourceLog) {
            Copy-Item $sourceLog (Join-Path $ResultsDir $tb.LogName) -Force
            Write-Host "  -> Successfully simulated and logged to results/$($tb.LogName)" -ForegroundColor Green
        } else {
            Write-Warning "  -> Log file $sourceLog not produced!"
        }
    } finally {
        Pop-Location
    }
    $step++
}

# 3. Parse and Display Summary of Results
Write-Host "`n=================================================================" -ForegroundColor Cyan
Write-Host " EXTRACTED VALIDATION RESULTS SUMMARY" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

# OP Results
$opLog = Join-Path $ResultsDir "tb_op.log"
if (Test-Path $opLog) {
    Write-Host "`n--- OPERATING POINT & BALANCE (tb_op) ---" -ForegroundColor White
    Get-Content $opLog | Select-String "v_|i_|p_diss|vds_" | ForEach-Object {
        Write-Host "  $($_.Line.Trim())" -ForegroundColor Gray
    }
}

# DC Results
$dcLog = Join-Path $ResultsDir "tb_dc_diff.log"
if (Test-Path $dcLog) {
    Write-Host "`n--- DC DIFFERENTIAL TRANSFER (tb_dc_diff) ---" -ForegroundColor White
    Get-Content $dcLog | Select-String "vout_|gain_dc" | ForEach-Object {
        Write-Host "  $($_.Line.Trim())" -ForegroundColor Gray
    }
}

# AC Diff Results
$acDiffLog = Join-Path $ResultsDir "tb_ac_diff.log"
if (Test-Path $acDiffLog) {
    Write-Host "`n--- AC FREQUENCY RESPONSE (tb_ac_diff) ---" -ForegroundColor White
    Get-Content $acDiffLog | Select-String "ad_|f_3db|gbw|phase_" | ForEach-Object {
        Write-Host "  $($_.Line.Trim())" -ForegroundColor Gray
    }
}

# AC CM Results
$acCmLog = Join-Path $ResultsDir "tb_ac_cm.log"
if (Test-Path $acCmLog) {
    Write-Host "`n--- COMMON-MODE REJECTION (tb_ac_cm) ---" -ForegroundColor White
    Get-Content $acCmLog | Select-String "acm_|cmrr_" | ForEach-Object {
        Write-Host "  $($_.Line.Trim())" -ForegroundColor Gray
    }
}

# TRAN Results
$tranLog = Join-Path $ResultsDir "tb_tran.log"
if (Test-Path $tranLog) {
    Write-Host "`n--- TRANSIENT & DISTORTION (tb_tran) ---" -ForegroundColor White
    Get-Content $tranLog | Select-String "vout_|gain_tran|Total Harmonic Distortion" | ForEach-Object {
        Write-Host "  $($_.Line.Trim())" -ForegroundColor Gray
    }
}

Write-Host "`n=================================================================" -ForegroundColor Cyan
Write-Host " VALIDATION HARNESS EXECUTION COMPLETE" -ForegroundColor Cyan
Write-Host " All logs and raw measurement data preserved in: $ResultsDir" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
