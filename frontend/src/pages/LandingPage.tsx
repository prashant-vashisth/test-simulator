import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { useAuthStore } from '../store/authStore';
import { childService } from '../services/childService';
import { ParentLogin } from '../components/auth/ParentLogin';
import { ChildSelector } from '../components/auth/ChildSelector';

export function LandingPage() {
  const navigate = useNavigate();
  const { isAuthenticated, selectedChild, login, logout, selectChild } = useAuthStore();

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
      <ParentLogin
        onSuccess={() => login('JaiShriRam@01')}
      />
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
