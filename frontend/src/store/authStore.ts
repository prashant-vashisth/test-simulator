import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { Session } from '@supabase/supabase-js';
import type { Child } from '../types';
import { supabase } from '../lib/supabase';
import api from '../services/api';

// Parent password stored client-side — family app with no sensitive data.
const PARENT_PASSWORD = 'JaiShriRam@01';

interface AuthState {
  // ── Parent flow (existing) ───────────────────────────────────────────────
  isAuthenticated: boolean;
  selectedChild: Child | null;
  login: (password: string) => boolean;
  logout: () => void;
  selectChild: (child: Child) => void;
  clearChild: () => void;

  // ── Child self-auth flow (new) ────────────────────────────────────────────
  childSession: Session | null;
  childProfile: Child | null;
  loginChild: (email: string, password: string) => Promise<void>;
  registerChild: (opts: { name: string; email: string; password: string; gradeId: string }) => Promise<void>;
  logoutChild: () => Promise<void>;
  setChildSession: (session: Session | null) => void;
  setChildProfile: (profile: Child | null) => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      // ── Parent ─────────────────────────────────────────────────────────────
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

      // ── Child auth ─────────────────────────────────────────────────────────
      childSession: null,
      childProfile: null,

      loginChild: async (email: string, password: string) => {
        const { data, error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw error;
        set({ childSession: data.session });

        const profileRes = await api.get<Child>('/api/v1/auth/me', {
          headers: { Authorization: `Bearer ${data.session?.access_token}` },
        });
        set({ childProfile: profileRes.data });
      },

      registerChild: async ({ name, email, password, gradeId }) => {
        const { data, error } = await supabase.auth.signUp({ email, password });
        if (error) throw error;

        const userId = data.user?.id;
        if (!userId) throw new Error('Registration failed — no user ID returned');

        // Create the children DB record immediately (idempotent)
        await api.post('/api/v1/auth/create-profile', {
          name,
          grade_id: gradeId,
          user_id: userId,
          email,
        });

        // Store session if Supabase returned one (depends on email confirm settings)
        if (data.session) {
          set({ childSession: data.session });
        }
      },

      logoutChild: async () => {
        await supabase.auth.signOut();
        set({ childSession: null, childProfile: null });
      },

      setChildSession: (session) => set({ childSession: session }),
      setChildProfile: (profile) => set({ childProfile: profile }),
    }),
    {
      name: 'ts-auth',
      partialize: (state) => ({
        isAuthenticated: state.isAuthenticated,
        selectedChild: state.selectedChild,
        childSession: state.childSession,
        childProfile: state.childProfile,
      }),
    },
  ),
);
