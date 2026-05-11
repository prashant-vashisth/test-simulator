import api from './api';
import type { Child } from '../types';

export interface AdminStats {
  total_users: number;
  active_users: number;
  disabled_users: number;
  trial_users: number;
  standard_users: number;
  total_sessions: number;
  completed_sessions: number;
}

export const adminService = {
  getStats: () =>
    api.get<AdminStats>('/api/v1/admin/stats').then(r => r.data),

  listUsers: (params?: { is_active?: boolean; account_type?: string }) =>
    api.get<Child[]>('/api/v1/admin/users', { params }).then(r => r.data),

  setStatus: (userId: string, is_active: boolean) =>
    api.patch<Child>(`/api/v1/admin/users/${userId}/status`, { is_active }).then(r => r.data),

  setAccountType: (userId: string, account_type: string, trial_expires_at?: string | null) =>
    api.patch<Child>(`/api/v1/admin/users/${userId}/account-type`, { account_type, trial_expires_at }).then(r => r.data),

  deleteUser: (userId: string) =>
    api.delete(`/api/v1/admin/users/${userId}`),
};
