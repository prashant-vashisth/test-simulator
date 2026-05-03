import { type ReactNode } from 'react';
import { clsx } from 'clsx';

interface Props {
  open: boolean;
  title?: string;
  children: ReactNode;
  onClose?: () => void;
  size?: 'sm' | 'md' | 'lg';
}

const sizeClasses = { sm: 'max-w-sm', md: 'max-w-md', lg: 'max-w-lg' };

export function Modal({ open, title, children, onClose, size = 'md' }: Props) {
  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
      <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" onClick={onClose} />
      <div
        className={clsx(
          'relative w-full bg-white rounded-3xl shadow-2xl p-6 animate-slide-up',
          sizeClasses[size],
        )}
      >
        {title && (
          <h2 className="font-display text-xl font-bold text-gray-900 mb-4">{title}</h2>
        )}
        {children}
      </div>
    </div>
  );
}
