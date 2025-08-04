import React from 'react';
import {
  Card,
  CardContent,
  Typography,
  Box,
  Chip,
  IconButton,
  Collapse,
  Button,
  Grid,
  Divider
} from '@mui/material';
import {
  DirectionsBus as BusIcon,
  LocationOn as LocationIcon,
  Route as RouteIcon,
  CalendarToday as CalendarIcon,
  AttachMoney as MoneyIcon,
  Person as PersonIcon,
  Phone as PhoneIcon,
  ExpandMore as ExpandMoreIcon,
  ExpandLess as ExpandLessIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Payment as PaymentIcon,
  CheckCircle as CheckCircleIcon,
  Warning as WarningIcon,
  Error as ErrorIcon
} from '@mui/icons-material';
import { format, isAfter, isBefore, addMonths } from 'date-fns';

const TransportFeeCard = ({ 
  transportFee, 
  userRole, 
  onEdit, 
  onDelete, 
  onDeactivate,
  expanded,
  onToggleExpand 
}) => {
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

  const getPaymentStatusIcon = (paymentStatus) => {
    switch (paymentStatus) {
      case 'PAID': return <CheckCircleIcon />;
      case 'PENDING': return <WarningIcon />;
      case 'OVERDUE': return <ErrorIcon />;
      default: return null;
    }
  };

  return (
    <Card sx={{ mb: 2, position: 'relative' }}>
      <CardContent>
        {/* Header */}
        <Box display="flex" justifyContent="space-between" alignItems="flex-start" mb={2}>
          <Box display="flex" alignItems="center" flex={1}>
            <BusIcon sx={{ mr: 1, color: 'primary.main' }} />
            <Box flex={1}>
              <Typography variant="h6" component="h3" noWrap>
                {transportFee.routeName}
              </Typography>
              <Typography variant="caption" color="text.secondary">
                {transportFee.studentName} - {transportFee.className} {transportFee.section}
              </Typography>
            </Box>
          </Box>
          
          <Box display="flex" alignItems="center" gap={1}>
            <Chip
              label={`₹${transportFee.monthlyFee}`}
              color="primary"
              size="small"
              icon={<MoneyIcon />}
            />
            
            {userRole === 'ADMIN' && (
              <>
                <IconButton size="small" onClick={() => onEdit(transportFee)} title="Edit">
                  <EditIcon />
                </IconButton>
                <IconButton size="small" onClick={() => onDelete(transportFee.id)} title="Delete">
                  <DeleteIcon />
                </IconButton>
                <IconButton size="small" onClick={() => onDeactivate(transportFee.id)} title="Deactivate">
                  <PaymentIcon />
                </IconButton>
              </>
            )}
            
            <IconButton 
              size="small" 
              onClick={onToggleExpand}
              title={expanded ? "Show less" : "Show more"}
            >
              {expanded ? <ExpandLessIcon /> : <ExpandMoreIcon />}
            </IconButton>
          </Box>
        </Box>

        {/* Status Chips */}
        <Box display="flex" flexWrap="wrap" gap={1} mb={2}>
          <Chip
            icon={<RouteIcon />}
            label={transportFee.routeName}
            size="small"
            variant="outlined"
          />
          <Chip
            icon={<LocationIcon />}
            label={`${transportFee.pickupLocation} → ${transportFee.dropLocation}`}
            size="small"
            variant="outlined"
          />
          <Chip
            label={getStatusText(transportFee.isActive ? 'ACTIVE' : 'INACTIVE', transportFee.endDate)}
            size="small"
            color={getStatusColor(transportFee.isActive ? 'ACTIVE' : 'INACTIVE', transportFee.endDate)}
          />
          <Chip
            label={transportFee.paymentStatus}
            size="small"
            color={getPaymentStatusColor(transportFee.paymentStatus)}
            icon={getPaymentStatusIcon(transportFee.paymentStatus)}
          />
        </Box>

        {/* Expanded Content */}
        <Collapse in={expanded}>
          <Box mt={2}>
            <Grid container spacing={2}>
              <Grid item xs={12} sm={6}>
                <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                  <CalendarIcon sx={{ mr: 0.5, fontSize: 'small' }} />
                  Validity Period
                </Typography>
                <Typography variant="body2" sx={{ mb: 1 }}>
                  <strong>Start:</strong> {format(new Date(transportFee.startDate), 'MMM dd, yyyy')}
                </Typography>
                <Typography variant="body2" sx={{ mb: 2 }}>
                  <strong>End:</strong> {format(new Date(transportFee.endDate), 'MMM dd, yyyy')}
                </Typography>
              </Grid>
              
              <Grid item xs={12} sm={6}>
                <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                  <MoneyIcon sx={{ mr: 0.5, fontSize: 'small' }} />
                  Fee Details
                </Typography>
                <Typography variant="body2" sx={{ mb: 1 }}>
                  <strong>Monthly Fee:</strong> ₹{transportFee.monthlyFee}
                </Typography>
                <Typography variant="body2" sx={{ mb: 2 }}>
                  <strong>Total Amount:</strong> ₹{transportFee.totalAmount || transportFee.monthlyFee}
                </Typography>
              </Grid>
            </Grid>

            <Divider sx={{ my: 2 }} />

            <Grid container spacing={2}>
              <Grid item xs={12} sm={6}>
                <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                  <LocationIcon sx={{ mr: 0.5, fontSize: 'small' }} />
                  Route Details
                </Typography>
                <Typography variant="body2" sx={{ mb: 1 }}>
                  <strong>Pickup:</strong> {transportFee.pickupLocation}
                </Typography>
                <Typography variant="body2" sx={{ mb: 2 }}>
                  <strong>Drop:</strong> {transportFee.dropLocation}
                </Typography>
              </Grid>
              
              <Grid item xs={12} sm={6}>
                <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                  <BusIcon sx={{ mr: 0.5, fontSize: 'small' }} />
                  Vehicle Details
                </Typography>
                <Typography variant="body2" sx={{ mb: 1 }}>
                  <strong>Vehicle:</strong> {transportFee.vehicleNumber}
                </Typography>
                <Typography variant="body2" sx={{ mb: 2 }}>
                  <strong>Driver:</strong> {transportFee.driverName}
                </Typography>
              </Grid>
            </Grid>

            {transportFee.driverPhone && (
              <>
                <Divider sx={{ my: 2 }} />
                <Box display="flex" alignItems="center" gap={1}>
                  <PhoneIcon fontSize="small" color="action" />
                  <Typography variant="body2">
                    <strong>Driver Contact:</strong> {transportFee.driverPhone}
                  </Typography>
                </Box>
              </>
            )}

            {transportFee.notes && (
              <>
                <Divider sx={{ my: 2 }} />
                <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                  Notes
                </Typography>
                <Typography variant="body2" color="text.secondary">
                  {transportFee.notes}
                </Typography>
              </>
            )}

            {/* Payment Actions */}
            {transportFee.paymentStatus === 'PENDING' && (
              <>
                <Divider sx={{ my: 2 }} />
                <Box display="flex" gap={1}>
                  <Button
                    variant="contained"
                    color="primary"
                    size="small"
                    startIcon={<PaymentIcon />}
                  >
                    Pay Now
                  </Button>
                  <Button
                    variant="outlined"
                    size="small"
                  >
                    View Details
                  </Button>
                </Box>
              </>
            )}
          </Box>
        </Collapse>

        {/* Footer */}
        <Box display="flex" justifyContent="space-between" alignItems="center" mt={2}>
          <Typography variant="caption" color="text.secondary">
            Created: {format(new Date(transportFee.createdAt), 'MMM dd, yyyy HH:mm')}
          </Typography>
          <Typography variant="caption" color="text.secondary">
            ID: {transportFee.id}
          </Typography>
        </Box>
      </CardContent>
    </Card>
  );
};

export default TransportFeeCard; 