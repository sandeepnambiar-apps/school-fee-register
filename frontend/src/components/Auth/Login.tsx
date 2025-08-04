import React, { useState } from 'react';
import {
  Box,
  Typography,
  TextField,
  Button,
  ButtonGroup,
  Alert,
  CircularProgress,
  Paper,
  InputAdornment,
  IconButton,
  Container,
  Fade,
  Slide,
  useTheme,
  alpha
} from '@mui/material';
import {
  Visibility as VisibilityIcon,
  VisibilityOff as VisibilityOffIcon,
  Lock as LockIcon,
  Person as PersonIcon,
  Login as LoginIcon,
  Phone as PhoneIcon,
  AccountCircle as AccountCircleIcon
} from '@mui/icons-material';
import { useAuth } from '../../contexts/AuthContext';
import { useNavigate } from 'react-router-dom';

interface FormData {
  username: string;
  mobile: string;
  password: string;
  loginType: 'username' | 'mobile';
}

interface FormErrors {
  username?: string;
  mobile?: string;
  password?: string;
}

const Login: React.FC = () => {
  const [formData, setFormData] = useState<FormData>({
    username: '',
    mobile: '',
    password: '',
    loginType: 'username'
  });
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState<FormErrors>({});

  const { login, error: authError, clearError } = useAuth();
  const navigate = useNavigate();
  const theme = useTheme();

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
    
    // Clear error when user starts typing
    if (errors[name as keyof FormErrors]) {
      setErrors(prev => ({
        ...prev,
        [name]: ''
      }));
    }
    
    // Clear auth error when user starts typing
    if (authError) {
      clearError();
    }
  };

  const validateForm = (): boolean => {
    const newErrors: FormErrors = {};

    if (formData.loginType === 'username') {
      if (!formData.username.trim()) {
        newErrors.username = 'Username is required';
      }
    } else {
      if (!formData.mobile.trim()) {
        newErrors.mobile = 'Mobile number is required';
      } else if (!/^\d{10}$/.test(formData.mobile.trim())) {
        newErrors.mobile = 'Please enter a valid 10-digit mobile number';
      }
    }

    if (!formData.password) {
      newErrors.password = 'Password is required';
    } else if (formData.password.length < 6) {
      newErrors.password = 'Password must be at least 6 characters';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    console.log('Login form submitted with:', formData); // Debug log
    
    if (!validateForm()) {
      console.log('Form validation failed'); // Debug log
      return;
    }

    setLoading(true);
    
    try {
      console.log('Calling login function...'); // Debug log
      
      // Prepare login credentials based on login type
      const loginCredentials = formData.loginType === 'username' 
        ? { username: formData.username, password: formData.password }
        : { mobile: formData.mobile, password: formData.password };
      
      const result = await login(loginCredentials);
      console.log('Login result:', result); // Debug log
      
      if (result.success) {
        console.log('Login successful, navigating to dashboard...'); // Debug log
        // Redirect based on user role
        navigate('/dashboard');
      } else {
        console.log('Login failed:', result.error); // Debug log
      }
    } catch (err) {
      console.error('Login error:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleTogglePassword = () => {
    setShowPassword(!showPassword);
  };

  return (
    <Box
      sx={{
        minHeight: '100vh',
        background: 'linear-gradient(135deg, #87CEEB 0%, #4682B4 100%)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        position: 'relative',
        overflow: 'hidden',
        '&::before': {
          content: '""',
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          background: 'radial-gradient(circle at 20% 80%, rgba(135, 206, 235, 0.3) 0%, transparent 50%), radial-gradient(circle at 80% 20%, rgba(70, 130, 180, 0.3) 0%, transparent 50%)',
          zIndex: 1
        }
      }}
    >
      {/* Kids Drawings - Sun */}
      <Box
        sx={{
          position: 'absolute',
          top: '5%',
          right: '15%',
          zIndex: 1
        }}
      >
        <svg width="80" height="80" viewBox="0 0 80 80">
          <circle cx="40" cy="40" r="25" fill="#FFD700" stroke="#FFA500" strokeWidth="2"/>
          <g stroke="#FFA500" strokeWidth="3" strokeLinecap="round">
            <line x1="40" y1="10" x2="40" y2="5"/>
            <line x1="40" y1="75" x2="40" y2="70"/>
            <line x1="10" y1="40" x2="5" y2="40"/>
            <line x1="75" y1="40" x2="70" y2="40"/>
            <line x1="20" y1="20" x2="17" y2="17"/>
            <line x1="63" y1="63" x2="60" y2="60"/>
            <line x1="20" y1="60" x2="17" y2="63"/>
            <line x1="63" y1="17" x2="60" y2="20"/>
          </g>
        </svg>
      </Box>

      {/* Kids Drawings - Rocket */}
      <Box
        sx={{
          position: 'absolute',
          top: '15%',
          left: '10%',
          zIndex: 1
        }}
      >
        <svg width="60" height="80" viewBox="0 0 60 80">
          {/* Rocket body */}
          <rect x="25" y="20" width="10" height="40" fill="#FF6B6B" stroke="#E74C3C" strokeWidth="2"/>
          {/* Rocket nose */}
          <polygon points="30,20 25,10 35,10" fill="#FF6B6B" stroke="#E74C3C" strokeWidth="2"/>
          {/* Rocket fins */}
          <polygon points="25,50 15,60 25,60" fill="#FF6B6B" stroke="#E74C3C" strokeWidth="2"/>
          <polygon points="35,50 45,60 35,60" fill="#FF6B6B" stroke="#E74C3C" strokeWidth="2"/>
          {/* Windows */}
          <circle cx="30" cy="30" r="2" fill="#87CEEB"/>
          <circle cx="30" cy="40" r="2" fill="#87CEEB"/>
          {/* Fire */}
          <polygon points="25,60 30,70 35,60" fill="#FFA500"/>
          <polygon points="26,60 30,68 34,60" fill="#FFD700"/>
        </svg>
      </Box>

      {/* Kids Drawings - Astronomer */}
      <Box
        sx={{
          position: 'absolute',
          bottom: '15%',
          right: '10%',
          zIndex: 1
        }}
      >
        <svg width="50" height="70" viewBox="0 0 50 70">
          {/* Astronomer body */}
          <ellipse cx="25" cy="45" rx="8" ry="12" fill="#4A90E2" stroke="#357ABD" strokeWidth="2"/>
          {/* Head */}
          <circle cx="25" cy="25" r="8" fill="#FFE4B5" stroke="#DEB887" strokeWidth="2"/>
          {/* Helmet */}
          <ellipse cx="25" cy="20" rx="10" ry="6" fill="#C0C0C0" stroke="#A0A0A0" strokeWidth="2"/>
          {/* Telescope */}
          <rect x="35" y="30" width="8" height="3" fill="#8B4513" stroke="#654321" strokeWidth="1"/>
          <circle cx="39" cy="31.5" r="2" fill="#000000"/>
          {/* Arms */}
          <line x1="17" y1="40" x2="10" y2="35" stroke="#4A90E2" strokeWidth="3" strokeLinecap="round"/>
          <line x1="33" y1="40" x2="40" y2="35" stroke="#4A90E2" strokeWidth="3" strokeLinecap="round"/>
        </svg>
      </Box>

      {/* Kids Drawings - Stars */}
      <Box
        sx={{
          position: 'absolute',
          top: '25%',
          left: '25%',
          zIndex: 1
        }}
      >
        <svg width="20" height="20" viewBox="0 0 20 20">
          <polygon points="10,2 12,8 18,8 13,12 15,18 10,14 5,18 7,12 2,8 8,8" fill="#FFD700"/>
        </svg>
      </Box>

      <Box
        sx={{
          position: 'absolute',
          top: '45%',
          left: '5%',
          zIndex: 1
        }}
      >
        <svg width="15" height="15" viewBox="0 0 15 15">
          <polygon points="7.5,1.5 9,6 13.5,6 10.5,9 12,13.5 7.5,10.5 3,13.5 4.5,9 1.5,6 6,6" fill="#FFD700"/>
        </svg>
      </Box>

      <Box
        sx={{
          position: 'absolute',
          top: '35%',
          right: '25%',
          zIndex: 1
        }}
      >
        <svg width="18" height="18" viewBox="0 0 18 18">
          <polygon points="9,1.5 11,7 16.5,7 12.5,11 14,16.5 9,12.5 4,16.5 5.5,11 1.5,7 7,7" fill="#FFD700"/>
        </svg>
      </Box>

      {/* Kids Drawings - Clouds */}
      <Box
        sx={{
          position: 'absolute',
          top: '10%',
          left: '50%',
          zIndex: 1
        }}
      >
        <svg width="80" height="40" viewBox="0 0 80 40">
          <ellipse cx="20" cy="20" rx="15" ry="10" fill="rgba(255,255,255,0.8)"/>
          <ellipse cx="35" cy="15" rx="12" ry="8" fill="rgba(255,255,255,0.8)"/>
          <ellipse cx="50" cy="20" rx="15" ry="10" fill="rgba(255,255,255,0.8)"/>
          <ellipse cx="65" cy="15" rx="10" ry="7" fill="rgba(255,255,255,0.8)"/>
        </svg>
      </Box>

      <Box
        sx={{
          position: 'absolute',
          top: '35%',
          right: '5%',
          zIndex: 1
        }}
      >
        <svg width="60" height="30" viewBox="0 0 60 30">
          <ellipse cx="15" cy="15" rx="12" ry="8" fill="rgba(255,255,255,0.7)"/>
          <ellipse cx="30" cy="10" rx="10" ry="6" fill="rgba(255,255,255,0.7)"/>
          <ellipse cx="45" cy="15" rx="12" ry="8" fill="rgba(255,255,255,0.7)"/>
        </svg>
      </Box>

      {/* Kids Drawings - Planet */}
      <Box
        sx={{
          position: 'absolute',
          bottom: '25%',
          left: '15%',
          zIndex: 1
        }}
      >
        <svg width="40" height="40" viewBox="0 0 40 40">
          <circle cx="20" cy="20" r="18" fill="#32CD32" stroke="#228B22" strokeWidth="2"/>
          <ellipse cx="15" cy="15" rx="3" ry="2" fill="#228B22"/>
          <ellipse cx="25" cy="25" rx="2" ry="1.5" fill="#228B22"/>
          <ellipse cx="30" cy="12" rx="1.5" ry="1" fill="#228B22"/>
        </svg>
      </Box>

      {/* Kids Drawings - Trees */}
      <Box
        sx={{
          position: 'absolute',
          bottom: '5%',
          left: '5%',
          zIndex: 1
        }}
      >
        <svg width="50" height="70" viewBox="0 0 50 70">
          {/* Tree trunk */}
          <rect x="22" y="40" width="6" height="30" fill="#8B4513" stroke="#654321" strokeWidth="1"/>
          {/* Tree leaves */}
          <circle cx="25" cy="35" r="15" fill="#228B22" stroke="#006400" strokeWidth="2"/>
          <circle cx="20" cy="30" r="8" fill="#32CD32" stroke="#228B22" strokeWidth="1"/>
          <circle cx="30" cy="30" r="8" fill="#32CD32" stroke="#228B22" strokeWidth="1"/>
        </svg>
      </Box>

      <Box
        sx={{
          position: 'absolute',
          bottom: '8%',
          right: '25%',
          zIndex: 1
        }}
      >
        <svg width="40" height="60" viewBox="0 0 40 60">
          {/* Tree trunk */}
          <rect x="18" y="35" width="4" height="25" fill="#8B4513" stroke="#654321" strokeWidth="1"/>
          {/* Tree leaves */}
          <circle cx="20" cy="30" r="12" fill="#228B22" stroke="#006400" strokeWidth="2"/>
          <circle cx="16" cy="25" r="6" fill="#32CD32" stroke="#228B22" strokeWidth="1"/>
          <circle cx="24" cy="25" r="6" fill="#32CD32" stroke="#228B22" strokeWidth="1"/>
        </svg>
      </Box>

      {/* Kids Drawings - Birds */}
      <Box
        sx={{
          position: 'absolute',
          top: '20%',
          left: '35%',
          zIndex: 1
        }}
      >
        <svg width="30" height="20" viewBox="0 0 30 20">
          {/* Bird body */}
          <ellipse cx="15" cy="10" rx="8" ry="5" fill="#FF6B6B" stroke="#E74C3C" strokeWidth="1"/>
          {/* Bird head */}
          <circle cx="22" cy="8" r="3" fill="#FF6B6B" stroke="#E74C3C" strokeWidth="1"/>
          {/* Bird beak */}
          <polygon points="25,8 27,7 27,9" fill="#FFA500"/>
          {/* Bird wings */}
          <ellipse cx="12" cy="8" rx="4" ry="2" fill="#FF8C00" stroke="#FF6B6B" strokeWidth="1"/>
          <ellipse cx="12" cy="12" rx="4" ry="2" fill="#FF8C00" stroke="#FF6B6B" strokeWidth="1"/>
        </svg>
      </Box>

      <Box
        sx={{
          position: 'absolute',
          top: '30%',
          left: '45%',
          zIndex: 1
        }}
      >
        <svg width="25" height="15" viewBox="0 0 25 15">
          {/* Bird body */}
          <ellipse cx="12" cy="7.5" rx="6" ry="4" fill="#4A90E2" stroke="#357ABD" strokeWidth="1"/>
          {/* Bird head */}
          <circle cx="18" cy="6" r="2.5" fill="#4A90E2" stroke="#357ABD" strokeWidth="1"/>
          {/* Bird beak */}
          <polygon points="20.5,6 22,5.5 22,6.5" fill="#FFA500"/>
          {/* Bird wings */}
          <ellipse cx="10" cy="6" rx="3" ry="1.5" fill="#357ABD" stroke="#4A90E2" strokeWidth="1"/>
          <ellipse cx="10" cy="9" rx="3" ry="1.5" fill="#357ABD" stroke="#4A90E2" strokeWidth="1"/>
        </svg>
      </Box>

      {/* Kids Drawings - Flowers */}
      <Box
        sx={{
          position: 'absolute',
          bottom: '12%',
          left: '30%',
          zIndex: 1
        }}
      >
        <svg width="30" height="30" viewBox="0 0 30 30">
          {/* Flower petals */}
          <circle cx="15" cy="15" r="8" fill="#FF69B4" stroke="#FF1493" strokeWidth="1"/>
          <circle cx="15" cy="7" r="4" fill="#FF69B4" stroke="#FF1493" strokeWidth="1"/>
          <circle cx="15" cy="23" r="4" fill="#FF69B4" stroke="#FF1493" strokeWidth="1"/>
          <circle cx="7" cy="15" r="4" fill="#FF69B4" stroke="#FF1493" strokeWidth="1"/>
          <circle cx="23" cy="15" r="4" fill="#FF69B4" stroke="#FF1493" strokeWidth="1"/>
          {/* Flower center */}
          <circle cx="15" cy="15" r="3" fill="#FFD700"/>
          {/* Flower stem */}
          <line x1="15" y1="23" x2="15" y2="30" stroke="#228B22" strokeWidth="2"/>
        </svg>
      </Box>

      <Box
        sx={{
          position: 'absolute',
          bottom: '15%',
          right: '35%',
          zIndex: 1
        }}
      >
        <svg width="25" height="25" viewBox="0 0 25 25">
          {/* Flower petals */}
          <circle cx="12.5" cy="12.5" r="6" fill="#FFB6C1" stroke="#FF69B4" strokeWidth="1"/>
          <circle cx="12.5" cy="6.5" r="3" fill="#FFB6C1" stroke="#FF69B4" strokeWidth="1"/>
          <circle cx="12.5" cy="18.5" r="3" fill="#FFB6C1" stroke="#FF69B4" strokeWidth="1"/>
          <circle cx="6.5" cy="12.5" r="3" fill="#FFB6C1" stroke="#FF69B4" strokeWidth="1"/>
          <circle cx="18.5" cy="12.5" r="3" fill="#FFB6C1" stroke="#FF69B4" strokeWidth="1"/>
          {/* Flower center */}
          <circle cx="12.5" cy="12.5" r="2" fill="#FFD700"/>
        </svg>
      </Box>

      {/* Kids Drawings - Butterfly */}
      <Box
        sx={{
          position: 'absolute',
          top: '50%',
          left: '20%',
          zIndex: 1
        }}
      >
        <svg width="25" height="20" viewBox="0 0 25 20">
          {/* Butterfly body */}
          <ellipse cx="12.5" cy="10" rx="1" ry="8" fill="#8B4513"/>
          {/* Butterfly wings */}
          <ellipse cx="8" cy="8" rx="4" ry="6" fill="#FF69B4" stroke="#FF1493" strokeWidth="1"/>
          <ellipse cx="17" cy="8" rx="4" ry="6" fill="#FF69B4" stroke="#FF1493" strokeWidth="1"/>
          <ellipse cx="8" cy="12" rx="4" ry="6" fill="#FFB6C1" stroke="#FF69B4" strokeWidth="1"/>
          <ellipse cx="17" cy="12" rx="4" ry="6" fill="#FFB6C1" stroke="#FF69B4" strokeWidth="1"/>
          {/* Wing patterns */}
          <circle cx="7" cy="7" r="1" fill="#FFD700"/>
          <circle cx="18" cy="7" r="1" fill="#FFD700"/>
          <circle cx="7" cy="13" r="1" fill="#FFD700"/>
          <circle cx="18" cy="13" r="1" fill="#FFD700"/>
        </svg>
      </Box>

      {/* Kids Drawings - Rainbow */}
      <Box
        sx={{
          position: 'absolute',
          top: '8%',
          left: '20%',
          zIndex: 1
        }}
      >
        <svg width="60" height="30" viewBox="0 0 60 30">
          <path d="M 5 25 Q 30 5 55 25" fill="none" stroke="#FF0000" strokeWidth="2"/>
          <path d="M 5 26 Q 30 6 55 26" fill="none" stroke="#FF7F00" strokeWidth="2"/>
          <path d="M 5 27 Q 30 7 55 27" fill="none" stroke="#FFFF00" strokeWidth="2"/>
          <path d="M 5 28 Q 30 8 55 28" fill="none" stroke="#00FF00" strokeWidth="2"/>
          <path d="M 5 29 Q 30 9 55 29" fill="none" stroke="#0000FF" strokeWidth="2"/>
        </svg>
      </Box>

      <Container maxWidth="xs" sx={{ position: 'relative', zIndex: 2 }}>
        <Fade in timeout={1000}>
          <Paper
            elevation={24}
            sx={{
              p: 3,
              borderRadius: 3,
              background: 'rgba(255, 255, 255, 0.95)',
              backdropFilter: 'blur(10px)',
              border: '1px solid rgba(255, 255, 255, 0.2)',
              boxShadow: '0 25px 45px rgba(0, 0, 0, 0.1)',
              position: 'relative',
              overflow: 'hidden',
              '&::before': {
                content: '""',
                position: 'absolute',
                top: 0,
                left: 0,
                right: 0,
                height: 4,
                background: 'linear-gradient(90deg, #87CEEB, #4682B4, #87CEEB, #4682B4)'
              }
            }}
          >
            {/* Header Section */}
            <Box sx={{ textAlign: 'center', mb: 3 }}>
              
              
              <Slide direction="up" in timeout={1000}>
                <Box
                  sx={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    mb: 1
                  }}
                >
                                    <Typography
                    variant="h4"
                    component="span"
                    sx={{
                      fontWeight: 700,
                      color: '#ff6b35',
                      textShadow: '0 2px 4px rgba(0,0,0,0.1)'
                    }}
                  >
                    Kid
                  </Typography>
                  <Box
                    component="span"
                    sx={{
                      display: 'inline-flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      width: 48,
                      height: 48,
                      borderRadius: '50%',
                      background: 'linear-gradient(45deg, #ff6b35, #f7931e)',
                      color: 'white',
                      fontSize: '2.125rem',
                      fontWeight: 700,
                      marginLeft: 0,
                      boxShadow: '0 4px 12px rgba(255, 107, 53, 0.3)'
                    }}
                  >
                    sy
                  </Box>
                </Box>
              </Slide>
              

            </Box>

            <Box component="form" onSubmit={handleSubmit}>
              <Slide direction="up" in timeout={1400}>
                <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                  {authError && (
                    <Alert 
                      severity="error" 
                      sx={{ 
                        mb: 2,
                        borderRadius: 2,
                        boxShadow: '0 4px 12px rgba(244, 67, 54, 0.15)',
                        fontSize: '0.875rem'
                      }}
                    >
                      {authError}
                    </Alert>
                  )}

                  {/* Login Type Toggle */}
                  <Box sx={{ mb: 2, display: 'flex', justifyContent: 'center', width: '100%' }}>
                                          <ButtonGroup
                        variant="outlined"
                        size="medium"
                        sx={{
                          borderRadius: 2,
                          boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
                          '& .MuiButton-root': {
                            borderRadius: 2,
                            border: 'none',
                            px: 2,
                            py: 1,
                            fontWeight: 600,
                            fontSize: '0.875rem',
                            transition: 'all 0.3s ease',
                            '&:hover': {
                              transform: 'translateY(-2px)',
                              boxShadow: '0 6px 20px rgba(0,0,0,0.15)'
                            }
                          }
                        }}
                      >
                      <Button
                        variant={formData.loginType === 'username' ? 'contained' : 'outlined'}
                        onClick={() => setFormData(prev => ({ ...prev, loginType: 'username' }))}
                        startIcon={<AccountCircleIcon />}
                        sx={{
                          background: formData.loginType === 'username' 
                            ? 'linear-gradient(45deg, #87CEEB, #4682B4)' 
                            : 'transparent',
                          color: formData.loginType === 'username' ? 'white' : 'primary.main',
                          '&:hover': {
                            background: formData.loginType === 'username' 
                              ? 'linear-gradient(45deg, #4682B4, #357ABD)' 
                              : 'rgba(135, 206, 235, 0.1)'
                          }
                        }}
                      >
                        Username
                      </Button>
                      <Button
                        variant={formData.loginType === 'mobile' ? 'contained' : 'outlined'}
                        onClick={() => setFormData(prev => ({ ...prev, loginType: 'mobile' }))}
                        startIcon={<PhoneIcon />}
                        sx={{
                          background: formData.loginType === 'mobile' 
                            ? 'linear-gradient(45deg, #87CEEB, #4682B4)' 
                            : 'transparent',
                          color: formData.loginType === 'mobile' ? 'white' : 'primary.main',
                          '&:hover': {
                            background: formData.loginType === 'mobile' 
                              ? 'linear-gradient(45deg, #4682B4, #357ABD)' 
                              : 'rgba(135, 206, 235, 0.1)'
                          }
                        }}
                      >
                        Mobile Number
                      </Button>
                    </ButtonGroup>
                  </Box>

                  {/* Input Fields */}
                  <Slide direction="up" in timeout={1600}>
                    <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', width: '100%' }}>
                      {formData.loginType === 'username' ? (
                        <TextField
                          label="Username"
                          name="username"
                          value={formData.username}
                          onChange={handleInputChange}
                          error={!!errors.username}
                          helperText={errors.username}
                          required
                          margin="dense"
                          size="small"
                          InputProps={{
                            startAdornment: (
                              <InputAdornment position="start">
                                <PersonIcon sx={{ color: 'primary.main', fontSize: 20 }} />
                              </InputAdornment>
                            ),
                          }}
                          disabled={loading}
                          sx={{
                            width: '100%',
                            maxWidth: 280,
                            '& .MuiOutlinedInput-root': {
                              borderRadius: 2,
                              transition: 'all 0.3s ease',
                              '&:hover': {
                                transform: 'translateY(-1px)',
                                boxShadow: '0 4px 12px rgba(0,0,0,0.1)'
                              },
                              '&.Mui-focused': {
                                transform: 'translateY(-2px)',
                                boxShadow: '0 6px 20px rgba(135, 206, 235, 0.2)'
                              }
                            }
                          }}
                        />
                      ) : (
                        <TextField
                          label="Mobile Number"
                          name="mobile"
                          value={formData.mobile}
                          onChange={handleInputChange}
                          error={!!errors.mobile}
                          helperText={errors.mobile}
                          required
                          margin="dense"
                          size="small"
                          placeholder="Enter 10-digit mobile number"
                          InputProps={{
                            startAdornment: (
                              <InputAdornment position="start">
                                <PhoneIcon sx={{ color: 'primary.main', fontSize: 20 }} />
                              </InputAdornment>
                            ),
                          }}
                          disabled={loading}
                          sx={{
                            width: '100%',
                            maxWidth: 280,
                            '& .MuiOutlinedInput-root': {
                              borderRadius: 2,
                              transition: 'all 0.3s ease',
                              '&:hover': {
                                transform: 'translateY(-1px)',
                                boxShadow: '0 4px 12px rgba(0,0,0,0.1)'
                              },
                              '&.Mui-focused': {
                                transform: 'translateY(-2px)',
                                boxShadow: '0 6px 20px rgba(135, 206, 235, 0.2)'
                              }
                            }
                          }}
                        />
                      )}

                      <TextField
                        label="Password"
                        name="password"
                        type={showPassword ? 'text' : 'password'}
                        value={formData.password}
                        onChange={handleInputChange}
                        error={!!errors.password}
                        helperText={errors.password}
                        required
                        margin="dense"
                        size="small"
                        InputProps={{
                          startAdornment: (
                            <InputAdornment position="start">
                              <LockIcon sx={{ color: 'primary.main', fontSize: 20 }} />
                            </InputAdornment>
                          ),
                          endAdornment: (
                            <InputAdornment position="end">
                              <IconButton
                                onClick={handleTogglePassword}
                                edge="end"
                                disabled={loading}
                                size="small"
                                sx={{
                                  color: 'primary.main',
                                  '&:hover': {
                                    backgroundColor: 'rgba(135, 206, 235, 0.1)'
                                  }
                                }}
                              >
                                {showPassword ? <VisibilityOffIcon /> : <VisibilityIcon />}
                              </IconButton>
                            </InputAdornment>
                          ),
                        }}
                        disabled={loading}
                        sx={{
                          width: '100%',
                          maxWidth: 280,
                          '& .MuiOutlinedInput-root': {
                            borderRadius: 2,
                            transition: 'all 0.3s ease',
                            '&:hover': {
                              transform: 'translateY(-1px)',
                              boxShadow: '0 4px 12px rgba(0,0,0,0.1)'
                            },
                            '&.Mui-focused': {
                              transform: 'translateY(-2px)',
                              boxShadow: '0 6px 20px rgba(135, 206, 235, 0.2)'
                            }
                          }
                        }}
                      />
                    </Box>
                  </Slide>

                  {/* Submit Button */}
                  <Slide direction="up" in timeout={1800}>
                    <Box sx={{ display: 'flex', justifyContent: 'center', width: '100%' }}>
                      <Button
                        type="submit"
                        variant="contained"
                        disabled={loading}
                        startIcon={loading ? <CircularProgress size={18} sx={{ color: 'white' }} /> : <LoginIcon />}
                        sx={{
                          mt: 3,
                          mb: 2,
                          py: 1.5,
                          px: 4,
                          borderRadius: 2,
                          fontSize: '1rem',
                          fontWeight: 600,
                          width: '100%',
                          maxWidth: 280,
                          background: 'linear-gradient(45deg, #87CEEB, #4682B4)',
                          boxShadow: '0 8px 25px rgba(135, 206, 235, 0.3)',
                          transition: 'all 0.3s ease',
                          '&:hover': {
                            background: 'linear-gradient(45deg, #4682B4, #357ABD)',
                            transform: 'translateY(-3px)',
                            boxShadow: '0 12px 35px rgba(135, 206, 235, 0.4)'
                          },
                          '&:disabled': {
                            background: 'linear-gradient(45deg, #ccc, #999)',
                            transform: 'none',
                            boxShadow: 'none'
                          }
                        }}
                      >
                        {loading ? 'Signing In...' : 'Sign In'}
                      </Button>
                    </Box>
                  </Slide>
                </Box>
              </Slide>
            </Box>
          </Paper>
        </Fade>
      </Container>


    </Box>
  );
};

export default Login; 