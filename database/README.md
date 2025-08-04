# School Fee Register Database Setup

This directory contains the database setup for the School Fee Register system.

## 📋 Overview

The database is built using MySQL 8.0 and includes:
- Complete schema for all entities
- Sample data for testing
- Docker setup for easy deployment
- phpMyAdmin for database management

## 🗄️ Database Schema

### Tables

1. **classes** - School classes/grades
2. **academic_years** - Academic year definitions
3. **fee_categories** - Types of fees (tuition, library, etc.)
4. **students** - Student information
5. **fee_structures** - Fee definitions for classes
6. **student_fees** - Individual student fee assignments
7. **payments** - Payment records
8. **audit_logs** - Change tracking
9. **users** - Authentication and authorization

### Key Features

- **Foreign Key Relationships** - Proper referential integrity
- **Indexes** - Optimized for common queries
- **Audit Trail** - Track all changes
- **Soft Deletes** - Data preservation with is_active flags

## 🚀 Quick Start

### Prerequisites

- Docker Desktop
- Docker Compose

### Setup Steps

#### Option 1: Using Setup Scripts

**For Linux/Mac:**
```bash
cd database
chmod +x setup.sh
./setup.sh
```

**For Windows:**
```cmd
cd database
setup.bat
```

#### Option 2: Manual Setup

1. **Start the database:**
   ```bash
   docker-compose up -d mysql
   ```

2. **Wait for MySQL to be ready (30 seconds)**

3. **Start phpMyAdmin:**
   ```bash
   docker-compose up -d phpmyadmin
   ```

## 📊 Database Information

| Property | Value |
|----------|-------|
| Host | localhost |
| Port | 3306 |
| Database | school_fee_register |
| Username | schooluser |
| Password | schoolpass |
| Root Password | rootpassword |

## 🌐 phpMyAdmin Access

- **URL:** http://localhost:8080
- **Username:** root
- **Password:** rootpassword

## 📝 Sample Data

The database comes pre-loaded with:

### Academic Years
- 2024-2025 (Active)
- 2023-2024 (Inactive)
- 2025-2026 (Inactive)

### Classes
- Class 1-10 (Primary to High School)

### Fee Categories
- Tuition Fee (Monthly)
- Library Fee (Annual)
- Laboratory Fee (Annual)
- Sports Fee (Annual)
- Computer Fee (Annual)
- Transportation Fee (Optional)
- Examination Fee
- Development Fee
- Admission Fee (One-time)
- Uniform Fee

### Students
- 10 sample students across different classes
- Complete parent information
- Various fee statuses (Pending, Paid, Partial, Overdue)

### Fee Structures
- Different fee amounts for each class
- Various frequencies (Monthly, Annual)
- Due dates for 2024-2025 academic year

## 🔧 Application Configuration

Update your Spring Boot application.properties files:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/school_fee_register?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=schooluser
spring.datasource.password=schoolpass
spring.jpa.hibernate.ddl-auto=validate
```

## 🛠️ Useful Commands

### Docker Commands
```bash
# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Restart database
docker-compose restart mysql

# Access MySQL CLI
docker exec -it school_fee_mysql mysql -u root -p

# Backup database
docker exec school_fee_mysql mysqldump -u root -prootpassword school_fee_register > backup.sql

# Restore database
docker exec -i school_fee_mysql mysql -u root -prootpassword school_fee_register < backup.sql
```

### Database Queries

#### Check Student Fee Status
```sql
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    c.class_name,
    fc.category_name,
    sf.amount,
    sf.status,
    sf.due_date
FROM students s
JOIN classes c ON s.class_id = c.id
JOIN student_fees sf ON s.id = sf.student_id
JOIN fee_structures fs ON sf.fee_structure_id = fs.id
JOIN fee_categories fc ON fs.fee_category_id = fc.id
WHERE s.is_active = TRUE
ORDER BY s.student_id, sf.due_date;
```

#### Get Overdue Fees
```sql
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    c.class_name,
    fc.category_name,
    sf.amount,
    sf.due_date,
    DATEDIFF(CURDATE(), sf.due_date) as days_overdue
FROM students s
JOIN classes c ON s.class_id = c.id
JOIN student_fees sf ON s.id = sf.student_id
JOIN fee_structures fs ON sf.fee_structure_id = fs.id
JOIN fee_categories fc ON fs.fee_category_id = fc.id
WHERE sf.status = 'OVERDUE'
ORDER BY days_overdue DESC;
```

#### Payment Summary
```sql
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    COUNT(p.id) as payment_count,
    SUM(p.amount) as total_paid,
    p.payment_method
FROM students s
JOIN student_fees sf ON s.id = sf.student_id
JOIN payments p ON sf.id = p.student_fee_id
GROUP BY s.id, p.payment_method
ORDER BY total_paid DESC;
```

## 🔒 Security Considerations

1. **Change Default Passwords** - Update passwords in production
2. **Network Security** - Restrict database access
3. **Backup Strategy** - Regular database backups
4. **Audit Logging** - Monitor all database changes

## 🐛 Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```bash
   # Check what's using port 3306
   netstat -tulpn | grep 3306
   
   # Stop conflicting service or change port in docker-compose.yml
   ```

2. **Database Connection Failed**
   ```bash
   # Check if MySQL is running
   docker ps | grep mysql
   
   # Check logs
   docker-compose logs mysql
   ```

3. **Permission Denied**
   ```bash
   # Make setup script executable
   chmod +x setup.sh
   ```

### Reset Database

To completely reset the database:

```bash
# Stop containers
docker-compose down

# Remove volumes
docker volume rm school-fee-register_mysql_data

# Restart
docker-compose up -d
```

## 📚 Additional Resources

- [MySQL 8.0 Documentation](https://dev.mysql.com/doc/refman/8.0/en/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [phpMyAdmin Documentation](https://docs.phpmyadmin.net/)

## 🤝 Contributing

When making changes to the database schema:

1. Update `schema.sql`
2. Update `sample_data.sql` if needed
3. Test the changes
4. Update this README if necessary
5. Create a backup before applying changes to production 