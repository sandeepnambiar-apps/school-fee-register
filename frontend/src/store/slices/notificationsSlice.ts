import { createSlice, PayloadAction } from '@reduxjs/toolkit';

interface Notification {
  id: number;
  type: 'email' | 'sms';
  recipient: string;
  subject: string;
  message: string;
  status: 'pending' | 'sent' | 'failed';
  sentAt: string;
}

interface NotificationsState {
  notifications: Notification[];
  loading: boolean;
  error: string | null;
}

const initialState: NotificationsState = {
  notifications: [],
  loading: false,
  error: null,
};

const notificationsSlice = createSlice({
  name: 'notifications',
  initialState,
  reducers: {
    setLoading: (state, action: PayloadAction<boolean>) => {
      state.loading = action.payload;
    },
    setNotifications: (state, action: PayloadAction<Notification[]>) => {
      state.notifications = action.payload;
      state.loading = false;
      state.error = null;
    },
    setError: (state, action: PayloadAction<string>) => {
      state.error = action.payload;
      state.loading = false;
    },
    addNotification: (state, action: PayloadAction<Notification>) => {
      state.notifications.push(action.payload);
    },
    updateNotification: (state, action: PayloadAction<Notification>) => {
      const index = state.notifications.findIndex(n => n.id === action.payload.id);
      if (index !== -1) {
        state.notifications[index] = action.payload;
      }
    },
    deleteNotification: (state, action: PayloadAction<number>) => {
      state.notifications = state.notifications.filter(n => n.id !== action.payload);
    },
  },
});

export const { setLoading, setNotifications, setError, addNotification, updateNotification, deleteNotification } = notificationsSlice.actions;
export default notificationsSlice.reducer; 