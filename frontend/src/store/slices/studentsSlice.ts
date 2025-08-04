import { createSlice, PayloadAction } from '@reduxjs/toolkit';

interface Student {
  id: number;
  name: string;
  email: string;
  phone: string;
  class: string;
  section: string;
  admissionDate: string;
  status: 'active' | 'inactive';
}

interface StudentsState {
  students: Student[];
  loading: boolean;
  error: string | null;
}

const initialState: StudentsState = {
  students: [],
  loading: false,
  error: null,
};

const studentsSlice = createSlice({
  name: 'students',
  initialState,
  reducers: {
    setLoading: (state, action: PayloadAction<boolean>) => {
      state.loading = action.payload;
    },
    setStudents: (state, action: PayloadAction<Student[]>) => {
      state.students = action.payload;
      state.loading = false;
      state.error = null;
    },
    setError: (state, action: PayloadAction<string>) => {
      state.error = action.payload;
      state.loading = false;
    },
    addStudent: (state, action: PayloadAction<Student>) => {
      state.students.push(action.payload);
    },
    updateStudent: (state, action: PayloadAction<Student>) => {
      const index = state.students.findIndex(s => s.id === action.payload.id);
      if (index !== -1) {
        state.students[index] = action.payload;
      }
    },
    deleteStudent: (state, action: PayloadAction<number>) => {
      state.students = state.students.filter(s => s.id !== action.payload);
    },
  },
});

export const { setLoading, setStudents, setError, addStudent, updateStudent, deleteStudent } = studentsSlice.actions;
export default studentsSlice.reducer;
 