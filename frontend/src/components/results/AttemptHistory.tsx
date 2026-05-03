import type { SessionSummary } from '../../types';
import { clsx } from 'clsx';

interface Props {
  sessions: SessionSummary[];
}

const pctColor = (pct: number | null) => {
  if (pct === null) return 'text-gray-400';
  if (pct >= 80) return 'text-green-600';
  if (pct >= 60) return 'text-yellow-600';
  return 'text-red-500';
};

const dateLabel = (iso: string) =>
  new Date(iso).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });

export function AttemptHistory({ sessions }: Props) {
  if (sessions.length === 0) {
    return (
      <div className="bg-gray-50 rounded-2xl border border-gray-100 p-6 text-center text-gray-400 text-sm">
        No previous attempts yet.
      </div>
    );
  }

  return (
    <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
      <div className="px-5 py-4 border-b border-gray-100">
        <h3 className="font-display font-bold text-gray-900">Last {sessions.length} Attempts</h3>
      </div>
      <div className="divide-y divide-gray-50">
        {sessions.map((s, idx) => (
          <div key={s.id} className="px-5 py-3.5 flex items-center justify-between gap-4">
            <div className="min-w-0">
              <p className="text-sm font-semibold text-gray-800 truncate">
                {s.test_type_name ?? '—'} · {s.subject_name ?? '—'}
              </p>
              <p className="text-xs text-gray-400 mt-0.5">
                {s.grade_name ?? '—'} · {s.difficulty} · {dateLabel(s.started_at)}
              </p>
            </div>
            <div className="flex items-center gap-3 flex-shrink-0">
              <div className="text-right">
                <div className={clsx('text-xl font-black', pctColor(s.score_percentage))}>
                  {s.score_percentage !== null ? `${s.score_percentage.toFixed(0)}%` : '—'}
                </div>
                <div className="text-xs text-gray-400">{s.correct_count}/{s.total_questions}</div>
              </div>
              {idx === 0 && (
                <span className="text-xs bg-brand-100 text-brand-700 font-bold px-2 py-0.5 rounded-full">Latest</span>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
