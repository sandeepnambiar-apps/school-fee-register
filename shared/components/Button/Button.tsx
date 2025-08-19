import React from 'react';

// Platform-specific imports - web-compatible version
const ButtonComponent = (() => {
  // Check if we're in a web environment
  if (typeof window !== 'undefined') {
    return require('./Button.web').default;
  } else {
    return require('./Button.native').default;
  }
})();

export interface ButtonProps {
  title: string;
  onPress: () => void;
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'small' | 'medium' | 'large';
  disabled?: boolean;
  loading?: boolean;
}

const Button: React.FC<ButtonProps> = (props) => {
  return <ButtonComponent {...props} />;
};

export default Button; 