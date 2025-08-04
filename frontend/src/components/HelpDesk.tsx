import React, { useState, useEffect } from 'react';
import {
  Container,
  Typography,
  Button,
  Box,
  Card,
  CardContent,
  Grid,
  Tabs,
  Tab,
  Chip,
  IconButton,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Alert,
  CircularProgress,
  LinearProgress,
  Divider,
  List,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  Switch,
  Accordion,
  AccordionSummary,
  AccordionDetails,
  Tooltip,
  ButtonGroup,
  Avatar,
  Badge
} from '@mui/material';
import {
  Add as AddIcon,
  Support as SupportIcon,
  Message as MessageIcon,
  Reply as ReplyIcon,
  Close as CloseIcon,
  CheckCircle as CheckCircleIcon,
  Warning as WarningIcon,
  Schedule as ScheduleIcon,
  PriorityHigh as PriorityHighIcon,
  LowPriority as LowPriorityIcon,
  ExpandMore as ExpandMoreIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Visibility as VisibilityIcon,
  Assignment as AssignmentIcon,
  Person as PersonIcon,
  Email as EmailIcon,
  Phone as PhoneIcon,
  CalendarToday as CalendarIcon,
  Category as CategoryIcon
} from '@mui/icons-material';
import { useAuth } from '../contexts/AuthContext';
import { helpDeskAPI, Ticket, TicketResponse, TicketForm } from '../services/helpDeskAPI';

const HelpDesk: React.FC = () => {
  const { user } = useAuth();
  const [selectedTab, setSelectedTab] = useState(0);
  const userRole = user?.role || 'USER';
  const [loading, setLoading] = useState(false);
  const [tickets, setTickets] = useState<Ticket[]>([]);
  const [selectedTicket, setSelectedTicket] = useState<Ticket | null>(null);
  const [openTicketDialog, setOpenTicketDialog] = useState(false);
  const [openResponseDialog, setOpenResponseDialog] = useState(false);
  const [openViewDialog, setOpenViewDialog] = useState(false);
  const [responseMessage, setResponseMessage] = useState('');
  const [savingResponse, setSavingResponse] = useState(false);
  const [savingTicket, setSavingTicket] = useState(false);

  // Form states for new ticket
  const [ticketForm, setTicketForm] = useState<TicketForm>({
    title: '',
    description: '',
    category: '',
    priority: 'MEDIUM'
  });

  // Categories for tickets
  const categories = [
    'Fee Related',
    'Academic',
    'Technical',
    'Transport',
    'General',
    'Complaint',
    'Suggestion'
  ];

  useEffect(() => {
    loadTickets();
  }, []);

  const loadTickets = async () => {
    setLoading(true);
    try {
      let tickets: Ticket[];
      
      if (userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN') {
        tickets = await helpDeskAPI.getAllTickets();
      } else if (userRole === 'PARENT') {
        tickets = await helpDeskAPI.getTicketsByUserPhone(user?.username || '');
      } else {
        tickets = [];
      }

      setTickets(tickets);
    } catch (error) {
      console.error('Error loading tickets:', error);
      // Fallback to empty array if API fails
      setTickets([]);
    } finally {
      setLoading(false);
    }
  };

  const handleTabChange = (event: React.SyntheticEvent, newValue: number) => {
    setSelectedTab(newValue);
  };

  const handleCreateTicket = () => {
    setTicketForm({
      title: '',
      description: '',
      category: '',
      priority: 'MEDIUM'
    });
    setOpenTicketDialog(true);
  };

  const handleSaveTicket = async () => {
    try {
      setSavingTicket(true);
      
      // Validate form
      if (!ticketForm.title.trim() || !ticketForm.description.trim() || !ticketForm.category) {
        alert('Please fill in all required fields');
        return;
      }

      // Create ticket via API
      const newTicket = await helpDeskAPI.createTicket(ticketForm, {
        fullName: user?.fullName || 'Unknown',
        phone: user?.username || ''
      });

      setTickets(prev => [newTicket, ...prev]);
      setOpenTicketDialog(false);
      
      // Show success message
      alert('Ticket created successfully!');
      
    } catch (error) {
      console.error('Error creating ticket:', error);
      alert('Failed to create ticket. Please try again.');
    } finally {
      setSavingTicket(false);
    }
  };

  const handleViewTicket = (ticket: Ticket) => {
    setSelectedTicket(ticket);
    setOpenViewDialog(true);
  };

  const handleRespondToTicket = (ticket: Ticket) => {
    setSelectedTicket(ticket);
    setResponseMessage('');
    setOpenResponseDialog(true);
  };

  const handleSaveResponse = async () => {
    try {
      setSavingResponse(true);
      
      if (!responseMessage.trim()) {
        alert('Please enter a response message');
        return;
      }

      if (!selectedTicket) return;

      // Add response via API
      const newResponse = await helpDeskAPI.addResponse(selectedTicket.id, {
        message: responseMessage.trim(),
        respondedBy: user?.fullName || 'Unknown',
        respondedByRole: userRole
      });

      // Reload tickets to get updated data
      await loadTickets();

      setOpenResponseDialog(false);
      setResponseMessage('');
      
      // Show success message
      alert('Response added successfully!');
      
    } catch (error) {
      console.error('Error saving response:', error);
      alert('Failed to save response. Please try again.');
    } finally {
      setSavingResponse(false);
    }
  };

  const handleUpdateTicketStatus = async (ticketId: number, newStatus: Ticket['status']) => {
    try {
      // Update ticket status via API
      await helpDeskAPI.updateTicketStatus(ticketId, newStatus);
      
      // Reload tickets to get updated data
      await loadTickets();
      
      alert('Ticket status updated successfully!');
    } catch (error) {
      console.error('Error updating ticket status:', error);
      alert('Failed to update ticket status. Please try again.');
    }
  };

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'URGENT': return 'error';
      case 'HIGH': return 'warning';
      case 'MEDIUM': return 'info';
      case 'LOW': return 'success';
      default: return 'default';
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'OPEN': return 'error';
      case 'IN_PROGRESS': return 'warning';
      case 'RESOLVED': return 'success';
      case 'CLOSED': return 'default';
      default: return 'default';
    }
  };

  const getPriorityIcon = (priority: string) => {
    switch (priority) {
      case 'URGENT': return <PriorityHighIcon />;
      case 'HIGH': return <PriorityHighIcon />;
      case 'MEDIUM': return <ScheduleIcon />;
      case 'LOW': return <LowPriorityIcon />;
      default: return <ScheduleIcon />;
    }
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'OPEN': return <WarningIcon />;
      case 'IN_PROGRESS': return <ScheduleIcon />;
      case 'RESOLVED': return <CheckCircleIcon />;
      case 'CLOSED': return <CloseIcon />;
      default: return <WarningIcon />;
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleString();
  };

  const getFilteredTickets = () => {
    switch (selectedTab) {
      case 0: return tickets; // All tickets
      case 1: return tickets.filter(t => t.status === 'OPEN');
      case 2: return tickets.filter(t => t.status === 'IN_PROGRESS');
      case 3: return tickets.filter(t => t.status === 'RESOLVED' || t.status === 'CLOSED');
      default: return tickets;
    }
  };

  return (
    <Container maxWidth="xl" sx={{ mt: 2, mb: 4 }}>
      {/* Header */}
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Box display="flex" alignItems="center">
          <SupportIcon sx={{ fontSize: 32, mr: 2, color: 'primary.main' }} />
          <Typography variant="h4" component="h1">
            Help Desk & Support
          </Typography>
        </Box>
        {userRole === 'PARENT' && (
          <Button
            variant="contained"
            startIcon={<AddIcon />}
            onClick={handleCreateTicket}
          >
            Create New Ticket
          </Button>
        )}
      </Box>

      {/* Tab Navigation */}
      <Box sx={{ borderBottom: 1, borderColor: 'divider', mb: 3 }}>
        <Tabs value={selectedTab} onChange={handleTabChange}>
          <Tab 
            label={
              <Box display="flex" alignItems="center" gap={1}>
                <MessageIcon />
                All Tickets
                <Badge badgeContent={tickets.length} color="primary" />
              </Box>
            } 
          />
          <Tab 
            label={
              <Box display="flex" alignItems="center" gap={1}>
                <WarningIcon />
                Open
                <Badge badgeContent={tickets.filter(t => t.status === 'OPEN').length} color="error" />
              </Box>
            } 
          />
          <Tab 
            label={
              <Box display="flex" alignItems="center" gap={1}>
                <ScheduleIcon />
                In Progress
                <Badge badgeContent={tickets.filter(t => t.status === 'IN_PROGRESS').length} color="warning" />
              </Box>
            } 
          />
          <Tab 
            label={
              <Box display="flex" alignItems="center" gap={1}>
                <CheckCircleIcon />
                Resolved
                <Badge badgeContent={tickets.filter(t => t.status === 'RESOLVED' || t.status === 'CLOSED').length} color="success" />
              </Box>
            } 
          />
        </Tabs>
      </Box>

      {/* Loading State */}
      {loading && <LinearProgress sx={{ mb: 2 }} />}

      {/* Tickets Table */}
      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Ticket ID</TableCell>
              <TableCell>Title</TableCell>
              <TableCell>Category</TableCell>
              <TableCell>Priority</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Created By</TableCell>
              <TableCell>Created Date</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {getFilteredTickets().map((ticket) => (
              <TableRow key={ticket.id}>
                <TableCell>#{ticket.id}</TableCell>
                <TableCell>
                  <Typography variant="subtitle2" fontWeight="bold">
                    {ticket.title}
                  </Typography>
                  <Typography variant="caption" color="text.secondary">
                    {ticket.description.substring(0, 50)}...
                  </Typography>
                </TableCell>
                <TableCell>
                  <Chip 
                    label={ticket.category} 
                    size="small" 
                    variant="outlined"
                  />
                </TableCell>
                <TableCell>
                  <Chip 
                    icon={getPriorityIcon(ticket.priority)}
                    label={ticket.priority} 
                    size="small" 
                    color={getPriorityColor(ticket.priority) as any}
                  />
                </TableCell>
                <TableCell>
                  <Chip 
                    icon={getStatusIcon(ticket.status)}
                    label={ticket.status.replace('_', ' ')} 
                    size="small" 
                    color={getStatusColor(ticket.status) as any}
                  />
                </TableCell>
                <TableCell>
                  <Box>
                    <Typography variant="body2">
                      {ticket.createdBy}
                    </Typography>
                    <Typography variant="caption" color="text.secondary">
                      {ticket.createdByPhone}
                    </Typography>
                  </Box>
                </TableCell>
                <TableCell>
                  <Typography variant="body2">
                    {formatDate(ticket.createdAt)}
                  </Typography>
                </TableCell>
                <TableCell>
                  <Box display="flex" gap={1}>
                    <Tooltip title="View Details">
                      <IconButton 
                        size="small" 
                        color="primary"
                        onClick={() => handleViewTicket(ticket)}
                      >
                        <VisibilityIcon />
                      </IconButton>
                    </Tooltip>
                    <Tooltip title="Add Response">
                      <IconButton 
                        size="small" 
                        color="secondary"
                        onClick={() => handleRespondToTicket(ticket)}
                      >
                        <ReplyIcon />
                      </IconButton>
                    </Tooltip>
                    {(userRole === 'SUPER_ADMIN' || userRole === 'SCHOOL_ADMIN') && (
                      <FormControl size="small" sx={{ minWidth: 120 }}>
                        <Select
                          value={ticket.status}
                          onChange={(e) => handleUpdateTicketStatus(ticket.id, e.target.value as Ticket['status'])}
                          size="small"
                        >
                          <MenuItem value="OPEN">Open</MenuItem>
                          <MenuItem value="IN_PROGRESS">In Progress</MenuItem>
                          <MenuItem value="RESOLVED">Resolved</MenuItem>
                          <MenuItem value="CLOSED">Closed</MenuItem>
                        </Select>
                      </FormControl>
                    )}
                  </Box>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      {/* Create Ticket Dialog */}
      <Dialog 
        open={openTicketDialog} 
        onClose={() => setOpenTicketDialog(false)}
        maxWidth="md"
        fullWidth
      >
        <DialogTitle>
          Create New Support Ticket
        </DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 1 }}>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Ticket Title"
                value={ticketForm.title}
                onChange={(e) => setTicketForm({...ticketForm, title: e.target.value})}
                required
                placeholder="Brief description of your issue"
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Description"
                multiline
                rows={4}
                value={ticketForm.description}
                onChange={(e) => setTicketForm({...ticketForm, description: e.target.value})}
                required
                placeholder="Please provide detailed information about your issue"
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Category</InputLabel>
                <Select
                  value={ticketForm.category}
                  onChange={(e) => setTicketForm({...ticketForm, category: e.target.value})}
                  label="Category"
                  required
                >
                  {categories.map((category) => (
                    <MenuItem key={category} value={category}>
                      {category}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth>
                <InputLabel>Priority</InputLabel>
                <Select
                  value={ticketForm.priority}
                  onChange={(e) => setTicketForm({...ticketForm, priority: e.target.value as TicketForm['priority']})}
                  label="Priority"
                  required
                >
                  <MenuItem value="LOW">Low</MenuItem>
                  <MenuItem value="MEDIUM">Medium</MenuItem>
                  <MenuItem value="HIGH">High</MenuItem>
                  <MenuItem value="URGENT">Urgent</MenuItem>
                </Select>
              </FormControl>
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenTicketDialog(false)} disabled={savingTicket}>
            Cancel
          </Button>
          <Button 
            onClick={handleSaveTicket} 
            variant="contained"
            disabled={savingTicket}
            startIcon={savingTicket ? <CircularProgress size={16} /> : null}
          >
            {savingTicket ? 'Creating...' : 'Create Ticket'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* View Ticket Dialog */}
      <Dialog 
        open={openViewDialog} 
        onClose={() => setOpenViewDialog(false)}
        maxWidth="md"
        fullWidth
      >
        <DialogTitle>
          Ticket Details - #{selectedTicket?.id}
        </DialogTitle>
        <DialogContent>
          {selectedTicket && (
            <Box sx={{ mt: 2 }}>
              <Grid container spacing={3}>
                <Grid item xs={12}>
                  <Typography variant="h6" gutterBottom>
                    {selectedTicket.title}
                  </Typography>
                  <Typography variant="body1" color="text.secondary" paragraph>
                    {selectedTicket.description}
                  </Typography>
                </Grid>
                
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">Category</Typography>
                  <Chip label={selectedTicket.category} size="small" />
                </Grid>
                
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">Priority</Typography>
                  <Chip 
                    icon={getPriorityIcon(selectedTicket.priority)}
                    label={selectedTicket.priority} 
                    size="small" 
                    color={getPriorityColor(selectedTicket.priority) as any}
                  />
                </Grid>
                
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">Status</Typography>
                  <Chip 
                    icon={getStatusIcon(selectedTicket.status)}
                    label={selectedTicket.status.replace('_', ' ')} 
                    size="small" 
                    color={getStatusColor(selectedTicket.status) as any}
                  />
                </Grid>
                
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">Created By</Typography>
                  <Typography variant="body2">{selectedTicket.createdBy}</Typography>
                  <Typography variant="caption" color="text.secondary">{selectedTicket.createdByPhone}</Typography>
                </Grid>
                
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">Created Date</Typography>
                  <Typography variant="body2">{formatDate(selectedTicket.createdAt)}</Typography>
                </Grid>
                
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">Last Updated</Typography>
                  <Typography variant="body2">{formatDate(selectedTicket.updatedAt)}</Typography>
                </Grid>
              </Grid>

              <Divider sx={{ my: 3 }} />

              <Typography variant="h6" gutterBottom>
                Responses ({selectedTicket.responses.length})
              </Typography>

              {selectedTicket.responses.length === 0 ? (
                <Typography variant="body2" color="text.secondary">
                  No responses yet.
                </Typography>
              ) : (
                <Box>
                  {selectedTicket.responses.map((response, index) => (
                    <Card key={response.id} sx={{ mb: 2, bgcolor: 'grey.50' }}>
                      <CardContent>
                        <Box display="flex" justifyContent="space-between" alignItems="flex-start" mb={1}>
                          <Box>
                            <Typography variant="subtitle2" fontWeight="bold">
                              {response.respondedBy}
                            </Typography>
                            <Typography variant="caption" color="text.secondary">
                              {response.respondedByRole} • {formatDate(response.createdAt)}
                            </Typography>
                          </Box>
                        </Box>
                        <Typography variant="body2">
                          {response.message}
                        </Typography>
                      </CardContent>
                    </Card>
                  ))}
                </Box>
              )}
            </Box>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenViewDialog(false)}>
            Close
          </Button>
          <Button 
            variant="contained"
            onClick={() => {
              setOpenViewDialog(false);
              if (selectedTicket) handleRespondToTicket(selectedTicket);
            }}
          >
            Add Response
          </Button>
        </DialogActions>
      </Dialog>

      {/* Add Response Dialog */}
      <Dialog 
        open={openResponseDialog} 
        onClose={() => setOpenResponseDialog(false)}
        maxWidth="md"
        fullWidth
      >
        <DialogTitle>
          Add Response - #{selectedTicket?.id}
        </DialogTitle>
        <DialogContent>
          <Box sx={{ mt: 2 }}>
            <Typography variant="subtitle2" gutterBottom>
              Ticket: {selectedTicket?.title}
            </Typography>
            <TextField
              fullWidth
              label="Your Response"
              multiline
              rows={4}
              value={responseMessage}
              onChange={(e) => setResponseMessage(e.target.value)}
              placeholder="Type your response here..."
              sx={{ mt: 2 }}
            />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenResponseDialog(false)} disabled={savingResponse}>
            Cancel
          </Button>
          <Button 
            onClick={handleSaveResponse} 
            variant="contained"
            disabled={savingResponse}
            startIcon={savingResponse ? <CircularProgress size={16} /> : null}
          >
            {savingResponse ? 'Saving...' : 'Send Response'}
          </Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
};

export default HelpDesk; 