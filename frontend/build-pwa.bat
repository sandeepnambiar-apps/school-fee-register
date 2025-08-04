@echo off
echo Building Kidsy School PWA...

REM Install dependencies if needed
if not exist "node_modules" (
    echo Installing dependencies...
    npm install
)

REM Build the PWA
echo Building production PWA...
npm run build

REM Copy service worker to build directory
echo Copying service worker...
copy public\sw.js build\sw.js

REM Create app icons (you'll need to add actual icon files)
echo Creating app icons...
echo Note: Add logo192.png and logo512.png to public folder for proper icons

echo.
echo PWA Build Complete!
echo.
echo To test the PWA:
echo 1. Serve the build folder: npx serve -s build
echo 2. Open in Chrome/Edge and look for "Install" button
echo 3. Or use: npx http-server build -p 3000
echo.
echo For mobile testing:
echo 1. Use ngrok: npx ngrok http 3000
echo 2. Open the ngrok URL on your mobile device
echo 3. Add to home screen for app-like experience 