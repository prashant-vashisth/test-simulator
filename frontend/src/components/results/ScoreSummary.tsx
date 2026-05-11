import type { SessionResult } from '../../types';

interface Props {
  result: SessionResult;
  childName: string;
}

function scoreConfig(pct: number) {
  if (pct >= 90) return { color: 'text-emerald-600', bg: 'bg-emerald-50', border: 'border-emerald-100', label: 'Outstanding', bar: 'bg-emerald-500' };
  if (pct >= 75) return { color: 'text-brand-600',   bg: 'bg-brand-50',   border: 'border-brand-100',   label: 'Great Work',   bar: 'bg-brand-500' };
  if (pct >= 60) return { color: 'text-amber-600',   bg: 'bg-amber-50',   border: 'border-amber-100',   label: 'Good Effort',  bar: 'bg-amber-500' };
  return                 { color: 'text-rose-600',    bg: 'bg-rose-50',    border: 'border-rose-100',    label: 'Keep Trying',  bar: 'bg-rose-400' };
}

const MESSAGES: Record<string, string> = {
  Outstanding: 'Exceptional performance. You have a strong command of this material.',
  'Great Work': 'Solid understanding. A little more focused practice will get you to mastery.',
  'Good Effort': 'You are on the right track. Review the incorrect answers and try again.',
  'Keep Trying': 'Every attempt builds knowledge. Review the material and try again.',
};

const duration = (startIso: string, endIso: string | null) => {
  if (!endIso) return '—';
  const s = Math.round((new Date(endIso).getTime() - new Date(startIso).getTime()) / 1000);
  const m = Math.floor(s / 60);
  return m > 0 ? `${m}m ${s % 60}s` : `${s}s`;
};

export function ScoreSummary({ result, childName }: Props) {
  const pct = result.score_percentage ?? 0;
  const cfg = scoreConfig(pct);
  const incorrect = result.total_questions - result.correct_count;

  return (
    <div className={`bg-white border rounded-xl shadow-card overflow-hidden ${cfg.border}`}>
      {/* Score band */}
      <div className={`${cfg.bg} border-b ${cfg.border} px-6 py-5 flex items-center justify-between`}>
        <div>
          <p className="text-xs font-semibold text-slate-500 mb-0.5">Result for {childName.split(' ')[0]}</p>
          <div className={`text-5xl font-extrabold tracking-tight ${cfg.color}`}>
            {pct.toFixed(0)}<span className="text-2xl">%</span>
          </div>
          <p className="text-sm font-semibold text-slate-700 mt-1">{cfg.label}</p>
          <p className="text-xs text-slate-500 leading-relaxed mt-0.5 max-w-xs">{MESSAGES[cfg.label]}</p>
        </div>
        {/* Mini radial arc via SVG */}
        <svg width="80" height="80" viewBox="0 0 80 80" className="shrink-0">
          <circle cx="40" cy="40" r="32" fill="none" stroke="#e2e8f0" strokeWidth="6" />
          <circle
            cx="40" cy="40" r="32" fill="none"
            strokeWidth="6" strokeLinecap="round"
            stroke="currentColor"
            className={cfg.color}
            strokeDasharray={`${2 * Math.PI * 32}`}
            strokeDashoffset={`${2 * Math.PI * 32 * (1 - pct / 100)}`}
            transform="rotate(-90 40 40)"
            style={{ transition: 'stroke-dashoffset 1s ease-out' }}
          />
          <text x="40" y="45" textAnchor="middle" className={`text-xs font-bold fill-current ${cfg.color}`} style={{ fontSize: 13, fontWeight: 700 }}>
            {pct.toFixed(0)}%
          </text>
        </svg>
      </div>

      {/* Stats row */}
      <div className="grid grid-cols-4 divide-x divide-slate-100">
        {[
          { label: 'Correct',   value: result.correct_count, color: 'text-emerald-600' },
          { label: 'Incorrect', value: incorrect,             color: 'text-rose-500' },
          { label: 'Total Qs',  value: result.total_questions, color: 'text-slate-900' },
          { label: 'Duration',  value: duration(result.started_at, result.ended_at), color: 'text-slate-700' },
        ].map((s) => (
          <div key={s.label} className="px-4 py-4 text-center">
            <div className={`text-xl font-extrabold ${s.color}`}>{s.value}</div>
            <div className="text-xs text-slate-400 font-medium mt-0.5">{s.label}</div>
          </div>
        ))}
      </div>

      {result.interruption_count > 0 && (
        <div className="px-4 py-2.5 bg-amber-50 border-t border-amber-100 flex items-center gap-2">
          <svg className="w-3.5 h-3.5 text-amber-500 shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" /></svg>
          <p className="text-xs text-amber-700 font-medium">
            {result.interruption_count} tab switch{result.interruption_count > 1 ? 'es' : ''} detected during this session.
          </p>
        </div>
      )}
    </div>
  );
}
