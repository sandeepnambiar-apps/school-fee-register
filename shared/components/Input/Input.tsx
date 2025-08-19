import React from 'react';

// Platform-specific imports - web-compatible version
const InputComponent = (() => {
  // Check if we're in a web environment
  if (typeof window !== 'undefined') {
    return require('./Input.web').default;
  } else {
    return require('./Input.native').default;
  }
})();

export interface InputProps {
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
  return <InputComponent {...props} />;
};

export default Input; 