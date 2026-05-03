import { clsx } from 'clsx';
import type { SessionResult } from '../../types';

interface Props {
  result: SessionResult;
  childName: string;
}

function getScoreColor(pct: number) {
  if (pct >= 85) return 'text-green-600';
  if (pct >= 70) return 'text-brand-600';
  if (pct >= 50) return 'text-yellow-600';
  return 'text-red-600';
}

function getScoreEmoji(pct: number) {
  if (pct >= 90) return '🏆';
  if (pct >= 75) return '⭐';
  if (pct >= 60) return '👍';
  if (pct >= 40) return '📚';
  return '💪';
}

function getScoreMessage(pct: number) {
  if (pct >= 90) return 'Outstanding! You nailed it!';
  if (pct >= 75) return 'Great job! Keep it up!';
  if (pct >= 60) return 'Good work! A little more practice will help.';
  if (pct >= 40) return 'Keep practising — you\'re getting there!';
  return 'Don\'t give up! Review the topics and try again.';
}

const durationLabel = (startIso: string, endIso: string | null) => {
  if (!endIso) return 'N/A';
  const diff = Math.round((new Date(endIso).getTime() - new Date(startIso).getTime()) / 1000);
  const m = Math.floor(diff / 60);
  const s = diff % 60;
  return m > 0 ? `${m}m ${s}s` : `${s}s`;
};

export function ScoreSummary({ result, childName }: Props) {
  const pct = result.score_percentage ?? 0;

  return (
    <div className="bg-white rounded-3xl shadow-lg border border-gray-100 p-8 text-center space-y-4">
      <p className="text-gray-500 text-sm font-medium">Great effort, {childName.split(' ')[0]}!</p>

      <div className="text-7xl">{getScoreEmoji(pct)}</div>

      <div>
        <div className={clsx('font-display text-7xl font-black', getScoreColor(pct))}>
          {pct.toFixed(0)}%
        </div>
        <p className="text-gray-600 font-medium mt-1">{getScoreMessage(pct)}</p>
      </div>

      <div className="grid grid-cols-3 gap-4 pt-4 border-t border-gray-100">
        <div>
          <div className="text-2xl font-black text-green-600">{result.correct_count}</div>
          <div className="text-xs text-gray-500 font-medium mt-0.5">Correct</div>
        </div>
        <div>
          <div className="text-2xl font-black text-red-500">{result.total_questions - result.correct_count}</div>
          <div className="text-xs text-gray-500 font-medium mt-0.5">Incorrect</div>
        </div>
        <div>
          <div className="text-2xl font-black text-gray-700">
            {durationLabel(result.started_at, result.ended_at)}
          </div>
          <div className="text-xs text-gray-500 font-medium mt-0.5">Time taken</div>
        </div>
      </div>

      {result.interruption_count > 0 && (
        <p className="text-xs text-orange-600 bg-orange-50 rounded-xl px-3 py-2">
          ⚠️ {result.interruption_count} tab switch{result.interruption_count > 1 ? 'es' : ''} detected during this test.
        </p>
      )}
    </div>
  );
}
