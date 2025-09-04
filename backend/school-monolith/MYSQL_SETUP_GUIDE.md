# MySQL Setup Guide for School Management System

## Prerequisites
- MySQL 8.0+ installed and running
- Java 11+ installed
- Maven installed

## Step 1: Start MySQL Service
```bash
# Windows (if using XAMPP/WAMP)
# Start MySQL service from your control panel

# Windows (if using MySQL Installer)
net start mysql80

# Linux/Mac
sudo systemctl start mysql
```

## Step 2: Create Database
1. Connect to MySQL as root:
```bash
mysql -u root -p
```

2. Run the setup script:
```bash
source mysql-setup.sql
```

Or manually:
```sql
CREATE DATABASE IF NOT EXISTS school_management 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;
```

## Step 3: Verify Database Configuration
The application.yml is already configured with:
- Database URL: `jdbc:mysql://localhost:3306/school_management`
- Username: `root`
- Password: `root`
- Auto-create tables: `ddl-auto: update`

## Step 4: Build and Run the Application
```bash
cd backend/school-monolith
mvn clean compile
mvn spring-boot:run
```

## Step 5: Verify Data Initialization
When the application starts, you should see:
```
Initialized 5 students with complete data including Aadhaar and category fields.
```

## Step 6: Check Database Tables
Connect to MySQL and verify:
```sql
USE school_management;
SHOW TABLES;
SELECT * FROM students;
```

## Expected Tables
- `schools` - School information
- `students` - Student data with new Aadhaar and category fields
- `buses` - Bus tracking data (if implemented)

## Troubleshooting

### Connection Issues
- Ensure MySQL is running on port 3306
- Check username/password in application.yml
- Verify database exists

### Table Creation Issues
- Check MySQL user permissions
- Ensure `ddl-auto: update` is set
- Check application logs for Hibernate errors

### Data Initialization Issues
- Check if StudentDataInitializer is loaded
- Verify entity annotations are correct
- Check for compilation errors

## Database Schema
The `students` table will include:
- Basic fields (name, class, section, etc.)
- **NEW: kid_aadhaar** - Student's Aadhaar number
- **NEW: pen** - Permanent Enrollment Number
- **NEW: father_aadhaar** - Father's Aadhaar
- **NEW: mother_aadhaar** - Mother's Aadhaar
- **NEW: caste** - Student's caste
- **NEW: category** - Reservation category (General, OBC, SC, ST, EWS)

## Sample Data
5 students will be automatically created with:
- Complete personal information
- Aadhaar numbers for student, father, and mother
- PEN numbers
- Caste and category information
- All major Indian reservation categories represented

