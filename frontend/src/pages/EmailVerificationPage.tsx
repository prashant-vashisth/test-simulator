import { useEffect } from 'react';
import { useNavigate, useLocation, Link } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import { useAuthStore } from '../store/authStore';
import api from '../services/api';
import type { Child } from '../types';

export function EmailVerificationPage() {
  const navigate = useNavigate();
  const location = useLocation();
  const email = (location.state as { email?: string })?.email ?? '';
  const { setChildSession, setChildProfile } = useAuthStore();

  useEffect(() => {
    const { data: listener } = supabase.auth.onAuthStateChange(async (event, session) => {
      if (event === 'SIGNED_IN' && session) {
        setChildSession(session);
        try {
          const res = await api.get<Child>('/api/v1/auth/me', {
            headers: { Authorization: `Bearer ${session.access_token}` },
          });
          setChildProfile(res.data);
        } catch { /* profile will be loaded on dashboard */ }
        navigate('/dashboard');
      }
    });
    return () => listener.subscription.unsubscribe();
  }, [navigate, setChildSession, setChildProfile]);

  return (
    <div className="min-h-screen bg-slate-50 flex items-center justify-center p-6">
      <div className="max-w-md w-full">
        <Link to="/" className="flex items-center gap-2 mb-10 justify-center">
          <div className="w-7 h-7 rounded bg-brand-600 flex items-center justify-center text-white font-black text-xs">A</div>
          <span className="font-bold text-slate-900">AcademIQ</span>
        </Link>

        <div className="bg-white border border-slate-200 rounded-2xl p-8 shadow-card text-center">
          <div className="w-14 h-14 bg-brand-50 rounded-full flex items-center justify-center mx-auto mb-5">
            <svg className="w-7 h-7 text-brand-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
          </div>

          <h1 className="text-xl font-bold text-slate-900 mb-2">Verify your email</h1>
          <p className="text-slate-500 text-sm leading-relaxed">
            We sent a confirmation link to
          </p>
          {email && (
            <p className="font-semibold text-slate-800 text-sm mt-1 mb-4">{email}</p>
          )}
          <p className="text-slate-500 text-sm leading-relaxed mb-6">
            Click the link in your email to activate your account. This page will
            redirect automatically once verified.
          </p>

          <div className="bg-slate-50 border border-slate-100 rounded-xl p-4 text-left">
            <p className="text-xs font-semibold text-slate-700 mb-1">Didn't receive the email?</p>
            <ul className="text-xs text-slate-500 space-y-1">
              <li>· Check your spam or junk folder</li>
              <li>· Make sure you entered the correct email address</li>
              <li>· <Link to="/register" className="text-brand-600 hover:underline">Try registering again</Link> with the same email</li>
            </ul>
          </div>
        </div>

        <p className="text-center text-xs text-slate-400 mt-6">
          <Link to="/" className="hover:text-slate-600">← Back to home</Link>
        </p>
      </div>
    </div>
  );
}
