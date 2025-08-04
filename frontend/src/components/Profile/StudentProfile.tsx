import React, { useState, useEffect } from 'react';
import {
  Box,
  Card,
  CardContent,
  Typography,
  Grid,
  Avatar,
  Chip,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Divider,
  IconButton,
  Alert,
  CircularProgress,
  Paper,
  List,
  ListItem,
  ListItemText,
  ListItemIcon
} from '@mui/material';
import {
  Person as PersonIcon,
  School as SchoolIcon,
  Phone as PhoneIcon,
  Email as EmailIcon,
  LocationOn as LocationIcon,
  Bloodtype as BloodIcon,
  Edit as EditIcon,
  Save as SaveIcon,
  Cancel as CancelIcon,
  ContactPhone as ContactIcon,
  Work as WorkIcon,
  Home as HomeIcon,
  CalendarToday as CalendarIcon,
  Badge as BadgeIcon,
  MedicalServices as MedicalIcon
} from '@mui/icons-material';

interface Student {
  id: number;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  bloodGroup: string;
  class: string;
  section: string;
  parents: {
    father: {
      name: string;
      phone: string;
    };
    mother: {
      name: string;
      phone: string;
    };
  };
}

interface StudentProfileProps {
  studentId?: number;
  userRole?: string;
}

const StudentProfile: React.FC<StudentProfileProps> = ({ studentId, userRole }) => {
  const [student, setStudent] = useState<Student | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [editMode, setEditMode] = useState(false);
  const [openEditDialog, setOpenEditDialog] = useState(false);
  const [editForm, setEditForm] = useState<Student | null>(null);

  useEffect(() => {
    loadStudentProfile();
  }, [studentId]);

  const loadStudentProfile = async () => {
    try {
      setLoading(true);
      // Mock data - replace with API call
      const mockStudent: Student = {
        id: studentId || 1,
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@school.com',
        phone: '+91-9876543210',
        bloodGroup: 'O+',
        class: 'Class 10',
        section: 'A',
        parents: {
          father: {
            name: 'Robert Doe',
            phone: '+91-9876543211'
          },
          mother: {
            name: 'Sarah Doe',
            phone: '+91-9876543212'
          }
        }
      };
      
      setStudent(mockStudent);
      setEditForm(mockStudent);
    } catch (err) {
      console.error(err);
      setError('Failed to load student profile');
    } finally {
      setLoading(false);
    }
  };

  const handleEdit = () => {
    setEditMode(true);
  };

  const handleSave = () => {
    if (editForm) {
      setStudent(editForm);
      setEditMode(false);
    }
  };

  const handleCancel = () => {
    if (student) {
      setEditForm(student);
      setEditMode(false);
    }
  };

  const getBloodGroupColor = (bloodGroup: string) => {
    const colors: { [key: string]: string } = {
      'A+': 'error',
      'A-': 'error',
      'B+': 'primary',
      'B-': 'primary',
      'AB+': 'secondary',
      'AB-': 'secondary',
      'O+': 'success',
      'O-': 'success'
    };
    return colors[bloodGroup] || 'default';
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'Active': return 'success';
      case 'Inactive': return 'error';
      case 'Suspended': return 'warning';
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

  if (error) {
    return (
      <Alert severity="error" sx={{ mb: 2 }}>
        {error}
      </Alert>
    );
  }

  if (!student) {
    return (
      <Alert severity="warning">
        Student profile not found
      </Alert>
    );
  }

  return (
    <Box>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">
          <PersonIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
          Student Profile
        </Typography>
        {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN') && !editMode && (
          <Button variant="contained" startIcon={<EditIcon />} onClick={handleEdit}>
            Edit Profile
          </Button>
        )}
      </Box>

      <Grid container spacing={3}>
        <Grid item xs={12} md={4}>
          <Card>
            <CardContent>
              <Box display="flex" flexDirection="column" alignItems="center" mb={2}>
                <Avatar sx={{ width: 100, height: 100, mb: 2, fontSize: '2rem' }}>
                  {student.firstName.charAt(0)}{student.lastName.charAt(0)}
                </Avatar>
                <Typography variant="h5" gutterBottom>
                  {student.firstName} {student.lastName}
                </Typography>
                <Chip label="Active" color="success" size="small" />
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} md={8}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Personal Information
              </Typography>
              
              <Grid container spacing={2}>
                <Grid item xs={12} sm={6}>
                  <TextField
                    fullWidth
                    label="First Name"
                    value={editMode && editForm ? editForm.firstName : student.firstName}
                    onChange={(e) => editForm && setEditForm({ ...editForm, firstName: e.target.value })}
                    disabled={!editMode}
                  />
                </Grid>
                <Grid item xs={12} sm={6}>
                  <TextField
                    fullWidth
                    label="Last Name"
                    value={editMode && editForm ? editForm.lastName : student.lastName}
                    onChange={(e) => editForm && setEditForm({ ...editForm, lastName: e.target.value })}
                    disabled={!editMode}
                  />
                </Grid>
                <Grid item xs={12} sm={6}>
                  <TextField
                    fullWidth
                    label="Email"
                    value={editMode && editForm ? editForm.email : student.email}
                    onChange={(e) => editForm && setEditForm({ ...editForm, email: e.target.value })}
                    disabled={!editMode}
                  />
                </Grid>
                <Grid item xs={12} sm={6}>
                  <TextField
                    fullWidth
                    label="Phone"
                    value={editMode && editForm ? editForm.phone : student.phone}
                    onChange={(e) => editForm && setEditForm({ ...editForm, phone: e.target.value })}
                    disabled={!editMode}
                  />
                </Grid>
                <Grid item xs={12} sm={6}>
                  <TextField
                    fullWidth
                    label="Class"
                    value={editMode && editForm ? editForm.class : student.class}
                    onChange={(e) => editForm && setEditForm({ ...editForm, class: e.target.value })}
                    disabled={!editMode}
                  />
                </Grid>
                <Grid item xs={12} sm={6}>
                  <TextField
                    fullWidth
                    label="Section"
                    value={editMode && editForm ? editForm.section : student.section}
                    onChange={(e) => editForm && setEditForm({ ...editForm, section: e.target.value })}
                    disabled={!editMode}
                  />
                </Grid>
              </Grid>

              {editMode && (
                <Box display="flex" gap={2} mt={3}>
                  <Button variant="contained" startIcon={<SaveIcon />} onClick={handleSave}>
                    Save
                  </Button>
                  <Button variant="outlined" startIcon={<CancelIcon />} onClick={handleCancel}>
                    Cancel
                  </Button>
                </Box>
              )}
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};

export default StudentProfile; 