import React from 'react';
import { Container, Typography, Button, Box } from '@mui/material';
import { Add as AddIcon } from '@mui/icons-material';

const Payments: React.FC = () => {
  return (
    <Container maxWidth="xl">
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">Payment Management</Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={() => console.log('Process payment')}
        >
          Process Payment
        </Button>
      </Box>
      <Typography variant="body1" color="textSecondary">
        Payment processing and management interface will be implemented here.
      </Typography>
    </Container>
  );
};

export default Payments; 