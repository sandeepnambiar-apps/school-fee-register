import React from 'react';
import { TextField, FormHelperText } from '@mui/material';

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

const Input: React.FC<InputProps> = ({
  value,
  onChangeText,
  placeholder,
  label,
  type = 'text',
  error,
  disabled = false,
  required = false,
}) => {
  const getInputType = () => {
    switch (type) {
      case 'password':
        return 'password';
      case 'email':
        return 'email';
      case 'number':
        return 'number';
      default:
        return 'text';
    }
  };

  return (
    <div style={{ width: '100%' }}>
      <TextField
        fullWidth
        label={label}
        placeholder={placeholder}
        type={getInputType()}
        value={value}
        onChange={(e) => onChangeText(e.target.value)}
        disabled={disabled}
        required={required}
        error={!!error}
        variant="outlined"
        size="medium"
        sx={{
          '& .MuiOutlinedInput-root': {
            borderRadius: 2,
          },
        }}
      />
      {error && (
        <FormHelperText error sx={{ marginLeft: 1 }}>
          {error}
        </FormHelperText>
      )}
    </div>
  );
};

export default Input; 