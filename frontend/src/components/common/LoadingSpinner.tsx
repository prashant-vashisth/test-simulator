import { clsx } from 'clsx';

interface Props { size?: 'sm' | 'md' | 'lg'; className?: string; }

const sizes = { sm: 'h-4 w-4', md: 'h-8 w-8', lg: 'h-14 w-14' };

export function LoadingSpinner({ size = 'md', className }: Props) {
  return (
    <svg
      className={clsx('animate-spin text-brand-600', sizes[size], className)}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
    >
      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z" />
    </svg>
  );
}
