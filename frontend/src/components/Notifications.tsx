import React, { useState, useEffect } from 'react';
import {
  Box,
  Card,
  CardContent,
  Typography,
  Grid,
  Chip,
  Button,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  List,
  ListItem,
  ListItemText,
  ListItemIcon,
  IconButton,
  Alert,
  CircularProgress,
  Divider,
  Badge,
  Tabs,
  Tab,
  Paper,
  FormControlLabel,
  Checkbox,
  FormGroup,
  Snackbar
} from '@mui/material';
import {
  Notifications as NotificationsIcon,
  NotificationsActive as NotificationsActiveIcon,
  NotificationsOff as NotificationsOffIcon,
  School as SchoolIcon,
  Class as ClassIcon,
  Send as SendIcon,
  Add as AddIcon,
  Delete as DeleteIcon,
  Edit as EditIcon,
  Announcement as AnnouncementIcon,
  Event as EventIcon,
  Info as InfoIcon,
  Warning as WarningIcon,
  Error as ErrorIcon,
  CheckCircle as CheckCircleIcon,
  WhatsApp as WhatsAppIcon,
  Email as EmailIcon
} from '@mui/icons-material';

interface Notification {
  id: number;
  title: string;
  message: string;
  type: 'holiday' | 'circular' | 'event' | 'reminder';
  priority: 'high' | 'medium' | 'low';
  targetAudience: 'all' | 'class';
  class: string | null;
  section: string | null;
  createdAt: string;
  read: boolean;
  sentBy: string;
}

interface NotificationsProps {
  userRole: string;
}

const Notifications: React.FC<NotificationsProps> = ({ userRole }) => {
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedTab, setSelectedTab] = useState(0);
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedSection, setSelectedSection] = useState('');
  const [filterType, setFilterType] = useState('all');
  
  // WhatsApp notification states
  const [notificationTitle, setNotificationTitle] = useState('');
  const [notificationMessage, setNotificationMessage] = useState('');
  const [notificationType, setNotificationType] = useState('circular');
  const [notificationPriority, setNotificationPriority] = useState('medium');
  const [sendEmail, setSendEmail] = useState(true);
  const [sendWhatsApp, setSendWhatsApp] = useState(true);
  const [phoneNumbers, setPhoneNumbers] = useState<string[]>([]);
  const [emailAddresses, setEmailAddresses] = useState<string[]>([]);
  const [sendingNotification, setSendingNotification] = useState(false);
  
  // Parent notification states
  const [selectedStudents, setSelectedStudents] = useState<number[]>([]);
  const [selectedClassForNotification, setSelectedClassForNotification] = useState<number | null>(null);
  const [students, setStudents] = useState<any[]>([]);
  const [classes, setClasses] = useState<any[]>([]);
  const [notificationTarget, setNotificationTarget] = useState<'manual' | 'parents' | 'classParents'>('manual');
  
  // Snackbar states
  const [snackbarOpen, setSnackbarOpen] = useState(false);
  const [snackbarMessage, setSnackbarMessage] = useState('');
  const [snackbarSeverity, setSnackbarSeverity] = useState<'success' | 'error' | 'info' | 'warning'>('success');

  useEffect(() => {
    loadNotifications();
  }, []);

  const loadNotifications = async () => {
    try {
      setLoading(true);
      // Mock data - replace with API call
      const mockNotifications: Notification[] = [
        {
          id: 1,
          title: 'School Holiday - Republic Day',
          message: 'School will be closed on 26th January 2024 for Republic Day celebrations.',
          type: 'holiday',
          priority: 'high',
          targetAudience: 'all',
          class: null,
          section: null,
          createdAt: '2024-01-20T10:00:00Z',
          read: false,
          sentBy: 'Principal'
        },
        {
          id: 2,
          title: 'Parent-Teacher Meeting',
          message: 'Parent-Teacher meeting scheduled for Class 10 students on 30th January 2024.',
          type: 'circular',
          priority: 'medium',
          targetAudience: 'class',
          class: 'Class 10',
          section: 'A',
          createdAt: '2024-01-19T14:30:00Z',
          read: true,
          sentBy: 'Class Teacher'
        },
        {
          id: 3,
          title: 'Sports Day Event',
          message: 'Annual Sports Day will be held on 15th February 2024. All students must participate.',
          type: 'event',
          priority: 'medium',
          targetAudience: 'all',
          class: null,
          section: null,
          createdAt: '2024-01-18T09:15:00Z',
          read: false,
          sentBy: 'Sports Department'
        },
        {
          id: 4,
          title: 'Fee Payment Reminder',
          message: 'This is a reminder that the second installment of school fees is due by 31st January 2024.',
          type: 'reminder',
          priority: 'high',
          targetAudience: 'all',
          class: null,
          section: null,
          createdAt: '2024-01-17T16:45:00Z',
          read: true,
          sentBy: 'Accounts Department'
        },
        {
          id: 5,
          title: 'Science Exhibition',
          message: 'Science exhibition for Class 8-10 students will be held on 10th February 2024.',
          type: 'event',
          priority: 'low',
          targetAudience: 'class',
          class: 'Class 8-10',
          section: null,
          createdAt: '2024-01-16T11:20:00Z',
          read: false,
          sentBy: 'Science Department'
        }
      ];
      
      setNotifications(mockNotifications);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleTabChange = (event: React.SyntheticEvent, newValue: number) => {
    setSelectedTab(newValue);
  };

  const resetNotificationForm = () => {
    setNotificationTitle('');
    setNotificationMessage('');
    setNotificationType('circular');
    setNotificationPriority('medium');
    setSelectedClassForNotification(null);
    setSelectedSection('');
    setSelectedStudents([]);
    setNotificationTarget('manual');
    setSendEmail(true);
    setSendWhatsApp(true);
    setPhoneNumbers([]);
    setEmailAddresses([]);
  };

  const handleCloseDialog = () => {
    setOpenDialog(false);
    resetNotificationForm();
  };

  const handleSendNotification = async () => {
    if (!notificationTitle.trim() || !notificationMessage.trim()) {
      alert('Please fill in all required fields');
      return;
    }

    setSendingNotification(true);
    
    try {
      let notificationEndpoint = '';
      let requestBody: any = {};
      
      // Determine notification target and endpoint
      switch (notificationTarget) {
        case 'parents':
          if (selectedStudents.length === 0) {
            alert('Please select at least one student');
            return;
          }
          notificationEndpoint = '/api/notifications/parents';
          requestBody = {
            studentIds: selectedStudents,
            title: notificationTitle,
            message: notificationMessage,
            channels: sendEmail && sendWhatsApp ? 'both' : sendEmail ? 'email' : 'whatsapp'
          };
          break;
          
                 case 'classParents':
           if (!selectedClassForNotification) {
             alert('Please select a class');
             return;
           }
           notificationEndpoint = `/api/notifications/class/${selectedClassForNotification}/parents`;
          requestBody = {
            title: notificationTitle,
            message: notificationMessage,
            channels: sendEmail && sendWhatsApp ? 'both' : sendEmail ? 'email' : 'whatsapp'
          };
          break;
          
        default: // manual
          // Use existing manual notification logic
          const promises: Promise<Response>[] = [];
          
          if (sendEmail && emailAddresses.length > 0) {
            emailAddresses.forEach(email => {
              promises.push(
                fetch('/api/notifications/email', {
                  method: 'POST',
                  headers: { 'Content-Type': 'application/json' },
                  body: JSON.stringify({
                    to: email,
                    subject: notificationTitle,
                    body: notificationMessage
                  })
                })
              );
            });
          }
          
          if (sendWhatsApp && phoneNumbers.length > 0) {
            phoneNumbers.forEach(phone => {
              promises.push(
                fetch('/api/notifications/whatsapp', {
                  method: 'POST',
                  headers: { 'Content-Type': 'application/json' },
                  body: JSON.stringify({
                    phoneNumber: phone,
                    message: notificationMessage
                  })
                })
              );
            });
          }
          
          await Promise.all(promises);
          break;
      }
      
      // Send student/class/parent notifications
      if (notificationTarget !== 'manual') {
        await fetch(notificationEndpoint, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(requestBody)
        });
      }
      
      // Create notification object for local display
      const newNotification: Notification = {
        id: notifications.length + 1,
        title: notificationTitle,
        message: notificationMessage,
        type: notificationType as any,
        priority: notificationPriority as any,
        targetAudience: notificationTarget === 'classParents' ? 'class' : 'all',
        class: selectedClassForNotification ? 'Class ' + selectedClassForNotification : null,
        section: selectedSection,
        createdAt: new Date().toISOString(),
        read: false,
        sentBy: 'Admin'
      };
      
      // Add to local notifications list
      setNotifications([newNotification, ...notifications]);
      
      // Reset form and close dialog
      resetNotificationForm();
      setOpenDialog(false);
      
      // Show success message
      setSnackbarMessage('Notification sent successfully!');
      setSnackbarSeverity('success');
      setSnackbarOpen(true);
    } catch (error) {
      console.error('Error sending notification:', error);
      setSnackbarMessage('Failed to send notification. Please try again.');
      setSnackbarSeverity('error');
      setSnackbarOpen(true);
    } finally {
      setSendingNotification(false);
    }
  };

  const getNotificationIcon = (type: string) => {
    switch (type) {
      case 'holiday': return <EventIcon color="primary" />;
      case 'circular': return <AnnouncementIcon color="info" />;
      case 'event': return <SchoolIcon color="secondary" />;
      case 'reminder': return <InfoIcon color="warning" />;
      default: return <NotificationsIcon />;
    }
  };

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'high': return 'error';
      case 'medium': return 'warning';
      case 'low': return 'info';
      default: return 'default';
    }
  };

  const getTypeColor = (type: string) => {
    switch (type) {
      case 'holiday': return 'primary';
      case 'circular': return 'info';
      case 'event': return 'secondary';
      case 'reminder': return 'warning';
      default: return 'default';
    }
  };

  const filteredNotifications = notifications.filter(notification => {
    if (selectedTab === 0) return true; // All notifications
    if (selectedTab === 1) return !notification.read; // Unread
    if (selectedTab === 2) return notification.read; // Read
    return true;
  });

  const unreadCount = notifications.filter(n => !n.read).length;

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="400px">
        <CircularProgress />
      </Box>
    );
  }

  return (
    <Box>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">
          <NotificationsIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
          Notifications
        </Typography>
        {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN' || userRole === 'TEACHER') && (
          <Button
            variant="contained"
            startIcon={<AddIcon />}
            onClick={() => setOpenDialog(true)}
          >
            Send Notification
          </Button>
        )}
      </Box>

      <Paper sx={{ mb: 3 }}>
        <Tabs value={selectedTab} onChange={handleTabChange} aria-label="notification tabs">
          <Tab 
            label={
              <Box display="flex" alignItems="center">
                All Notifications
                <Badge badgeContent={notifications.length} color="primary" sx={{ ml: 1 }} />
              </Box>
            } 
          />
          <Tab 
            label={
              <Box display="flex" alignItems="center">
                Unread
                <Badge badgeContent={unreadCount} color="error" sx={{ ml: 1 }} />
              </Box>
            } 
          />
          <Tab label="Read" />
        </Tabs>
      </Paper>

      <Grid container spacing={2}>
        {filteredNotifications.map((notification) => (
          <Grid item xs={12} key={notification.id}>
            <Card 
              sx={{ 
                borderLeft: 4, 
                borderColor: notification.read ? 'grey.300' : 'primary.main',
                opacity: notification.read ? 0.8 : 1
              }}
            >
              <CardContent>
                <Box display="flex" justifyContent="space-between" alignItems="flex-start">
                  <Box display="flex" alignItems="center" flex={1}>
                    <ListItemIcon sx={{ minWidth: 40 }}>
                      {getNotificationIcon(notification.type)}
                    </ListItemIcon>
                    <Box flex={1}>
                      <Box display="flex" alignItems="center" gap={1} mb={1}>
                        <Typography variant="h6" component="h3">
                          {notification.title}
                        </Typography>
                        <Chip 
                          label={notification.type.toUpperCase()} 
                          color={getTypeColor(notification.type)}
                          size="small"
                        />
                        <Chip 
                          label={notification.priority.toUpperCase()} 
                          color={getPriorityColor(notification.priority)}
                          size="small"
                        />
                        {!notification.read && (
                          <Chip 
                            label="NEW" 
                            color="error" 
                            size="small"
                            icon={<NotificationsActiveIcon />}
                          />
                        )}
                      </Box>
                      
                      <Typography variant="body1" color="text.secondary" paragraph>
                        {notification.message}
                      </Typography>
                      
                      <Box display="flex" alignItems="center" gap={2} flexWrap="wrap">
                        <Typography variant="body2" color="text.secondary">
                          <SchoolIcon sx={{ mr: 0.5, fontSize: 'small' }} />
                          {notification.targetAudience === 'all' ? 'All Students' : 
                           `${notification.class}${notification.section ? ` - Section ${notification.section}` : ''}`}
                        </Typography>
                        <Typography variant="body2" color="text.secondary">
                          Sent by: {notification.sentBy}
                        </Typography>
                        <Typography variant="body2" color="text.secondary">
                          {new Date(notification.createdAt).toLocaleDateString()} at{' '}
                          {new Date(notification.createdAt).toLocaleTimeString()}
                        </Typography>
                      </Box>
                    </Box>
                  </Box>
                  
                  {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN') && (
                    <Box display="flex" gap={1}>
                      <IconButton size="small" color="primary">
                        <EditIcon />
                      </IconButton>
                      <IconButton size="small" color="error">
                        <DeleteIcon />
                      </IconButton>
                    </Box>
                  )}
                </Box>
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>

      {filteredNotifications.length === 0 && (
        <Box textAlign="center" py={4}>
          <NotificationsOffIcon sx={{ fontSize: 64, color: 'grey.400', mb: 2 }} />
          <Typography variant="h6" color="text.secondary">
            No notifications found
          </Typography>
        </Box>
      )}

      {/* Send Notification Dialog */}
      <Dialog open={openDialog} onClose={handleCloseDialog} maxWidth="md" fullWidth>
        <DialogTitle>Send New Notification</DialogTitle>
        <DialogContent>
          <Alert severity="info" sx={{ mb: 2 }}>
            Fields marked with * are required. Please fill in all required fields before sending.
            {userRole === 'TEACHER' && (
              <Box mt={1}>
                <strong>Note for Teachers:</strong> You can only send notifications to the classes you are assigned to teach.
              </Box>
            )}
          </Alert>
          <Grid container spacing={2} sx={{ mt: 1 }}>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Notification Title *"
                placeholder="Enter notification title"
                value={notificationTitle}
                onChange={(e) => setNotificationTitle(e.target.value)}
                required
                error={!notificationTitle.trim()}
                helperText={!notificationTitle.trim() ? 'Title is required' : ''}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Message *"
                multiline
                rows={4}
                placeholder="Enter notification message"
                value={notificationMessage}
                onChange={(e) => setNotificationMessage(e.target.value)}
                required
                error={!notificationMessage.trim()}
                helperText={!notificationMessage.trim() ? 'Message is required' : ''}
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Type *</InputLabel>
                <Select 
                  label="Type *"
                  value={notificationType}
                  onChange={(e) => setNotificationType(e.target.value)}
                  required
                >
                  <MenuItem value="circular">Circular</MenuItem>
                  <MenuItem value="holiday">Holiday</MenuItem>
                  <MenuItem value="event">Event</MenuItem>
                  <MenuItem value="reminder">Reminder</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Priority *</InputLabel>
                <Select 
                  label="Priority *"
                  value={notificationPriority}
                  onChange={(e) => setNotificationPriority(e.target.value)}
                  required
                >
                  <MenuItem value="low">Low</MenuItem>
                  <MenuItem value="medium">Medium</MenuItem>
                  <MenuItem value="high">High</MenuItem>
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Target Class (Optional)</InputLabel>
                                 <Select 
                   value={selectedClassForNotification?.toString() || ''} 
                   onChange={(e) => setSelectedClassForNotification(e.target.value ? parseInt(e.target.value, 10) : null)}
                   label="Target Class (Optional)"
                 >
                  <MenuItem value="">All Classes</MenuItem>
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
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Target Section (Optional)</InputLabel>
                <Select 
                  value={selectedSection} 
                  onChange={(e) => setSelectedSection(e.target.value)}
                  label="Target Section (Optional)"
                                     disabled={!selectedClassForNotification}
                >
                  <MenuItem value="">All Sections</MenuItem>
                  <MenuItem value="A">Section A</MenuItem>
                  <MenuItem value="B">Section B</MenuItem>
                  <MenuItem value="C">Section C</MenuItem>
                  <MenuItem value="D">Section D</MenuItem>
                </Select>
              </FormControl>
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Cancel</Button>
          <Button 
            onClick={handleSendNotification} 
            variant="contained" 
            startIcon={<SendIcon />}
            disabled={!notificationTitle.trim() || !notificationMessage.trim() || sendingNotification}
          >
            {sendingNotification ? <CircularProgress size={20} /> : 'Send Notification'}
          </Button>
        </DialogActions>
      </Dialog>
      
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
    </Box>
  );
};

export default Notifications; 