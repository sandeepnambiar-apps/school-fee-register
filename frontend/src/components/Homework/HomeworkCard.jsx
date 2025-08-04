import React from 'react';
import {
  Card,
  CardContent,
  Typography,
  Box,
  Chip,
  IconButton,
  Collapse,
  Button
} from '@mui/material';
import {
  Assignment as AssignmentIcon,
  Subject as SubjectIcon,
  Class as ClassIcon,
  CalendarToday as CalendarIcon,
  PriorityHigh as PriorityIcon,
  Download as DownloadIcon,
  ExpandMore as ExpandMoreIcon,
  ExpandLess as ExpandLessIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Archive as ArchiveIcon
} from '@mui/icons-material';
import { format, isAfter, isBefore, addDays } from 'date-fns';

const HomeworkCard = ({ 
  homework, 
  userRole, 
  onEdit, 
  onDelete, 
  onArchive,
  expanded,
  onToggleExpand 
}) => {
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

  const handleDownload = () => {
    if (homework.attachmentUrl) {
      window.open(homework.attachmentUrl, '_blank');
    }
  };

  return (
    <Card sx={{ mb: 2, position: 'relative' }}>
      <CardContent>
        {/* Header */}
        <Box display="flex" justifyContent="space-between" alignItems="flex-start" mb={2}>
          <Box display="flex" alignItems="center" flex={1}>
            <AssignmentIcon sx={{ mr: 1, color: 'primary.main' }} />
            <Typography variant="h6" component="h3" noWrap sx={{ flex: 1 }}>
              {homework.title}
            </Typography>
          </Box>
          
          <Box display="flex" alignItems="center" gap={1}>
            {homework.attachmentUrl && (
              <IconButton size="small" onClick={handleDownload} title="Download Attachment">
                <DownloadIcon />
              </IconButton>
            )}
            
            {userRole === 'TEACHER' && (
              <>
                <IconButton size="small" onClick={() => onEdit(homework)} title="Edit">
                  <EditIcon />
                </IconButton>
                <IconButton size="small" onClick={() => onDelete(homework.id)} title="Delete">
                  <DeleteIcon />
                </IconButton>
                <IconButton size="small" onClick={() => onArchive(homework.id)} title="Archive">
                  <ArchiveIcon />
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

        {/* Chips */}
        <Box display="flex" flexWrap="wrap" gap={1} mb={2}>
          <Chip
            icon={<SubjectIcon />}
            label={homework.subjectName || 'Subject'}
            size="small"
            variant="outlined"
          />
          <Chip
            icon={<ClassIcon />}
            label={`Class ${homework.className}${homework.section ? ` - ${homework.section}` : ''}`}
            size="small"
            variant="outlined"
          />
          <Chip
            icon={<PriorityIcon />}
            label={homework.priority}
            size="small"
            color={getPriorityColor(homework.priority)}
          />
          <Chip
            icon={<CalendarIcon />}
            label={getStatusText(homework.status, homework.dueDate)}
            size="small"
            color={getStatusColor(homework.status, homework.dueDate)}
          />
        </Box>

        {/* Expanded Content */}
        <Collapse in={expanded}>
          <Box mt={2}>
            <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
              {homework.description}
            </Typography>
            
            <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
              <Typography variant="caption" color="text.secondary">
                <strong>Assigned:</strong> {format(new Date(homework.assignedDate), 'MMM dd, yyyy')}
              </Typography>
              <Typography variant="caption" color="text.secondary">
                <strong>Due:</strong> {format(new Date(homework.dueDate), 'MMM dd, yyyy')}
              </Typography>
            </Box>

            {homework.attachmentUrl && (
              <Box display="flex" alignItems="center" gap={1}>
                <DownloadIcon fontSize="small" />
                <Typography variant="caption" color="primary">
                  {homework.attachmentName || 'Attachment available'}
                </Typography>
                <Button size="small" onClick={handleDownload}>
                  Download
                </Button>
              </Box>
            )}
          </Box>
        </Collapse>

        {/* Footer */}
        <Box display="flex" justifyContent="space-between" alignItems="center" mt={2}>
          <Typography variant="caption" color="text.secondary">
            Created by: {homework.teacherName || 'Teacher'}
          </Typography>
          <Typography variant="caption" color="text.secondary">
            {format(new Date(homework.createdAt), 'MMM dd, yyyy HH:mm')}
          </Typography>
        </Box>
      </CardContent>
    </Card>
  );
};

export default HomeworkCard; 