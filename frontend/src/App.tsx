import { useEffect } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useAuthStore } from './store/authStore';
import { supabase } from './lib/supabase';
import { LandingPage } from './pages/LandingPage';
import { TestSelectionPage } from './pages/TestSelectionPage';
import { TestPage } from './pages/TestPage';
import { ResultsPage } from './pages/ResultsPage';
import { RegisterPage } from './pages/RegisterPage';
import { ChildLoginPage } from './pages/ChildLoginPage';
import { EmailVerificationPage } from './pages/EmailVerificationPage';
import { ChildDashboardPage } from './pages/ChildDashboardPage';
import { useKeepAlive } from './hooks/useKeepAlive';
import type { ReactNode } from 'react';

const queryClient = new QueryClient({
  defaultOptions: { queries: { retry: 2, staleTime: 30_000 } },
});

function ProtectedRoute({ children }: { children: ReactNode }) {
  const { isAuthenticated, selectedChild } = useAuthStore();
  if (!isAuthenticated) return <Navigate to="/" replace />;
  if (!selectedChild) return <Navigate to="/" replace />;
  return <>{children}</>;
}

function AuthRequired({ children }: { children: ReactNode }) {
  const { isAuthenticated, childSession } = useAuthStore();
  if (!isAuthenticated && !childSession) return <Navigate to="/" replace />;
  return <>{children}</>;
}

function ChildRoute({ children }: { children: ReactNode }) {
  const { childSession } = useAuthStore();
  if (!childSession) return <Navigate to="/child-login" replace />;
  return <>{children}</>;
}

function AppInner() {
  useKeepAlive();
  const { setChildSession, setChildProfile } = useAuthStore();

  // Restore Supabase session on app load and handle auth/callback
  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setChildSession(session);
    });
    const { data: listener } = supabase.auth.onAuthStateChange((_event, session) => {
      setChildSession(session);
      if (!session) setChildProfile(null);
    });
    return () => listener.subscription.unsubscribe();
  }, [setChildSession, setChildProfile]);

  return (
    <Routes>
      {/* ── Public ── */}
      <Route path="/" element={<LandingPage />} />
      <Route path="/register" element={<RegisterPage />} />
      <Route path="/child-login" element={<ChildLoginPage />} />
      <Route path="/verify-email" element={<EmailVerificationPage />} />
      {/* Supabase email confirmation redirect lands here */}
      <Route path="/auth/callback" element={<EmailVerificationPage />} />

      {/* ── Child self-auth routes ── */}
      <Route path="/dashboard" element={<ChildRoute><ChildDashboardPage /></ChildRoute>} />

      {/* ── Parent-managed routes ── */}
      <Route path="/select-test" element={<AuthRequired><TestSelectionPage /></AuthRequired>} />
      <Route path="/test" element={<ProtectedRoute><TestPage /></ProtectedRoute>} />
      <Route path="/results" element={<ProtectedRoute><ResultsPage /></ProtectedRoute>} />

      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        <AppInner />
      </BrowserRouter>
    </QueryClientProvider>
  );
}
