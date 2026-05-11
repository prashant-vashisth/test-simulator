import { useEffect } from 'react';
import api from '../services/api';

const INTERVAL_MS = 4 * 60 * 1000; // 4 minutes — stays within 5-min Render free-tier sleep window

export function useKeepAlive() {
  useEffect(() => {
    const ping = () => api.get('/health').catch(() => {});
    const id = setInterval(ping, INTERVAL_MS);
    return () => clearInterval(id);
  }, []);
}
