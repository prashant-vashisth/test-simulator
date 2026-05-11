import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useAuthStore } from '../store/authStore';
import { adminService } from '../services/adminService';
import type { Child } from '../types';

function StatCard({ label, value, sub, color = 'text-slate-900' }: { label: string; value: number; sub?: string; color?: string }) {
  return (
    <div className="bg-white border border-slate-200 rounded-xl p-5 shadow-card">
      <div className={`text-3xl font-extrabold tracking-tight ${color}`}>{value.toLocaleString()}</div>
      <div className="text-sm font-semibold text-slate-700 mt-1">{label}</div>
      {sub && <div className="text-xs text-slate-400 mt-0.5">{sub}</div>}
    </div>
  );
}

function AccountTypeBadge({ type }: { type?: string }) {
  return type === 'standard'
    ? <span className="inline-flex px-2 py-0.5 rounded text-xs font-semibold bg-brand-50 text-brand-700 border border-brand-100">Standard</span>
    : <span className="inline-flex px-2 py-0.5 rounded text-xs font-semibold bg-amber-50 text-amber-700 border border-amber-100">Trial</span>;
}

function StatusBadge({ active, deletedAt }: { active?: boolean; deletedAt?: string | null }) {
  if (deletedAt) {
    return <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs font-semibold bg-rose-50 text-rose-600 border border-rose-100"><span className="w-1.5 h-1.5 rounded-full bg-rose-400" />Deactivated</span>;
  }
  return active !== false
    ? <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-100"><span className="w-1.5 h-1.5 rounded-full bg-emerald-500" />Active</span>
    : <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs font-semibold bg-slate-100 text-slate-500 border border-slate-200"><span className="w-1.5 h-1.5 rounded-full bg-slate-400" />Disabled</span>;
}

function ConfirmModal({ message, onConfirm, onCancel }: { message: string; onConfirm: () => void; onCancel: () => void }) {
  return (
    <div className="fixed inset-0 bg-black/40 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-card-lg p-6 max-w-sm w-full">
        <div className="w-10 h-10 rounded-full bg-rose-100 flex items-center justify-center mb-4">
          <svg className="w-5 h-5 text-rose-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
          </svg>
        </div>
        <p className="text-sm text-slate-700 leading-relaxed mb-5">{message}</p>
        <div className="flex gap-3">
          <button onClick={onCancel} className="flex-1 py-2 rounded-lg border border-slate-200 text-sm font-semibold text-slate-600 hover:bg-slate-50 transition-colors">Cancel</button>
          <button onClick={onConfirm} className="flex-1 py-2 rounded-lg bg-rose-600 hover:bg-rose-700 text-white text-sm font-semibold transition-colors">Confirm</button>
        </div>
      </div>
    </div>
  );
}

export function AdminPage() {
  const navigate = useNavigate();
  const qc = useQueryClient();
  const { childProfile } = useAuthStore();

  const [search, setSearch] = useState('');
  const [filterStatus, setFilterStatus] = useState<'all' | 'active' | 'disabled'>('all');
  const [filterType, setFilterType] = useState<'all' | 'trial' | 'standard'>('all');
  const [confirm, setConfirm] = useState<{ message: string; onConfirm: () => void } | null>(null);

  // Redirect non-admins
  if (childProfile && childProfile.role !== 'admin') {
    navigate('/dashboard');
    return null;
  }

  const { data: stats } = useQuery({
    queryKey: ['admin-stats'],
    queryFn: adminService.getStats,
    staleTime: 30_000,
  });

  const { data: users = [], isLoading } = useQuery({
    queryKey: ['admin-users'],
    queryFn: () => adminService.listUsers(),
    staleTime: 30_000,
  });

  const toggleStatus = useMutation({
    mutationFn: ({ id, active }: { id: string; active: boolean }) =>
      adminService.setStatus(id, active),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['admin-users', 'admin-stats'] }),
  });

  const setType = useMutation({
    mutationFn: ({ id, type }: { id: string; type: string }) =>
      adminService.setAccountType(id, type, type === 'standard' ? null : undefined),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['admin-users', 'admin-stats'] }),
  });

  const deleteUser = useMutation({
    mutationFn: (id: string) => adminService.deleteUser(id),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['admin-users', 'admin-stats'] }),
  });

  const filtered = users.filter((u: Child) => {
    if (filterStatus === 'active' && u.is_active === false) return false;
    if (filterStatus === 'disabled' && u.is_active !== false) return false;
    if (filterType !== 'all' && u.account_type !== filterType) return false;
    if (search && !u.name.toLowerCase().includes(search.toLowerCase()) && !u.email?.toLowerCase().includes(search.toLowerCase())) return false;
    return true;
  });

  const handleToggle = (user: Child) => {
    const newState = user.is_active === false;
    setConfirm({
      message: `${newState ? 'Enable' : 'Disable'} account for ${user.name}? ${!newState ? 'They will not be able to log in.' : ''}`,
      onConfirm: () => { toggleStatus.mutate({ id: user.id, active: newState }); setConfirm(null); },
    });
  };

  const handleDelete = (user: Child) => {
    setConfirm({
      message: `Permanently delete ${user.name}'s account? This removes all their sessions and data and cannot be undone.`,
      onConfirm: () => { deleteUser.mutate(user.id); setConfirm(null); },
    });
  };

  return (
    <div className="min-h-screen bg-slate-50">
      {confirm && <ConfirmModal {...confirm} onCancel={() => setConfirm(null)} />}

      {/* Header */}
      <header className="bg-white border-b border-slate-100 sticky top-0 z-20">
        <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <Link to="/dashboard" className="flex items-center gap-2">
              <div className="w-7 h-7 rounded bg-brand-600 flex items-center justify-center text-white font-black text-xs">A</div>
              <span className="font-bold text-slate-900">AcademIQ</span>
            </Link>
            <span className="text-slate-300">|</span>
            <span className="text-sm font-semibold text-slate-600">Admin Console</span>
          </div>
          <div className="flex items-center gap-3">
            <span className="text-xs text-slate-400">{childProfile?.name}</span>
            <span className="inline-flex px-2 py-0.5 rounded text-xs font-bold bg-brand-600 text-white">ADMIN</span>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-6 py-8 space-y-8">

        {/* Stats */}
        {stats && (
          <div className="grid grid-cols-2 sm:grid-cols-4 lg:grid-cols-7 gap-4">
            <StatCard label="Total Accounts" value={stats.total_users} sub="registered students" />
            <StatCard label="Active" value={stats.active_users} color="text-emerald-600" />
            <StatCard label="Disabled" value={stats.disabled_users} color="text-slate-400" />
            <StatCard label="Trial" value={stats.trial_users} color="text-amber-600" />
            <StatCard label="Standard" value={stats.standard_users} color="text-brand-600" />
            <StatCard label="Total Sessions" value={stats.total_sessions} />
            <StatCard label="Completed" value={stats.completed_sessions} color="text-emerald-600" />
          </div>
        )}

        {/* User management */}
        <section>
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-4">
            <h2 className="text-sm font-semibold text-slate-700 uppercase tracking-widest">User Management</h2>
            <div className="flex items-center gap-2 flex-wrap">
              <input
                type="text" value={search} onChange={(e) => setSearch(e.target.value)}
                placeholder="Search name or email…"
                className="border border-slate-200 rounded-lg px-3 py-1.5 text-xs focus:outline-none focus:ring-2 focus:ring-brand-400 w-44"
              />
              <select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value as never)}
                className="border border-slate-200 rounded-lg px-3 py-1.5 text-xs bg-white focus:outline-none focus:ring-2 focus:ring-brand-400">
                <option value="all">All status</option>
                <option value="active">Active</option>
                <option value="disabled">Disabled</option>
              </select>
              <select value={filterType} onChange={(e) => setFilterType(e.target.value as never)}
                className="border border-slate-200 rounded-lg px-3 py-1.5 text-xs bg-white focus:outline-none focus:ring-2 focus:ring-brand-400">
                <option value="all">All types</option>
                <option value="trial">Trial</option>
                <option value="standard">Standard</option>
              </select>
            </div>
          </div>

          <div className="bg-white border border-slate-200 rounded-xl shadow-card overflow-hidden">
            {isLoading ? (
              <div className="flex items-center justify-center py-12 text-slate-400 text-sm gap-2">
                <svg className="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"/><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/></svg>
                Loading users…
              </div>
            ) : filtered.length === 0 ? (
              <div className="text-center py-12 text-slate-400 text-sm">No users match the current filter.</div>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full text-sm min-w-[700px]">
                  <thead>
                    <tr className="border-b border-slate-100 bg-slate-50">
                      <th className="text-left px-5 py-3 text-xs font-semibold text-slate-500">Name</th>
                      <th className="text-left px-4 py-3 text-xs font-semibold text-slate-500">Email</th>
                      <th className="text-left px-4 py-3 text-xs font-semibold text-slate-500">Status</th>
                      <th className="text-left px-4 py-3 text-xs font-semibold text-slate-500">Account</th>
                      <th className="text-left px-4 py-3 text-xs font-semibold text-slate-500 hidden lg:table-cell">Trial expires</th>
                      <th className="text-left px-4 py-3 text-xs font-semibold text-slate-500 hidden lg:table-cell">Deactivated</th>
                      <th className="text-left px-4 py-3 text-xs font-semibold text-slate-500">Joined</th>
                      <th className="text-right px-5 py-3 text-xs font-semibold text-slate-500">Actions</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-50">
                    {filtered.map((user: Child) => (
                      <tr key={user.id} className={`hover:bg-slate-50 transition-colors ${user.is_active === false ? 'opacity-60' : ''}`}>
                        <td className="px-5 py-3">
                          <div className="flex items-center gap-2.5">
                            <div className="w-7 h-7 rounded-full bg-brand-100 flex items-center justify-center text-brand-700 font-bold text-xs shrink-0">
                              {user.name.charAt(0).toUpperCase()}
                            </div>
                            <div>
                              <p className="font-medium text-slate-800 text-sm">{user.name}</p>
                              {user.role === 'admin' && <span className="text-xs text-brand-600 font-semibold">Admin</span>}
                            </div>
                          </div>
                        </td>
                        <td className="px-4 py-3 text-xs text-slate-500">{user.email ?? '—'}</td>
                        <td className="px-4 py-3"><StatusBadge active={user.is_active} deletedAt={user.deleted_at} /></td>
                        <td className="px-4 py-3"><AccountTypeBadge type={user.account_type} /></td>
                        <td className="px-4 py-3 text-xs text-slate-500 hidden lg:table-cell">
                          {user.trial_expires_at
                            ? new Date(user.trial_expires_at).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
                            : <span className="text-slate-300">—</span>}
                        </td>
                        <td className="px-4 py-3 text-xs hidden lg:table-cell">
                          {user.deleted_at
                            ? <span className="text-rose-500">{new Date(user.deleted_at).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })}</span>
                            : <span className="text-slate-300">—</span>}
                        </td>
                        <td className="px-4 py-3 text-xs text-slate-400">
                          {user.created_at
                            ? new Date(user.created_at).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
                            : '—'}
                        </td>
                        <td className="px-5 py-3">
                          <div className="flex items-center justify-end gap-1">
                            {/* Toggle status */}
                            <button
                              onClick={() => handleToggle(user)}
                              disabled={user.role === 'admin'}
                              title={user.is_active === false ? 'Enable account' : 'Disable account'}
                              className="p-1.5 rounded-lg hover:bg-slate-100 text-slate-500 disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
                            >
                              {user.is_active === false
                                ? <svg className="w-4 h-4 text-emerald-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                                : <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" /></svg>
                              }
                            </button>
                            {/* Toggle account type */}
                            <button
                              onClick={() => setType.mutate({ id: user.id, type: user.account_type === 'standard' ? 'trial' : 'standard' })}
                              title={user.account_type === 'standard' ? 'Downgrade to trial' : 'Upgrade to standard'}
                              className="p-1.5 rounded-lg hover:bg-slate-100 text-slate-500 transition-colors"
                            >
                              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 11l5-5m0 0l5 5m-5-5v12" /></svg>
                            </button>
                            {/* Delete */}
                            <button
                              onClick={() => handleDelete(user)}
                              disabled={user.role === 'admin'}
                              title="Delete account"
                              className="p-1.5 rounded-lg hover:bg-rose-50 text-slate-400 hover:text-rose-600 disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
                            >
                              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
                            </button>
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
          <p className="text-xs text-slate-400 mt-2">{filtered.length} user{filtered.length !== 1 ? 's' : ''} shown</p>
        </section>
      </main>
    </div>
  );
}
