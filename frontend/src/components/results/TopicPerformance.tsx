import { clsx } from 'clsx';
import type { TopicPerformance } from '../../types';

interface Props {
  performances: TopicPerformance[];
  recommendations: string[];
}

function AccuracyBar({ pct }: { pct: number }) {
  const color = pct >= 80 ? 'bg-green-500' : pct >= 60 ? 'bg-yellow-400' : 'bg-red-400';
  return (
    <div className="h-2 bg-gray-100 rounded-full overflow-hidden flex-1">
      <div
        className={clsx('h-full rounded-full transition-all duration-700', color)}
        style={{ width: `${pct}%` }}
      />
    </div>
  );
}

export function TopicPerformancePanel({ performances, recommendations }: Props) {
  if (performances.length === 0) return null;

  return (
    <div className="space-y-5">
      {/* Recommendations */}
      {recommendations.length > 0 && (
        <div className="bg-indigo-50 border border-indigo-200 rounded-2xl p-5">
          <h3 className="font-display font-bold text-indigo-900 mb-3">📋 Recommendations</h3>
          <ul className="space-y-2">
            {recommendations.map((rec, i) => (
              <li key={i} className="flex items-start gap-2 text-sm text-indigo-800">
                <span className="mt-0.5">•</span>
                <span>{rec}</span>
              </li>
            ))}
          </ul>
        </div>
      )}

      {/* Per-topic breakdown */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
        <h3 className="font-display font-bold text-gray-900 mb-4">Topic Breakdown</h3>
        <div className="space-y-3">
          {performances
            .sort((a, b) => a.accuracy_percent - b.accuracy_percent)
            .map((p) => (
              <div key={p.topic_id} className="space-y-1">
                <div className="flex items-center justify-between text-sm">
                  <span className="font-medium text-gray-700 truncate max-w-xs">{p.topic_name}</span>
                  <span className={clsx(
                    'font-bold text-xs ml-2',
                    p.accuracy_percent >= 80 ? 'text-green-600' :
                    p.accuracy_percent >= 60 ? 'text-yellow-600' : 'text-red-500',
                  )}>
                    {p.accuracy_percent.toFixed(0)}%
                  </span>
                </div>
                <div className="flex items-center gap-2">
                  <AccuracyBar pct={p.accuracy_percent} />
                  <span className="text-xs text-gray-400 w-14 text-right">
                    {p.correct_attempts}/{p.total_attempts}
                  </span>
                </div>
              </div>
            ))}
        </div>
      </div>
    </div>
  );
}
