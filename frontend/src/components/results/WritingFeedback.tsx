interface ScoreSection {
  score: number | null;
  issues?: string[];
  suggestions?: string[];
  strengths?: string[];
  improvements?: string[];
  feedback?: string;
}

interface GroqFeedback {
  overall_score: number | null;
  grammar: ScoreSection;
  vocabulary: ScoreSection;
  content: ScoreSection;
  structure: ScoreSection;
  overall_feedback: string;
  next_steps: string[];
}

function ScoreBar({ score }: { score: number | null }) {
  if (score === null) return <span className="text-xs text-gray-400">N/A</span>;
  const pct = (score / 10) * 100;
  const color = score >= 8 ? 'bg-green-500' : score >= 6 ? 'bg-yellow-400' : 'bg-red-400';
  return (
    <div className="flex items-center gap-2">
      <div className="flex-1 bg-gray-100 rounded-full h-2">
        <div className={`${color} h-2 rounded-full transition-all`} style={{ width: `${pct}%` }} />
      </div>
      <span className="text-xs font-semibold text-gray-600 w-8 text-right">{score}/10</span>
    </div>
  );
}

function BulletList({ items, color }: { items: string[]; color: string }) {
  if (!items?.length) return null;
  return (
    <ul className="mt-1 space-y-0.5">
      {items.map((item, i) => (
        <li key={i} className={`text-xs ${color} flex gap-1`}>
          <span>•</span><span>{item}</span>
        </li>
      ))}
    </ul>
  );
}

export function WritingFeedback({ feedback }: { feedback: GroqFeedback | null | undefined }) {
  if (!feedback) {
    return (
      <div className="bg-gray-50 rounded-xl p-4 text-sm text-gray-400 text-center">
        Writing feedback not available.
      </div>
    );
  }

  const sections = [
    { key: 'grammar',    label: 'Grammar',    data: feedback.grammar },
    { key: 'vocabulary', label: 'Vocabulary', data: feedback.vocabulary },
    { key: 'content',    label: 'Content',    data: feedback.content },
    { key: 'structure',  label: 'Structure',  data: feedback.structure },
  ] as const;

  return (
    <div className="space-y-4">
      {/* Overall score */}
      <div className="bg-indigo-50 border border-indigo-200 rounded-xl p-4 flex items-center gap-4">
        {feedback.overall_score !== null ? (
          <div className="text-center min-w-[4rem]">
            <div className="text-3xl font-bold text-indigo-700">{feedback.overall_score}</div>
            <div className="text-xs text-indigo-500">/ 10</div>
          </div>
        ) : (
          <div className="text-2xl">✍️</div>
        )}
        <p className="text-sm text-gray-700 leading-relaxed">{feedback.overall_feedback}</p>
      </div>

      {/* Section scores */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
        {sections.map(({ key, label, data }) => (
          <div key={key} className="bg-white border border-gray-100 rounded-xl p-3">
            <div className="flex items-center justify-between mb-1">
              <span className="text-xs font-semibold text-gray-600 uppercase tracking-wide">{label}</span>
            </div>
            <ScoreBar score={data?.score ?? null} />
            {data?.issues && <BulletList items={data.issues} color="text-red-500" />}
            {data?.suggestions && <BulletList items={data.suggestions} color="text-blue-500" />}
            {data?.strengths && <BulletList items={data.strengths} color="text-green-600" />}
            {data?.improvements && <BulletList items={data.improvements} color="text-amber-600" />}
            {data?.feedback && <p className="text-xs text-gray-500 mt-1">{data.feedback}</p>}
          </div>
        ))}
      </div>

      {/* Next steps */}
      {feedback.next_steps?.length > 0 && (
        <div className="bg-blue-50 border border-blue-200 rounded-xl p-4">
          <p className="text-xs font-semibold text-blue-700 uppercase tracking-wide mb-2">Next Steps</p>
          <ul className="space-y-1">
            {feedback.next_steps.map((step, i) => (
              <li key={i} className="text-sm text-blue-800 flex gap-2">
                <span className="text-blue-400 font-bold">{i + 1}.</span>
                <span>{step}</span>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}
