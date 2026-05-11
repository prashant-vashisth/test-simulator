interface Props {
  current: number;
  total: number;
  answeredCount: number;
}

export function ProgressBar({ current, total, answeredCount }: Props) {
  const pct = Math.round((answeredCount / total) * 100);

  return (
    <div className="space-y-1.5">
      <div className="flex justify-between items-center">
        <span className="text-xs font-semibold text-slate-700">
          Question <span className="text-brand-600">{current}</span> / {total}
        </span>
        <span className="text-xs text-slate-400 font-medium">{answeredCount} answered</span>
      </div>
      <div className="h-1.5 bg-slate-100 rounded-full overflow-hidden">
        <div
          className="h-full bg-brand-600 rounded-full transition-all duration-500 ease-out"
          style={{ width: `${pct}%` }}
        />
      </div>
    </div>
  );
}
