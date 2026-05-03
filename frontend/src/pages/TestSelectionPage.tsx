import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useQuery, useMutation } from '@tanstack/react-query';
import { useAuthStore } from '../store/authStore';
import { useTestStore } from '../store/testStore';
import { catalogueService } from '../services/catalogueService';
import { sessionService } from '../services/sessionService';
import { Card } from '../components/common/Card';
import { Button } from '../components/common/Button';
import { LoadingSpinner } from '../components/common/LoadingSpinner';
import type { TestType, Subject, Grade } from '../types';

const DIFFICULTY_OPTIONS = [
  { value: 'easy',   label: 'Easy',   emoji: '🌱', desc: 'Foundational questions' },
  { value: 'medium', label: 'Medium', emoji: '⚡', desc: 'Standard grade level' },
  { value: 'hard',   label: 'Hard',   emoji: '🔥', desc: 'Challenge yourself!' },
] as const;

const QUESTION_COUNT_OPTIONS = [10, 20, 30, 42, 50];

export function TestSelectionPage() {
  const navigate = useNavigate();
  const { selectedChild } = useAuthStore();
  const { setConfig, setSession, reset } = useTestStore();

  const [selectedTestType, setSelectedTestType] = useState<TestType | null>(null);
  const [selectedSubject, setSelectedSubject] = useState<Subject | null>(null);
  const [selectedGrade, setSelectedGrade] = useState<Grade | null>(null);
  const [difficulty, setDifficulty] = useState<'easy' | 'medium' | 'hard'>('medium');
  const [numQuestions, setNumQuestions] = useState(30);

  const { data: testTypes = [], isLoading: loadingTypes } = useQuery({
    queryKey: ['test-types'],
    queryFn: catalogueService.getTestTypes,
    staleTime: Infinity,
  });

  const { data: grades = [] } = useQuery({
    queryKey: ['grades', selectedTestType?.id],
    queryFn: () => catalogueService.getGrades(selectedTestType?.id),
    enabled: !!selectedTestType,
    staleTime: Infinity,
  });

  const { data: subjects = [] } = useQuery({
    queryKey: ['subjects', selectedTestType?.id],
    queryFn: () => catalogueService.getSubjects(selectedTestType?.id),
    enabled: !!selectedTestType,
    staleTime: Infinity,
  });

  const createSession = useMutation({
    mutationFn: sessionService.createSession,
    onSuccess: (session) => {
      setSession(session);
      navigate('/test');
    },
  });

  if (!selectedChild) {
    navigate('/');
    return null;
  }

  const canStart = selectedTestType && selectedSubject && selectedGrade;

  const handleStart = () => {
    if (!canStart) return;
    reset();
    setConfig({
      child: selectedChild,
      testType: selectedTestType,
      subject: selectedSubject,
      grade: selectedGrade,
      difficulty,
      numQuestions,
    });
    createSession.mutate({
      child_id: selectedChild.id,
      test_type_id: selectedTestType.id,
      subject_id: selectedSubject.id,
      grade_id: selectedGrade.id,
      difficulty,
      num_questions: numQuestions,
    });
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-brand-50 to-indigo-50 p-4 sm:p-8">
      <div className="max-w-3xl mx-auto">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="font-display text-3xl font-black text-gray-900">Choose Your Test</h1>
            <p className="text-gray-500 mt-0.5">Hi {selectedChild.name.split(' ')[0]}! What are we practising today?</p>
          </div>
          <button
            onClick={() => navigate('/')}
            className="text-sm text-gray-400 hover:text-gray-600 transition"
          >
            ← Back
          </button>
        </div>

        <div className="space-y-6">
          {/* Step 1: Test Type */}
          <section>
            <h2 className="font-semibold text-gray-700 mb-3 text-sm uppercase tracking-wide">1 · Select Test Type</h2>
            {loadingTypes ? (
              <div className="flex justify-center py-8"><LoadingSpinner /></div>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                {testTypes.map((tt) => (
                  <Card
                    key={tt.id}
                    hover
                    selected={selectedTestType?.id === tt.id}
                    padding="md"
                    className="text-center"
                    onClick={() => {
                      setSelectedTestType(tt);
                      setSelectedSubject(null);
                      setSelectedGrade(null);
                    }}
                  >
                    <div className="text-3xl mb-2">{tt.icon ?? '📋'}</div>
                    <div className="font-display font-bold text-gray-900 text-sm">{tt.name}</div>
                    {tt.description && (
                      <div className="text-xs text-gray-400 mt-1 leading-snug">{tt.description}</div>
                    )}
                  </Card>
                ))}
              </div>
            )}
          </section>

          {/* Step 2: Subject */}
          {selectedTestType && subjects.length > 0 && (
            <section className="animate-fade-in">
              <h2 className="font-semibold text-gray-700 mb-3 text-sm uppercase tracking-wide">2 · Select Subject</h2>
              <div className="flex flex-wrap gap-2">
                {subjects.map((s) => (
                  <button
                    key={s.id}
                    onClick={() => setSelectedSubject(s)}
                    className={`px-4 py-2 rounded-xl text-sm font-semibold transition-all ${
                      selectedSubject?.id === s.id
                        ? 'bg-brand-600 text-white shadow-md'
                        : 'bg-white text-gray-700 border border-gray-200 hover:border-brand-400'
                    }`}
                  >
                    {s.name}
                  </button>
                ))}
              </div>
            </section>
          )}

          {/* Step 3: Grade */}
          {selectedTestType && grades.length > 0 && (
            <section className="animate-fade-in">
              <h2 className="font-semibold text-gray-700 mb-3 text-sm uppercase tracking-wide">3 · Select Grade</h2>
              <div className="flex flex-wrap gap-2">
                {grades.map((g) => (
                  <button
                    key={g.id}
                    onClick={() => setSelectedGrade(g)}
                    className={`px-3.5 py-2 rounded-xl text-sm font-bold transition-all min-w-[3rem] ${
                      selectedGrade?.id === g.id
                        ? 'bg-indigo-600 text-white shadow-md'
                        : 'bg-white text-gray-700 border border-gray-200 hover:border-indigo-400'
                    }`}
                  >
                    {g.code === 'K' ? 'K' : `${g.level}`}
                  </button>
                ))}
              </div>
            </section>
          )}

          {/* Step 4: Difficulty */}
          <section>
            <h2 className="font-semibold text-gray-700 mb-3 text-sm uppercase tracking-wide">4 · Difficulty Level</h2>
            <div className="grid grid-cols-3 gap-3">
              {DIFFICULTY_OPTIONS.map((opt) => (
                <Card
                  key={opt.value}
                  hover
                  selected={difficulty === opt.value}
                  padding="sm"
                  className="text-center cursor-pointer"
                  onClick={() => setDifficulty(opt.value)}
                >
                  <div className="text-2xl mb-1">{opt.emoji}</div>
                  <div className="font-bold text-sm text-gray-800">{opt.label}</div>
                  <div className="text-xs text-gray-400 mt-0.5">{opt.desc}</div>
                </Card>
              ))}
            </div>
          </section>

          {/* Step 5: Number of questions */}
          <section>
            <h2 className="font-semibold text-gray-700 mb-3 text-sm uppercase tracking-wide">5 · Number of Questions</h2>
            <div className="flex flex-wrap gap-2">
              {QUESTION_COUNT_OPTIONS.map((n) => (
                <button
                  key={n}
                  onClick={() => setNumQuestions(n)}
                  className={`px-4 py-2 rounded-xl text-sm font-bold transition-all ${
                    numQuestions === n
                      ? 'bg-gray-900 text-white shadow-md'
                      : 'bg-white text-gray-700 border border-gray-200 hover:border-gray-400'
                  }`}
                >
                  {n} Qs
                </button>
              ))}
            </div>
          </section>

          {/* Start button */}
          {createSession.isError && (
            <p className="text-red-600 text-sm bg-red-50 rounded-xl px-4 py-3">
              {(createSession.error as Error)?.message ?? 'Could not start the test. Make sure questions are loaded for this configuration.'}
            </p>
          )}

          <Button
            size="xl"
            fullWidth
            disabled={!canStart}
            loading={createSession.isPending}
            onClick={handleStart}
          >
            🚀 Start Test
          </Button>

          {!canStart && (
            <p className="text-center text-sm text-gray-400">
              Please select a test type, subject, and grade to continue.
            </p>
          )}
        </div>
      </div>
    </div>
  );
}
