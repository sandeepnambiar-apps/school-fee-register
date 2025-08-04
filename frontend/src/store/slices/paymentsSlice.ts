import { createSlice, PayloadAction } from '@reduxjs/toolkit';

interface Payment {
  id: number;
  studentId: number;
  feeStructureId: number;
  amount: number;
  paymentMethod: 'CASH' | 'CARD' | 'ONLINE' | 'BANK_TRANSFER' | 'CHEQUE';
  status: 'PENDING' | 'COMPLETED' | 'FAILED' | 'CANCELLED' | 'REFUNDED';
  transactionId: string;
  receiptNumber: string;
  paymentDate: string;
  dueDate: string;
  discountAmount: number;
  lateFeeAmount: number;
  notes: string;
}

interface PaymentsState {
  payments: Payment[];
  loading: boolean;
  error: string | null;
}

const initialState: PaymentsState = {
  payments: [],
  loading: false,
  error: null,
};

const paymentsSlice = createSlice({
  name: 'payments',
  initialState,
  reducers: {
    setLoading: (state, action: PayloadAction<boolean>) => {
      state.loading = action.payload;
    },
    setPayments: (state, action: PayloadAction<Payment[]>) => {
      state.payments = action.payload;
      state.loading = false;
      state.error = null;
    },
    setError: (state, action: PayloadAction<string>) => {
      state.error = action.payload;
      state.loading = false;
    },
    addPayment: (state, action: PayloadAction<Payment>) => {
      state.payments.push(action.payload);
    },
    updatePayment: (state, action: PayloadAction<Payment>) => {
      const index = state.payments.findIndex(p => p.id === action.payload.id);
      if (index !== -1) {
        state.payments[index] = action.payload;
      }
    },
    deletePayment: (state, action: PayloadAction<number>) => {
      state.payments = state.payments.filter(p => p.id !== action.payload);
    },
  },
});

export const { setLoading, setPayments, setError, addPayment, updatePayment, deletePayment } = paymentsSlice.actions;
export default paymentsSlice.reducer; 