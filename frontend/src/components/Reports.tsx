import React from 'react';
import { Container, Typography, Button, Box } from '@mui/material';
import { Assessment as AssessmentIcon } from '@mui/icons-material';

const Reports: React.FC = () => {
  return (
    <Container maxWidth="xl">
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">Reports & Analytics</Typography>
        <Button
          variant="contained"
          startIcon={<AssessmentIcon />}
          onClick={() => console.log('Generate report')}
        >
          Generate Report
        </Button>
      </Box>
      <Typography variant="body1" color="textSecondary">
        Financial reports and analytics interface will be implemented here.
      </Typography>
    </Container>
  );
};

export default Reports; 