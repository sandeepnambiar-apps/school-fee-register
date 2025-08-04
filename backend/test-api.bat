@echo off
echo Testing School Fee Register API Endpoints...
echo.

echo 1. Testing Eureka Server...
curl -s http://localhost:8761
if %errorlevel% equ 0 (
    echo ✓ Eureka Server is running
) else (
    echo ✗ Eureka Server is not running
)

echo.
echo 2. Testing Gateway Service...
curl -s http://localhost:8080/actuator/health
if %errorlevel% equ 0 (
    echo ✓ Gateway Service is running
) else (
    echo ✗ Gateway Service is not running
)

echo.
echo Service URLs:
echo - Eureka Dashboard: http://localhost:8761
echo - Gateway: http://localhost:8080
echo - Student Service: http://localhost:8081
echo - Auth Service: http://localhost:8082
echo - Fee Service: http://localhost:8083
echo - Payment Service: http://localhost:8084
echo - Notification Service: http://localhost:8085
echo - Reporting Service: http://localhost:8086
echo.
pause 