# School Fee Register - Complete Startup Script (PowerShell)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  School Fee Register - Complete Startup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Checking prerequisites..." -ForegroundColor Yellow
Write-Host ""

# Check if Java is installed
try {
    $javaVersion = java -version 2>&1
    Write-Host "✓ Java is installed" -ForegroundColor Green
} catch {
    Write-Host "✗ Java is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Java 17 or higher" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if Maven is installed
try {
    $mvnVersion = mvn -version 2>&1
    Write-Host "✓ Maven is installed" -ForegroundColor Green
} catch {
    Write-Host "✗ Maven is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Apache Maven" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if Node.js is installed
try {
    $nodeVersion = node --version 2>&1
    Write-Host "✓ Node.js is installed" -ForegroundColor Green
} catch {
    Write-Host "✗ Node.js is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Node.js 16 or higher" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if Docker is running
try {
    docker info > $null 2>&1
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker is not running" -ForegroundColor Red
    Write-Host "Please start Docker Desktop" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "🚀 Starting all services..." -ForegroundColor Yellow
Write-Host ""

# Start MySQL if not running
Write-Host "1. Checking MySQL Database..." -ForegroundColor Cyan
$mysqlRunning = docker ps --filter "name=school_fee_mysql" --format "table {{.Names}}" | Select-String "school_fee_mysql"
if (-not $mysqlRunning) {
    Write-Host "Starting MySQL database..." -ForegroundColor Yellow
    docker-compose up -d mysql
    Start-Sleep -Seconds 15
    Write-Host "✓ MySQL database started" -ForegroundColor Green
} else {
    Write-Host "✓ MySQL is already running" -ForegroundColor Green
}

# Start services in order
Write-Host ""
Write-Host "2. Starting Eureka Server (Service Discovery)..." -ForegroundColor Cyan
Start-Process -FilePath "cmd" -ArgumentList "/k", "cd backend\eureka-server && mvn spring-boot:run" -WindowStyle Normal
Start-Sleep -Seconds 10

Write-Host "3. Starting Gateway Service..." -ForegroundColor Cyan
Start-Process -FilePath "cmd" -ArgumentList "/k", "cd backend\gateway-service && mvn spring-boot:run" -WindowStyle Normal
Start-Sleep -Seconds 10

Write-Host "4. Starting Auth Service..." -ForegroundColor Cyan
Start-Process -FilePath "cmd" -ArgumentList "/k", "cd backend\auth-service && mvn spring-boot:run" -WindowStyle Normal
Start-Sleep -Seconds 10

Write-Host "5. Starting Student Service..." -ForegroundColor Cyan
Start-Process -FilePath "cmd" -ArgumentList "/k", "cd backend\student-service && mvn spring-boot:run" -WindowStyle Normal
Start-Sleep -Seconds 10

Write-Host "6. Starting Fee Service..." -ForegroundColor Cyan
Start-Process -FilePath "cmd" -ArgumentList "/k", "cd backend\fee-service && mvn spring-boot:run" -WindowStyle Normal
Start-Sleep -Seconds 10

Write-Host "7. Starting Notification Service..." -ForegroundColor Cyan
Start-Process -FilePath "cmd" -ArgumentList "/k", "cd backend\notification-service && mvn spring-boot:run" -WindowStyle Normal
Start-Sleep -Seconds 10

Write-Host "8. Starting Reporting Service..." -ForegroundColor Cyan
Start-Process -FilePath "cmd" -ArgumentList "/k", "cd backend\reporting-service && mvn spring-boot:run" -WindowStyle Normal
Start-Sleep -Seconds 10

Write-Host "9. Starting Frontend Application..." -ForegroundColor Cyan
Start-Process -FilePath "cmd" -ArgumentList "/k", "cd frontend && npm start" -WindowStyle Normal

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🎉 All services are starting!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📱 Application URLs:" -ForegroundColor Yellow
Write-Host "   Frontend: http://localhost:3000" -ForegroundColor White
Write-Host ""
Write-Host "🔧 Backend Services:" -ForegroundColor Yellow
Write-Host "   Eureka Dashboard: http://localhost:8761" -ForegroundColor White
Write-Host "   Gateway: http://localhost:8080" -ForegroundColor White
Write-Host "   Auth Service: http://localhost:8082" -ForegroundColor White
Write-Host "   Student Service: http://localhost:8081" -ForegroundColor White
Write-Host "   Fee Service: http://localhost:8086" -ForegroundColor White
Write-Host "   Notification Service: http://localhost:8084" -ForegroundColor White
Write-Host "   Reporting Service: http://localhost:8087" -ForegroundColor White
Write-Host ""
Write-Host "🗄️  Database:" -ForegroundColor Yellow
Write-Host "   MySQL: localhost:3306" -ForegroundColor White
Write-Host ""
Write-Host "🔑 Demo Credentials:" -ForegroundColor Yellow
Write-Host "   Admin: admin / admin123" -ForegroundColor White
Write-Host "   Teacher: teacher / teacher123" -ForegroundColor White
Write-Host "   Parent: parent / parent123" -ForegroundColor White
Write-Host ""
Write-Host "⏳ Services will take a few minutes to fully start up." -ForegroundColor Yellow
Write-Host "   Check the individual command windows for startup progress." -ForegroundColor Gray
Write-Host ""
Write-Host "🛑 To stop all services, run: .\stop-all.ps1" -ForegroundColor Red
Write-Host ""
Read-Host "Press Enter to continue" 