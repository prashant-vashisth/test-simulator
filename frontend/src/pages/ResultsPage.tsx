import { useNavigate } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { useTestStore } from '../store/testStore';
import { useAuthStore } from '../store/authStore';
import { sessionService } from '../services/sessionService';
import { childService } from '../services/childService';
import { ScoreSummary } from '../components/results/ScoreSummary';
import { TopicPerformancePanel } from '../components/results/TopicPerformance';
import { AttemptHistory } from '../components/results/AttemptHistory';
import { WritingFeedback } from '../components/results/WritingFeedback';
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

  // Review mode
  if (showReview && result.questions.length > 0) {
    const qr: QuestionResult = result.questions[reviewIndex];
    const isWriting = qr.question_type === 'open_ended';

    const asQuestion = {
      id: qr.question_id,
      topic_id: '',
      grade_id: '',
      test_type_id: '',
      question_text: qr.question_text,
      passage: qr.passage,
      image_url: null,
      question_type: qr.question_type as 'single_choice' | 'multiple_choice' | 'open_ended',
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
      <div className="min-h-screen bg-slate-50">
        {/* Review header */}
        <header className="bg-white border-b border-slate-200 sticky top-0 z-10 shadow-sm">
          <div className="max-w-2xl mx-auto px-6 py-4 flex items-center justify-between">
            <div>
              <h2 className="font-display text-lg font-bold text-slate-900">Review Answers</h2>
              <p className="text-xs text-slate-400 mt-0.5">{reviewIndex + 1} of {result.questions.length} questions</p>
            </div>
            <button
              onClick={() => setShowReview(false)}
              className="flex items-center gap-1.5 text-sm font-medium text-slate-500 hover:text-brand-600 transition-colors"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
              </svg>
              Back to results
            </button>
          </div>
        </header>

        <div className="max-w-2xl mx-auto px-4 sm:px-6 py-6 space-y-4 pb-16">
          <div className="bg-white rounded-2xl shadow-card border border-slate-100 p-6">
            {isWriting ? (
              <div className="space-y-4">
                <div className="bg-brand-50 border border-brand-200 rounded-xl p-4">
                  <p className="font-semibold text-brand-800 text-xs uppercase tracking-wide mb-1.5">Writing Prompt</p>
                  <p className="text-slate-800 text-sm leading-relaxed">{qr.question_text}</p>
                </div>
                {qr.writing_response && (
                  <div className="bg-slate-50 border border-slate-200 rounded-xl p-4">
                    <p className="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-1.5">Your Response</p>
                    <p className="text-sm text-slate-700 leading-relaxed whitespace-pre-wrap">{qr.writing_response}</p>
                  </div>
                )}
                <WritingFeedback feedback={qr.groq_feedback as Parameters<typeof WritingFeedback>[0]['feedback']} />
              </div>
            ) : (
              <>
                <div className="flex items-center gap-2 mb-4 text-sm font-semibold">
                  {qr.is_correct
                    ? <span className="text-emerald-700 bg-emerald-50 border border-emerald-200 px-3 py-1 rounded-full">✓ Correct</span>
                    : <span className="text-red-600 bg-red-50 border border-red-200 px-3 py-1 rounded-full">✗ Incorrect</span>}
                </div>
                <QuestionCard
                  question={asQuestion}
                  questionNumber={reviewIndex + 1}
                  selectedOptionIds={qr.selected_option_ids}
                  isReview
                  showTTS={false}
                  onToggleOption={() => null}
                />
              </>
            )}
          </div>

          <div className="flex items-center justify-between gap-3">
            <Button variant="secondary" onClick={() => setReviewIndex(Math.max(0, reviewIndex - 1))} disabled={reviewIndex === 0}>← Prev</Button>
            <div className="flex gap-1">
              {result.questions.map((_, idx) => (
                <button
                  key={idx}
                  onClick={() => setReviewIndex(idx)}
                  className={`w-2 h-2 rounded-full transition-all ${idx === reviewIndex ? 'bg-brand-600 scale-125' : 'bg-slate-300 hover:bg-slate-400'}`}
                />
              ))}
            </div>
            <Button onClick={() => setReviewIndex(Math.min(result.questions.length - 1, reviewIndex + 1))} disabled={reviewIndex === result.questions.length - 1}>Next →</Button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-50">
      {/* Header bar */}
      <header className="bg-white border-b border-slate-100 sticky top-0 z-10">
        <div className="max-w-3xl mx-auto px-6 py-4 flex items-center justify-between">
          <div>
            <h1 className="text-base font-bold text-slate-900">Session Complete</h1>
            <p className="text-xs text-slate-400 mt-0.5">
              {config?.testType.name} · {config?.subject.name} · {config?.grade.name}
            </p>
          </div>
          <span className="text-xs text-slate-400">
            {new Date(result.started_at).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })}
          </span>
        </div>
      </header>

      <div className="max-w-3xl mx-auto px-6 py-8 space-y-6 pb-16">
        <ScoreSummary result={result} childName={selectedChild.name} />
        <TopicPerformancePanel performances={topicPerf} recommendations={recommendations} />

        <button
          onClick={() => { setShowReview(true); setReviewIndex(0); }}
          className="w-full flex items-center justify-center gap-2 py-3 text-sm font-semibold text-brand-700 bg-white hover:bg-brand-50 rounded-xl border border-brand-200 hover:border-brand-300 transition-colors shadow-card"
        >
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
          </svg>
          Review Questions & Answers
        </button>

        <AttemptHistory sessions={sessions} />

        <div className="grid grid-cols-2 gap-3">
          <Button variant="secondary" size="lg" onClick={handleNewChild}>Switch Student</Button>
          <Button size="lg" onClick={handleRetry}>Practice Again →</Button>
        </div>
      </div>
    </div>
  );
}
