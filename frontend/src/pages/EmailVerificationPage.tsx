import { useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
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
        } catch {
          // Profile may not exist yet; child will set it up on dashboard
        }
        navigate('/dashboard');
      }
    });
    return () => listener.subscription.unsubscribe();
  }, [navigate, setChildSession, setChildProfile]);

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-50 to-purple-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-xl p-8 w-full max-w-md text-center">
        <div className="text-6xl mb-4">📬</div>
        <h1 className="text-2xl font-bold text-gray-800 mb-2">Check Your Email</h1>
        <p className="text-gray-600 mb-2">
          We sent a verification link to:
        </p>
        {email && (
          <p className="font-semibold text-indigo-700 mb-4">{email}</p>
        )}
        <p className="text-gray-500 text-sm mb-6">
          Click the link in the email to activate your account. This page will automatically
          redirect once your email is verified.
        </p>
        <div className="bg-indigo-50 rounded-lg p-4 text-sm text-indigo-700">
          <p className="font-medium mb-1">Didn't get the email?</p>
          <p>Check your spam folder, or go back and register again with the same email.</p>
        </div>
      </div>
    </div>
  );
}
