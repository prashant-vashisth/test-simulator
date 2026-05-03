import api from './api';
import type { TestSession, Question, AnswerSubmit, SessionResult } from '../types';

export const sessionService = {
  createSession: (payload: {
    child_id: string;
    test_type_id: string;
    subject_id: string;
    grade_id: string;
    difficulty: string;
    num_questions: number;
  }) => api.post<TestSession>('/api/v1/sessions', payload).then(r => r.data),

  getSession: (sessionId: string) =>
    api.get<TestSession>(`/api/v1/sessions/${sessionId}`).then(r => r.data),

  getQuestions: (sessionId: string) =>
    api.get<Question[]>(`/api/v1/sessions/${sessionId}/questions`).then(r => r.data),

  submitAnswer: (sessionId: string, payload: AnswerSubmit) =>
    api.post(`/api/v1/sessions/${sessionId}/answers`, payload).then(r => r.data),

  completeSession: (sessionId: string) =>
    api.patch<TestSession>(`/api/v1/sessions/${sessionId}/complete`).then(r => r.data),

  abandonSession: (sessionId: string) =>
    api.patch<TestSession>(`/api/v1/sessions/${sessionId}/abandon`).then(r => r.data),

  recordInterruption: (sessionId: string) =>
    api.patch<TestSession>(`/api/v1/sessions/${sessionId}/interruption`).then(r => r.data),

  getResults: (sessionId: string) =>
    api.get<SessionResult>(`/api/v1/sessions/${sessionId}/results`).then(r => r.data),
};
