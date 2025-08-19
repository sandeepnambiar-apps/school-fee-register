import React from 'react';

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

  const inputStyle: React.CSSProperties = {
    width: '100%',
    padding: '12px 16px',
    border: error ? '1px solid #d32f2f' : '1px solid #ccc',
    borderRadius: '8px',
    fontSize: '14px',
    fontFamily: 'inherit',
    backgroundColor: disabled ? '#f5f5f5' : '#ffffff',
    color: disabled ? '#666666' : '#000000',
    outline: 'none',
    transition: 'border-color 0.2s ease',
  };

  const labelStyle: React.CSSProperties = {
    display: 'block',
    marginBottom: '8px',
    fontSize: '14px',
    fontWeight: '500',
    color: '#333333',
  };

  const errorStyle: React.CSSProperties = {
    color: '#d32f2f',
    fontSize: '12px',
    marginTop: '4px',
    marginLeft: '4px',
  };

  return (
    <div style={{ width: '100%', marginBottom: '16px' }}>
      {label && (
        <label style={labelStyle}>
          {label}
          {required && <span style={{ color: '#d32f2f' }}> *</span>}
        </label>
      )}
      <input
        type={getInputType()}
        value={value}
        onChange={(e) => onChangeText(e.target.value)}
        placeholder={placeholder}
        disabled={disabled}
        required={required}
        style={inputStyle}
        onFocus={(e) => {
          e.target.style.borderColor = error ? '#d32f2f' : '#1976d2';
        }}
        onBlur={(e) => {
          e.target.style.borderColor = error ? '#d32f2f' : '#ccc';
        }}
      />
      {error && (
        <div style={errorStyle}>
          {error}
        </div>
      )}
    </div>
  );
};

export default Input; 