import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { Child } from '../types';

// Password is stored client-side intentionally – this is a family app with no
// sensitive data. Do not store passwords like this in multi-tenant applications.
const PARENT_PASSWORD = 'JaiShriRam@01';

interface AuthState {
  isAuthenticated: boolean;
  selectedChild: Child | null;
  login: (password: string) => boolean;
  logout: () => void;
  selectChild: (child: Child) => void;
  clearChild: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      isAuthenticated: false,
      selectedChild: null,

      login: (password: string) => {
        if (password === PARENT_PASSWORD) {
          set({ isAuthenticated: true });
          return true;
        }
        return false;
      },

      logout: () => set({ isAuthenticated: false, selectedChild: null }),

      selectChild: (child: Child) => set({ selectedChild: child }),

      clearChild: () => set({ selectedChild: null }),
    }),
    {
      name: 'ts-auth',
      partialize: (state) => ({
        isAuthenticated: state.isAuthenticated,
        selectedChild: state.selectedChild,
      }),
    },
  ),
);
