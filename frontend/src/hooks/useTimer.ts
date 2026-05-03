import { useEffect, useRef, useState } from 'react';

interface UseTimerOptions {
  autoStart?: boolean;
}

export function useTimer({ autoStart = true }: UseTimerOptions = {}) {
  const [elapsedSeconds, setElapsedSeconds] = useState(0);
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const startedAtRef = useRef<number | null>(null);

  const start = () => {
    if (intervalRef.current) return;
    startedAtRef.current = Date.now() - elapsedSeconds * 1000;
    intervalRef.current = setInterval(() => {
      setElapsedSeconds(Math.floor((Date.now() - (startedAtRef.current ?? Date.now())) / 1000));
    }, 1000);
  };

  const pause = () => {
    if (intervalRef.current) {
      clearInterval(intervalRef.current);
      intervalRef.current = null;
    }
  };

  const reset = () => {
    pause();
    setElapsedSeconds(0);
    startedAtRef.current = null;
  };

  useEffect(() => {
    if (autoStart) start();
    return () => pause();
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const format = (secs: number) => {
    const m = Math.floor(secs / 60).toString().padStart(2, '0');
    const s = (secs % 60).toString().padStart(2, '0');
    return `${m}:${s}`;
  };

  return { elapsedSeconds, formattedTime: format(elapsedSeconds), start, pause, reset };
}
