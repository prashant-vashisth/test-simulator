import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { useAuthStore } from '../store/authStore';
import { catalogueService } from '../services/catalogueService';
import { AuthLayout } from '../components/auth/AuthLayout';

export function RegisterPage() {
  const navigate = useNavigate();
  const { registerChild } = useAuthStore();

  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirm, setConfirm] = useState('');
  const [gradeId, setGradeId] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const { data: grades = [] } = useQuery({
    queryKey: ['grades'],
    queryFn: () => catalogueService.getGrades(),
    staleTime: 10 * 60 * 1000,
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    if (!name.trim()) return setError('Please enter your full name.');
    if (!gradeId) return setError('Please select your grade.');
    if (password.length < 6) return setError('Password must be at least 6 characters.');
    if (password !== confirm) return setError('Passwords do not match.');
    setLoading(true);
    try {
      await registerChild({ name: name.trim(), email, password, gradeId });
      navigate('/verify-email', { state: { email } });
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : 'Registration failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthLayout
      heading="Start your learning journey today."
      subheading="Create an account and access thousands of practice questions across Math, English Reading, and AI-coached Writing."
      quote="Education is the most powerful weapon which you can use to change the world."
      quoteAuthor="Nelson Mandela"
    >
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-slate-900">Create your account</h2>
        <p className="text-slate-500 text-sm mt-1">Free access · No credit card required</p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="grid grid-cols-2 gap-3">
          <div className="col-span-2">
            <label className="block text-xs font-semibold text-slate-600 mb-1.5">Full Name</label>
            <input
              type="text" value={name} onChange={(e) => setName(e.target.value)}
              placeholder="Jane Smith" required
              className="w-full border border-slate-200 rounded-lg px-3.5 py-2.5 text-sm text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition"
            />
          </div>
          <div className="col-span-2">
            <label className="block text-xs font-semibold text-slate-600 mb-1.5">Email Address</label>
            <input
              type="email" value={email} onChange={(e) => setEmail(e.target.value)}
              placeholder="jane@example.com" required
              className="w-full border border-slate-200 rounded-lg px-3.5 py-2.5 text-sm text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition"
            />
          </div>
          <div className="col-span-2">
            <label className="block text-xs font-semibold text-slate-600 mb-1.5">Grade Level</label>
            <select
              value={gradeId} onChange={(e) => setGradeId(e.target.value)} required
              className="w-full border border-slate-200 rounded-lg px-3.5 py-2.5 text-sm text-slate-900 bg-white focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition"
            >
              <option value="">Select your grade…</option>
              {grades.map((g) => (
                <option key={g.id} value={g.id}>{g.name}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1.5">Password</label>
            <input
              type="password" value={password} onChange={(e) => setPassword(e.target.value)}
              placeholder="Min. 6 characters" required
              className="w-full border border-slate-200 rounded-lg px-3.5 py-2.5 text-sm text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition"
            />
          </div>
          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1.5">Confirm Password</label>
            <input
              type="password" value={confirm} onChange={(e) => setConfirm(e.target.value)}
              placeholder="Repeat password" required
              className="w-full border border-slate-200 rounded-lg px-3.5 py-2.5 text-sm text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition"
            />
          </div>
        </div>

        {error && (
          <div className="flex items-start gap-2 bg-rose-50 border border-rose-200 rounded-lg px-3 py-2.5">
            <svg className="w-4 h-4 text-rose-500 mt-0.5 shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" /></svg>
            <p className="text-sm text-rose-700">{error}</p>
          </div>
        )}

        <button
          type="submit" disabled={loading}
          className="w-full bg-brand-600 hover:bg-brand-700 disabled:opacity-60 text-white font-semibold py-2.5 rounded-lg text-sm transition-colors flex items-center justify-center gap-2 mt-1"
        >
          {loading ? (
            <><svg className="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"/><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/></svg>Creating account…</>
          ) : 'Create Free Account'}
        </button>
      </form>

      <p className="text-center text-sm text-slate-500 mt-6">
        Already have an account?{' '}
        <Link to="/child-login" className="text-brand-600 font-semibold hover:text-brand-700">Sign in</Link>
      </p>
    </AuthLayout>
  );
}
