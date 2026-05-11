import { useEffect } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { useAuthStore } from '../store/authStore';
import { childService } from '../services/childService';
import { ParentLogin } from '../components/auth/ParentLogin';
import { ChildSelector } from '../components/auth/ChildSelector';

export function LandingPage() {
  const navigate = useNavigate();
  const { isAuthenticated, selectedChild, childSession, login, logout, selectChild } = useAuthStore();

  // Redirect child if already logged in
  useEffect(() => {
    if (childSession) navigate('/dashboard');
  }, [childSession, navigate]);

  const { data: children = [], isLoading } = useQuery({
    queryKey: ['children'],
    queryFn: childService.listChildren,
    enabled: isAuthenticated,
    staleTime: 5 * 60 * 1000,
  });

  useEffect(() => {
    if (isAuthenticated && selectedChild) {
      navigate('/select-test');
    }
  }, [isAuthenticated, selectedChild, navigate]);

  if (!isAuthenticated) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-indigo-50 to-purple-50 flex flex-col items-center justify-center p-4 gap-6">
        <ParentLogin onSuccess={() => login('JaiShriRam@01')} />
        <div className="w-full max-w-sm">
          <div className="relative flex items-center my-2">
            <div className="flex-grow border-t border-gray-200" />
            <span className="mx-3 text-xs text-gray-400 uppercase tracking-wide">or</span>
            <div className="flex-grow border-t border-gray-200" />
          </div>
          <div className="bg-white rounded-2xl shadow p-5 text-center space-y-3">
            <p className="text-sm font-medium text-gray-700">Student? Sign in or create your account.</p>
            <div className="grid grid-cols-2 gap-2">
              <Link
                to="/child-login"
                className="py-2.5 rounded-xl bg-indigo-600 text-white text-sm font-semibold hover:bg-indigo-700 transition text-center"
              >
                Sign In
              </Link>
              <Link
                to="/register"
                className="py-2.5 rounded-xl border-2 border-indigo-600 text-indigo-600 text-sm font-semibold hover:bg-indigo-50 transition text-center"
              >
                Register
              </Link>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <ChildSelector
      children={children}
      isLoading={isLoading}
      onSelect={(child) => {
        selectChild(child);
        navigate('/select-test');
      }}
      onLogout={logout}
    />
  );
}
