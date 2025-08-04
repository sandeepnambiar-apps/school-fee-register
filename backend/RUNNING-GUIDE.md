# School Fee Register - Running and Testing Guide

## ✅ Current Status
- **Maven Build**: ✅ SUCCESSFUL - All modules compile without errors
- **Project Structure**: ✅ COMPLETE - All microservices are properly configured
- **Dependencies**: ✅ RESOLVED - All dependencies are correctly managed

## 🚀 How to Run the Application

### Prerequisites
1. **Java 17** installed and configured
2. **Maven** installed and configured  
3. **MySQL** installed and running (optional for initial testing)
4. **Git** (optional)

### Option 1: Quick Test (Recommended for first run)

#### Step 1: Test Individual Services
```bash
# Navigate to backend directory
cd school-fee-register/backend

# Test Eureka Server (Service Discovery)
cd eureka-server
mvn spring-boot:run

# In a new terminal, test Gateway Service
cd gateway-service
mvn spring-boot:run

# In another terminal, test Student Service
cd student-service
mvn spring-boot:run
```

#### Step 2: Access Services
- **Eureka Dashboard**: http://localhost:8761
- **Gateway Service**: http://localhost:8080
- **Student Service**: http://localhost:8081
- **Auth Service**: http://localhost:8082
- **Fee Service**: http://localhost:8083
- **Payment Service**: http://localhost:8084
- **Notification Service**: http://localhost:8085
- **Reporting Service**: http://localhost:8086

### Option 2: Database Setup (For Full Functionality)

#### Step 1: Setup MySQL Database
```sql
-- Connect to MySQL as root and run:
CREATE DATABASE school_fee_register;
CREATE USER 'schooluser'@'localhost' IDENTIFIED BY 'schoolpass';
GRANT ALL PRIVILEGES ON school_fee_register.* TO 'schooluser'@'localhost';
FLUSH PRIVILEGES;
```

#### Step 2: Configure Database Connection
Update `application.properties` in each service with:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/school_fee_register
spring.datasource.username=schooluser
spring.datasource.password=schoolpass
```

### Option 3: Use H2 In-Memory Database (For Testing)
Add to each service's `application.properties`:
```properties
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
spring.h2.console.enabled=true
```

## 🧪 Testing the Application

### 1. Health Checks
```bash
# Test Eureka Server
curl http://localhost:8761

# Test Gateway Health
curl http://localhost:8080/actuator/health

# Test Student Service Health
curl http://localhost:8081/actuator/health
```

### 2. API Testing
```bash
# Test Student Service APIs
curl http://localhost:8081/api/students
curl http://localhost:8081/api/students/1

# Test Auth Service (if running)
curl http://localhost:8082/api/auth/login
```

### 3. Frontend Testing (if available)
```bash
# Navigate to frontend directory
cd ../frontend

# Install dependencies (if using npm)
npm install

# Start frontend
npm start
```

## 🔧 Troubleshooting

### Common Issues:

#### 1. Port Already in Use
```bash
# Find process using port
netstat -ano | findstr :8761

# Kill process (replace PID with actual process ID)
taskkill /PID <PID> /F
```

#### 2. Database Connection Issues
- Ensure MySQL is running
- Check database credentials
- Verify database exists

#### 3. Maven Build Issues
```bash
# Clean and rebuild
mvn clean install

# Skip tests
mvn clean install -DskipTests
```

#### 4. Service Discovery Issues
- Ensure Eureka Server starts first
- Check service registration in Eureka dashboard
- Verify service URLs in application.properties

## 📋 Service Ports Summary
| Service | Port | Description |
|---------|------|-------------|
| Eureka Server | 8761 | Service Discovery |
| Gateway Service | 8080 | API Gateway |
| Student Service | 8081 | Student Management |
| Auth Service | 8082 | Authentication |
| Fee Service | 8083 | Fee Management |
| Payment Service | 8084 | Payment Processing |
| Notification Service | 8085 | Notifications |
| Reporting Service | 8086 | Reports |

## 🎯 Next Steps
1. Start with Eureka Server
2. Start Gateway Service
3. Start individual microservices as needed
4. Test API endpoints
5. Configure database if required
6. Deploy to production environment

## 📞 Support
If you encounter issues:
1. Check the logs for error messages
2. Verify all prerequisites are installed
3. Ensure ports are not in use
4. Check database connectivity
5. Review application.properties configuration 