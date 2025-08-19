import React, { useState } from 'react';
import { Box, Typography, Alert, ToggleButton, ToggleButtonGroup } from '@mui/material';
import Button from '../Button/Button';
import Input from '../Input/Input';

interface LoginFormProps {
  onLogin: (username: string, password: string) => Promise<void>;
  loading?: boolean;
  error?: string;
}

const LoginForm: React.FC<LoginFormProps> = ({
  onLogin,
  loading = false,
  error,
}) => {
  const [loginType, setLoginType] = useState<'username' | 'mobile'>('username');
  const [username, setUsername] = useState('admin');
  const [mobile, setMobile] = useState('');
  const [password, setPassword] = useState('password');
  const [formError, setFormError] = useState('');

  const handleSubmit = async () => {
    setFormError('');
    
    if (loginType === 'username' && !username.trim()) {
      setFormError('Please enter username');
      return;
    }
    
    if (loginType === 'mobile' && !mobile.trim()) {
      setFormError('Please enter mobile number');
      return;
    }
    
    if (!password.trim()) {
      setFormError('Please enter password');
      return;
    }

    try {
      const identifier = loginType === 'username' ? username.trim() : mobile.trim();
      await onLogin(identifier, password);
    } catch (err) {
      setFormError('Login failed. Please try again.');
    }
  };

  const useDemoCredentials = () => {
    setUsername('admin');
    setPassword('password');
    setLoginType('username');
    setFormError('');
  };

  return (
    <Box sx={{ width: '100%', maxWidth: 400, mx: 'auto' }}>
      {/* Logo */}
      <Box sx={{ textAlign: 'center', mb: 3 }}>
        <Typography variant="h4" component="h1" sx={{ color: '#ff6b35', fontWeight: 'bold' }}>
          Kidsy
        </Typography>
        <Typography variant="subtitle1" sx={{ color: '#666' }}>
          School Fee Register
        </Typography>
      </Box>

      {/* Error Display */}
      {(error || formError) && (
        <Alert severity="error" sx={{ mb: 2 }}>
          {error || formError}
        </Alert>
      )}

      {/* Login Type Toggle */}
      <Box sx={{ mb: 3 }}>
        <ToggleButtonGroup
          value={loginType}
          exclusive
          onChange={(_, newType) => newType && setLoginType(newType)}
          sx={{ width: '100%' }}
        >
          <ToggleButton value="username" sx={{ flex: 1 }}>
            👤 Username
          </ToggleButton>
          <ToggleButton value="mobile" sx={{ flex: 1 }}>
            📱 Mobile Number
          </ToggleButton>
        </ToggleButtonGroup>
      </Box>

      {/* Input Fields */}
      {loginType === 'username' ? (
        <Box sx={{ mb: 2 }}>
          <Input
            label="Username"
            value={username}
            onChangeText={setUsername}
            placeholder="Enter username"
            required
          />
        </Box>
      ) : (
        <Box sx={{ mb: 2 }}>
          <Input
            label="Mobile Number"
            value={mobile}
            onChangeText={setMobile}
            placeholder="Enter mobile number"
            type="number"
            required
          />
        </Box>
      )}

      <Box sx={{ mb: 3 }}>
        <Input
          label="Password"
          value={password}
          onChangeText={setPassword}
          placeholder="Enter password"
          type="password"
          required
        />
      </Box>

      {/* Login Button */}
      <Box sx={{ mb: 2 }}>
        <Button
          title={loading ? "Signing In..." : "Sign In"}
          onPress={handleSubmit}
          loading={loading}
          disabled={loading}
          size="large"
        />
      </Box>

      {/* Demo Credentials */}
      <Box sx={{ width: '100%' }}>
        <Button
          title="Use Demo Credentials"
          onPress={useDemoCredentials}
          variant="outline"
          size="small"
        />
      </Box>
    </Box>
  );
};

export default LoginForm; 