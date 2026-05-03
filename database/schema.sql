-- =============================================================================
-- Test Simulator – Full PostgreSQL Schema
-- Compatible with Supabase (PostgreSQL 15+) and any standard PostgreSQL instance
-- =============================================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";  -- for fast text search on questions

-- =============================================================================
-- Enum Types
-- =============================================================================

CREATE TYPE question_type_enum AS ENUM ('single_choice', 'multiple_choice');
CREATE TYPE difficulty_enum    AS ENUM ('easy', 'medium', 'hard');
CREATE TYPE test_status_enum   AS ENUM ('in_progress', 'completed', 'abandoned');
CREATE TYPE test_type_code_enum AS ENUM ('nwea_map', 'math_olympiad', 'science_olympiad');

-- =============================================================================
-- Children
-- =============================================================================

CREATE TABLE children (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        VARCHAR(100) NOT NULL,
    avatar_url  TEXT,
    display_order INTEGER  DEFAULT 0,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- Test Types  (NWEA MAP / Math Olympiad / Science Olympiad)
-- =============================================================================

CREATE TABLE test_types (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        VARCHAR(100) NOT NULL,
    code        test_type_code_enum NOT NULL UNIQUE,
    description TEXT,
    icon        VARCHAR(50),  -- emoji or icon name
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- Subjects  (Math, Reading, Language, Science, …)
-- =============================================================================

CREATE TABLE subjects (
    id           UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    name         VARCHAR(100) NOT NULL,
    code         VARCHAR(50)  NOT NULL,
    test_type_id UUID        NOT NULL REFERENCES test_types(id) ON DELETE CASCADE,
    description  TEXT,
    display_order INTEGER     DEFAULT 0,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (code, test_type_id)
);

-- =============================================================================
-- Grades  (Kindergarten → 12)
-- =============================================================================

CREATE TABLE grades (
    id      UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    name    VARCHAR(50)  NOT NULL,          -- "Kindergarten", "1st Grade", …
    code    VARCHAR(10)  NOT NULL UNIQUE,   -- "K", "1", "2", … "12"
    level   SMALLINT     NOT NULL,          -- 0=K, 1=1, … 12=12
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- Test Type ↔ Grade availability  (not all tests available at all grades)
-- =============================================================================

CREATE TABLE test_type_grades (
    test_type_id UUID NOT NULL REFERENCES test_types(id)  ON DELETE CASCADE,
    grade_id     UUID NOT NULL REFERENCES grades(id)       ON DELETE CASCADE,
    PRIMARY KEY (test_type_id, grade_id)
);

-- =============================================================================
-- Topics  (grouped by subject + grade)
-- =============================================================================

CREATE TABLE topics (
    id           UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    name         VARCHAR(200) NOT NULL,
    subject_id   UUID        NOT NULL REFERENCES subjects(id)  ON DELETE CASCADE,
    grade_id     UUID        NOT NULL REFERENCES grades(id)    ON DELETE CASCADE,
    description  TEXT,
    display_order INTEGER     DEFAULT 0,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (name, subject_id, grade_id)
);

CREATE INDEX idx_topics_subject_grade ON topics (subject_id, grade_id);

-- =============================================================================
-- Questions
-- TEXT columns used for question_text & passage to support lengthy paragraphs
-- =============================================================================

CREATE TABLE questions (
    id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    topic_id      UUID        NOT NULL REFERENCES topics(id)     ON DELETE CASCADE,
    grade_id      UUID        NOT NULL REFERENCES grades(id)     ON DELETE RESTRICT,
    test_type_id  UUID        NOT NULL REFERENCES test_types(id) ON DELETE RESTRICT,
    -- Content
    question_text TEXT        NOT NULL,
    passage       TEXT,                   -- Reading comprehension / long context
    image_url     TEXT,
    question_type question_type_enum NOT NULL DEFAULT 'single_choice',
    difficulty    difficulty_enum    NOT NULL DEFAULT 'medium',
    points        SMALLINT           NOT NULL DEFAULT 1,
    explanation   TEXT,                   -- Post-answer explanation shown to child
    -- Metadata
    source_file   VARCHAR(200),           -- Which Excel file it came from
    source_row    INTEGER,                -- Row in source file (for debugging)
    is_active     BOOLEAN                NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ            NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_questions_topic      ON questions (topic_id);
CREATE INDEX idx_questions_grade      ON questions (grade_id);
CREATE INDEX idx_questions_test_type  ON questions (test_type_id);
CREATE INDEX idx_questions_difficulty ON questions (difficulty);
CREATE INDEX idx_questions_active     ON questions (is_active);
-- Full-text search index
CREATE INDEX idx_questions_text_search ON questions USING gin(to_tsvector('english', question_text));

-- =============================================================================
-- Answer Options
-- =============================================================================

CREATE TABLE answer_options (
    id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id   UUID        NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    option_label  CHAR(1)     NOT NULL,   -- A, B, C, D, E
    option_text   TEXT        NOT NULL,
    is_correct    BOOLEAN     NOT NULL DEFAULT FALSE,
    display_order SMALLINT    NOT NULL,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_answer_options_question ON answer_options (question_id);

-- =============================================================================
-- Test Sessions
-- =============================================================================

CREATE TABLE test_sessions (
    id                UUID             PRIMARY KEY DEFAULT uuid_generate_v4(),
    child_id          UUID             NOT NULL REFERENCES children(id)    ON DELETE CASCADE,
    test_type_id      UUID             NOT NULL REFERENCES test_types(id)  ON DELETE RESTRICT,
    subject_id        UUID             NOT NULL REFERENCES subjects(id)    ON DELETE RESTRICT,
    grade_id          UUID             NOT NULL REFERENCES grades(id)      ON DELETE RESTRICT,
    difficulty        difficulty_enum  NOT NULL,
    total_questions   SMALLINT         NOT NULL,
    -- Timing
    started_at        TIMESTAMPTZ      NOT NULL DEFAULT NOW(),
    ended_at          TIMESTAMPTZ,
    -- Results
    status            test_status_enum NOT NULL DEFAULT 'in_progress',
    correct_count     SMALLINT         NOT NULL DEFAULT 0,
    score_percentage  NUMERIC(5,2),
    -- Anti-cheat
    interruption_count SMALLINT        NOT NULL DEFAULT 0,
    created_at        TIMESTAMPTZ      NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_sessions_child       ON test_sessions (child_id);
CREATE INDEX idx_sessions_child_time  ON test_sessions (child_id, started_at DESC);
CREATE INDEX idx_sessions_status      ON test_sessions (status);

-- =============================================================================
-- Session Question Answers
-- =============================================================================

CREATE TABLE session_answers (
    id                  UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id          UUID        NOT NULL REFERENCES test_sessions(id) ON DELETE CASCADE,
    question_id         UUID        NOT NULL REFERENCES questions(id)     ON DELETE RESTRICT,
    question_order      SMALLINT    NOT NULL,  -- position in this session (1-based)
    selected_option_ids UUID[]      NOT NULL DEFAULT '{}',
    is_correct          BOOLEAN,
    time_taken_seconds  SMALLINT,
    answered_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (session_id, question_id)
);

CREATE INDEX idx_session_answers_session  ON session_answers (session_id);
CREATE INDEX idx_session_answers_question ON session_answers (question_id);

-- =============================================================================
-- Topic Performance  (rolling aggregate per child)
-- =============================================================================

CREATE TABLE topic_performance (
    id               UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    child_id         UUID        NOT NULL REFERENCES children(id) ON DELETE CASCADE,
    topic_id         UUID        NOT NULL REFERENCES topics(id)   ON DELETE CASCADE,
    total_attempts   INTEGER     NOT NULL DEFAULT 0,
    correct_attempts INTEGER     NOT NULL DEFAULT 0,
    last_attempted_at TIMESTAMPTZ,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (child_id, topic_id)
);

CREATE INDEX idx_topic_perf_child ON topic_performance (child_id);

-- =============================================================================
-- updated_at auto-update trigger
-- =============================================================================

CREATE OR REPLACE FUNCTION trigger_set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

CREATE TRIGGER set_updated_at_children
    BEFORE UPDATE ON children
    FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

CREATE TRIGGER set_updated_at_questions
    BEFORE UPDATE ON questions
    FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

CREATE TRIGGER set_updated_at_topic_performance
    BEFORE UPDATE ON topic_performance
    FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

-- =============================================================================
-- Helper view: question_with_options  (flattens question + options for API)
-- =============================================================================

CREATE VIEW question_with_options AS
SELECT
    q.id,
    q.topic_id,
    q.grade_id,
    q.test_type_id,
    q.question_text,
    q.passage,
    q.image_url,
    q.question_type,
    q.difficulty,
    q.points,
    q.explanation,
    t.name         AS topic_name,
    g.code         AS grade_code,
    g.level        AS grade_level,
    json_agg(
        json_build_object(
            'id',            ao.id,
            'label',         ao.option_label,
            'text',          ao.option_text,
            'is_correct',    ao.is_correct,
            'display_order', ao.display_order
        ) ORDER BY ao.display_order
    ) AS options
FROM questions q
JOIN topics       t  ON t.id = q.topic_id
JOIN grades       g  ON g.id = q.grade_id
JOIN answer_options ao ON ao.question_id = q.id
WHERE q.is_active = TRUE
GROUP BY q.id, t.name, g.code, g.level;
