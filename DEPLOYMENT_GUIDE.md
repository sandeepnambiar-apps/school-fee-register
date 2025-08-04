# School Fee Register - Complete Deployment Guide

This guide covers the deployment of the entire School Fee Register system, including the Spring Boot backend services, React.js frontend, and Flutter mobile app.

## System Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │   React.js Web  │    │   Mobile App    │
│   (Mobile)      │    │   (Frontend)    │    │   (iOS/Android) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   API Gateway   │
                    │   (Zuul)        │
                    └─────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Eureka Server  │    │  Config Server  │    │  Auth Service   │
│  (Discovery)    │    │  (Config Mgmt)  │    │  (Security)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Student Service │    │  Payment Service│    │  Fee Service    │
│ (Student Mgmt)  │    │  (Payments)     │    │  (Fee Mgmt)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│Notification Svc │    │Homework Service │    │Reporting Service│
│(Notifications)  │    │(Assignments)    │    │(Reports)        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │   MySQL DB      │
                    │   (Database)    │
                    └─────────────────┘
```

## Prerequisites

### System Requirements
- **OS**: Linux/Windows/macOS
- **RAM**: Minimum 8GB (16GB recommended)
- **Storage**: 50GB free space
- **Java**: JDK 17 or higher
- **Node.js**: 18.x or higher
- **Flutter**: 3.0 or higher
- **Docker**: 20.x or higher
- **Docker Compose**: 2.x or higher

### Software Installation

1. **Java Development Kit (JDK)**
   ```bash
   # Ubuntu/Debian
   sudo apt update
   sudo apt install openjdk-17-jdk

   # CentOS/RHEL
   sudo yum install java-17-openjdk-devel

   # macOS
   brew install openjdk@17

   # Windows
   # Download from Oracle or use Chocolatey
   choco install openjdk17
   ```

2. **Node.js and npm**
   ```bash
   # Using NodeSource repository
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs

   # Or using nvm
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
   nvm install 18
   nvm use 18
   ```

3. **Flutter SDK**
   ```bash
   # Download Flutter
   git clone https://github.com/flutter/flutter.git
   export PATH="$PATH:`pwd`/flutter/bin"
   
   # Verify installation
   flutter doctor
   ```

4. **Docker and Docker Compose**
   ```bash
   # Install Docker
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh

   # Install Docker Compose
   sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   ```

## Environment Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd school-fee-register
```

### 2. Environment Configuration

Create environment files for each service:

**Backend Services (.env)**
```bash
# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_NAME=school_fee_register
DB_USERNAME=root
DB_PASSWORD=your_password

# Eureka Server
EUREKA_SERVER_URL=http://localhost:8761

# JWT Configuration
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRATION=86400000

# Email Configuration (for notifications)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_app_password
```

**Frontend (.env)**
```bash
REACT_APP_API_BASE_URL=http://localhost:8080
REACT_APP_AUTH_ENDPOINT=http://localhost:8080/auth
```

**Mobile App (.env)**
```bash
API_BASE_URL=http://localhost:8080
AUTH_ENDPOINT=http://localhost:8080/auth
```

## Backend Deployment

### 1. Database Setup

```bash
# Start MySQL container
docker run -d \
  --name mysql-school-fee \
  -e MYSQL_ROOT_PASSWORD=your_password \
  -e MYSQL_DATABASE=school_fee_register \
  -p 3306:3306 \
  mysql:8.0

# Or use the provided docker-compose
docker-compose up -d mysql
```

### 2. Build and Deploy Services

```bash
# Build all services
./build-services.sh

# Or build individually
cd eureka-server && mvn clean package
cd ../config-server && mvn clean package
cd ../auth-service && mvn clean package
cd ../student-service && mvn clean package

cd ../fee-service && mvn clean package
cd ../notification-service && mvn clean package
cd ../homework-service && mvn clean package
cd ../reporting-service && mvn clean package
cd ../gateway-service && mvn clean package
```

### 3. Start Services in Order

```bash
# 1. Start Eureka Server
java -jar eureka-server/target/eureka-server-1.0.0.jar

# 2. Start Config Server
java -jar config-server/target/config-server-1.0.0.jar

# 3. Start Auth Service
java -jar auth-service/target/auth-service-1.0.0.jar

# 4. Start other services
java -jar student-service/target/student-service-1.0.0.jar

java -jar fee-service/target/fee-service-1.0.0.jar
java -jar notification-service/target/notification-service-1.0.0.jar
java -jar homework-service/target/homework-service-1.0.0.jar
java -jar reporting-service/target/reporting-service-1.0.0.jar

# 5. Start Gateway Service
java -jar gateway-service/target/gateway-service-1.0.0.jar
```

### 4. Using Docker Compose (Recommended)

```bash
# Start all services
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f
```

## Frontend Deployment

### 1. Build React Application

```bash
cd frontend

# Install dependencies
npm install

# Build for production
npm run build

# The build will be in the 'build' directory
```

### 2. Deploy to Web Server

**Using Nginx:**
```bash
# Install Nginx
sudo apt install nginx

# Copy build files
sudo cp -r build/* /var/www/html/

# Configure Nginx
sudo nano /etc/nginx/sites-available/school-fee-register

# Add configuration:
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

# Enable site
sudo ln -s /etc/nginx/sites-available/school-fee-register /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

**Using Docker:**
```bash
# Build Docker image
docker build -t school-fee-frontend .

# Run container
docker run -d -p 80:80 school-fee-frontend
```

## Mobile App Deployment

### 1. Android Deployment

```bash
cd mobile_app

# Get dependencies
flutter pub get

# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

**APK Location:** `build/app/outputs/flutter-apk/app-release.apk`
**AAB Location:** `build/app/outputs/bundle/release/app-release.aab`

### 2. iOS Deployment

```bash
cd mobile_app

# Get dependencies
flutter pub get

# Build for iOS
flutter build ios --release

# Open in Xcode
open ios/Runner.xcworkspace
```

### 3. Publishing to App Stores

**Google Play Store:**
1. Create developer account
2. Upload AAB file
3. Fill in app details
4. Submit for review

**Apple App Store:**
1. Create developer account
2. Archive app in Xcode
3. Upload to App Store Connect
4. Submit for review

## Production Deployment

### 1. Production Environment Setup

```bash
# Create production environment files
cp .env.example .env.production

# Update with production values
nano .env.production
```

### 2. SSL Certificate Setup

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d your-domain.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

### 3. Load Balancer Setup (Optional)

```bash
# Install HAProxy
sudo apt install haproxy

# Configure HAProxy
sudo nano /etc/haproxy/haproxy.cfg

# Add configuration for load balancing
global
    daemon

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http_front
    bind *:80
    stats uri /haproxy?stats
    default_backend http_back

backend http_back
    balance roundrobin
    server server1 localhost:8080 check
    server server2 localhost:8081 check
```

### 4. Monitoring Setup

```bash
# Install Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz
tar xvf prometheus-*.tar.gz
cd prometheus-*

# Configure Prometheus
nano prometheus.yml

# Start Prometheus
./prometheus --config.file=prometheus.yml
```

## CI/CD Pipeline Setup

### 1. GitHub Actions Workflow

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy School Fee Register

on:
  push:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Set up JDK 17
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
    - name: Run tests
      run: mvn test

  build-backend:
    needs: test
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Build backend
      run: mvn clean package -DskipTests

  build-frontend:
    needs: test
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Set up Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
    - name: Build frontend
      run: |
        cd frontend
        npm install
        npm run build

  deploy:
    needs: [build-backend, build-frontend]
    runs-on: ubuntu-latest
    steps:
    - name: Deploy to server
      run: |
        # Add deployment commands
        echo "Deploying to production..."
```

### 2. Docker Registry Setup

```bash
# Build and push Docker images
docker build -t your-registry/school-fee-backend .
docker push your-registry/school-fee-backend

docker build -t your-registry/school-fee-frontend ./frontend
docker push your-registry/school-fee-frontend
```

## Security Considerations

### 1. Database Security
```sql
-- Create dedicated user
CREATE USER 'school_fee_user'@'%' IDENTIFIED BY 'strong_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON school_fee_register.* TO 'school_fee_user'@'%';
FLUSH PRIVILEGES;
```

### 2. API Security
- Use HTTPS in production
- Implement rate limiting
- Add API key authentication
- Enable CORS properly
- Validate all inputs

### 3. Environment Variables
- Never commit secrets to version control
- Use environment-specific configuration
- Rotate secrets regularly
- Use secret management services

## Monitoring and Maintenance

### 1. Health Checks
```bash
# Check service health
curl http://localhost:8080/actuator/health

# Check Eureka status
curl http://localhost:8761/eureka/apps
```

### 2. Log Management
```bash
# View service logs
docker-compose logs -f service-name

# Set up log rotation
sudo nano /etc/logrotate.d/school-fee-register
```

### 3. Backup Strategy
```bash
# Database backup
mysqldump -u root -p school_fee_register > backup_$(date +%Y%m%d_%H%M%S).sql

# Automated backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
mysqldump -u root -p school_fee_register > /backups/backup_$DATE.sql
find /backups -name "backup_*.sql" -mtime +7 -delete
```

## Troubleshooting

### Common Issues

1. **Service Discovery Issues**
   ```bash
   # Check Eureka server
   curl http://localhost:8761/eureka/apps
   
   # Restart Eureka server
   docker-compose restart eureka-server
   ```

2. **Database Connection Issues**
   ```bash
   # Check MySQL status
   docker-compose logs mysql
   
   # Test connection
   mysql -h localhost -P 3306 -u root -p
   ```

3. **Frontend Build Issues**
   ```bash
   # Clear cache
   npm cache clean --force
   rm -rf node_modules package-lock.json
   npm install
   ```

4. **Mobile App Issues**
   ```bash
   # Flutter doctor
   flutter doctor
   
   # Clean and rebuild
   flutter clean
   flutter pub get
   flutter run
   ```

## Support and Documentation

- **API Documentation**: http://localhost:8080/swagger-ui.html
- **Eureka Dashboard**: http://localhost:8761
- **Application Logs**: Check individual service logs
- **Monitoring**: Prometheus dashboard (if configured)

## Contact

For deployment support and issues:
- Create an issue in the repository
- Contact the development team
- Check the troubleshooting section above 