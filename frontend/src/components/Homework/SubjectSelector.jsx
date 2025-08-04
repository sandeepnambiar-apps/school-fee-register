import React, { useState, useEffect } from 'react';
import {
  Box,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Typography,
  Chip,
  Avatar,
  List,
  ListItem,
  ListItemAvatar,
  ListItemText,
  ListItemButton,
  Divider
} from '@mui/material';
import {
  Subject as SubjectIcon,
  Assignment as AssignmentIcon,
  CheckCircle as CheckCircleIcon
} from '@mui/icons-material';

const SubjectSelector = ({ 
  selectedSubject, 
  onSubjectChange, 
  subjects = [], 
  homeworkCounts = {},
  showCounts = true 
}) => {
  const [localSubjects, setLocalSubjects] = useState([]);

  useEffect(() => {
    // If no subjects provided, use default subjects
    if (subjects.length === 0) {
      setLocalSubjects([
        { id: 1, name: 'Mathematics', code: 'MATH', color: '#f44336' },
        { id: 2, name: 'Science', code: 'SCI', color: '#2196f3' },
        { id: 3, name: 'English', code: 'ENG', color: '#4caf50' },
        { id: 4, name: 'History', code: 'HIST', color: '#ff9800' },
        { id: 5, name: 'Geography', code: 'GEO', color: '#9c27b0' },
        { id: 6, name: 'Computer Science', code: 'CS', color: '#607d8b' },
        { id: 7, name: 'Physical Education', code: 'PE', color: '#795548' },
        { id: 8, name: 'Art', code: 'ART', color: '#e91e63' }
      ]);
    } else {
      setLocalSubjects(subjects);
    }
  }, [subjects]);

  const getSubjectColor = (subjectId) => {
    const subject = localSubjects.find(s => s.id === subjectId);
    return subject?.color || '#757575';
  };

  const getSubjectIcon = (subjectName) => {
    const name = subjectName.toLowerCase();
    if (name.includes('math')) return '🔢';
    if (name.includes('science')) return '🔬';
    if (name.includes('english')) return '📚';
    if (name.includes('history')) return '📜';
    if (name.includes('geography')) return '🌍';
    if (name.includes('computer')) return '💻';
    if (name.includes('physical') || name.includes('pe')) return '⚽';
    if (name.includes('art')) return '🎨';
    return '📖';
  };

  return (
    <Box>
      <Typography variant="h6" gutterBottom>
        <SubjectIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
        Select Subject
      </Typography>
      
      {/* Dropdown Selector */}
      <FormControl fullWidth sx={{ mb: 2 }}>
        <InputLabel>Subject</InputLabel>
        <Select
          value={selectedSubject || ''}
          onChange={(e) => onSubjectChange(e.target.value)}
          label="Subject"
        >
          <MenuItem value="">
            <Box display="flex" alignItems="center">
              <SubjectIcon sx={{ mr: 1 }} />
              All Subjects
              {showCounts && (
                <Chip 
                  label={Object.values(homeworkCounts).reduce((a, b) => a + b, 0)} 
                  size="small" 
                  sx={{ ml: 'auto' }}
                />
              )}
            </Box>
          </MenuItem>
          {localSubjects.map((subject) => (
            <MenuItem key={subject.id} value={subject.id}>
              <Box display="flex" alignItems="center" width="100%">
                <Avatar 
                  sx={{ 
                    width: 24, 
                    height: 24, 
                    mr: 1, 
                    bgcolor: subject.color,
                    fontSize: '0.75rem'
                  }}
                >
                  {getSubjectIcon(subject.name)}
                </Avatar>
                <Box flex={1}>
                  <Typography variant="body2">{subject.name}</Typography>
                  <Typography variant="caption" color="text.secondary">
                    {subject.code}
                  </Typography>
                </Box>
                {showCounts && (
                  <Chip 
                    label={homeworkCounts[subject.id] || 0} 
                    size="small" 
                    color="primary"
                    variant="outlined"
                  />
                )}
              </Box>
            </MenuItem>
          ))}
        </Select>
      </FormControl>

      {/* Visual Subject Grid */}
      <Box>
        <Typography variant="subtitle2" gutterBottom>
          Quick Select
        </Typography>
        <Box display="flex" flexWrap="wrap" gap={1}>
          <Chip
            label="All Subjects"
            variant={selectedSubject === '' ? 'filled' : 'outlined'}
            color={selectedSubject === '' ? 'primary' : 'default'}
            onClick={() => onSubjectChange('')}
            icon={<SubjectIcon />}
          />
          {localSubjects.map((subject) => (
            <Chip
              key={subject.id}
              label={subject.name}
              variant={selectedSubject === subject.id ? 'filled' : 'outlined'}
              color={selectedSubject === subject.id ? 'primary' : 'default'}
              onClick={() => onSubjectChange(subject.id)}
              avatar={
                <Avatar sx={{ bgcolor: subject.color, fontSize: '0.75rem' }}>
                  {getSubjectIcon(subject.name)}
                </Avatar>
              }
              {...(showCounts && {
                deleteIcon: <AssignmentIcon />,
                onDelete: () => {},
                deleteIconColor: 'primary'
              })}
            />
          ))}
        </Box>
      </Box>

      {/* Subject List View */}
      <Box sx={{ mt: 3 }}>
        <Typography variant="subtitle2" gutterBottom>
          Subject Details
        </Typography>
        <List dense>
          {localSubjects.map((subject, index) => (
            <React.Fragment key={subject.id}>
              <ListItem disablePadding>
                <ListItemButton 
                  selected={selectedSubject === subject.id}
                  onClick={() => onSubjectChange(subject.id)}
                >
                  <ListItemAvatar>
                    <Avatar sx={{ bgcolor: subject.color }}>
                      {getSubjectIcon(subject.name)}
                    </Avatar>
                  </ListItemAvatar>
                  <ListItemText
                    primary={subject.name}
                    secondary={
                      <Box display="flex" alignItems="center" gap={1}>
                        <Typography variant="caption" color="text.secondary">
                          Code: {subject.code}
                        </Typography>
                        {showCounts && (
                          <Chip 
                            label={homeworkCounts[subject.id] || 0} 
                            size="small" 
                            icon={<AssignmentIcon />}
                            variant="outlined"
                          />
                        )}
                      </Box>
                    }
                  />
                  {selectedSubject === subject.id && (
                    <CheckCircleIcon color="primary" />
                  )}
                </ListItemButton>
              </ListItem>
              {index < localSubjects.length - 1 && <Divider />}
            </React.Fragment>
          ))}
        </List>
      </Box>
    </Box>
  );
};

export default SubjectSelector; 