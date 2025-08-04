// API Base URL - change this based on your environment
// In development, use relative URLs since proxy is configured
const API_BASE_URL = process.env.REACT_APP_API_BASE_URL || '';
const AUTH_API_BASE_URL = process.env.REACT_APP_AUTH_API_BASE_URL || 'http://localhost:8082';

// Common headers
const getHeaders = (requireAuth = true) => {
  const token = localStorage.getItem('authToken');
  return {
    'Content-Type': 'application/json',
    ...(requireAuth && token && { 'Authorization': `Bearer ${token}` })
  };
};

// Generic API methods
const api = {
  get: async (endpoint, requireAuth = true) => {
    try {
      const response = await fetch(`${API_BASE_URL}${endpoint}`, {
        method: 'GET',
        headers: getHeaders(requireAuth),
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      return await response.json();
    } catch (error) {
      console.error('API GET Error:', error);
      throw error;
    }
  },

  post: async (endpoint, data, requireAuth = true) => {
    try {
      const response = await fetch(`${API_BASE_URL}${endpoint}`, {
        method: 'POST',
        headers: getHeaders(requireAuth),
        body: JSON.stringify(data),
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      // Check if response has content before trying to parse JSON
      const contentType = response.headers.get('content-type');
      if (contentType && contentType.includes('application/json')) {
        return await response.json();
      } else {
        // For responses without JSON content (like 201 Created with no body)
        return { success: true, status: response.status };
      }
    } catch (error) {
      console.error('API POST Error:', error);
      throw error;
    }
  },

  put: async (endpoint, data, requireAuth = true) => {
    try {
      const response = await fetch(`${API_BASE_URL}${endpoint}`, {
        method: 'PUT',
        headers: getHeaders(requireAuth),
        body: JSON.stringify(data),
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      return await response.json();
    } catch (error) {
      console.error('API PUT Error:', error);
      throw error;
    }
  },

  delete: async (endpoint, requireAuth = true) => {
    try {
      const response = await fetch(`${API_BASE_URL}${endpoint}`, {
        method: 'DELETE',
        headers: getHeaders(requireAuth),
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      return await response.json();
    } catch (error) {
      console.error('API DELETE Error:', error);
      throw error;
    }
  }
};

// Student API
export const studentAPI = {
  getProfile: (studentId) => api.get(`/api/students/${studentId}/profile`),
  updateProfile: (studentId, data) => api.put(`/api/students/${studentId}/profile`, data),
  getAllStudents: () => api.get('/api/students'),
  getStudentsByClass: (classId) => api.get(`/api/students/class/${classId}`),
  createStudent: (data) => api.post('/api/students', data),
  deleteStudent: (studentId) => api.delete(`/api/students/${studentId}`)
};

// Fee API
export const feeAPI = {
  // Fee Structure Management
  getFeeStructures: () => api.get('/api/fees/structures', false),
  getFeeStructureById: (id) => api.get(`/api/fees/structures/${id}`, false),
  getFeeStructuresByClass: (classId) => api.get(`/api/fees/structures/class/${classId}`, false),
  getActiveFeeStructures: () => api.get('/api/fees/structures/active', false),
  createFeeStructure: (data) => api.post('/api/fees/structures', data, false),
  updateFeeStructure: (id, data) => api.put(`/api/fees/structures/${id}`, data, false),
  deleteFeeStructure: (id) => api.delete(`/api/fees/structures/${id}`, false),
  
  // Student Fee Management
  getStudentFees: (studentId) => api.get(`/api/fees/student-fees/student/${studentId}`),
  getStudentFeeById: (id) => api.get(`/api/fees/student-fees/${id}`),
  createStudentFee: (data) => api.post('/api/fees/student-fees', data),
  updateStudentFee: (id, data) => api.put(`/api/fees/student-fees/${id}`, data),
  deleteStudentFee: (id) => api.delete(`/api/fees/student-fees/${id}`),
  
  // Payment Management
  recordPayment: (data) => api.post('/api/fees/payments', data),
  getPaymentHistory: (studentId) => api.get(`/api/fees/payments/student/${studentId}`),
  generateReceipt: (paymentId) => api.get(`/api/fees/receipts/${paymentId}`),
  getFeeReports: (filters) => api.post('/api/fees/reports', filters),
  
  // Business Logic
  assignFeesToStudent: (studentId, classId, academicYearId) => 
    api.post(`/api/fees/assign/${studentId}/class/${classId}/year/${academicYearId}`),
  updateOverdueStatus: () => api.post('/api/fees/update-overdue'),
  applyDiscount: (id, discountAmount) => 
    api.patch(`/api/fees/student-fees/${id}/apply-discount?discountAmount=${discountAmount}`),
  markAsPaid: (id) => api.patch(`/api/fees/student-fees/${id}/mark-paid`),
  markAsPartial: (id) => api.patch(`/api/fees/student-fees/${id}/mark-partial`)
};

// Transport Fee API
export const transportFeeAPI = {
  getRoutes: () => api.get('/api/transport/routes'),
  getTransportFees: () => api.get('/api/transport/fees'),
  getStudentTransportFees: (studentId) => api.get(`/api/transport/fees/student/${studentId}`),
  createTransportFee: (data) => api.post('/api/transport/fees', data),
  updateTransportFee: (feeId, data) => api.put(`/api/transport/fees/${feeId}`, data),
  deleteTransportFee: (feeId) => api.delete(`/api/transport/fees/${feeId}`)
};

// Notification API
export const notificationAPI = {
  getNotifications: (filters = {}) => api.post('/api/notifications/search', filters),
  getNotificationsByUser: (userId) => api.get(`/api/notifications/user/${userId}`),
  sendNotification: (data) => api.post('/api/notifications', data),
  markAsRead: (notificationId) => api.put(`/api/notifications/${notificationId}/read`),
  deleteNotification: (notificationId) => api.delete(`/api/notifications/${notificationId}`),
  getUnreadCount: (userId) => api.get(`/api/notifications/unread-count/${userId}`)
};

// Homework API
export const homeworkAPI = {
  getHomework: (filters = {}) => api.post('/api/homework/search', filters),
  getHomeworkByClass: (classId) => api.get(`/api/homework/class/${classId}`),
  getHomeworkBySubject: (subjectId) => api.get(`/api/homework/subject/${subjectId}`),
  createHomework: (data) => api.post('/api/homework', data),
  updateHomework: (homeworkId, data) => api.put(`/api/homework/${homeworkId}`, data),
  deleteHomework: (homeworkId) => api.delete(`/api/homework/${homeworkId}`),
  submitHomework: (homeworkId, data) => api.post(`/api/homework/${homeworkId}/submit`, data)
};

// Payment API
export const paymentAPI = {
  getPayments: (filters = {}) => api.post('/api/payments/search', filters),
  getPaymentById: (paymentId) => api.get(`/api/payments/${paymentId}`),
  createPayment: (data) => api.post('/api/payments', data),
  updatePayment: (paymentId, data) => api.put(`/api/payments/${paymentId}`, data),
  deletePayment: (paymentId) => api.delete(`/api/payments/${paymentId}`),
  getPaymentMethods: () => api.get('/api/payments/methods')
};

// Auth API - using separate auth service URL
export const authAPI = {
  login: (credentials) => {
    return fetch(`${AUTH_API_BASE_URL}/api/v1/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(credentials),
    }).then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    });
  },
  logout: (token) => {
    return fetch(`${AUTH_API_BASE_URL}/api/v1/auth/logout`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
    }).then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    });
  },
  refreshToken: (refreshToken) => {
    return fetch(`${AUTH_API_BASE_URL}/api/v1/auth/refresh`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ refreshToken }),
    }).then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    });
  },
  getCurrentUser: () => {
    const token = localStorage.getItem('authToken');
    if (!token) {
      throw new Error('No authentication token found');
    }
    return fetch(`${AUTH_API_BASE_URL}/api/v1/auth/profile`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
    }).then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    });
  },
  changePassword: (data) => {
    const token = localStorage.getItem('authToken');
    return fetch(`${AUTH_API_BASE_URL}/api/v1/auth/password`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify(data),
    }).then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    });
  }
};

// Reporting API
export const reportingAPI = {
  getFeeReports: (filters) => api.post('/api/reports/fees', filters),
  getStudentReports: (studentId) => api.get(`/api/reports/students/${studentId}`),
  getClassReports: (classId) => api.get(`/api/reports/classes/${classId}`),
  getPaymentReports: (filters) => api.post('/api/reports/payments', filters),
  exportReport: (reportType, filters) => api.post(`/api/reports/export/${reportType}`, filters)
};

export default api; 