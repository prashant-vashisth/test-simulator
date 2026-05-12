import { useState } from 'react';
import { Link } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import { AuthLayout } from '../components/auth/AuthLayout';

export function ForgotPasswordPage() {
  const [email, setEmail] = useState('');
  const [sent, setSent] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const { error } = await supabase.auth.resetPasswordForEmail(email, {
        redirectTo: `${window.location.origin}/reset-password`,
      });
      if (error) throw error;
      setSent(true);
    } catch (err: unknown) {
      const msg = (err instanceof Error ? err.message : '').toLowerCase();
      if (msg.includes('rate limit') || msg.includes('too many') || msg.includes('over_email_send_rate_limit')) {
        setError('Too many reset emails sent recently. Please wait a few minutes before trying again.');
      } else if (msg.includes('user not found') || msg.includes('invalid email')) {
        // Don't reveal whether email exists — always show success to prevent enumeration
        setSent(true);
      } else {
        setError('Something went wrong. Please try again in a few minutes.');
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthLayout
      heading="Forgot your password? No problem."
      subheading="Enter the email address linked to your account and we'll send you a reset link."
    >
      {sent ? (
        <div className="text-center">
          <div className="w-14 h-14 bg-emerald-50 rounded-full flex items-center justify-center mx-auto mb-5">
            <svg className="w-7 h-7 text-emerald-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
          </div>
          <h2 className="text-xl font-bold text-slate-900 mb-2">Check your inbox</h2>
          <p className="text-sm text-slate-500 leading-relaxed mb-6">
            We sent a password reset link to <span className="font-semibold text-slate-700">{email}</span>.
            The link expires in 1 hour.
          </p>
          <div className="bg-slate-50 border border-slate-100 rounded-xl p-4 text-left mb-6">
            <p className="text-xs font-semibold text-slate-600 mb-1">Didn't get the email?</p>
            <ul className="text-xs text-slate-500 space-y-1">
              <li>· Check your spam or junk folder</li>
              <li>· Make sure the email address above is correct</li>
              <li>
                ·{' '}
                <button
                  onClick={() => setSent(false)}
                  className="text-brand-600 hover:underline"
                >
                  Try again with a different address
                </button>
              </li>
            </ul>
          </div>
          <Link
            to="/child-login"
            className="text-sm font-semibold text-brand-600 hover:text-brand-700"
          >
            ← Back to sign in
          </Link>
        </div>
      ) : (
        <>
          <div className="mb-8">
            <h2 className="text-2xl font-bold text-slate-900">Reset your password</h2>
            <p className="text-slate-500 text-sm mt-1">We'll email you a secure reset link</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-xs font-semibold text-slate-600 mb-1.5">Email Address</label>
              <input
                type="email" value={email} onChange={(e) => setEmail(e.target.value)}
                placeholder="jane@example.com" required autoFocus
                className="w-full border border-slate-200 rounded-lg px-3.5 py-2.5 text-sm text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition"
              />
            </div>

            {error && (
              <div className="flex items-start gap-2 bg-rose-50 border border-rose-200 rounded-lg px-3 py-2.5">
                <svg className="w-4 h-4 text-rose-500 mt-0.5 shrink-0" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
                </svg>
                <p className="text-sm text-rose-700">{error}</p>
              </div>
            )}

            <button
              type="submit" disabled={loading}
              className="w-full bg-brand-600 hover:bg-brand-700 disabled:opacity-60 text-white font-semibold py-2.5 rounded-lg text-sm transition-colors flex items-center justify-center gap-2 mt-1"
            >
              {loading ? (
                <><svg className="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"/><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/></svg>Sending…</>
              ) : 'Send Reset Link'}
            </button>
          </form>

          <p className="text-center text-sm text-slate-500 mt-6">
            Remember your password?{' '}
            <Link to="/child-login" className="text-brand-600 font-semibold hover:text-brand-700">
              Sign in
            </Link>
          </p>
        </>
      )}
    </AuthLayout>
  );
}
