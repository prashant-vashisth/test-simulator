import { useCallback, useEffect, useState } from 'react';

export function useFullscreen() {
  const [isFullscreen, setIsFullscreen] = useState(false);

  const enter = useCallback(async () => {
    try {
      await document.documentElement.requestFullscreen({ navigationUI: 'hide' });
    } catch {
      // Browser may block initial fullscreen without user gesture – handled in UI
    }
  }, []);

  const exit = useCallback(async () => {
    if (document.fullscreenElement) {
      await document.exitFullscreen();
    }
  }, []);

  useEffect(() => {
    const onChange = () => setIsFullscreen(!!document.fullscreenElement);
    document.addEventListener('fullscreenchange', onChange);
    return () => document.removeEventListener('fullscreenchange', onChange);
  }, []);

  return { isFullscreen, enter, exit };
}
