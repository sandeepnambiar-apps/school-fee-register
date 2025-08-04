@echo off
echo ========================================
echo   School Fee Register - Complete Startup
echo ========================================
echo.

echo Checking prerequisites...
echo.

REM Check if Java is installed
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java is not installed or not in PATH
    echo Please install Java 17 or higher
    pause
    exit /b 1
)
echo ✅ Java is installed

REM Check if Maven is installed
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Maven is not installed or not in PATH
    echo Please install Apache Maven
    pause
    exit /b 1
)
echo ✅ Maven is installed

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed or not in PATH
    echo Please install Node.js 16 or higher
    pause
    exit /b 1
)
echo ✅ Node.js is installed

echo.
echo 🚀 Starting all services...
echo.

REM Start MySQL if not running
echo 1. Checking MySQL Database...
docker ps | findstr "school_fee_mysql" >nul
if %errorlevel% neq 0 (
    echo Starting MySQL database...
    docker-compose up -d mysql
    timeout /t 15 /nobreak > nul
) else (
    echo ✅ MySQL is already running
)

REM Start Eureka Server first
echo.
echo 2. Starting Eureka Server (Service Discovery)...
start "Eureka Server" cmd /k "cd backend\eureka-server && mvn spring-boot:run"
timeout /t 15 /nobreak > nul

REM Start Gateway Service
echo.
echo 3. Starting Gateway Service...
start "Gateway Service" cmd /k "cd backend\gateway-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

REM Start Auth Service
echo.
echo 4. Starting Auth Service...
start "Auth Service" cmd /k "cd backend\auth-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

REM Start Student Service
echo.
echo 5. Starting Student Service...
start "Student Service" cmd /k "cd backend\student-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

REM Start Fee Service
echo.
echo 6. Starting Fee Service...
start "Fee Service" cmd /k "cd backend\fee-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

REM Start Payment Service
echo.
echo 7. Starting Payment Service...
start "Payment Service" cmd /k "cd backend\payment-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

REM Start Notification Service
echo.
echo 8. Starting Notification Service...
start "Notification Service" cmd /k "cd backend\notification-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

REM Start Reporting Service
echo.
echo 9. Starting Reporting Service...
start "Reporting Service" cmd /k "cd backend\reporting-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

REM Start Frontend
echo.
echo 10. Starting Frontend Application...
start "Frontend" cmd /k "cd frontend && npm start"
timeout /t 10 /nobreak > nul

echo.
echo ========================================
echo 🎉 All services are starting!
echo ========================================
echo.
echo 📱 Application URLs:
echo    Frontend: http://localhost:3000
echo.
echo 🔧 Backend Services:
echo    Eureka Dashboard: http://localhost:8761
echo    Gateway: http://localhost:8080
echo    Auth Service: http://localhost:8082
echo    Student Service: http://localhost:8081
echo    Fee Service: http://localhost:8082
echo    Payment Service: http://localhost:8083
echo    Notification Service: http://localhost:8084
echo    Reporting Service: http://localhost:8087
echo.
echo 🗄️  Database:
echo    MySQL: localhost:3306
echo.
echo 🔑 Demo Credentials:
echo    Admin: admin / admin123
echo    Teacher: teacher / teacher123
echo    Parent: parent / parent123
echo.
echo ⏳ Services will take a few minutes to fully start up.
echo    Check the individual command windows for startup progress.
echo.
echo 🛑 To stop all services, close the command windows or run: stop-all.bat
echo.
pause 