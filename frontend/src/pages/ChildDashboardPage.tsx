import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { useAuthStore } from '../store/authStore';
import { childService } from '../services/childService';
import { catalogueService } from '../services/catalogueService';
import type { Subject, TopicPerformance } from '../types';

// NWEA MAP test type ID (fixed in seed_data.sql)
const NWEA_MAP_ID = '22222222-0000-0000-0000-000000000001';

const SUBJECT_META: Record<string, { emoji: string; color: string; bg: string }> = {
  math:            { emoji: '🔢', color: 'text-blue-700',   bg: 'bg-blue-50 border-blue-200' },
  english_reading: { emoji: '📖', color: 'text-green-700',  bg: 'bg-green-50 border-green-200' },
  english_writing: { emoji: '✏️', color: 'text-purple-700', bg: 'bg-purple-50 border-purple-200' },
};

function accuracyColor(pct: number) {
  if (pct >= 80) return 'text-green-600';
  if (pct >= 60) return 'text-yellow-600';
  return 'text-red-500';
}

function SubjectCard({
  subject,
  performance,
  gradeName,
  onClick,
}: {
  subject: Subject;
  performance: TopicPerformance[];
  gradeName: string;
  onClick: () => void;
}) {
  const meta = SUBJECT_META[subject.code] ?? { emoji: '📚', color: 'text-gray-700', bg: 'bg-gray-50 border-gray-200' };
  const totalAttempts = performance.reduce((s, p) => s + p.total_attempts, 0);
  const avgAccuracy = performance.length
    ? Math.round(performance.reduce((s, p) => s + p.accuracy_percent, 0) / performance.length)
    : null;

  return (
    <div
      onClick={onClick}
      className={`border-2 rounded-2xl p-5 cursor-pointer hover:shadow-md transition-all ${meta.bg}`}
    >
      <div className="flex items-center gap-3 mb-3">
        <span className="text-3xl">{meta.emoji}</span>
        <div>
          <h3 className={`font-bold text-lg ${meta.color}`}>{subject.name}</h3>
          <p className="text-xs text-gray-500">{gradeName}</p>
        </div>
      </div>
      <p className="text-xs text-gray-500 mb-3">{subject.description}</p>
      <div className="flex items-center justify-between">
        {avgAccuracy !== null ? (
          <span className={`text-sm font-semibold ${accuracyColor(avgAccuracy)}`}>
            {avgAccuracy}% accuracy
          </span>
        ) : (
          <span className="text-xs text-gray-400">No attempts yet</span>
        )}
        {totalAttempts > 0 && (
          <span className="text-xs text-gray-400">{totalAttempts} questions answered</span>
        )}
      </div>
      <button className={`mt-4 w-full py-2 rounded-lg text-sm font-semibold text-white transition-colors ${
        subject.code === 'english_writing'
          ? 'bg-purple-600 hover:bg-purple-700'
          : subject.code === 'english_reading'
          ? 'bg-green-600 hover:bg-green-700'
          : 'bg-blue-600 hover:bg-blue-700'
      }`}>
        Start Practice →
      </button>
    </div>
  );
}

export function ChildDashboardPage() {
  const navigate = useNavigate();
  const { childProfile, childSession, logoutChild, setChildProfile } = useAuthStore();

  // Redirect if not authenticated
  useEffect(() => {
    if (!childSession) navigate('/child-login');
  }, [childSession, navigate]);

  // Fetch child profile if missing
  useEffect(() => {
    if (childSession && !childProfile) {
      import('../services/api').then(({ default: api }) =>
        api.get('/api/v1/auth/me').then((r) => setChildProfile(r.data)).catch(() => {})
      );
    }
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

  const { data: recentSessions = [] } = useQuery({
    queryKey: ['sessions', childId],
    queryFn: () => childService.getSessions(childId, 3),
    enabled: !!childId,
    staleTime: 60_000,
  });

  // Filter to the 3 core subjects
  const coreSubjects = allSubjects.filter((s) =>
    ['math', 'english_reading', 'english_writing'].includes(s.code)
  );

  const gradeName = grades.find((g) => g.id === gradeId)?.name ?? '';

  const perfBySubject = (_subjectId: string) => performance;

  const handleStartPractice = (subject: Subject) => {
    if (!childProfile) return;

    const gradeObj = grades.find((g) => g.id === gradeId);
    if (!gradeObj) return;

    // Pre-fill test config and navigate to selection page
    navigate('/select-test', {
      state: {
        childId: childProfile.id,
        childName: childProfile.name,
        preselectedSubjectId: subject.id,
        preselectedSubjectCode: subject.code,
        preselectedGradeId: gradeId,
        testTypeId: NWEA_MAP_ID,
      },
    });
  };

  if (!childProfile) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-gray-400 animate-pulse">Loading your dashboard…</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-50 to-purple-50">
      {/* Header */}
      <header className="bg-white shadow-sm px-6 py-4 flex items-center justify-between">
        <div>
          <h1 className="text-xl font-bold text-gray-800">
            Welcome back, {childProfile.name.split(' ')[0]}! 👋
          </h1>
          {gradeName && (
            <p className="text-sm text-gray-500">{gradeName}</p>
          )}
        </div>
        <button
          onClick={() => logoutChild().then(() => navigate('/'))}
          className="text-sm text-gray-500 hover:text-gray-700"
        >
          Sign out
        </button>
      </header>

      <main className="max-w-3xl mx-auto px-4 py-8 space-y-8">
        {/* Subject cards */}
        <section>
          <h2 className="text-lg font-semibold text-gray-700 mb-4">Your Subjects</h2>
          {coreSubjects.length === 0 ? (
            <p className="text-gray-400 text-sm">Loading subjects…</p>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              {coreSubjects.map((subject) => (
                <SubjectCard
                  key={subject.id}
                  subject={subject}
                  performance={perfBySubject(subject.id)}
                  gradeName={gradeName}
                  onClick={() => handleStartPractice(subject)}
                />
              ))}
            </div>
          )}
        </section>

        {/* Recent sessions */}
        {recentSessions.length > 0 && (
          <section>
            <h2 className="text-lg font-semibold text-gray-700 mb-4">Recent Sessions</h2>
            <div className="space-y-2">
              {recentSessions.map((s) => (
                <div
                  key={s.id}
                  className="bg-white rounded-xl border border-gray-100 px-4 py-3 flex items-center justify-between"
                >
                  <div>
                    <p className="text-sm font-medium text-gray-700">
                      {s.subject_name ?? 'Practice'} · {s.grade_name}
                    </p>
                    <p className="text-xs text-gray-400">
                      {new Date(s.started_at).toLocaleDateString()}
                    </p>
                  </div>
                  <div className="text-right">
                    {s.score_percentage !== null ? (
                      <span className={`text-sm font-bold ${accuracyColor(s.score_percentage)}`}>
                        {Math.round(s.score_percentage)}%
                      </span>
                    ) : (
                      <span className="text-xs text-gray-400">{s.status}</span>
                    )}
                    <p className="text-xs text-gray-400">
                      {s.correct_count}/{s.total_questions} correct
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </section>
        )}
      </main>
    </div>
  );
}
