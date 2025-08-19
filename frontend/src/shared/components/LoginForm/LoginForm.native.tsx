import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  Alert,
  ScrollView,
  ActivityIndicator,
} from 'react-native';
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
    <ScrollView contentContainerStyle={styles.container}>
      {/* Logo */}
      <View style={styles.logoContainer}>
        <Text style={styles.logoText}>Kidsy</Text>
        <Text style={styles.subtitle}>School Fee Register</Text>
      </View>

      {/* Error Display */}
      {(error || formError) && (
        <View style={styles.errorContainer}>
          <Text style={styles.errorText}>⚠️ {error || formError}</Text>
        </View>
      )}

      {/* Login Type Toggle */}
      <View style={styles.toggleContainer}>
        <TouchableOpacity
          style={[
            styles.toggleButton,
            loginType === 'username' && styles.toggleButtonActive
          ]}
          onPress={() => setLoginType('username')}
        >
          <Text style={[
            styles.toggleText,
            loginType === 'username' && styles.toggleTextActive
          ]}>
            👤 Username
          </Text>
        </TouchableOpacity>
        
        <TouchableOpacity
          style={[
            styles.toggleButton,
            loginType === 'mobile' && styles.toggleButtonActive
          ]}
          onPress={() => setLoginType('mobile')}
        >
          <Text style={[
            styles.toggleText,
            loginType === 'mobile' && styles.toggleTextActive
          ]}>
            📱 Mobile Number
          </Text>
        </TouchableOpacity>
      </View>

      {/* Input Fields */}
      {loginType === 'username' ? (
        <Input
          label="Username"
          value={username}
          onChangeText={setUsername}
          placeholder="Enter username"
          required
        />
      ) : (
        <Input
          label="Mobile Number"
          value={mobile}
          onChangeText={setMobile}
          placeholder="Enter mobile number"
          type="number"
          required
        />
      )}

      <Input
        label="Password"
        value={password}
        onChangeText={setPassword}
        placeholder="Enter password"
        type="password"
        required
      />

      {/* Login Button */}
      <Button
        title={loading ? "Signing In..." : "Sign In"}
        onPress={handleSubmit}
        loading={loading}
        disabled={loading}
        size="large"
      />

      {/* Demo Credentials */}
      <Button
        title="Use Demo Credentials"
        onPress={useDemoCredentials}
        variant="outline"
        size="small"
      />
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flexGrow: 1,
    padding: 20,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#f5f5f5',
  },
  logoContainer: {
    alignItems: 'center',
    marginBottom: 30,
  },
  logoText: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#ff6b35',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
  },
  errorContainer: {
    backgroundColor: '#ffebee',
    borderColor: '#f44336',
    borderWidth: 1,
    borderRadius: 8,
    padding: 12,
    marginBottom: 20,
    width: '100%',
  },
  errorText: {
    color: '#d32f2f',
    fontSize: 14,
    textAlign: 'center',
  },
  toggleContainer: {
    flexDirection: 'row',
    backgroundColor: '#f5f5f5',
    borderRadius: 8,
    padding: 4,
    marginBottom: 20,
    width: '100%',
  },
  toggleButton: {
    flex: 1,
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 6,
    alignItems: 'center',
  },
  toggleButtonActive: {
    backgroundColor: '#1976d2',
  },
  toggleText: {
    fontSize: 14,
    color: '#666',
    fontWeight: '500',
  },
  toggleTextActive: {
    color: '#ffffff',
  },
});

export default LoginForm; 