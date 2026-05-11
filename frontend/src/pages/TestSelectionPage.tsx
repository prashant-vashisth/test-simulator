import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useQuery, useMutation } from '@tanstack/react-query';
import { useAuthStore } from '../store/authStore';
import { useTestStore } from '../store/testStore';
import { catalogueService } from '../services/catalogueService';
import { sessionService } from '../services/sessionService';
import { Button } from '../components/common/Button';
import { LoadingSpinner } from '../components/common/LoadingSpinner';
import type { TestType, Subject, Grade } from '../types';

const DIFFICULTY_OPTIONS = [
  { value: 'easy',   label: 'Foundation',  desc: 'Core concepts, confidence-building',  color: 'border-emerald-200 bg-emerald-50 text-emerald-800', active: 'border-emerald-500 bg-emerald-100 ring-2 ring-emerald-400' },
  { value: 'medium', label: 'Standard',    desc: 'Grade-level, exam-style questions',    color: 'border-amber-200 bg-amber-50 text-amber-800',     active: 'border-amber-500 bg-amber-100 ring-2 ring-amber-400' },
  { value: 'hard',   label: 'Advanced',    desc: 'Challenge problems, deep mastery',     color: 'border-rose-200 bg-rose-50 text-rose-800',        active: 'border-rose-500 bg-rose-100 ring-2 ring-rose-400' },
] as const;

const QUESTION_COUNTS = [10, 20, 30, 42, 50];

const STEPS = ['Test Type', 'Subject', 'Grade', 'Difficulty', 'Questions'];

export function TestSelectionPage() {
  const navigate = useNavigate();
  const { selectedChild, childProfile } = useAuthStore();
  const { setConfig, setSession, reset } = useTestStore();

  const child = selectedChild ?? childProfile;

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
    onSuccess: (session) => { setSession(session); navigate('/test'); },
  });

  if (!child) { navigate('/'); return null; }

  const completedSteps = [
    !!selectedTestType,
    !!selectedSubject,
    !!selectedGrade,
    true, // difficulty always selected
    true, // question count always selected
  ];
  const canStart = selectedTestType && selectedSubject && selectedGrade;

  const handleStart = () => {
    if (!canStart) return;
    reset();
    setConfig({ child, testType: selectedTestType, subject: selectedSubject, grade: selectedGrade, difficulty, numQuestions });
    createSession.mutate({
      child_id: child.id,
      test_type_id: selectedTestType.id,
      subject_id: selectedSubject.id,
      grade_id: selectedGrade.id,
      difficulty,
      num_questions: numQuestions,
    });
  };

  return (
    <div className="min-h-screen bg-slate-50">
      {/* Nav */}
      <header className="bg-white border-b border-slate-100 sticky top-0 z-10">
        <div className="max-w-4xl mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link to={child === childProfile ? '/dashboard' : '/'} className="text-slate-400 hover:text-slate-600 transition-colors">
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
              </svg>
            </Link>
            <div>
              <h1 className="text-base font-bold text-slate-900">Configure Practice Session</h1>
              <p className="text-xs text-slate-400">Hi {child.name.split(' ')[0]}! Select your test configuration below.</p>
            </div>
          </div>
          {/* Step indicator */}
          <div className="hidden sm:flex items-center gap-1">
            {STEPS.map((step, i) => (
              <div key={step} className="flex items-center gap-1">
                <div className={`w-5 h-5 rounded-full flex items-center justify-center text-xs font-bold transition-colors ${
                  completedSteps[i] ? 'bg-brand-600 text-white' : 'bg-slate-100 text-slate-400'
                }`}>{i + 1}</div>
                {i < STEPS.length - 1 && <div className={`w-4 h-px ${completedSteps[i] ? 'bg-brand-300' : 'bg-slate-200'}`} />}
              </div>
            ))}
          </div>
        </div>
      </header>

      <div className="max-w-4xl mx-auto px-6 py-8 space-y-8">

        {/* Step 1 */}
        <section>
          <p className="label-xs mb-3">Step 1 · Test Format</p>
          {loadingTypes ? (
            <div className="flex items-center gap-2 text-sm text-slate-400 py-4"><LoadingSpinner size="sm" /> Loading…</div>
          ) : (
            <div className="grid sm:grid-cols-3 gap-3">
              {testTypes.map((tt) => (
                <button
                  key={tt.id}
                  onClick={() => { setSelectedTestType(tt); setSelectedSubject(null); setSelectedGrade(null); }}
                  className={`text-left p-4 rounded-xl border-2 transition-all ${
                    selectedTestType?.id === tt.id
                      ? 'border-brand-500 bg-brand-50 shadow-sm ring-1 ring-brand-300'
                      : 'border-slate-200 bg-white hover:border-slate-300 hover:shadow-sm'
                  }`}
                >
                  <div className="text-2xl mb-2">{tt.icon ?? '📋'}</div>
                  <div className="font-semibold text-slate-900 text-sm">{tt.name}</div>
                  {tt.description && <div className="text-xs text-slate-400 mt-1 leading-snug line-clamp-2">{tt.description}</div>}
                </button>
              ))}
            </div>
          )}
        </section>

        {/* Step 2 */}
        {selectedTestType && subjects.length > 0 && (
          <section className="animate-fade-in">
            <p className="label-xs mb-3">Step 2 · Subject</p>
            <div className="flex flex-wrap gap-2">
              {subjects.map((s) => (
                <button
                  key={s.id}
                  onClick={() => setSelectedSubject(s)}
                  className={`px-4 py-2 rounded-lg text-sm font-semibold border transition-all ${
                    selectedSubject?.id === s.id
                      ? 'bg-brand-600 text-white border-brand-600 shadow-sm'
                      : 'bg-white text-slate-700 border-slate-200 hover:border-brand-300 hover:text-brand-700'
                  }`}
                >
                  {s.name}
                </button>
              ))}
            </div>
          </section>
        )}

        {/* Step 3 */}
        {selectedTestType && grades.length > 0 && (
          <section className="animate-fade-in">
            <p className="label-xs mb-3">Step 3 · Grade Level</p>
            <div className="flex flex-wrap gap-2">
              {grades.map((g) => (
                <button
                  key={g.id}
                  onClick={() => setSelectedGrade(g)}
                  className={`min-w-[2.75rem] px-3 py-2 rounded-lg text-sm font-bold border transition-all ${
                    selectedGrade?.id === g.id
                      ? 'bg-slate-900 text-white border-slate-900 shadow-sm'
                      : 'bg-white text-slate-700 border-slate-200 hover:border-slate-400'
                  }`}
                >
                  {g.code === 'K' ? 'K' : g.level}
                </button>
              ))}
            </div>
          </section>
        )}

        {/* Step 4 */}
        <section>
          <p className="label-xs mb-3">Step 4 · Difficulty</p>
          <div className="grid sm:grid-cols-3 gap-3">
            {DIFFICULTY_OPTIONS.map((opt) => (
              <button
                key={opt.value}
                onClick={() => setDifficulty(opt.value)}
                className={`text-left p-4 rounded-xl border-2 transition-all ${
                  difficulty === opt.value ? opt.active : opt.color + ' hover:opacity-80'
                }`}
              >
                <div className="font-bold text-sm mb-0.5">{opt.label}</div>
                <div className="text-xs opacity-70">{opt.desc}</div>
              </button>
            ))}
          </div>
        </section>

        {/* Step 5 */}
        <section>
          <p className="label-xs mb-3">Step 5 · Number of Questions</p>
          <div className="flex flex-wrap gap-2">
            {QUESTION_COUNTS.map((n) => (
              <button
                key={n}
                onClick={() => setNumQuestions(n)}
                className={`px-5 py-2.5 rounded-lg text-sm font-bold border transition-all ${
                  numQuestions === n
                    ? 'bg-slate-900 text-white border-slate-900 shadow-sm'
                    : 'bg-white text-slate-600 border-slate-200 hover:border-slate-400'
                }`}
              >
                {n}
              </button>
            ))}
          </div>
          <p className="text-xs text-slate-400 mt-2">Estimated time: ~{Math.round(numQuestions * 1.5)} minutes</p>
        </section>

        {/* CTA */}
        {createSession.isError && (
          <div className="flex items-start gap-2 bg-rose-50 border border-rose-200 rounded-xl px-4 py-3">
            <svg className="w-4 h-4 text-rose-500 mt-0.5 shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" /></svg>
            <p className="text-sm text-rose-700">No questions found for this configuration. Please check that questions are loaded for this subject and grade.</p>
          </div>
        )}

        <div className="pb-8">
          <Button
            size="xl" fullWidth
            disabled={!canStart}
            loading={createSession.isPending}
            onClick={handleStart}
            className="text-base"
          >
            {createSession.isPending ? 'Starting session…' : 'Start Practice Session →'}
          </Button>
          {!canStart && (
            <p className="text-center text-xs text-slate-400 mt-3">
              Complete steps 1–3 to begin
            </p>
          )}
        </div>
      </div>
    </div>
  );
}
