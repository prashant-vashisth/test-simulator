// ── Domain types mirroring backend schemas ────────────────────────────────────

export interface Child {
  id: string;
  name: string;
  avatar_url: string | null;
  display_order: number;
  email?: string | null;
  grade_id?: string | null;
}

export interface TestType {
  id: string;
  name: string;
  code: string;
  description: string | null;
  icon: string | null;
}

export interface Subject {
  id: string;
  name: string;
  code: string;
  test_type_id: string;
  description: string | null;
  display_order: number;
}

export interface Grade {
  id: string;
  name: string;
  code: string;
  level: number;
}

export interface Topic {
  id: string;
  name: string;
  subject_id: string;
  grade_id: string;
  description: string | null;
  display_order: number;
}

export interface AnswerOption {
  id: string;
  option_label: string;
  option_text: string;
  display_order: number;
  is_correct?: boolean; // only present post-test
}

export interface Question {
  id: string;
  topic_id: string;
  grade_id: string;
  test_type_id: string;
  question_text: string;
  passage: string | null;
  image_url: string | null;
  question_type: 'single_choice' | 'multiple_choice' | 'open_ended';
  writing_rubric?: string | null;
  difficulty: 'easy' | 'medium' | 'hard';
  points: number;
  explanation?: string | null;
  options: AnswerOption[];
}

export interface TestSession {
  id: string;
  child_id: string;
  test_type_id: string;
  subject_id: string;
  grade_id: string;
  difficulty: 'easy' | 'medium' | 'hard';
  total_questions: number;
  started_at: string;
  ended_at: string | null;
  status: 'in_progress' | 'completed' | 'abandoned';
  correct_count: number;
  score_percentage: number | null;
  interruption_count: number;
}

export interface SessionSummary extends TestSession {
  test_type_name: string | null;
  subject_name: string | null;
  grade_name: string | null;
}

export interface AnswerSubmit {
  question_id: string;
  selected_option_ids?: string[];
  time_taken_seconds?: number;
  writing_response?: string;
}

export interface TopicPerformance {
  topic_id: string;
  topic_name: string;
  total_attempts: number;
  correct_attempts: number;
  accuracy_percent: number;
  last_attempted_at: string | null;
}

export interface SessionResult {
  session_id: string;
  status: string;
  total_questions: number;
  correct_count: number;
  score_percentage: number | null;
  interruption_count: number;
  started_at: string;
  ended_at: string | null;
  questions: QuestionResult[];
}

export interface QuestionResult {
  question_order: number;
  question_id: string;
  question_text: string;
  passage: string | null;
  question_type: string;
  difficulty: string;
  explanation: string | null;
  writing_rubric: string | null;
  options: {
    id: string;
    label: string;
    text: string;
    is_correct: boolean;
  }[];
  selected_option_ids: string[];
  writing_response: string | null;
  groq_feedback: Record<string, unknown> | null;
  is_correct: boolean | null;
  time_taken_seconds: number | null;
}

// ── UI config types ───────────────────────────────────────────────────────────

export interface TestConfig {
  child: Child;
  testType: TestType;
  subject: Subject;
  grade: Grade;
  difficulty: 'easy' | 'medium' | 'hard';
  numQuestions: number;
}
