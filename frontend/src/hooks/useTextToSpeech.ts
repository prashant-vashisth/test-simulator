import { useCallback, useEffect, useRef } from 'react';

export function useTextToSpeech() {
  const utteranceRef = useRef<SpeechSynthesisUtterance | null>(null);

  const isSupported = typeof window !== 'undefined' && 'speechSynthesis' in window;

  const speak = useCallback((text: string) => {
    if (!isSupported) return;
    window.speechSynthesis.cancel();
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.rate = 0.85;
    utterance.pitch = 1;
    utterance.lang = 'en-US';
    // Prefer a clear US English voice when available
    const voices = window.speechSynthesis.getVoices();
    const preferred = voices.find(
      (v) => v.lang === 'en-US' && v.name.toLowerCase().includes('samantha'),
    ) ?? voices.find((v) => v.lang === 'en-US') ?? voices[0];
    if (preferred) utterance.voice = preferred;
    utteranceRef.current = utterance;
    window.speechSynthesis.speak(utterance);
  }, [isSupported]);

  const stop = useCallback(() => {
    if (isSupported) window.speechSynthesis.cancel();
  }, [isSupported]);

  useEffect(() => () => { if (isSupported) window.speechSynthesis.cancel(); }, [isSupported]);

  return { speak, stop, isSupported };
}
