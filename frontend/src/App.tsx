import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useAuthStore } from './store/authStore';
import { LandingPage } from './pages/LandingPage';
import { TestSelectionPage } from './pages/TestSelectionPage';
import { TestPage } from './pages/TestPage';
import { ResultsPage } from './pages/ResultsPage';
import type { ReactNode } from 'react';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 2,
      staleTime: 30_000,
    },
  },
});

function ProtectedRoute({ children }: { children: ReactNode }) {
  const { isAuthenticated, selectedChild } = useAuthStore();
  if (!isAuthenticated) return <Navigate to="/" replace />;
  if (!selectedChild) return <Navigate to="/" replace />;
  return <>{children}</>;
}

function AuthRequired({ children }: { children: ReactNode }) {
  const { isAuthenticated } = useAuthStore();
  if (!isAuthenticated) return <Navigate to="/" replace />;
  return <>{children}</>;
}

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<LandingPage />} />
          <Route
            path="/select-test"
            element={
              <AuthRequired>
                <TestSelectionPage />
              </AuthRequired>
            }
          />
          <Route
            path="/test"
            element={
              <ProtectedRoute>
                <TestPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/results"
            element={
              <ProtectedRoute>
                <ResultsPage />
              </ProtectedRoute>
            }
          />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </BrowserRouter>
    </QueryClientProvider>
  );
}
