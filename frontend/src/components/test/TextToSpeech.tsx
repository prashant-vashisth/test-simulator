import { useTextToSpeech } from '../../hooks/useTextToSpeech';

interface Props {
  text: string;
  className?: string;
}

export function TextToSpeechButton({ text, className = '' }: Props) {
  const { speak, stop, isSupported } = useTextToSpeech();

  if (!isSupported) return null;

  return (
    <button
      type="button"
      onClick={() => speak(text)}
      onDoubleClick={stop}
      title="Listen to this question (double-click to stop)"
      className={`inline-flex items-center gap-1.5 text-brand-600 hover:text-brand-800 bg-brand-50 hover:bg-brand-100 rounded-lg px-2.5 py-1 text-sm font-medium transition-colors ${className}`}
    >
      <span className="text-base">🔊</span>
      <span>Listen</span>
    </button>
  );
}
