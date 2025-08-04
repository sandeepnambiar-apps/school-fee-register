# School Fee Register System

A comprehensive microservices-based application for managing school fee collection, student records, and financial reporting.

## 🏗️ Architecture

- **Microservices Architecture** with Spring Boot
- **React.js Frontend** with Material-UI
- **MySQL Database** for data persistence
- **AWS Cloud Deployment** ready
- **Docker Containerization**

## 🚀 Features

### Core Features
- **Student Management**: Add, update, view student information
- **Fee Structure Management**: Define fee categories, amounts, and schedules
- **Fee Collection**: Process payments, generate receipts
- **Payment Tracking**: Monitor payment status, due dates, and arrears
- **Reporting**: Generate financial reports, student fee statements
- **User Management**: Role-based access control (Admin, Staff, Parents)

### Advanced Features
- **Multi-payment Methods**: Cash, Card, Online, Bank Transfer
- **Fee Discounts**: Scholarships, sibling discounts, early payment discounts
- **Automated Reminders**: Email/SMS notifications for due payments
- **Receipt Generation**: PDF receipts and certificates
- **Audit Trail**: Complete transaction history and logging

## 📁 Project Structure

```
school-fee-register/
├── backend/
│   ├── student-service/          # Student management microservice
│   ├── fee-service/             # Fee structure, collection, and payment processing
│   ├── notification-service/    # Email/SMS notifications
│   ├── reporting-service/       # Report generation
│   └── gateway-service/         # API Gateway
├── frontend/                    # React.js application
├── database/                    # Database scripts and migrations
├── docker/                      # Docker configurations
└── aws/                         # AWS deployment scripts
```

## 🛠️ Technology Stack

### Backend
- **Java 17** with **Spring Boot 3.x**
- **Spring Cloud** for microservices
- **Spring Data JPA** for data access
- **Spring Security** for authentication
- **MySQL 8.0** for database
- **Redis** for caching
- **RabbitMQ** for messaging

### Frontend
- **React.js 18** with **TypeScript**
- **Material-UI** for components
- **Redux Toolkit** for state management
- **React Router** for navigation
- **Axios** for API calls

### Infrastructure
- **Docker** for containerization
- **AWS** for cloud deployment
- **Kubernetes** for orchestration (optional)

## 🚀 Quick Start

### Prerequisites
- Java 17+
- Node.js 18+
- MySQL 8.0
- Docker (optional)

### Local Development
1. Clone the repository
2. Set up MySQL database
3. Start backend services
4. Start frontend application

### Docker Deployment
```bash
docker-compose up -d
```

### AWS Deployment
```bash
./aws/deploy.sh
```

## 📊 Database Schema

The system uses a normalized database design with the following main entities:
- Students
- Fee Structures
- Payments
- Users
- Classes/Sections
- Academic Years

## 🔐 Security

- JWT-based authentication
- Role-based access control
- API rate limiting
- Data encryption
- Audit logging

## 📈 Monitoring

- Application metrics with Prometheus
- Logging with ELK stack
- Health checks and alerts
- Performance monitoring

## 🤝 Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details. 