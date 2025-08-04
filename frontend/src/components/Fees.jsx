import React, { useState, useEffect } from 'react';
import { loadScript } from '../utils/razorpay';
import {
  Box,
  Card,
  CardContent,
  Typography,
  Button,
  Grid,
  Chip,
  IconButton,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Alert,
  CircularProgress,
  Tabs,
  Tab,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Divider,
  List,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  Radio,
  RadioGroup,
  FormControlLabel,
  FormLabel
} from '@mui/material';
import {
  Payment as PaymentIcon,
  CreditCard as CreditCardIcon,
  AccountBalance as BankIcon,
  QrCode as QrCodeIcon,
  Receipt as ReceiptIcon,
  Download as DownloadIcon,
  FilterList as FilterIcon,
  Clear as ClearIcon,
  School as SchoolIcon,
  Person as PersonIcon,
  CalendarToday as CalendarIcon,
  Warning as WarningIcon,
  CheckCircle as CheckCircleIcon
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { format, isAfter, isBefore, addDays } from 'date-fns';

const Fees = ({ userRole, userId, userEmail, userPhone }) => {
  const [fees, setFees] = useState([]);
  const [students, setStudents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedTab, setSelectedTab] = useState(0);
  const [openPaymentDialog, setOpenPaymentDialog] = useState(false);
  const [selectedFee, setSelectedFee] = useState(null);
  const [selectedStudent, setSelectedStudent] = useState('');
  const [filteredFees, setFilteredFees] = useState([]);

  // Payment form state
  const [paymentForm, setPaymentForm] = useState({
    paymentMethod: 'card',
    cardNumber: '',
    cardHolderName: '',
    expiryDate: '',
    cvv: '',
    upiId: '',
    amount: '',
    remarks: ''
  });

  useEffect(() => {
    loadData();
  }, [userRole, userId, userEmail, userPhone]);

  useEffect(() => {
    filterFees();
  }, [fees, selectedStudent]);

  const loadData = async () => {
    try {
      setLoading(true);
      
      // Load students based on user role
      if (userRole === 'PARENT') {
        // Parents can see their children
        const studentsResponse = await fetch(`/api/students/parent/phone/${userPhone}`);
        if (studentsResponse.ok) {
          const studentsData = await studentsResponse.json();
          setStudents(Array.isArray(studentsData) ? studentsData : []);
        } else {
          console.error('Failed to load parent students:', studentsResponse.status);
          setStudents([]);
        }
      } else {
        // Admin can see all students
        const studentsResponse = await fetch('/api/students');
        if (studentsResponse.ok) {
          const studentsData = await studentsResponse.json();
          setStudents(Array.isArray(studentsData) ? studentsData : []);
        } else {
          console.error('Failed to load all students:', studentsResponse.status);
          setStudents([]);
        }
      }

      // Load fees based on user role
      if (userRole === 'PARENT') {
        // Parents can see their children's fees
        const feesResponse = await fetch(`/api/fees/parent/phone/${userPhone}`);
        if (feesResponse.ok) {
          const feesData = await feesResponse.json();
          setFees(Array.isArray(feesData) ? feesData : []);
        } else {
          console.error('Failed to load parent fees:', feesResponse.status);
          setFees([]);
        }
      } else {
        // Admin can see all fees
        const feesResponse = await fetch('/api/fees');
        if (feesResponse.ok) {
          const feesData = await feesResponse.json();
          setFees(Array.isArray(feesData) ? feesData : []);
        } else {
          console.error('Failed to load all fees:', feesResponse.status);
          setFees([]);
        }
      }
    } catch (err) {
      setError('Failed to load fees data');
      console.error(err);
      setStudents([]);
      setFees([]);
    } finally {
      setLoading(false);
    }
  };

  const filterFees = () => {
    if (!Array.isArray(fees)) {
      setFilteredFees([]);
      return;
    }

    let filtered = [...fees];

    if (selectedStudent) {
      filtered = filtered.filter(fee => fee.studentId === selectedStudent);
    }

    setFilteredFees(filtered);
  };

  const handlePayment = async () => {
    try {
      // Load Razorpay script
      const res = await loadScript("https://checkout.razorpay.com/v1/checkout.js");
      if (!res) {
        setError("Razorpay SDK failed to load");
        return;
      }

      // Create order
      const orderResponse = await fetch('/api/razorpay/create-order', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          amount: selectedFee.amount,
          currency: 'INR',
          receipt: `receipt_${Date.now()}`,
          notes: {
            studentName: selectedFee.studentName,
            feeType: selectedFee.feeType,
            remarks: paymentForm.remarks
          },
          studentName: selectedFee.studentName,
          feeType: selectedFee.feeType,
          studentId: selectedFee.studentId,
          feeId: selectedFee.id,
          parentId: userId
        }),
      });

      if (!orderResponse.ok) {
        setError('Failed to create payment order');
        return;
      }

      const orderData = await orderResponse.json();

      // Initialize Razorpay payment
      const options = {
        key: orderData.keyId,
        amount: orderData.amount * 100, // Convert to paise
        currency: orderData.currency,
        name: "Kidsy",
        description: `${selectedFee.feeType} - ${selectedFee.studentName}`,
        order_id: orderData.orderId,
        handler: async function (response) {
          try {
            // Verify payment
            const verifyResponse = await fetch('/api/razorpay/process-payment', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json',
              },
              body: JSON.stringify({
                paymentId: response.razorpay_payment_id,
                orderId: response.razorpay_order_id,
                signature: response.razorpay_signature,
                feeId: selectedFee.id,
                studentId: selectedFee.studentId,
                parentId: userId
              }),
            });

            if (verifyResponse.ok) {
              setOpenPaymentDialog(false);
              resetPaymentForm();
              loadData(); // Reload to show updated payment status
              alert('Payment processed successfully!');
            } else {
              setError('Payment verification failed');
            }
          } catch (err) {
            setError('Payment verification failed');
            console.error(err);
          }
        },
        prefill: {
          name: selectedFee.studentName,
          email: "parent@example.com", // You can get this from user profile
          contact: "9999999999" // You can get this from user profile
        },
        theme: {
          color: "#1976d2"
        }
      };

      const paymentObject = new window.Razorpay(options);
      paymentObject.open();
    } catch (err) {
      setError('Failed to process payment');
      console.error(err);
    }
  };

  const resetPaymentForm = () => {
    setPaymentForm({
      paymentMethod: 'card',
      cardNumber: '',
      cardHolderName: '',
      expiryDate: '',
      cvv: '',
      upiId: '',
      amount: '',
      remarks: ''
    });
    setSelectedFee(null);
  };

  const handleOpenPaymentDialog = (fee) => {
    setSelectedFee(fee);
    setPaymentForm({
      ...paymentForm,
      amount: fee.amount.toString()
    });
    setOpenPaymentDialog(true);
  };

  const getStatusColor = (status, dueDate) => {
    if (status === 'PAID') return 'success';
    if (status === 'PARTIAL') return 'warning';
    if (isBefore(new Date(dueDate), new Date())) return 'error';
    return 'primary';
  };

  const getStatusText = (status, dueDate) => {
    if (status === 'PAID') return 'Paid';
    if (status === 'PARTIAL') return 'Partial';
    if (isBefore(new Date(dueDate), new Date())) return 'Overdue';
    return 'Pending';
  };

  const generateReceipt = (fee) => {
    const receiptContent = `
Fee Receipt
===========

Student: ${fee.studentName}
Class: ${fee.className}
Fee Type: ${fee.feeType}
Amount: $${fee.amount}
Due Date: ${format(new Date(fee.dueDate), 'MMM dd, yyyy')}
Status: ${getStatusText(fee.status, fee.dueDate)}

Generated on: ${format(new Date(), 'MMM dd, yyyy HH:mm')}
    `;

    const blob = new Blob([receiptContent], { type: 'text/plain' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `Fee_Receipt_${fee.studentName}_${format(new Date(), 'yyyy-MM-dd')}.txt`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    window.URL.revokeObjectURL(url);
  };

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="400px">
        <CircularProgress />
      </Box>
    );
  }

  return (
    <LocalizationProvider dateAdapter={AdapterDateFns}>
      <Box>
        {error && (
          <Alert severity="error" sx={{ mb: 2 }} onClose={() => setError(null)}>
            {error}
          </Alert>
        )}

        {/* Header */}
        <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
          <Typography variant="h4" component="h1">
            <PaymentIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
            {userRole === 'PARENT' ? 'Children\'s Fees' : 'Fee Management'}
          </Typography>
        </Box>

        {/* Role-specific Notes */}
        {userRole === 'PARENT' && (
          <Alert severity="info" sx={{ mb: 2 }}>
            <strong>Note for Parents:</strong> You can view your children's fee dues and make payments using card or UPI. Click the PAY button to proceed with payment.
          </Alert>
        )}

        {/* Filters */}
        <Card sx={{ mb: 3 }}>
          <CardContent>
            <Grid container spacing={2} alignItems="center">
              <Grid item xs={12} sm={4}>
                <FormControl fullWidth>
                  <InputLabel>Student</InputLabel>
                  <Select
                    value={selectedStudent}
                    onChange={(e) => setSelectedStudent(e.target.value)}
                    label="Student"
                  >
                    <MenuItem value="">All Students</MenuItem>
                    {students.map((student) => (
                      <MenuItem key={student.id} value={student.id}>
                        {student.firstName} {student.lastName} - {student.className}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} sm={4}>
                <Button
                  variant="outlined"
                  onClick={() => setSelectedStudent('')}
                  startIcon={<ClearIcon />}
                  fullWidth
                >
                  Clear Filters
                </Button>
              </Grid>
            </Grid>
          </CardContent>
        </Card>

        {/* Tabs */}
        <Box sx={{ borderBottom: 1, borderColor: 'divider', mb: 2 }}>
          <Tabs value={selectedTab} onChange={(e, newValue) => setSelectedTab(newValue)}>
            <Tab label="All Fees" />
            <Tab label="Pending" />
            <Tab label="Overdue" />
            <Tab label="Paid" />
          </Tabs>
        </Box>

        {/* Fees Table */}
        <TableContainer component={Paper}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Student</TableCell>
                <TableCell>Class</TableCell>
                <TableCell>Fee Type</TableCell>
                <TableCell>Amount</TableCell>
                <TableCell>Due Date</TableCell>
                <TableCell>Status</TableCell>
                <TableCell>Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {filteredFees
                .filter(fee => {
                  if (selectedTab === 1) return fee.status === 'PENDING';
                  if (selectedTab === 2) return isBefore(new Date(fee.dueDate), new Date());
                  if (selectedTab === 3) return fee.status === 'PAID';
                  return true;
                })
                .map((fee) => (
                  <TableRow key={fee.id}>
                    <TableCell>
                      <Box display="flex" alignItems="center">
                        <PersonIcon sx={{ mr: 1, color: 'text.secondary' }} />
                        {fee.studentName}
                      </Box>
                    </TableCell>
                    <TableCell>{fee.className}</TableCell>
                    <TableCell>{fee.feeType}</TableCell>
                    <TableCell>${fee.amount}</TableCell>
                    <TableCell>{format(new Date(fee.dueDate), 'MMM dd, yyyy')}</TableCell>
                    <TableCell>
                      <Chip
                        label={getStatusText(fee.status, fee.dueDate)}
                        color={getStatusColor(fee.status, fee.dueDate)}
                        size="small"
                      />
                    </TableCell>
                    <TableCell>
                      <Box display="flex" gap={1}>
                        {userRole === 'PARENT' && fee.status !== 'PAID' && (
                          <Button
                            variant="contained"
                            size="small"
                            startIcon={<PaymentIcon />}
                            onClick={() => handleOpenPaymentDialog(fee)}
                            color="primary"
                          >
                            PAY
                          </Button>
                        )}
                        <IconButton
                          size="small"
                          onClick={() => generateReceipt(fee)}
                        >
                          <DownloadIcon />
                        </IconButton>
                      </Box>
                    </TableCell>
                  </TableRow>
                ))}
            </TableBody>
          </Table>
        </TableContainer>

        {/* Payment Dialog */}
        <Dialog open={openPaymentDialog} onClose={() => setOpenPaymentDialog(false)} maxWidth="sm" fullWidth>
          <DialogTitle>
            <Box display="flex" alignItems="center">
              <PaymentIcon sx={{ mr: 1 }} />
              Payment for {selectedFee?.studentName}
            </Box>
          </DialogTitle>
          <DialogContent>
            {selectedFee && (
              <Box mb={3}>
                <Card variant="outlined">
                  <CardContent>
                    <Typography variant="h6" gutterBottom>Fee Details</Typography>
                    <Grid container spacing={2}>
                      <Grid item xs={6}>
                        <Typography variant="body2" color="text.secondary">Student</Typography>
                        <Typography variant="body1">{selectedFee.studentName}</Typography>
                      </Grid>
                      <Grid item xs={6}>
                        <Typography variant="body2" color="text.secondary">Class</Typography>
                        <Typography variant="body1">{selectedFee.className}</Typography>
                      </Grid>
                      <Grid item xs={6}>
                        <Typography variant="body2" color="text.secondary">Fee Type</Typography>
                        <Typography variant="body1">{selectedFee.feeType}</Typography>
                      </Grid>
                      <Grid item xs={6}>
                        <Typography variant="body2" color="text.secondary">Amount</Typography>
                        <Typography variant="h6" color="primary">₹{selectedFee.amount}</Typography>
                      </Grid>
                    </Grid>
                  </CardContent>
                </Card>
              </Box>
            )}

            <Alert severity="info" sx={{ mb: 2 }}>
              <Typography variant="body2">
                You will be redirected to Razorpay's secure payment gateway to complete your transaction.
                Multiple payment options including cards, UPI, net banking, and wallets are available.
              </Typography>
            </Alert>

            <TextField
              fullWidth
              multiline
              rows={3}
              label="Remarks (Optional)"
              value={paymentForm.remarks}
              onChange={(e) => setPaymentForm({ ...paymentForm, remarks: e.target.value })}
              sx={{ mt: 2 }}
            />
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setOpenPaymentDialog(false)}>Cancel</Button>
            <Button
              onClick={handlePayment}
              variant="contained"
              startIcon={<PaymentIcon />}
            >
              Proceed to Payment
            </Button>
          </DialogActions>
        </Dialog>
      </Box>
    </LocalizationProvider>
  );
};

export default Fees; 