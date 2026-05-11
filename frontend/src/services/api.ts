/// <reference types="vite/client" />
import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL ?? '',
  timeout: 15_000,
  headers: { 'Content-Type': 'application/json' },
});

// Inject Supabase child JWT when a child session exists
api.interceptors.request.use((config) => {
  // Dynamic import avoids circular dependency (authStore imports api)
  try {
    const raw = localStorage.getItem('ts-auth');
    if (raw) {
      const state = JSON.parse(raw);
      const token = state?.state?.childSession?.access_token;
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
    }
  } catch {
    // Silently ignore — parent-flow requests don't need a JWT
  }
  return config;
});

export default api;
