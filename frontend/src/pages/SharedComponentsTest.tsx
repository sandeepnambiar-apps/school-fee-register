import React, { useState } from 'react';
import { Box, Typography, Container, Paper, Button as MuiButton, TextField, Alert } from '@mui/material';

const SharedComponentsTest: React.FC = () => {
  const [text, setText] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async (username: string, password: string) => {
    setLoading(true);
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 2000));
    console.log('Login attempt:', { username, password });
    alert(`Login attempt with: ${username}`);
    setLoading(false);
  };

  const handleButtonPress = () => {
    console.log('Button pressed!');
    alert('Button pressed!');
  };

  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Typography variant="h3" component="h1" align="center" gutterBottom>
        🚀 Shared Components Test
      </Typography>
      <Typography variant="h6" align="center" color="text.secondary" gutterBottom>
        Testing shared components in React Web App
      </Typography>

      <Paper elevation={3} sx={{ p: 3, mb: 3 }}>
        <Typography variant="h5" gutterBottom>
          Basic Components Test
        </Typography>
        <Box sx={{ display: 'flex', gap: 2, mb: 2, flexWrap: 'wrap' }}>
          <MuiButton variant="contained" onClick={handleButtonPress}>
            Primary Button
          </MuiButton>
          <MuiButton variant="outlined" onClick={handleButtonPress}>
            Secondary Button
          </MuiButton>
          <MuiButton variant="text" onClick={handleButtonPress}>
            Text Button
          </MuiButton>
        </Box>
        
        <Box sx={{ display: 'flex', gap: 2, flexWrap: 'wrap' }}>
          <MuiButton size="small" onClick={handleButtonPress}>
            Small Button
          </MuiButton>
          <MuiButton size="large" onClick={handleButtonPress}>
            Large Button
          </MuiButton>
          <MuiButton disabled onClick={handleButtonPress}>
            Disabled Button
          </MuiButton>
        </Box>
      </Paper>

      <Paper elevation={3} sx={{ p: 3, mb: 3 }}>
        <Typography variant="h5" gutterBottom>
          Input Components Test
        </Typography>
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
          <TextField
            label="Text Input"
            value={text}
            onChange={(e) => setText(e.target.value)}
            placeholder="Type something..."
            required
            fullWidth
          />
          <TextField
            label="Password Input"
            type="password"
            placeholder="Enter password"
            required
            fullWidth
          />
          <TextField
            label="Email Input"
            type="email"
            placeholder="Enter email"
            fullWidth
          />
          <TextField
            label="Number Input"
            type="number"
            placeholder="Enter number"
            fullWidth
          />
        </Box>
      </Paper>

      <Paper elevation={3} sx={{ p: 3, mb: 3 }}>
        <Typography variant="h5" gutterBottom>
          Simple Login Form Test
        </Typography>
        <Box sx={{ maxWidth: 400, mx: 'auto' }}>
          <TextField
            label="Username"
            defaultValue="admin"
            fullWidth
            sx={{ mb: 2 }}
          />
          <TextField
            label="Password"
            type="password"
            defaultValue="password"
            fullWidth
            sx={{ mb: 2 }}
          />
          <MuiButton
            variant="contained"
            fullWidth
            onClick={() => handleLogin('admin', 'password')}
            disabled={loading}
          >
            {loading ? "Signing In..." : "Sign In"}
          </MuiButton>
        </Box>
      </Paper>

      <Paper elevation={3} sx={{ p: 3 }}>
        <Typography variant="h5" gutterBottom>
          Status: Basic Setup Working
        </Typography>
        <Alert severity="success" sx={{ mb: 2 }}>
          ✅ Basic Material-UI components are working
        </Alert>
        <Alert severity="info" sx={{ mb: 2 }}>
          ℹ️ Shared components will be added next
        </Alert>
        <Typography variant="body2" color="text.secondary">
          This page confirms that the basic routing and Material-UI setup is working correctly.
          The next step will be to integrate the shared components.
        </Typography>
      </Paper>
    </Container>
  );
};

export default SharedComponentsTest; 