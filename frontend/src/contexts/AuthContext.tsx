import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { authAPI } from '../services/api';

interface User {
  id: number;
  username: string;
  email: string;
  fullName: string;
  role?: string;
  roles?: string[];
  userType: string;
}

interface AuthContextType {
  user: User | null;
  loading: boolean;
  error: string | null;
  login: (credentials: { username?: string; mobile?: string; password: string }) => Promise<{ success: boolean; error?: string }>;
  logout: () => Promise<void>;
  refreshToken: () => Promise<boolean>;
  changePassword: (passwordData: { currentPassword: string; newPassword: string }) => Promise<{ success: boolean; error?: string }>;
  isAuthenticated: () => boolean;
  hasRole: (role: string) => boolean;
  hasAnyRole: (roles: string[]) => boolean;
  clearError: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useAuth = (): AuthContextType => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

interface AuthProviderProps {
  children: ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    checkAuthStatus();
  }, []);

  const checkAuthStatus = async () => {
    try {
      const token = localStorage.getItem('authToken');
      if (token) {
        const userData = await authAPI.getCurrentUser();
        setUser(userData);
      }
    } catch (err) {
      console.error('Auth check failed:', err);
      localStorage.removeItem('authToken');
    } finally {
      setLoading(false);
    }
  };

  const login = async (credentials: { username?: string; mobile?: string; password: string }) => {
    try {
      setLoading(true);
      setError(null);
      
      const response = await authAPI.login(credentials);
      console.log('Login response:', response); // Debug log
      
      // Check for different possible response formats
      const token = response.token || response.accessToken || response.access_token;
      const userData = response.user || response.userData || response;
      
      if (token) {
        localStorage.setItem('authToken', token);
        console.log('Token stored:', token); // Debug log
        
        // If user data is included in response, use it
        if (userData && userData.id) {
          setUser(userData);
          return { success: true };
        } else {
          // If no user data in response, fetch it
          try {
            const currentUser = await authAPI.getCurrentUser();
            setUser(currentUser);
            return { success: true };
          } catch (userErr) {
            console.error('Failed to get current user:', userErr);
            // Still return success if we have a token
            return { success: true };
          }
        }
      } else {
        throw new Error('Login failed - no token received');
      }
    } catch (err: any) {
      console.error('Login error:', err);
      setError(err.message || 'Login failed');
      return { success: false, error: err.message };
    } finally {
      setLoading(false);
    }
  };

  const logout = async () => {
    try {
      await authAPI.logout();
    } catch (err) {
      console.error('Logout error:', err);
    } finally {
      localStorage.removeItem('authToken');
      setUser(null);
      setError(null);
    }
  };

  const refreshToken = async (): Promise<boolean> => {
    try {
      const response = await authAPI.refreshToken();
      if (response.token) {
        localStorage.setItem('authToken', response.token);
        return true;
      }
      return false;
    } catch (err) {
      console.error('Token refresh failed:', err);
      logout();
      return false;
    }
  };

  const changePassword = async (passwordData: { currentPassword: string; newPassword: string }) => {
    try {
      setError(null);
      await authAPI.changePassword(passwordData);
      return { success: true };
    } catch (err: any) {
      setError(err.message || 'Password change failed');
      return { success: false, error: err.message };
    }
  };

  const isAuthenticated = () => {
    return !!user && !!localStorage.getItem('authToken');
  };

  const hasRole = (role: string): boolean => {
    return !!(user && (user.role === role || (user.roles && user.roles.includes(role))));
  };

  const hasAnyRole = (roles: string[]): boolean => {
    return !!(user && (user.role && roles.includes(user.role) || (user.roles && roles.some(role => user.roles!.includes(role)))));
  };

  const value: AuthContextType = {
    user,
    loading,
    error,
    login,
    logout,
    refreshToken,
    changePassword,
    isAuthenticated,
    hasRole,
    hasAnyRole,
    clearError: () => setError(null)
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
}; 