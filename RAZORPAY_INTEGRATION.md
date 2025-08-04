# Razorpay Payment Gateway Integration

## Overview
The school fee management system now integrates with Razorpay, a leading payment gateway in India, to provide secure and seamless payment processing for fee payments.

## Features

### Payment Methods Supported
- ✅ Credit/Debit Cards (Visa, MasterCard, RuPay)
- ✅ UPI (Google Pay, PhonePe, Paytm, etc.)
- ✅ Net Banking (All major banks)
- ✅ Digital Wallets (Paytm, Amazon Pay, etc.)
- ✅ EMI Options
- ✅ International Cards

### Security Features
- ✅ PCI DSS Compliant
- ✅ 256-bit SSL Encryption
- ✅ Payment Signature Verification
- ✅ Secure Payment Processing
- ✅ Fraud Detection

## Backend Implementation

### Configuration
```properties
# Razorpay Configuration
razorpay.key.id=rzp_test_YOUR_TEST_KEY_ID
razorpay.key.secret=YOUR_TEST_SECRET_KEY
razorpay.currency=INR
razorpay.company.name=MySchool
razorpay.company.description=School Fee Management System
razorpay.company.logo=https://example.com/logo.png
razorpay.company.color=#1976d2
```

### Dependencies Added
```xml
<!-- Razorpay Dependencies -->
<dependency>
    <groupId>com.razorpay</groupId>
    <artifactId>razorpay-java</artifactId>
    <version>1.4.3</version>
</dependency>

<!-- Apache Commons Codec for HMAC -->
<dependency>
    <groupId>commons-codec</groupId>
    <artifactId>commons-codec</artifactId>
    <version>1.15</version>
</dependency>

<!-- JSON Processing -->
<dependency>
    <groupId>org.json</groupId>
    <artifactId>json</artifactId>
    <version>20231013</version>
</dependency>
```

### API Endpoints

#### Create Order
```
POST /api/razorpay/create-order
Content-Type: application/json

{
  "amount": 500.00,
  "currency": "INR",
  "receipt": "receipt_1234567890",
  "notes": {
    "studentName": "John Doe",
    "feeType": "TUITION_FEE",
    "remarks": "Monthly fee payment"
  },
  "studentName": "John Doe",
  "feeType": "TUITION_FEE",
  "studentId": "1",
  "feeId": "1",
  "parentId": "1"
}
```

#### Process Payment
```
POST /api/razorpay/process-payment
Content-Type: application/json

{
  "paymentId": "pay_1234567890",
  "orderId": "order_1234567890",
  "signature": "razorpay_signature",
  "feeId": "1",
  "studentId": "1",
  "parentId": "1"
}
```

#### Get Payment Status
```
GET /api/razorpay/payment-status/{paymentId}
```

#### Refund Payment
```
POST /api/razorpay/refund
Content-Type: application/json

{
  "paymentId": "pay_1234567890",
  "amount": 500.00,
  "reason": "Student withdrawal"
}
```

## Frontend Implementation

### Razorpay Script Loading
```javascript
export const loadScript = (src) => {
  return new Promise((resolve) => {
    const script = document.createElement("script");
    script.src = src;
    script.onload = () => {
      resolve(true);
    };
    script.onerror = () => {
      resolve(false);
    };
    document.body.appendChild(script);
  });
};
```

### Payment Flow
1. **User clicks PAY button**
2. **Load Razorpay script** dynamically
3. **Create order** via backend API
4. **Initialize Razorpay** with order details
5. **Open payment modal** with multiple payment options
6. **User completes payment** using preferred method
7. **Verify payment** via backend API
8. **Update fee status** and show success message

### Payment Options Configuration
```javascript
const options = {
  key: orderData.keyId,
  amount: orderData.amount * 100, // Convert to paise
  currency: orderData.currency,
  name: "MySchool",
  description: `${selectedFee.feeType} - ${selectedFee.studentName}`,
  order_id: orderData.orderId,
  handler: function (response) {
    // Payment verification logic
  },
  prefill: {
    name: selectedFee.studentName,
    email: "parent@example.com",
    contact: "9999999999"
  },
  theme: {
    color: "#1976d2"
  }
};
```

## Setup Instructions

### 1. Razorpay Account Setup
1. Sign up at [Razorpay Dashboard](https://dashboard.razorpay.com/)
2. Complete KYC verification
3. Get API keys from Dashboard → Settings → API Keys
4. Note down Key ID and Key Secret

### 2. Backend Configuration
1. Update `application.properties` with your Razorpay credentials:
   ```properties
   razorpay.key.id=rzp_test_YOUR_ACTUAL_KEY_ID
   razorpay.key.secret=YOUR_ACTUAL_SECRET_KEY
   ```

2. Restart the student service

### 3. Frontend Configuration
1. The Razorpay script is loaded dynamically
2. No additional configuration needed
3. Payment modal opens automatically

### 4. Testing
1. Use Razorpay test cards for testing:
   - **Card Number**: 4111 1111 1111 1111
   - **Expiry**: Any future date
   - **CVV**: Any 3 digits
   - **Name**: Any name

2. Use test UPI IDs:
   - **UPI ID**: success@razorpay

## Payment Flow Diagram

```
Parent → Click PAY → Load Razorpay Script → Create Order → 
Open Payment Modal → User Payment → Verify Payment → 
Update Fee Status → Show Success
```

## Security Considerations

### Payment Verification
- All payments are verified using Razorpay signature
- HMAC-SHA256 signature verification
- Prevents payment tampering

### Error Handling
- Network error handling
- Payment failure scenarios
- Timeout handling
- Retry mechanisms

### Data Protection
- No sensitive payment data stored locally
- All payment processing via Razorpay
- PCI DSS compliance maintained

## Production Deployment

### 1. Switch to Live Keys
```properties
razorpay.key.id=rzp_live_YOUR_LIVE_KEY_ID
razorpay.key.secret=YOUR_LIVE_SECRET_KEY
```

### 2. Update Webhook URLs
- Configure webhook endpoints in Razorpay dashboard
- Handle payment status updates
- Implement retry logic

### 3. SSL Certificate
- Ensure HTTPS is enabled
- Valid SSL certificate required
- Secure communication

### 4. Monitoring
- Payment success/failure rates
- Transaction monitoring
- Error logging and alerting

## Troubleshooting

### Common Issues

1. **Script Loading Failed**
   - Check internet connectivity
   - Verify script URL
   - Check browser console for errors

2. **Payment Creation Failed**
   - Verify API keys
   - Check amount format (should be in paise)
   - Validate order parameters

3. **Payment Verification Failed**
   - Check signature verification
   - Verify payment status
   - Check network connectivity

4. **Fee Status Not Updated**
   - Check database connection
   - Verify fee ID and student ID
   - Check transaction logs

### Debug Mode
Enable debug logging in `application.properties`:
```properties
logging.level.com.school.studentservice.service.RazorpayService=DEBUG
```

## Support

For Razorpay-specific issues:
- [Razorpay Documentation](https://razorpay.com/docs/)
- [Razorpay Support](https://razorpay.com/support/)

For application-specific issues:
- Check application logs
- Verify configuration
- Test with sample data 