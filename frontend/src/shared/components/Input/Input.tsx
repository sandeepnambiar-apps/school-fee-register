import React from 'react';
import { Platform } from 'react-native';

// Platform-specific imports
const WebInput = Platform.select({
  web: () => require('./Input.web').default,
  default: () => require('./Input.native').default,
})();

interface InputProps {
  value: string;
  onChangeText: (text: string) => void;
  placeholder?: string;
  label?: string;
  type?: 'text' | 'password' | 'email' | 'number';
  error?: string;
  disabled?: boolean;
  required?: boolean;
}

const Input: React.FC<InputProps> = (props) => {
  return <WebInput {...props} />;
};

export default Input; 