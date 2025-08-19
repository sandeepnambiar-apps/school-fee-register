import React from 'react';
import { Button as MuiButton, CircularProgress } from '@mui/material';

interface ButtonProps {
  title: string;
  onPress: () => void;
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'small' | 'medium' | 'large';
  disabled?: boolean;
  loading?: boolean;
}

const Button: React.FC<ButtonProps> = ({
  title,
  onPress,
  variant = 'primary',
  size = 'medium',
  disabled = false,
  loading = false,
}) => {
  const getMuiVariant = () => {
    switch (variant) {
      case 'outline':
        return 'outlined';
      case 'secondary':
        return 'text';
      default:
        return 'contained';
    }
  };

  const getMuiSize = () => {
    switch (size) {
      case 'small':
        return 'small';
      case 'large':
        return 'large';
      default:
        return 'medium';
    }
  };

  const getMuiColor = () => {
    switch (variant) {
      case 'secondary':
        return 'secondary';
      case 'outline':
        return 'primary';
      default:
        return 'primary';
    }
  };

  return (
    <MuiButton
      variant={getMuiVariant()}
      size={getMuiSize()}
      color={getMuiColor()}
      onClick={onPress}
      disabled={disabled || loading}
      sx={{
        minWidth: size === 'large' ? 120 : size === 'small' ? 80 : 100,
        height: size === 'large' ? 48 : size === 'small' ? 32 : 40,
      }}
    >
      {loading ? (
        <CircularProgress size={20} color="inherit" />
      ) : (
        title
      )}
    </MuiButton>
  );
};

export default Button; 