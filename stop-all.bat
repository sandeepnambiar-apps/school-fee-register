@echo off
echo ========================================
echo   School Fee Register - Stop All Services
echo ========================================
echo.

echo 🛑 Stopping all services...
echo.

REM Stop all Java processes (Spring Boot applications)
echo Stopping Spring Boot services...
taskkill /f /im java.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Spring Boot services stopped
) else (
    echo ℹ️  No Spring Boot services were running
)

REM Stop Node.js processes (Frontend)
echo Stopping Frontend application...
taskkill /f /im node.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Frontend application stopped
) else (
    echo ℹ️  No Frontend application was running
)

REM Stop MySQL container
echo Stopping MySQL database...
docker stop school_fee_mysql >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ MySQL database stopped
) else (
    echo ℹ️  MySQL database was not running
)

echo.
echo ========================================
echo ✅ All services have been stopped!
echo ========================================
echo.
echo To start all services again, run: start-all.bat
echo.
pause 