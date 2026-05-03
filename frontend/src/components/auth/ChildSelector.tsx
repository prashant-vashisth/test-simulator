import type { Child } from '../../types';
import { Card } from '../common/Card';
import { Button } from '../common/Button';
import { LoadingSpinner } from '../common/LoadingSpinner';

interface Props {
  children: Child[];
  isLoading: boolean;
  onSelect: (child: Child) => void;
  onLogout: () => void;
}

const AVATAR_COLORS = [
  'from-pink-400 to-rose-500',
  'from-violet-400 to-purple-500',
  'from-blue-400 to-sky-500',
];

const AVATAR_EMOJIS = ['🌸', '⭐', '🚀'];

export function ChildSelector({ children, isLoading, onSelect, onLogout }: Props) {
  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-brand-50 via-white to-purple-50 flex items-center justify-center p-6">
      <div className="w-full max-w-2xl">
        <div className="text-center mb-10">
          <h2 className="font-display text-4xl font-black text-gray-900">Who's learning today?</h2>
          <p className="text-gray-500 mt-2">Select your name to begin</p>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
          {children.map((child, idx) => (
            <Card
              key={child.id}
              hover
              padding="lg"
              className="text-center group"
              onClick={() => onSelect(child)}
            >
              {child.avatar_url ? (
                <img
                  src={child.avatar_url}
                  alt={child.name}
                  className="w-24 h-24 rounded-full mx-auto object-cover shadow-md border-4 border-white group-hover:scale-105 transition-transform duration-200"
                />
              ) : (
                <div
                  className={`w-24 h-24 rounded-full mx-auto flex items-center justify-center text-4xl bg-gradient-to-br ${AVATAR_COLORS[idx % AVATAR_COLORS.length]} shadow-md group-hover:scale-105 transition-transform duration-200`}
                >
                  {AVATAR_EMOJIS[idx % AVATAR_EMOJIS.length]}
                </div>
              )}
              <h3 className="font-display text-xl font-bold text-gray-900 mt-4 leading-tight">
                {child.name.split(' ')[0]}
              </h3>
              <p className="text-sm text-gray-400 mt-0.5">{child.name}</p>
              <Button size="sm" className="mt-4 w-full" onClick={() => onSelect(child)}>
                Start →
              </Button>
            </Card>
          ))}
        </div>

        <div className="text-center mt-8">
          <button
            onClick={onLogout}
            className="text-sm text-gray-400 hover:text-gray-600 transition"
          >
            ← Switch parent account
          </button>
        </div>
      </div>
    </div>
  );
}
