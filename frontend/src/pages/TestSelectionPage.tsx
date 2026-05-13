import { useState, useEffect } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useQuery, useMutation } from '@tanstack/react-query';
import { useAuthStore } from '../store/authStore';
import { useTestStore } from '../store/testStore';
import { catalogueService } from '../services/catalogueService';
import { sessionService } from '../services/sessionService';
import type { Grade, Subject } from '../types';

// ── Fixed test-type IDs from seed_data.sql ────────────────────────────────────
const NWEA_ID  = '22222222-0000-0000-0000-000000000001';
const MATH_OLY = '22222222-0000-0000-0000-000000000002';
const SCI_OLY  = '22222222-0000-0000-0000-000000000003';

type Difficulty = 'easy' | 'medium' | 'hard';

type TabItem =
  | { kind: 'nwea';     subjectId: string; testTypeId: string; name: string; code: string }
  | { kind: 'olympiad'; testTypeId: string;                    name: string; code: string };

// ── Per-subject color tokens ──────────────────────────────────────────────────
const SUBJECT_CONFIG: Record<string, {
  tabActive: string;
  tabBorder: string;
  topicBg: string;
  topicText: string;
  topicBorder: string;
  subjectPillActive: string;
}> = {
  math: {
    tabActive:        'text-blue-700 bg-blue-50',
    tabBorder:        'border-blue-600',
    topicBg:          'bg-blue-50',
    topicText:        'text-blue-800',
    topicBorder:      'border-blue-200',
    subjectPillActive:'border-blue-500 bg-blue-600 text-white',
  },
  english_reading: {
    tabActive:        'text-emerald-700 bg-emerald-50',
    tabBorder:        'border-emerald-600',
    topicBg:          'bg-emerald-50',
    topicText:        'text-emerald-800',
    topicBorder:      'border-emerald-200',
    subjectPillActive:'border-emerald-500 bg-emerald-600 text-white',
  },
  english_writing: {
    tabActive:        'text-violet-700 bg-violet-50',
    tabBorder:        'border-violet-600',
    topicBg:          'bg-violet-50',
    topicText:        'text-violet-800',
    topicBorder:      'border-violet-200',
    subjectPillActive:'border-violet-500 bg-violet-600 text-white',
  },
  math_olympiad: {
    tabActive:        'text-amber-700 bg-amber-50',
    tabBorder:        'border-amber-500',
    topicBg:          'bg-amber-50',
    topicText:        'text-amber-800',
    topicBorder:      'border-amber-200',
    subjectPillActive:'border-amber-500 bg-amber-500 text-white',
  },
  sci_olympiad: {
    tabActive:        'text-teal-700 bg-teal-50',
    tabBorder:        'border-teal-600',
    topicBg:          'bg-teal-50',
    topicText:        'text-teal-800',
    topicBorder:      'border-teal-200',
    subjectPillActive:'border-teal-500 bg-teal-600 text-white',
  },
};

const DIFF_OPTS: { value: Difficulty; label: string; desc: string; inactive: string; active: string }[] = [
  { value: 'easy',   label: 'Foundation', desc: 'Core concepts', inactive: 'border-slate-200 bg-white text-slate-600 hover:border-emerald-300 hover:bg-emerald-50', active: 'border-emerald-500 bg-emerald-500 text-white' },
  { value: 'medium', label: 'Standard',   desc: 'Grade level',   inactive: 'border-slate-200 bg-white text-slate-600 hover:border-amber-300 hover:bg-amber-50',     active: 'border-amber-500 bg-amber-500 text-white'   },
  { value: 'hard',   label: 'Advanced',   desc: 'Challenge',     inactive: 'border-slate-200 bg-white text-slate-600 hover:border-rose-300 hover:bg-rose-50',        active: 'border-rose-500 bg-rose-500 text-white'     },
];

const Q_COUNTS = [10, 20, 30, 42, 50];

// ── Helpers ───────────────────────────────────────────────────────────────────
function ordinal(n: number): string {
  if (n >= 11 && n <= 13) return `${n}th`;
  switch (n % 10) {
    case 1: return `${n}st`;
    case 2: return `${n}nd`;
    case 3: return `${n}rd`;
    default: return `${n}th`;
  }
}

function gradeFullName(g: Grade): string {
  return g.code === 'K' ? 'Kindergarten' : `${ordinal(g.level)} Grade`;
}

function tabIsActive(tab: TabItem, active: TabItem | null): boolean {
  if (!active || active.kind !== tab.kind) return false;
  if (tab.kind === 'nwea'     && active.kind === 'nwea')     return active.subjectId  === tab.subjectId;
  if (tab.kind === 'olympiad' && active.kind === 'olympiad') return active.testTypeId === tab.testTypeId;
  return false;
}

// ── Grade Sidebar ─────────────────────────────────────────────────────────────
function GradeSidebar({ grades, selectedId, onSelect }: {
  grades: Grade[];
  selectedId: string;
  onSelect: (id: string) => void;
}) {
  return (
    <aside className="w-44 shrink-0 bg-white border-r border-slate-100 overflow-y-auto flex flex-col">
      <div className="px-4 pt-5 pb-3">
        <p className="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Grade Level</p>
      </div>
      <nav className="flex-1 pb-4">
        {grades.map((g) => (
          <button
            key={g.id}
            onClick={() => onSelect(g.id)}
            className={`w-full text-left px-4 py-2.5 text-sm transition-colors ${
              selectedId === g.id
                ? 'bg-brand-50 text-brand-700 font-semibold border-r-[3px] border-brand-600'
                : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900 font-medium'
            }`}
          >
            {gradeFullName(g)}
          </button>
        ))}
      </nav>
    </aside>
  );
}

// ── Main Page ─────────────────────────────────────────────────────────────────
export function TestSelectionPage() {
  const navigate = useNavigate();
  const { selectedChild, childProfile } = useAuthStore();
  const { setConfig, setSession, reset } = useTestStore();

  const child = selectedChild ?? childProfile;

  const [gradeId,           setGradeId          ] = useState('');
  const [activeTab,         setActiveTab         ] = useState<TabItem | null>(null);
  const [olympiadSubjectId, setOlympiadSubjectId ] = useState('');
  const [difficulty,        setDifficulty        ] = useState<Difficulty>('medium');
  const [numQ,              setNumQ              ] = useState(20);
  const [startError,        setStartError        ] = useState('');

  // ── Queries ────────────────────────────────────────────────────────────────
  const { data: grades = [] } = useQuery({
    queryKey: ['grades', NWEA_ID],
    queryFn:  () => catalogueService.getGrades(NWEA_ID),
    staleTime: Infinity,
  });

  const { data: nweaSubjects = [] } = useQuery({
    queryKey: ['subjects', NWEA_ID],
    queryFn:  () => catalogueService.getSubjects(NWEA_ID),
    staleTime: Infinity,
  });

  const olympiadTestTypeId = activeTab?.kind === 'olympiad' ? activeTab.testTypeId : undefined;
  const { data: olympiadSubjects = [] } = useQuery({
    queryKey: ['subjects', olympiadTestTypeId],
    queryFn:  () => catalogueService.getSubjects(olympiadTestTypeId!),
    enabled:  !!olympiadTestTypeId,
    staleTime: Infinity,
  });

  const { data: testTypes = [] } = useQuery({
    queryKey: ['test-types'],
    queryFn:  catalogueService.getTestTypes,
    staleTime: Infinity,
  });

  const effectiveSubjectId  = activeTab?.kind === 'nwea' ? activeTab.subjectId : olympiadSubjectId;
  const effectiveTestTypeId = activeTab ? (activeTab.kind === 'nwea' ? NWEA_ID : activeTab.testTypeId) : '';

  const { data: topics = [] } = useQuery({
    queryKey: ['topics', effectiveSubjectId, gradeId],
    queryFn:  () => catalogueService.getTopics(effectiveSubjectId, gradeId),
    enabled:  !!effectiveSubjectId && !!gradeId,
    staleTime: Infinity,
  });

  // ── Defaults: pre-select child's grade & Math tab ─────────────────────────
  useEffect(() => {
    if (!gradeId && grades.length) {
      const childGradeId = (childProfile ?? selectedChild)?.grade_id;
      const match = childGradeId ? grades.find((g) => g.id === childGradeId) : null;
      setGradeId(match ? match.id : grades[0].id);
    }
  }, [grades, gradeId, childProfile, selectedChild]);

  useEffect(() => {
    if (!activeTab && nweaSubjects.length) {
      const math = nweaSubjects.find((s) => s.code === 'math') ?? nweaSubjects[0];
      setActiveTab({ kind: 'nwea', subjectId: math.id, testTypeId: NWEA_ID, name: math.name, code: math.code });
    }
  }, [nweaSubjects, activeTab]);

  // ── Session mutation ───────────────────────────────────────────────────────
  const createSession = useMutation({
    mutationFn: sessionService.createSession,
    onSuccess:  (session) => { setSession(session); navigate('/test'); },
    onError:    () => setStartError('No questions found for this selection. Try a different grade, subject, or difficulty.'),
  });

  if (!child) { navigate('/'); return null; }

  // ── Derived ───────────────────────────────────────────────────────────────
  const subjectTabs: TabItem[] = [
    ...nweaSubjects
      .filter((s) => ['math', 'english_reading', 'english_writing'].includes(s.code))
      .map<TabItem>((s) => ({ kind: 'nwea', subjectId: s.id, testTypeId: NWEA_ID, name: s.name, code: s.code })),
    { kind: 'olympiad', testTypeId: MATH_OLY, name: 'Math Olympiad',    code: 'math_olympiad' },
    { kind: 'olympiad', testTypeId: SCI_OLY,  name: 'Science Olympiad', code: 'sci_olympiad'  },
  ];

  const cfg         = SUBJECT_CONFIG[activeTab?.code ?? 'math'] ?? SUBJECT_CONFIG.math;
  const selectedGrade = grades.find((g) => g.id === gradeId);
  const backUrl     = childProfile ? '/dashboard' : '/';
  const canStart    = !!gradeId && !!effectiveSubjectId && (activeTab?.kind !== 'olympiad' || !!olympiadSubjectId);

  const handleStart = () => {
    if (!canStart) return;
    setStartError('');
    reset();

    const grade    = grades.find((g) => g.id === gradeId);
    const testType = testTypes.find((t) => t.id === effectiveTestTypeId);
    const subject  = activeTab?.kind === 'nwea'
      ? nweaSubjects.find((s) => s.id === effectiveSubjectId)
      : olympiadSubjects.find((s: Subject) => s.id === olympiadSubjectId);

    if (grade && testType) {
      setConfig({
        child,
        testType,
        subject: subject ?? { id: effectiveSubjectId, name: '', code: '', test_type_id: effectiveTestTypeId, description: null, display_order: 0 },
        grade,
        difficulty,
        numQuestions: numQ,
      });
    }

    createSession.mutate({
      child_id:      child.id,
      test_type_id:  effectiveTestTypeId,
      subject_id:    effectiveSubjectId,
      grade_id:      gradeId,
      difficulty,
      num_questions: numQ,
    });
  };

  return (
    <div className="h-screen flex flex-col bg-slate-50">

      {/* ── Header ──────────────────────────────────────────────────────── */}
      <header className="bg-white border-b border-slate-100 shrink-0 z-20">
        <div className="px-6 h-14 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Link to={backUrl} className="flex items-center gap-2">
              <div className="w-7 h-7 rounded bg-brand-600 flex items-center justify-center text-white font-black text-xs">A</div>
              <span className="font-bold text-slate-900 text-sm hidden sm:block">AcademIQ</span>
            </Link>
            <svg className="w-4 h-4 text-slate-300 hidden sm:block" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
            </svg>
            <span className="text-sm font-semibold text-slate-500 hidden sm:block">Practice</span>
          </div>

          <div className="flex items-center gap-3">
            {selectedGrade && (
              <span className="hidden md:block text-xs font-medium text-slate-500 bg-slate-100 px-2.5 py-1 rounded-full">
                {gradeFullName(selectedGrade)}
              </span>
            )}
            <div className="w-8 h-8 rounded-full bg-brand-100 flex items-center justify-center text-brand-700 font-bold text-sm">
              {child.name.charAt(0).toUpperCase()}
            </div>
            <span className="text-sm font-semibold text-slate-700 hidden sm:block">{child.name.split(' ')[0]}</span>
            <Link to={backUrl} className="text-xs text-slate-400 hover:text-slate-600 font-medium transition-colors ml-1">
              ← Back
            </Link>
          </div>
        </div>
      </header>

      {/* ── Body (sidebar + main) ────────────────────────────────────────── */}
      <div className="flex flex-1 min-h-0">

        {/* Grade Sidebar */}
        <GradeSidebar
          grades={grades}
          selectedId={gradeId}
          onSelect={(id) => { setGradeId(id); setStartError(''); }}
        />

        {/* Right pane */}
        <main className="flex-1 flex flex-col min-h-0">

          {/* Subject Tab Bar */}
          <div className="bg-white border-b border-slate-100 shrink-0">
            <div className="flex overflow-x-auto">
              {subjectTabs.map((tab) => {
                const isActive = tabIsActive(tab, activeTab);
                const colors   = SUBJECT_CONFIG[tab.code] ?? SUBJECT_CONFIG.math;
                return (
                  <button
                    key={tab.kind === 'nwea' ? tab.subjectId : tab.testTypeId}
                    onClick={() => { setActiveTab(tab); setOlympiadSubjectId(''); setStartError(''); }}
                    className={`shrink-0 px-5 py-4 text-sm font-semibold border-b-[3px] transition-all whitespace-nowrap ${
                      isActive
                        ? `${colors.tabBorder} ${colors.tabActive}`
                        : 'border-transparent text-slate-500 hover:text-slate-800 hover:bg-slate-50'
                    }`}
                  >
                    {tab.name}
                  </button>
                );
              })}
            </div>
          </div>

          {/* Scrollable content */}
          <div className="flex-1 overflow-y-auto">
            <div className="max-w-4xl mx-auto px-6 py-8 space-y-8">

              {/* Olympiad sub-subject selector */}
              {activeTab?.kind === 'olympiad' && olympiadSubjects.length > 0 && (
                <section>
                  <h3 className="text-[11px] font-bold text-slate-400 uppercase tracking-widest mb-3">
                    Select Subject Area
                  </h3>
                  <div className="flex flex-wrap gap-2">
                    {olympiadSubjects.map((s: Subject) => (
                      <button
                        key={s.id}
                        onClick={() => { setOlympiadSubjectId(s.id); setStartError(''); }}
                        className={`px-4 py-2 rounded-lg text-sm font-semibold border-2 transition-all ${
                          olympiadSubjectId === s.id
                            ? cfg.subjectPillActive
                            : 'bg-white border-slate-200 text-slate-600 hover:border-slate-300 hover:text-slate-900'
                        }`}
                      >
                        {s.name}
                      </button>
                    ))}
                  </div>
                </section>
              )}

              {/* Topic grid */}
              {effectiveSubjectId && gradeId && (
                <section>
                  <div className="flex items-center justify-between mb-4">
                    <h3 className="text-[11px] font-bold text-slate-400 uppercase tracking-widest">
                      {topics.length > 0
                        ? `Topics — ${selectedGrade ? gradeFullName(selectedGrade) : ''}`
                        : 'Topics'}
                    </h3>
                    {topics.length > 0 && (
                      <span className="text-xs text-slate-400">
                        {topics.length} topic{topics.length !== 1 ? 's' : ''}
                      </span>
                    )}
                  </div>

                  {topics.length > 0 ? (
                    <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3">
                      {topics.map((t) => (
                        <div
                          key={t.id}
                          className={`p-3.5 rounded-xl border text-sm font-medium leading-snug ${cfg.topicBg} ${cfg.topicText} ${cfg.topicBorder}`}
                        >
                          {t.name}
                          {t.description && (
                            <p className="text-xs opacity-60 mt-1 font-normal leading-snug line-clamp-2">
                              {t.description}
                            </p>
                          )}
                        </div>
                      ))}
                    </div>
                  ) : (
                    <div className="bg-white border border-slate-100 rounded-2xl p-8 text-center">
                      <div className="w-12 h-12 bg-slate-50 rounded-full flex items-center justify-center mx-auto mb-3">
                        <svg className="w-5 h-5 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                        </svg>
                      </div>
                      <p className="text-sm font-semibold text-slate-600">Topics coming soon</p>
                      <p className="text-xs text-slate-400 mt-1 leading-relaxed">
                        Practice questions are available now — topic categories will be added shortly.
                      </p>
                    </div>
                  )}
                </section>
              )}

              {/* Prompt if nothing selected yet */}
              {!effectiveSubjectId && !gradeId && (
                <div className="bg-white border border-slate-100 rounded-2xl p-10 text-center">
                  <p className="text-sm text-slate-500">Select a grade and subject to get started.</p>
                </div>
              )}

              {/* Practice Settings card */}
              <section className="bg-white border border-slate-200 rounded-2xl p-6 shadow-sm space-y-6">
                <div>
                  <h3 className="text-[11px] font-bold text-slate-400 uppercase tracking-widest mb-3">
                    Difficulty Level
                  </h3>
                  <div className="grid grid-cols-3 gap-3">
                    {DIFF_OPTS.map((d) => (
                      <button
                        key={d.value}
                        onClick={() => setDifficulty(d.value)}
                        className={`p-3.5 rounded-xl border-2 text-left transition-all ${
                          difficulty === d.value ? d.active : d.inactive
                        }`}
                      >
                        <div className="font-bold text-sm">{d.label}</div>
                        <div className="text-xs opacity-70 mt-0.5">{d.desc}</div>
                      </button>
                    ))}
                  </div>
                </div>

                <div>
                  <h3 className="text-[11px] font-bold text-slate-400 uppercase tracking-widest mb-3">
                    Number of Questions
                  </h3>
                  <div className="flex flex-wrap items-center gap-2">
                    {Q_COUNTS.map((n) => (
                      <button
                        key={n}
                        onClick={() => setNumQ(n)}
                        className={`w-14 h-10 rounded-xl text-sm font-bold border-2 transition-all ${
                          numQ === n
                            ? 'bg-slate-900 text-white border-slate-900'
                            : 'bg-white text-slate-600 border-slate-200 hover:border-slate-400'
                        }`}
                      >
                        {n}
                      </button>
                    ))}
                    <span className="text-xs text-slate-400 ml-1">
                      ~{Math.round(numQ * 1.5)} min
                    </span>
                  </div>
                </div>

                {startError && (
                  <div className="flex items-center gap-2 bg-rose-50 border border-rose-200 rounded-xl px-4 py-3">
                    <svg className="w-4 h-4 text-rose-500 shrink-0" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
                    </svg>
                    <p className="text-sm text-rose-700">{startError}</p>
                  </div>
                )}

                <button
                  onClick={handleStart}
                  disabled={!canStart || createSession.isPending}
                  className="w-full py-3.5 rounded-xl bg-brand-600 hover:bg-brand-700 disabled:opacity-40 disabled:cursor-not-allowed text-white font-bold text-sm transition-all flex items-center justify-center gap-2 shadow-sm"
                >
                  {createSession.isPending ? (
                    <>
                      <svg className="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24">
                        <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                        <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                      </svg>
                      Starting session…
                    </>
                  ) : (
                    <>
                      Start Practice Session
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 8l4 4m0 0l-4 4m4-4H3" />
                      </svg>
                    </>
                  )}
                </button>

                {!canStart && (
                  <p className="text-center text-xs text-slate-400">
                    {!gradeId
                      ? 'Select a grade from the left panel to continue'
                      : activeTab?.kind === 'olympiad' && !olympiadSubjectId
                      ? 'Select a subject area above to continue'
                      : !activeTab
                      ? 'Select a subject tab above to continue'
                      : ''}
                  </p>
                )}
              </section>

            </div>
          </div>
        </main>
      </div>
    </div>
  );
}
