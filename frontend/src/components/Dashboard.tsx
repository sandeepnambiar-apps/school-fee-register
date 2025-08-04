import React, { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import {
  Grid,
  Card,
  CardContent,
  Typography,
  Box,
  Chip,
  Paper,
  Container,
  LinearProgress,
  List,
  ListItem,
  ListItemText,
  ListItemIcon,
  CircularProgress,
  Skeleton,
} from '@mui/material';
import {
  TrendingUp,
  People,
  Payment,
  Email,
  Assessment,
  Settings,
  CheckCircle,
  Warning,
  Error,
  Assignment,
} from '@mui/icons-material';
import { dashboardAPI, DashboardData, DashboardStats } from '../services/dashboardAPI';
import { canAccessServerMonitoring, getRoleDisplayName } from '../utils/roleUtils';

interface ServiceCard {
  title: string;
  description: string;
  icon: React.ReactNode;
  status: string;
  port: number;
  color: string;
}

interface DashboardProps {
  serviceCards: ServiceCard[];
  userRole: string;
}

const Dashboard: React.FC<DashboardProps> = ({ serviceCards, userRole }) => {
  const { t } = useTranslation();
  const [dashboardData, setDashboardData] = useState<DashboardData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        setLoading(true);
        setError(null);
        
        // Add timeout to prevent hanging
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), 10000);
        
        try {
          const data = await dashboardAPI.getDashboardData(userRole);
          clearTimeout(timeoutId);
          setDashboardData(data);
        } catch (fetchError) {
          clearTimeout(timeoutId);
          throw fetchError;
        }
      } catch (err) {
        console.error('Error fetching dashboard data:', err);
        setError('Failed to load dashboard data');
        // Use fallback data immediately
        setDashboardData(dashboardAPI.getFallbackData(userRole));
      } finally {
        setLoading(false);
      }
    };

    fetchDashboardData();
  }, [userRole]);

  // Role-specific statistics
  const getStats = () => {
    if (!dashboardData) return [];

    if (userRole === 'PARENT') {
      return [
        { label: t('dashboard.myChildren'), value: dashboardData.stats.myChildren?.toString() || '0', icon: <People />, color: '#ff6b35' },
        { label: t('dashboard.totalFeesPaid'), value: `$${dashboardData.stats.totalFeesPaid?.toLocaleString() || '0'}`, icon: <Payment />, color: '#388e3c' },
        { label: t('dashboard.pendingPayments'), value: dashboardData.stats.pendingPayments?.toString() || '0', icon: <Warning />, color: '#f57c00' },
        { label: t('dashboard.recentNotifications'), value: dashboardData.stats.recentNotifications?.toString() || '0', icon: <Email />, color: '#7b1fa2' },
      ];
    } else if (userRole === 'TEACHER') {
      return [
        { label: t('dashboard.myStudents'), value: dashboardData.stats.myStudents?.toString() || '0', icon: <People />, color: '#ff6b35' },
        { label: t('dashboard.activeHomework'), value: dashboardData.stats.activeHomework?.toString() || '0', icon: <Assignment />, color: '#388e3c' },
        { label: t('dashboard.pendingAssignments'), value: dashboardData.stats.pendingAssignments?.toString() || '0', icon: <Warning />, color: '#f57c00' },
        { label: t('dashboard.recentNotifications'), value: dashboardData.stats.recentNotifications?.toString() || '0', icon: <Email />, color: '#7b1fa2' },
      ];
    } else {
      // Admin/Default stats
      return [
        { label: t('dashboard.totalStudents'), value: dashboardData.stats.totalStudents?.toLocaleString() || '0', icon: <People />, color: '#ff6b35' },
        { label: t('dashboard.totalFeesCollected'), value: `$${dashboardData.stats.totalFeesCollected?.toLocaleString() || '0'}`, icon: <Payment />, color: '#388e3c' },
        { label: t('dashboard.pendingPayments'), value: dashboardData.stats.pendingPayments?.toString() || '0', icon: <Warning />, color: '#f57c00' },
        { label: t('dashboard.activeFeeStructures'), value: dashboardData.stats.activeFeeStructures?.toString() || '0', icon: <Assessment />, color: '#7b1fa2' },
      ];
    }
  };

  const stats = getStats();



  const getRecentActivities = () => {
    if (!dashboardData) return [];
    return dashboardData.recentActivities.map(activity => ({
      text: activity.text,
      time: activity.time
    }));
  };

  const recentActivities = getRecentActivities();

  const getStatusColor = (status: string) => {
    switch (status.toLowerCase()) {
      case 'running':
        return 'success';
      case 'stopped':
        return 'error';
      case 'starting':
        return 'warning';
      default:
        return 'default';
    }
  };

  const getStatusIcon = (status: string) => {
    switch (status.toLowerCase()) {
      case 'running':
        return <CheckCircle fontSize="small" />;
      case 'stopped':
        return <Error fontSize="small" />;
      case 'starting':
        return <Warning fontSize="small" />;
      default:
        return <Warning fontSize="small" />;
    }
  };

  if (loading) {
    return (
      <Container maxWidth="xl">
        <Box>
          {/* Title Skeleton */}
          <Skeleton variant="text" width="60%" height={60} sx={{ mb: 3 }} />
          
          {/* Stats Cards Skeleton */}
          <Grid container spacing={3} sx={{ mb: 4 }}>
            {[1, 2, 3, 4].map((item) => (
              <Grid item xs={12} sm={6} md={3} key={item}>
                <Card>
                  <CardContent>
                    <Skeleton variant="text" width="40%" height={20} />
                    <Skeleton variant="text" width="60%" height={40} />
                    <Skeleton variant="circular" width={40} height={40} sx={{ mt: 1 }} />
                  </CardContent>
                </Card>
              </Grid>
            ))}
          </Grid>
          
          {/* Service Status Skeleton */}
          <Skeleton variant="text" width="30%" height={40} sx={{ mb: 2 }} />
          <Grid container spacing={2} sx={{ mb: 4 }}>
            {[1, 2, 3, 4].map((item) => (
              <Grid item xs={12} sm={6} md={3} key={item}>
                <Skeleton variant="rectangular" height={100} />
              </Grid>
            ))}
          </Grid>
          
          {/* Recent Activities Skeleton */}
          <Skeleton variant="text" width="25%" height={40} sx={{ mb: 2 }} />
          <Card>
            <CardContent>
              {[1, 2, 3, 4].map((item) => (
                <Skeleton key={item} variant="text" width="100%" height={30} sx={{ mb: 1 }} />
              ))}
            </CardContent>
          </Card>
        </Box>
      </Container>
    );
  }

  if (error) {
    return (
      <Container maxWidth="xl">
        <Typography variant="h6" color="error" sx={{ mb: 2, fontWeight: 600 }}>
          {error}
        </Typography>
        <Typography variant="body2" color="textSecondary" sx={{ fontSize: '1rem' }}>
          Please try refreshing the page or contact support if the problem persists.
        </Typography>
      </Container>
    );
  }

  return (
    <Container maxWidth="xl">
      <Typography 
        variant="h4" 
        gutterBottom 
        sx={{ 
          mb: 4, 
          fontWeight: 500,
          fontSize: '1.8rem',
          fontFamily: '"Roboto", "Helvetica", "Arial", sans-serif',
          color: '#2c3e50',
          letterSpacing: '0.5px',
          textAlign: 'center',
          borderBottom: '2px solid #ff6b35',
          paddingBottom: '10px',
          marginBottom: '30px'
        }}
      >
        {userRole === 'PARENT' ? t('dashboard.parentDashboard') : 
         userRole === 'TEACHER' ? t('dashboard.teacherDashboard') : 
         canAccessServerMonitoring(userRole) ? t('dashboard.systemAdminDashboard') :
         t('dashboard.title')}
      </Typography>

      {/* Statistics Cards */}
      <Grid container spacing={3} sx={{ mb: 4 }}>
        {stats.map((stat, index) => (
          <Grid item xs={12} sm={6} md={3} key={index}>
            <Card sx={{ 
              height: '100%',
              borderRadius: 3,
              boxShadow: '0 8px 25px rgba(0,0,0,0.1)',
              transition: 'all 0.3s ease',
              '&:hover': {
                transform: 'translateY(-5px)',
                boxShadow: '0 12px 35px rgba(0,0,0,0.15)'
              }
            }}>
              <CardContent sx={{ p: 3 }}>
                <Box display="flex" alignItems="center" justifyContent="space-between">
                  <Box>
                    <Typography 
                      color="textSecondary" 
                      gutterBottom 
                      variant="h6"
                      sx={{ 
                        fontWeight: 600,
                        fontSize: '1.1rem',
                        mb: 2
                      }}
                    >
                      {stat.label}
                    </Typography>
                    <Typography 
                      variant="h3" 
                      component="div"
                      sx={{ 
                        fontWeight: 700,
                        fontSize: '2.5rem',
                        color: stat.color
                      }}
                    >
                      {stat.value}
                    </Typography>
                  </Box>
                  <Box
                    sx={{
                      backgroundColor: stat.color,
                      borderRadius: '50%',
                      p: 2,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      boxShadow: `0 4px 12px ${stat.color}40`,
                      width: 60,
                      height: 60
                    }}
                  >
                    {React.cloneElement(stat.icon, { 
                      sx: { 
                        color: 'white',
                        fontSize: '2rem'
                      } 
                    })}
                  </Box>
                </Box>
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>

      {/* Services Overview - Only show for Super Admin */}
      {canAccessServerMonitoring(userRole) && (
        <>
          <Typography 
            variant="h5" 
            gutterBottom 
            sx={{ 
              mb: 3,
              fontWeight: 500,
              fontSize: '1.4rem',
              fontFamily: '"Roboto", "Helvetica", "Arial", sans-serif',
              color: '#2c3e50',
              letterSpacing: '0.3px',
              borderBottom: '1px solid #e0e0e0',
              paddingBottom: '8px',
              marginBottom: '20px'
            }}
          >
            {t('dashboard.servicesStatus')}
          </Typography>
          <Grid container spacing={3} sx={{ mb: 4 }}>
            {serviceCards.map((service, index) => (
              <Grid item xs={12} sm={6} md={4} key={index}>
                <Card sx={{ 
                  height: '100%', 
                  position: 'relative',
                  borderRadius: 3,
                  boxShadow: '0 6px 20px rgba(0,0,0,0.1)',
                  transition: 'all 0.3s ease',
                  '&:hover': {
                    transform: 'translateY(-3px)',
                    boxShadow: '0 10px 30px rgba(0,0,0,0.15)'
                  }
                }}>
                  <CardContent sx={{ p: 3 }}>
                    <Box display="flex" alignItems="center" justifyContent="space-between" mb={2}>
                      <Box display="flex" alignItems="center">
                        {service.icon}
                        <Typography 
                          variant="h6" 
                          sx={{ 
                            ml: 2,
                            fontWeight: 600,
                            fontSize: '1.2rem'
                          }}
                        >
                          {service.title}
                        </Typography>
                      </Box>
                      <Chip
                        icon={getStatusIcon(service.status)}
                        label={service.status}
                        color={getStatusColor(service.status) as any}
                        size="small"
                        sx={{ fontWeight: 600 }}
                      />
                    </Box>
                    <Typography 
                      color="textSecondary" 
                      gutterBottom
                      sx={{ 
                        fontSize: '1rem',
                        lineHeight: 1.5
                      }}
                    >
                      {service.description}
                    </Typography>
                    <Box display="flex" justifyContent="space-between" alignItems="center" mt={2}>
                      <Typography 
                        variant="body2" 
                        color="textSecondary"
                        sx={{ fontWeight: 500 }}
                      >
                        Port: {service.port}
                      </Typography>
                      <Box
                        sx={{
                          width: 12,
                          height: 12,
                          borderRadius: '50%',
                          backgroundColor: service.status === 'Running' ? '#4caf50' : '#f44336',
                        }}
                      />
                    </Box>
                  </CardContent>
                </Card>
              </Grid>
            ))}
          </Grid>
        </>
      )}

      {/* System Health and Recent Activities */}
      <Grid container spacing={3}>
        {/* System Health - Only show for Super Admin */}
        {canAccessServerMonitoring(userRole) && (
          <Grid item xs={12} md={6}>
            <Paper sx={{ 
              p: 3,
              borderRadius: 3,
              boxShadow: '0 6px 20px rgba(0,0,0,0.1)'
            }}>
              <Typography 
                variant="h5" 
                gutterBottom
                sx={{ 
                  fontWeight: 600,
                  color: '#ff6b35',
                  mb: 3
                }}
              >
                System Health
              </Typography>
              <Box sx={{ mb: 3 }}>
                <Box display="flex" justifyContent="space-between" mb={1}>
                  <Typography variant="body1" sx={{ fontWeight: 500 }}>CPU Usage</Typography>
                  <Typography variant="body1" sx={{ fontWeight: 600, color: '#ff6b35' }}>45%</Typography>
                </Box>
                <LinearProgress 
                  variant="determinate" 
                  value={45} 
                  sx={{ 
                    height: 10, 
                    borderRadius: 5,
                    backgroundColor: '#f0f0f0',
                    '& .MuiLinearProgress-bar': {
                      backgroundColor: '#ff6b35'
                    }
                  }} 
                />
              </Box>
              <Box sx={{ mb: 3 }}>
                <Box display="flex" justifyContent="space-between" mb={1}>
                  <Typography variant="body1" sx={{ fontWeight: 500 }}>Memory Usage</Typography>
                  <Typography variant="body1" sx={{ fontWeight: 600, color: '#ff6b35' }}>62%</Typography>
                </Box>
                <LinearProgress 
                  variant="determinate" 
                  value={62} 
                  sx={{ 
                    height: 10, 
                    borderRadius: 5,
                    backgroundColor: '#f0f0f0',
                    '& .MuiLinearProgress-bar': {
                      backgroundColor: '#ff6b35'
                    }
                  }} 
                />
              </Box>
              <Box sx={{ mb: 2 }}>
                <Box display="flex" justifyContent="space-between" mb={1}>
                  <Typography variant="body1" sx={{ fontWeight: 500 }}>Database Connections</Typography>
                  <Typography variant="body1" sx={{ fontWeight: 600, color: '#ff6b35' }}>8/20</Typography>
                </Box>
                <LinearProgress 
                  variant="determinate" 
                  value={40} 
                  sx={{ 
                    height: 10, 
                    borderRadius: 5,
                    backgroundColor: '#f0f0f0',
                    '& .MuiLinearProgress-bar': {
                      backgroundColor: '#ff6b35'
                    }
                  }} 
                />
              </Box>
            </Paper>
          </Grid>
        )}

        {/* Recent Activities */}
        <Grid item xs={12} md={canAccessServerMonitoring(userRole) ? 6 : 12}>
          <Paper sx={{ 
            p: 3,
            borderRadius: 3,
            boxShadow: '0 6px 20px rgba(0,0,0,0.1)'
          }}>
            <Typography 
              variant="h5" 
              gutterBottom
              sx={{ 
                fontWeight: 600,
                color: '#ff6b35',
                mb: 3
              }}
            >
              {userRole === 'PARENT' ? 'Recent Activities for My Children' : 
               userRole === 'TEACHER' ? 'Recent Activities in My Classes' : 
               'Recent Activities'}
            </Typography>
            <List dense>
              {recentActivities.map((activity, index) => (
                <ListItem key={index} sx={{ px: 0, mb: 1 }}>
                  <ListItemIcon sx={{ minWidth: 40 }}>
                    <TrendingUp fontSize="small" sx={{ color: '#ff6b35' }} />
                  </ListItemIcon>
                  <ListItemText
                    primary={activity.text}
                    secondary={activity.time}
                    primaryTypographyProps={{ 
                      variant: 'body1',
                      sx: { 
                        fontWeight: 500,
                        fontSize: '1rem'
                      }
                    }}
                    secondaryTypographyProps={{ 
                      variant: 'body2',
                      sx: { 
                        color: 'text.secondary',
                        fontSize: '0.9rem'
                      }
                    }}
                  />
                </ListItem>
              ))}
            </List>
          </Paper>
        </Grid>
      </Grid>
    </Container>
  );
};

export default Dashboard; 