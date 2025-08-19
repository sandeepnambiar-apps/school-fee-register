import React, { useState } from 'react';
import { Platform } from 'react-native';

// Platform-specific imports
const WebLoginForm = Platform.select({
  web: () => require('./LoginForm.web').default,
  default: () => require('./LoginForm.native').default,
})();

interface LoginFormProps {
  onLogin: (username: string, password: string) => Promise<void>;
  loading?: boolean;
  error?: string;
}

const LoginForm: React.FC<LoginFormProps> = (props) => {
  return <WebLoginForm {...props} />;
};

export default LoginForm; 