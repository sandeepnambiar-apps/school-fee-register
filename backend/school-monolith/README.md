# School Management System - Monolith

## Overview
This is a consolidated Spring Boot monolith application that combines all the microservices from the original school management system into a single, deployable application.

## Quick Start

### 1. Build the Application
```bash
mvn clean install
```

### 2. Run the Application
```bash
mvn spring-boot:run
```

### 3. Access the Application
- **Main Application**: http://localhost:8080
- **H2 Console**: http://localhost:8080/h2-console

## Benefits
- **Cost**: 50-70% reduction in AWS costs
- **Deployment**: Single JAR file deployment
- **Maintenance**: Easier to manage and monitor
- **Performance**: Faster response times (no inter-service calls)

## API Endpoints
All existing API endpoints are preserved and available on port 8080:
- `/api/auth/**` - Authentication endpoints
- `/api/students/**` - Student management
- `/api/fees/**` - Fee management
- `/api/homework/**` - Homework management


