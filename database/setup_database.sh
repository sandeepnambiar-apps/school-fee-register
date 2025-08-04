#!/bin/bash

# School Fee Register Database Setup Script
# This script sets up the complete database with all tables and sample data

echo "🏗️  Setting up School Fee Register Database..."
echo "================================================"

# Database configuration
DB_HOST="localhost"
DB_PORT="3306"
DB_NAME="school_fee_register"
DB_USER="root"
DB_PASSWORD="your_password"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if MySQL is running
echo "Checking MySQL connection..."
if ! mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD -e "SELECT 1;" > /dev/null 2>&1; then
    print_error "Cannot connect to MySQL. Please ensure MySQL is running and credentials are correct."
    exit 1
fi
print_status "MySQL connection successful"

# Create database if it doesn't exist
echo "Creating database..."
mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
print_status "Database created/verified"

# Run migration scripts in order
echo "Running database migrations..."

# 1. Core tables
echo "Creating core tables..."
mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME < database/schema.sql
print_status "Core tables created"

# 2. Authentication tables
echo "Creating authentication tables..."
mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME < database/migrations/001_create_auth_tables.sql
print_status "Authentication tables created"

# 3. Homework tables
echo "Creating homework tables..."
mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME < database/migrations/002_create_homework_tables.sql
print_status "Homework tables created"

# 4. Transport fee tables
echo "Creating transport fee tables..."
mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME < database/transport_fee_tables.sql
print_status "Transport fee tables created"

# 5. Sample data
echo "Inserting sample data..."
mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME < database/sample_data.sql
print_status "Sample data inserted"

# 6. Views and stored procedures
echo "Creating views and stored procedures..."
mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME < database/views_and_procedures.sql
print_status "Views and stored procedures created"

# Verify database setup
echo "Verifying database setup..."
TABLE_COUNT=$(mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "SHOW TABLES;" | wc -l)
print_status "Database contains $TABLE_COUNT tables"

# Test data verification
echo "Verifying sample data..."
STUDENT_COUNT=$(mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "SELECT COUNT(*) FROM students;" | tail -n 1)
USER_COUNT=$(mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "SELECT COUNT(*) FROM users;" | tail -n 1)
HOMEWORK_COUNT=$(mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "SELECT COUNT(*) FROM homework_assignments;" | tail -n 1)

print_status "Sample data verification:"
echo "  - Students: $STUDENT_COUNT"
echo "  - Users: $USER_COUNT"
echo "  - Homework assignments: $HOMEWORK_COUNT"

# Create database user for application
echo "Creating application database user..."
mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD -e "
CREATE USER IF NOT EXISTS 'school_fee_user'@'%' IDENTIFIED BY 'school_fee_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON $DB_NAME.* TO 'school_fee_user'@'%';
FLUSH PRIVILEGES;
"
print_status "Application database user created"

# Create environment configuration file
echo "Creating environment configuration..."
cat > .env << EOF
# Database Configuration
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_NAME=$DB_NAME
DB_USERNAME=school_fee_user
DB_PASSWORD=school_fee_password

# JWT Configuration
JWT_SECRET=your_super_secret_jwt_key_for_school_fee_register_2024
JWT_EXPIRATION=86400000

# Email Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_app_password

# Application Configuration
SERVER_PORT=8080
EUREKA_SERVER_URL=http://localhost:8761
EOF
print_status "Environment configuration created"

echo ""
echo "🎉 Database setup completed successfully!"
echo "================================================"
echo ""
echo "📋 Next steps:"
echo "1. Update .env file with your actual credentials"
echo "2. Start the backend services: ./start.sh"
echo "3. Test the API endpoints"
echo "4. Run the mobile app: flutter run"
echo ""
echo "🔑 Default credentials:"
echo "  - Username: admin"
echo "  - Password: admin123"
echo ""
echo "📊 Database connection details:"
echo "  - Host: $DB_HOST"
echo "  - Port: $DB_PORT"
echo "  - Database: $DB_NAME"
echo "  - User: school_fee_user"
echo "  - Password: school_fee_password"
echo "" 