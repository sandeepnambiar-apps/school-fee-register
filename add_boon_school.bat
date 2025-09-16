@echo off
echo ========================================
echo   Adding BOON School to Database
echo ========================================
echo.

echo Checking if MySQL is running...
netstat -an | findstr :3306 >nul
if %errorlevel% neq 0 (
    echo ERROR: MySQL is not running on port 3306
    echo Please start the database first
    pause
    exit /b 1
)

echo MySQL is running. Proceeding with adding BOON school...
echo.

echo Executing SQL script to add BOON school...
mysql -u root -p -e "source database/add_boon_school.sql" school_fee_register

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   SUCCESS: BOON school added!
    echo ========================================
    echo.
    echo Summary:
    echo - BOON school added to the database
    echo - School Code: BOON
    echo - School Name: BOON School
    echo - You can now test the login with BOON school code!
) else (
    echo.
    echo ERROR: Failed to add BOON school to database
    echo Please check the error messages above
)

echo.
pause

