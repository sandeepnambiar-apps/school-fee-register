import React from 'react';

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
  const getButtonStyle = () => {
    const baseStyle: React.CSSProperties = {
      borderRadius: '8px',
      border: 'none',
      cursor: 'pointer',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      fontWeight: '600',
      transition: 'all 0.2s ease',
      fontFamily: 'inherit',
    };

    // Size styles
    switch (size) {
      case 'small':
        baseStyle.padding = '8px 16px';
        baseStyle.minHeight = '32px';
        baseStyle.fontSize = '12px';
        break;
      case 'large':
        baseStyle.padding = '16px 24px';
        baseStyle.minHeight = '48px';
        baseStyle.fontSize = '16px';
        break;
      default:
        baseStyle.padding = '12px 20px';
        baseStyle.minHeight = '40px';
        baseStyle.fontSize = '14px';
    }

    // Variant styles
    switch (variant) {
      case 'primary':
        baseStyle.backgroundColor = '#1976d2';
        baseStyle.color = '#ffffff';
        break;
      case 'secondary':
        baseStyle.backgroundColor = '#f5f5f5';
        baseStyle.color = '#666666';
        break;
      case 'outline':
        baseStyle.backgroundColor = 'transparent';
        baseStyle.color = '#1976d2';
        baseStyle.border = '1px solid #1976d2';
        break;
    }

    if (disabled) {
      baseStyle.opacity = '0.6';
      baseStyle.cursor = 'not-allowed';
    }

    return baseStyle;
  };

  return (
    <button
      style={getButtonStyle()}
      onClick={onPress}
      disabled={disabled || loading}
    >
      {loading ? (
        <div style={{ 
          width: '20px', 
          height: '20px', 
          border: '2px solid transparent',
          borderTop: `2px solid ${variant === 'primary' ? '#ffffff' : '#1976d2'}`,
          borderRadius: '50%',
          animation: 'spin 1s linear infinite'
        }} />
      ) : (
        title
      )}
      <style>{`
        @keyframes spin {
          0% { transform: rotate(0deg); }
          100% { transform: rotate(360deg); }
        }
      `}</style>
    </button>
  );
};

export default Button; 