import { configureStore } from '@reduxjs/toolkit';
import studentsReducer from './slices/studentsSlice';
import feesReducer from './slices/feesSlice';
import paymentsReducer from './slices/paymentsSlice';
import notificationsReducer from './slices/notificationsSlice';

export const store = configureStore({
  reducer: {
    students: studentsReducer,
    fees: feesReducer,
    payments: paymentsReducer,
    notifications: notificationsReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch; 