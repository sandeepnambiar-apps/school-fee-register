import React, { useState } from 'react';

// Platform-specific imports - web-compatible version
const LoginFormComponent = (() => {
  // Check if we're in a web environment
  if (typeof window !== 'undefined') {
    return require('./LoginForm.web').default;
  } else {
    return require('./LoginForm.native').default;
  }
})();

export interface LoginFormProps {
  onLogin: (username: string, password: string) => Promise<void>;
  loading?: boolean;
  error?: string;
}

const LoginForm: React.FC<LoginFormProps> = (props) => {
  return <LoginFormComponent {...props} />;
};

export default LoginForm; 