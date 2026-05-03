import api from './api';
import type { Child, SessionSummary, TopicPerformance } from '../types';

export const childService = {
  listChildren: () =>
    api.get<Child[]>('/api/v1/children').then(r => r.data),

  getChild: (id: string) =>
    api.get<Child>(`/api/v1/children/${id}`).then(r => r.data),

  updateAvatar: (id: string, avatarUrl: string) =>
    api.patch<Child>(`/api/v1/children/${id}`, { avatar_url: avatarUrl }).then(r => r.data),

  getSessions: (childId: string, limit = 5) =>
    api.get<SessionSummary[]>(`/api/v1/children/${childId}/sessions`, {
      params: { limit },
    }).then(r => r.data),

  getTopicPerformance: (childId: string, subjectId?: string, gradeId?: string) =>
    api.get<TopicPerformance[]>(`/api/v1/children/${childId}/topic-performance`, {
      params: {
        ...(subjectId && { subject_id: subjectId }),
        ...(gradeId && { grade_id: gradeId }),
      },
    }).then(r => r.data),

  getRecommendations: (childId: string, subjectId?: string, gradeId?: string) =>
    api.get<string[]>(`/api/v1/children/${childId}/recommendations`, {
      params: {
        ...(subjectId && { subject_id: subjectId }),
        ...(gradeId && { grade_id: gradeId }),
      },
    }).then(r => r.data),
};
