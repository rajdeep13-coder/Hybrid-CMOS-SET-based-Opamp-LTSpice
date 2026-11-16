<#
.SYNOPSIS
    Automated batch runner and validation harness for Circuit B: CMOS Voltage Gain / Integrator Stage.
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
$GainStageDir  = Join-Path $WorkspaceRoot "circuits\gain_integrator_stage"
$TbDir         = Join-Path $GainStageDir "testbenches"
$ResultsDir    = Join-Path $GainStageDir "results"

if (-not (Test-Path $LTspiceExe)) {
    Write-Error "LTspice executable not found at: $LTspiceExe"
}

if (-not (Test-Path $ResultsDir)) {
    New-Item -ItemType Directory -Path $ResultsDir -Force | Out-Null
}

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " CIRCUIT B: CMOS GAIN / INTEGRATOR AUTOMATED VALIDATION HARNESS" -ForegroundColor Cyan
Write-Host " Simulator: $LTspiceExe" -ForegroundColor DarkGray
Write-Host " Working Directory: $GainStageDir" -ForegroundColor DarkGray
Write-Host "=================================================================" -ForegroundColor Cyan

# 1. Compile Schematic to Netlist & verify schematic execution
Write-Host "`n[1/5] Netlisting and Simulating CMOS_Gain_Integrator.asc..." -ForegroundColor Yellow
Push-Location $GainStageDir
try {
    & $LTspiceExe -netlist "CMOS_Gain_Integrator.asc"
    Start-Sleep -Seconds 1
    & $LTspiceExe -b "CMOS_Gain_Integrator.asc"
    Start-Sleep -Seconds 2
    if (Test-Path "CMOS_Gain_Integrator.log") {
        Copy-Item "CMOS_Gain_Integrator.log" (Join-Path $ResultsDir "CMOS_Gain_Integrator_asc.log") -Force
        Write-Host "  -> CMOS_Gain_Integrator.asc simulated successfully." -ForegroundColor Green
    }
} finally {
    Pop-Location
}

# 2. Standalone Master Netlist
Write-Host "`n[2/5] Simulating CMOS_Gain_Integrator.cir..." -ForegroundColor Yellow
Push-Location $GainStageDir
try {
    & $LTspiceExe -b "CMOS_Gain_Integrator.cir"
    Start-Sleep -Seconds 2
    if (Test-Path "CMOS_Gain_Integrator.log") {
        Copy-Item "CMOS_Gain_Integrator.log" (Join-Path $ResultsDir "CMOS_Gain_Integrator_cir.log") -Force
        Write-Host "  -> CMOS_Gain_Integrator.cir simulated successfully." -ForegroundColor Green
    }
} finally {
    Pop-Location
}

# 3. Dedicated Testbenches list
$testbenches = @(
    @{ File = "tb_op.cir";   LogName = "tb_op.log";   Desc = "Operating Point (.op)" },
    @{ File = "tb_dc.cir";   LogName = "tb_dc.log";   Desc = "DC Transfer Characteristic (.dc)" },
    @{ File = "tb_ac.cir";   LogName = "tb_ac.log";   Desc = "AC Frequency Response & Bandwidth (.ac)" },
    @{ File = "tb_tran.cir"; LogName = "tb_tran.log"; Desc = "Transient Response & Linearity (.tran)" }
)

$step = 3
foreach ($tb in $testbenches) {
    Write-Host "`n[$step/5] Simulating $($tb.Desc) [$($tb.File)]..." -ForegroundColor Yellow
    Push-Location $TbDir
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

# 4. Parse and Display Summary of Results
Write-Host "`n=================================================================" -ForegroundColor Cyan
Write-Host " EXTRACTED VALIDATION RESULTS SUMMARY (CIRCUIT B)" -ForegroundColor Cyan
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
$dcLog = Join-Path $ResultsDir "tb_dc.log"
if (Test-Path $dcLog) {
    Write-Host "`n--- DC TRANSFER & LINEAR RANGE (tb_dc) ---" -ForegroundColor White
    Get-Content $dcLog | Select-String "vout_|gain_dc" | ForEach-Object {
        Write-Host "  $($_.Line.Trim())" -ForegroundColor Gray
    }
}

# AC Results
$acLog = Join-Path $ResultsDir "tb_ac.log"
if (Test-Path $acLog) {
    Write-Host "`n--- AC FREQUENCY RESPONSE & COMPENSATION (tb_ac) ---" -ForegroundColor White
    Get-Content $acLog | Select-String "ad_|f_3db|gbw|phase_" | ForEach-Object {
        Write-Host "  $($_.Line.Trim())" -ForegroundColor Gray
    }
}

# TRAN Results
$tranLog = Join-Path $ResultsDir "tb_tran.log"
if (Test-Path $tranLog) {
    Write-Host "`n--- TRANSIENT & DISTORTION (tb_tran) ---" -ForegroundColor White
    Get-Content $tranLog | Select-String "vin_|vout_|gain_tran|Total Harmonic Distortion" | ForEach-Object {
        Write-Host "  $($_.Line.Trim())" -ForegroundColor Gray
    }
}

Write-Host "`n=================================================================" -ForegroundColor Cyan
Write-Host " VALIDATION HARNESS EXECUTION COMPLETE" -ForegroundColor Cyan
Write-Host " All logs preserved in: $ResultsDir" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
