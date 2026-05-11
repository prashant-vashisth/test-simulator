import { useEffect, useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { useAuthStore } from '../store/authStore';
import { childService } from '../services/childService';
import { ChildSelector } from '../components/auth/ChildSelector';

const FEATURES = [
  {
    icon: '🔢',
    title: 'Mathematics',
    desc: 'Adaptive practice from Kindergarten through 12th grade — covering number sense, algebra, geometry, data analysis, and AP Calculus.',
    tags: ['K–12', 'NWEA MAP', 'Olympiad'],
    color: 'bg-blue-50 border-blue-100',
    iconBg: 'bg-blue-100',
  },
  {
    icon: '📖',
    title: 'English Reading',
    desc: 'Comprehensive ELA preparation — phonics, comprehension, literary analysis, rhetorical reading, and college-level synthesis.',
    tags: ['ELA', 'K–12', 'Standards-aligned'],
    color: 'bg-emerald-50 border-emerald-100',
    iconBg: 'bg-emerald-100',
  },
  {
    icon: '✍️',
    title: 'AI Writing Coach',
    desc: 'Students write responses to grade-level prompts and receive instant AI-powered feedback on grammar, vocabulary, structure, and content.',
    tags: ['Groq AI', 'Instant Feedback', 'K–12'],
    color: 'bg-violet-50 border-violet-100',
    iconBg: 'bg-violet-100',
  },
];

const STATS = [
  { value: '1,000+', label: 'Practice Questions' },
  { value: 'K – 12', label: 'Grade Coverage' },
  { value: '3',      label: 'Test Formats' },
  { value: 'AI',     label: 'Writing Feedback' },
];

export function LandingPage() {
  const navigate = useNavigate();
  const { isAuthenticated, selectedChild, childSession, login, logout, selectChild } = useAuthStore();

  const [showParentLogin, setShowParentLogin] = useState(false);
  const [password, setPassword] = useState('');
  const [pwError, setPwError] = useState('');

  useEffect(() => { if (childSession) navigate('/dashboard'); }, [childSession, navigate]);
  useEffect(() => { if (isAuthenticated && selectedChild) navigate('/select-test'); }, [isAuthenticated, selectedChild, navigate]);

  const { data: children = [], isLoading } = useQuery({
    queryKey: ['children'],
    queryFn: childService.listChildren,
    enabled: isAuthenticated,
    staleTime: 5 * 60 * 1000,
  });

  const handleParentLogin = (e: React.FormEvent) => {
    e.preventDefault();
    if (login(password)) { setPwError(''); }
    else { setPwError('Incorrect password. Please try again.'); }
  };

  if (isAuthenticated) {
    return (
      <ChildSelector
        children={children}
        isLoading={isLoading}
        onSelect={(child) => { selectChild(child); navigate('/select-test'); }}
        onLogout={logout}
      />
    );
  }

  return (
    <div className="min-h-screen bg-white flex flex-col">

      {/* ── Top Nav ──────────────────────────────────────────────────── */}
      <header className="sticky top-0 z-30 bg-white/95 backdrop-blur border-b border-slate-100">
        <div className="max-w-6xl mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-lg bg-brand-600 flex items-center justify-center text-white font-black text-sm">A</div>
            <span className="font-bold text-slate-900 text-lg tracking-tight">AcademIQ</span>
          </div>
          <nav className="flex items-center gap-3">
            <Link
              to="/child-login"
              className="text-sm font-medium text-slate-600 hover:text-slate-900 px-3 py-2 rounded-lg hover:bg-slate-50 transition-colors"
            >
              Sign In
            </Link>
            <Link
              to="/register"
              className="text-sm font-semibold bg-brand-600 hover:bg-brand-700 text-white px-4 py-2 rounded-lg transition-colors"
            >
              Get Started Free
            </Link>
          </nav>
        </div>
      </header>

      {/* ── Hero ─────────────────────────────────────────────────────── */}
      <section className="flex-1 flex flex-col items-center justify-center text-center px-6 py-20 bg-gradient-to-b from-slate-50 to-white">
        <div className="inline-flex items-center gap-2 bg-brand-50 border border-brand-100 text-brand-700 text-xs font-semibold px-3 py-1.5 rounded-full mb-6">
          <span className="w-1.5 h-1.5 rounded-full bg-brand-500 animate-pulse" />
          AI-Powered Academic Test Preparation
        </div>

        <h1 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold text-slate-900 tracking-tight leading-tight max-w-3xl">
          Personalized Learning for
          <span className="text-brand-600"> Academic Excellence</span>
        </h1>

        <p className="mt-5 text-lg text-slate-500 max-w-xl leading-relaxed">
          Adaptive test prep for NWEA MAP, Math &amp; Science Olympiad — with AI-powered writing coaching.
          Designed for students in grades K–12.
        </p>

        <div className="mt-8 flex flex-col sm:flex-row gap-3 justify-center">
          <Link
            to="/register"
            className="inline-flex items-center justify-center gap-2 bg-brand-600 hover:bg-brand-700 text-white font-semibold px-6 py-3 rounded-xl transition-colors shadow-md shadow-brand-200"
          >
            Create Free Account
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 8l4 4m0 0l-4 4m4-4H3" /></svg>
          </Link>
          <Link
            to="/child-login"
            className="inline-flex items-center justify-center gap-2 bg-white hover:bg-slate-50 text-slate-700 font-semibold px-6 py-3 rounded-xl border border-slate-200 transition-colors"
          >
            Sign In to Dashboard
          </Link>
        </div>
      </section>

      {/* ── Stats bar ────────────────────────────────────────────────── */}
      <section className="border-y border-slate-100 bg-slate-50">
        <div className="max-w-4xl mx-auto px-6 py-6 grid grid-cols-2 sm:grid-cols-4 gap-6">
          {STATS.map((s) => (
            <div key={s.label} className="text-center">
              <div className="text-2xl font-extrabold text-slate-900">{s.value}</div>
              <div className="text-xs text-slate-500 font-medium mt-0.5">{s.label}</div>
            </div>
          ))}
        </div>
      </section>

      {/* ── Features ─────────────────────────────────────────────────── */}
      <section className="py-20 px-6">
        <div className="max-w-5xl mx-auto">
          <div className="text-center mb-12">
            <p className="text-xs font-semibold text-brand-600 uppercase tracking-widest mb-2">What's Included</p>
            <h2 className="text-3xl font-extrabold text-slate-900">Three Core Learning Areas</h2>
            <p className="text-slate-500 mt-2 max-w-lg mx-auto">Every subject is fully aligned to grade-level standards with questions that adapt to your child's current level.</p>
          </div>

          <div className="grid sm:grid-cols-3 gap-6">
            {FEATURES.map((f) => (
              <div key={f.title} className={`border rounded-2xl p-6 ${f.color}`}>
                <div className={`w-11 h-11 rounded-xl flex items-center justify-center text-2xl mb-4 ${f.iconBg}`}>
                  {f.icon}
                </div>
                <h3 className="font-bold text-slate-900 text-lg mb-2">{f.title}</h3>
                <p className="text-sm text-slate-600 leading-relaxed mb-4">{f.desc}</p>
                <div className="flex flex-wrap gap-1.5">
                  {f.tags.map((t) => (
                    <span key={t} className="text-xs font-medium bg-white/80 text-slate-600 px-2.5 py-1 rounded-full border border-white">
                      {t}
                    </span>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── How it works ─────────────────────────────────────────────── */}
      <section className="py-16 px-6 bg-slate-50 border-t border-slate-100">
        <div className="max-w-3xl mx-auto text-center">
          <p className="text-xs font-semibold text-brand-600 uppercase tracking-widest mb-2">How It Works</p>
          <h2 className="text-2xl font-extrabold text-slate-900 mb-10">Up and running in minutes</h2>
          <div className="grid sm:grid-cols-3 gap-8">
            {[
              { step: '01', title: 'Create an account', desc: 'Register with your email and select your grade level.' },
              { step: '02', title: 'Choose a subject', desc: 'Pick Math, English Reading, or English Writing — then configure your difficulty and question count.' },
              { step: '03', title: 'Practice & improve', desc: 'Complete timed sessions, get AI writing feedback, and track your performance over time.' },
            ].map((item) => (
              <div key={item.step} className="text-left">
                <div className="text-xs font-black text-brand-400 mb-2 font-mono">{item.step}</div>
                <h3 className="font-bold text-slate-900 mb-1">{item.title}</h3>
                <p className="text-sm text-slate-500 leading-relaxed">{item.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── Footer / Parent access ────────────────────────────────────── */}
      <footer className="border-t border-slate-100 bg-white">
        <div className="max-w-4xl mx-auto px-6 py-8 flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="flex items-center gap-2">
            <div className="w-6 h-6 rounded bg-brand-600 flex items-center justify-center text-white font-black text-xs">A</div>
            <span className="text-sm font-semibold text-slate-700">AcademIQ</span>
            <span className="text-slate-300 mx-1">·</span>
            <span className="text-xs text-slate-400">K–12 Academic Excellence Platform</span>
          </div>

          <div>
            <button
              onClick={() => setShowParentLogin(!showParentLogin)}
              className="text-xs text-slate-400 hover:text-slate-600 underline underline-offset-2 transition-colors"
            >
              {showParentLogin ? 'Hide' : 'Parent / Admin Access'}
            </button>

            {showParentLogin && (
              <form onSubmit={handleParentLogin} className="mt-3 flex items-center gap-2">
                <input
                  type="password"
                  value={password}
                  onChange={(e) => { setPassword(e.target.value); setPwError(''); }}
                  placeholder="Parent password"
                  autoFocus
                  className="border border-slate-200 rounded-lg px-3 py-1.5 text-xs text-slate-700 focus:outline-none focus:ring-2 focus:ring-brand-400 w-40"
                />
                <button
                  type="submit"
                  className="bg-slate-800 hover:bg-slate-900 text-white text-xs font-semibold px-3 py-1.5 rounded-lg transition-colors"
                >
                  Unlock
                </button>
                {pwError && <span className="text-xs text-rose-500">{pwError}</span>}
              </form>
            )}
          </div>
        </div>
      </footer>

    </div>
  );
}
