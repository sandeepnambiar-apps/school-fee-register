import React, { useState, useEffect } from 'react';
import { 
  Container, 
  Typography, 
  Button, 
  Box, 
  Card, 
  CardContent, 
  Grid, 
  Tabs, 
  Tab,
  Chip,
  IconButton,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Alert,
  CircularProgress,
  LinearProgress,
  Divider,
  List,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  Switch,
  Accordion,
  AccordionSummary,
  AccordionDetails,
  Tooltip,
  ButtonGroup
} from '@mui/material';
import { 
  Add as AddIcon,
  School as SchoolIcon,
  DirectionsBus as BusIcon,
  Payment as PaymentIcon,
  Assessment as AssessmentIcon,
  Settings as SettingsIcon,
  Search as SearchIcon,
  FilterList as FilterIcon,
  Download as DownloadIcon,
  Print as PrintIcon,
  Receipt as ReceiptIcon,
  Warning as WarningIcon,
  CheckCircle as CheckCircleIcon,
  Schedule as ScheduleIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  ExpandMore as ExpandMoreIcon,
  Person as PersonIcon,
  Class as ClassIcon,
  Category as CategoryIcon
} from '@mui/icons-material';
import TransportFeeDashboard from './TransportFee/TransportFeeDashboard';
import { feeAPI } from '../services/api';
import { useAuth } from '../contexts/AuthContext';
import { loadScript } from '../utils/razorpay';

// Declare Razorpay types
declare global {
  interface Window {
    Razorpay: any;
  }
}

interface StudentFee {
  studentId: number;
  studentName: string;
  class: string;
  section: string;
  admissionNumber: string;
  fees: {
    tuition: { total: number; paid: number; pending: number; dueDate: string; status: string; };
    library: { total: number; paid: number; pending: number; dueDate: string; status: string; };
    laboratory: { total: number; paid: number; pending: number; dueDate: string; status: string; };
    sports: { total: number; paid: number; pending: number; dueDate: string; status: string; };
  };
  totalFees: number;
  totalPaid: number;
  totalPending: number;
  overallStatus: string;
}

interface FeeStructure {
  id: number;
  name: string;
  description: string;
  amount: number;
  frequency: 'MONTHLY' | 'QUARTERLY' | 'SEMESTER' | 'ANNUAL';
  classId: number;
  className: string;
  categoryId: number;
  categoryName: string;
  academicYearId: number;
  academicYear: string;
  dueDate: string;
  isActive: boolean;
  createdAt: string;
}

interface FeeCategory {
  id: number;
  name: string;
  description: string;
  amount: number;
  frequency: string;
  status: string;
  color: string;
}

interface Class {
  id: number;
  name: string;
  section: string;
}

const Fees = () => {
  const { user } = useAuth();
  const [selectedTab, setSelectedTab] = useState(0);
  const userRole = user?.role || 'STUDENT';
  const userId = user?.id || 1;
  const [loading, setLoading] = useState(false);
  const [studentFees, setStudentFees] = useState<StudentFee[]>([]);
  const [selectedStudent, setSelectedStudent] = useState<StudentFee | null>(null);
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [openPaymentDialog, setOpenPaymentDialog] = useState(false);
  const [processingPayment, setProcessingPayment] = useState(false);
  
  // Fee Structure Management States
  const [openFeeStructureDialog, setOpenFeeStructureDialog] = useState(false);
  const [openStudentFeeDialog, setOpenStudentFeeDialog] = useState(false);
  const [editingFeeStructure, setEditingFeeStructure] = useState<FeeStructure | null>(null);
  const [editingStudentFee, setEditingStudentFee] = useState<StudentFee | null>(null);
  const [feeStructures, setFeeStructures] = useState<FeeStructure[]>([]);
  const [classes, setClasses] = useState<Class[]>([]);
  const [selectedClass, setSelectedClass] = useState<number | ''>('');
  const [viewMode, setViewMode] = useState<'overview' | 'class-wise' | 'student-wise'>('overview');
  const [savingFeeStructure, setSavingFeeStructure] = useState(false);

  // Form states for fee structure
  const [feeStructureForm, setFeeStructureForm] = useState({
    amount: '',
    frequency: 'MONTHLY' as FeeStructure['frequency'],
    classId: '',
    feeCategoryId: '',
    academicYearId: '',
    dueDate: '',
    isActive: true
  });

  useEffect(() => {
    loadStudentFees();
    loadFeeStructures();
    loadClasses();
  }, []);

  const loadStudentFees = async () => {
    setLoading(true);
    
    // Mock data - replace with API call
    let mockStudentFees = [
      {
        studentId: 1,
        studentName: 'John Doe',
        class: 'Class 10',
        section: 'A',
        admissionNumber: 'STU2024001',
        fees: {
          tuition: {
            total: 5000,
            paid: 4000,
            pending: 1000,
            dueDate: '2024-01-31',
            status: 'partial'
          },
          library: {
            total: 500,
            paid: 500,
            pending: 0,
            dueDate: '2024-01-15',
            status: 'paid'
          },
          laboratory: {
            total: 1000,
            paid: 0,
            pending: 1000,
            dueDate: '2024-02-15',
            status: 'pending'
          },
          sports: {
            total: 800,
            paid: 800,
            pending: 0,
            dueDate: '2024-01-20',
            status: 'paid'
          }
        },
        totalFees: 7300,
        totalPaid: 5300,
        totalPending: 2000,
        overallStatus: 'partial'
      },
      {
        studentId: 2,
        studentName: 'Jane Smith',
        class: 'Class 9',
        section: 'B',
        admissionNumber: 'STU2024002',
        fees: {
          tuition: {
            total: 4500,
            paid: 4500,
            pending: 0,
            dueDate: '2024-01-31',
            status: 'paid'
          },
          library: {
            total: 500,
            paid: 0,
            pending: 500,
            dueDate: '2024-01-15',
            status: 'overdue'
          },
          laboratory: {
            total: 1000,
            paid: 1000,
            pending: 0,
            dueDate: '2024-02-15',
            status: 'paid'
          },
          sports: {
            total: 800,
            paid: 0,
            pending: 800,
            dueDate: '2024-01-20',
            status: 'overdue'
          }
        },
        totalFees: 6800,
        totalPaid: 5500,
        totalPending: 1300,
        overallStatus: 'partial'
      }
    ];

    // Filter students based on user role
    if (userRole === 'PARENT') {
      // For parents, show only their children (mock: show first 2 students as example)
      // In real implementation, this would filter based on parentId
      mockStudentFees = mockStudentFees.slice(0, 2);
    } else if (userRole === 'STUDENT') {
      // For students, show only their own fee
      // In real implementation, this would filter based on studentId
      mockStudentFees = mockStudentFees.slice(0, 1);
    }
            // For SUPER_ADMIN and SCHOOL_ADMIN roles, show all students

    setStudentFees(mockStudentFees);
    setLoading(false);
  };

  const loadFeeStructures = async () => {
    try {
      const response = await feeAPI.getFeeStructures();
      setFeeStructures(response);
    } catch (error) {
      console.error('Error loading fee structures:', error);
      // Fallback to mock data if API fails
      const mockFeeStructures: FeeStructure[] = [
        {
          id: 1,
          name: 'Class 10 Tuition Fee',
          description: 'Monthly tuition fee for Class 10 students',
          amount: 5000,
          frequency: 'MONTHLY',
          classId: 10,
          className: 'Class 10',
          categoryId: 1,
          categoryName: 'Tuition Fee',
          academicYearId: 1,
          academicYear: '2024-2025',
          dueDate: '2024-01-31',
          isActive: true,
          createdAt: '2024-01-01'
        },
        {
          id: 2,
          name: 'Class 9 Library Fee',
          description: 'Annual library fee for Class 9 students',
          amount: 500,
          frequency: 'ANNUAL',
          classId: 9,
          className: 'Class 9',
          categoryId: 2,
          categoryName: 'Library Fee',
          academicYearId: 1,
          academicYear: '2024-2025',
          dueDate: '2024-01-15',
          isActive: true,
          createdAt: '2024-01-01'
        }
      ];
      setFeeStructures(mockFeeStructures);
    }
  };

  const loadClasses = async () => {
    // Mock data - replace with API call
    const mockClasses: Class[] = [
      { id: 1, name: 'Class 1', section: 'A' },
      { id: 2, name: 'Class 2', section: 'A' },
      { id: 3, name: 'Class 3', section: 'A' },
      { id: 4, name: 'Class 4', section: 'A' },
      { id: 5, name: 'Class 5', section: 'A' },
      { id: 6, name: 'Class 6', section: 'A' },
      { id: 7, name: 'Class 7', section: 'A' },
      { id: 8, name: 'Class 8', section: 'A' },
      { id: 9, name: 'Class 9', section: 'A' },
      { id: 10, name: 'Class 10', section: 'A' }
    ];
    setClasses(mockClasses);
  };

  const handleTabChange = (event: React.SyntheticEvent, newValue: number) => {
    setSelectedTab(newValue);
  };

  const handlePayment = async (student: StudentFee, category?: string) => {
    setSelectedStudent(student);
    setSelectedCategory(category || null);
    
    if (userRole === 'PARENT') {
      // Use Razorpay for parent payments
      await initiateRazorpayPayment(student, category);
    } else {
      // Use regular dialog for admin payments
      setOpenPaymentDialog(true);
    }
  };

  const initiateRazorpayPayment = async (student: StudentFee, category?: string) => {
    try {
      setProcessingPayment(true);
      
      // Load Razorpay script
      const scriptLoaded = await loadScript("https://checkout.razorpay.com/v1/checkout.js");
      if (!scriptLoaded) {
        alert("Failed to load Razorpay. Please check your internet connection.");
        return;
      }

      // Get fee details
      const feeDetails = category ? student.fees[category as keyof typeof student.fees] : null;
      const amount = category && feeDetails ? feeDetails.pending : student.totalPending;
      const feeType = category ? category.toUpperCase() : 'ALL_FEES';

      // Create order
      const orderData = {
        amount: amount * 100, // Convert to paise
        currency: "INR",
        receipt: `receipt_${Date.now()}`,
        notes: {
          studentName: student.studentName,
          feeType: feeType,
          remarks: `${feeType} fee payment for ${student.studentName}`
        },
        studentName: student.studentName,
        feeType: feeType,
        studentId: student.studentId.toString(),
        feeId: category || 'all',
        parentId: userId.toString()
      };

      console.log('Creating Razorpay order:', orderData);

      // Call backend to create order
      const response = await fetch('/api/razorpay/create-order', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(orderData)
      });

      if (!response.ok) {
        throw new Error('Failed to create payment order');
      }

      const orderResponse = await response.json();
      console.log('Order created:', orderResponse);

      // Initialize Razorpay
      const options = {
        key: orderResponse.keyId,
        amount: orderResponse.amount * 100, // Convert to paise
        currency: orderResponse.currency,
        name: "Kidsy",
        description: `${feeType} - ${student.studentName}`,
        order_id: orderResponse.orderId,
        handler: function (response: any) {
          handlePaymentSuccess(response, student, category);
        },
        prefill: {
          name: student.studentName,
          email: "parent@school.com",
          contact: "9999999999"
        },
        theme: {
          color: "#1976d2"
        },
        modal: {
          ondismiss: function() {
            setProcessingPayment(false);
          }
        }
      };

      // Open Razorpay modal
      const rzp = new window.Razorpay(options);
      rzp.open();

    } catch (error) {
      console.error('Payment initiation failed:', error);
      alert('Payment initiation failed. Please try again.');
      setProcessingPayment(false);
    }
  };

  const handlePaymentSuccess = async (response: any, student: StudentFee, category?: string) => {
    try {
      console.log('Payment successful:', response);

      // Process payment on backend
      const paymentData = {
        paymentId: response.razorpay_payment_id,
        orderId: response.razorpay_order_id,
        signature: response.razorpay_signature,
        feeId: category || 'all',
        studentId: student.studentId.toString(),
        parentId: userId.toString()
      };

      const processResponse = await fetch('/api/razorpay/process-payment', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(paymentData)
      });

      if (!processResponse.ok) {
        throw new Error('Failed to process payment');
      }

      const result = await processResponse.json();
      console.log('Payment processed:', result);

      // Show success message
      alert(`Payment successful! Payment ID: ${response.razorpay_payment_id}`);
      
      // Reload student fees to reflect updated status
      loadStudentFees();
      
    } catch (error) {
      console.error('Payment processing failed:', error);
      alert('Payment processing failed. Please contact support.');
    } finally {
      setProcessingPayment(false);
    }
  };

  const handleAddFeeStructure = () => {
    setEditingFeeStructure(null);
    setFeeStructureForm({
      amount: '',
      frequency: 'MONTHLY',
      classId: '',
      feeCategoryId: '',
      academicYearId: '',
      dueDate: '',
      isActive: true
    });
    setOpenFeeStructureDialog(true);
  };

  const handleEditFeeStructure = (feeStructure: FeeStructure) => {
    setEditingFeeStructure(feeStructure);
    setFeeStructureForm({
      amount: feeStructure.amount.toString(),
      frequency: feeStructure.frequency,
      classId: feeStructure.classId.toString(),
      feeCategoryId: feeStructure.categoryId.toString(),
      academicYearId: feeStructure.academicYearId.toString(),
      dueDate: feeStructure.dueDate,
      isActive: feeStructure.isActive
    });
    setOpenFeeStructureDialog(true);
  };

  const handleEditStudentFee = (student: StudentFee) => {
    setEditingStudentFee(student);
    setOpenStudentFeeDialog(true);
  };

  const handleSaveFeeStructure = async () => {
    try {
      setSavingFeeStructure(true);
      
      // Validate form
      if (!feeStructureForm.amount || !feeStructureForm.classId || !feeStructureForm.feeCategoryId || !feeStructureForm.academicYearId) {
        alert('Please fill in all required fields');
        return;
      }

      // Validate amount
      const amount = parseFloat(feeStructureForm.amount);
      if (isNaN(amount) || amount <= 0) {
        alert('Please enter a valid amount');
        return;
      }

      const feeStructureData = {
        classId: parseInt(feeStructureForm.classId),
        feeCategoryId: parseInt(feeStructureForm.feeCategoryId),
        academicYearId: parseInt(feeStructureForm.academicYearId),
        amount: amount,
        frequency: feeStructureForm.frequency,
        dueDate: feeStructureForm.dueDate || null,
        isActive: feeStructureForm.isActive
      };

      console.log('Sending fee structure data:', feeStructureData);

      if (editingFeeStructure) {
        // Update existing fee structure
        await feeAPI.updateFeeStructure(editingFeeStructure.id, feeStructureData);
      } else {
        // Create new fee structure
        await feeAPI.createFeeStructure(feeStructureData);
      }

      setOpenFeeStructureDialog(false);
      loadFeeStructures(); // Reload data
    } catch (error) {
      console.error('Error saving fee structure:', error);
      if (error instanceof Error) {
        console.error('Error details:', {
          name: error.name,
          message: error.message,
          stack: error.stack
        });
      }
      const errorMessage = error instanceof Error ? error.message : 'Unknown error';
      alert(`Error saving fee structure: ${errorMessage}`);
    } finally {
      setSavingFeeStructure(false);
    }
  };

  const handleDeleteFeeStructure = async (id: number) => {
    if (window.confirm('Are you sure you want to delete this fee structure?')) {
      try {
        await feeAPI.deleteFeeStructure(id);
        loadFeeStructures(); // Reload data
      } catch (error) {
        console.error('Error deleting fee structure:', error);
        alert('Error deleting fee structure');
      }
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'paid': return 'success';
      case 'partial': return 'warning';
      case 'pending': return 'info';
      case 'overdue': return 'error';
      default: return 'default';
    }
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'paid': return <CheckCircleIcon />;
      case 'partial': return <ScheduleIcon />;
      case 'pending': return <WarningIcon />;
      case 'overdue': return <WarningIcon />;
      default: return <WarningIcon />;
    }
  };

  const feeCategories = [
    {
      id: 1,
      name: 'Tuition Fee',
      description: 'Regular academic tuition fees',
      amount: 5000,
      frequency: 'Monthly',
      status: 'Active',
      color: '#1976d2'
    },
    {
      id: 2,
      name: 'Library Fee',
      description: 'Library and resource fees',
      amount: 500,
      frequency: 'Annual',
      status: 'Active',
      color: '#388e3c'
    },
    {
      id: 3,
      name: 'Laboratory Fee',
      description: 'Science lab and equipment fees',
      amount: 1000,
      frequency: 'Annual',
      status: 'Active',
      color: '#f57c00'
    },
    {
      id: 4,
      name: 'Sports Fee',
      description: 'Sports and physical education fees',
      amount: 800,
      frequency: 'Annual',
      status: 'Active',
      color: '#7b1fa2'
    }
  ];

  return (
    <Container maxWidth="xl">
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">
          <PaymentIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
          Fee Management System
        </Typography>
        {selectedTab === 0 && (userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN') && (
          <Button
            variant="contained"
            startIcon={<AddIcon />}
            onClick={handleAddFeeStructure}
          >
            Add Fee Structure
          </Button>
        )}
      </Box>

      {/* Tab Navigation */}
      <Box sx={{ borderBottom: 1, borderColor: 'divider', mb: 3 }}>
        <Tabs value={selectedTab} onChange={handleTabChange}>
          <Tab 
            label={
              <Box display="flex" alignItems="center" gap={1}>
                <SchoolIcon />
                School Fees
              </Box>
            } 
          />
          <Tab 
            label={
              <Box display="flex" alignItems="center" gap={1}>
                <BusIcon />
                Transport Fees
              </Box>
            } 
          />
        </Tabs>
      </Box>

      {/* Tab Content */}
      {selectedTab === 0 && (
        <Box>
          {/* View Mode Toggle - Show for SUPER_ADMIN, SCHOOL_ADMIN and PARENT roles */}
          {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN' || userRole === 'PARENT') && (
            <Box sx={{ mb: 3 }}>
              <ButtonGroup variant="outlined" size="small">
                <Button 
                  variant={viewMode === 'overview' ? 'contained' : 'outlined'}
                  onClick={() => setViewMode('overview')}
                  startIcon={<AssessmentIcon />}
                >
                  Overview
                </Button>
                <Button 
                  variant={viewMode === 'class-wise' ? 'contained' : 'outlined'}
                  onClick={() => setViewMode('class-wise')}
                  startIcon={<ClassIcon />}
                >
                  Class-wise
                </Button>
                <Button 
                  variant={viewMode === 'student-wise' ? 'contained' : 'outlined'}
                  onClick={() => setViewMode('student-wise')}
                  startIcon={<PersonIcon />}
                >
                  Student-wise
                </Button>
              </ButtonGroup>
            </Box>
          )}

          {/* Message for TEACHER role */}
          {userRole === 'TEACHER' && (
            <Card sx={{ mb: 3 }}>
              <CardContent>
                <Box display="flex" alignItems="center" justifyContent="center" py={4}>
                  <Box textAlign="center">
                    <SchoolIcon sx={{ fontSize: 64, color: 'text.secondary', mb: 2 }} />
                    <Typography variant="h6" color="text.secondary" gutterBottom>
                      Fee Management Access Restricted
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      Teachers do not have access to fee management features. 
                      Please contact the administration for fee-related queries.
                    </Typography>
                  </Box>
                </Box>
              </CardContent>
            </Card>
          )}

          {viewMode === 'overview' && userRole !== 'TEACHER' && (
            <>
                              {/* Fee Structure Overview - Hide for TEACHER role */}
          <Card sx={{ mb: 3 }}>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                <SchoolIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
                School Fee Structure
              </Typography>
              <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                Manage academic fees, library fees, laboratory fees, and other school-related charges.
              </Typography>
              
              <Grid container spacing={2}>
                {feeCategories.map((category) => (
                  <Grid item xs={12} sm={6} md={3} key={category.id}>
                    <Card variant="outlined" sx={{ borderColor: category.color }}>
                      <CardContent>
                        <Box display="flex" justifyContent="space-between" alignItems="center" mb={1}>
                          <Typography variant="h6" component="div" color={category.color}>
                            {category.name}
                          </Typography>
                          <Chip 
                            label={category.status} 
                            size="small" 
                            color={category.status === 'Active' ? 'success' : 'default'}
                          />
                        </Box>
                        <Typography variant="h5" component="div" sx={{ mb: 1 }}>
                          ₹{category.amount}
                        </Typography>
                        <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                          {category.description}
                        </Typography>
                        <Typography variant="caption" color="text.secondary">
                          Frequency: {category.frequency}
                        </Typography>
                      </CardContent>
                    </Card>
                  </Grid>
                ))}
              </Grid>
            </CardContent>
          </Card>
            </>
          )}

          {viewMode === 'class-wise' && userRole !== 'TEACHER' && (
            <Card sx={{ mb: 3 }}>
              <CardContent>
                <Typography variant="h6" gutterBottom>
                  <ClassIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
                  Class-wise Fee Structures
                </Typography>
                
                <FormControl sx={{ minWidth: 200, mb: 2 }}>
                  <InputLabel>Select Class</InputLabel>
                  <Select
                    value={selectedClass}
                    onChange={(e) => setSelectedClass(e.target.value as number | '')}
                    label="Select Class"
                  >
                    <MenuItem value="">All Classes</MenuItem>
                    {classes.map((cls) => (
                      <MenuItem key={cls.id} value={cls.id}>
                        {cls.name}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>

                <TableContainer component={Paper}>
                  <Table>
                    <TableHead>
                      <TableRow>
                        <TableCell>Name</TableCell>
                        <TableCell>Class</TableCell>
                        <TableCell>Category</TableCell>
                        <TableCell>Amount</TableCell>
                        <TableCell>Frequency</TableCell>
                        <TableCell>Due Date</TableCell>
                        <TableCell>Status</TableCell>
                        <TableCell>Actions</TableCell>
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {feeStructures
                        .filter(fs => !selectedClass || fs.classId === selectedClass)
                        .map((feeStructure) => (
                        <TableRow key={feeStructure.id}>
                          <TableCell>{feeStructure.name}</TableCell>
                          <TableCell>{feeStructure.className}</TableCell>
                          <TableCell>{feeStructure.categoryName}</TableCell>
                          <TableCell>₹{feeStructure.amount}</TableCell>
                          <TableCell>{feeStructure.frequency}</TableCell>
                          <TableCell>{feeStructure.dueDate}</TableCell>
                          <TableCell>
                            <Chip 
                              label={feeStructure.isActive ? 'Active' : 'Inactive'} 
                              color={feeStructure.isActive ? 'success' : 'default'}
                              size="small"
                            />
                          </TableCell>
                          <TableCell>
                            <Tooltip title="Edit">
                              <IconButton 
                                size="small" 
                                onClick={() => handleEditFeeStructure(feeStructure)}
                              >
                                <EditIcon />
                              </IconButton>
                            </Tooltip>
                            <Tooltip title="Delete">
                              <IconButton 
                                size="small" 
                                color="error"
                                onClick={() => handleDeleteFeeStructure(feeStructure.id)}
                              >
                                <DeleteIcon />
                              </IconButton>
                            </Tooltip>
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                </TableContainer>
              </CardContent>
            </Card>
          )}



          {viewMode === 'student-wise' && userRole !== 'TEACHER' && (
            <>
                              {/* Student Fee Tracking - Hide for TEACHER role */}
          <Card sx={{ mb: 3 }}>
            <CardContent>
              <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
                <Typography variant="h6" gutterBottom>
                  <AssessmentIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
                  Student Fee Tracking
                </Typography>
                <Box display="flex" gap={1}>
                  <TextField
                    size="small"
                    placeholder="Search students..."
                    InputProps={{
                      startAdornment: <SearchIcon sx={{ mr: 1, color: 'text.secondary' }} />
                    }}
                  />
                      <Button
                        variant="outlined"
                        startIcon={<FilterIcon />}
                        size="small"
                      >
                    Filter
                  </Button>
                </Box>
              </Box>

              {loading ? (
                    <LinearProgress />
              ) : (
                    <TableContainer component={Paper}>
                  <Table>
                    <TableHead>
                      <TableRow>
                        <TableCell>Student</TableCell>
                        <TableCell>Class</TableCell>
                            <TableCell>Total Fees</TableCell>
                            <TableCell>Paid</TableCell>
                            <TableCell>Pending</TableCell>
                        <TableCell>Status</TableCell>
                        <TableCell>Actions</TableCell>
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {studentFees.map((student) => (
                        <React.Fragment key={student.studentId}>
                          {/* Main Student Row */}
                          <TableRow>
                            <TableCell>
                              <Box>
                                <Typography variant="subtitle2">
                                  {student.studentName}
                                </Typography>
                                <Typography variant="caption" color="text.secondary">
                                  {student.admissionNumber}
                                </Typography>
                              </Box>
                            </TableCell>
                            <TableCell>{student.class} - {student.section}</TableCell>
                            <TableCell>₹{student.totalFees}</TableCell>
                            <TableCell>₹{student.totalPaid}</TableCell>
                            <TableCell>₹{student.totalPending}</TableCell>
                            <TableCell>
                              <Chip 
                                icon={getStatusIcon(student.overallStatus)}
                                label={student.overallStatus.toUpperCase()}
                                color={getStatusColor(student.overallStatus) as any}
                                size="small" 
                              />
                            </TableCell>
                            <TableCell>
                              <Box display="flex" gap={1}>
                                                              {/* PAY button - Only show for PARENT role */}
                              {userRole === 'PARENT' && (
                                <Tooltip title="Pay All Fees">
                                  <IconButton 
                                    size="small" 
                                    color="primary"
                                    onClick={() => handlePayment(student)}
                                    disabled={processingPayment}
                                  >
                                    {processingPayment ? <CircularProgress size={16} /> : <PaymentIcon />}
                                  </IconButton>
                                </Tooltip>
                              )}
                                {/* Edit button - Only show for SUPER_ADMIN and SCHOOL_ADMIN roles */}
                                {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN') && (
                                  <Tooltip title="Edit Fees">
                                    <IconButton 
                                      size="small" 
                                      color="secondary"
                                      onClick={() => handleEditStudentFee(student)}
                                    >
                                      <EditIcon />
                                    </IconButton>
                                  </Tooltip>
                                )}
                              </Box>
                            </TableCell>
                          </TableRow>
                          
                          {/* Detailed Fee Categories Row - Only show for PARENT role */}
                          {userRole === 'PARENT' && (
                            <TableRow>
                              <TableCell colSpan={7}>
                                <Box sx={{ pl: 2, pr: 2, pb: 2 }}>
                                  <Typography variant="subtitle2" gutterBottom sx={{ mt: 1, mb: 1 }}>
                                    Fee Categories:
                                  </Typography>
                                  <Grid container spacing={2}>
                                    {Object.entries(student.fees).map(([category, fee]) => (
                                      <Grid item xs={12} sm={6} md={3} key={category}>
                                        <Card variant="outlined" sx={{ 
                                          borderColor: fee.status === 'PAID' ? 'success.main' : 
                                                      fee.status === 'PENDING' ? 'warning.main' : 'error.main'
                                        }}>
                                          <CardContent sx={{ p: 2 }}>
                                            <Box display="flex" justifyContent="space-between" alignItems="center" mb={1}>
                                              <Typography variant="subtitle2" sx={{ textTransform: 'capitalize' }}>
                                                {category} Fee
                                              </Typography>
                                              <Chip 
                                                label={fee.status.toUpperCase()} 
                                                size="small" 
                                                color={fee.status === 'PAID' ? 'success' : 
                                                       fee.status === 'PENDING' ? 'warning' : 'error'}
                                              />
                                            </Box>
                                            <Typography variant="body2" color="text.secondary" gutterBottom>
                                              Total: ₹{fee.total} | Paid: ₹{fee.paid} | Pending: ₹{fee.pending}
                                            </Typography>
                                            <Typography variant="caption" color="text.secondary" display="block" gutterBottom>
                                              Due: {fee.dueDate}
                                            </Typography>
                                            {/* Individual PAY button for each fee category */}
                                            {fee.status !== 'PAID' && fee.pending > 0 && (
                                              <Button
                                                variant="contained"
                                                size="small"
                                                startIcon={processingPayment ? <CircularProgress size={16} /> : <PaymentIcon />}
                                                onClick={() => handlePayment(student, category)}
                                                sx={{ mt: 1, width: '100%' }}
                                                color={fee.status === 'OVERDUE' ? 'error' : 'primary'}
                                                disabled={processingPayment}
                                              >
                                                {processingPayment ? 'Processing...' : `Pay ₹${fee.pending}`}
                                              </Button>
                                            )}
                                          </CardContent>
                                        </Card>
                                      </Grid>
                                    ))}
                                  </Grid>
                                </Box>
                              </TableCell>
                            </TableRow>
                          )}
                        </React.Fragment>
                      ))}
                    </TableBody>
                  </Table>
                </TableContainer>
              )}
            </CardContent>
          </Card>
            </>
          )}
        </Box>
      )}

      {selectedTab === 1 && (
        <TransportFeeDashboard userRole={userRole} userId={userId} studentId={null} />
      )}

      {/* Fee Structure Dialog */}
      <Dialog 
        open={openFeeStructureDialog} 
        onClose={() => setOpenFeeStructureDialog(false)}
        maxWidth="md"
        fullWidth
      >
        <DialogTitle>
          {editingFeeStructure ? 'Edit Fee Structure' : 'Add New Fee Structure'}
        </DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 1 }}>
            <Grid item xs={12} sm={6}>
              <TextField
                fullWidth
                label="Amount"
                type="number"
                value={feeStructureForm.amount}
                onChange={(e) => setFeeStructureForm({...feeStructureForm, amount: e.target.value})}
                required
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Class</InputLabel>
                <Select
                  value={feeStructureForm.classId}
                  onChange={(e) => setFeeStructureForm({...feeStructureForm, classId: e.target.value})}
                  label="Class"
                  required
                >
                  {classes.map((cls) => (
                    <MenuItem key={cls.id} value={cls.id}>
                      {cls.name}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Fee Category</InputLabel>
                                 <Select
                   value={feeStructureForm.feeCategoryId}
                   onChange={(e) => setFeeStructureForm({...feeStructureForm, feeCategoryId: e.target.value})}
                   label="Fee Category"
                   required
                 >
                  {feeCategories.map((category) => (
                    <MenuItem key={category.id} value={category.id}>
                      {category.name}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Frequency</InputLabel>
                <Select
                  value={feeStructureForm.frequency}
                  onChange={(e) => setFeeStructureForm({...feeStructureForm, frequency: e.target.value as FeeStructure['frequency']})}
                  label="Frequency"
                  required
                >
                  <MenuItem value="MONTHLY">Monthly</MenuItem>
                  <MenuItem value="QUARTERLY">Quarterly</MenuItem>
                  <MenuItem value="SEMESTER">Semester</MenuItem>
                  <MenuItem value="ANNUAL">Annual</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField
                fullWidth
                label="Due Date"
                type="date"
                value={feeStructureForm.dueDate}
                onChange={(e) => setFeeStructureForm({...feeStructureForm, dueDate: e.target.value})}
                InputLabelProps={{ shrink: true }}
              />
            </Grid>
            <Grid item xs={12}>
              <FormControl fullWidth>
                <InputLabel>Academic Year</InputLabel>
                <Select
                  value={feeStructureForm.academicYearId}
                  onChange={(e) => setFeeStructureForm({...feeStructureForm, academicYearId: e.target.value})}
                  label="Academic Year"
                  required
                >
                  <MenuItem value="1">2024-2025</MenuItem>
                  <MenuItem value="2">2023-2024</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12}>
              <Box display="flex" alignItems="center">
                <Switch
                  checked={feeStructureForm.isActive}
                  onChange={(e) => setFeeStructureForm({...feeStructureForm, isActive: e.target.checked})}
                />
                <Typography>Active</Typography>
              </Box>
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenFeeStructureDialog(false)} disabled={savingFeeStructure}>
            Cancel
          </Button>
          <Button 
            onClick={handleSaveFeeStructure} 
            variant="contained"
            disabled={savingFeeStructure}
            startIcon={savingFeeStructure ? <CircularProgress size={16} /> : null}
          >
            {savingFeeStructure ? 'Saving...' : (editingFeeStructure ? 'Update' : 'Create')}
          </Button>
        </DialogActions>
      </Dialog>

      {/* Student Fee Edit Dialog */}
      <Dialog 
        open={openStudentFeeDialog} 
        onClose={() => setOpenStudentFeeDialog(false)}
        maxWidth="md"
        fullWidth
      >
        <DialogTitle>
          Edit Student Fees - {editingStudentFee?.studentName}
        </DialogTitle>
        <DialogContent>
          {editingStudentFee && (
            <Box sx={{ mt: 2 }}>
              <Typography variant="h6" gutterBottom>Fee Details</Typography>
              <Grid container spacing={2}>
                {Object.entries(editingStudentFee.fees).map(([category, fee]) => (
                  <Grid item xs={12} sm={6} key={category}>
                    <Card variant="outlined">
                <CardContent>
                        <Typography variant="subtitle1" gutterBottom>
                          {category.charAt(0).toUpperCase() + category.slice(1)} Fee
                  </Typography>
                        <Grid container spacing={1}>
                          <Grid item xs={6}>
                            <TextField
                              fullWidth
                              size="small"
                              label="Total Amount"
                              type="number"
                              value={fee.total}
                              onChange={(e) => {
                                // Handle fee update logic
                                console.log('Update fee:', category, e.target.value);
                              }}
                            />
                          </Grid>
                          <Grid item xs={6}>
                            <TextField
                              fullWidth
                              size="small"
                              label="Paid Amount"
                              type="number"
                              value={fee.paid}
                              onChange={(e) => {
                                // Handle fee update logic
                                console.log('Update paid amount:', category, e.target.value);
                              }}
                            />
                          </Grid>
                          <Grid item xs={6}>
                            <TextField
                              fullWidth
                              size="small"
                              label="Due Date"
                              type="date"
                              value={fee.dueDate}
                              onChange={(e) => {
                                // Handle fee update logic
                                console.log('Update due date:', category, e.target.value);
                              }}
                              InputLabelProps={{ shrink: true }}
                            />
                          </Grid>
                          <Grid item xs={6}>
                            <FormControl fullWidth size="small">
                              <InputLabel>Status</InputLabel>
                              <Select
                                value={fee.status}
                                onChange={(e) => {
                                  // Handle fee update logic
                                  console.log('Update status:', category, e.target.value);
                                }}
                                label="Status"
                              >
                                <MenuItem value="paid">Paid</MenuItem>
                                <MenuItem value="partial">Partial</MenuItem>
                                <MenuItem value="pending">Pending</MenuItem>
                                <MenuItem value="overdue">Overdue</MenuItem>
                              </Select>
                            </FormControl>
                          </Grid>
                        </Grid>
                </CardContent>
              </Card>
            </Grid>
                ))}
          </Grid>
        </Box>
      )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenStudentFeeDialog(false)}>Cancel</Button>
          <Button variant="contained">Save Changes</Button>
        </DialogActions>
      </Dialog>

      {/* Payment Dialog */}
      <Dialog 
        open={openPaymentDialog} 
        onClose={() => {
          setOpenPaymentDialog(false);
          setSelectedCategory(null);
        }}
        maxWidth="sm"
        fullWidth
      >
        <DialogTitle>
          {userRole === 'PARENT' ? 'Pay Fees' : 'Record Fee Payment'}
          {selectedCategory && (
            <Typography variant="subtitle2" color="text.secondary" sx={{ mt: 1 }}>
              {selectedCategory.charAt(0).toUpperCase() + selectedCategory.slice(1)} Fee
            </Typography>
          )}
        </DialogTitle>
        <DialogContent>
          {selectedStudent && (
            <Box sx={{ mt: 2 }}>
                <Typography variant="h6" gutterBottom>
                  {selectedStudent.studentName} - {selectedStudent.class} {selectedStudent.section}
                </Typography>
              <Typography variant="body2" color="text.secondary" gutterBottom>
                Admission Number: {selectedStudent.admissionNumber}
              </Typography>
              
              <Divider sx={{ my: 2 }} />
              
              <Typography variant="subtitle1" gutterBottom>Payment Details</Typography>
              <Grid container spacing={2}>
                <Grid item xs={12}>
                <FormControl fullWidth>
                  <InputLabel>Fee Category</InputLabel>
                  <Select 
                    label="Fee Category"
                    value={selectedCategory || ''}
                    onChange={(e) => setSelectedCategory(e.target.value)}
                  >
                    <MenuItem value="tuition">Tuition Fee</MenuItem>
                    <MenuItem value="library">Library Fee</MenuItem>
                    <MenuItem value="laboratory">Laboratory Fee</MenuItem>
                    <MenuItem value="sports">Sports Fee</MenuItem>
                  </Select>
                </FormControl>
              </Grid>
                <Grid item xs={12}>
                  <TextField
                    fullWidth
                    label="Payment Amount"
                    type="number"
                    placeholder="Enter payment amount"
                    defaultValue={selectedCategory && selectedStudent.fees[selectedCategory as keyof typeof selectedStudent.fees]?.pending}
                  />
                </Grid>
                <Grid item xs={12}>
                <TextField
                  fullWidth
                  label="Payment Date"
                  type="date"
                  InputLabelProps={{ shrink: true }}
                />
              </Grid>
                <Grid item xs={12}>
                  <TextField
                    fullWidth
                    label="Payment Method"
                    placeholder="Cash, Card, Online Transfer, etc."
                  />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                    label="Reference Number"
                    placeholder="Transaction ID or receipt number"
                  />
                </Grid>
                <Grid item xs={12}>
                  <TextField
                    fullWidth
                    label="Notes"
                  multiline
                  rows={2}
                    placeholder="Additional notes about the payment"
                />
              </Grid>
            </Grid>
            </Box>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => {
            setOpenPaymentDialog(false);
            setSelectedCategory(null);
          }}>Cancel</Button>
          <Button variant="contained">
            {userRole === 'PARENT' ? 'Pay Now' : 'Record Payment'}
          </Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
};

export default Fees; 