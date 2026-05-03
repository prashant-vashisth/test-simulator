import { Modal } from '../common/Modal';
import { Button } from '../common/Button';

const MAX_INTERRUPTIONS = 3;

interface Props {
  count: number;
  onResume: () => void;
  onAbandon: () => void;
}

export function InterruptionWarning({ count, onResume, onAbandon }: Props) {
  const remaining = MAX_INTERRUPTIONS - count;
  const isFinal = remaining <= 0;

  return (
    <Modal open size="sm">
      <div className="text-center space-y-4">
        <div className="text-5xl">{isFinal ? '🛑' : '⚠️'}</div>
        <h3 className="font-display text-2xl font-black text-gray-900">
          {isFinal ? 'Test Stopped' : 'Stay Focused!'}
        </h3>
        <p className="text-gray-600 text-sm leading-relaxed">
          {isFinal
            ? 'You left the test window too many times. The test has been stopped. Your progress has been saved.'
            : `You switched away from the test. This is warning ${count} of ${MAX_INTERRUPTIONS}. ${remaining} warning${remaining !== 1 ? 's' : ''} left before the test stops.`
          }
        </p>

        {!isFinal && (
          <Button onClick={onResume} fullWidth size="lg">
            Resume Test
          </Button>
        )}
        <Button variant={isFinal ? 'primary' : 'ghost'} onClick={onAbandon} fullWidth size={isFinal ? 'lg' : 'md'}>
          {isFinal ? 'View My Score' : 'End Test Early'}
        </Button>
      </div>
    </Modal>
  );
}
