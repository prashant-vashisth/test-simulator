import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useQuery, useMutation } from '@tanstack/react-query';
import { useAuthStore } from '../store/authStore';
import { useTestStore } from '../store/testStore';
import { catalogueService } from '../services/catalogueService';
import { sessionService } from '../services/sessionService';
import type { Subject, Grade } from '../types';

// ── Fixed IDs from seed_data.sql ─────────────────────────────────────────────
const NWEA_ID   = '22222222-0000-0000-0000-000000000001';
const MATH_OLY  = '22222222-0000-0000-0000-000000000002';
const SCI_OLY   = '22222222-0000-0000-0000-000000000003';

const CORE_SUBJECT_CODES = ['math', 'english_reading', 'english_writing'];

const SUBJECT_STYLE: Record<string, { icon: string; color: string; ring: string; bg: string; activeBg: string }> = {
  math:            { icon: '🔢', color: 'text-blue-700',   ring: 'ring-blue-400',   bg: 'bg-blue-50 border-blue-200',   activeBg: 'bg-blue-600 border-blue-600 text-white' },
  english_reading: { icon: '📖', color: 'text-emerald-700',ring: 'ring-emerald-400',bg: 'bg-emerald-50 border-emerald-200', activeBg: 'bg-emerald-600 border-emerald-600 text-white' },
  english_writing: { icon: '✍️', color: 'text-violet-700', ring: 'ring-violet-400', bg: 'bg-violet-50 border-violet-200',  activeBg: 'bg-violet-600 border-violet-600 text-white' },
};

const EXAM_META: Record<string, { icon: string; title: string; subtitle: string; color: string; activeBg: string }> = {
  [MATH_OLY]: { icon: '🏆', title: 'Math Olympiad', subtitle: 'Grades 3–12 · Algebra, Geometry, Competition Math', color: 'text-amber-700', activeBg: 'bg-amber-500 text-white border-amber-500' },
  [SCI_OLY]:  { icon: '🔬', title: 'Science Olympiad', subtitle: 'Grades 3–12 · Life, Earth, Physical & Engineering', color: 'text-teal-700', activeBg: 'bg-teal-600 text-white border-teal-600' },
};

const DIFFICULTY = [
  { value: 'easy',   label: 'Foundation', desc: 'Core concepts', bg: 'bg-emerald-50 border-emerald-200 text-emerald-800', active: 'bg-emerald-500 border-emerald-500 text-white' },
  { value: 'medium', label: 'Standard',   desc: 'Grade level',   bg: 'bg-amber-50 border-amber-200 text-amber-800',     active: 'bg-amber-500 border-amber-500 text-white' },
  { value: 'hard',   label: 'Advanced',   desc: 'Challenge',     bg: 'bg-rose-50 border-rose-200 text-rose-800',         active: 'bg-rose-500 border-rose-500 text-white' },
] as const;

const Q_COUNTS = [10, 20, 30, 42, 50];

// ── Shared sub-components ─────────────────────────────────────────────────────

function SectionLabel({ step, label }: { step: number; label: string }) {
  return (
    <div className="flex items-center gap-2 mb-3">
      <span className="w-5 h-5 rounded-full bg-brand-600 text-white text-xs font-bold flex items-center justify-center shrink-0">{step}</span>
      <span className="text-xs font-semibold text-slate-500 uppercase tracking-widest">{label}</span>
    </div>
  );
}

function DifficultyPicker({ value, onChange }: { value: string; onChange: (v: string) => void }) {
  return (
    <div className="grid grid-cols-3 gap-3">
      {DIFFICULTY.map((d) => (
        <button
          key={d.value}
          onClick={() => onChange(d.value)}
          className={`p-3 rounded-xl border-2 text-left transition-all ${value === d.value ? d.active : d.bg + ' hover:opacity-80'}`}
        >
          <div className="font-bold text-sm">{d.label}</div>
          <div className="text-xs opacity-70 mt-0.5">{d.desc}</div>
        </button>
      ))}
    </div>
  );
}

function QuestionCountPicker({ value, onChange }: { value: number; onChange: (v: number) => void }) {
  return (
    <div className="flex flex-wrap gap-2">
      {Q_COUNTS.map((n) => (
        <button
          key={n}
          onClick={() => onChange(n)}
          className={`w-14 h-10 rounded-xl text-sm font-bold border-2 transition-all ${
            value === n ? 'bg-slate-900 text-white border-slate-900' : 'bg-white text-slate-600 border-slate-200 hover:border-slate-400'
          }`}
        >
          {n}
        </button>
      ))}
      <span className="text-xs text-slate-400 self-center ml-1">questions · ~{Math.round(value * 1.5)} min</span>
    </div>
  );
}

function StartButton({ label, disabled, loading, onClick }: { label: string; disabled: boolean; loading: boolean; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      disabled={disabled || loading}
      className="w-full py-4 rounded-2xl bg-brand-600 hover:bg-brand-700 disabled:opacity-40 disabled:cursor-not-allowed text-white font-bold text-base transition-all flex items-center justify-center gap-2 shadow-md shadow-brand-200"
    >
      {loading ? (
        <><svg className="animate-spin w-5 h-5" fill="none" viewBox="0 0 24 24"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"/><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/></svg>Starting…</>
      ) : (
        <>{label}<svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 8l4 4m0 0l-4 4m4-4H3" /></svg></>
      )}
    </button>
  );
}

// ── Tab 1: Practice ───────────────────────────────────────────────────────────

function PracticeTab({ child, onStart }: { child: { id: string; name: string }; onStart: (payload: Parameters<typeof sessionService.createSession>[0]) => void; loading: boolean }) {
  const [gradeId, setGradeId] = useState('');
  const [subjectId, setSubjectId] = useState('');
  const [difficulty, setDifficulty] = useState<'easy'|'medium'|'hard'>('medium');
  const [numQ, setNumQ] = useState(20);

  const { data: grades = [] } = useQuery({ queryKey: ['grades', NWEA_ID], queryFn: () => catalogueService.getGrades(NWEA_ID), staleTime: Infinity });
  const { data: subjects = [] } = useQuery({ queryKey: ['subjects', NWEA_ID], queryFn: () => catalogueService.getSubjects(NWEA_ID), staleTime: Infinity });

  const coreSubjects = subjects.filter((s) => CORE_SUBJECT_CODES.includes(s.code));
  const canStart = !!gradeId && !!subjectId;

  return (
    <div className="space-y-8">
      {/* Grade */}
      <div>
        <SectionLabel step={1} label="Select Your Grade" />
        <div className="flex flex-wrap gap-2">
          {grades.map((g) => (
            <button
              key={g.id}
              onClick={() => setGradeId(g.id)}
              className={`min-w-[3rem] px-3.5 py-2 rounded-xl text-sm font-bold border-2 transition-all ${
                gradeId === g.id
                  ? 'bg-brand-600 text-white border-brand-600 shadow-sm'
                  : 'bg-white text-slate-700 border-slate-200 hover:border-brand-300'
              }`}
            >
              {g.code === 'K' ? 'K' : g.level}
            </button>
          ))}
        </div>
      </div>

      {/* Subject */}
      {gradeId && (
        <div className="animate-fade-in">
          <SectionLabel step={2} label="Choose a Subject" />
          <div className="grid sm:grid-cols-3 gap-3">
            {coreSubjects.map((s) => {
              const style = SUBJECT_STYLE[s.code] ?? SUBJECT_STYLE.math;
              const isActive = subjectId === s.id;
              return (
                <button
                  key={s.id}
                  onClick={() => setSubjectId(s.id)}
                  className={`p-4 rounded-2xl border-2 text-left transition-all ${isActive ? style.activeBg + ' shadow-md' : style.bg + ' hover:shadow-sm'}`}
                >
                  <div className="text-2xl mb-2">{style.icon}</div>
                  <div className={`font-bold text-sm ${isActive ? '' : style.color}`}>{s.name}</div>
                  <div className={`text-xs mt-0.5 leading-snug ${isActive ? 'opacity-80' : 'text-slate-400'}`}>{s.description}</div>
                </button>
              );
            })}
          </div>
        </div>
      )}

      {/* Difficulty */}
      {gradeId && subjectId && (
        <div className="animate-fade-in">
          <SectionLabel step={3} label="Difficulty Level" />
          <DifficultyPicker value={difficulty} onChange={(v) => setDifficulty(v as 'easy'|'medium'|'hard')} />
        </div>
      )}

      {/* Questions */}
      {gradeId && subjectId && (
        <div className="animate-fade-in">
          <SectionLabel step={4} label="Number of Questions" />
          <QuestionCountPicker value={numQ} onChange={setNumQ} />
        </div>
      )}

      {/* CTA */}
      <StartButton
        label="Start Practice Session"
        disabled={!canStart}
        loading={false}
        onClick={() => canStart && onStart({
          child_id: child.id,
          test_type_id: NWEA_ID,
          subject_id: subjectId,
          grade_id: gradeId,
          difficulty,
          num_questions: numQ,
        })}
      />
      {!canStart && <p className="text-center text-xs text-slate-400">Select your grade and subject to continue</p>}
    </div>
  );
}

// ── Tab 2: Competitive Exams ──────────────────────────────────────────────────

function CompetitiveTab({ child, onStart, loading }: { child: { id: string }; onStart: (p: Parameters<typeof sessionService.createSession>[0]) => void; loading: boolean }) {
  const [examId, setExamId] = useState('');
  const [subjectId, setSubjectId] = useState('');
  const [gradeId, setGradeId] = useState('');
  const [difficulty, setDifficulty] = useState<'easy'|'medium'|'hard'>('medium');
  const [numQ, setNumQ] = useState(20);

  const { data: grades = [] } = useQuery({ queryKey: ['grades', examId], queryFn: () => catalogueService.getGrades(examId), enabled: !!examId, staleTime: Infinity });
  const { data: subjects = [] } = useQuery({ queryKey: ['subjects', examId], queryFn: () => catalogueService.getSubjects(examId), enabled: !!examId, staleTime: Infinity });

  const canStart = !!examId && !!subjectId && !!gradeId;

  return (
    <div className="space-y-8">
      {/* Exam type */}
      <div>
        <SectionLabel step={1} label="Select Exam Type" />
        <div className="grid sm:grid-cols-2 gap-4">
          {[MATH_OLY, SCI_OLY].map((id) => {
            const meta = EXAM_META[id];
            const isActive = examId === id;
            return (
              <button
                key={id}
                onClick={() => { setExamId(id); setSubjectId(''); setGradeId(''); }}
                className={`p-5 rounded-2xl border-2 text-left transition-all ${isActive ? meta.activeBg + ' shadow-md' : 'bg-white border-slate-200 hover:border-slate-300 hover:shadow-sm'}`}
              >
                <div className="text-3xl mb-2">{meta.icon}</div>
                <div className={`font-bold text-base ${isActive ? '' : meta.color}`}>{meta.title}</div>
                <div className={`text-xs mt-1 leading-relaxed ${isActive ? 'opacity-80' : 'text-slate-400'}`}>{meta.subtitle}</div>
              </button>
            );
          })}
        </div>
      </div>

      {/* Subject */}
      {examId && subjects.length > 0 && (
        <div className="animate-fade-in">
          <SectionLabel step={2} label="Select Subject" />
          <div className="flex flex-wrap gap-2">
            {subjects.map((s: Subject) => (
              <button
                key={s.id}
                onClick={() => setSubjectId(s.id)}
                className={`px-4 py-2 rounded-xl text-sm font-semibold border-2 transition-all ${
                  subjectId === s.id
                    ? 'bg-brand-600 text-white border-brand-600'
                    : 'bg-white text-slate-700 border-slate-200 hover:border-brand-300 hover:text-brand-700'
                }`}
              >
                {s.name}
              </button>
            ))}
          </div>
        </div>
      )}

      {/* Grade */}
      {examId && grades.length > 0 && (
        <div className="animate-fade-in">
          <SectionLabel step={3} label="Select Grade" />
          <div className="flex flex-wrap gap-2">
            {grades.map((g: Grade) => (
              <button
                key={g.id}
                onClick={() => setGradeId(g.id)}
                className={`min-w-[3rem] px-3.5 py-2 rounded-xl text-sm font-bold border-2 transition-all ${
                  gradeId === g.id
                    ? 'bg-slate-900 text-white border-slate-900'
                    : 'bg-white text-slate-700 border-slate-200 hover:border-slate-400'
                }`}
              >
                {g.code === 'K' ? 'K' : g.level}
              </button>
            ))}
          </div>
        </div>
      )}

      {/* Difficulty */}
      {canStart && (
        <div className="animate-fade-in">
          <SectionLabel step={4} label="Difficulty Level" />
          <DifficultyPicker value={difficulty} onChange={(v) => setDifficulty(v as 'easy'|'medium'|'hard')} />
        </div>
      )}

      {/* Questions */}
      {canStart && (
        <div className="animate-fade-in">
          <SectionLabel step={5} label="Number of Questions" />
          <QuestionCountPicker value={numQ} onChange={setNumQ} />
        </div>
      )}

      <StartButton
        label="Start Exam Prep"
        disabled={!canStart}
        loading={loading}
        onClick={() => canStart && onStart({
          child_id: child.id,
          test_type_id: examId,
          subject_id: subjectId,
          grade_id: gradeId,
          difficulty,
          num_questions: numQ,
        })}
      />
      {!canStart && <p className="text-center text-xs text-slate-400">Complete all selections to begin</p>}
    </div>
  );
}

// ── Main page ─────────────────────────────────────────────────────────────────

export function TestSelectionPage() {
  const navigate = useNavigate();
  const { selectedChild, childProfile } = useAuthStore();
  const { setConfig, setSession, reset } = useTestStore();
  const [tab, setTab] = useState<'practice' | 'competitive'>('practice');
  const [startError, setStartError] = useState('');

  const child = selectedChild ?? childProfile;

  const { data: allSubjects = [] } = useQuery({ queryKey: ['subjects', NWEA_ID], queryFn: () => catalogueService.getSubjects(NWEA_ID), staleTime: Infinity });
  const { data: allGrades = [] } = useQuery({ queryKey: ['grades', NWEA_ID], queryFn: () => catalogueService.getGrades(NWEA_ID), staleTime: Infinity });
  const { data: testTypes = [] } = useQuery({ queryKey: ['test-types'], queryFn: catalogueService.getTestTypes, staleTime: Infinity });

  const createSession = useMutation({
    mutationFn: sessionService.createSession,
    onSuccess: (session) => { setSession(session); navigate('/test'); },
    onError: () => setStartError('No questions found for this selection. Try a different configuration.'),
  });

  if (!child) { navigate('/'); return null; }

  const handleStart = (payload: Parameters<typeof sessionService.createSession>[0]) => {
    setStartError('');
    reset();

    const grade = allGrades.find((g) => g.id === payload.grade_id);
    const subject = allSubjects.find((s) => s.id === payload.subject_id)
      ?? testTypes.flatMap(() => []).find(() => false); // competitive subjects loaded separately
    const testType = testTypes.find((t) => t.id === payload.test_type_id);

    if (grade && testType) {
      setConfig({
        child,
        testType,
        subject: subject ?? { id: payload.subject_id, name: '', code: '', test_type_id: payload.test_type_id, description: null, display_order: 0 },
        grade,
        difficulty: payload.difficulty as 'easy'|'medium'|'hard',
        numQuestions: payload.num_questions,
      });
    }
    createSession.mutate(payload);
  };

  const backUrl = childProfile ? '/dashboard' : '/';

  return (
    <div className="min-h-screen bg-slate-50">
      {/* ── Header ── */}
      <header className="bg-white border-b border-slate-100 sticky top-0 z-20">
        <div className="max-w-3xl mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link to={backUrl} className="w-8 h-8 rounded-lg border border-slate-200 flex items-center justify-center text-slate-500 hover:bg-slate-50 transition-colors">
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" /></svg>
            </Link>
            <div>
              <h1 className="text-sm font-bold text-slate-900">Start a Session</h1>
              <p className="text-xs text-slate-400">Hi {child.name.split(' ')[0]}! What are we working on today?</p>
            </div>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-7 h-7 rounded-full bg-brand-100 flex items-center justify-center text-brand-700 font-bold text-xs">
              {child.name.charAt(0).toUpperCase()}
            </div>
          </div>
        </div>
      </header>

      <div className="max-w-3xl mx-auto px-6 py-8">
        {/* ── Tab switcher ── */}
        <div className="bg-white border border-slate-200 rounded-2xl p-1.5 flex gap-1.5 mb-8 shadow-card">
          {([
            { key: 'practice',    icon: '📚', label: 'Practice by Grade & Subject', sub: 'Math · Reading · Writing' },
            { key: 'competitive', icon: '🏆', label: 'Competitive Exam Prep',        sub: 'Math & Science Olympiad' },
          ] as const).map((t) => (
            <button
              key={t.key}
              onClick={() => setTab(t.key)}
              className={`flex-1 flex items-center gap-3 px-4 py-3 rounded-xl text-left transition-all ${
                tab === t.key
                  ? 'bg-brand-600 text-white shadow-sm'
                  : 'text-slate-600 hover:bg-slate-50'
              }`}
            >
              <span className="text-xl">{t.icon}</span>
              <div>
                <div className={`text-sm font-semibold leading-tight ${tab === t.key ? 'text-white' : 'text-slate-800'}`}>{t.label}</div>
                <div className={`text-xs ${tab === t.key ? 'text-brand-100' : 'text-slate-400'}`}>{t.sub}</div>
              </div>
            </button>
          ))}
        </div>

        {/* ── Error ── */}
        {startError && (
          <div className="flex items-center gap-2 bg-rose-50 border border-rose-200 rounded-xl px-4 py-3 mb-6">
            <svg className="w-4 h-4 text-rose-500 shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" /></svg>
            <p className="text-sm text-rose-700">{startError}</p>
          </div>
        )}

        {/* ── Tab content ── */}
        <div className="bg-white border border-slate-200 rounded-2xl p-6 sm:p-8 shadow-card">
          {tab === 'practice' ? (
            <PracticeTab
              child={child as { id: string; name: string }}
              onStart={handleStart}
              loading={createSession.isPending}
            />
          ) : (
            <CompetitiveTab
              child={child as { id: string }}
              onStart={handleStart}
              loading={createSession.isPending}
            />
          )}
        </div>
      </div>
    </div>
  );
}
