import { useState, useEffect, useRef } from 'react';

interface WritingEditorProps {
  prompt: string;
  passage?: string | null;
  grade?: string;
  onSubmit: (response: string) => void;
  disabled?: boolean;
}

function wordCount(text: string) {
  return text.trim() ? text.trim().split(/\s+/).length : 0;
}

function minWordsForGrade(grade?: string): number {
  if (!grade) return 30;
  const level = parseInt(grade, 10);
  if (isNaN(level)) return 20; // Kindergarten
  if (level <= 2) return 20;
  if (level <= 4) return 50;
  if (level <= 6) return 80;
  if (level <= 8) return 120;
  return 150;
}

export function WritingEditor({ prompt, passage, grade, onSubmit, disabled }: WritingEditorProps) {
  const [text, setText] = useState('');
  const textareaRef = useRef<HTMLTextAreaElement>(null);
  const words = wordCount(text);
  const minWords = minWordsForGrade(grade);
  const canSubmit = words >= minWords && !disabled;

  // Auto-resize textarea
  useEffect(() => {
    const el = textareaRef.current;
    if (el) {
      el.style.height = 'auto';
      el.style.height = `${Math.max(180, el.scrollHeight)}px`;
    }
  }, [text]);

  return (
    <div className="space-y-4">
      {passage && (
        <div className="bg-amber-50 border border-amber-200 rounded-xl p-4 text-sm text-slate-700 leading-relaxed">
          <p className="font-semibold text-amber-800 mb-1 text-xs uppercase tracking-wide">Reading Passage</p>
          {passage}
        </div>
      )}

      <div className="bg-brand-50 border border-brand-200 rounded-xl p-4">
        <p className="font-semibold text-brand-800 text-sm mb-1">Writing Prompt</p>
        <p className="text-slate-800 text-sm leading-relaxed">{prompt}</p>
      </div>

      <div>
        <textarea
          ref={textareaRef}
          value={text}
          onChange={(e) => setText(e.target.value)}
          disabled={disabled}
          placeholder={`Write your response here… (aim for at least ${minWords} words)`}
          className="w-full border-2 border-slate-200 focus:border-brand-400 rounded-xl px-4 py-3 text-sm leading-relaxed resize-none focus:outline-none transition-colors disabled:bg-slate-50"
          style={{ minHeight: 180 }}
        />
        <div className="flex items-center justify-between mt-1 px-1">
          <span className={`text-xs ${words >= minWords ? 'text-green-600 font-medium' : 'text-slate-400'}`}>
            {words} {words === 1 ? 'word' : 'words'}
            {words < minWords && ` (${minWords - words} more to go)`}
          </span>
          {words >= minWords && (
            <span className="text-xs text-green-600">✓ Ready to submit</span>
          )}
        </div>
      </div>

      <button
        onClick={() => canSubmit && onSubmit(text)}
        disabled={!canSubmit}
        className="w-full py-3 rounded-xl font-semibold text-white transition-all bg-brand-600 hover:bg-brand-700 disabled:opacity-40 disabled:cursor-not-allowed"
      >
        {disabled ? 'Submitted' : 'Submit Writing'}
      </button>
    </div>
  );
}
