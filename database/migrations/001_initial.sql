-- Migration 001 – Initial schema + seed
-- Run once against a fresh PostgreSQL / Supabase database.
-- Idempotent: uses IF NOT EXISTS / DO $$ blocks where possible.

\i schema.sql
\i seed_data.sql

-- Supabase Row-Level Security (enable but allow all for service-role key)
ALTER TABLE children          ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_types        ENABLE ROW LEVEL SECURITY;
ALTER TABLE subjects          ENABLE ROW LEVEL SECURITY;
ALTER TABLE grades            ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_type_grades  ENABLE ROW LEVEL SECURITY;
ALTER TABLE topics            ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions         ENABLE ROW LEVEL SECURITY;
ALTER TABLE answer_options    ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_sessions     ENABLE ROW LEVEL SECURITY;
ALTER TABLE session_answers   ENABLE ROW LEVEL SECURITY;
ALTER TABLE topic_performance ENABLE ROW LEVEL SECURITY;

-- Allow the service_role key (used by backend) to bypass RLS
CREATE POLICY "service_role_all_children"          ON children          FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "service_role_all_test_types"        ON test_types        FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "service_role_all_subjects"          ON subjects          FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "service_role_all_grades"            ON grades            FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "service_role_all_ttgrades"          ON test_type_grades  FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "service_role_all_topics"            ON topics            FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "service_role_all_questions"         ON questions         FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "service_role_all_answer_options"    ON answer_options    FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "service_role_all_test_sessions"     ON test_sessions     FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "service_role_all_session_answers"   ON session_answers   FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "service_role_all_topic_performance" ON topic_performance FOR ALL TO service_role USING (true) WITH CHECK (true);

-- Allow anon key to read catalogue data (no questions with answers exposed)
CREATE POLICY "public_read_test_types"       ON test_types       FOR SELECT TO anon USING (true);
CREATE POLICY "public_read_subjects"         ON subjects         FOR SELECT TO anon USING (true);
CREATE POLICY "public_read_grades"           ON grades           FOR SELECT TO anon USING (true);
CREATE POLICY "public_read_test_type_grades" ON test_type_grades FOR SELECT TO anon USING (true);
CREATE POLICY "public_read_topics"           ON topics           FOR SELECT TO anon USING (true);
