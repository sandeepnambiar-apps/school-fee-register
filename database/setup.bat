@echo off
REM School Fee Register Database Setup Script for Windows
REM This script sets up the MySQL database for the school fee register system

echo 🚀 Starting School Fee Register Database Setup...

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker Desktop first.
    pause
    exit /b 1
)

REM Check if Docker Compose is installed
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose is not installed. Please install Docker Compose first.
    pause
    exit /b 1
)

REM Stop any existing containers
echo 🛑 Stopping any existing containers...
docker-compose down

REM Start the database
echo 🐳 Starting MySQL database...
docker-compose up -d mysql

REM Wait for MySQL to be ready
echo ⏳ Waiting for MySQL to be ready...
timeout /t 30 /nobreak >nul

REM Check if MySQL is running
docker exec school_fee_mysql mysqladmin ping -h"localhost" --silent >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ MySQL is not ready. Please check the logs:
    docker-compose logs mysql
    pause
    exit /b 1
)

echo ✅ MySQL is ready!

REM Start phpMyAdmin
echo 🌐 Starting phpMyAdmin...
docker-compose up -d phpmyadmin

REM Display connection information
echo.
echo 🎉 Database setup completed successfully!
echo.
echo 📊 Database Information:
echo    Host: localhost
echo    Port: 3306
echo    Database: school_fee_register
echo    Username: schooluser
echo    Password: schoolpass
echo    Root Password: rootpassword
echo.
echo 🌐 phpMyAdmin:
echo    URL: http://localhost:8080
echo    Username: root
echo    Password: rootpassword
echo.
echo 🔧 Application Configuration:
echo    Update your application.properties files with:
echo    spring.datasource.url=jdbc:mysql://localhost:3306/school_fee_register
echo    spring.datasource.username=schooluser
echo    spring.datasource.password=schoolpass
echo.
echo 📝 Useful Commands:
echo    View logs: docker-compose logs -f
echo    Stop database: docker-compose down
echo    Restart database: docker-compose restart
echo    Access MySQL CLI: docker exec -it school_fee_mysql mysql -u root -p
echo.
pause 