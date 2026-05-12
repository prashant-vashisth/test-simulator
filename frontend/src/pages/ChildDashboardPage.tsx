import { useEffect, useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { useAuthStore } from '../store/authStore';
import { childService } from '../services/childService';
import { catalogueService } from '../services/catalogueService';
import api from '../services/api';
import type { Child, Subject, TopicPerformance, SessionSummary } from '../types';

const NWEA_MAP_ID = '22222222-0000-0000-0000-000000000001';

const SUBJECT_CONFIG: Record<string, { color: string; bg: string; border: string; icon: string; iconBg: string }> = {
  math:            { color: 'text-blue-700',   bg: 'bg-blue-50',   border: 'border-blue-100',   icon: '🔢', iconBg: 'bg-blue-100' },
  english_reading: { color: 'text-emerald-700', bg: 'bg-emerald-50', border: 'border-emerald-100', icon: '📖', iconBg: 'bg-emerald-100' },
  english_writing: { color: 'text-violet-700',  bg: 'bg-violet-50',  border: 'border-violet-100',  icon: '✍️', iconBg: 'bg-violet-100' },
};

function AccuracyRing({ pct }: { pct: number | null }) {
  if (pct === null) return <span className="text-xs text-slate-400 font-medium">No data yet</span>;
  const color = pct >= 80 ? 'text-emerald-600' : pct >= 60 ? 'text-amber-600' : 'text-rose-500';
  return <span className={`text-2xl font-extrabold ${color}`}>{Math.round(pct)}%</span>;
}

function SubjectCard({ subject, perf, gradeName, childId }: {
  subject: Subject;
  perf: TopicPerformance[];
  gradeName: string;
  childId: string;
}) {
  const cfg = SUBJECT_CONFIG[subject.code] ?? { color: 'text-slate-700', bg: 'bg-slate-50', border: 'border-slate-100', icon: '📚', iconBg: 'bg-slate-100' };
  const total = perf.reduce((s, p) => s + p.total_attempts, 0);
  const avg = perf.length ? perf.reduce((s, p) => s + p.accuracy_percent, 0) / perf.length : null;
  const navigate = useNavigate();

  return (
    <div className={`bg-white border rounded-xl p-5 shadow-card hover:shadow-card-md transition-shadow ${cfg.border}`}>
      <div className="flex items-start justify-between mb-4">
        <div className={`w-10 h-10 rounded-lg flex items-center justify-center text-xl ${cfg.iconBg}`}>
          {cfg.icon}
        </div>
        <AccuracyRing pct={avg} />
      </div>
      <h3 className={`font-bold text-base mb-0.5 ${cfg.color}`}>{subject.name}</h3>
      <p className="text-xs text-slate-500 mb-1">{gradeName}</p>
      <p className="text-xs text-slate-400 mb-4 leading-relaxed line-clamp-2">{subject.description}</p>
      <div className="flex items-center justify-between mb-3">
        <span className="text-xs text-slate-500">{total} questions answered</span>
        {avg !== null && (
          <span className="text-xs text-slate-400">avg accuracy</span>
        )}
      </div>
      <button
        onClick={() => navigate('/select-test', { state: { preselectedSubjectId: subject.id, preselectedSubjectCode: subject.code, preselectedGradeId: childId, testTypeId: NWEA_MAP_ID } })}
        className={`w-full py-2 rounded-lg text-xs font-semibold transition-colors ${cfg.bg} ${cfg.color} hover:opacity-80 border ${cfg.border}`}
      >
        Start Practice →
      </button>
    </div>
  );
}

function StatusBadge({ status }: { status: string }) {
  const map: Record<string, string> = {
    completed: 'bg-emerald-50 text-emerald-700 border-emerald-100',
    abandoned: 'bg-rose-50 text-rose-600 border-rose-100',
    in_progress: 'bg-amber-50 text-amber-700 border-amber-100',
  };
  return (
    <span className={`inline-flex px-2 py-0.5 rounded text-xs font-medium border ${map[status] ?? 'bg-slate-50 text-slate-600 border-slate-100'}`}>
      {status.replace('_', ' ')}
    </span>
  );
}

const PENDING_KEY = 'ts-pending-profile';

export function ChildDashboardPage() {
  const navigate = useNavigate();
  const { childProfile, childSession, logoutChild, setChildProfile } = useAuthStore();
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  const [deleting, setDeleting] = useState(false);
  const [profileError, setProfileError] = useState('');

  useEffect(() => { if (!childSession) navigate('/child-login'); }, [childSession, navigate]);

  useEffect(() => {
    if (!childSession || childProfile) return;

    const load = async () => {
      // Retry up to 6 times (covers the ~30s Render cold-start window).
      // Returns the profile data on success, null on 404, throws on timeout.
      const fetchMe = async (): Promise<Child | null> => {
        for (let attempt = 1; attempt <= 6; attempt++) {
          try {
            const res = await api.get<Child>('/api/v1/auth/me');
            return res.data;
          } catch (err: unknown) {
            const status = (err as { response?: { status?: number } })?.response?.status;
            if (status === 404) return null;
            if (attempt === 6) throw err;
            await new Promise((r) => setTimeout(r, 5000));
          }
        }
        return null;
      };

      let profile: Child | null = null;
      try {
        profile = await fetchMe();
      } catch (err: unknown) {
        const status = (err as { response?: { status?: number } })?.response?.status;
        if (status === 401) {
          setProfileError('Session expired. Please sign out and sign in again.');
        } else if (status === 403) {
          setProfileError('Your account has been disabled. Please contact support.');
        } else {
          // Log to console so you can see the real error in browser DevTools
          console.error('[Dashboard] profile fetch failed:', err);
          setProfileError('Could not reach the server. Check the browser console (F12) for details, then retry.');
        }
        return;
      }

      if (profile) { setChildProfile(profile); return; }

      // 404 path — profile was never saved (backend was sleeping during signup)
      const stored = localStorage.getItem(PENDING_KEY);
      if (!stored) {
        setProfileError('Your profile could not be found. Please sign out and register again.');
        return;
      }

      try {
        await api.post('/api/v1/auth/create-profile', JSON.parse(stored));
        localStorage.removeItem(PENDING_KEY);
        const res = await api.get<Child>('/api/v1/auth/me');
        setChildProfile(res.data);
      } catch {
        setProfileError('We could not set up your profile. Please try refreshing.');
      }
    };

    load();
  }, [childSession, childProfile, setChildProfile]);

  const gradeId = childProfile?.grade_id ?? '';
  const childId = childProfile?.id ?? '';

  const { data: allSubjects = [] } = useQuery({
    queryKey: ['subjects', NWEA_MAP_ID],
    queryFn: () => catalogueService.getSubjects(NWEA_MAP_ID),
    enabled: !!childSession,
    staleTime: 10 * 60 * 1000,
  });

  const { data: grades = [] } = useQuery({
    queryKey: ['grades'],
    queryFn: () => catalogueService.getGrades(),
    staleTime: 10 * 60 * 1000,
  });

  const { data: performance = [] } = useQuery({
    queryKey: ['topicPerf', childId, gradeId],
    queryFn: () => childService.getTopicPerformance(childId, undefined, gradeId),
    enabled: !!childId && !!gradeId,
    staleTime: 60_000,
  });

  const { data: recentSessions = [] } = useQuery<SessionSummary[]>({
    queryKey: ['sessions', childId],
    queryFn: () => childService.getSessions(childId, 5),
    enabled: !!childId,
    staleTime: 60_000,
  });

  const coreSubjects = allSubjects.filter((s) =>
    ['math', 'english_reading', 'english_writing'].includes(s.code)
  );

  const gradeName = grades.find((g) => g.id === gradeId)?.name ?? '';

  const completedSessions = recentSessions.filter((s) => s.status === 'completed');
  const avgScore = completedSessions.length
    ? completedSessions.reduce((sum, s) => sum + (s.score_percentage ?? 0), 0) / completedSessions.length
    : null;

  if (!childProfile) {
    return (
      <div className="min-h-screen bg-slate-50 flex items-center justify-center p-6">
        <div className="bg-white border border-slate-200 rounded-2xl shadow-card p-8 max-w-sm w-full text-center">
          {profileError ? (
            <>
              <div className="w-12 h-12 bg-rose-50 rounded-full flex items-center justify-center mx-auto mb-4">
                <svg className="w-6 h-6 text-rose-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                </svg>
              </div>
              <p className="text-sm font-semibold text-slate-800 mb-1">Profile Setup Issue</p>
              <p className="text-xs text-slate-500 leading-relaxed mb-5">{profileError}</p>
              <div className="flex flex-col gap-2">
                <button
                  onClick={() => { setProfileError(''); window.location.reload(); }}
                  className="w-full py-2.5 rounded-lg bg-brand-600 hover:bg-brand-700 text-white text-sm font-semibold transition-colors"
                >
                  Retry
                </button>
                <button
                  onClick={() => logoutChild().then(() => navigate('/'))}
                  className="w-full py-2.5 rounded-lg border border-slate-200 text-slate-600 text-sm font-semibold hover:bg-slate-50 transition-colors"
                >
                  Sign out
                </button>
              </div>
            </>
          ) : (
            <>
              <svg className="animate-spin w-7 h-7 text-brand-400 mx-auto mb-3" fill="none" viewBox="0 0 24 24">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"/>
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/>
              </svg>
              <p className="text-sm text-slate-500">Loading your dashboard…</p>
              <p className="text-xs text-slate-400 mt-1">Starting up the server — this can take up to 30 seconds on first load.</p>
            </>
          )}
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-50">
      {/* ── Top Nav ── */}
      <header className="bg-white border-b border-slate-100 sticky top-0 z-20">
        <div className="max-w-6xl mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-6">
            <Link to="/" className="flex items-center gap-2">
              <div className="w-7 h-7 rounded bg-brand-600 flex items-center justify-center text-white font-black text-xs">A</div>
              <span className="font-bold text-slate-900 hidden sm:block">AcademIQ</span>
            </Link>
            <nav className="hidden md:flex items-center gap-1">
              <span className="text-xs font-semibold text-brand-600 bg-brand-50 px-3 py-1.5 rounded-lg">Dashboard</span>
              <Link to="/select-test" className="text-xs font-medium text-slate-600 hover:text-slate-900 px-3 py-1.5 rounded-lg hover:bg-slate-50 transition-colors">Practice</Link>
              {childProfile?.role === 'admin' && (
                <Link to="/admin" className="text-xs font-medium text-amber-700 bg-amber-50 border border-amber-100 hover:bg-amber-100 px-3 py-1.5 rounded-lg transition-colors">
                  Admin Console
                </Link>
              )}
            </nav>
          </div>
          <div className="flex items-center gap-3">
            <div className="text-right hidden sm:block">
              <p className="text-xs font-semibold text-slate-900">{childProfile.name}</p>
              <p className="text-xs text-slate-400">{gradeName}</p>
            </div>
            <div className="w-8 h-8 rounded-full bg-brand-100 flex items-center justify-center text-brand-700 font-bold text-sm">
              {childProfile.name.charAt(0).toUpperCase()}
            </div>
            <button
              onClick={() => logoutChild().then(() => navigate('/'))}
              className="text-xs text-slate-400 hover:text-slate-700 font-medium transition-colors ml-1"
            >
              Sign out
            </button>
          </div>
        </div>
      </header>

      <main className="max-w-6xl mx-auto px-6 py-8 space-y-8">

        {/* ── Welcome + Stats ── */}
        <div>
          <h1 className="text-2xl font-bold text-slate-900">
            Good {getGreeting()}, {childProfile.name.split(' ')[0]}
          </h1>
          <p className="text-sm text-slate-500 mt-0.5">Here's your learning overview for {gradeName}.</p>
        </div>

        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
          {[
            { label: 'Sessions this week', value: recentSessions.length, sub: 'practice sessions' },
            { label: 'Average Score', value: avgScore !== null ? `${Math.round(avgScore)}%` : '—', sub: 'across completed tests' },
            { label: 'Subjects Available', value: coreSubjects.length, sub: 'core subjects' },
            { label: 'Topics Practiced', value: performance.length, sub: 'unique topics' },
          ].map((stat) => (
            <div key={stat.label} className="bg-white border border-slate-200 rounded-xl p-4 shadow-card">
              <div className="text-2xl font-extrabold text-slate-900 tracking-tight">{stat.value}</div>
              <div className="text-xs font-semibold text-slate-700 mt-1">{stat.label}</div>
              <div className="text-xs text-slate-400 mt-0.5">{stat.sub}</div>
            </div>
          ))}
        </div>

        {/* ── Subject Cards ── */}
        <section>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-sm font-semibold text-slate-700 uppercase tracking-widest">Your Subjects</h2>
            <Link to="/select-test" className="text-xs font-semibold text-brand-600 hover:text-brand-700">
              All subjects →
            </Link>
          </div>
          <div className="grid sm:grid-cols-3 gap-4">
            {coreSubjects.length === 0 ? (
              <div className="col-span-3 bg-white border border-slate-200 rounded-xl p-8 text-center text-slate-400 text-sm">
                Loading subjects…
              </div>
            ) : coreSubjects.map((subject) => (
              <SubjectCard
                key={subject.id}
                subject={subject}
                perf={performance}
                gradeName={gradeName}
                childId={gradeId}
              />
            ))}
          </div>
        </section>

        {/* ── Recent Activity ── */}
        {recentSessions.length > 0 && (
          <section>
            <h2 className="text-sm font-semibold text-slate-700 uppercase tracking-widest mb-4">Recent Activity</h2>
            <div className="bg-white border border-slate-200 rounded-xl shadow-card overflow-hidden">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-slate-100">
                    <th className="text-left px-5 py-3 text-xs font-semibold text-slate-500">Subject</th>
                    <th className="text-left px-4 py-3 text-xs font-semibold text-slate-500 hidden sm:table-cell">Difficulty</th>
                    <th className="text-left px-4 py-3 text-xs font-semibold text-slate-500">Status</th>
                    <th className="text-right px-5 py-3 text-xs font-semibold text-slate-500">Score</th>
                    <th className="text-right px-5 py-3 text-xs font-semibold text-slate-500 hidden md:table-cell">Date</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-50">
                  {recentSessions.map((s) => (
                    <tr key={s.id} className="hover:bg-slate-50 transition-colors">
                      <td className="px-5 py-3">
                        <div className="font-medium text-slate-800 text-sm">{s.subject_name ?? '—'}</div>
                        <div className="text-xs text-slate-400">{s.grade_name}</div>
                      </td>
                      <td className="px-4 py-3 hidden sm:table-cell">
                        <span className="capitalize text-xs text-slate-500">{s.difficulty}</span>
                      </td>
                      <td className="px-4 py-3"><StatusBadge status={s.status} /></td>
                      <td className="px-5 py-3 text-right">
                        {s.score_percentage !== null ? (
                          <span className={`font-bold text-sm ${s.score_percentage >= 80 ? 'text-emerald-600' : s.score_percentage >= 60 ? 'text-amber-600' : 'text-rose-500'}`}>
                            {Math.round(s.score_percentage)}%
                          </span>
                        ) : <span className="text-xs text-slate-400">—</span>}
                      </td>
                      <td className="px-5 py-3 text-right hidden md:table-cell">
                        <span className="text-xs text-slate-400">
                          {new Date(s.started_at).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </section>
        )}
        {/* Account settings */}
        <section>
          <h2 className="text-sm font-semibold text-slate-700 uppercase tracking-widest mb-4">Account</h2>
          <div className="bg-white border border-slate-200 rounded-xl shadow-card p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
              <p className="text-sm font-semibold text-slate-800">Delete Account</p>
              <p className="text-xs text-slate-500 mt-0.5">Permanently remove your account and all practice data. This cannot be undone.</p>
            </div>
            <button
              onClick={() => setShowDeleteConfirm(true)}
              className="shrink-0 px-4 py-2 rounded-lg border border-rose-200 text-rose-600 hover:bg-rose-50 text-sm font-semibold transition-colors"
            >
              Delete Account
            </button>
          </div>
        </section>
      </main>

      {/* Delete confirmation modal */}
      {showDeleteConfirm && (
        <div className="fixed inset-0 bg-black/40 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-card-lg p-6 max-w-sm w-full">
            <div className="w-10 h-10 rounded-full bg-rose-100 flex items-center justify-center mb-4">
              <svg className="w-5 h-5 text-rose-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
              </svg>
            </div>
            <h3 className="font-bold text-slate-900 mb-1">Delete your account?</h3>
            <p className="text-sm text-slate-500 leading-relaxed mb-5">
              All your sessions, scores, and progress will be permanently deleted.
              Your login will stop working immediately.
            </p>
            <div className="flex gap-3">
              <button
                onClick={() => setShowDeleteConfirm(false)}
                className="flex-1 py-2.5 rounded-lg border border-slate-200 text-sm font-semibold text-slate-600 hover:bg-slate-50 transition-colors"
              >
                Cancel
              </button>
              <button
                disabled={deleting}
                onClick={async () => {
                  setDeleting(true);
                  try {
                    await api.delete('/api/v1/auth/account');
                    await logoutChild();
                    navigate('/');
                  } catch {
                    setDeleting(false);
                    setShowDeleteConfirm(false);
                  }
                }}
                className="flex-1 py-2.5 rounded-lg bg-rose-600 hover:bg-rose-700 disabled:opacity-60 text-white text-sm font-semibold transition-colors flex items-center justify-center gap-2"
              >
                {deleting
                  ? <><svg className="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"/><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/></svg>Deleting…</>
                  : 'Yes, delete everything'
                }
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function getGreeting() {
  const h = new Date().getHours();
  if (h < 12) return 'morning';
  if (h < 17) return 'afternoon';
  return 'evening';
}
