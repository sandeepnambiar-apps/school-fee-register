# Fees & Payment Feature

## Overview
The enhanced Fees feature allows parents to view their children's fee dues and make payments using card or UPI transactions. The system provides a comprehensive fee management interface with payment processing capabilities.

## Features

### For Parents:
- ✅ View their children's fee dues
- ✅ Make payments using credit/debit cards
- ✅ Make payments using UPI
- ✅ Download fee receipts
- ✅ Filter fees by student
- ✅ View payment status (Pending, Partial, Paid, Overdue)
- ✅ Track payment history

### For Admin:
- ✅ View all student fees
- ✅ Manage fee structure
- ✅ Track payment status
- ✅ Generate fee reports
- ✅ Monitor overdue payments

## Database Schema

### fees Table
```sql
CREATE TABLE fees (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    class_id BIGINT NOT NULL,
    fee_type ENUM('TUITION_FEE', 'TRANSPORT_FEE', 'LIBRARY_FEE', 'LABORATORY_FEE', 'SPORTS_FEE', 'EXAMINATION_FEE', 'MISCELLANEOUS_FEE') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    due_date DATE NOT NULL,
    status ENUM('PENDING', 'PARTIAL', 'PAID', 'OVERDUE') NOT NULL DEFAULT 'PENDING',
    paid_amount DECIMAL(10,2) DEFAULT 0.00,
    remarks VARCHAR(500),
    created_at DATE DEFAULT CURRENT_DATE,
    updated_at DATE DEFAULT CURRENT_DATE ON UPDATE CURRENT_DATE
);
```

## API Endpoints

### Fee Management
- `GET /api/fees` - Get all fees
- `GET /api/fees/{id}` - Get fee by ID
- `GET /api/fees/student/{studentId}` - Get fees by student
- `GET /api/fees/parent/{parentId}` - Get fees by parent
- `GET /api/fees/class/{classId}` - Get fees by class
- `GET /api/fees/type/{feeType}` - Get fees by type
- `GET /api/fees/status/{status}` - Get fees by status
- `GET /api/fees/overdue` - Get overdue fees
- `GET /api/fees/pending` - Get pending fees
- `GET /api/fees/partial` - Get partial paid fees
- `POST /api/fees` - Create new fee
- `PUT /api/fees/{id}` - Update fee
- `DELETE /api/fees/{id}` - Delete fee

### Payment Processing
- `POST /api/payments` - Process payment

## Frontend Components

### Fees.jsx
Main component that provides:
- **Tabbed Interface**: All Fees, Pending, Overdue, Paid
- **Payment Dialog**: Card and UPI payment options
- **Role-based Access**: Different views for admin vs parents
- **Filtering**: By student
- **Receipt Generation**: Download fee receipts
- **Payment Processing**: Secure payment gateway integration

## Payment Methods

### Credit/Debit Card
- Card number validation
- Expiry date validation
- CVV validation
- Card holder name
- Secure payment processing

### UPI Payment
- UPI ID validation
- QR code display
- Mobile app integration
- Instant payment processing

## Fee Types
- **Tuition Fee**: Regular academic fees
- **Transport Fee**: Bus/transportation charges
- **Library Fee**: Library membership and usage
- **Laboratory Fee**: Science/computer lab charges
- **Sports Fee**: Sports facility usage
- **Examination Fee**: Test and exam charges
- **Miscellaneous Fee**: Other school charges

## Payment Status
- **Pending**: Fee not yet paid
- **Partial**: Partially paid
- **Paid**: Fully paid
- **Overdue**: Past due date

## Role-based Access Control

### Parent
- Can view their children's fees only
- Can make payments for pending fees
- Can download receipts
- Cannot access other students' data

### Admin
- Can view all student fees
- Can manage fee structure
- Can track all payments
- Full administrative access

## Payment Flow

1. **Parent Login**: Parent logs into the system
2. **View Fees**: Parent sees their children's fee dues
3. **Select Fee**: Parent clicks PAY button for a specific fee
4. **Payment Dialog**: Payment method selection dialog opens
5. **Payment Details**: Parent enters card/UPI details
6. **Payment Processing**: System processes the payment
7. **Confirmation**: Payment confirmation and receipt generation
8. **Status Update**: Fee status updated to PAID

## Security Features
- Role-based access control
- Payment data encryption
- Secure payment gateway
- Audit trail for all transactions
- Input validation and sanitization

## Sample Data
The system includes sample fee data for testing:
- 18 sample fee entries across different students
- Various fee types (Tuition, Transport, Library, etc.)
- Different payment statuses (Pending, Paid, Partial)
- Realistic amounts and due dates

## Setup Instructions

1. **Database Setup**:
   ```bash
   # Run the fees.sql script
   mysql -u root -p school_fee_register < database/fees.sql
   ```

2. **Backend Setup**:
   - Ensure all Java files are in the correct packages
   - Restart the student service
   - Verify API endpoints are accessible

3. **Frontend Setup**:
   - The Fees component is automatically imported
   - Payment functionality is integrated
   - Role-based access is configured

## Payment Gateway Integration

### Card Payment
- Supports major credit/debit cards
- Real-time validation
- Secure transaction processing
- Payment confirmation

### UPI Payment
- Supports all UPI apps (Google Pay, PhonePe, etc.)
- QR code generation
- Instant payment verification
- Transaction status tracking

## Receipt Generation
Parents can download detailed receipts including:
- Student information
- Fee details
- Payment information
- Transaction ID
- Date and time stamp

## Future Enhancements
- Multiple payment gateway support
- Payment installment options
- Automated payment reminders
- Email/SMS notifications
- Payment analytics dashboard
- Mobile app integration
- Bulk payment processing
- Fee waiver management 