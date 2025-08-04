@echo off
echo ========================================
echo    Kidsy School Mobile App Setup
echo ========================================
echo.

echo [1/8] Checking Node.js installation...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js is not installed!
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)
echo ✓ Node.js is installed

echo.
echo [2/8] Checking npm installation...
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: npm is not installed!
    pause
    exit /b 1
)
echo ✓ npm is installed

echo.
echo [3/8] Installing React Native CLI globally...
npm install -g @react-native-community/cli
if %errorlevel% neq 0 (
    echo ERROR: Failed to install React Native CLI!
    pause
    exit /b 1
)
echo ✓ React Native CLI installed

echo.
echo [4/8] Installing project dependencies...
npm install
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies!
    pause
    exit /b 1
)
echo ✓ Dependencies installed

echo.
echo [5/8] Creating Android directory structure...
if not exist "android" (
    echo Creating Android project structure...
    mkdir android
    echo ✓ Android directory created
) else (
    echo ✓ Android directory exists
)

echo.
echo [6/8] Creating iOS directory structure...
if not exist "ios" (
    echo Creating iOS project structure...
    mkdir ios
    echo ✓ iOS directory created
) else (
    echo ✓ iOS directory exists
)

echo.
echo [7/8] Setting up environment variables...
echo API_BASE_URL=http://localhost:8081 > .env
echo ENVIRONMENT=development >> .env
echo ✓ Environment variables set

echo.
echo [8/8] Setup complete!
echo.
echo ========================================
echo    Next Steps:
echo ========================================
echo.
echo For Android Development:
echo 1. Install Android Studio
echo 2. Set up Android SDK
echo 3. Create Android Virtual Device (AVD)
echo 4. Run: npm run android
echo.
echo For iOS Development (macOS only):
echo 1. Install Xcode
echo 2. Install CocoaPods: sudo gem install cocoapods
echo 3. Run: cd ios && pod install && cd ..
echo 4. Run: npm run ios
echo.
echo To start the Metro bundler:
echo npm start
echo.
echo ========================================
echo    Mobile App Setup Complete!
echo ========================================
echo.
pause 