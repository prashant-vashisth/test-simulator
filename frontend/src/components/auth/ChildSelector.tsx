import type { Child } from '../../types';
import { LoadingSpinner } from '../common/LoadingSpinner';

interface Props {
  children: Child[];
  isLoading: boolean;
  onSelect: (child: Child) => void;
  onLogout: () => void;
}

const AVATAR_BG = ['bg-brand-100 text-brand-700', 'bg-violet-100 text-violet-700', 'bg-emerald-100 text-emerald-700'];

export function ChildSelector({ children, isLoading, onSelect, onLogout }: Props) {
  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-slate-50">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-50 flex items-center justify-center p-6">
      <div className="w-full max-w-3xl">
        {/* Header */}
        <div className="flex items-center justify-between mb-10">
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-lg bg-brand-600 flex items-center justify-center text-white font-black text-sm">A</div>
            <span className="font-bold text-slate-900 text-lg">AcademIQ</span>
          </div>
          <button onClick={onLogout} className="text-xs text-slate-400 hover:text-slate-600 font-medium transition-colors">
            Sign out
          </button>
        </div>

        <div className="mb-8">
          <h1 className="text-2xl font-bold text-slate-900">Select a student</h1>
          <p className="text-slate-500 text-sm mt-1">Choose a name to begin a practice session.</p>
        </div>

        <div className="grid sm:grid-cols-3 gap-4">
          {children.map((child, idx) => (
            <button
              key={child.id}
              onClick={() => onSelect(child)}
              className="group bg-white border border-slate-200 rounded-xl p-6 text-left hover:border-brand-300 hover:shadow-card-md transition-all focus:outline-none focus:ring-2 focus:ring-brand-500"
            >
              <div className={`w-12 h-12 rounded-xl flex items-center justify-center text-lg font-bold mb-4 ${AVATAR_BG[idx % AVATAR_BG.length]} group-hover:scale-105 transition-transform`}>
                {child.avatar_url
                  ? <img src={child.avatar_url} alt={child.name} className="w-full h-full rounded-xl object-cover" />
                  : child.name.charAt(0).toUpperCase()
                }
              </div>
              <p className="font-bold text-slate-900 text-sm">{child.name}</p>
              <p className="text-xs text-slate-400 mt-0.5 mb-4">Student account</p>
              <span className="inline-flex items-center gap-1 text-xs font-semibold text-brand-600 group-hover:gap-2 transition-all">
                Start session
                <svg className="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 8l4 4m0 0l-4 4m4-4H3" />
                </svg>
              </span>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}
