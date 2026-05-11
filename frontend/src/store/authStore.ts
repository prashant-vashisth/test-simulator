import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { Session } from '@supabase/supabase-js';
import type { Child } from '../types';
import { supabase } from '../lib/supabase';
import api from '../services/api';

const PARENT_PASSWORD = 'JaiShriRam@01';
const PENDING_PROFILE_KEY = 'ts-pending-profile';

interface PendingProfile {
  name: string;
  grade_id: string;
  user_id: string;
  email: string;
}

async function createProfile(payload: PendingProfile, token?: string) {
  await api.post('/api/v1/auth/create-profile', payload, {
    headers: token ? { Authorization: `Bearer ${token}` } : {},
  });
  localStorage.removeItem(PENDING_PROFILE_KEY);
}

interface AuthState {
  isAuthenticated: boolean;
  selectedChild: Child | null;
  login: (password: string) => boolean;
  logout: () => void;
  selectChild: (child: Child) => void;
  clearChild: () => void;

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
      isAuthenticated: false,
      selectedChild: null,

      login: (password: string) => {
        if (password === PARENT_PASSWORD) { set({ isAuthenticated: true }); return true; }
        return false;
      },
      logout: () => set({ isAuthenticated: false, selectedChild: null }),
      selectChild: (child: Child) => set({ selectedChild: child }),
      clearChild: () => set({ selectedChild: null }),

      childSession: null,
      childProfile: null,

      registerChild: async ({ name, email, password, gradeId }) => {
        // Step 1: Create the Supabase auth account — this is the only hard requirement.
        const { data, error } = await supabase.auth.signUp({ email, password });
        if (error) throw error;

        const userId = data.user?.id;
        if (!userId) throw new Error('Registration failed — no user ID returned.');

        const payload: PendingProfile = { name, grade_id: gradeId, user_id: userId, email };

        // Step 2: Try to create the DB profile. If the backend is unreachable (sleeping,
        // CORS, wrong URL) we save the payload locally and retry on first login.
        try {
          await createProfile(payload, data.session?.access_token);
        } catch {
          localStorage.setItem(PENDING_PROFILE_KEY, JSON.stringify(payload));
          // Don't throw — Supabase account exists, email verification can proceed.
        }

        if (data.session) set({ childSession: data.session });
      },

      loginChild: async (email: string, password: string) => {
        const { data, error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw error;
        set({ childSession: data.session });

        const token = data.session?.access_token;

        // Retry profile creation if it was deferred during registration.
        const stored = localStorage.getItem(PENDING_PROFILE_KEY);
        if (stored) {
          try {
            const pending: PendingProfile = JSON.parse(stored);
            if (pending.user_id === data.user?.id) {
              await createProfile(pending, token);
            }
          } catch { /* will retry next login */ }
        }

        try {
          const res = await api.get<Child>('/api/v1/auth/me', {
            headers: token ? { Authorization: `Bearer ${token}` } : {},
          });
          set({ childProfile: res.data });
        } catch (err: unknown) {
          const status = (err as { response?: { status?: number } })?.response?.status;
          if (status === 404) {
            throw new Error(
              'Your account was created but your profile is still being set up. ' +
              'Please try signing in again in a few seconds.'
            );
          }
          throw err;
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
