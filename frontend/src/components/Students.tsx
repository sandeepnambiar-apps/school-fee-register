import React, { useState, useEffect } from 'react';
import {
  Container,
  Typography,
  Button,
  Box,
  Paper,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  IconButton,
  Tooltip,
  Chip,
  Grid,
} from '@mui/material';
import { DataGrid, GridColDef } from '@mui/x-data-grid';
import { 
  Add as AddIcon, 
  Edit as EditIcon, 
  Delete as DeleteIcon,
  Visibility as ViewIcon 
} from '@mui/icons-material';
import AdmissionForm from './AdmissionForm';

interface Student {
  id: number;
  studentId: string;
  firstName: string;
  lastName: string;
  fullName: string;
  className: string;
  section?: string; // Optional since backend doesn't have this
  admissionDate: string;
  status: string;
  parentName: string;
  parentPhone: string;
  parentEmail: string;
}

const Students: React.FC = () => {
  const [students, setStudents] = useState<Student[]>([]);
  const [loading, setLoading] = useState(true);
  const [admissionFormOpen, setAdmissionFormOpen] = useState(false);
  const [selectedStudent, setSelectedStudent] = useState<Student | null>(null);
  const [viewDialogOpen, setViewDialogOpen] = useState(false);

  useEffect(() => {
    fetchStudents();
  }, []);

  const fetchStudents = async () => {
    try {
      const response = await fetch('/api/students');
      if (response.ok) {
        const data = await response.json();
        setStudents(data);
      } else {
        // Fallback to mock data if API fails
        setStudents([
          { 
            id: 1, 
            studentId: 'STU001', 
            firstName: 'John', 
            lastName: 'Doe', 
            fullName: 'John Doe',
            className: 'Class 10', 
            section: 'A', 
            admissionDate: '2023-01-15', 
            status: 'active',
            parentName: 'John Doe Sr.',
            parentPhone: '123-456-7890',
            parentEmail: 'parent@example.com'
          },
          { 
            id: 2, 
            studentId: 'STU002', 
            firstName: 'Jane', 
            lastName: 'Smith', 
            fullName: 'Jane Smith',
            className: 'Class 9', 
            section: 'B', 
            admissionDate: '2023-02-20', 
            status: 'active',
            parentName: 'Jane Smith Sr.',
            parentPhone: '123-456-7891',
            parentEmail: 'parent2@example.com'
          },
        ]);
      }
    } catch (error) {
      console.error('Error fetching students:', error);
      // Fallback to mock data
      setStudents([
        { 
          id: 1, 
          studentId: 'STU001', 
          firstName: 'John', 
          lastName: 'Doe', 
          fullName: 'John Doe',
          className: 'Class 10', 
          section: 'A', 
          admissionDate: '2023-01-15', 
          status: 'active',
          parentName: 'John Doe Sr.',
          parentPhone: '123-456-7890',
          parentEmail: 'parent@example.com'
        },
        { 
          id: 2, 
          studentId: 'STU002', 
          firstName: 'Jane', 
          lastName: 'Smith', 
          fullName: 'Jane Smith',
          className: 'Class 9', 
          section: 'B', 
          admissionDate: '2023-02-20', 
          status: 'active',
          parentName: 'Jane Smith Sr.',
          parentPhone: '123-456-7891',
          parentEmail: 'parent2@example.com'
        },
      ]);
    } finally {
      setLoading(false);
    }
  };

  const handleViewStudent = (student: Student) => {
    setSelectedStudent(student);
    setViewDialogOpen(true);
  };

  const handleEditStudent = (student: Student) => {
    // TODO: Implement edit functionality
    console.log('Edit student:', student);
  };

  const handleDeleteStudent = async (studentId: number) => {
    if (window.confirm('Are you sure you want to delete this student?')) {
      try {
        const response = await fetch(`/api/students/${studentId}`, {
          method: 'DELETE',
        });
        if (response.ok) {
          setStudents(students.filter(s => s.id !== studentId));
        }
      } catch (error) {
        console.error('Error deleting student:', error);
      }
    }
  };

  const columns: GridColDef[] = [
    { field: 'id', headerName: 'ID', width: 90 },
    { field: 'fullName', headerName: 'Name', width: 200 },
    { field: 'studentId', headerName: 'Student ID', width: 120 },
    { field: 'className', headerName: 'Class', width: 120 },
    { field: 'section', headerName: 'Section', width: 100 },
    { field: 'parentName', headerName: 'Parent Name', width: 150 },
    { field: 'parentPhone', headerName: 'Parent Phone', width: 150 },
    { field: 'admissionDate', headerName: 'Admission Date', width: 150 },
    { 
      field: 'status', 
      headerName: 'Status', 
      width: 120,
      renderCell: (params) => (
        <Chip 
          label={params.value} 
          color={params.value === 'active' ? 'success' : 'default'}
          size="small"
        />
      )
    },
    {
      field: 'actions',
      headerName: 'Actions',
      width: 150,
      sortable: false,
      renderCell: (params) => (
        <Box>
          <Tooltip title="View Details">
            <IconButton
              size="small"
              onClick={() => handleViewStudent(params.row)}
            >
              <ViewIcon />
            </IconButton>
          </Tooltip>
          <Tooltip title="Edit Student">
            <IconButton
              size="small"
              onClick={() => handleEditStudent(params.row)}
            >
              <EditIcon />
            </IconButton>
          </Tooltip>
          <Tooltip title="Delete Student">
            <IconButton
              size="small"
              color="error"
              onClick={() => handleDeleteStudent(params.row.id)}
            >
              <DeleteIcon />
            </IconButton>
          </Tooltip>
        </Box>
      ),
    },
  ];

  return (
    <Container maxWidth="xl">
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">Students Management</Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={() => setAdmissionFormOpen(true)}
          sx={{ 
            background: 'linear-gradient(45deg, #2196F3 30%, #21CBF3 90%)',
            boxShadow: '0 3px 5px 2px rgba(33, 203, 243, .3)',
          }}
        >
          New Admission
        </Button>
      </Box>
      
      <Paper sx={{ height: 600, width: '100%' }}>
        <DataGrid
          rows={students}
          columns={columns}
          loading={loading}
          initialState={{
            pagination: {
              paginationModel: { page: 0, pageSize: 10 },
            },
          }}
          pageSizeOptions={[10, 25, 50]}
          checkboxSelection
          disableRowSelectionOnClick
        />
      </Paper>

      {/* Admission Form Dialog */}
      <Dialog
        open={admissionFormOpen}
        onClose={() => setAdmissionFormOpen(false)}
        maxWidth="lg"
        fullWidth
      >
        <DialogContent sx={{ p: 0 }}>
          <AdmissionForm />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setAdmissionFormOpen(false)}>
            Close
          </Button>
        </DialogActions>
      </Dialog>

      {/* View Student Dialog */}
      <Dialog
        open={viewDialogOpen}
        onClose={() => setViewDialogOpen(false)}
        maxWidth="md"
        fullWidth
      >
        <DialogTitle>Student Details</DialogTitle>
        <DialogContent>
          {selectedStudent && (
            <Box>
              <Typography variant="h6" gutterBottom>
                {selectedStudent.fullName}
              </Typography>
              <Grid container spacing={2}>
                <Grid item xs={6}>
                  <Typography variant="body2" color="text.secondary">Class</Typography>
                  <Typography variant="body1">{selectedStudent.className}</Typography>
                </Grid>
                <Grid item xs={6}>
                  <Typography variant="body2" color="text.secondary">Section</Typography>
                  <Typography variant="body1">{selectedStudent.section}</Typography>
                </Grid>
                <Grid item xs={6}>
                  <Typography variant="body2" color="text.secondary">Admission Date</Typography>
                  <Typography variant="body1">{selectedStudent.admissionDate}</Typography>
                </Grid>
                <Grid item xs={6}>
                  <Typography variant="body2" color="text.secondary">Status</Typography>
                  <Chip 
                    label={selectedStudent.status} 
                    color={selectedStudent.status === 'active' ? 'success' : 'default'}
                  />
                </Grid>
                <Grid item xs={6}>
                  <Typography variant="body2" color="text.secondary">Parent Name</Typography>
                  <Typography variant="body1">{selectedStudent.parentName}</Typography>
                </Grid>
                <Grid item xs={6}>
                  <Typography variant="body2" color="text.secondary">Parent Phone</Typography>
                  <Typography variant="body1">{selectedStudent.parentPhone}</Typography>
                </Grid>
                <Grid item xs={6}>
                  <Typography variant="body2" color="text.secondary">Parent Email</Typography>
                  <Typography variant="body1">{selectedStudent.parentEmail}</Typography>
                </Grid>
              </Grid>
            </Box>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setViewDialogOpen(false)}>
            Close
          </Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
};

export default Students; 