import { createSlice, PayloadAction } from '@reduxjs/toolkit';

interface FeeStructure {
  id: number;
  name: string;
  class: string;
  amount: number;
  frequency: 'monthly' | 'quarterly' | 'annually';
  dueDate: string;
  status: 'active' | 'inactive';
}

interface FeesState {
  feeStructures: FeeStructure[];
  loading: boolean;
  error: string | null;
}

const initialState: FeesState = {
  feeStructures: [],
  loading: false,
  error: null,
};

const feesSlice = createSlice({
  name: 'fees',
  initialState,
  reducers: {
    setLoading: (state, action: PayloadAction<boolean>) => {
      state.loading = action.payload;
    },
    setFeeStructures: (state, action: PayloadAction<FeeStructure[]>) => {
      state.feeStructures = action.payload;
      state.loading = false;
      state.error = null;
    },
    setError: (state, action: PayloadAction<string>) => {
      state.error = action.payload;
      state.loading = false;
    },
    addFeeStructure: (state, action: PayloadAction<FeeStructure>) => {
      state.feeStructures.push(action.payload);
    },
    updateFeeStructure: (state, action: PayloadAction<FeeStructure>) => {
      const index = state.feeStructures.findIndex(f => f.id === action.payload.id);
      if (index !== -1) {
        state.feeStructures[index] = action.payload;
      }
    },
    deleteFeeStructure: (state, action: PayloadAction<number>) => {
      state.feeStructures = state.feeStructures.filter(f => f.id !== action.payload);
    },
  },
});

export const { setLoading, setFeeStructures, setError, addFeeStructure, updateFeeStructure, deleteFeeStructure } = feesSlice.actions;
export default feesSlice.reducer; 