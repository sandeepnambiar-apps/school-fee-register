import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  AppBar,
  Box,
  CssBaseline,
  Drawer,
  IconButton,
  List,
  ListItem,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  Toolbar,
  Typography,
  Grid,
  Card,
  CardContent,
  CardActions,
  Button,
  Container,
  Paper,
  Chip,
  Avatar,
  Menu,
  MenuItem,
  Divider,
  CircularProgress
} from '@mui/material';
import {
  Menu as MenuIcon,
  Dashboard as DashboardIcon,
  People as PeopleIcon,
  Payment as PaymentIcon,
  Notifications as NotificationsIcon,
  Assessment as AssessmentIcon,
  TrendingUp as TrendingUpIcon,
  AccountBalance as AccountBalanceIcon,
  Receipt as ReceiptIcon,
  Email as EmailIcon,
  Settings as SettingsIcon,
  Assignment as AssignmentIcon,
  AccountCircle as AccountCircleIcon,
  Person as PersonIcon,
  Logout as LogoutIcon,
  Security as SecurityIcon,
  CalendarToday as CalendarIcon,
  Schedule as TimetableIcon,
  Support as SupportIcon
} from '@mui/icons-material';
import { Routes, Route, Navigate, useNavigate, BrowserRouter } from 'react-router-dom';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import { LanguageProvider } from './contexts/LanguageContext';
import Login from './components/Auth/Login';
import Dashboard from './components/Dashboard';
import Students from './components/Students';
import StudentProfile from './components/Profile/StudentProfile';
import Fees from './components/Fees';
import Payments from './components/Payments';
import HomeworkDashboard from './components/Homework/HomeworkDashboard';
import Notifications from './components/Notifications';
import MarksAndReports from './components/MarksAndReports';
import Calendar from './components/Calendar';
import Timetable from './components/Timetable';
import HelpDesk from './components/HelpDesk';
import LanguageSwitcher from './components/LanguageSwitcher';
import MobileOptimizer from './components/MobileOptimizer';

const drawerWidth = 240;

// Service Status Interface
interface ServiceStatus {
  name: string;
  status: 'running' | 'stopped' | 'error';
  port: number;
  url: string;
}

// Menu Item Interface
interface MenuItem {
  text: string;
  icon: React.ReactNode;
  path: string;
  roles: string[];
}

// Service Card Interface
interface ServiceCard {
  title: string;
  description: string;
  icon: React.ReactNode;
  status: string;
  port: number;
  color: string;
}

// Service Status Component
const ServiceStatusCard: React.FC<ServiceCard> = ({ title, description, icon, status, port, color }) => (
  <Card sx={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
    <CardContent sx={{ flexGrow: 1 }}>
      <Box display="flex" alignItems="center" mb={2}>
        <Box sx={{ color, mr: 1 }}>{icon}</Box>
        <Typography variant="h6" component="h2">
          {title}
        </Typography>
      </Box>
      <Typography variant="body2" color="text.secondary" mb={2}>
        {description}
      </Typography>
      <Box display="flex" alignItems="center" gap={1}>
        <Chip 
          label={status} 
          size="small" 
          color={status === 'running' ? 'success' : status === 'error' ? 'error' : 'default'}
        />
        <Typography variant="caption" color="text.secondary">
          Port: {port}
        </Typography>
      </Box>
    </CardContent>
    <CardActions>
      <Button size="small" color="primary">
        View Details
      </Button>
    </CardActions>
  </Card>
);

// Protected Route Component
interface ProtectedRouteProps {
  children: React.ReactNode;
  allowedRoles?: string[];
}

const ProtectedRoute: React.FC<ProtectedRouteProps> = ({ children, allowedRoles = [] }) => {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="400px">
        <CircularProgress />
      </Box>
    );
  }

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  if (allowedRoles.length > 0 && !allowedRoles.some(role => user!.role === role || (user!.roles && user!.roles.includes(role)))) {
    return <Navigate to="/dashboard" replace />;
  }

  return <>{children}</>;
};

// Main App Content Component
const AppContent: React.FC = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [mobileOpen, setMobileOpen] = useState(false);
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };

  const handleProfileMenuOpen = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorEl(event.currentTarget);
  };

  const handleProfileMenuClose = () => {
    setAnchorEl(null);
  };

  const handleLogout = async () => {
    await logout();
    navigate('/login');
    handleProfileMenuClose();
  };

  // If not authenticated, show login
  if (!user) {
    return <Navigate to="/login" replace />;
  }

  // Menu items based on user role
  const menuItems: MenuItem[] = [
    {
      text: t('navigation.dashboard'),
      icon: <DashboardIcon />,
      path: '/dashboard',
      roles: ['SUPER_ADMIN', 'SCHOOL_ADMIN', 'TEACHER', 'PARENT']
    },
    {
      text: t('navigation.students'),
      icon: <PeopleIcon />,
      path: '/students',
      roles: ['SUPER_ADMIN', 'SCHOOL_ADMIN', 'TEACHER']
    },
    {
      text: t('navigation.fees'),
      icon: <PaymentIcon />,
      path: '/fees',
      roles: ['SUPER_ADMIN', 'SCHOOL_ADMIN', 'PARENT']
    },
    {
      text: t('navigation.payments'),
      icon: <ReceiptIcon />,
      path: '/payments',
      roles: ['SUPER_ADMIN', 'SCHOOL_ADMIN']
    },
    {
      text: t('navigation.homework'),
      icon: <AssignmentIcon />,
      path: '/homework',
      roles: ['SUPER_ADMIN', 'SCHOOL_ADMIN', 'TEACHER', 'PARENT']
    },
    {
      text: t('navigation.calendar'),
      icon: <CalendarIcon />,
      path: '/calendar',
      roles: ['SUPER_ADMIN', 'SCHOOL_ADMIN', 'TEACHER', 'PARENT']
    },
    {
      text: t('navigation.timetable'),
      icon: <TimetableIcon />,
      path: '/timetable',
      roles: ['SUPER_ADMIN', 'SCHOOL_ADMIN', 'TEACHER', 'PARENT']
    },
    {
      text: t('navigation.notifications'),
      icon: <NotificationsIcon />,
      path: '/notifications',
      roles: ['SUPER_ADMIN', 'SCHOOL_ADMIN', 'TEACHER', 'PARENT']
    },
    {
      text: t('navigation.marksReports'),
      icon: <AssessmentIcon />,
      path: '/marks-reports',
      roles: ['SUPER_ADMIN', 'SCHOOL_ADMIN', 'TEACHER', 'PARENT']
    },
    {
      text: t('navigation.helpDesk'),
      icon: <SupportIcon />,
      path: '/help-desk',
      roles: ['SUPER_ADMIN', 'SCHOOL_ADMIN', 'PARENT']
    }
  ];

  // Filter menu items based on user role
  const userRole = user!.role || user!.roles?.[0] || 'USER';
  const filteredMenuItems = menuItems.filter(item => 
    item.roles.includes(userRole)
  );

  // Drawer content
  const drawer = (
    <div>
      <Toolbar>
        <Box display="flex" alignItems="center">
          <Avatar sx={{ width: 40, height: 40, mr: 2, bgcolor: 'primary.main' }}>
            <AccountCircleIcon sx={{ color: 'white' }} />
          </Avatar>
          <Box>
            <Typography variant="h6" noWrap component="div" sx={{ fontWeight: 'bold' }}>
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <Typography
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
                    width: 24,
                    height: 24,
                    borderRadius: '50%',
                    background: 'linear-gradient(45deg, #ff6b35, #f7931e)',
                    color: 'white',
                    fontSize: '0.875rem',
                    fontWeight: 700,
                    marginLeft: 0,
                    boxShadow: '0 4px 12px rgba(255, 107, 53, 0.3)'
                  }}
                >
                  sy
                </Box>
              </Box>
            </Typography>
            <Typography variant="caption" color="text.secondary" noWrap>
              {t('common.schoolManagementSystem')}
            </Typography>
          </Box>
        </Box>
      </Toolbar>
      <Divider />
      <List>
        {filteredMenuItems.map((item) => (
          <ListItem key={item.text} disablePadding>
            <ListItemButton onClick={() => navigate(item.path)}>
              <ListItemIcon>{item.icon}</ListItemIcon>
              <ListItemText primary={item.text} />
            </ListItemButton>
          </ListItem>
        ))}
      </List>
    </div>
  );

  return (
    <Box sx={{ display: 'flex' }}>
      <CssBaseline />
      <AppBar
        position="fixed"
        sx={{
          width: { sm: `calc(100% - ${drawerWidth}px)` },
          ml: { sm: `${drawerWidth}px` },
        }}
      >
        <Toolbar>
          <IconButton
            color="inherit"
            aria-label={t('common.openDrawer')}
            edge="start"
            onClick={handleDrawerToggle}
            sx={{ mr: 2, display: { sm: 'none' } }}
          >
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" noWrap component="div" sx={{ flexGrow: 1 }}>
            <Box sx={{ display: 'flex', alignItems: 'center' }}>
              <Typography
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
                  width: 32,
                  height: 32,
                  borderRadius: '50%',
                  background: 'linear-gradient(45deg, #ff6b35, #f7931e)',
                  color: 'white',
                  fontSize: '1.25rem',
                  fontWeight: 700,
                  marginLeft: 0,
                  boxShadow: '0 4px 12px rgba(255, 107, 53, 0.3)'
                }}
              >
                sy
              </Box>
              <Typography
                component="span"
                sx={{
                  marginLeft: 1,
                  fontWeight: 500,
                  color: '#2c3e50'
                }}
              >
                {t('common.schoolManagementSystem')}
              </Typography>
            </Box>
          </Typography>
          
          {/* User Profile Menu */}
          <Box display="flex" alignItems="center" gap={2}>
            <LanguageSwitcher 
              userRole={user!.role || user!.roles?.[0]} 
              userName={user!.fullName || 'User'}
            />
            <Typography variant="body2" color="inherit">
              {t('common.welcome')}, {user!.fullName || t('common.user')}
            </Typography>
            <Chip 
                              label={user!.role || user!.roles?.[0] || 'User'} 
              size="small" 
              color="secondary" 
              variant="outlined"
            />
            <IconButton
              color="inherit"
              onClick={handleProfileMenuOpen}
            >
              <Avatar sx={{ width: 32, height: 32 }}>
                <AccountCircleIcon />
              </Avatar>
            </IconButton>
            <Menu
              anchorEl={anchorEl}
              open={Boolean(anchorEl)}
              onClose={handleProfileMenuClose}
              anchorOrigin={{
                vertical: 'bottom',
                horizontal: 'right',
              }}
              transformOrigin={{
                vertical: 'top',
                horizontal: 'right',
              }}
            >
              <MenuItem onClick={() => { navigate('/profile'); handleProfileMenuClose(); }}>
                <ListItemIcon>
                  <PersonIcon fontSize="small" />
                </ListItemIcon>
                {t('common.profile')}
              </MenuItem>
              <Divider />
              <MenuItem onClick={handleLogout}>
                <ListItemIcon>
                  <LogoutIcon fontSize="small" />
                </ListItemIcon>
                {t('common.logout')}
              </MenuItem>
            </Menu>
          </Box>
        </Toolbar>
      </AppBar>
      
      <Box
        component="nav"
        sx={{ width: { sm: drawerWidth }, flexShrink: { sm: 0 } }}
        aria-label="mailbox folders"
      >
        <Drawer
          variant="temporary"
          open={mobileOpen}
          onClose={handleDrawerToggle}
          ModalProps={{
            keepMounted: true,
          }}
          sx={{
            display: { xs: 'block', sm: 'none' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: drawerWidth },
          }}
        >
          {drawer}
        </Drawer>
        <Drawer
          variant="permanent"
          sx={{
            display: { xs: 'none', sm: 'block' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: drawerWidth },
          }}
          open
        >
          {drawer}
        </Drawer>
      </Box>
      
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          p: 3,
          width: { sm: `calc(100% - ${drawerWidth}px)` },
        }}
      >
        <Toolbar />
        <Container maxWidth="xl">
          <Routes>
            <Route path="/dashboard" element={
              <ProtectedRoute>
                <Dashboard 
                  userRole={user!.role || user!.roles?.[0] || 'USER'}
                  serviceCards={[
                  {
                    title: 'Student Service',
                    description: 'Student Management and Registration',
                    icon: <PeopleIcon />,
                    status: 'Running',
                    port: 8081,
                    color: '#7b1fa2'
                  },
                  {
                    title: 'Fee Service',
                    description: 'Fee Structure and Management',
                    icon: <PaymentIcon />,
                    status: 'Running',
                    port: 8082,
                    color: '#f57c00'
                  },
                  {
                    title: 'Payment Service',
                    description: 'Payment Processing and Transactions',
                    icon: <ReceiptIcon />,
                    status: 'Running',
                    port: 8083,
                    color: '#d32f2f'
                  },
                  {
                    title: 'Notification Service',
                    description: 'Email and SMS Notifications',
                    icon: <EmailIcon />,
                    status: 'Running',
                    port: 8084,
                    color: '#1976d2'
                  },
                  {
                    title: 'Auth Service',
                    description: 'Authentication and Authorization',
                    icon: <SecurityIcon />,
                    status: 'Running',
                    port: 8082,
                    color: '#388e3c'
                  },
                  {
                    title: 'Reporting Service',
                    description: 'Reports and Analytics',
                    icon: <AssessmentIcon />,
                    status: 'Running',
                    port: 8087,
                    color: '#1976d2'
                  }
                ]} />
              </ProtectedRoute>
            } />
            
            <Route path="/students" element={
              <ProtectedRoute allowedRoles={['SUPER_ADMIN', 'SCHOOL_ADMIN', 'TEACHER']}>
                <Students />
              </ProtectedRoute>
            } />
            
            <Route path="/profile" element={
              <ProtectedRoute>
                <StudentProfile studentId={user!.id} userRole={user!.role || user!.roles?.[0] || 'USER'} />
              </ProtectedRoute>
            } />
            
            <Route path="/fees" element={
              <ProtectedRoute>
                <Fees />
              </ProtectedRoute>
            } />
            
            <Route path="/payments" element={
              <ProtectedRoute allowedRoles={['SUPER_ADMIN', 'SCHOOL_ADMIN']}>
                <Payments />
              </ProtectedRoute>
            } />
            
            <Route path="/homework" element={
              <ProtectedRoute>
                <HomeworkDashboard userRole={user!.role || user!.roles?.[0] || 'USER'} userId={user!.id} />
              </ProtectedRoute>
            } />
            
            <Route path="/calendar" element={
              <ProtectedRoute>
                <Calendar userRole={user!.role || user!.roles?.[0] || 'USER'} userId={user!.id} />
              </ProtectedRoute>
            } />
            
            <Route path="/timetable" element={
              <ProtectedRoute>
                <Timetable userRole={user!.role || user!.roles?.[0] || 'USER'} userId={user!.id} />
              </ProtectedRoute>
            } />
            
            <Route path="/notifications" element={
              <ProtectedRoute>
                <Notifications userRole={user!.role || user!.roles?.[0] || 'USER'} />
              </ProtectedRoute>
            } />
            
            <Route path="/marks-reports" element={
              <ProtectedRoute>
                <MarksAndReports userRole={user!.role || user!.roles?.[0] || 'USER'} userId={user!.id} />
              </ProtectedRoute>
            } />
            
            <Route path="/help-desk" element={
              <ProtectedRoute>
                <HelpDesk />
              </ProtectedRoute>
            } />
            
            <Route path="/" element={<Navigate to="/dashboard" replace />} />
          </Routes>
        </Container>
      </Box>
    </Box>
  );
};

// Main App Component with Auth Provider
function App() {
  return (
    <AuthProvider>
      <LanguageProvider>
        <MobileOptimizer>
          <Routes>
            <Route path="/login" element={<Login />} />
            <Route path="/*" element={<AppContent />} />
          </Routes>
        </MobileOptimizer>
      </LanguageProvider>
    </AuthProvider>
  );
}

export default App; 