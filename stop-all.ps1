# School Fee Register - Stop All Services Script (PowerShell)
# This script stops all services for the School Fee Register application

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  School Fee Register - Stop All Services" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "🛑 Stopping all services..." -ForegroundColor Yellow
Write-Host ""

# Stop all Java processes (Spring Boot applications)
Write-Host "Stopping Spring Boot services..." -ForegroundColor Cyan
$javaProcesses = Get-Process -Name "java" -ErrorAction SilentlyContinue
if ($javaProcesses) {
    $javaProcesses | Stop-Process -Force
    Write-Host "✓ Spring Boot services stopped" -ForegroundColor Green
} else {
    Write-Host "ℹ️  No Spring Boot services were running" -ForegroundColor Gray
}

# Stop Node.js processes (Frontend)
Write-Host "Stopping Frontend application..." -ForegroundColor Cyan
$nodeProcesses = Get-Process -Name "node" -ErrorAction SilentlyContinue
if ($nodeProcesses) {
    $nodeProcesses | Stop-Process -Force
    Write-Host "✓ Frontend application stopped" -ForegroundColor Green
} else {
    Write-Host "ℹ️  No Frontend application was running" -ForegroundColor Gray
}

# Stop MySQL container
Write-Host "Stopping MySQL database..." -ForegroundColor Cyan
try {
    docker stop school_fee_mysql > $null 2>&1
    Write-Host "✓ MySQL database stopped" -ForegroundColor Green
} catch {
    Write-Host "ℹ️  MySQL database was not running" -ForegroundColor Gray
}

# Stop any remaining related processes
Write-Host "Cleaning up remaining processes..." -ForegroundColor Cyan

# Stop any remaining Maven processes
$mvnProcesses = Get-Process -Name "mvn" -ErrorAction SilentlyContinue
if ($mvnProcesses) {
    $mvnProcesses | Stop-Process -Force
    Write-Host "✓ Maven processes stopped" -ForegroundColor Green
}

# Stop any remaining npm processes
$npmProcesses = Get-Process -Name "npm" -ErrorAction SilentlyContinue
if ($npmProcesses) {
    $npmProcesses | Stop-Process -Force
    Write-Host "✓ NPM processes stopped" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ All services have been stopped!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To start all services again, run: .\start-all.ps1" -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter to continue" 