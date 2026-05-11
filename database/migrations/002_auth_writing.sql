-- =============================================================================
-- Migration 002 – Child Auth, Writing Support, English Subjects
-- Run in Supabase SQL editor AFTER 001_initial.sql
-- =============================================================================

-- ── 1. Extend children table ─────────────────────────────────────────────────
ALTER TABLE children
    ADD COLUMN IF NOT EXISTS user_id  UUID UNIQUE,
    ADD COLUMN IF NOT EXISTS email    TEXT UNIQUE,
    ADD COLUMN IF NOT EXISTS grade_id UUID REFERENCES grades(id) ON DELETE SET NULL;

-- Note: user_id references auth.users which lives in the auth schema.
-- Supabase manages auth.users; add the FK constraint only if you want DB-level enforcement:
-- ALTER TABLE children ADD CONSTRAINT fk_children_user
--     FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;
-- (Comment this out if your Supabase plan doesn't allow cross-schema FKs)

CREATE INDEX IF NOT EXISTS idx_children_user_id  ON children (user_id);
CREATE INDEX IF NOT EXISTS idx_children_grade_id ON children (grade_id);

-- ── 2. Add open_ended to question type enum ──────────────────────────────────
ALTER TYPE question_type_enum ADD VALUE IF NOT EXISTS 'open_ended';

-- ── 3. Add writing columns to questions ─────────────────────────────────────
ALTER TABLE questions
    ADD COLUMN IF NOT EXISTS writing_rubric TEXT;

-- ── 4. Add writing columns to session_answers ────────────────────────────────
ALTER TABLE session_answers
    ADD COLUMN IF NOT EXISTS writing_response TEXT,
    ADD COLUMN IF NOT EXISTS groq_feedback    JSONB;

-- Make selected_option_ids nullable for open_ended questions
ALTER TABLE session_answers
    ALTER COLUMN selected_option_ids DROP NOT NULL;

-- =============================================================================
-- 5. New Subjects: English Reading & English Writing (NWEA MAP)
-- =============================================================================

INSERT INTO subjects (id, name, code, test_type_id, description, display_order)
VALUES
    ('44444444-0001-0000-0000-000000000005',
     'English Reading', 'english_reading',
     '22222222-0000-0000-0000-000000000001',
     'Reading comprehension, ELA, vocabulary, literary analysis, informational texts', 5),
    ('44444444-0001-0000-0000-000000000006',
     'English Writing', 'english_writing',
     '22222222-0000-0000-0000-000000000001',
     'Writing prompts with AI-powered feedback on grammar, vocabulary, content, and structure', 6)
ON CONFLICT (code, test_type_id) DO NOTHING;

-- =============================================================================
-- 6. Topics – English Reading (K–12)
-- =============================================================================

-- Kindergarten
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Print Concepts & Phonological Awareness', '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000000', 1),
    ('Phonics & Letter Recognition',            '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000000', 2),
    ('Story Elements & Retelling',              '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000000', 3)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 1st Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Phonics & Word Recognition',              '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000001', 1),
    ('Reading Fluency & Comprehension',         '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000001', 2),
    ('Vocabulary in Stories',                   '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000001', 3)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 2nd Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Main Idea & Key Details',                 '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000002', 1),
    ('Text Structure & Features',               '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000002', 2),
    ('Vocabulary in Context',                   '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000002', 3)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 3rd Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Literary Elements (Character, Setting, Plot)', '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000003', 1),
    ('Informational Text & Main Idea',               '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000003', 2),
    ('Making Inferences',                            '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000003', 3)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 4th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Theme & Central Idea',                    '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000004', 1),
    ('Point of View & Author Purpose',          '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000004', 2),
    ('Comparing Texts',                         '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000004', 3)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 5th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Context Clues & Vocabulary',              '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000005', 1),
    ('Figurative Language',                     '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000005', 2),
    ('Author''s Purpose & Craft',               '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000005', 3)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 6th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Argument & Evidence in Texts',            '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000006', 1),
    ('Narrative Techniques & Structure',        '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000006', 2),
    ('Synthesis Across Texts',                  '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000006', 3)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 7th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Rhetorical Analysis',                     '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000007', 1),
    ('Complex Text Structures',                 '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000007', 2),
    ('Critical Reading & Evaluation',           '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000007', 3)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 8th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Textual Evidence & Analysis',             '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000008', 1),
    ('Comparing Arguments',                     '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000008', 2),
    ('Advanced Inference & Interpretation',     '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000008', 3)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 9th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Literary Analysis',                       '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000009', 1),
    ('Research Skills & Sourcing',              '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000009', 2),
    ('Persuasive & Informational Reading',      '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000009', 3)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 10th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Advanced Literary Criticism',             '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000010', 1),
    ('Non-fiction & Documentary Analysis',      '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000010', 2),
    ('Close Reading Techniques',                '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000010', 3)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 11th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Rhetoric & Persuasion',                   '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000011', 1),
    ('Historical & Seminal Texts',              '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000011', 2),
    ('AP-level Analysis & Synthesis',           '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000011', 3)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 12th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('College-level Reading Strategies',        '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000012', 1),
    ('Synthesis & Evaluation of Complex Texts', '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000012', 2),
    ('Advanced Rhetoric & Argumentation',       '44444444-0001-0000-0000-000000000005', '33333333-0000-0000-0000-000000000012', 3)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- =============================================================================
-- 7. Topics – English Writing (K–12)
-- =============================================================================

-- Kindergarten
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Sentence Writing',                        '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000000', 1),
    ('Descriptive Writing',                     '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000000', 2)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 1st Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Personal Narrative',                      '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000001', 1),
    ('Descriptive Paragraphs',                  '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000001', 2)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 2nd Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Story Writing',                           '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000002', 1),
    ('Opinion Writing',                         '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000002', 2)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 3rd Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Paragraph Structure',                     '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000003', 1),
    ('Narrative Writing',                       '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000003', 2)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 4th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Opinion Essays',                          '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000004', 1),
    ('Descriptive Essays',                      '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000004', 2)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 5th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Explanatory Writing',                     '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000005', 1),
    ('Persuasive Paragraphs',                   '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000005', 2)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 6th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Argumentative Writing',                   '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000006', 1),
    ('Expository Essays',                       '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000006', 2)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 7th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Research Writing',                        '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000007', 1),
    ('Analytical Paragraphs',                   '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000007', 2)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 8th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Argumentative Essays',                    '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000008', 1),
    ('Comparative Writing',                     '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000008', 2)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 9th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Analytical Essays',                       '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000009', 1),
    ('Literary Response Writing',               '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000009', 2)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 10th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Synthesis Essays',                        '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000010', 1),
    ('Research Papers',                         '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000010', 2)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 11th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('AP-style Essays',                         '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000011', 1),
    ('Argumentative Analysis',                  '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000011', 2)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;

-- 12th Grade
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('College Application Essay',               '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000012', 1),
    ('Advanced Composition',                    '44444444-0001-0000-0000-000000000006', '33333333-0000-0000-0000-000000000012', 2)
ON CONFLICT (name, subject_id, grade_id) DO NOTHING;
