#!/bin/bash

# School Fee Register Database Setup Script
# This script sets up the MySQL database for the school fee register system

echo "🚀 Starting School Fee Register Database Setup..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Stop any existing containers
echo "🛑 Stopping any existing containers..."
docker-compose down

# Remove existing volumes (optional - uncomment if you want fresh data)
# echo "🗑️  Removing existing volumes..."
# docker volume rm school-fee-register_mysql_data

# Start the database
echo "🐳 Starting MySQL database..."
docker-compose up -d mysql

# Wait for MySQL to be ready
echo "⏳ Waiting for MySQL to be ready..."
sleep 30

# Check if MySQL is running
if ! docker exec school_fee_mysql mysqladmin ping -h"localhost" --silent; then
    echo "❌ MySQL is not ready. Please check the logs:"
    docker-compose logs mysql
    exit 1
fi

echo "✅ MySQL is ready!"

# Start phpMyAdmin
echo "🌐 Starting phpMyAdmin..."
docker-compose up -d phpmyadmin

# Display connection information
echo ""
echo "🎉 Database setup completed successfully!"
echo ""
echo "📊 Database Information:"
echo "   Host: localhost"
echo "   Port: 3306"
echo "   Database: school_fee_register"
echo "   Username: schooluser"
echo "   Password: schoolpass"
echo "   Root Password: rootpassword"
echo ""
echo "🌐 phpMyAdmin:"
echo "   URL: http://localhost:8080"
echo "   Username: root"
echo "   Password: rootpassword"
echo ""
echo "🔧 Application Configuration:"
echo "   Update your application.properties files with:"
echo "   spring.datasource.url=jdbc:mysql://localhost:3306/school_fee_register"
echo "   spring.datasource.username=schooluser"
echo "   spring.datasource.password=schoolpass"
echo ""
echo "📝 Useful Commands:"
echo "   View logs: docker-compose logs -f"
echo "   Stop database: docker-compose down"
echo "   Restart database: docker-compose restart"
echo "   Access MySQL CLI: docker exec -it school_fee_mysql mysql -u root -p"
echo "" 