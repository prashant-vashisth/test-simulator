import { type ButtonHTMLAttributes, forwardRef } from 'react';
import { clsx } from 'clsx';

type Variant = 'primary' | 'secondary' | 'ghost' | 'danger' | 'success';
type Size = 'sm' | 'md' | 'lg' | 'xl';

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  size?: Size;
  loading?: boolean;
  fullWidth?: boolean;
}

const variantClasses: Record<Variant, string> = {
  primary:   'bg-brand-600 hover:bg-brand-700 text-white border border-brand-600 shadow-sm shadow-brand-100',
  secondary: 'bg-white hover:bg-slate-50 text-slate-700 border border-slate-200 hover:border-slate-300',
  ghost:     'bg-transparent hover:bg-slate-100 text-slate-600 border border-transparent',
  danger:    'bg-rose-600 hover:bg-rose-700 text-white border border-rose-600',
  success:   'bg-emerald-600 hover:bg-emerald-700 text-white border border-emerald-600',
};

const sizeClasses: Record<Size, string> = {
  sm:  'px-3 py-1.5 text-xs font-semibold rounded-lg gap-1.5',
  md:  'px-4 py-2.5 text-sm font-semibold rounded-lg gap-2',
  lg:  'px-5 py-3 text-sm font-semibold rounded-xl gap-2',
  xl:  'px-6 py-3.5 text-base font-semibold rounded-xl gap-2',
};

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ variant = 'primary', size = 'md', loading, fullWidth, className, children, disabled, ...rest }, ref) => (
    <button
      ref={ref}
      disabled={disabled || loading}
      className={clsx(
        'inline-flex items-center justify-center transition-all duration-150',
        'focus:outline-none focus:ring-2 focus:ring-brand-500 focus:ring-offset-1',
        'disabled:opacity-50 disabled:cursor-not-allowed active:scale-[0.98]',
        variantClasses[variant],
        sizeClasses[size],
        fullWidth && 'w-full',
        className,
      )}
      {...rest}
    >
      {loading && (
        <svg className="animate-spin w-4 h-4 shrink-0" fill="none" viewBox="0 0 24 24">
          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
        </svg>
      )}
      {children}
    </button>
  ),
);
Button.displayName = 'Button';
