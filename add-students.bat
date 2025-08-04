@echo off
echo ========================================
echo   Adding 50 Students to Database
echo ========================================
echo.

echo Checking if MySQL is running...
netstat -an | findstr :3306 >nul
if %errorlevel% neq 0 (
    echo ERROR: MySQL is not running on port 3306
    echo Please start the database first using: .\start-all.ps1
    pause
    exit /b 1
)

echo MySQL is running. Proceeding with adding students...
echo.

echo Executing SQL script to add 50 students...
mysql -u root -p -e "source database/add_50_students.sql" school_fee_register

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   SUCCESS: 50 students added!
    echo ========================================
    echo.
    echo Summary:
    echo - 50 new students added to the database
    echo - Students distributed across all 10 classes
    echo - Parent accounts created for each student
    echo - Total students in database: 60 (10 original + 50 new)
    echo.
    echo You can now test the mobile app with more students!
) else (
    echo.
    echo ERROR: Failed to add students to database
    echo Please check the error messages above
)

echo.
pause 