import React, { useState } from 'react';
import { Box, Typography, Container, Paper } from '@mui/material';
import { Button, Input, LoginForm } from '../components';

const SharedComponentsDemo: React.FC = () => {
  const [text, setText] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async (username: string, password: string) => {
    setLoading(true);
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 2000));
    console.log('Login attempt:', { username, password });
    setLoading(false);
  };

  const handleButtonPress = () => {
    console.log('Button pressed!');
  };

  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Typography variant="h3" component="h1" align="center" gutterBottom>
        🚀 Shared Components Demo
      </Typography>
      <Typography variant="h6" align="center" color="text.secondary" gutterBottom>
        Platform: Web (Material-UI)
      </Typography>

      <Paper elevation={3} sx={{ p: 3, mb: 3 }}>
        <Typography variant="h5" gutterBottom>
          Button Components
        </Typography>
        <Box sx={{ display: 'flex', gap: 2, mb: 2, flexWrap: 'wrap' }}>
          <Button
            title="Primary Button"
            onPress={handleButtonPress}
            variant="primary"
            size="medium"
          />
          <Button
            title="Secondary"
            onPress={handleButtonPress}
            variant="secondary"
            size="medium"
          />
          <Button
            title="Outline"
            onPress={handleButtonPress}
            variant="outline"
            size="medium"
          />
        </Box>
        
        <Box sx={{ display: 'flex', gap: 2, flexWrap: 'wrap' }}>
          <Button
            title="Small"
            onPress={handleButtonPress}
            size="small"
          />
          <Button
            title="Large"
            onPress={handleButtonPress}
            size="large"
          />
          <Button
            title="Loading"
            onPress={handleButtonPress}
            loading={true}
          />
        </Box>
      </Paper>

      <Paper elevation={3} sx={{ p: 3, mb: 3 }}>
        <Typography variant="h5" gutterBottom>
          Input Components
        </Typography>
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
          <Input
            label="Text Input"
            value={text}
            onChangeText={setText}
            placeholder="Type something..."
            required
          />
          <Input
            label="Password Input"
            value=""
            onChangeText={() => {}}
            placeholder="Enter password"
            type="password"
            required
          />
          <Input
            label="Email Input"
            value=""
            onChangeText={() => {}}
            placeholder="Enter email"
            type="email"
          />
          <Input
            label="Number Input"
            value=""
            onChangeText={() => {}}
            placeholder="Enter number"
            type="number"
          />
        </Box>
      </Paper>

      <Paper elevation={3} sx={{ p: 3 }}>
        <Typography variant="h5" gutterBottom>
          Login Form Component
        </Typography>
        <LoginForm
          onLogin={handleLogin}
          loading={loading}
          error=""
        />
      </Paper>
    </Container>
  );
};

export default SharedComponentsDemo; 