import type { Question } from '../../types';
import { AnswerOptionItem } from './AnswerOption';
import { TextToSpeechButton } from './TextToSpeech';
import { clsx } from 'clsx';

const DIFFICULTY_BADGE: Record<string, string> = {
  easy:   'bg-green-100 text-green-700',
  medium: 'bg-yellow-100 text-yellow-700',
  hard:   'bg-red-100 text-red-700',
};

interface Props {
  question: Question;
  questionNumber: number;
  selectedOptionIds: string[];
  isReview?: boolean;
  showTTS: boolean;
  onToggleOption: (optionId: string) => void;
}

export function QuestionCard({
  question,
  questionNumber,
  selectedOptionIds,
  isReview,
  showTTS,
  onToggleOption,
}: Props) {
  const ttsText = [
    question.passage,
    `Question ${questionNumber}: ${question.question_text}`,
    question.question_type === 'multiple_choice' ? 'Select all that apply.' : '',
    ...question.options.map((o) => `Option ${o.option_label}: ${o.option_text}`),
  ]
    .filter(Boolean)
    .join('. ');

  return (
    <div className="animate-fade-in space-y-5">
      {/* Passage / reading context */}
      {question.passage && (
        <div className="bg-amber-50 border border-amber-200 rounded-2xl p-5 text-slate-700 text-sm leading-relaxed max-h-52 overflow-y-auto font-body">
          <p className="font-semibold text-amber-800 mb-2 text-xs uppercase tracking-wide">Read the passage below</p>
          {question.passage}
        </div>
      )}

      {/* Question header */}
      <div className="space-y-3">
        <div className="flex items-center gap-2 flex-wrap">
          <span className="text-xs font-bold text-slate-400">Q{questionNumber}</span>
          <span className={clsx('text-xs font-semibold px-2 py-0.5 rounded-full', DIFFICULTY_BADGE[question.difficulty])}>
            {question.difficulty}
          </span>
          {question.question_type === 'multiple_choice' && (
            <span className="text-xs bg-purple-100 text-purple-700 font-semibold px-2 py-0.5 rounded-full">
              Select all that apply
            </span>
          )}
          {showTTS && <TextToSpeechButton text={ttsText} />}
        </div>

        <p className="text-slate-900 text-lg font-semibold leading-relaxed font-display">
          {question.question_text}
        </p>

        {question.image_url && (
          <img
            src={question.image_url}
            alt="Question illustration"
            className="rounded-xl max-h-56 object-contain border border-slate-200"
          />
        )}
      </div>

      {/* Answer options */}
      <div className="space-y-2.5">
        {question.options.map((option) => (
          <AnswerOptionItem
            key={option.id}
            option={option}
            isSelected={selectedOptionIds.includes(option.id)}
            isMultiple={question.question_type === 'multiple_choice'}
            isReview={isReview}
            onToggle={onToggleOption}
          />
        ))}
      </div>

      {/* Post-review explanation */}
      {isReview && question.explanation && (
        <div className="bg-blue-50 border border-blue-200 rounded-2xl px-5 py-4 text-sm text-blue-800">
          <span className="font-bold">💡 Explanation: </span>
          {question.explanation}
        </div>
      )}
    </div>
  );
}
