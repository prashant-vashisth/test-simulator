import api from './api';
import type { TestType, Subject, Grade, Topic } from '../types';

export const catalogueService = {
  getTestTypes: () =>
    api.get<TestType[]>('/api/v1/catalogue/test-types').then(r => r.data),

  getGrades: (testTypeId?: string) =>
    api.get<Grade[]>('/api/v1/catalogue/grades', {
      params: testTypeId ? { test_type_id: testTypeId } : undefined,
    }).then(r => r.data),

  getSubjects: (testTypeId?: string) =>
    api.get<Subject[]>('/api/v1/catalogue/subjects', {
      params: testTypeId ? { test_type_id: testTypeId } : undefined,
    }).then(r => r.data),

  getTopics: (subjectId?: string, gradeId?: string) =>
    api.get<Topic[]>('/api/v1/catalogue/topics', {
      params: {
        ...(subjectId && { subject_id: subjectId }),
        ...(gradeId && { grade_id: gradeId }),
      },
    }).then(r => r.data),
};
