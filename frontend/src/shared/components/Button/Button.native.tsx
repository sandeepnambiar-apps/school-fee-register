import React from 'react';
import {
  TouchableOpacity,
  Text,
  ActivityIndicator,
  StyleSheet,
  ViewStyle,
  TextStyle,
} from 'react-native';

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
  const getButtonStyle = (): ViewStyle => {
    const baseStyle: ViewStyle = {
      borderRadius: 8,
      alignItems: 'center',
      justifyContent: 'center',
      flexDirection: 'row',
    };

    // Size styles
    switch (size) {
      case 'small':
        baseStyle.paddingHorizontal = 16;
        baseStyle.paddingVertical = 8;
        baseStyle.minHeight = 32;
        break;
      case 'large':
        baseStyle.paddingHorizontal = 24;
        baseStyle.paddingVertical = 16;
        baseStyle.minHeight = 48;
        break;
      default:
        baseStyle.paddingHorizontal = 20;
        baseStyle.paddingVertical = 12;
        baseStyle.minHeight = 40;
    }

    // Variant styles
    switch (variant) {
      case 'primary':
        baseStyle.backgroundColor = '#1976d2';
        break;
      case 'secondary':
        baseStyle.backgroundColor = '#f5f5f5';
        break;
      case 'outline':
        baseStyle.backgroundColor = 'transparent';
        baseStyle.borderWidth = 1;
        baseStyle.borderColor = '#1976d2';
        break;
    }

    if (disabled) {
      baseStyle.opacity = 0.6;
    }

    return baseStyle;
  };

  const getTextStyle = (): TextStyle => {
    const baseStyle: TextStyle = {
      fontWeight: '600',
    };

    // Size styles
    switch (size) {
      case 'small':
        baseStyle.fontSize = 12;
        break;
      case 'large':
        baseStyle.fontSize = 16;
        break;
      default:
        baseStyle.fontSize = 14;
    }

    // Variant styles
    switch (variant) {
      case 'primary':
        baseStyle.color = '#ffffff';
        break;
      case 'secondary':
        baseStyle.color = '#666666';
        break;
      case 'outline':
        baseStyle.color = '#1976d2';
        break;
    }

    return baseStyle;
  };

  return (
    <TouchableOpacity
      style={getButtonStyle()}
      onPress={onPress}
      disabled={disabled || loading}
      activeOpacity={0.8}
    >
      {loading ? (
        <ActivityIndicator
          size="small"
          color={variant === 'primary' ? '#ffffff' : '#1976d2'}
        />
      ) : (
        <Text style={getTextStyle()}>{title}</Text>
      )}
    </TouchableOpacity>
  );
};

export default Button; 