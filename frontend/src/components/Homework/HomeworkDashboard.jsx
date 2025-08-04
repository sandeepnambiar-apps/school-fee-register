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
  List,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  Divider
} from '@mui/material';
import {
  Add as AddIcon,
  Assignment as AssignmentIcon,
  CalendarToday as CalendarIcon,
  Subject as SubjectIcon,
  Class as ClassIcon,
  PriorityHigh as PriorityIcon,
  Download as DownloadIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Archive as ArchiveIcon
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { format, isAfter, isBefore, addDays } from 'date-fns';

const HomeworkDashboard = ({ userRole, userId }) => {
  const [homework, setHomework] = useState([]);
  const [subjects, setSubjects] = useState([]);
  const [classes, setClasses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedTab, setSelectedTab] = useState(0);
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedSubject, setSelectedSubject] = useState('');
  const [selectedClass, setSelectedClass] = useState('');
  const [selectedSection, setSelectedSection] = useState('');
  const [filteredHomework, setFilteredHomework] = useState([]);

  // Form state for creating/editing homework
  const [homeworkForm, setHomeworkForm] = useState({
    title: '',
    description: '',
    subjectId: '',
    classId: '',
    section: '',
    assignedDate: new Date(),
    dueDate: addDays(new Date(), 7),
    priority: 'NORMAL',
    attachmentUrl: '',
    attachmentName: ''
  });

  useEffect(() => {
    loadData();
  }, [userRole, userId]);

  useEffect(() => {
    filterHomework();
  }, [homework, selectedSubject, selectedClass, selectedSection]);

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

      // Load homework based on user role
      if (userRole === 'TEACHER') {
        const homeworkResponse = await fetch(`/api/students/homework/teacher/${userId}`);
        if (homeworkResponse.ok) {
          const homeworkData = await homeworkResponse.json();
          setHomework(Array.isArray(homeworkData) ? homeworkData : []);
        } else {
          console.error('Failed to load teacher homework:', homeworkResponse.status);
          setHomework([]);
        }
      } else if (userRole === 'PARENT') {
        // For parents, load homework for their children's classes
        const homeworkResponse = await fetch(`/api/students/homework/parent/${userId}`);
        if (homeworkResponse.ok) {
          const homeworkData = await homeworkResponse.json();
          setHomework(Array.isArray(homeworkData) ? homeworkData : []);
        } else {
          console.error('Failed to load parent homework:', homeworkResponse.status);
          setHomework([]);
        }
      } else {
        // For students/parents, load homework for their class
        const homeworkResponse = await fetch(`/api/students/homework/class/${selectedClass}/section/${selectedSection}`);
        if (homeworkResponse.ok) {
          const homeworkData = await homeworkResponse.json();
          setHomework(Array.isArray(homeworkData) ? homeworkData : []);
        } else {
          console.error('Failed to load class homework:', homeworkResponse.status);
          setHomework([]);
        }
      }
    } catch (err) {
      setError('Failed to load homework data');
      console.error(err);
      setSubjects([]);
      setClasses([]);
      setHomework([]);
    } finally {
      setLoading(false);
    }
  };

  const filterHomework = () => {
    if (!Array.isArray(homework)) {
      setFilteredHomework([]);
      return;
    }

    let filtered = [...homework];

    if (selectedSubject) {
      filtered = filtered.filter(hw => hw.subjectId === selectedSubject);
    }

    if (selectedClass) {
      filtered = filtered.filter(hw => hw.classId === selectedClass);
    }

    if (selectedSection) {
      filtered = filtered.filter(hw => hw.section === selectedSection);
    }

    setFilteredHomework(filtered);
  };

  const handleCreateHomework = async () => {
    try {
      const response = await fetch('/api/students/homework', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...homeworkForm,
          teacherId: userId
        }),
      });

      if (response.ok) {
        setOpenDialog(false);
        resetForm();
        loadData();
      } else {
        setError('Failed to create homework');
      }
    } catch (err) {
      setError('Failed to create homework');
      console.error(err);
    }
  };

  const handleUpdateHomework = async (homeworkId) => {
    try {
      const response = await fetch(`/api/students/homework/${homeworkId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...homeworkForm,
          teacherId: userId
        }),
      });

      if (response.ok) {
        setOpenDialog(false);
        resetForm();
        loadData();
      } else {
        setError('Failed to update homework');
      }
    } catch (err) {
      setError('Failed to update homework');
      console.error(err);
    }
  };

  const handleDeleteHomework = async (homeworkId) => {
    if (window.confirm('Are you sure you want to delete this homework?')) {
      try {
        const response = await fetch(`/api/students/homework/${homeworkId}?teacherId=${userId}`, {
          method: 'DELETE',
        });

        if (response.ok) {
          loadData();
        } else {
          setError('Failed to delete homework');
        }
      } catch (err) {
        setError('Failed to delete homework');
        console.error(err);
      }
    }
  };

  const handleArchiveHomework = async (homeworkId) => {
    try {
      const response = await fetch(`/api/students/homework/${homeworkId}/archive?teacherId=${userId}`, {
        method: 'PUT',
      });

      if (response.ok) {
        loadData();
      } else {
        setError('Failed to archive homework');
      }
    } catch (err) {
      setError('Failed to archive homework');
      console.error(err);
    }
  };

  const resetForm = () => {
    setHomeworkForm({
      title: '',
      description: '',
      subjectId: '',
      classId: '',
      section: '',
      assignedDate: new Date(),
      dueDate: addDays(new Date(), 7),
      priority: 'NORMAL',
      attachmentUrl: '',
      attachmentName: ''
    });
  };

  const openCreateDialog = () => {
    resetForm();
    setOpenDialog(true);
  };

  const openEditDialog = (homeworkItem) => {
    setHomeworkForm({
      id: homeworkItem.id,
      title: homeworkItem.title,
      description: homeworkItem.description,
      subjectId: homeworkItem.subjectId,
      classId: homeworkItem.classId,
      section: homeworkItem.section,
      assignedDate: new Date(homeworkItem.assignedDate),
      dueDate: new Date(homeworkItem.dueDate),
      priority: homeworkItem.priority,
      attachmentUrl: homeworkItem.attachmentUrl,
      attachmentName: homeworkItem.attachmentName
    });
    setOpenDialog(true);
  };

  const getPriorityColor = (priority) => {
    switch (priority) {
      case 'URGENT': return 'error';
      case 'HIGH': return 'warning';
      case 'NORMAL': return 'primary';
      case 'LOW': return 'default';
      default: return 'default';
    }
  };

  const getStatusColor = (status, dueDate) => {
    if (status === 'COMPLETED') return 'success';
    if (status === 'ARCHIVED') return 'default';
    if (isBefore(new Date(dueDate), new Date())) return 'error';
    if (isAfter(new Date(dueDate), addDays(new Date(), 3))) return 'primary';
    return 'warning';
  };

  const getStatusText = (status, dueDate) => {
    if (status === 'COMPLETED') return 'Completed';
    if (status === 'ARCHIVED') return 'Archived';
    if (isBefore(new Date(dueDate), new Date())) return 'Overdue';
    if (isAfter(new Date(dueDate), addDays(new Date(), 3))) return 'Active';
    return 'Due Soon';
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
            <AssignmentIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
            {userRole === 'PARENT' ? 'Children\'s Homework' : 'Homework Management'}
          </Typography>
          {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN' || userRole === 'TEACHER') && (
            <Button
              variant="contained"
              startIcon={<AddIcon />}
              onClick={openCreateDialog}
            >
              Add Homework
            </Button>
          )}
        </Box>

        {/* Teacher/Admin Note */}
        {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN' || userRole === 'TEACHER') && (
          <Alert severity="info" sx={{ mb: 2 }}>
            <strong>Note for Teachers/Administrators:</strong> You can assign homework to any classes and subjects. Teachers can only assign to their assigned classes.
          </Alert>
        )}

        {/* Parent Note */}
        {userRole === 'PARENT' && (
          <Alert severity="info" sx={{ mb: 2 }}>
            <strong>Note for Parents:</strong> You can view homework assigned to your children's classes. Use the filters below to view specific subjects or classes.
          </Alert>
        )}

        {/* Filters */}
        <Card sx={{ mb: 3 }}>
          <CardContent>
            <Grid container spacing={2} alignItems="center">
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
                <FormControl fullWidth>
                  <InputLabel>Section</InputLabel>
                  <Select
                    value={selectedSection}
                    onChange={(e) => setSelectedSection(e.target.value)}
                    label="Section"
                  >
                    <MenuItem value="">All Sections</MenuItem>
                    <MenuItem value="A">Section A</MenuItem>
                    <MenuItem value="B">Section B</MenuItem>
                    <MenuItem value="C">Section C</MenuItem>
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} sm={3}>
                <Button
                  variant="outlined"
                  onClick={() => {
                    setSelectedSubject('');
                    setSelectedClass('');
                    setSelectedSection('');
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
            <Tab label="All Homework" />
            <Tab label="Active" />
            <Tab label="Overdue" />
            <Tab label="Upcoming" />
          </Tabs>
        </Box>

        {/* Homework List */}
        <Grid container spacing={2}>
          {filteredHomework
            .filter(hw => {
              if (selectedTab === 1) return hw.status === 'ACTIVE';
              if (selectedTab === 2) return isBefore(new Date(hw.dueDate), new Date());
              if (selectedTab === 3) return isAfter(new Date(hw.dueDate), new Date()) && isBefore(new Date(hw.dueDate), addDays(new Date(), 7));
              return true;
            })
            .map((homeworkItem) => (
              <Grid item xs={12} md={6} lg={4} key={homeworkItem.id}>
                <Card>
                  <CardContent>
                    <Box display="flex" justifyContent="space-between" alignItems="flex-start" mb={1}>
                      <Typography variant="h6" component="h3" noWrap>
                        {homeworkItem.title}
                      </Typography>
                      {userRole === 'TEACHER' && (
                        <Box>
                          <IconButton
                            size="small"
                            onClick={() => openEditDialog(homeworkItem)}
                          >
                            <EditIcon />
                          </IconButton>
                          <IconButton
                            size="small"
                            onClick={() => handleDeleteHomework(homeworkItem.id)}
                          >
                            <DeleteIcon />
                          </IconButton>
                          <IconButton
                            size="small"
                            onClick={() => handleArchiveHomework(homeworkItem.id)}
                          >
                            <ArchiveIcon />
                          </IconButton>
                        </Box>
                      )}
                    </Box>

                    <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                      {homeworkItem.description}
                    </Typography>

                    <Box display="flex" flexWrap="wrap" gap={1} mb={2}>
                      <Chip
                        icon={<SubjectIcon />}
                        label={homeworkItem.subjectName || 'Subject'}
                        size="small"
                        variant="outlined"
                      />
                      <Chip
                        icon={<ClassIcon />}
                        label={`Class ${homeworkItem.className}${homeworkItem.section ? ` - ${homeworkItem.section}` : ''}`}
                        size="small"
                        variant="outlined"
                      />
                      <Chip
                        icon={<PriorityIcon />}
                        label={homeworkItem.priority}
                        size="small"
                        color={getPriorityColor(homeworkItem.priority)}
                      />
                      <Chip
                        icon={<CalendarIcon />}
                        label={getStatusText(homeworkItem.status, homeworkItem.dueDate)}
                        size="small"
                        color={getStatusColor(homeworkItem.status, homeworkItem.dueDate)}
                      />
                    </Box>

                    <Box display="flex" justifyContent="space-between" alignItems="center">
                      <Typography variant="caption" color="text.secondary">
                        Due: {format(new Date(homeworkItem.dueDate), 'MMM dd, yyyy')}
                      </Typography>
                      {homeworkItem.attachmentUrl && (
                        <IconButton
                          size="small"
                          onClick={() => window.open(homeworkItem.attachmentUrl, '_blank')}
                        >
                          <DownloadIcon />
                        </IconButton>
                      )}
                    </Box>
                  </CardContent>
                </Card>
              </Grid>
            ))}
        </Grid>

        {/* Create/Edit Dialog */}
        <Dialog open={openDialog} onClose={() => setOpenDialog(false)} maxWidth="md" fullWidth>
          <DialogTitle>
            {homeworkForm.id ? 'Edit Homework' : 'Create New Homework'}
          </DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 1 }}>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  label="Title"
                  value={homeworkForm.title}
                  onChange={(e) => setHomeworkForm({ ...homeworkForm, title: e.target.value })}
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  multiline
                  rows={4}
                  label="Description"
                  value={homeworkForm.description}
                  onChange={(e) => setHomeworkForm({ ...homeworkForm, description: e.target.value })}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <FormControl fullWidth>
                  <InputLabel>Subject</InputLabel>
                  <Select
                    value={homeworkForm.subjectId}
                    onChange={(e) => setHomeworkForm({ ...homeworkForm, subjectId: e.target.value })}
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
                    value={homeworkForm.classId}
                    onChange={(e) => setHomeworkForm({ ...homeworkForm, classId: e.target.value })}
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
                  <InputLabel>Section</InputLabel>
                  <Select
                    value={homeworkForm.section}
                    onChange={(e) => setHomeworkForm({ ...homeworkForm, section: e.target.value })}
                    label="Section"
                  >
                    <MenuItem value="A">Section A</MenuItem>
                    <MenuItem value="B">Section B</MenuItem>
                    <MenuItem value="C">Section C</MenuItem>
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} sm={6}>
                <FormControl fullWidth>
                  <InputLabel>Priority</InputLabel>
                  <Select
                    value={homeworkForm.priority}
                    onChange={(e) => setHomeworkForm({ ...homeworkForm, priority: e.target.value })}
                    label="Priority"
                  >
                    <MenuItem value="LOW">Low</MenuItem>
                    <MenuItem value="NORMAL">Normal</MenuItem>
                    <MenuItem value="HIGH">High</MenuItem>
                    <MenuItem value="URGENT">Urgent</MenuItem>
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} sm={6}>
                <DatePicker
                  label="Assigned Date"
                  value={homeworkForm.assignedDate}
                  onChange={(date) => setHomeworkForm({ ...homeworkForm, assignedDate: date })}
                  renderInput={(params) => <TextField {...params} fullWidth />}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <DatePicker
                  label="Due Date"
                  value={homeworkForm.dueDate}
                  onChange={(date) => setHomeworkForm({ ...homeworkForm, dueDate: date })}
                  renderInput={(params) => <TextField {...params} fullWidth />}
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  label="Attachment URL (optional)"
                  value={homeworkForm.attachmentUrl}
                  onChange={(e) => setHomeworkForm({ ...homeworkForm, attachmentUrl: e.target.value })}
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  label="Attachment Name (optional)"
                  value={homeworkForm.attachmentName}
                  onChange={(e) => setHomeworkForm({ ...homeworkForm, attachmentName: e.target.value })}
                />
              </Grid>
            </Grid>
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setOpenDialog(false)}>Cancel</Button>
            <Button
              onClick={homeworkForm.id ? () => handleUpdateHomework(homeworkForm.id) : handleCreateHomework}
              variant="contained"
            >
              {homeworkForm.id ? 'Update' : 'Create'}
            </Button>
          </DialogActions>
        </Dialog>
      </Box>
    </LocalizationProvider>
  );
};

export default HomeworkDashboard; 