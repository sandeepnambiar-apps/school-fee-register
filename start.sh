#!/bin/bash

echo "🚀 Starting School Fee Register Application..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "📦 Building and starting all services..."

# Build and start all services
docker-compose up --build -d

echo "⏳ Waiting for services to start..."

# Wait for MySQL to be ready
echo "🔍 Waiting for MySQL database..."
until docker-compose exec -T mysql mysqladmin ping -h"localhost" --silent; do
    echo "⏳ MySQL is starting..."
    sleep 5
done
echo "✅ MySQL is ready!"

# Wait for Eureka Server
echo "🔍 Waiting for Eureka Server..."
until curl -f http://localhost:8761/actuator/health > /dev/null 2>&1; do
    echo "⏳ Eureka Server is starting..."
    sleep 5
done
echo "✅ Eureka Server is ready!"

# Wait for Gateway Service
echo "🔍 Waiting for Gateway Service..."
until curl -f http://localhost:8080/actuator/health > /dev/null 2>&1; do
    echo "⏳ Gateway Service is starting..."
    sleep 5
done
echo "✅ Gateway Service is ready!"

# Wait for Frontend
echo "🔍 Waiting for Frontend..."
until curl -f http://localhost:3000 > /dev/null 2>&1; do
    echo "⏳ Frontend is starting..."
    sleep 5
done
echo "✅ Frontend is ready!"

echo ""
echo "🎉 School Fee Register Application is now running!"
echo ""
echo "📱 Frontend Application: http://localhost:3000"
echo "🔧 Eureka Server: http://localhost:8761"
echo "🌐 Gateway Service: http://localhost:8080"
echo "📊 Student Service: http://localhost:8081"
echo "💰 Fee Service: http://localhost:8082"
echo "💳 Payment Service: http://localhost:8083"
echo "📧 Notification Service: http://localhost:8084"
echo "📈 Reporting Service: http://localhost:8085"
echo "🗄️  MySQL Database: localhost:3306"
echo ""
echo "🔑 Demo Credentials:"
echo "   Admin: admin / admin123"
echo "   Teacher: teacher / teacher123"
echo "   Parent: parent / parent123"
echo ""
echo "🛑 To stop the application, run: docker-compose down"
echo "📋 To view logs, run: docker-compose logs -f [service-name]" 