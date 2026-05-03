interface Props {
  current: number;  // 1-based
  total: number;
  answeredCount: number;
}

export function ProgressBar({ current, total, answeredCount }: Props) {
  const pct = Math.round((answeredCount / total) * 100);

  return (
    <div className="space-y-1">
      <div className="flex justify-between text-xs font-semibold text-gray-500">
        <span>Question {current} of {total}</span>
        <span>{answeredCount} answered · {pct}%</span>
      </div>
      <div className="h-2.5 bg-gray-200 rounded-full overflow-hidden">
        <div
          className="h-full bg-gradient-to-r from-brand-500 to-indigo-500 rounded-full transition-all duration-500"
          style={{ width: `${pct}%` }}
        />
      </div>
    </div>
  );
}
