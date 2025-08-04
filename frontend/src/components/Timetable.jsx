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
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Tabs,
  Tab,
  Divider
} from '@mui/material';
import {
  Add as AddIcon,
  Schedule as ScheduleIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Class as ClassIcon,
  Subject as SubjectIcon,
  Person as PersonIcon,
  AccessTime as TimeIcon,
  Room as RoomIcon
} from '@mui/icons-material';
import { TimePicker } from '@mui/x-date-pickers/TimePicker';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { format, parse, setHours, setMinutes } from 'date-fns';

const Timetable = ({ userRole, userId }) => {
  const [timetable, setTimetable] = useState([]);
  const [subjects, setSubjects] = useState([]);
  const [classes, setClasses] = useState([]);
  const [teachers, setTeachers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedTab, setSelectedTab] = useState(0);
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedClass, setSelectedClass] = useState('');
  const [selectedSection, setSelectedSection] = useState('');
  const [filteredTimetable, setFilteredTimetable] = useState([]);

  // Form state for creating/editing timetable entries
  const [timetableForm, setTimetableForm] = useState({
    dayOfWeek: '',
    startTime: setHours(setMinutes(new Date(), 0), 8), // 8:00 AM default
    endTime: setHours(setMinutes(new Date(), 0), 9), // 9:00 AM default
    subjectId: '',
    classId: '',
    section: '',
    teacherId: '',
    roomNumber: '',
    periodNumber: 1
  });

  const daysOfWeek = [
    'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'
  ];

  const timeSlots = [
    { start: '08:00', end: '08:45', period: 1 },
    { start: '08:45', end: '09:30', period: 2 },
    { start: '09:30', end: '10:15', period: 3 },
    { start: '10:15', end: '11:00', period: 4 },
    { start: '11:00', end: '11:15', period: 0, break: 'Short Break' },
    { start: '11:15', end: '12:00', period: 5 },
    { start: '12:00', end: '12:45', period: 6 },
    { start: '12:45', end: '13:30', period: 7 },
    { start: '13:30', end: '14:00', period: 0, break: 'Lunch Break' },
    { start: '14:00', end: '14:45', period: 8 },
    { start: '14:45', end: '15:30', period: 9 },
    { start: '15:30', end: '16:15', period: 10 }
  ];

  useEffect(() => {
    loadData();
  }, [userRole, userId]);

  useEffect(() => {
    filterTimetable();
  }, [timetable, selectedClass, selectedSection]);

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

      // Load teachers
      const teachersResponse = await fetch('/api/students/teachers');
      if (teachersResponse.ok) {
        const teachersData = await teachersResponse.json();
        setTeachers(Array.isArray(teachersData) ? teachersData : []);
      } else {
        console.error('Failed to load teachers:', teachersResponse.status);
        setTeachers([]);
      }

      // Load timetable
      const timetableResponse = await fetch('/api/timetable');
      if (timetableResponse.ok) {
        const timetableData = await timetableResponse.json();
        setTimetable(Array.isArray(timetableData) ? timetableData : []);
      } else {
        console.error('Failed to load timetable:', timetableResponse.status);
        setTimetable([]);
      }
    } catch (err) {
      setError('Failed to load timetable data');
      console.error(err);
      setSubjects([]);
      setClasses([]);
      setTeachers([]);
      setTimetable([]);
    } finally {
      setLoading(false);
    }
  };

  const filterTimetable = () => {
    if (!Array.isArray(timetable)) {
      setFilteredTimetable([]);
      return;
    }

    let filtered = [...timetable];

    if (selectedClass) {
      filtered = filtered.filter(entry => entry.classId === selectedClass);
    }

    if (selectedSection) {
      filtered = filtered.filter(entry => entry.section === selectedSection);
    }

    setFilteredTimetable(filtered);
  };

  const handleCreateTimetableEntry = async () => {
    try {
      const response = await fetch('/api/timetable', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...timetableForm,
          createdBy: userId
        }),
      });

      if (response.ok) {
        setOpenDialog(false);
        resetForm();
        loadData();
      } else {
        setError('Failed to create timetable entry');
      }
    } catch (err) {
      setError('Failed to create timetable entry');
      console.error(err);
    }
  };

  const handleUpdateTimetableEntry = async (entryId) => {
    try {
      const response = await fetch(`/api/timetable/${entryId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...timetableForm,
          updatedBy: userId
        }),
      });

      if (response.ok) {
        setOpenDialog(false);
        resetForm();
        loadData();
      } else {
        setError('Failed to update timetable entry');
      }
    } catch (err) {
      setError('Failed to update timetable entry');
      console.error(err);
    }
  };

  const handleDeleteTimetableEntry = async (entryId) => {
    if (window.confirm('Are you sure you want to delete this timetable entry?')) {
      try {
        const response = await fetch(`/api/timetable/${entryId}`, {
          method: 'DELETE',
        });

        if (response.ok) {
          loadData();
        } else {
          setError('Failed to delete timetable entry');
        }
      } catch (err) {
        setError('Failed to delete timetable entry');
        console.error(err);
      }
    }
  };

  const resetForm = () => {
    setTimetableForm({
      dayOfWeek: '',
      startTime: setHours(setMinutes(new Date(), 0), 8),
      endTime: setHours(setMinutes(new Date(), 0), 9),
      subjectId: '',
      classId: '',
      section: '',
      teacherId: '',
      roomNumber: '',
      periodNumber: 1
    });
  };

  const openCreateDialog = () => {
    resetForm();
    setOpenDialog(true);
  };

  const openEditDialog = (entry) => {
    setTimetableForm({
      id: entry.id,
      dayOfWeek: entry.dayOfWeek,
      startTime: parse(entry.startTime, 'HH:mm', new Date()),
      endTime: parse(entry.endTime, 'HH:mm', new Date()),
      subjectId: entry.subjectId,
      classId: entry.classId,
      section: entry.section,
      teacherId: entry.teacherId,
      roomNumber: entry.roomNumber,
      periodNumber: entry.periodNumber
    });
    setOpenDialog(true);
  };

  const getTimetableForDay = (day) => {
    if (!Array.isArray(filteredTimetable)) {
      return [];
    }
    return filteredTimetable.filter(entry => entry.dayOfWeek === day);
  };

  const getSubjectName = (subjectId) => {
    const subject = subjects.find(s => s.id === subjectId);
    return subject ? subject.name : 'Unknown';
  };

  const getTeacherName = (teacherId) => {
    const teacher = teachers.find(t => t.id === teacherId);
    return teacher ? teacher.name : 'Unknown';
  };

  const getClassName = (classId) => {
    const cls = classes.find(c => c.id === classId);
    return cls ? cls.name : 'Unknown';
  };

  const canEdit = userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN' || userRole === 'TEACHER';

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
            <ScheduleIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
            School Timetable
          </Typography>
          {canEdit && (
            <Button
              variant="contained"
              startIcon={<AddIcon />}
              onClick={openCreateDialog}
            >
              Add Timetable Entry
            </Button>
          )}
        </Box>

        {/* Role-based Note */}
        {canEdit ? (
          <Alert severity="info" sx={{ mb: 2 }}>
            <strong>Note for {userRole}s:</strong> You can create and manage timetable entries for your assigned classes and subjects.
          </Alert>
        ) : (
          <Alert severity="info" sx={{ mb: 2 }}>
            <strong>Note for Parents:</strong> You can view the timetable for your children's classes. Use the filters below to view specific classes or sections.
          </Alert>
        )}

        {/* Filters */}
        <Card sx={{ mb: 3 }}>
          <CardContent>
            <Grid container spacing={2} alignItems="center">
              <Grid item xs={12} sm={4}>
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
              <Grid item xs={12} sm={4}>
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
              <Grid item xs={12} sm={4}>
                <Button
                  variant="outlined"
                  onClick={() => {
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
            <Tab label="Weekly View" />
            <Tab label="List View" />
          </Tabs>
        </Box>

        {/* Weekly Timetable View */}
        {selectedTab === 0 && (
          <TableContainer component={Paper}>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell sx={{ fontWeight: 'bold' }}>Time</TableCell>
                  {daysOfWeek.map(day => (
                    <TableCell key={day} sx={{ fontWeight: 'bold', textAlign: 'center' }}>
                      {day.charAt(0) + day.slice(1).toLowerCase()}
                    </TableCell>
                  ))}
                </TableRow>
              </TableHead>
              <TableBody>
                {timeSlots.map((slot, index) => (
                  <TableRow key={index}>
                    <TableCell sx={{ fontWeight: 'bold' }}>
                      {slot.break ? (
                        <Box textAlign="center">
                          <Typography variant="caption" color="text.secondary">
                            {slot.start} - {slot.end}
                          </Typography>
                          <Typography variant="body2" color="primary">
                            {slot.break}
                          </Typography>
                        </Box>
                      ) : (
                        `${slot.start} - ${slot.end}`
                      )}
                    </TableCell>
                    {daysOfWeek.map(day => {
                      const dayEntries = getTimetableForDay(day);
                      const entry = dayEntries.find(e => e.periodNumber === slot.period);
                      
                      if (slot.break) {
                        return (
                          <TableCell key={day} sx={{ backgroundColor: '#f5f5f5' }}>
                            <Typography variant="body2" color="text.secondary" textAlign="center">
                              Break
                            </Typography>
                          </TableCell>
                        );
                      }

                      return (
                        <TableCell key={day}>
                          {entry ? (
                            <Card variant="outlined" sx={{ p: 1 }}>
                              <Typography variant="body2" fontWeight="bold">
                                {getSubjectName(entry.subjectId)}
                              </Typography>
                              <Typography variant="caption" color="text.secondary">
                                {getClassName(entry.classId)} - {entry.section}
                              </Typography>
                              <Typography variant="caption" display="block" color="text.secondary">
                                {getTeacherName(entry.teacherId)}
                              </Typography>
                              <Typography variant="caption" color="text.secondary">
                                Room {entry.roomNumber}
                              </Typography>
                              {canEdit && (
                                <Box mt={1}>
                                  <IconButton
                                    size="small"
                                    onClick={() => openEditDialog(entry)}
                                  >
                                    <EditIcon fontSize="small" />
                                  </IconButton>
                                  <IconButton
                                    size="small"
                                    onClick={() => handleDeleteTimetableEntry(entry.id)}
                                  >
                                    <DeleteIcon fontSize="small" />
                                  </IconButton>
                                </Box>
                              )}
                            </Card>
                          ) : (
                            <Typography variant="body2" color="text.secondary" textAlign="center">
                              -
                            </Typography>
                          )}
                        </TableCell>
                      );
                    })}
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        )}

        {/* List View */}
        {selectedTab === 1 && (
          <TableContainer component={Paper}>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell>Day</TableCell>
                  <TableCell>Time</TableCell>
                  <TableCell>Subject</TableCell>
                  <TableCell>Class</TableCell>
                  <TableCell>Section</TableCell>
                  <TableCell>Teacher</TableCell>
                  <TableCell>Room</TableCell>
                  {canEdit && <TableCell>Actions</TableCell>}
                </TableRow>
              </TableHead>
              <TableBody>
                {filteredTimetable.map((entry) => (
                  <TableRow key={entry.id}>
                    <TableCell>{entry.dayOfWeek.charAt(0) + entry.dayOfWeek.slice(1).toLowerCase()}</TableCell>
                    <TableCell>{entry.startTime} - {entry.endTime}</TableCell>
                    <TableCell>{getSubjectName(entry.subjectId)}</TableCell>
                    <TableCell>{getClassName(entry.classId)}</TableCell>
                    <TableCell>{entry.section}</TableCell>
                    <TableCell>{getTeacherName(entry.teacherId)}</TableCell>
                    <TableCell>{entry.roomNumber}</TableCell>
                    {canEdit && (
                      <TableCell>
                        <IconButton
                          size="small"
                          onClick={() => openEditDialog(entry)}
                        >
                          <EditIcon />
                        </IconButton>
                        <IconButton
                          size="small"
                          onClick={() => handleDeleteTimetableEntry(entry.id)}
                        >
                          <DeleteIcon />
                        </IconButton>
                      </TableCell>
                    )}
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        )}

        {/* Create/Edit Dialog */}
        <Dialog open={openDialog} onClose={() => setOpenDialog(false)} maxWidth="md" fullWidth>
          <DialogTitle>
            {timetableForm.id ? 'Edit Timetable Entry' : 'Create New Timetable Entry'}
          </DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 1 }}>
              <Grid item xs={12} sm={6}>
                <FormControl fullWidth>
                  <InputLabel>Day of Week</InputLabel>
                  <Select
                    value={timetableForm.dayOfWeek}
                    onChange={(e) => setTimetableForm({ ...timetableForm, dayOfWeek: e.target.value })}
                    label="Day of Week"
                  >
                    {daysOfWeek.map((day) => (
                      <MenuItem key={day} value={day}>
                        {day.charAt(0) + day.slice(1).toLowerCase()}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} sm={6}>
                <FormControl fullWidth>
                  <InputLabel>Period Number</InputLabel>
                  <Select
                    value={timetableForm.periodNumber}
                    onChange={(e) => setTimetableForm({ ...timetableForm, periodNumber: e.target.value })}
                    label="Period Number"
                  >
                    {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((period) => (
                      <MenuItem key={period} value={period}>
                        Period {period}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} sm={6}>
                <TimePicker
                  label="Start Time"
                  value={timetableForm.startTime}
                  onChange={(time) => setTimetableForm({ ...timetableForm, startTime: time })}
                  renderInput={(params) => <TextField {...params} fullWidth />}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TimePicker
                  label="End Time"
                  value={timetableForm.endTime}
                  onChange={(time) => setTimetableForm({ ...timetableForm, endTime: time })}
                  renderInput={(params) => <TextField {...params} fullWidth />}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <FormControl fullWidth>
                  <InputLabel>Subject</InputLabel>
                  <Select
                    value={timetableForm.subjectId}
                    onChange={(e) => setTimetableForm({ ...timetableForm, subjectId: e.target.value })}
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
                    value={timetableForm.classId}
                    onChange={(e) => setTimetableForm({ ...timetableForm, classId: e.target.value })}
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
                    value={timetableForm.section}
                    onChange={(e) => setTimetableForm({ ...timetableForm, section: e.target.value })}
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
                  <InputLabel>Teacher</InputLabel>
                  <Select
                    value={timetableForm.teacherId}
                    onChange={(e) => setTimetableForm({ ...timetableForm, teacherId: e.target.value })}
                    label="Teacher"
                  >
                    {teachers.map((teacher) => (
                      <MenuItem key={teacher.id} value={teacher.id}>
                        {teacher.name}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  label="Room Number"
                  value={timetableForm.roomNumber}
                  onChange={(e) => setTimetableForm({ ...timetableForm, roomNumber: e.target.value })}
                />
              </Grid>
            </Grid>
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setOpenDialog(false)}>Cancel</Button>
            <Button
              onClick={timetableForm.id ? () => handleUpdateTimetableEntry(timetableForm.id) : handleCreateTimetableEntry}
              variant="contained"
            >
              {timetableForm.id ? 'Update' : 'Create'}
            </Button>
          </DialogActions>
        </Dialog>
      </Box>
    </LocalizationProvider>
  );
};

export default Timetable; 