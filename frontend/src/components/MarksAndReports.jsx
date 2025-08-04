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
  Divider,
  List,
  ListItem,
  ListItemText,
  ListItemSecondaryAction
} from '@mui/material';
import {
  Add as AddIcon,
  Assessment as AssessmentIcon,
  Subject as SubjectIcon,
  Class as ClassIcon,
  Person as PersonIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Download as DownloadIcon,
  TrendingUp as TrendingUpIcon,
  School as SchoolIcon
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { format, parseISO } from 'date-fns';

const MarksAndReports = ({ userRole, userId }) => {
  const [marks, setMarks] = useState([]);
  const [students, setStudents] = useState([]);
  const [subjects, setSubjects] = useState([]);
  const [classes, setClasses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedTab, setSelectedTab] = useState(0);
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedStudent, setSelectedStudent] = useState('');
  const [selectedSubject, setSelectedSubject] = useState('');
  const [selectedClass, setSelectedClass] = useState('');
  const [filteredMarks, setFilteredMarks] = useState([]);

  // Form state for creating/editing marks
  const [marksForm, setMarksForm] = useState({
    studentId: '',
    subjectId: '',
    classId: '',
    examType: '',
    examDate: new Date(),
    marksObtained: '',
    totalMarks: '',
    percentage: '',
    grade: '',
    remarks: ''
  });

  useEffect(() => {
    loadData();
  }, [userRole, userId]);

  useEffect(() => {
    filterMarks();
  }, [marks, selectedStudent, selectedSubject, selectedClass]);

  const loadData = async () => {
    try {
      setLoading(true);
      
      // Load subjects
      const subjectsResponse = await fetch('/api/students/subjects');
      if (subjectsResponse.ok) {
        const subjectsData = await subjectsResponse.json();
        setSubjects(Array.isArray(subjectsData) ? subjectsData : []);
      } else {
        console.error('Failed to load subjects:', subjectsResponse.status);
        setSubjects([]);
      }

      // Load classes
      const classesResponse = await fetch('/api/students/classes');
      if (classesResponse.ok) {
        const classesData = await classesResponse.json();
        setClasses(Array.isArray(classesData) ? classesData : []);
      } else {
        console.error('Failed to load classes:', classesResponse.status);
        setClasses([]);
      }

      // Load students based on user role
      if (userRole === 'TEACHER') {
        // Teachers can see students in their assigned classes
        const studentsResponse = await fetch(`/api/students/teacher/${userId}`);
        if (studentsResponse.ok) {
          const studentsData = await studentsResponse.json();
          setStudents(Array.isArray(studentsData) ? studentsData : []);
        } else {
          console.error('Failed to load teacher students:', studentsResponse.status);
          setStudents([]);
        }
      } else if (userRole === 'PARENT') {
        // Parents can see their children
        const studentsResponse = await fetch(`/api/students/parent/${userId}`);
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

      // Load marks based on user role
      if (userRole === 'PARENT') {
        // Parents can see their children's marks
        const marksResponse = await fetch(`/api/students/marks/parent/${userId}`);
        if (marksResponse.ok) {
          const marksData = await marksResponse.json();
          setMarks(Array.isArray(marksData) ? marksData : []);
        } else {
          console.error('Failed to load parent marks:', marksResponse.status);
          setMarks([]);
        }
      } else {
        // Admin and teachers can see marks for their students
        const marksResponse = await fetch('/api/students/marks');
        if (marksResponse.ok) {
          const marksData = await marksResponse.json();
          setMarks(Array.isArray(marksData) ? marksData : []);
        } else {
          console.error('Failed to load marks:', marksResponse.status);
          setMarks([]);
        }
      }
    } catch (err) {
      setError('Failed to load marks data');
      console.error(err);
      setSubjects([]);
      setClasses([]);
      setStudents([]);
      setMarks([]);
    } finally {
      setLoading(false);
    }
  };

  const filterMarks = () => {
    if (!Array.isArray(marks)) {
      setFilteredMarks([]);
      return;
    }

    let filtered = [...marks];

    if (selectedStudent) {
      filtered = filtered.filter(mark => mark.studentId === selectedStudent);
    }

    if (selectedSubject) {
      filtered = filtered.filter(mark => mark.subjectId === selectedSubject);
    }

    if (selectedClass) {
      filtered = filtered.filter(mark => mark.classId === selectedClass);
    }

    setFilteredMarks(filtered);
  };

  const handleCreateMarks = async () => {
    try {
      const response = await fetch('/api/students/marks', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...marksForm,
          teacherId: userId
        }),
      });

      if (response.ok) {
        setOpenDialog(false);
        resetForm();
        loadData();
      } else {
        setError('Failed to create marks');
      }
    } catch (err) {
      setError('Failed to create marks');
      console.error(err);
    }
  };

  const handleUpdateMarks = async (marksId) => {
    try {
      const response = await fetch(`/api/students/marks/${marksId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...marksForm,
          teacherId: userId
        }),
      });

      if (response.ok) {
        setOpenDialog(false);
        resetForm();
        loadData();
      } else {
        setError('Failed to update marks');
      }
    } catch (err) {
      setError('Failed to update marks');
      console.error(err);
    }
  };

  const handleDeleteMarks = async (marksId) => {
    if (window.confirm('Are you sure you want to delete this marks entry?')) {
      try {
        const response = await fetch(`/api/students/marks/${marksId}?teacherId=${userId}`, {
          method: 'DELETE',
        });

        if (response.ok) {
          loadData();
        } else {
          setError('Failed to delete marks');
        }
      } catch (err) {
        setError('Failed to delete marks');
        console.error(err);
      }
    }
  };

  const resetForm = () => {
    setMarksForm({
      studentId: '',
      subjectId: '',
      classId: '',
      examType: '',
      examDate: new Date(),
      marksObtained: '',
      totalMarks: '',
      percentage: '',
      grade: '',
      remarks: ''
    });
  };

  const openCreateDialog = () => {
    resetForm();
    setOpenDialog(true);
  };

  const openEditDialog = (marksItem) => {
    setMarksForm({
      id: marksItem.id,
      studentId: marksItem.studentId,
      subjectId: marksItem.subjectId,
      classId: marksItem.classId,
      examType: marksItem.examType,
      examDate: new Date(marksItem.examDate),
      marksObtained: marksItem.marksObtained,
      totalMarks: marksItem.totalMarks,
      percentage: marksItem.percentage,
      grade: marksItem.grade,
      remarks: marksItem.remarks
    });
    setOpenDialog(true);
  };

  const calculateGrade = (percentage) => {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B+';
    if (percentage >= 60) return 'B';
    if (percentage >= 50) return 'C+';
    if (percentage >= 40) return 'C';
    return 'F';
  };

  const getGradeColor = (grade) => {
    switch (grade) {
      case 'A+':
      case 'A': return 'success';
      case 'B+':
      case 'B': return 'primary';
      case 'C+':
      case 'C': return 'warning';
      case 'F': return 'error';
      default: return 'default';
    }
  };

  const generateReport = (studentId) => {
    const studentMarks = marks.filter(mark => mark.studentId === studentId);
    const student = students.find(s => s.id === studentId);
    
    if (!student || studentMarks.length === 0) {
      alert('No data available for report generation');
      return;
    }

    // Calculate overall performance
    const totalMarks = studentMarks.reduce((sum, mark) => sum + parseFloat(mark.marksObtained), 0);
    const totalPossible = studentMarks.reduce((sum, mark) => sum + parseFloat(mark.totalMarks), 0);
    const overallPercentage = totalPossible > 0 ? (totalMarks / totalPossible) * 100 : 0;
    const overallGrade = calculateGrade(overallPercentage);

    // Generate report content
    const reportContent = `
Student Report Card
==================

Student Name: ${student.firstName} ${student.lastName}
Class: ${student.className} - ${student.section}
Academic Year: ${new Date().getFullYear()}

Subject-wise Performance:
${studentMarks.map(mark => {
  const subject = subjects.find(s => s.id === mark.subjectId);
  return `${subject?.name || 'Unknown'}: ${mark.marksObtained}/${mark.totalMarks} (${mark.percentage}%) - Grade: ${mark.grade}`;
}).join('\n')}

Overall Performance:
Total Marks: ${totalMarks}/${totalPossible}
Percentage: ${overallPercentage.toFixed(2)}%
Grade: ${overallGrade}

Remarks: ${studentMarks[studentMarks.length - 1]?.remarks || 'Good performance'}
    `;

    // Create and download report
    const blob = new Blob([reportContent], { type: 'text/plain' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${student.firstName}_${student.lastName}_Report_${format(new Date(), 'yyyy-MM-dd')}.txt`;
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
            <AssessmentIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
            {userRole === 'PARENT' ? 'Children\'s Marks & Reports' : 'Marks & Reports Management'}
          </Typography>
          {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN' || userRole === 'TEACHER') && (
            <Button
              variant="contained"
              startIcon={<AddIcon />}
              onClick={openCreateDialog}
            >
              Add Marks
            </Button>
          )}
        </Box>

        {/* Role-specific Notes */}
        {userRole === 'TEACHER' && (
          <Alert severity="info" sx={{ mb: 2 }}>
            <strong>Note for Teachers:</strong> You can add and edit marks for students in your assigned classes.
          </Alert>
        )}

        {userRole === 'PARENT' && (
          <Alert severity="info" sx={{ mb: 2 }}>
            <strong>Note for Parents:</strong> You can view your children's marks and generate detailed reports.
          </Alert>
        )}

        {/* Filters */}
        <Card sx={{ mb: 3 }}>
          <CardContent>
            <Grid container spacing={2} alignItems="center">
              <Grid item xs={12} sm={3}>
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
              <Grid item xs={12} sm={3}>
                <FormControl fullWidth>
                  <InputLabel>Subject</InputLabel>
                  <Select
                    value={selectedSubject}
                    onChange={(e) => setSelectedSubject(e.target.value)}
                    label="Subject"
                  >
                    <MenuItem value="">All Subjects</MenuItem>
                    {subjects.map((subject) => (
                      <MenuItem key={subject.id} value={subject.id}>
                        {subject.name}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} sm={3}>
                <FormControl fullWidth>
                  <InputLabel>Class</InputLabel>
                  <Select
                    value={selectedClass}
                    onChange={(e) => setSelectedClass(e.target.value)}
                    label="Class"
                  >
                    <MenuItem value="">All Classes</MenuItem>
                    {classes.map((cls) => (
                      <MenuItem key={cls.id} value={cls.id}>
                        {cls.name}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} sm={3}>
                <Button
                  variant="outlined"
                  onClick={() => {
                    setSelectedStudent('');
                    setSelectedSubject('');
                    setSelectedClass('');
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
            <Tab label="All Marks" />
            <Tab label="Recent Exams" />
            <Tab label="Performance Analysis" />
          </Tabs>
        </Box>

        {/* Marks Table */}
        <TableContainer component={Paper}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Student</TableCell>
                <TableCell>Subject</TableCell>
                <TableCell>Class</TableCell>
                <TableCell>Exam Type</TableCell>
                <TableCell>Exam Date</TableCell>
                <TableCell>Marks</TableCell>
                <TableCell>Percentage</TableCell>
                <TableCell>Grade</TableCell>
                <TableCell>Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {filteredMarks
                .filter(mark => {
                  if (selectedTab === 1) {
                    // Recent exams (last 30 days)
                    const examDate = new Date(mark.examDate);
                    const thirtyDaysAgo = new Date();
                    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
                    return examDate >= thirtyDaysAgo;
                  }
                  return true;
                })
                .map((mark) => {
                  const student = students.find(s => s.id === mark.studentId);
                  const subject = subjects.find(s => s.id === mark.subjectId);
                  const cls = classes.find(c => c.id === mark.classId);
                  
                  return (
                    <TableRow key={mark.id}>
                      <TableCell>
                        {student ? `${student.firstName} ${student.lastName}` : 'Unknown'}
                      </TableCell>
                      <TableCell>{subject?.name || 'Unknown'}</TableCell>
                      <TableCell>{cls?.name || 'Unknown'}</TableCell>
                      <TableCell>{mark.examType}</TableCell>
                      <TableCell>{format(new Date(mark.examDate), 'MMM dd, yyyy')}</TableCell>
                      <TableCell>{mark.marksObtained}/{mark.totalMarks}</TableCell>
                      <TableCell>{mark.percentage}%</TableCell>
                      <TableCell>
                        <Chip
                          label={mark.grade}
                          color={getGradeColor(mark.grade)}
                          size="small"
                        />
                      </TableCell>
                      <TableCell>
                        <Box display="flex" gap={1}>
                          {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN' || userRole === 'TEACHER') && (
                            <>
                              <IconButton
                                size="small"
                                onClick={() => openEditDialog(mark)}
                              >
                                <EditIcon />
                              </IconButton>
                              <IconButton
                                size="small"
                                onClick={() => handleDeleteMarks(mark.id)}
                              >
                                <DeleteIcon />
                              </IconButton>
                            </>
                          )}
                          {userRole === 'PARENT' && (
                            <IconButton
                              size="small"
                              onClick={() => generateReport(mark.studentId)}
                            >
                              <DownloadIcon />
                            </IconButton>
                          )}
                        </Box>
                      </TableCell>
                    </TableRow>
                  );
                })}
            </TableBody>
          </Table>
        </TableContainer>

        {/* Performance Analysis Tab */}
        {selectedTab === 2 && (
          <Box mt={3}>
            <Typography variant="h6" gutterBottom>
              Performance Analysis
            </Typography>
            <Grid container spacing={2}>
              {students.map((student) => {
                const studentMarks = marks.filter(mark => mark.studentId === student.id);
                if (studentMarks.length === 0) return null;

                const totalMarks = studentMarks.reduce((sum, mark) => sum + parseFloat(mark.marksObtained), 0);
                const totalPossible = studentMarks.reduce((sum, mark) => sum + parseFloat(mark.totalMarks), 0);
                const overallPercentage = totalPossible > 0 ? (totalMarks / totalPossible) * 100 : 0;
                const overallGrade = calculateGrade(overallPercentage);

                return (
                  <Grid item xs={12} md={6} key={student.id}>
                    <Card>
                      <CardContent>
                        <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
                          <Typography variant="h6">
                            {student.firstName} {student.lastName}
                          </Typography>
                          <Chip
                            label={overallGrade}
                            color={getGradeColor(overallGrade)}
                          />
                        </Box>
                        <Typography variant="body2" color="text.secondary" gutterBottom>
                          Class: {student.className} - {student.section}
                        </Typography>
                        <Typography variant="h4" color="primary">
                          {overallPercentage.toFixed(1)}%
                        </Typography>
                        <Typography variant="body2" color="text.secondary">
                          Total: {totalMarks}/{totalPossible} marks
                        </Typography>
                        <Box mt={2}>
                          <Button
                            variant="outlined"
                            size="small"
                            startIcon={<DownloadIcon />}
                            onClick={() => generateReport(student.id)}
                          >
                            Download Report
                          </Button>
                        </Box>
                      </CardContent>
                    </Card>
                  </Grid>
                );
              })}
            </Grid>
          </Box>
        )}

        {/* Create/Edit Dialog */}
        <Dialog open={openDialog} onClose={() => setOpenDialog(false)} maxWidth="md" fullWidth>
          <DialogTitle>
            {marksForm.id ? 'Edit Marks' : 'Add New Marks'}
          </DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 1 }}>
              <Grid item xs={12} sm={6}>
                <FormControl fullWidth>
                  <InputLabel>Student</InputLabel>
                  <Select
                    value={marksForm.studentId}
                    onChange={(e) => setMarksForm({ ...marksForm, studentId: e.target.value })}
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
                  <InputLabel>Subject</InputLabel>
                  <Select
                    value={marksForm.subjectId}
                    onChange={(e) => setMarksForm({ ...marksForm, subjectId: e.target.value })}
                    label="Subject"
                  >
                    {subjects.map((subject) => (
                      <MenuItem key={subject.id} value={subject.id}>
                        {subject.name}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} sm={6}>
                <FormControl fullWidth>
                  <InputLabel>Class</InputLabel>
                  <Select
                    value={marksForm.classId}
                    onChange={(e) => setMarksForm({ ...marksForm, classId: e.target.value })}
                    label="Class"
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
                  <InputLabel>Exam Type</InputLabel>
                  <Select
                    value={marksForm.examType}
                    onChange={(e) => setMarksForm({ ...marksForm, examType: e.target.value })}
                    label="Exam Type"
                  >
                    <MenuItem value="UNIT_TEST">Unit Test</MenuItem>
                    <MenuItem value="MID_TERM">Mid Term</MenuItem>
                    <MenuItem value="FINAL_EXAM">Final Exam</MenuItem>
                    <MenuItem value="QUIZ">Quiz</MenuItem>
                    <MenuItem value="ASSIGNMENT">Assignment</MenuItem>
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} sm={6}>
                <DatePicker
                  label="Exam Date"
                  value={marksForm.examDate}
                  onChange={(date) => setMarksForm({ ...marksForm, examDate: date })}
                  renderInput={(params) => <TextField {...params} fullWidth />}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  label="Marks Obtained"
                  type="number"
                  value={marksForm.marksObtained}
                  onChange={(e) => {
                    const obtained = parseFloat(e.target.value) || 0;
                    const total = parseFloat(marksForm.totalMarks) || 0;
                    const percentage = total > 0 ? (obtained / total) * 100 : 0;
                    const grade = calculateGrade(percentage);
                    setMarksForm({
                      ...marksForm,
                      marksObtained: e.target.value,
                      percentage: percentage.toFixed(2),
                      grade: grade
                    });
                  }}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  label="Total Marks"
                  type="number"
                  value={marksForm.totalMarks}
                  onChange={(e) => {
                    const total = parseFloat(e.target.value) || 0;
                    const obtained = parseFloat(marksForm.marksObtained) || 0;
                    const percentage = total > 0 ? (obtained / total) * 100 : 0;
                    const grade = calculateGrade(percentage);
                    setMarksForm({
                      ...marksForm,
                      totalMarks: e.target.value,
                      percentage: percentage.toFixed(2),
                      grade: grade
                    });
                  }}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  label="Percentage"
                  value={marksForm.percentage}
                  InputProps={{ readOnly: true }}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  label="Grade"
                  value={marksForm.grade}
                  InputProps={{ readOnly: true }}
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  multiline
                  rows={3}
                  label="Remarks"
                  value={marksForm.remarks}
                  onChange={(e) => setMarksForm({ ...marksForm, remarks: e.target.value })}
                />
              </Grid>
            </Grid>
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setOpenDialog(false)}>Cancel</Button>
            <Button
              onClick={marksForm.id ? () => handleUpdateMarks(marksForm.id) : handleCreateMarks}
              variant="contained"
            >
              {marksForm.id ? 'Update' : 'Add'}
            </Button>
          </DialogActions>
        </Dialog>
      </Box>
    </LocalizationProvider>
  );
};

export default MarksAndReports; 