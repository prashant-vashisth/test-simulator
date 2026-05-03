import { useNavigate } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { useTestStore } from '../store/testStore';
import { useAuthStore } from '../store/authStore';
import { sessionService } from '../services/sessionService';
import { childService } from '../services/childService';
import { ScoreSummary } from '../components/results/ScoreSummary';
import { TopicPerformancePanel } from '../components/results/TopicPerformance';
import { AttemptHistory } from '../components/results/AttemptHistory';
import { QuestionCard } from '../components/test/QuestionCard';
import { Button } from '../components/common/Button';
import { LoadingSpinner } from '../components/common/LoadingSpinner';
import type { QuestionResult } from '../types';
import { useState } from 'react';

export function ResultsPage() {
  const navigate = useNavigate();
  const { session, config, reset } = useTestStore();
  const { selectedChild, clearChild } = useAuthStore();
  const [showReview, setShowReview] = useState(false);
  const [reviewIndex, setReviewIndex] = useState(0);

  const { data: result, isLoading: loadingResult } = useQuery({
    queryKey: ['session-results', session?.id],
    queryFn: () => sessionService.getResults(session!.id),
    enabled: !!session,
    staleTime: Infinity,
  });

  const { data: sessions = [] } = useQuery({
    queryKey: ['child-sessions', selectedChild?.id],
    queryFn: () => childService.getSessions(selectedChild!.id),
    enabled: !!selectedChild,
    staleTime: 30_000,
  });

  const { data: topicPerf = [] } = useQuery({
    queryKey: ['topic-perf', selectedChild?.id, config?.subject.id, config?.grade.id],
    queryFn: () =>
      childService.getTopicPerformance(
        selectedChild!.id,
        config?.subject.id,
        config?.grade.id,
      ),
    enabled: !!selectedChild,
    staleTime: 30_000,
  });

  const { data: recommendations = [] } = useQuery({
    queryKey: ['recs', selectedChild?.id, config?.subject.id, config?.grade.id],
    queryFn: () =>
      childService.getRecommendations(
        selectedChild!.id,
        config?.subject.id,
        config?.grade.id,
      ),
    enabled: !!selectedChild,
    staleTime: 30_000,
  });

  if (!session || !selectedChild) {
    navigate('/');
    return null;
  }

  if (loadingResult) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  if (!result) return null;

  const handleRetry = () => {
    reset();
    navigate('/select-test');
  };

  const handleNewChild = () => {
    reset();
    clearChild();
    navigate('/');
  };

  // Review mode: show question as a read-only card
  if (showReview && result.questions.length > 0) {
    const qr: QuestionResult = result.questions[reviewIndex];
    const asQuestion = {
      id: qr.question_id,
      topic_id: '',
      grade_id: '',
      test_type_id: '',
      question_text: qr.question_text,
      passage: qr.passage,
      image_url: null,
      question_type: qr.question_type as 'single_choice' | 'multiple_choice',
      difficulty: qr.difficulty as 'easy' | 'medium' | 'hard',
      points: 1,
      explanation: qr.explanation,
      options: qr.options.map((o) => ({
        id: o.id,
        option_label: o.label,
        option_text: o.text,
        is_correct: o.is_correct,
        display_order: 0,
      })),
    };

    return (
      <div className="min-h-screen bg-gray-50 p-4 sm:p-8">
        <div className="max-w-2xl mx-auto">
          <div className="flex items-center justify-between mb-6">
            <h2 className="font-display text-2xl font-black text-gray-900">Review Answers</h2>
            <button onClick={() => setShowReview(false)} className="text-sm text-gray-400 hover:text-gray-600">
              ← Back to results
            </button>
          </div>

          <div className="bg-white rounded-3xl shadow-sm border border-gray-100 p-6 mb-4">
            <div className="flex items-center gap-2 mb-4 text-sm font-medium">
              {qr.is_correct
                ? <span className="text-green-600 bg-green-50 px-2.5 py-1 rounded-full">✓ Correct</span>
                : <span className="text-red-600 bg-red-50 px-2.5 py-1 rounded-full">✗ Incorrect</span>}
            </div>
            <QuestionCard
              question={asQuestion}
              questionNumber={reviewIndex + 1}
              selectedOptionIds={qr.selected_option_ids}
              isReview
              showTTS={false}
              onToggleOption={() => null}
            />
          </div>

          <div className="flex items-center justify-between">
            <Button variant="secondary" onClick={() => setReviewIndex(Math.max(0, reviewIndex - 1))} disabled={reviewIndex === 0}>← Prev</Button>
            <span className="text-sm text-gray-500">{reviewIndex + 1} / {result.questions.length}</span>
            <Button onClick={() => setReviewIndex(Math.min(result.questions.length - 1, reviewIndex + 1))} disabled={reviewIndex === result.questions.length - 1}>Next →</Button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-brand-50 to-indigo-50 p-4 sm:p-8">
      <div className="max-w-2xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="font-display text-3xl font-black text-gray-900">Test Complete!</h1>
            <p className="text-gray-500 text-sm mt-0.5">
              {config?.testType.name} · {config?.subject.name} · {config?.grade.name}
            </p>
          </div>
          <div className="text-right text-sm text-gray-400">
            {new Date(result.started_at).toLocaleDateString()}
          </div>
        </div>

        {/* Score */}
        <ScoreSummary result={result} childName={selectedChild.name} />

        {/* Topic performance + recommendations */}
        <TopicPerformancePanel performances={topicPerf} recommendations={recommendations} />

        {/* Question review button */}
        <button
          onClick={() => { setShowReview(true); setReviewIndex(0); }}
          className="w-full py-3 text-sm font-semibold text-brand-700 bg-brand-50 hover:bg-brand-100 rounded-2xl border border-brand-200 transition"
        >
          📖 Review All Questions & Answers
        </button>

        {/* Attempt history */}
        <AttemptHistory sessions={sessions} />

        {/* Actions */}
        <div className="grid grid-cols-2 gap-3 pb-8">
          <Button variant="secondary" size="lg" onClick={handleNewChild}>
            Switch Child
          </Button>
          <Button size="lg" onClick={handleRetry}>
            Try Again 🚀
          </Button>
        </div>
      </div>
    </div>
  );
}
