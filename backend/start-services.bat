@echo off
echo Starting School Fee Register Microservices...
echo.

echo 1. Starting Eureka Server (Service Discovery)...
start "Eureka Server" cmd /k "cd eureka-server && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo 2. Starting Gateway Service...
start "Gateway Service" cmd /k "cd gateway-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo 3. Starting Auth Service...
start "Auth Service" cmd /k "cd auth-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo 4. Starting Student Service...
start "Student Service" cmd /k "cd student-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo 5. Starting Fee Service...
start "Fee Service" cmd /k "cd fee-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo 6. Starting Notification Service...
start "Notification Service" cmd /k "cd notification-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo 7. Starting Reporting Service...
start "Reporting Service" cmd /k "cd reporting-service && mvn spring-boot:run"

echo.
echo All services are starting...
echo.
echo Service URLs:
echo - Eureka Dashboard: http://localhost:8761
echo - Gateway: http://localhost:8080
echo - Auth Service: http://localhost:8082
echo - Student Service: http://localhost:8081
echo - Fee Service: http://localhost:8086
echo - Notification Service: http://localhost:8084
echo - Reporting Service: http://localhost:8087
echo.
echo Press any key to exit...
pause > nul 