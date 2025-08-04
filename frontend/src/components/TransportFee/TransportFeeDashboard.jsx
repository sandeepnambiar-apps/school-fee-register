import React, { useState, useEffect } from 'react';
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
  Switch,
  FormControlLabel,
  Divider
} from '@mui/material';
import {
  DirectionsBus as BusIcon,
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Visibility as ViewIcon,
  Payment as PaymentIcon,
  LocationOn as LocationIcon,
  Route as RouteIcon,
  CalendarToday as CalendarIcon,
  AttachMoney as MoneyIcon,
  CheckCircle as CheckCircleIcon,
  Warning as WarningIcon,
  Error as ErrorIcon
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { format, isAfter, isBefore, addMonths } from 'date-fns';

const TransportFeeDashboard = ({ userRole, userId, studentId }) => {
  const [transportFees, setTransportFees] = useState([]);
  const [routes, setRoutes] = useState([]);
  const [students, setStudents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedTab, setSelectedTab] = useState(0);
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedRoute, setSelectedRoute] = useState('');
  const [selectedStudent, setSelectedStudent] = useState('');
  const [filteredFees, setFilteredFees] = useState([]);

  // Form state for creating/editing transport fee
  const [transportFeeForm, setTransportFeeForm] = useState({
    studentId: '',
    routeId: '',
    monthlyFee: '',
    academicYearId: '',
    startDate: new Date(),
    endDate: addMonths(new Date(), 12),
    isActive: true,
    pickupLocation: '',
    dropLocation: '',
    vehicleNumber: '',
    driverName: '',
    driverPhone: '',
    notes: ''
  });

  useEffect(() => {
    loadData();
  }, [userRole, userId, studentId]);

  useEffect(() => {
    filterTransportFees();
  }, [transportFees, selectedRoute, selectedStudent]);

  const loadData = async () => {
    try {
      setLoading(true);
      
      // Load routes
      const routesResponse = await fetch('/api/transport/routes');
      const routesData = await routesResponse.json();
      setRoutes(routesData);

      // Load students (for admin view)
      if (userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN') {
        const studentsResponse = await fetch('/api/students');
        const studentsData = await studentsResponse.json();
        setStudents(studentsData);
      }

      // Load transport fees based on user role
      if (userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN') {
        const feesResponse = await fetch('/api/transport/fees');
        const feesData = await feesResponse.json();
        setTransportFees(feesData);
      } else {
        // For parents/students, load their specific transport fees
        const feesResponse = await fetch(`/api/transport/fees/student/${studentId || userId}`);
        const feesData = await feesResponse.json();
        setTransportFees(feesData);
      }
    } catch (err) {
      setError('Failed to load transport fee data');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const filterTransportFees = () => {
    let filtered = [...transportFees];

    if (selectedRoute) {
      filtered = filtered.filter(fee => fee.routeId === selectedRoute);
    }

    if (selectedStudent) {
      filtered = filtered.filter(fee => fee.studentId === selectedStudent);
    }

    setFilteredFees(filtered);
  };

  const handleCreateTransportFee = async () => {
    try {
      const response = await fetch('/api/transport/fees', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(transportFeeForm),
      });

      if (response.ok) {
        setOpenDialog(false);
        resetForm();
        loadData();
      } else {
        setError('Failed to create transport fee');
      }
    } catch (err) {
      setError('Failed to create transport fee');
      console.error(err);
    }
  };

  const handleUpdateTransportFee = async (feeId) => {
    try {
      const response = await fetch(`/api/transport/fees/${feeId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(transportFeeForm),
      });

      if (response.ok) {
        setOpenDialog(false);
        resetForm();
        loadData();
      } else {
        setError('Failed to update transport fee');
      }
    } catch (err) {
      setError('Failed to update transport fee');
      console.error(err);
    }
  };

  const handleDeleteTransportFee = async (feeId) => {
    if (window.confirm('Are you sure you want to delete this transport fee?')) {
      try {
        const response = await fetch(`/api/transport/fees/${feeId}`, {
          method: 'DELETE',
        });

        if (response.ok) {
          loadData();
        } else {
          setError('Failed to delete transport fee');
        }
      } catch (err) {
        setError('Failed to delete transport fee');
        console.error(err);
      }
    }
  };

  const handleDeactivateTransportFee = async (feeId) => {
    try {
      const response = await fetch(`/api/transport/fees/${feeId}/deactivate`, {
        method: 'PUT',
      });

      if (response.ok) {
        loadData();
      } else {
        setError('Failed to deactivate transport fee');
      }
    } catch (err) {
      setError('Failed to deactivate transport fee');
      console.error(err);
    }
  };

  const resetForm = () => {
    setTransportFeeForm({
      studentId: '',
      routeId: '',
      monthlyFee: '',
      academicYearId: '',
      startDate: new Date(),
      endDate: addMonths(new Date(), 12),
      isActive: true,
      pickupLocation: '',
      dropLocation: '',
      vehicleNumber: '',
      driverName: '',
      driverPhone: '',
      notes: ''
    });
  };

  const openCreateDialog = () => {
    resetForm();
    setOpenDialog(true);
  };

  const openEditDialog = (transportFee) => {
    setTransportFeeForm({
      id: transportFee.id,
      studentId: transportFee.studentId,
      routeId: transportFee.routeId,
      monthlyFee: transportFee.monthlyFee,
      academicYearId: transportFee.academicYearId,
      startDate: new Date(transportFee.startDate),
      endDate: new Date(transportFee.endDate),
      isActive: transportFee.isActive,
      pickupLocation: transportFee.pickupLocation,
      dropLocation: transportFee.dropLocation,
      vehicleNumber: transportFee.vehicleNumber,
      driverName: transportFee.driverName,
      driverPhone: transportFee.driverPhone,
      notes: transportFee.notes
    });
    setOpenDialog(true);
  };

  const getStatusColor = (status, endDate) => {
    if (status === 'INACTIVE') return 'default';
    if (isBefore(new Date(endDate), new Date())) return 'error';
    if (isAfter(new Date(endDate), addMonths(new Date(), 1))) return 'primary';
    return 'warning';
  };

  const getStatusText = (status, endDate) => {
    if (status === 'INACTIVE') return 'Inactive';
    if (isBefore(new Date(endDate), new Date())) return 'Expired';
    if (isAfter(new Date(endDate), addMonths(new Date(), 1))) return 'Active';
    return 'Expiring Soon';
  };

  const getPaymentStatusColor = (paymentStatus) => {
    switch (paymentStatus) {
      case 'PAID': return 'success';
      case 'PENDING': return 'warning';
      case 'OVERDUE': return 'error';
      default: return 'default';
    }
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
            <BusIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
            Transport Fee Management
          </Typography>
          {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN') && (
            <Button
              variant="contained"
              startIcon={<AddIcon />}
              onClick={openCreateDialog}
            >
              Add Transport Fee
            </Button>
          )}
        </Box>

        {/* Filters */}
        <Card sx={{ mb: 3 }}>
          <CardContent>
            <Grid container spacing={2} alignItems="center">
              {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN') && (
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
              )}
              <Grid item xs={12} sm={4}>
                <FormControl fullWidth>
                  <InputLabel>Route</InputLabel>
                  <Select
                    value={selectedRoute}
                    onChange={(e) => setSelectedRoute(e.target.value)}
                    label="Route"
                  >
                    <MenuItem value="">All Routes</MenuItem>
                    {routes.map((route) => (
                      <MenuItem key={route.id} value={route.id}>
                        {route.name} - {route.pickupLocation} to {route.dropLocation}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} sm={4}>
                <Button
                  variant="outlined"
                  onClick={() => {
                    setSelectedRoute('');
                    setSelectedStudent('');
                  }}
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
            <Tab label="All Transport Fees" />
            <Tab label="Active" />
            <Tab label="Pending Payment" />
            <Tab label="Expired" />
          </Tabs>
        </Box>

        {/* Transport Fees Table */}
        <TableContainer component={Paper}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Student</TableCell>
                <TableCell>Route</TableCell>
                <TableCell>Monthly Fee</TableCell>
                <TableCell>Pickup/Drop</TableCell>
                <TableCell>Vehicle</TableCell>
                <TableCell>Status</TableCell>
                <TableCell>Payment Status</TableCell>
                <TableCell>Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {filteredFees
                .filter(fee => {
                  if (selectedTab === 1) return fee.isActive;
                  if (selectedTab === 2) return fee.paymentStatus === 'PENDING';
                  if (selectedTab === 3) return !fee.isActive || isBefore(new Date(fee.endDate), new Date());
                  return true;
                })
                .map((fee) => (
                  <TableRow key={fee.id}>
                    <TableCell>
                      <Typography variant="body2" fontWeight="bold">
                        {fee.studentName}
                      </Typography>
                      <Typography variant="caption" color="text.secondary">
                        {fee.className} - {fee.section}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2">
                        {fee.routeName}
                      </Typography>
                      <Typography variant="caption" color="text.secondary">
                        {fee.pickupLocation} → {fee.dropLocation}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2" fontWeight="bold">
                        ₹{fee.monthlyFee}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2">
                        {fee.pickupLocation}
                      </Typography>
                      <Typography variant="caption" color="text.secondary">
                        to {fee.dropLocation}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2">
                        {fee.vehicleNumber}
                      </Typography>
                      <Typography variant="caption" color="text.secondary">
                        {fee.driverName}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Chip
                        label={getStatusText(fee.isActive ? 'ACTIVE' : 'INACTIVE', fee.endDate)}
                        color={getStatusColor(fee.isActive ? 'ACTIVE' : 'INACTIVE', fee.endDate)}
                        size="small"
                      />
                    </TableCell>
                    <TableCell>
                      <Chip
                        label={fee.paymentStatus}
                        color={getPaymentStatusColor(fee.paymentStatus)}
                        size="small"
                      />
                    </TableCell>
                    <TableCell>
                      <Box display="flex" gap={1}>
                        <IconButton
                          size="small"
                          onClick={() => openEditDialog(fee)}
                          title="View Details"
                        >
                          <ViewIcon />
                        </IconButton>
                        {userRole === 'ADMIN' && (
                          <>
                            <IconButton
                              size="small"
                              onClick={() => openEditDialog(fee)}
                              title="Edit"
                            >
                              <EditIcon />
                            </IconButton>
                            <IconButton
                              size="small"
                              onClick={() => handleDeleteTransportFee(fee.id)}
                              title="Delete"
                            >
                              <DeleteIcon />
                            </IconButton>
                            <IconButton
                              size="small"
                              onClick={() => handleDeactivateTransportFee(fee.id)}
                              title="Deactivate"
                            >
                              <PaymentIcon />
                            </IconButton>
                          </>
                        )}
                      </Box>
                    </TableCell>
                  </TableRow>
                ))}
            </TableBody>
          </Table>
        </TableContainer>

        {/* Create/Edit Dialog */}
        <Dialog open={openDialog} onClose={() => setOpenDialog(false)} maxWidth="md" fullWidth>
          <DialogTitle>
            {transportFeeForm.id ? 'Edit Transport Fee' : 'Add Transport Fee'}
          </DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 1 }}>
              <Grid item xs={12} sm={6}>
                <FormControl fullWidth>
                  <InputLabel>Student</InputLabel>
                  <Select
                    value={transportFeeForm.studentId}
                    onChange={(e) => setTransportFeeForm({ ...transportFeeForm, studentId: e.target.value })}
                    label="Student"
                  >
                    {students.map((student) => (
                      <MenuItem key={student.id} value={student.id}>
                        {student.firstName} {student.lastName} - {student.className}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} sm={6}>
                <FormControl fullWidth>
                  <InputLabel>Route</InputLabel>
                  <Select
                    value={transportFeeForm.routeId}
                    onChange={(e) => setTransportFeeForm({ ...transportFeeForm, routeId: e.target.value })}
                    label="Route"
                  >
                    {routes.map((route) => (
                      <MenuItem key={route.id} value={route.id}>
                        {route.name} - {route.pickupLocation} to {route.dropLocation}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  label="Monthly Fee (₹)"
                  type="number"
                  value={transportFeeForm.monthlyFee}
                  onChange={(e) => setTransportFeeForm({ ...transportFeeForm, monthlyFee: e.target.value })}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <DatePicker
                  label="Start Date"
                  value={transportFeeForm.startDate}
                  onChange={(date) => setTransportFeeForm({ ...transportFeeForm, startDate: date })}
                  renderInput={(params) => <TextField {...params} fullWidth />}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <DatePicker
                  label="End Date"
                  value={transportFeeForm.endDate}
                  onChange={(date) => setTransportFeeForm({ ...transportFeeForm, endDate: date })}
                  renderInput={(params) => <TextField {...params} fullWidth />}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <FormControlLabel
                  control={
                    <Switch
                      checked={transportFeeForm.isActive}
                      onChange={(e) => setTransportFeeForm({ ...transportFeeForm, isActive: e.target.checked })}
                    />
                  }
                  label="Active"
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  label="Pickup Location"
                  value={transportFeeForm.pickupLocation}
                  onChange={(e) => setTransportFeeForm({ ...transportFeeForm, pickupLocation: e.target.value })}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  label="Drop Location"
                  value={transportFeeForm.dropLocation}
                  onChange={(e) => setTransportFeeForm({ ...transportFeeForm, dropLocation: e.target.value })}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  label="Vehicle Number"
                  value={transportFeeForm.vehicleNumber}
                  onChange={(e) => setTransportFeeForm({ ...transportFeeForm, vehicleNumber: e.target.value })}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  label="Driver Name"
                  value={transportFeeForm.driverName}
                  onChange={(e) => setTransportFeeForm({ ...transportFeeForm, driverName: e.target.value })}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  label="Driver Phone"
                  value={transportFeeForm.driverPhone}
                  onChange={(e) => setTransportFeeForm({ ...transportFeeForm, driverPhone: e.target.value })}
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  multiline
                  rows={3}
                  label="Notes"
                  value={transportFeeForm.notes}
                  onChange={(e) => setTransportFeeForm({ ...transportFeeForm, notes: e.target.value })}
                />
              </Grid>
            </Grid>
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setOpenDialog(false)}>Cancel</Button>
            <Button
              onClick={transportFeeForm.id ? () => handleUpdateTransportFee(transportFeeForm.id) : handleCreateTransportFee}
              variant="contained"
            >
              {transportFeeForm.id ? 'Update' : 'Create'}
            </Button>
          </DialogActions>
        </Dialog>
      </Box>
    </LocalizationProvider>
  );
};

export default TransportFeeDashboard; 