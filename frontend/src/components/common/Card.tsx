import { type HTMLAttributes } from 'react';
import { clsx } from 'clsx';

interface CardProps extends HTMLAttributes<HTMLDivElement> {
  hover?: boolean;
  selected?: boolean;
  padding?: 'none' | 'sm' | 'md' | 'lg';
}

const paddingClasses = { none: '', sm: 'p-3', md: 'p-5', lg: 'p-8' };

export function Card({ hover, selected, padding = 'md', className, children, ...rest }: CardProps) {
  return (
    <div
      className={clsx(
        'bg-white rounded-2xl border transition-all duration-200',
        hover && 'cursor-pointer hover:shadow-lg hover:-translate-y-0.5',
        selected
          ? 'border-brand-500 shadow-md ring-2 ring-brand-400 ring-offset-1'
          : 'border-gray-200 shadow-sm',
        paddingClasses[padding],
        className,
      )}
      {...rest}
    >
      {children}
    </div>
  );
}
