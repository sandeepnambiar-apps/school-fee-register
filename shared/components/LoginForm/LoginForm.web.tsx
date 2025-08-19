import React, { useState } from 'react';
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

  const containerStyle: React.CSSProperties = {
    width: '100%',
    maxWidth: '400px',
    margin: '0 auto',
    padding: '20px',
  };

  const logoStyle: React.CSSProperties = {
    textAlign: 'center',
    marginBottom: '24px',
  };

  const titleStyle: React.CSSProperties = {
    fontSize: '32px',
    fontWeight: 'bold',
    color: '#ff6b35',
    margin: '0 0 8px 0',
  };

  const subtitleStyle: React.CSSProperties = {
    fontSize: '16px',
    color: '#666',
    margin: '0',
  };

  const errorStyle: React.CSSProperties = {
    backgroundColor: '#ffebee',
    color: '#c62828',
    padding: '12px 16px',
    borderRadius: '8px',
    marginBottom: '16px',
    border: '1px solid #ffcdd2',
  };

  const toggleContainerStyle: React.CSSProperties = {
    marginBottom: '24px',
    display: 'flex',
    width: '100%',
    border: '1px solid #ccc',
    borderRadius: '8px',
    overflow: 'hidden',
  };

  const toggleButtonStyle = (isActive: boolean): React.CSSProperties => ({
    flex: 1,
    padding: '12px 16px',
    border: 'none',
    backgroundColor: isActive ? '#1976d2' : '#f5f5f5',
    color: isActive ? '#ffffff' : '#666666',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: '500',
    transition: 'all 0.2s ease',
  });

  return (
    <div style={containerStyle}>
      {/* Logo */}
      <div style={logoStyle}>
        <h1 style={titleStyle}>Kidsy</h1>
        <p style={subtitleStyle}>School Fee Register</p>
      </div>

      {/* Error Display */}
      {(error || formError) && (
        <div style={errorStyle}>
          {error || formError}
        </div>
      )}

      {/* Login Type Toggle */}
      <div style={toggleContainerStyle}>
        <button
          style={toggleButtonStyle(loginType === 'username')}
          onClick={() => setLoginType('username')}
        >
          👤 Username
        </button>
        <button
          style={toggleButtonStyle(loginType === 'mobile')}
          onClick={() => setLoginType('mobile')}
        >
          📱 Mobile Number
        </button>
      </div>

      {/* Input Fields */}
      {loginType === 'username' ? (
        <div style={{ marginBottom: '16px' }}>
          <Input
            label="Username"
            value={username}
            onChangeText={setUsername}
            placeholder="Enter username"
            required
          />
        </div>
      ) : (
        <div style={{ marginBottom: '16px' }}>
          <Input
            label="Mobile Number"
            value={mobile}
            onChangeText={setMobile}
            placeholder="Enter mobile number"
            type="number"
            required
          />
        </div>
      )}

      <div style={{ marginBottom: '24px' }}>
        <Input
          label="Password"
          value={password}
          onChangeText={setPassword}
          placeholder="Enter password"
          type="password"
          required
        />
      </div>

      {/* Login Button */}
      <div style={{ marginBottom: '16px' }}>
        <Button
          title={loading ? "Signing In..." : "Sign In"}
          onPress={handleSubmit}
          loading={loading}
          disabled={loading}
          size="large"
        />
      </div>

      {/* Demo Credentials */}
      <div style={{ width: '100%' }}>
        <Button
          title="Use Demo Credentials"
          onPress={useDemoCredentials}
          variant="outline"
          size="small"
        />
      </div>
    </div>
  );
};

export default LoginForm; 