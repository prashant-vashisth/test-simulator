import { useEffect, useState, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useQuery, useMutation } from '@tanstack/react-query';
import { useTestStore } from '../store/testStore';
import { useAuthStore } from '../store/authStore';
import { useFullscreen } from '../hooks/useFullscreen';
import { useTabVisibility } from '../hooks/useTabVisibility';
import { useTimer } from '../hooks/useTimer';
import { sessionService } from '../services/sessionService';
import { QuestionCard } from '../components/test/QuestionCard';
import { ProgressBar } from '../components/test/ProgressBar';
import { Timer } from '../components/test/Timer';
import { InterruptionWarning } from '../components/test/InterruptionWarning';
import { Button } from '../components/common/Button';
import { LoadingSpinner } from '../components/common/LoadingSpinner';

const MAX_INTERRUPTIONS = 3;

export function TestPage() {
  const navigate = useNavigate();
  useAuthStore();
  const {
    session, questions, currentIndex, answers,
    setQuestions, recordAnswer, goToNext, goToPrev, goToIndex, startQuestionTimer, incrementInterruption,
  } = useTestStore();

  const { isFullscreen, enter: enterFullscreen, exit: exitFullscreen } = useFullscreen();
  const { formattedTime, pause: pauseTimer } = useTimer();

  const [showInterruption, setShowInterruption] = useState(false);
  const [localInterruptions, setLocalInterruptions] = useState(0);
  const [hasEnteredFullscreen, setHasEnteredFullscreen] = useState(false);

  // Redirect if no session
  useEffect(() => {
    if (!session) navigate('/select-test');
  }, [session, navigate]);

  // Load questions
  const { isLoading, data: questionData } = useQuery({
    queryKey: ['session-questions', session?.id],
    queryFn: () => sessionService.getQuestions(session!.id),
    enabled: !!session,
    staleTime: Infinity,
  });

  useEffect(() => {
    if (questionData && questionData.length > 0) {
      setQuestions(questionData);
      startQuestionTimer();
    }
  }, [questionData]); // eslint-disable-line react-hooks/exhaustive-deps

  // Fullscreen on mount
  useEffect(() => {
    if (!hasEnteredFullscreen) {
      enterFullscreen().then(() => setHasEnteredFullscreen(true));
    }
  }, [enterFullscreen, hasEnteredFullscreen]);

  const handleInterruption = useCallback(() => {
    const newCount = localInterruptions + 1;
    setLocalInterruptions(newCount);
    incrementInterruption();
    if (session?.id) {
      sessionService.recordInterruption(session.id).catch(() => null);
    }
    setShowInterruption(true);
    pauseTimer();
  }, [localInterruptions, incrementInterruption, session?.id, pauseTimer]);

  useTabVisibility({
    onLeave: handleInterruption,
    enabled: !!session && !showInterruption,
  });

  const submitAnswer = useMutation({
    mutationFn: ({ questionId, optionIds, timeTaken }: { questionId: string; optionIds: string[]; timeTaken: number }) =>
      sessionService.submitAnswer(session!.id, {
        question_id: questionId,
        selected_option_ids: optionIds,
        time_taken_seconds: timeTaken,
      }),
  });

  const completeSession = useMutation({
    mutationFn: () => sessionService.completeSession(session!.id),
    onSuccess: () => {
      exitFullscreen();
      navigate('/results');
    },
  });

  const abandonSession = useMutation({
    mutationFn: () => sessionService.abandonSession(session!.id),
    onSuccess: () => {
      exitFullscreen();
      navigate('/results');
    },
  });

  if (!session || isLoading || questions.length === 0) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="text-center space-y-3">
          <LoadingSpinner size="lg" />
          <p className="text-gray-500 font-medium">Loading your test…</p>
        </div>
      </div>
    );
  }

  const currentQuestion = questions[currentIndex];
  const selectedIds = answers[currentQuestion?.id]?.selectedOptionIds ?? [];
  const answeredCount = Object.keys(answers).length;
  const isLastQuestion = currentIndex === questions.length - 1;
  // Show TTS for Kindergarten through 2nd grade (level 0–2)
  const { config } = useTestStore();
  const showTTS = (config?.grade.level ?? 99) <= 2;

  const handleToggleOption = (optionId: string) => {
    const isMultiple = currentQuestion.question_type === 'multiple_choice';
    let newSelected: string[];
    if (isMultiple) {
      newSelected = selectedIds.includes(optionId)
        ? selectedIds.filter((id) => id !== optionId)
        : [...selectedIds, optionId];
    } else {
      newSelected = [optionId];
    }
    recordAnswer(currentQuestion.id, newSelected);
    submitAnswer.mutate({
      questionId: currentQuestion.id,
      optionIds: newSelected,
      timeTaken: answers[currentQuestion.id]?.timeTakenSeconds ?? 0,
    });
  };

  const handleFinish = () => {
    completeSession.mutate();
  };

  const forceAbandon = () => {
    abandonSession.mutate();
  };

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col select-none">
      {/* Top bar */}
      <div className="bg-white border-b border-gray-200 px-4 sm:px-6 py-3 flex items-center justify-between gap-4 sticky top-0 z-10">
        <div className="flex-1 max-w-lg">
          <ProgressBar
            current={currentIndex + 1}
            total={questions.length}
            answeredCount={answeredCount}
          />
        </div>
        <div className="flex items-center gap-3">
          <Timer formattedTime={formattedTime} />
          {!isFullscreen && (
            <button
              onClick={enterFullscreen}
              className="text-xs bg-yellow-100 text-yellow-800 px-2.5 py-1.5 rounded-lg font-medium hover:bg-yellow-200 transition"
            >
              ⛶ Fullscreen
            </button>
          )}
        </div>
      </div>

      {/* Main content */}
      <div className="flex-1 overflow-y-auto px-4 sm:px-6 py-6 max-w-2xl mx-auto w-full">
        {currentQuestion && (
          <QuestionCard
            question={currentQuestion}
            questionNumber={currentIndex + 1}
            selectedOptionIds={selectedIds}
            showTTS={showTTS}
            onToggleOption={handleToggleOption}
          />
        )}
      </div>

      {/* Question nav grid (compact) */}
      <div className="bg-white border-t border-gray-100 px-4 py-2 overflow-x-auto">
        <div className="flex gap-1.5 items-center min-w-max mx-auto max-w-2xl">
          {questions.map((q, idx) => {
            const answered = !!answers[q.id];
            const isCurrent = idx === currentIndex;
            return (
              <button
                key={q.id}
                onClick={() => goToIndex(idx)}
                className={`w-8 h-8 rounded-lg text-xs font-bold transition-all ${
                  isCurrent
                    ? 'bg-brand-600 text-white ring-2 ring-brand-400 ring-offset-1'
                    : answered
                    ? 'bg-green-100 text-green-700 hover:bg-green-200'
                    : 'bg-gray-100 text-gray-500 hover:bg-gray-200'
                }`}
              >
                {idx + 1}
              </button>
            );
          })}
        </div>
      </div>

      {/* Bottom nav */}
      <div className="bg-white border-t border-gray-200 px-4 sm:px-6 py-4 flex items-center justify-between gap-3">
        <Button
          variant="secondary"
          onClick={goToPrev}
          disabled={currentIndex === 0}
        >
          ← Prev
        </Button>

        <div className="flex items-center gap-2">
          {isLastQuestion ? (
            <Button
              size="lg"
              onClick={handleFinish}
              loading={completeSession.isPending}
              className="px-8"
            >
              Submit Test ✓
            </Button>
          ) : (
            <Button onClick={goToNext}>
              Next →
            </Button>
          )}
        </div>
      </div>

      {/* Interruption modal */}
      {showInterruption && (
        <InterruptionWarning
          count={localInterruptions}
          onResume={() => {
            if (localInterruptions >= MAX_INTERRUPTIONS) {
              forceAbandon();
            } else {
              setShowInterruption(false);
              enterFullscreen();
            }
          }}
          onAbandon={forceAbandon}
        />
      )}
    </div>
  );
}
