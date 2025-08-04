@echo off
echo ========================================
echo School Fee Register - Robust Startup
echo ========================================
echo.

echo 1. Checking if MySQL is running...
docker ps | findstr school_fee_mysql > nul
if %errorlevel% neq 0 (
    echo Starting MySQL database...
    docker start school_fee_mysql
    timeout /t 10 /nobreak > nul
) else (
    echo MySQL is already running
)

echo.
echo 2. Testing database connection...
docker exec school_fee_mysql mysql -u schooluser -pschoolpass -e "SELECT 1;" > nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Database connection failed!
    echo Please check if MySQL is running properly
    pause
    exit /b 1
)
echo Database connection successful!

echo.
echo 3. Starting Eureka Server (Service Discovery)...
cd eureka-server
start "Eureka Server" cmd /k "mvn spring-boot:run"
echo Waiting for Eureka to start...
timeout /t 20 /nobreak > nul

echo.
echo 4. Testing Eureka Server...
:check_eureka
curl -f http://localhost:8761/actuator/health > nul 2>&1
if %errorlevel% neq 0 (
    echo Waiting for Eureka to be ready...
    timeout /t 5 /nobreak > nul
    goto check_eureka
)
echo Eureka Server is ready!

echo.
echo 5. Starting Gateway Service...
cd ..\gateway-service
start "Gateway Service" cmd /k "mvn spring-boot:run"
echo Waiting for Gateway to start...
timeout /t 15 /nobreak > nul

echo.
echo 6. Testing Gateway Service...
:check_gateway
curl -f http://localhost:8080/actuator/health > nul 2>&1
if %errorlevel% neq 0 (
    echo Waiting for Gateway to be ready...
    timeout /t 5 /nobreak > nul
    goto check_gateway
)
echo Gateway Service is ready!

echo.
echo 7. Starting Student Service...
cd ..\student-service
start "Student Service" cmd /k "mvn spring-boot:run"
echo Waiting for Student Service to start...
timeout /t 15 /nobreak > nul

echo.
echo 8. Testing Student Service...
:check_student
curl -f http://localhost:8081/actuator/health > nul 2>&1
if %errorlevel% neq 0 (
    echo Waiting for Student Service to be ready...
    timeout /t 5 /nobreak > nul
    goto check_student
)
echo Student Service is ready!

echo.
echo 9. Starting Fee Service...
cd ..\fee-service
start "Fee Service" cmd /k "mvn spring-boot:run"
echo Waiting for Fee Service to start...
timeout /t 15 /nobreak > nul

echo.
echo 10. Testing Fee Service...
:check_fee
curl -f http://localhost:8086/actuator/health > nul 2>&1
if %errorlevel% neq 0 (
    echo Waiting for Fee Service to be ready...
    timeout /t 5 /nobreak > nul
    goto check_fee
)
echo Fee Service is ready!

echo.
echo 11. Starting Notification Service...
cd ..\notification-service
start "Notification Service" cmd /k "mvn spring-boot:run"
echo Waiting for Notification Service to start...
timeout /t 15 /nobreak > nul

echo.
echo 12. Starting Auth Service...
cd ..\auth-service
start "Auth Service" cmd /k "mvn spring-boot:run"
echo Waiting for Auth Service to start...
timeout /t 15 /nobreak > nul

echo.
echo 13. Starting Reporting Service...
cd ..\reporting-service
start "Reporting Service" cmd /k "mvn spring-boot:run"

echo.
echo ========================================
echo All Services Started Successfully!
echo ========================================
echo.
echo Service URLs:
echo - Eureka Dashboard: http://localhost:8761
echo - Gateway: http://localhost:8080
echo - Student Service: http://localhost:8081
echo - Fee Service: http://localhost:8086
echo - Auth Service: http://localhost:8082
echo - Notification Service: http://localhost:8084
echo - Reporting Service: http://localhost:8087
echo.
echo Frontend: http://localhost:3000
echo.
echo To check service status, run: node test-services-status.js
echo.
pause 