import React from 'react';
import { Platform } from 'react-native';

// Platform-specific imports
const WebButton = Platform.select({
  web: () => require('./Button.web').default,
  default: () => require('./Button.native').default,
})();

interface ButtonProps {
  title: string;
  onPress: () => void;
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'small' | 'medium' | 'large';
  disabled?: boolean;
  loading?: boolean;
}

const Button: React.FC<ButtonProps> = (props) => {
  return <WebButton {...props} />;
};

export default Button; 