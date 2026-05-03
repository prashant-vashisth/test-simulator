import { useState } from 'react';
import { Button } from '../common/Button';

interface Props {
  onSuccess: () => void;
}

export function ParentLogin({ onSuccess }: Props) {
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [shake, setShake] = useState(false);
  const [showPw, setShowPw] = useState(false);

  const { login } = { login: (pw: string) => pw === 'JaiShriRam@01' };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (login(password)) {
      onSuccess();
    } else {
      setError('Incorrect password. Please try again.');
      setShake(true);
      setTimeout(() => setShake(false), 600);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-brand-50 via-white to-indigo-50 flex items-center justify-center p-4">
      <div className="w-full max-w-sm">
        <div className="text-center mb-8">
          <div className="text-6xl mb-3">🎓</div>
          <h1 className="font-display text-4xl font-black text-gray-900">Test Simulator</h1>
          <p className="text-gray-500 mt-2 font-body">Parent authentication required</p>
        </div>

        <form
          onSubmit={handleSubmit}
          className={`bg-white rounded-3xl shadow-xl p-8 border border-gray-100 ${shake ? 'animate-[wiggle_0.5s_ease-in-out]' : ''}`}
        >
          <label className="block mb-1 text-sm font-semibold text-gray-700">
            Parent Password
          </label>
          <div className="relative">
            <input
              type={showPw ? 'text' : 'password'}
              value={password}
              onChange={(e) => { setPassword(e.target.value); setError(''); }}
              placeholder="Enter password"
              autoFocus
              className="w-full border border-gray-300 rounded-xl px-4 py-3 pr-12 text-gray-900 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent transition"
            />
            <button
              type="button"
              onClick={() => setShowPw(!showPw)}
              className="absolute right-3 top-3 text-gray-400 hover:text-gray-600 transition"
              tabIndex={-1}
            >
              {showPw ? '🙈' : '👁️'}
            </button>
          </div>

          {error && (
            <p className="mt-2 text-sm text-red-600 font-medium">{error}</p>
          )}

          <Button type="submit" size="lg" fullWidth className="mt-5">
            Unlock →
          </Button>
        </form>

        <p className="text-center text-xs text-gray-400 mt-6">
          Vashisth Family Learning Platform
        </p>
      </div>

      <style>{`
        @keyframes wiggle {
          0%, 100% { transform: translateX(0); }
          20% { transform: translateX(-8px); }
          40% { transform: translateX(8px); }
          60% { transform: translateX(-6px); }
          80% { transform: translateX(6px); }
        }
      `}</style>
    </div>
  );
}
