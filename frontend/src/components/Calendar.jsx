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
  Badge,
  Tooltip,
  List,
  ListItem,
  ListItemText
} from '@mui/material';
import {
  Add as AddIcon,
  CalendarToday as CalendarIcon,
  Event as EventIcon,
  HolidayVillage as HolidayIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Visibility as ViewIcon,
  ChevronLeft as ChevronLeftIcon,
  ChevronRight as ChevronRightIcon
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { format, startOfMonth, endOfMonth, eachDayOfInterval, isSameMonth, isSameDay, addMonths, subMonths, startOfWeek, endOfWeek } from 'date-fns';

const Calendar = ({ userRole, userId }) => {
  const [currentDate, setCurrentDate] = useState(new Date());
  const [events, setEvents] = useState([]);
  const [holidays, setHolidays] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedEvent, setSelectedEvent] = useState(null);
  const [viewMode, setViewMode] = useState('calendar'); // 'calendar' or 'list'
  const [selectedDate, setSelectedDate] = useState(null);
  const [dateEvents, setDateEvents] = useState([]);

  // Form state for creating/editing events/holidays
  const [eventForm, setEventForm] = useState({
    title: '',
    description: '',
    startDate: new Date(),
    endDate: new Date(),
    type: 'EVENT', // 'EVENT' or 'HOLIDAY'
    color: '#1976d2',
    isRecurring: false,
    recurringType: 'YEARLY' // 'YEARLY', 'MONTHLY', 'WEEKLY'
  });

  useEffect(() => {
    loadCalendarData();
  }, [currentDate]);

  const loadCalendarData = async () => {
    try {
      setLoading(true);
      
      // Load events
      const eventsResponse = await fetch('/api/calendar/events');
      if (eventsResponse.ok) {
        const eventsData = await eventsResponse.json();
        setEvents(Array.isArray(eventsData) ? eventsData : []);
      } else {
        console.error('Failed to load events:', eventsResponse.status);
        setEvents([]);
      }

      // Load holidays
      const holidaysResponse = await fetch('/api/calendar/holidays');
      if (holidaysResponse.ok) {
        const holidaysData = await holidaysResponse.json();
        setHolidays(Array.isArray(holidaysData) ? holidaysData : []);
      } else {
        console.error('Failed to load holidays:', holidaysResponse.status);
        setHolidays([]);
      }
    } catch (err) {
      setError('Failed to load calendar data');
      console.error(err);
      setEvents([]);
      setHolidays([]);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateEvent = async () => {
    try {
      const response = await fetch('/api/calendar/events', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...eventForm,
          createdBy: userId
        }),
      });

      if (response.ok) {
        setOpenDialog(false);
        resetForm();
        loadCalendarData();
      } else {
        setError('Failed to create event');
      }
    } catch (err) {
      setError('Failed to create event');
      console.error(err);
    }
  };

  const handleUpdateEvent = async (eventId) => {
    try {
      const response = await fetch(`/api/calendar/events/${eventId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...eventForm,
          updatedBy: userId
        }),
      });

      if (response.ok) {
        setOpenDialog(false);
        resetForm();
        loadCalendarData();
      } else {
        setError('Failed to update event');
      }
    } catch (err) {
      setError('Failed to update event');
      console.error(err);
    }
  };

  const handleDeleteEvent = async (eventId, type) => {
    if (window.confirm('Are you sure you want to delete this item?')) {
      try {
        const endpoint = type === 'HOLIDAY' ? 'holidays' : 'events';
        const response = await fetch(`/api/calendar/${endpoint}/${eventId}`, {
          method: 'DELETE',
        });

        if (response.ok) {
          loadCalendarData();
        } else {
          setError('Failed to delete item');
        }
      } catch (err) {
        setError('Failed to delete item');
        console.error(err);
      }
    }
  };

  const resetForm = () => {
    setEventForm({
      title: '',
      description: '',
      startDate: new Date(),
      endDate: new Date(),
      type: 'EVENT',
      color: '#1976d2',
      isRecurring: false,
      recurringType: 'YEARLY'
    });
    setSelectedEvent(null);
  };

  const openCreateDialog = (type = 'EVENT') => {
    resetForm();
    setEventForm(prev => ({ ...prev, type }));
    setOpenDialog(true);
  };

  const openEditDialog = (item, type) => {
    setSelectedEvent(item);
    setEventForm({
      id: item.id,
      title: item.title,
      description: item.description,
      startDate: new Date(item.startDate),
      endDate: new Date(item.endDate),
      type: type,
      color: item.color || '#1976d2',
      isRecurring: item.isRecurring || false,
      recurringType: item.recurringType || 'YEARLY'
    });
    setOpenDialog(true);
  };

  const openDateDialog = (date) => {
    setSelectedDate(date);
    const dateStr = format(date, 'yyyy-MM-dd');
    const dayEvents = [
      ...(Array.isArray(events) ? events.filter(event => 
        isSameDay(new Date(event.startDate), date) || 
        (new Date(event.startDate) <= date && new Date(event.endDate) >= date)
      ) : []),
      ...(Array.isArray(holidays) ? holidays.filter(holiday => 
        isSameDay(new Date(holiday.startDate), date) || 
        (new Date(holiday.startDate) <= date && new Date(holiday.endDate) >= date)
      ) : [])
    ];
    setDateEvents(dayEvents);
  };

  const getEventsForDate = (date) => {
    const dateStr = format(date, 'yyyy-MM-dd');
    const dayEvents = Array.isArray(events) ? events.filter(event => 
      isSameDay(new Date(event.startDate), date) || 
      (new Date(event.startDate) <= date && new Date(event.endDate) >= date)
    ) : [];
    const dayHolidays = Array.isArray(holidays) ? holidays.filter(holiday => 
      isSameDay(new Date(holiday.startDate), date) || 
      (new Date(holiday.startDate) <= date && new Date(holiday.endDate) >= date)
    ) : [];
    return [...dayEvents, ...dayHolidays];
  };

  const renderCalendar = () => {
    const monthStart = startOfMonth(currentDate);
    const monthEnd = endOfMonth(currentDate);
    const startDate = startOfWeek(monthStart);
    const endDate = endOfWeek(monthEnd);
    const days = eachDayOfInterval({ start: startDate, end: endDate });

    return (
      <Paper elevation={1}>
        <Box p={2}>
          <Grid container spacing={1}>
            {['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map(day => (
              <Grid item xs key={day}>
                <Typography variant="subtitle2" align="center" sx={{ fontWeight: 'bold', py: 1 }}>
                  {day}
                </Typography>
              </Grid>
            ))}
            {days.map(day => {
              const dayEvents = getEventsForDate(day);
              const isCurrentMonth = isSameMonth(day, currentDate);
              const isToday = isSameDay(day, new Date());
              
              return (
                <Grid item xs key={day.toString()}>
                  <Box
                    sx={{
                      minHeight: 80,
                      p: 1,
                      border: '1px solid #e0e0e0',
                      backgroundColor: isToday ? '#f0f8ff' : 'white',
                      cursor: 'pointer',
                      '&:hover': {
                        backgroundColor: '#f5f5f5'
                      }
                    }}
                    onClick={() => openDateDialog(day)}
                  >
                    <Typography
                      variant="body2"
                      sx={{
                        color: isCurrentMonth ? 'text.primary' : 'text.disabled',
                        fontWeight: isToday ? 'bold' : 'normal'
                      }}
                    >
                      {format(day, 'd')}
                    </Typography>
                    <Box sx={{ mt: 0.5 }}>
                      {dayEvents.slice(0, 2).map((event, index) => (
                        <Chip
                          key={index}
                          label={event.title}
                          size="small"
                          sx={{
                            fontSize: '0.6rem',
                            height: 16,
                            backgroundColor: event.color || '#1976d2',
                            color: 'white',
                            mb: 0.5,
                            '& .MuiChip-label': {
                              px: 0.5
                            }
                          }}
                        />
                      ))}
                      {dayEvents.length > 2 && (
                        <Typography variant="caption" color="text.secondary">
                          +{dayEvents.length - 2} more
                        </Typography>
                      )}
                    </Box>
                  </Box>
                </Grid>
              );
            })}
          </Grid>
        </Box>
      </Paper>
    );
  };

  const renderListView = () => {
    const allItems = [...(Array.isArray(events) ? events : []), ...(Array.isArray(holidays) ? holidays : [])].sort((a, b) => new Date(a.startDate) - new Date(b.startDate));
    
    return (
      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Title</TableCell>
              <TableCell>Type</TableCell>
              <TableCell>Start Date</TableCell>
              <TableCell>End Date</TableCell>
              <TableCell>Description</TableCell>
              {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN') && <TableCell>Actions</TableCell>}
            </TableRow>
          </TableHead>
          <TableBody>
            {allItems.map((item) => (
              <TableRow key={item.id}>
                <TableCell>
                  <Box display="flex" alignItems="center">
                    <Box
                      sx={{
                        width: 12,
                        height: 12,
                        borderRadius: '50%',
                        backgroundColor: item.color || '#1976d2',
                        mr: 1
                      }}
                    />
                    {item.title}
                  </Box>
                </TableCell>
                <TableCell>
                  <Chip
                    icon={item.type === 'HOLIDAY' ? <HolidayIcon /> : <EventIcon />}
                    label={item.type}
                    size="small"
                    color={item.type === 'HOLIDAY' ? 'warning' : 'primary'}
                  />
                </TableCell>
                <TableCell>{format(new Date(item.startDate), 'MMM dd, yyyy')}</TableCell>
                <TableCell>{format(new Date(item.endDate), 'MMM dd, yyyy')}</TableCell>
                <TableCell>{item.description}</TableCell>
                {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN') && (
                  <TableCell>
                    <IconButton
                      size="small"
                      onClick={() => openEditDialog(item, item.type)}
                    >
                      <EditIcon />
                    </IconButton>
                    <IconButton
                      size="small"
                      onClick={() => handleDeleteEvent(item.id, item.type)}
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
    );
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
            <CalendarIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
            School Calendar
          </Typography>
          {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN') && (
            <Box>
              <Button
                variant="contained"
                startIcon={<AddIcon />}
                onClick={() => openCreateDialog('EVENT')}
                sx={{ mr: 1 }}
              >
                Add Event
              </Button>
              <Button
                variant="outlined"
                startIcon={<HolidayIcon />}
                onClick={() => openCreateDialog('HOLIDAY')}
              >
                Add Holiday
              </Button>
            </Box>
          )}
        </Box>

        {/* Admin Note */}
        {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN') && (
          <Alert severity="info" sx={{ mb: 2 }}>
            <strong>Admin Access:</strong> You can create and manage school events and holidays. Events can be recurring (yearly, monthly, or weekly).
          </Alert>
        )}

        {/* Navigation */}
        <Card sx={{ mb: 3 }}>
          <CardContent>
            <Box display="flex" justifyContent="space-between" alignItems="center">
              <Box display="flex" alignItems="center">
                <IconButton onClick={() => setCurrentDate(subMonths(currentDate, 1))}>
                  <ChevronLeftIcon />
                </IconButton>
                <Typography variant="h6" sx={{ mx: 2 }}>
                  {format(currentDate, 'MMMM yyyy')}
                </Typography>
                <IconButton onClick={() => setCurrentDate(addMonths(currentDate, 1))}>
                  <ChevronRightIcon />
                </IconButton>
              </Box>
              <Box>
                <Button
                  variant={viewMode === 'calendar' ? 'contained' : 'outlined'}
                  onClick={() => setViewMode('calendar')}
                  sx={{ mr: 1 }}
                >
                  Calendar View
                </Button>
                <Button
                  variant={viewMode === 'list' ? 'contained' : 'outlined'}
                  onClick={() => setViewMode('list')}
                >
                  List View
                </Button>
              </Box>
            </Box>
          </CardContent>
        </Card>

        {/* Calendar/List View */}
        {viewMode === 'calendar' ? renderCalendar() : renderListView()}

        {/* Create/Edit Dialog */}
        <Dialog open={openDialog} onClose={() => setOpenDialog(false)} maxWidth="md" fullWidth>
          <DialogTitle>
            {selectedEvent ? 'Edit' : 'Create'} {eventForm.type === 'HOLIDAY' ? 'Holiday' : 'Event'}
          </DialogTitle>
          <DialogContent>
            <Grid container spacing={2} sx={{ mt: 1 }}>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  label="Title"
                  value={eventForm.title}
                  onChange={(e) => setEventForm({ ...eventForm, title: e.target.value })}
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  fullWidth
                  multiline
                  rows={3}
                  label="Description"
                  value={eventForm.description}
                  onChange={(e) => setEventForm({ ...eventForm, description: e.target.value })}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <DatePicker
                  label="Start Date"
                  value={eventForm.startDate}
                  onChange={(date) => setEventForm({ ...eventForm, startDate: date })}
                  renderInput={(params) => <TextField {...params} fullWidth />}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <DatePicker
                  label="End Date"
                  value={eventForm.endDate}
                  onChange={(date) => setEventForm({ ...eventForm, endDate: date })}
                  renderInput={(params) => <TextField {...params} fullWidth />}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  fullWidth
                  type="color"
                  label="Color"
                  value={eventForm.color}
                  onChange={(e) => setEventForm({ ...eventForm, color: e.target.value })}
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <FormControl fullWidth>
                  <InputLabel>Recurring Type</InputLabel>
                  <Select
                    value={eventForm.recurringType}
                    onChange={(e) => setEventForm({ ...eventForm, recurringType: e.target.value })}
                    label="Recurring Type"
                    disabled={!eventForm.isRecurring}
                  >
                    <MenuItem value="YEARLY">Yearly</MenuItem>
                    <MenuItem value="MONTHLY">Monthly</MenuItem>
                    <MenuItem value="WEEKLY">Weekly</MenuItem>
                  </Select>
                </FormControl>
              </Grid>
            </Grid>
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setOpenDialog(false)}>Cancel</Button>
            <Button
              onClick={selectedEvent ? () => handleUpdateEvent(selectedEvent.id) : handleCreateEvent}
              variant="contained"
            >
              {selectedEvent ? 'Update' : 'Create'}
            </Button>
          </DialogActions>
        </Dialog>

        {/* Date Events Dialog */}
        <Dialog open={!!selectedDate} onClose={() => setSelectedDate(null)} maxWidth="sm" fullWidth>
          <DialogTitle>
            Events for {selectedDate && format(selectedDate, 'MMMM dd, yyyy')}
          </DialogTitle>
          <DialogContent>
            {dateEvents.length === 0 ? (
              <Typography color="text.secondary">No events scheduled for this date.</Typography>
            ) : (
              <List>
                {dateEvents.map((event, index) => (
                  <ListItem key={index}>
                    <ListItemText
                      primary={event.title}
                      secondary={event.description}
                    />
                    <Chip
                      icon={event.type === 'HOLIDAY' ? <HolidayIcon /> : <EventIcon />}
                      label={event.type}
                      size="small"
                      color={event.type === 'HOLIDAY' ? 'warning' : 'primary'}
                    />
                  </ListItem>
                ))}
              </List>
            )}
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setSelectedDate(null)}>Close</Button>
          </DialogActions>
        </Dialog>
      </Box>
    </LocalizationProvider>
  );
};

export default Calendar; 