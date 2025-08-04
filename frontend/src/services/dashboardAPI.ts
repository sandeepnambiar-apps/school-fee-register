import { authAPI } from './api';

export interface DashboardStats {
  totalStudents?: number;
  totalFeesCollected?: number;
  pendingPayments?: number;
  activeFeeStructures?: number;
  myChildren?: number;
  totalFeesPaid?: number;
  recentNotifications?: number;
  myStudents?: number;
  activeHomework?: number;
  pendingAssignments?: number;
}

export interface RecentActivity {
  id: string;
  text: string;
  time: string;
  type: 'payment' | 'registration' | 'notification' | 'homework' | 'attendance';
}

export interface DashboardData {
  stats: DashboardStats;
  recentActivities: RecentActivity[];
}

class DashboardAPI {
  private baseURL = '/api';

  async getDashboardData(userRole: string): Promise<DashboardData> {
    try {
      const token = localStorage.getItem('authToken');
      if (!token) {
        throw new Error('No authentication token');
      }

      const headers = {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      };

      // Fetch dashboard data based on user role
      let endpoint = '';
      if (userRole === 'PARENT') {
        endpoint = '/dashboard/parent';
      } else if (userRole === 'TEACHER') {
        endpoint = '/dashboard/teacher';
      } else {
        endpoint = '/dashboard/admin';
      }

      // Add timeout to prevent hanging requests
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 8000);

      try {
        const response = await fetch(`${this.baseURL}${endpoint}`, {
          method: 'GET',
          headers,
          signal: controller.signal
        });

        clearTimeout(timeoutId);

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        return data;
      } catch (fetchError) {
        clearTimeout(timeoutId);
        throw fetchError;
      }
    } catch (error) {
      console.error('Error fetching dashboard data:', error);
      // Return fallback data if API fails
      return this.getFallbackData(userRole);
    }
  }

  getFallbackData(userRole: string): DashboardData {
    if (userRole === 'PARENT') {
      return {
        stats: {
          myChildren: 2,
          totalFeesPaid: 2500,
          pendingPayments: 1,
          recentNotifications: 3
        },
        recentActivities: [
          { id: '1', text: 'New homework assigned: Mathematics Chapter 5', time: '2 hours ago', type: 'homework' },
          { id: '2', text: 'Fee payment received: $500 for March 2024', time: '1 day ago', type: 'payment' },
          { id: '3', text: 'Attendance updated: 95% this month', time: '2 days ago', type: 'attendance' },
          { id: '4', text: 'New notification: Parent-Teacher meeting scheduled', time: '3 days ago', type: 'notification' }
        ]
      };
    } else if (userRole === 'TEACHER') {
      return {
        stats: {
          myStudents: 45,
          activeHomework: 8,
          pendingAssignments: 12,
          recentNotifications: 5
        },
        recentActivities: [
          { id: '1', text: 'Homework submitted by: John Doe', time: '30 minutes ago', type: 'homework' },
          { id: '2', text: 'New student assigned to your class', time: '2 hours ago', type: 'registration' },
          { id: '3', text: 'Attendance marked for Class 10A', time: '1 day ago', type: 'attendance' },
          { id: '4', text: 'Fee reminder sent to 5 parents', time: '2 days ago', type: 'notification' }
        ]
      };
    } else {
      // Admin/Default stats
      return {
        stats: {
          totalStudents: 1234,
          totalFeesCollected: 45678,
          pendingPayments: 23,
          activeFeeStructures: 12
        },
        recentActivities: [
          { id: '1', text: 'New student registration: John Doe', time: '2 minutes ago', type: 'registration' },
          { id: '2', text: 'Payment received: $500 from Student ID 123', time: '5 minutes ago', type: 'payment' },
          { id: '3', text: 'Fee structure updated for Class 10', time: '10 minutes ago', type: 'notification' },
          { id: '4', text: 'Email notification sent to parent', time: '15 minutes ago', type: 'notification' }
        ]
      };
    }
  }

  // Fetch real-time statistics
  async getRealTimeStats(): Promise<any> {
    try {
      const response = await fetch(`${this.baseURL}/dashboard/stats`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json'
        }
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      return await response.json();
    } catch (error) {
      console.error('Error fetching real-time stats:', error);
      return null;
    }
  }
}

export const dashboardAPI = new DashboardAPI(); 