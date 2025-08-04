import React, { useState } from 'react';
import {
  Container,
  Typography,
  Paper,
  Stepper,
  Step,
  StepLabel,
  Box,
  Button,
  TextField,
  Grid,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  FormControlLabel,
  Radio,
  RadioGroup,
  FormLabel,
  Divider,
  Alert,
  CircularProgress,
  Card,
  CardContent,
  Avatar,
  IconButton,
  Snackbar,
} from '@mui/material';
import {
  Save as SaveIcon,
  ArrowBack as ArrowBackIcon,
  ArrowForward as ArrowForwardIcon,
  PhotoCamera as PhotoCameraIcon,
  Upload as UploadIcon,
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { studentAPI, feeAPI } from '../services/api';

interface AdmissionFormData {
  // Personal Information
  firstName: string;
  lastName: string;
  dateOfBirth: Date | null;
  gender: string;
  bloodGroup: string;
  nationality: string;
  religion: string;
  motherTongue: string;
  
  // Contact Information
  address: string;
  city: string;
  state: string;
  pincode: string;
  
  // Academic Information
  classId: string;
  section: string;
  previousSchool: string;
  lastClassAttended: string;
  academicYear: string;
  
  // Fee Information
  feeAmount: string;
  feeStructureId: string;
  
  // Parent/Guardian Information
  fatherName: string;
  fatherOccupation: string;
  fatherPhone: string;
  fatherEmail: string;
  motherName: string;
  motherOccupation: string;
  motherPhone: string;
  motherEmail: string;
  guardianName: string;
  guardianRelation: string;
  guardianPhone: string;
  guardianEmail: string;
  primaryContact: string; // 'father', 'mother', or 'guardian'
  
  // Emergency Contact
  emergencyContactName: string;
  emergencyContactPhone: string;
  emergencyContactRelation: string;
  
  // Medical Information
  medicalConditions: string;
  allergies: string;
  medications: string;
  
  // Documents
  photo: File | null;
  birthCertificate: File | null;
  previousSchoolCertificate: File | null;
  addressProof: File | null;
  
  // Additional Information
  transportRequired: boolean;
  hostelRequired: boolean;
  specialNeeds: string;
  remarks: string;
}

const steps = [
  'Personal Information',
  'Contact Details',
  'Academic Information',
  'Parent Details',
  'Documents Upload',
  'Review & Submit'
];

const AdmissionForm: React.FC = () => {
  const [activeStep, setActiveStep] = useState(0);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);
  
  // Snackbar states
  const [snackbarOpen, setSnackbarOpen] = useState(false);
  const [snackbarMessage, setSnackbarMessage] = useState('');
  const [snackbarSeverity, setSnackbarSeverity] = useState<'success' | 'error' | 'info' | 'warning'>('success');
  
  const [formData, setFormData] = useState<AdmissionFormData>({
    firstName: '',
    lastName: '',
    dateOfBirth: null,
    gender: '',
    bloodGroup: '',
    nationality: 'Indian',
    religion: '',
    motherTongue: '',
    address: '',
    city: '',
    state: '',
    pincode: '',
    classId: '',
    section: '',
    previousSchool: '',
    lastClassAttended: '',
    academicYear: '2024-25',
    feeAmount: '',
    feeStructureId: '',
    fatherName: '',
    fatherOccupation: '',
    fatherPhone: '',
    fatherEmail: '',
    motherName: '',
    motherOccupation: '',
    motherPhone: '',
    motherEmail: '',
    guardianName: '',
    guardianRelation: '',
    guardianPhone: '',
    guardianEmail: '',
    primaryContact: 'father',
    emergencyContactName: '',
    emergencyContactPhone: '',
    emergencyContactRelation: '',
    medicalConditions: '',
    allergies: '',
    medications: '',
    photo: null,
    birthCertificate: null,
    previousSchoolCertificate: null,
    addressProof: null,
    transportRequired: false,
    hostelRequired: false,
    specialNeeds: '',
    remarks: ''
  });

  const handleInputChange = (field: keyof AdmissionFormData, value: any) => {
    setFormData(prev => ({
      ...prev,
      [field]: value
    }));

    // If class is changed, automatically load fee amount
    if (field === 'classId' && value) {
      loadFeeForClass(value);
    }
  };

  const loadFeeForClass = async (classId: string) => {
    try {
      const feeStructures = await feeAPI.getFeeStructuresByClass(parseInt(classId));
      if (feeStructures && feeStructures.length > 0) {
        // Get the first active fee structure for this class
        const activeFeeStructure = feeStructures.find((fee: any) => fee.isActive);
        if (activeFeeStructure) {
          setFormData(prev => ({
            ...prev,
            feeAmount: activeFeeStructure.amount.toString(),
            feeStructureId: activeFeeStructure.id.toString()
          }));
        }
      }
    } catch (error) {
      console.error('Error loading fee for class:', error);
    }
  };

  const handleFileUpload = (field: keyof AdmissionFormData, file: File) => {
    setFormData(prev => ({
      ...prev,
      [field]: file
    }));
  };

  const handleNext = () => {
    if (activeStep === steps.length - 1) {
      handleSubmit();
    } else {
      setActiveStep(prev => prev + 1);
    }
  };

  const handleBack = () => {
    setActiveStep(prev => prev - 1);
  };

  const handleSubmit = async () => {
    // Validate required fields
    const requiredFields = [
      'firstName', 'lastName', 'dateOfBirth', 'gender', 
      'address', 'city', 'state', 'pincode', 'classId',
      'fatherName', 'motherName'
    ];
    
    const missingFields = requiredFields.filter(field => {
      const value = formData[field as keyof AdmissionFormData];
      return !value || (typeof value === 'string' && value.trim() === '');
    });
    
    // Validate that at least one parent phone number is provided
    if (!formData.fatherPhone.trim() && !formData.motherPhone.trim()) {
      setSnackbarMessage('At least one parent phone number is required');
      setSnackbarSeverity('error');
      setSnackbarOpen(true);
      return;
    }
    
    if (missingFields.length > 0) {
      setSnackbarMessage(`Please fill in all required fields: ${missingFields.join(', ')}`);
      setSnackbarSeverity('error');
      setSnackbarOpen(true);
      return;
    }
    
    setLoading(true);
    setError('');
    
    try {
      // Create student data object - only send fields that backend expects
      const studentData = {
        studentId: `STU${Date.now()}`, // Generate unique student ID
        firstName: formData.firstName.trim(),
        lastName: formData.lastName.trim(),
        dateOfBirth: formData.dateOfBirth ? formData.dateOfBirth.toISOString().split('T')[0] : null,
        gender: formData.gender.toUpperCase(),
        address: formData.address.trim(),
        phone: '', // Student phone not required
        email: '', // Student email not required
        parentName: formData.fatherName.trim(), // Use father's name as primary parent
        parentPhone: formData.fatherPhone.trim() || formData.motherPhone.trim(), // Use first available parent phone
        parentEmail: '', // Parent email not required
        classId: parseInt(formData.classId) || 1,
        academicYearId: 1, // Default academic year ID
        admissionDate: new Date().toISOString().split('T')[0],
        // Add primary contact information for user account creation
        primaryContact: formData.primaryContact,
        primaryContactPhone: formData.primaryContact === 'father' ? formData.fatherPhone.trim() :
                           formData.primaryContact === 'mother' ? formData.motherPhone.trim() :
                           formData.guardianPhone.trim()
      };

      console.log('Sending student data to backend:', studentData);
      console.log('Student data JSON:', JSON.stringify(studentData, null, 2));
      
      // Use the studentAPI service
      const response = await studentAPI.createStudent(studentData);
      
      // Show success message
      setSnackbarMessage('Student admission submitted successfully!');
      setSnackbarSeverity('success');
      setSnackbarOpen(true);
      
      // Reset form and go back to first step
      setActiveStep(0);
      setFormData({
        firstName: '',
        lastName: '',
        dateOfBirth: null,
        gender: '',
        bloodGroup: '',
        nationality: 'Indian',
        religion: '',
        motherTongue: '',
        address: '',
        city: '',
        state: '',
        pincode: '',
        classId: '',
        section: '',
        previousSchool: '',
        lastClassAttended: '',
        academicYear: '2024-25',
        fatherName: '',
        fatherOccupation: '',
        fatherPhone: '',
        fatherEmail: '',
        motherName: '',
        motherOccupation: '',
        motherPhone: '',
        motherEmail: '',
        guardianName: '',
        guardianRelation: '',
        guardianPhone: '',
        guardianEmail: '',
        primaryContact: 'father',
        emergencyContactName: '',
        emergencyContactPhone: '',
        emergencyContactRelation: '',
        medicalConditions: '',
        allergies: '',
        medications: '',
        photo: null,
        birthCertificate: null,
        previousSchoolCertificate: null,
        addressProof: null,
        transportRequired: false,
        hostelRequired: false,
        specialNeeds: '',
        remarks: '',
        feeAmount: '',
        feeStructureId: ''
      });
      
    } catch (err: any) {
      console.error('Error submitting admission form:', err);
      
      // Try to extract error message from response
      let errorMessage = 'Failed to submit admission form. Please try again.';
      
      if (err.message) {
        errorMessage = err.message;
      } else if (err.response) {
        try {
          const errorData = await err.response.json();
          errorMessage = errorData.message || errorData.error || errorMessage;
        } catch (parseError) {
          errorMessage = `Server error: ${err.response.status}`;
        }
      }
      
      setSnackbarMessage(errorMessage);
      setSnackbarSeverity('error');
      setSnackbarOpen(true);
    } finally {
      setLoading(false);
    }
  };

  const renderPersonalInformation = () => (
    <Grid container spacing={3}>
      <Grid item xs={12} md={6}>
        <TextField
          fullWidth
          label="First Name *"
          value={formData.firstName}
          onChange={(e) => handleInputChange('firstName', e.target.value)}
          required
          error={!formData.firstName.trim()}
          helperText={!formData.firstName.trim() ? 'First name is required' : ''}
        />
      </Grid>
      <Grid item xs={12} md={6}>
        <TextField
          fullWidth
          label="Last Name *"
          value={formData.lastName}
          onChange={(e) => handleInputChange('lastName', e.target.value)}
          required
          error={!formData.lastName.trim()}
          helperText={!formData.lastName.trim() ? 'Last name is required' : ''}
        />
      </Grid>
      <Grid item xs={12} md={6}>
        <LocalizationProvider dateAdapter={AdapterDateFns}>
          <DatePicker
            label="Date of Birth *"
            value={formData.dateOfBirth}
            onChange={(date) => handleInputChange('dateOfBirth', date)}
            slotProps={{ 
              textField: { 
                fullWidth: true, 
                required: true,
                error: !formData.dateOfBirth,
                helperText: !formData.dateOfBirth ? 'Date of birth is required' : ''
              } 
            }}
          />
        </LocalizationProvider>
      </Grid>
      <Grid item xs={12} md={6}>
        <FormControl fullWidth required error={!formData.gender}>
          <InputLabel>Gender *</InputLabel>
          <Select
            value={formData.gender}
            onChange={(e) => handleInputChange('gender', e.target.value)}
          >
            <MenuItem value="male">Male</MenuItem>
            <MenuItem value="female">Female</MenuItem>
            <MenuItem value="other">Other</MenuItem>
          </Select>
        </FormControl>
      </Grid>
    </Grid>
  );

  const renderContactDetails = () => (
    <Grid container spacing={3}>
      <Grid item xs={12}>
        <TextField
          fullWidth
          label="Address *"
          multiline
          rows={3}
          value={formData.address}
          onChange={(e) => handleInputChange('address', e.target.value)}
          required
          error={!formData.address.trim()}
          helperText={!formData.address.trim() ? 'Address is required' : ''}
        />
      </Grid>
      <Grid item xs={12} md={4}>
        <TextField
          fullWidth
          label="City *"
          value={formData.city}
          onChange={(e) => handleInputChange('city', e.target.value)}
          required
          error={!formData.city.trim()}
          helperText={!formData.city.trim() ? 'City is required' : ''}
        />
      </Grid>
      <Grid item xs={12} md={4}>
        <TextField
          fullWidth
          label="State *"
          value={formData.state}
          onChange={(e) => handleInputChange('state', e.target.value)}
          required
          error={!formData.state.trim()}
          helperText={!formData.state.trim() ? 'State is required' : ''}
        />
      </Grid>
      <Grid item xs={12} md={4}>
        <TextField
          fullWidth
          label="Pincode *"
          value={formData.pincode}
          onChange={(e) => handleInputChange('pincode', e.target.value)}
          required
          error={!formData.pincode.trim()}
          helperText={!formData.pincode.trim() ? 'Pincode is required' : ''}
        />
      </Grid>
    </Grid>
  );

  const renderAcademicInformation = () => (
    <Grid container spacing={3}>
      <Grid item xs={12} md={6}>
        <FormControl fullWidth required error={!formData.classId}>
          <InputLabel>Class *</InputLabel>
          <Select
            value={formData.classId}
            onChange={(e) => handleInputChange('classId', e.target.value)}
          >
            <MenuItem value="1">Class 1</MenuItem>
            <MenuItem value="2">Class 2</MenuItem>
            <MenuItem value="3">Class 3</MenuItem>
            <MenuItem value="4">Class 4</MenuItem>
            <MenuItem value="5">Class 5</MenuItem>
            <MenuItem value="6">Class 6</MenuItem>
            <MenuItem value="7">Class 7</MenuItem>
            <MenuItem value="8">Class 8</MenuItem>
            <MenuItem value="9">Class 9</MenuItem>
            <MenuItem value="10">Class 10</MenuItem>
          </Select>
        </FormControl>
      </Grid>
      <Grid item xs={12} md={6}>
        <FormControl fullWidth>
          <InputLabel>Section</InputLabel>
          <Select
            value={formData.section}
            onChange={(e) => handleInputChange('section', e.target.value)}
          >
            <MenuItem value="A">Section A</MenuItem>
            <MenuItem value="B">Section B</MenuItem>
            <MenuItem value="C">Section C</MenuItem>
            <MenuItem value="D">Section D</MenuItem>
          </Select>
        </FormControl>
      </Grid>
      <Grid item xs={12} md={6}>
        <TextField
          fullWidth
          label="Fee Amount (₹)"
          type="number"
          value={formData.feeAmount || ''}
          onChange={(e) => handleInputChange('feeAmount', e.target.value)}
          placeholder="Enter fee amount"
          helperText="Fee amount for this class"
        />
      </Grid>
      <Grid item xs={12} md={6}>
        <TextField
          fullWidth
          label="Previous School"
          value={formData.previousSchool}
          onChange={(e) => handleInputChange('previousSchool', e.target.value)}
          placeholder="Name of previous school"
        />
      </Grid>
      <Grid item xs={12} md={6}>
        <TextField
          fullWidth
          label="Last Class Attended"
          value={formData.lastClassAttended}
          onChange={(e) => handleInputChange('lastClassAttended', e.target.value)}
          placeholder="Last class attended"
        />
      </Grid>
      <Grid item xs={12} md={6}>
        <TextField
          fullWidth
          label="Academic Year"
          value={formData.academicYear}
          onChange={(e) => handleInputChange('academicYear', e.target.value)}
          placeholder="e.g., 2024-25"
        />
      </Grid>
    </Grid>
  );

  const renderParentGuardianDetails = () => (
    <Grid container spacing={3}>
      <Grid item xs={12}>
        <Typography variant="h6" gutterBottom>
          Father's Information
        </Typography>
      </Grid>
      <Grid item xs={12} md={6}>
        <TextField
          fullWidth
          label="Father's Name *"
          value={formData.fatherName}
          onChange={(e) => handleInputChange('fatherName', e.target.value)}
          required
          error={!formData.fatherName.trim()}
          helperText={!formData.fatherName.trim() ? 'Father\'s name is required' : ''}
        />
      </Grid>
      <Grid item xs={12} md={6}>
        <TextField
          fullWidth
          label="Father's Phone *"
          value={formData.fatherPhone}
          onChange={(e) => handleInputChange('fatherPhone', e.target.value)}
          required
          error={!formData.fatherPhone.trim()}
          helperText={!formData.fatherPhone.trim() ? 'Father\'s phone is required' : ''}
        />
      </Grid>
      <Grid item xs={12} md={6}>
        <TextField
          fullWidth
          label="Father's Occupation"
          value={formData.fatherOccupation}
          onChange={(e) => handleInputChange('fatherOccupation', e.target.value)}
        />
      </Grid>
      
      <Grid item xs={12}>
        <Typography variant="h6" gutterBottom sx={{ mt: 2 }}>
          Mother's Information
        </Typography>
      </Grid>
      <Grid item xs={12} md={6}>
        <TextField
          fullWidth
          label="Mother's Name *"
          value={formData.motherName}
          onChange={(e) => handleInputChange('motherName', e.target.value)}
          required
          error={!formData.motherName.trim()}
          helperText={!formData.motherName.trim() ? 'Mother\'s name is required' : ''}
        />
      </Grid>
      <Grid item xs={12} md={6}>
        <TextField
          fullWidth
          label="Mother's Phone *"
          value={formData.motherPhone}
          onChange={(e) => handleInputChange('motherPhone', e.target.value)}
          required
          error={!formData.motherPhone.trim()}
          helperText={!formData.motherPhone.trim() ? 'Mother\'s phone is required' : ''}
        />
      </Grid>
      <Grid item xs={12} md={6}>
        <TextField
          fullWidth
          label="Mother's Occupation"
          value={formData.motherOccupation}
          onChange={(e) => handleInputChange('motherOccupation', e.target.value)}
        />
      </Grid>
      
      <Grid item xs={12}>
        <Typography variant="h6" gutterBottom sx={{ mt: 2 }}>
          Primary Contact for Login
        </Typography>
        <FormControl component="fieldset">
          <FormLabel component="legend">Select Primary Contact (This phone number will be used for login)</FormLabel>
          <RadioGroup
            value={formData.primaryContact}
            onChange={(e) => handleInputChange('primaryContact', e.target.value)}
          >
            <FormControlLabel 
              value="father" 
              control={<Radio />} 
              label={`Father: ${formData.fatherPhone || 'Not provided'}`}
              disabled={!formData.fatherPhone.trim()}
            />
            <FormControlLabel 
              value="mother" 
              control={<Radio />} 
              label={`Mother: ${formData.motherPhone || 'Not provided'}`}
              disabled={!formData.motherPhone.trim()}
            />
            <FormControlLabel 
              value="guardian" 
              control={<Radio />} 
              label={`Guardian: ${formData.guardianPhone || 'Not provided'}`}
              disabled={!formData.guardianPhone.trim()}
            />
          </RadioGroup>
        </FormControl>
      </Grid>
      
      <Grid item xs={12}>
        <Alert severity="info" sx={{ mt: 2 }}>
          <Typography variant="body2">
            <strong>Note:</strong> At least one parent's phone number is mandatory for communication. 
            The selected primary contact's phone number will be used as the login username.
          </Typography>
        </Alert>
      </Grid>
    </Grid>
  );

  const renderDocumentsUpload = () => (
    <Grid container spacing={3}>
      <Grid item xs={12} md={6}>
        <Card>
          <CardContent>
            <Typography variant="h6" gutterBottom>Student Photo</Typography>
            <Box display="flex" alignItems="center" gap={2}>
              <Avatar
                src={formData.photo ? URL.createObjectURL(formData.photo) : undefined}
                sx={{ width: 100, height: 100 }}
              />
              <Button
                variant="outlined"
                component="label"
                startIcon={<PhotoCameraIcon />}
              >
                Upload Photo
                <input
                  type="file"
                  hidden
                  accept="image/*"
                  onChange={(e) => {
                    const file = e.target.files?.[0];
                    if (file) handleFileUpload('photo', file);
                  }}
                />
              </Button>
            </Box>
          </CardContent>
        </Card>
      </Grid>
      
      <Grid item xs={12} md={6}>
        <Card>
          <CardContent>
            <Typography variant="h6" gutterBottom>Birth Certificate</Typography>
            <Button
              variant="outlined"
              component="label"
              startIcon={<UploadIcon />}
              fullWidth
            >
              Upload Birth Certificate
              <input
                type="file"
                hidden
                accept=".pdf,.jpg,.jpeg,.png"
                onChange={(e) => {
                  const file = e.target.files?.[0];
                  if (file) handleFileUpload('birthCertificate', file);
                }}
              />
            </Button>
            {formData.birthCertificate && (
              <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                Selected: {formData.birthCertificate.name}
              </Typography>
            )}
          </CardContent>
        </Card>
      </Grid>
      
      <Grid item xs={12} md={6}>
        <Card>
          <CardContent>
            <Typography variant="h6" gutterBottom>Previous School Certificate</Typography>
            <Button
              variant="outlined"
              component="label"
              startIcon={<UploadIcon />}
              fullWidth
            >
              Upload Certificate
              <input
                type="file"
                hidden
                accept=".pdf,.jpg,.jpeg,.png"
                onChange={(e) => {
                  const file = e.target.files?.[0];
                  if (file) handleFileUpload('previousSchoolCertificate', file);
                }}
              />
            </Button>
            {formData.previousSchoolCertificate && (
              <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                Selected: {formData.previousSchoolCertificate.name}
              </Typography>
            )}
          </CardContent>
        </Card>
      </Grid>
      
      <Grid item xs={12} md={6}>
        <Card>
          <CardContent>
            <Typography variant="h6" gutterBottom>Address Proof</Typography>
            <Button
              variant="outlined"
              component="label"
              startIcon={<UploadIcon />}
              fullWidth
            >
              Upload Address Proof
              <input
                type="file"
                hidden
                accept=".pdf,.jpg,.jpeg,.png"
                onChange={(e) => {
                  const file = e.target.files?.[0];
                  if (file) handleFileUpload('addressProof', file);
                }}
              />
            </Button>
            {formData.addressProof && (
              <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                Selected: {formData.addressProof.name}
              </Typography>
            )}
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  );

  const renderReview = () => (
    <Grid container spacing={3}>
      <Grid item xs={12}>
        <Typography variant="h6" gutterBottom>Personal Information</Typography>
        <Card>
          <CardContent>
            <Grid container spacing={2}>
              <Grid item xs={6}>
                <Typography variant="body2" color="text.secondary">Name</Typography>
                <Typography variant="body1">{formData.firstName} {formData.lastName}</Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="body2" color="text.secondary">Date of Birth</Typography>
                <Typography variant="body1">{formData.dateOfBirth?.toLocaleDateString()}</Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="body2" color="text.secondary">Gender</Typography>
                <Typography variant="body1">{formData.gender}</Typography>
              </Grid>
            </Grid>
          </CardContent>
        </Card>
      </Grid>
      
      <Grid item xs={12}>
        <Typography variant="h6" gutterBottom>Academic Information</Typography>
        <Card>
          <CardContent>
            <Grid container spacing={2}>
              <Grid item xs={6}>
                <Typography variant="body2" color="text.secondary">Class</Typography>
                <Typography variant="body1">Class {formData.classId}</Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="body2" color="text.secondary">Section</Typography>
                <Typography variant="body1">{formData.section}</Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="body2" color="text.secondary">Fee Amount</Typography>
                <Typography variant="body1" color="primary" fontWeight="bold">
                  ₹{formData.feeAmount || 'Not set'}
                </Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="body2" color="text.secondary">Academic Year</Typography>
                <Typography variant="body1">{formData.academicYear}</Typography>
              </Grid>
            </Grid>
          </CardContent>
        </Card>
      </Grid>
      
      <Grid item xs={12}>
        <Typography variant="h6" gutterBottom>Contact Information</Typography>
        <Card>
          <CardContent>
            <Grid container spacing={2}>
              <Grid item xs={12}>
                <Typography variant="body2" color="text.secondary">Address</Typography>
                <Typography variant="body1">{formData.address}</Typography>
              </Grid>
              <Grid item xs={4}>
                <Typography variant="body2" color="text.secondary">City</Typography>
                <Typography variant="body1">{formData.city}</Typography>
              </Grid>
              <Grid item xs={4}>
                <Typography variant="body2" color="text.secondary">State</Typography>
                <Typography variant="body1">{formData.state}</Typography>
              </Grid>
              <Grid item xs={4}>
                <Typography variant="body2" color="text.secondary">Pincode</Typography>
                <Typography variant="body1">{formData.pincode}</Typography>
              </Grid>
            </Grid>
          </CardContent>
        </Card>
      </Grid>
      
      <Grid item xs={12}>
        <Typography variant="h6" gutterBottom>Parent Information</Typography>
        <Card>
          <CardContent>
            <Grid container spacing={2}>
              <Grid item xs={6}>
                <Typography variant="body2" color="text.secondary">Father's Name</Typography>
                <Typography variant="body1">{formData.fatherName}</Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="body2" color="text.secondary">Father's Phone</Typography>
                <Typography variant="body1">{formData.fatherPhone}</Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="body2" color="text.secondary">Father's Occupation</Typography>
                <Typography variant="body1">{formData.fatherOccupation || 'Not specified'}</Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="body2" color="text.secondary">Mother's Name</Typography>
                <Typography variant="body1">{formData.motherName}</Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="body2" color="text.secondary">Mother's Phone</Typography>
                <Typography variant="body1">{formData.motherPhone}</Typography>
              </Grid>
              <Grid item xs={6}>
                <Typography variant="body2" color="text.secondary">Mother's Occupation</Typography>
                <Typography variant="body1">{formData.motherOccupation || 'Not specified'}</Typography>
              </Grid>
            </Grid>
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  );

  const renderStepContent = (step: number) => {
    switch (step) {
      case 0:
        return renderPersonalInformation();
      case 1:
        return renderContactDetails();
      case 2:
        return renderAcademicInformation();
      case 3:
        return renderParentGuardianDetails();
      case 4:
        return renderDocumentsUpload();
      case 5:
        return renderReview();
      default:
        return null;
    }
  };

  if (success) {
    return (
      <Container maxWidth="md">
        <Paper sx={{ p: 4, textAlign: 'center' }}>
          <Alert severity="success" sx={{ mb: 2 }}>
            Admission form submitted successfully!
          </Alert>
          <Typography variant="h6" gutterBottom>
            Thank you for submitting the admission form.
          </Typography>
          <Typography variant="body1" color="text.secondary" sx={{ mb: 3 }}>
            We will review your application and contact you within 3-5 business days.
          </Typography>
          <Button
            variant="contained"
            onClick={() => setSuccess(false)}
          >
            Submit Another Application
          </Button>
        </Paper>
      </Container>
    );
  }

  return (
    <LocalizationProvider dateAdapter={AdapterDateFns}>
      <Container maxWidth="lg">
        <Paper sx={{ p: 4, my: 4 }}>
          <Typography variant="h4" gutterBottom align="center">
            Student Admission Form
          </Typography>
          
          <Stepper activeStep={activeStep} sx={{ mb: 4 }}>
            {steps.map((label) => (
              <Step key={label}>
                <StepLabel>{label}</StepLabel>
              </Step>
            ))}
          </Stepper>

          <Alert severity="info" sx={{ mb: 2 }}>
            Fields marked with * are required. Please ensure all required information is filled before submitting.
          </Alert>

          {error && (
            <Alert severity="error" sx={{ mb: 2 }}>
              {error}
            </Alert>
          )}

          <Box sx={{ mb: 4 }}>
            {renderStepContent(activeStep)}
          </Box>

          <Box display="flex" justifyContent="space-between">
            <Button
              disabled={activeStep === 0}
              onClick={handleBack}
              startIcon={<ArrowBackIcon />}
            >
              Back
            </Button>
            
            <Button
              variant="contained"
              onClick={handleNext}
              endIcon={activeStep === steps.length - 1 ? <SaveIcon /> : <ArrowForwardIcon />}
              disabled={loading}
            >
              {loading ? (
                <CircularProgress size={20} />
              ) : activeStep === steps.length - 1 ? (
                'Submit Application'
              ) : (
                'Next'
              )}
            </Button>
          </Box>
        </Paper>
        
        {/* Success/Error Snackbar */}
        <Snackbar
          open={snackbarOpen}
          autoHideDuration={6000}
          onClose={() => setSnackbarOpen(false)}
          anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
        >
          <Alert 
            onClose={() => setSnackbarOpen(false)} 
            severity={snackbarSeverity}
            sx={{ width: '100%' }}
          >
            {snackbarMessage}
          </Alert>
        </Snackbar>
      </Container>
    </LocalizationProvider>
  );
};

export default AdmissionForm; 