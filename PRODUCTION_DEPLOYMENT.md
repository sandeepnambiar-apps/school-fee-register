# 🚀 Production Deployment Guide

## 📋 Prerequisites

- **Docker & Docker Compose** installed
- **MySQL 8.0** (or use Docker)
- **Domain name** with SSL certificate
- **Cloud provider** (AWS, Azure, GCP, etc.)

## 🔧 Environment Setup

### 1. Create Environment File
```bash
# Create .env file in root directory
cp .env.example .env
```

### 2. Configure Environment Variables
```bash
# Database Configuration
DB_USERNAME=your_db_user
DB_PASSWORD=your_secure_password
MYSQL_ROOT_PASSWORD=your_root_password

# JWT Configuration
JWT_SECRET=your-super-secure-jwt-secret-key-256-bits

# API URLs
REACT_APP_API_BASE_URL=https://api.yourdomain.com
REACT_APP_AUTH_API_BASE_URL=https://auth.yourdomain.com

# Razorpay (Production Keys)
RAZORPAY_KEY_ID=rzp_live_your_live_key
RAZORPAY_KEY_SECRET=your_live_secret_key
```

## 🗄️ Database Setup

### 1. Create Production Database
```sql
-- Run the migration script
mysql -u root -p < database/migrations/V1__Create_Production_Schema.sql
```

### 2. Create Database User
```sql
CREATE USER 'schooluser'@'%' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON school_auth_db.* TO 'schooluser'@'%';
GRANT ALL PRIVILEGES ON school_fee_register.* TO 'schooluser'@'%';
FLUSH PRIVILEGES;
```

## 🐳 Docker Deployment

### 1. Build and Deploy
```bash
# Build all services
docker-compose -f docker-compose.prod.yml build

# Start services
docker-compose -f docker-compose.prod.yml up -d

# Check status
docker-compose -f docker-compose.prod.yml ps
```

### 2. Initialize Data (First Time Only)
```bash
# Access MySQL container
docker exec -it school_mysql mysql -u root -p

# Run initialization script
source /docker-entrypoint-initdb.d/V1__Create_Production_Schema.sql
```

## 🔒 Security Configuration

### 1. SSL Certificate Setup
```bash
# Install Certbot
sudo apt-get install certbot

# Get SSL certificate
sudo certbot certonly --standalone -d yourdomain.com -d www.yourdomain.com

# Copy certificates to nginx
sudo cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem ./nginx/ssl/
sudo cp /etc/letsencrypt/live/yourdomain.com/privkey.pem ./nginx/ssl/
```

### 2. Update Nginx SSL Configuration
```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com;
    
    ssl_certificate /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;
    
    # SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512;
    ssl_prefer_server_ciphers off;
}
```

## 📊 Monitoring Setup

### 1. Health Checks
```bash
# Check service health
curl https://yourdomain.com/health
curl https://api.yourdomain.com/actuator/health
curl https://auth.yourdomain.com/actuator/health
```

### 2. Log Monitoring
```bash
# View logs
docker-compose -f docker-compose.prod.yml logs -f

# View specific service logs
docker-compose -f docker-compose.prod.yml logs -f auth-service
docker-compose -f docker-compose.prod.yml logs -f student-service
```

## 🔄 Backup Strategy

### 1. Database Backup
```bash
# Create backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker exec school_mysql mysqldump -u root -p school_auth_db > backup/auth_db_$DATE.sql
docker exec school_mysql mysqldump -u root -p school_fee_register > backup/fee_db_$DATE.sql
```

### 2. Automated Backups
```bash
# Add to crontab (daily backup at 2 AM)
0 2 * * * /path/to/backup_script.sh
```

## 🚨 Troubleshooting

### Common Issues

1. **Database Connection Failed**
   ```bash
   # Check MySQL container
   docker logs school_mysql
   
   # Test connection
   docker exec -it school_mysql mysql -u schooluser -p
   ```

2. **Services Not Starting**
   ```bash
   # Check service logs
   docker-compose -f docker-compose.prod.yml logs
   
   # Restart services
   docker-compose -f docker-compose.prod.yml restart
   ```

3. **SSL Certificate Issues**
   ```bash
   # Renew certificate
   sudo certbot renew
   
   # Restart nginx
   docker-compose -f docker-compose.prod.yml restart nginx
   ```

## 📈 Performance Optimization

### 1. Database Optimization
```sql
-- Add indexes for better performance
CREATE INDEX idx_student_fee_status ON student_fees(status);
CREATE INDEX idx_payment_date ON payments(payment_date);
CREATE INDEX idx_notification_recipient ON notifications(recipient_type, recipient_id);
```

### 2. Application Optimization
- Enable Hibernate second-level cache
- Configure connection pooling
- Enable Gzip compression
- Use CDN for static assets

## 🔄 Update Process

### 1. Application Updates
```bash
# Pull latest code
git pull origin main

# Rebuild and deploy
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml build --no-cache
docker-compose -f docker-compose.prod.yml up -d
```

### 2. Database Migrations
```bash
# Run new migrations
docker exec -it school_mysql mysql -u root -p < database/migrations/V2__New_Migration.sql
```

## 📞 Support

For production issues:
1. Check application logs
2. Monitor system resources
3. Verify database connectivity
4. Check SSL certificate validity
5. Review security configurations

## ✅ Production Checklist

- [ ] Environment variables configured
- [ ] Database created and migrated
- [ ] SSL certificates installed
- [ ] Security headers configured
- [ ] Monitoring setup
- [ ] Backup strategy implemented
- [ ] Performance optimized
- [ ] Error handling configured
- [ ] Logging configured
- [ ] Health checks working 