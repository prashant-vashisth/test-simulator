import { Link } from 'react-router-dom';
import type { ReactNode } from 'react';

interface Props {
  children: ReactNode;
  heading: string;
  subheading: string;
  quote?: string;
  quoteAuthor?: string;
}

export function AuthLayout({ children, heading, subheading, quote, quoteAuthor }: Props) {
  return (
    <div className="min-h-screen flex">
      {/* ── Left panel ── */}
      <div className="hidden lg:flex lg:w-5/12 xl:w-2/5 flex-col bg-gradient-to-br from-brand-900 via-brand-800 to-slate-900 p-12 justify-between">
        <Link to="/" className="flex items-center gap-2.5">
          <div className="w-8 h-8 rounded-lg bg-white/15 flex items-center justify-center text-white font-black text-sm">A</div>
          <span className="font-bold text-white text-lg tracking-tight">AcademIQ</span>
        </Link>

        <div>
          <div className="text-4xl font-extrabold text-white leading-snug mb-4">{heading}</div>
          <p className="text-brand-200 text-base leading-relaxed">{subheading}</p>

          <div className="mt-10 space-y-3">
            {[
              'Adaptive K–12 practice questions',
              'NWEA MAP, Math & Science Olympiad',
              'AI-powered writing coaching',
              'Track progress over time',
            ].map((item) => (
              <div key={item} className="flex items-center gap-2.5 text-sm text-brand-100">
                <svg className="w-4 h-4 text-brand-400 shrink-0" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                </svg>
                {item}
              </div>
            ))}
          </div>

          {quote && (
            <blockquote className="mt-12 border-l-2 border-brand-500 pl-4">
              <p className="text-brand-100 text-sm italic leading-relaxed">"{quote}"</p>
              {quoteAuthor && <cite className="text-brand-400 text-xs font-medium not-italic mt-1 block">— {quoteAuthor}</cite>}
            </blockquote>
          )}
        </div>

        <p className="text-brand-600 text-xs">© {new Date().getFullYear()} AcademIQ. All rights reserved.</p>
      </div>

      {/* ── Right panel ── */}
      <div className="flex-1 flex flex-col justify-center px-6 py-12 sm:px-12 lg:px-16 bg-white">
        {/* Mobile logo */}
        <div className="lg:hidden mb-8">
          <Link to="/" className="flex items-center gap-2">
            <div className="w-7 h-7 rounded bg-brand-600 flex items-center justify-center text-white font-black text-xs">A</div>
            <span className="font-bold text-slate-900">AcademIQ</span>
          </Link>
        </div>
        <div className="max-w-sm w-full mx-auto">
          {children}
        </div>
      </div>
    </div>
  );
}
