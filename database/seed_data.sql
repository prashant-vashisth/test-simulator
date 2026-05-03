-- =============================================================================
-- Seed Data – Test Simulator
-- Run AFTER schema.sql
-- =============================================================================

-- ── Children ──────────────────────────────────────────────────────────────────
INSERT INTO children (id, name, display_order) VALUES
    ('11111111-0000-0000-0000-000000000001', 'Ayanna Vashisth', 1),
    ('11111111-0000-0000-0000-000000000002', 'Aarvi Vashisth',  2),
    ('11111111-0000-0000-0000-000000000003', 'Adhrit Vashisth', 3);

-- ── Test Types ────────────────────────────────────────────────────────────────
INSERT INTO test_types (id, name, code, description, icon) VALUES
    ('22222222-0000-0000-0000-000000000001', 'NWEA MAP',          'nwea_map',         'Measures of Academic Progress – adaptive standardized assessment', '📊'),
    ('22222222-0000-0000-0000-000000000002', 'Math Olympiad',     'math_olympiad',     'Competitive mathematics preparation and problem-solving',           '🏆'),
    ('22222222-0000-0000-0000-000000000003', 'Science Olympiad',  'science_olympiad',  'Team-based science competition preparation',                       '🔬');

-- ── Grades ────────────────────────────────────────────────────────────────────
INSERT INTO grades (id, name, code, level) VALUES
    ('33333333-0000-0000-0000-000000000000', 'Kindergarten', 'K',  0),
    ('33333333-0000-0000-0000-000000000001', '1st Grade',    '1',  1),
    ('33333333-0000-0000-0000-000000000002', '2nd Grade',    '2',  2),
    ('33333333-0000-0000-0000-000000000003', '3rd Grade',    '3',  3),
    ('33333333-0000-0000-0000-000000000004', '4th Grade',    '4',  4),
    ('33333333-0000-0000-0000-000000000005', '5th Grade',    '5',  5),
    ('33333333-0000-0000-0000-000000000006', '6th Grade',    '6',  6),
    ('33333333-0000-0000-0000-000000000007', '7th Grade',    '7',  7),
    ('33333333-0000-0000-0000-000000000008', '8th Grade',    '8',  8),
    ('33333333-0000-0000-0000-000000000009', '9th Grade',    '9',  9),
    ('33333333-0000-0000-0000-000000000010', '10th Grade',   '10', 10),
    ('33333333-0000-0000-0000-000000000011', '11th Grade',   '11', 11),
    ('33333333-0000-0000-0000-000000000012', '12th Grade',   '12', 12);

-- ── NWEA MAP: grade availability (K–12) ──────────────────────────────────────
INSERT INTO test_type_grades (test_type_id, grade_id)
SELECT '22222222-0000-0000-0000-000000000001', id FROM grades;

-- ── Math Olympiad: grade availability (3–12) ─────────────────────────────────
INSERT INTO test_type_grades (test_type_id, grade_id)
SELECT '22222222-0000-0000-0000-000000000002', id FROM grades WHERE level >= 3;

-- ── Science Olympiad: grade availability (3–12) ──────────────────────────────
INSERT INTO test_type_grades (test_type_id, grade_id)
SELECT '22222222-0000-0000-0000-000000000003', id FROM grades WHERE level >= 3;

-- =============================================================================
-- Subjects
-- =============================================================================

-- NWEA MAP subjects
INSERT INTO subjects (id, name, code, test_type_id, description, display_order) VALUES
    ('44444444-0001-0000-0000-000000000001', 'Mathematics',      'math',     '22222222-0000-0000-0000-000000000001', 'Number sense, algebra, geometry, data analysis', 1),
    ('44444444-0001-0000-0000-000000000002', 'Reading',          'reading',  '22222222-0000-0000-0000-000000000001', 'Comprehension, vocabulary, literary analysis',   2),
    ('44444444-0001-0000-0000-000000000003', 'Language Usage',   'language', '22222222-0000-0000-0000-000000000001', 'Grammar, punctuation, writing conventions',      3),
    ('44444444-0001-0000-0000-000000000004', 'Science',          'science',  '22222222-0000-0000-0000-000000000001', 'Life science, earth science, physical science',   4);

-- Math Olympiad subjects
INSERT INTO subjects (id, name, code, test_type_id, description, display_order) VALUES
    ('44444444-0002-0000-0000-000000000001', 'Competition Math', 'comp_math', '22222222-0000-0000-0000-000000000002', 'Problem solving, number theory, combinatorics', 1),
    ('44444444-0002-0000-0000-000000000002', 'Algebra',          'algebra',   '22222222-0000-0000-0000-000000000002', 'Expressions, equations, functions',             2),
    ('44444444-0002-0000-0000-000000000003', 'Geometry',         'geometry',  '22222222-0000-0000-0000-000000000002', 'Shapes, proofs, coordinate geometry',           3);

-- Science Olympiad subjects
INSERT INTO subjects (id, name, code, test_type_id, description, display_order) VALUES
    ('44444444-0003-0000-0000-000000000001', 'Life Science',     'life_sci',  '22222222-0000-0000-0000-000000000003', 'Biology, ecology, anatomy',                      1),
    ('44444444-0003-0000-0000-000000000002', 'Earth Science',    'earth_sci', '22222222-0000-0000-0000-000000000003', 'Geology, meteorology, astronomy',                2),
    ('44444444-0003-0000-0000-000000000003', 'Physical Science', 'phys_sci',  '22222222-0000-0000-0000-000000000003', 'Chemistry, physics, forces and motion',          3),
    ('44444444-0003-0000-0000-000000000004', 'Technology & Eng', 'tech_eng',  '22222222-0000-0000-0000-000000000003', 'Engineering design, simple machines, tech',      4);

-- =============================================================================
-- Topics – NWEA MAP Mathematics (sample per grade; expand via Excel pipeline)
-- =============================================================================

-- Helper: inserts topics for a given subject + grade list
-- Kindergarten Math
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Counting & Cardinality',         '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000000', 1),
    ('Number Sense 0–20',              '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000000', 2),
    ('Basic Addition & Subtraction',   '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000000', 3),
    ('Shapes & Geometry',              '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000000', 4),
    ('Patterns',                       '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000000', 5),
    ('Measurement Basics',             '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000000', 6);

-- 1st Grade Math
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Addition & Subtraction within 20', '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000001', 1),
    ('Place Value (tens and ones)',       '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000001', 2),
    ('Number Patterns',                  '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000001', 3),
    ('Measurement & Time',               '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000001', 4),
    ('Basic Geometry',                   '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000001', 5),
    ('Data & Graphs',                    '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000001', 6);

-- 2nd Grade Math
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Addition & Subtraction within 1000', '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000002', 1),
    ('Introduction to Multiplication',     '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000002', 2),
    ('Fractions (halves, thirds, fourths)','44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000002', 3),
    ('Time & Money',                       '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000002', 4),
    ('Place Value (hundreds)',             '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000002', 5),
    ('Measurement & Data',                 '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000002', 6);

-- 3rd Grade Math
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Multiplication & Division',          '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000003', 1),
    ('Fractions',                          '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000003', 2),
    ('Area & Perimeter',                   '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000003', 3),
    ('Place Value & Rounding',             '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000003', 4),
    ('Time, Liquid Volume & Mass',         '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000003', 5),
    ('Data Analysis & Graphs',             '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000003', 6);

-- 4th Grade Math
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Multi-digit Multiplication',         '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000004', 1),
    ('Division with Remainders',           '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000004', 2),
    ('Fractions & Decimals',               '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000004', 3),
    ('Angles & Geometry',                  '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000004', 4),
    ('Factors & Multiples',                '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000004', 5),
    ('Measurement & Conversions',          '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000004', 6);

-- 5th Grade Math
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Fractions Operations',               '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000005', 1),
    ('Decimals Operations',                '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000005', 2),
    ('Volume',                             '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000005', 3),
    ('Coordinate Plane',                   '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000005', 4),
    ('Powers of 10 & Place Value',         '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000005', 5),
    ('Data Analysis',                      '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000005', 6);

-- 6th Grade Math
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Ratios & Proportional Relationships', '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 1),
    ('Integers & Number System',            '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 2),
    ('Expressions & Equations',             '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 3),
    ('Geometry (Area, Surface Area, Volume)','44444444-0001-0000-0000-000000000001','33333333-0000-0000-0000-000000000006', 4),
    ('Statistics & Probability',            '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 5),
    ('Fractions, Decimals & Percents',      '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 6);

-- 7th Grade Math
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Proportional Relationships',         '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000007', 1),
    ('Rational Numbers',                   '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000007', 2),
    ('Expressions, Equations & Inequalities','44444444-0001-0000-0000-000000000001','33333333-0000-0000-0000-000000000007', 3),
    ('Geometry (Scale, Area, Surface Area)','44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000007', 4),
    ('Statistics & Probability',           '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000007', 5),
    ('Percents & Financial Literacy',      '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000007', 6);

-- 8th Grade Math
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Linear Equations & Systems',         '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000008', 1),
    ('Functions',                          '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000008', 2),
    ('Geometry (Transformations, Pythagorean)','44444444-0001-0000-0000-000000000001','33333333-0000-0000-0000-000000000008', 3),
    ('Exponents & Scientific Notation',    '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000008', 4),
    ('Statistics & Bivariate Data',        '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000008', 5),
    ('Irrational Numbers & Real Number System','44444444-0001-0000-0000-000000000001','33333333-0000-0000-0000-000000000008', 6);

-- 9th Grade Math (Algebra I / Integrated)
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Expressions & Properties',           '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000009', 1),
    ('Linear Equations & Inequalities',    '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000009', 2),
    ('Systems of Equations',               '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000009', 3),
    ('Polynomials & Factoring',            '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000009', 4),
    ('Quadratic Functions',                '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000009', 5),
    ('Exponential Functions',              '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000009', 6);

-- 10th Grade Math (Geometry / Algebra II)
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Congruence & Similarity',            '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000010', 1),
    ('Coordinate Geometry',                '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000010', 2),
    ('Trigonometric Ratios',               '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000010', 3),
    ('Circles & Theorems',                 '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000010', 4),
    ('Probability',                        '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000010', 5),
    ('Statistics & Modeling',              '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000010', 6);

-- 11th Grade Math (Pre-Calculus / Statistics)
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Polynomial & Rational Functions',    '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000011', 1),
    ('Trigonometry',                       '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000011', 2),
    ('Sequences & Series',                 '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000011', 3),
    ('Matrices & Vectors',                 '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000011', 4),
    ('Probability & Statistics',           '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000011', 5),
    ('Conic Sections',                     '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000011', 6);

-- 12th Grade Math (Calculus / AP)
INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Limits & Continuity',                '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000012', 1),
    ('Derivatives',                        '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000012', 2),
    ('Integrals',                          '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000012', 3),
    ('Applications of Calculus',           '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000012', 4),
    ('Differential Equations',             '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000012', 5),
    ('Multivariable Concepts',             '44444444-0001-0000-0000-000000000001', '33333333-0000-0000-0000-000000000012', 6);

-- =============================================================================
-- Topics – NWEA MAP Reading (selected grades)
-- =============================================================================

INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Phonics & Word Recognition', '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000000', 1),
    ('Reading Comprehension',      '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000000', 2),
    ('Vocabulary',                 '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000000', 3);

INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Main Idea & Details',        '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000003', 1),
    ('Author''s Purpose & POV',    '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000003', 2),
    ('Vocabulary in Context',      '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000003', 3),
    ('Text Structure',             '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000003', 4),
    ('Literary Elements',          '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000003', 5),
    ('Inference & Evidence',       '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000003', 6);

INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Main Idea & Details',        '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000006', 1),
    ('Author''s Purpose & POV',    '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000006', 2),
    ('Vocabulary in Context',      '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000006', 3),
    ('Text Structure & Features',  '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000006', 4),
    ('Inference & Evidence',       '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000006', 5),
    ('Compare & Contrast Texts',   '44444444-0001-0000-0000-000000000002', '33333333-0000-0000-0000-000000000006', 6);

-- =============================================================================
-- Topics – Math Olympiad Competition Math (grades 3–8)
-- =============================================================================

INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Number Theory Basics',       '44444444-0002-0000-0000-000000000001', '33333333-0000-0000-0000-000000000003', 1),
    ('Logical Reasoning',          '44444444-0002-0000-0000-000000000001', '33333333-0000-0000-0000-000000000003', 2),
    ('Pattern Recognition',        '44444444-0002-0000-0000-000000000001', '33333333-0000-0000-0000-000000000003', 3),
    ('Word Problems',              '44444444-0002-0000-0000-000000000001', '33333333-0000-0000-0000-000000000003', 4);

INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Number Theory',              '44444444-0002-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 1),
    ('Combinatorics',              '44444444-0002-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 2),
    ('Modular Arithmetic',         '44444444-0002-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 3),
    ('Sequences & Series',         '44444444-0002-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 4),
    ('Geometry Problems',          '44444444-0002-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 5),
    ('Logical Puzzles',            '44444444-0002-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 6);

-- =============================================================================
-- Topics – Science Olympiad (grade 6 sample)
-- =============================================================================

INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Cell Biology',               '44444444-0003-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 1),
    ('Ecosystems & Food Webs',     '44444444-0003-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 2),
    ('Human Body Systems',         '44444444-0003-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 3),
    ('Genetics & Heredity',        '44444444-0003-0000-0000-000000000001', '33333333-0000-0000-0000-000000000006', 4);

INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Rocks & Minerals',           '44444444-0003-0000-0000-000000000002', '33333333-0000-0000-0000-000000000006', 1),
    ('Weather & Atmosphere',       '44444444-0003-0000-0000-000000000002', '33333333-0000-0000-0000-000000000006', 2),
    ('Solar System & Space',       '44444444-0003-0000-0000-000000000002', '33333333-0000-0000-0000-000000000006', 3),
    ('Water Cycle & Erosion',      '44444444-0003-0000-0000-000000000002', '33333333-0000-0000-0000-000000000006', 4);

INSERT INTO topics (name, subject_id, grade_id, display_order) VALUES
    ('Matter & States',            '44444444-0003-0000-0000-000000000003', '33333333-0000-0000-0000-000000000006', 1),
    ('Forces & Motion',            '44444444-0003-0000-0000-000000000003', '33333333-0000-0000-0000-000000000006', 2),
    ('Energy Transformations',     '44444444-0003-0000-0000-000000000003', '33333333-0000-0000-0000-000000000006', 3),
    ('Chemical Reactions',         '44444444-0003-0000-0000-000000000003', '33333333-0000-0000-0000-000000000006', 4);

-- =============================================================================
-- Sample Questions – NWEA MAP Math 6th Grade (to verify the system works)
-- You must load real questions using the Excel pipeline.
-- =============================================================================

DO $$
DECLARE
    v_topic_ratios   UUID;
    v_topic_integers UUID;
    v_topic_expr     UUID;
    v_grade_6        UUID := '33333333-0000-0000-0000-000000000006';
    v_tt_map         UUID := '22222222-0000-0000-0000-000000000001';
    v_q1 UUID; v_q2 UUID; v_q3 UUID; v_q4 UUID; v_q5 UUID; v_q6 UUID;
BEGIN
    SELECT id INTO v_topic_ratios   FROM topics WHERE name='Ratios & Proportional Relationships' AND grade_id=v_grade_6 LIMIT 1;
    SELECT id INTO v_topic_integers FROM topics WHERE name='Integers & Number System'            AND grade_id=v_grade_6 LIMIT 1;
    SELECT id INTO v_topic_expr     FROM topics WHERE name='Expressions & Equations'             AND grade_id=v_grade_6 LIMIT 1;

    -- Question 1 (easy)
    INSERT INTO questions (id, topic_id, grade_id, test_type_id, question_text, question_type, difficulty, points, explanation)
    VALUES (uuid_generate_v4(), v_topic_ratios, v_grade_6, v_tt_map,
        'A recipe uses 3 cups of flour for every 2 cups of sugar. If you use 9 cups of flour, how many cups of sugar do you need?',
        'single_choice', 'easy', 1,
        'Set up the proportion: 3/2 = 9/x. Cross-multiply: 3x = 18, so x = 6.')
    RETURNING id INTO v_q1;
    INSERT INTO answer_options (question_id, option_label, option_text, is_correct, display_order) VALUES
        (v_q1, 'A', '4 cups',  FALSE, 1),
        (v_q1, 'B', '6 cups',  TRUE,  2),
        (v_q1, 'C', '8 cups',  FALSE, 3),
        (v_q1, 'D', '12 cups', FALSE, 4);

    -- Question 2 (easy)
    INSERT INTO questions (id, topic_id, grade_id, test_type_id, question_text, question_type, difficulty, points, explanation)
    VALUES (uuid_generate_v4(), v_topic_integers, v_grade_6, v_tt_map,
        'What is the value of |-7|?',
        'single_choice', 'easy', 1,
        'The absolute value of a number is its distance from zero, always non-negative.')
    RETURNING id INTO v_q2;
    INSERT INTO answer_options (question_id, option_label, option_text, is_correct, display_order) VALUES
        (v_q2, 'A', '-7', FALSE, 1),
        (v_q2, 'B', '0',  FALSE, 2),
        (v_q2, 'C', '7',  TRUE,  3),
        (v_q2, 'D', '49', FALSE, 4);

    -- Question 3 (medium)
    INSERT INTO questions (id, topic_id, grade_id, test_type_id, question_text, question_type, difficulty, points, explanation)
    VALUES (uuid_generate_v4(), v_topic_expr, v_grade_6, v_tt_map,
        'Evaluate the expression 4x + 3 when x = 5.',
        'single_choice', 'medium', 1,
        'Substitute x = 5: 4(5) + 3 = 20 + 3 = 23.')
    RETURNING id INTO v_q3;
    INSERT INTO answer_options (question_id, option_label, option_text, is_correct, display_order) VALUES
        (v_q3, 'A', '17', FALSE, 1),
        (v_q3, 'B', '20', FALSE, 2),
        (v_q3, 'C', '23', TRUE,  3),
        (v_q3, 'D', '32', FALSE, 4);

    -- Question 4 (medium) – multiple choice
    INSERT INTO questions (id, topic_id, grade_id, test_type_id, question_text, question_type, difficulty, points, explanation)
    VALUES (uuid_generate_v4(), v_topic_integers, v_grade_6, v_tt_map,
        'Which of the following numbers are integers? Select ALL that apply.',
        'multiple_choice', 'medium', 2,
        'Integers include all whole numbers and their negatives: …-2, -1, 0, 1, 2… Fractions and decimals are not integers.')
    RETURNING id INTO v_q4;
    INSERT INTO answer_options (question_id, option_label, option_text, is_correct, display_order) VALUES
        (v_q4, 'A', '-5',  TRUE,  1),
        (v_q4, 'B', '3/4', FALSE, 2),
        (v_q4, 'C', '0',   TRUE,  3),
        (v_q4, 'D', '2.5', FALSE, 4),
        (v_q4, 'E', '100', TRUE,  5);

    -- Question 5 (hard)
    INSERT INTO questions (id, topic_id, grade_id, test_type_id, question_text, question_type, difficulty, points, explanation)
    VALUES (uuid_generate_v4(), v_topic_ratios, v_grade_6, v_tt_map,
        'A car travels 150 miles in 3 hours. At the same rate, how many miles will it travel in 7 hours?',
        'single_choice', 'hard', 1,
        'Unit rate = 150 ÷ 3 = 50 mph. Distance in 7 hours = 50 × 7 = 350 miles.')
    RETURNING id INTO v_q5;
    INSERT INTO answer_options (question_id, option_label, option_text, is_correct, display_order) VALUES
        (v_q5, 'A', '250 miles', FALSE, 1),
        (v_q5, 'B', '300 miles', FALSE, 2),
        (v_q5, 'C', '350 miles', TRUE,  3),
        (v_q5, 'D', '400 miles', FALSE, 4);

    -- Question 6 (hard) – reading comprehension style
    INSERT INTO questions (id, topic_id, grade_id, test_type_id, question_text, passage, question_type, difficulty, points, explanation)
    VALUES (uuid_generate_v4(), v_topic_expr, v_grade_6, v_tt_map,
        'Based on the scenario above, what is the total cost for 4 friends each buying 2 smoothies at $3.50 each plus a $1.25 topping?',
        'Four friends visit a smoothie shop. Each smoothie costs $3.50, and each person can add a topping for $1.25. All four friends decide to get 2 smoothies each and add a topping to one of their smoothies.',
        'single_choice', 'hard', 2,
        'Each friend: 2 × $3.50 + 1 × $1.25 = $7.00 + $1.25 = $8.25. Four friends: 4 × $8.25 = $33.00.')
    RETURNING id INTO v_q6;
    INSERT INTO answer_options (question_id, option_label, option_text, is_correct, display_order) VALUES
        (v_q6, 'A', '$28.00', FALSE, 1),
        (v_q6, 'B', '$30.00', FALSE, 2),
        (v_q6, 'C', '$33.00', TRUE,  3),
        (v_q6, 'D', '$35.00', FALSE, 4);
END;
$$;
