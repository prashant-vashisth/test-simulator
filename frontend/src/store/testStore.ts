import { create } from 'zustand';
import type { TestConfig, Question, TestSession } from '../types';

interface AnswerRecord {
  questionId: string;
  selectedOptionIds: string[];
  timeTakenSeconds: number;
  submittedAt: Date;
}

interface TestState {
  config: TestConfig | null;
  session: TestSession | null;
  questions: Question[];
  currentIndex: number;
  answers: Record<string, AnswerRecord>;
  questionStartTime: Date | null;
  interruptionCount: number;

  setConfig: (config: TestConfig) => void;
  setSession: (session: TestSession) => void;
  setQuestions: (questions: Question[]) => void;
  recordAnswer: (questionId: string, selectedOptionIds: string[]) => void;
  goToNext: () => void;
  goToPrev: () => void;
  goToIndex: (index: number) => void;
  startQuestionTimer: () => void;
  incrementInterruption: () => void;
  reset: () => void;
}

const initialState = {
  config: null,
  session: null,
  questions: [],
  currentIndex: 0,
  answers: {},
  questionStartTime: null,
  interruptionCount: 0,
};

export const useTestStore = create<TestState>()((set, get) => ({
  ...initialState,

  setConfig: (config) => set({ config }),
  setSession: (session) => set({ session }),
  setQuestions: (questions) => set({ questions, currentIndex: 0 }),

  recordAnswer: (questionId, selectedOptionIds) => {
    const start = get().questionStartTime;
    const timeTakenSeconds = start ? Math.round((Date.now() - start.getTime()) / 1000) : 0;
    set((state) => ({
      answers: {
        ...state.answers,
        [questionId]: {
          questionId,
          selectedOptionIds,
          timeTakenSeconds,
          submittedAt: new Date(),
        },
      },
      questionStartTime: new Date(), // reset for next question
    }));
  },

  goToNext: () =>
    set((state) => ({
      currentIndex: Math.min(state.currentIndex + 1, state.questions.length - 1),
      questionStartTime: new Date(),
    })),

  goToPrev: () =>
    set((state) => ({
      currentIndex: Math.max(state.currentIndex - 1, 0),
    })),

  goToIndex: (index) =>
    set((state) => ({
      currentIndex: Math.max(0, Math.min(index, state.questions.length - 1)),
      questionStartTime: new Date(),
    })),

  startQuestionTimer: () => set({ questionStartTime: new Date() }),

  incrementInterruption: () =>
    set((state) => ({ interruptionCount: state.interruptionCount + 1 })),

  reset: () => set(initialState),
}));
