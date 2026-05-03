import { clsx } from 'clsx';
import type { AnswerOption } from '../../types';

interface Props {
  option: AnswerOption;
  isSelected: boolean;
  isMultiple: boolean;
  isReview?: boolean;   // post-test review mode
  onToggle: (optionId: string) => void;
}

export function AnswerOptionItem({ option, isSelected, isMultiple, isReview, onToggle }: Props) {
  const correct = isReview && option.is_correct;
  const wrong   = isReview && isSelected && !option.is_correct;

  return (
    <button
      type="button"
      onClick={() => !isReview && onToggle(option.id)}
      disabled={isReview}
      className={clsx(
        'w-full text-left rounded-2xl border-2 px-5 py-3.5 transition-all duration-150 flex items-start gap-3 group',
        !isReview && 'hover:border-brand-400 hover:bg-brand-50 active:scale-[0.99]',
        isSelected && !isReview && 'border-brand-500 bg-brand-50 shadow-sm',
        !isSelected && !isReview && 'border-gray-200 bg-white',
        correct && 'border-green-500 bg-green-50',
        wrong   && 'border-red-400 bg-red-50',
        isReview && !correct && !wrong && 'border-gray-200 bg-white opacity-60',
      )}
    >
      {/* Circle / checkbox indicator */}
      <div className={clsx(
        'flex-shrink-0 mt-0.5 w-6 h-6 rounded-full border-2 flex items-center justify-center text-xs font-bold',
        isSelected && !isReview && 'border-brand-500 bg-brand-500 text-white',
        !isSelected && !isReview && 'border-gray-300 text-gray-400',
        correct && 'border-green-500 bg-green-500 text-white',
        wrong   && 'border-red-400 bg-red-400 text-white',
        isReview && !correct && !wrong && 'border-gray-300 text-gray-400',
      )}>
        {isReview
          ? (correct ? '✓' : wrong ? '✗' : option.option_label)
          : (isSelected ? (isMultiple ? '✓' : '●') : option.option_label)
        }
      </div>

      <span className={clsx(
        'text-sm font-medium leading-relaxed',
        isSelected && !isReview && 'text-brand-800',
        !isSelected && !isReview && 'text-gray-700',
        correct && 'text-green-800',
        wrong   && 'text-red-700',
        isReview && !correct && !wrong && 'text-gray-500',
      )}>
        {option.option_text}
      </span>
    </button>
  );
}
