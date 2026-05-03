import { useEffect, useRef } from 'react';

interface Options {
  onLeave: () => void;
  enabled: boolean;
}

/**
 * Fires `onLeave` whenever the user navigates away from the tab or window
 * while the test is in progress. Tracks both Page Visibility API and blur.
 * Deduplicates rapid consecutive firings with a 1-second cooldown.
 */
export function useTabVisibility({ onLeave, enabled }: Options) {
  const lastFiredRef = useRef<number>(0);

  useEffect(() => {
    if (!enabled) return;

    const fire = () => {
      const now = Date.now();
      if (now - lastFiredRef.current < 1000) return; // debounce
      lastFiredRef.current = now;
      onLeave();
    };

    const onVisibilityChange = () => {
      if (document.hidden) fire();
    };

    const onBlur = () => fire();

    // Prevent common keyboard escape routes
    const onKeyDown = (e: KeyboardEvent) => {
      const blocked = (
        (e.ctrlKey && ['w', 't', 'n', 'Tab'].includes(e.key)) ||
        (e.altKey && e.key === 'Tab') ||
        e.key === 'Escape' ||
        e.key === 'F11'
      );
      if (blocked) {
        e.preventDefault();
        e.stopPropagation();
      }
    };

    const onContextMenu = (e: MouseEvent) => e.preventDefault();

    document.addEventListener('visibilitychange', onVisibilityChange);
    window.addEventListener('blur', onBlur);
    document.addEventListener('keydown', onKeyDown, { capture: true });
    document.addEventListener('contextmenu', onContextMenu);

    return () => {
      document.removeEventListener('visibilitychange', onVisibilityChange);
      window.removeEventListener('blur', onBlur);
      document.removeEventListener('keydown', onKeyDown, { capture: true });
      document.removeEventListener('contextmenu', onContextMenu);
    };
  }, [onLeave, enabled]);
}
