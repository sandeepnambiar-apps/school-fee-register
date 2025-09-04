@echo off
echo ========================================
echo School Management System - Monolith
echo ========================================
echo.

echo Building application...
call mvn clean install -DskipTests

if %ERRORLEVEL% NEQ 0 (
    echo Build failed! Please check the errors above.
    pause
    exit /b 1
)

echo.
echo Build successful! Starting application...
echo.
echo Application will be available at: http://localhost:8080
echo H2 Console: http://localhost:8080/h2-console
echo.
echo Press Ctrl+C to stop the application
echo.

java -jar target/school-management-monolith-1.0.0.jar

pause


