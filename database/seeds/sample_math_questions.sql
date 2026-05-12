-- =============================================================================
-- Sample Math Questions – K through 12  (10 per grade = 130 total)
-- Delete these later and load real questions via the Excel pipeline.
-- =============================================================================

DO $$
DECLARE
  v_subj UUID := '44444444-0001-0000-0000-000000000001'; -- NWEA MAP Mathematics
  v_tt   UUID := '22222222-0000-0000-0000-000000000001'; -- NWEA MAP
  g_k    UUID := '33333333-0000-0000-0000-000000000000';
  g_1    UUID := '33333333-0000-0000-0000-000000000001';
  g_2    UUID := '33333333-0000-0000-0000-000000000002';
  g_3    UUID := '33333333-0000-0000-0000-000000000003';
  g_4    UUID := '33333333-0000-0000-0000-000000000004';
  g_5    UUID := '33333333-0000-0000-0000-000000000005';
  g_6    UUID := '33333333-0000-0000-0000-000000000006';
  g_7    UUID := '33333333-0000-0000-0000-000000000007';
  g_8    UUID := '33333333-0000-0000-0000-000000000008';
  g_9    UUID := '33333333-0000-0000-0000-000000000009';
  g_10   UUID := '33333333-0000-0000-0000-000000000010';
  g_11   UUID := '33333333-0000-0000-0000-000000000011';
  g_12   UUID := '33333333-0000-0000-0000-000000000012';
  v_t    UUID;
  v_q    UUID;
BEGIN

-- ── KINDERGARTEN ─────────────────────────────────────────────────────────────

SELECT id INTO v_t FROM topics WHERE name='Counting & Cardinality' AND grade_id=g_k LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_k,v_tt,'There are 5 birds on a branch and 0 on the ground. How many birds are there in total?','single_choice','easy',1,'5 + 0 = 5. Adding zero to any number gives the same number.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','3',FALSE,1),(v_q,'B','4',FALSE,2),(v_q,'C','5',TRUE,3),(v_q,'D','6',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Number Sense 0–20' AND grade_id=g_k LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_k,v_tt,'Which number is bigger: 9 or 6?','single_choice','easy',1,'9 comes after 6 when counting, so 9 is bigger.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','6',FALSE,1),(v_q,'B','They are equal',FALSE,2),(v_q,'C','9',TRUE,3),(v_q,'D','3',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Shapes & Geometry' AND grade_id=g_k LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_k,v_tt,'A pizza slice looks like a triangle. How many sides does a triangle have?','single_choice','easy',1,'A triangle has exactly 3 sides and 3 corners.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','2',FALSE,1),(v_q,'B','3',TRUE,2),(v_q,'C','4',FALSE,3),(v_q,'D','5',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Basic Addition & Subtraction' AND grade_id=g_k LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_k,v_tt,'Ben has 3 toy cars. His mom gives him 4 more. How many toy cars does Ben have now?','single_choice','medium',1,'3 + 4 = 7. Count on from 3: 4, 5, 6, 7.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','6',FALSE,1),(v_q,'B','7',TRUE,2),(v_q,'C','8',FALSE,3),(v_q,'D','9',FALSE,4);

INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_k,v_tt,'There are 6 apples on a tree. 2 apples fall off. How many apples are still on the tree?','single_choice','medium',1,'6 − 2 = 4.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','3',FALSE,1),(v_q,'B','4',TRUE,2),(v_q,'C','5',FALSE,3),(v_q,'D','8',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Patterns' AND grade_id=g_k LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_k,v_tt,'What comes next in the pattern: 1, 2, 1, 2, ___?','single_choice','medium',1,'The pattern repeats 1, 2, 1, 2. After 2 comes 1.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','1',TRUE,1),(v_q,'B','2',FALSE,2),(v_q,'C','3',FALSE,3),(v_q,'D','4',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Number Sense 0–20' AND grade_id=g_k LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_k,v_tt,'What number comes just before 10?','single_choice','medium',1,'When counting: 8, 9, 10 — the number just before 10 is 9.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','8',FALSE,1),(v_q,'B','9',TRUE,2),(v_q,'C','11',FALSE,3),(v_q,'D','12',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Measurement Basics' AND grade_id=g_k LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_k,v_tt,'A pencil is 7 inches long. A crayon is 4 inches long. How much longer is the pencil than the crayon?','single_choice','hard',1,'7 − 4 = 3. The pencil is 3 inches longer.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','2 inches',FALSE,1),(v_q,'B','3 inches',TRUE,2),(v_q,'C','4 inches',FALSE,3),(v_q,'D','11 inches',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Basic Addition & Subtraction' AND grade_id=g_k LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_k,v_tt,'There are 4 red fish and 5 blue fish in a tank. How many fish are there altogether?','single_choice','hard',1,'4 + 5 = 9.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','8',FALSE,1),(v_q,'B','9',TRUE,2),(v_q,'C','10',FALSE,3),(v_q,'D','1',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Number Sense 0–20' AND grade_id=g_k LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_k,v_tt,'Which group of numbers is in order from smallest to biggest?','single_choice','hard',1,'Numbers in order from smallest to biggest: 1, 3, 5, 8.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','5, 3, 8, 1',FALSE,1),(v_q,'B','1, 3, 5, 8',TRUE,2),(v_q,'C','8, 5, 3, 1',FALSE,3),(v_q,'D','3, 5, 1, 8',FALSE,4);

-- ── GRADE 1 ──────────────────────────────────────────────────────────────────

SELECT id INTO v_t FROM topics WHERE name='Addition & Subtraction within 20' AND grade_id=g_1 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_1,v_tt,'What is 8 + 7?','single_choice','easy',1,'8 + 7 = 15. Count on from 8: 9, 10, 11, 12, 13, 14, 15.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','13',FALSE,1),(v_q,'B','14',FALSE,2),(v_q,'C','15',TRUE,3),(v_q,'D','16',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Place Value (tens and ones)' AND grade_id=g_1 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_1,v_tt,'What is the value of the digit 3 in the number 37?','single_choice','easy',1,'The 3 is in the tens place, representing 3 tens = 30.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','3',FALSE,1),(v_q,'B','7',FALSE,2),(v_q,'C','30',TRUE,3),(v_q,'D','70',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Basic Geometry' AND grade_id=g_1 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_1,v_tt,'How many sides does a rectangle have?','single_choice','easy',1,'A rectangle has 4 sides.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','3',FALSE,1),(v_q,'B','4',TRUE,2),(v_q,'C','5',FALSE,3),(v_q,'D','6',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Addition & Subtraction within 20' AND grade_id=g_1 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_1,v_tt,'Jake has 15 stickers. He gives 8 to his friend. How many stickers does Jake have left?','single_choice','medium',1,'15 − 8 = 7.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','6',FALSE,1),(v_q,'B','7',TRUE,2),(v_q,'C','8',FALSE,3),(v_q,'D','23',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Number Patterns' AND grade_id=g_1 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_1,v_tt,'What number is missing? 5, 10, ___, 20, 25','single_choice','medium',1,'Counting by 5s: 5, 10, 15, 20, 25.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','12',FALSE,1),(v_q,'B','14',FALSE,2),(v_q,'C','15',TRUE,3),(v_q,'D','16',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Place Value (tens and ones)' AND grade_id=g_1 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_1,v_tt,'How many tens are in the number 45?','single_choice','medium',1,'45 = 4 tens + 5 ones. There are 4 tens.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','4',TRUE,1),(v_q,'B','5',FALSE,2),(v_q,'C','9',FALSE,3),(v_q,'D','45',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Measurement & Time' AND grade_id=g_1 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_1,v_tt,'A movie starts at 3:00 and lasts 1 hour. What time does it end?','single_choice','medium',1,'3:00 + 1 hour = 4:00.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','2:00',FALSE,1),(v_q,'B','3:30',FALSE,2),(v_q,'C','4:00',TRUE,3),(v_q,'D','4:30',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Addition & Subtraction within 20' AND grade_id=g_1 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_1,v_tt,'Anna has 6 red flowers, 5 yellow flowers, and 4 purple flowers. How many flowers does she have in all?','single_choice','hard',1,'6 + 5 + 4 = 15.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','13',FALSE,1),(v_q,'B','14',FALSE,2),(v_q,'C','15',TRUE,3),(v_q,'D','16',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Number Patterns' AND grade_id=g_1 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_1,v_tt,'What are the two missing numbers? 2, 4, ___, 8, ___, 12','single_choice','hard',1,'Counting by 2s: 2, 4, 6, 8, 10, 12.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','5 and 9',FALSE,1),(v_q,'B','6 and 10',TRUE,2),(v_q,'C','6 and 11',FALSE,3),(v_q,'D','7 and 10',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Addition & Subtraction within 20' AND grade_id=g_1 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_1,v_tt,'There are 11 children in a park. 3 go home. Then 4 more arrive. How many children are in the park now?','single_choice','hard',1,'11 − 3 = 8, then 8 + 4 = 12.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','10',FALSE,1),(v_q,'B','11',FALSE,2),(v_q,'C','12',TRUE,3),(v_q,'D','18',FALSE,4);

-- ── GRADE 2 ──────────────────────────────────────────────────────────────────

SELECT id INTO v_t FROM topics WHERE name='Place Value (hundreds)' AND grade_id=g_2 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_2,v_tt,'What is the value of the digit 5 in 524?','single_choice','easy',1,'5 is in the hundreds place, representing 5 hundreds = 500.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','5',FALSE,1),(v_q,'B','50',FALSE,2),(v_q,'C','500',TRUE,3),(v_q,'D','5,000',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Addition & Subtraction within 1000' AND grade_id=g_2 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_2,v_tt,'245 + 132 = ?','single_choice','easy',1,'Add ones: 5+2=7. Tens: 4+3=7. Hundreds: 2+1=3. Answer: 377.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','377',TRUE,1),(v_q,'B','387',FALSE,2),(v_q,'C','477',FALSE,3),(v_q,'D','487',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Fractions (halves, thirds, fourths)' AND grade_id=g_2 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_2,v_tt,'A pizza is cut into 4 equal pieces. You eat 1 piece. What fraction of the pizza did you eat?','single_choice','easy',1,'You ate 1 out of 4 equal pieces = 1/4.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','1/2',FALSE,1),(v_q,'B','1/3',FALSE,2),(v_q,'C','1/4',TRUE,3),(v_q,'D','1/5',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Introduction to Multiplication' AND grade_id=g_2 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_2,v_tt,'3 bags each have 4 apples. How many apples are there in all?','single_choice','medium',1,'3 × 4 = 12. Or add: 4 + 4 + 4 = 12.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','7',FALSE,1),(v_q,'B','9',FALSE,2),(v_q,'C','12',TRUE,3),(v_q,'D','16',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Addition & Subtraction within 1000' AND grade_id=g_2 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_2,v_tt,'500 − 237 = ?','single_choice','medium',1,'500 − 237 = 263. Check: 237 + 263 = 500.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','237',FALSE,1),(v_q,'B','263',TRUE,2),(v_q,'C','273',FALSE,3),(v_q,'D','763',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Time & Money' AND grade_id=g_2 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_2,v_tt,'You have 3 quarters and 2 dimes. How much money do you have?','single_choice','medium',1,'3 quarters = 75¢. 2 dimes = 20¢. 75¢ + 20¢ = 95¢.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','$0.75',FALSE,1),(v_q,'B','$0.85',FALSE,2),(v_q,'C','$0.95',TRUE,3),(v_q,'D','$1.05',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Fractions (halves, thirds, fourths)' AND grade_id=g_2 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_2,v_tt,'Which fraction is greater: 1/2 or 1/4?','single_choice','medium',1,'Larger denominator means smaller piece. 1/2 is greater than 1/4.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','1/4',FALSE,1),(v_q,'B','1/2',TRUE,2),(v_q,'C','They are equal',FALSE,3),(v_q,'D','Cannot compare',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Introduction to Multiplication' AND grade_id=g_2 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_2,v_tt,'There are 5 rows of chairs with 6 chairs in each row. How many chairs are there altogether?','single_choice','hard',1,'5 × 6 = 30.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','11',FALSE,1),(v_q,'B','25',FALSE,2),(v_q,'C','30',TRUE,3),(v_q,'D','36',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Addition & Subtraction within 1000' AND grade_id=g_2 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_2,v_tt,'A school has 412 boys and 389 girls. How many more boys are there than girls?','single_choice','hard',1,'412 − 389 = 23.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','21',FALSE,1),(v_q,'B','23',TRUE,2),(v_q,'C','31',FALSE,3),(v_q,'D','33',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Place Value (hundreds)' AND grade_id=g_2 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_2,v_tt,'Which number shows 3 hundreds, 0 tens, and 8 ones?','single_choice','hard',1,'300 + 0 + 8 = 308.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','308',TRUE,1),(v_q,'B','380',FALSE,2),(v_q,'C','38',FALSE,3),(v_q,'D','830',FALSE,4);

-- ── GRADE 3 ──────────────────────────────────────────────────────────────────

SELECT id INTO v_t FROM topics WHERE name='Multiplication & Division' AND grade_id=g_3 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_3,v_tt,'7 × 8 = ?','single_choice','easy',1,'7 × 8 = 56. A key multiplication fact to memorize.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','48',FALSE,1),(v_q,'B','54',FALSE,2),(v_q,'C','56',TRUE,3),(v_q,'D','64',FALSE,4);

INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_3,v_tt,'36 ÷ 6 = ?','single_choice','easy',1,'36 ÷ 6 = 6. Check: 6 × 6 = 36.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','5',FALSE,1),(v_q,'B','6',TRUE,2),(v_q,'C','7',FALSE,3),(v_q,'D','8',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Fractions' AND grade_id=g_3 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_3,v_tt,'Which fraction equals 1/2?','single_choice','easy',1,'2/4 = 1/2. Both numerator and denominator are multiplied by 2.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','2/6',FALSE,1),(v_q,'B','2/4',TRUE,2),(v_q,'C','3/8',FALSE,3),(v_q,'D','2/3',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Area & Perimeter' AND grade_id=g_3 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_3,v_tt,'A rectangle is 4 inches long and 3 inches wide. What is its area?','single_choice','medium',1,'Area = length × width = 4 × 3 = 12 square inches.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','7 sq in',FALSE,1),(v_q,'B','10 sq in',FALSE,2),(v_q,'C','12 sq in',TRUE,3),(v_q,'D','14 sq in',FALSE,4);

INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_3,v_tt,'A square has sides of 5 cm each. What is its perimeter?','single_choice','medium',1,'Perimeter = 4 × side = 4 × 5 = 20 cm.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','10 cm',FALSE,1),(v_q,'B','20 cm',TRUE,2),(v_q,'C','25 cm',FALSE,3),(v_q,'D','30 cm',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Place Value & Rounding' AND grade_id=g_3 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_3,v_tt,'Round 347 to the nearest hundred.','single_choice','medium',1,'The tens digit (4) is less than 5, so round down to 300.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','300',TRUE,1),(v_q,'B','340',FALSE,2),(v_q,'C','350',FALSE,3),(v_q,'D','400',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Multiplication & Division' AND grade_id=g_3 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_3,v_tt,'A bookshelf has 6 shelves, and each shelf holds 9 books. How many books can the shelf hold in all?','single_choice','medium',1,'6 × 9 = 54.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','15',FALSE,1),(v_q,'B','48',FALSE,2),(v_q,'C','54',TRUE,3),(v_q,'D','63',FALSE,4);

INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_3,v_tt,'48 students are divided equally into 6 groups. How many students are in each group?','single_choice','hard',1,'48 ÷ 6 = 8.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','6',FALSE,1),(v_q,'B','7',FALSE,2),(v_q,'C','8',TRUE,3),(v_q,'D','9',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Area & Perimeter' AND grade_id=g_3 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_3,v_tt,'A garden is 8 meters long and 5 meters wide. What is the perimeter of the garden?','single_choice','hard',1,'Perimeter = 2 × (length + width) = 2 × 13 = 26 m.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','13 m',FALSE,1),(v_q,'B','26 m',TRUE,2),(v_q,'C','40 m',FALSE,3),(v_q,'D','52 m',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Fractions' AND grade_id=g_3 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_3,v_tt,'Mrs. Smith has 24 students. 1/3 of them are wearing hats. How many students are wearing hats?','single_choice','hard',1,'1/3 of 24 = 24 ÷ 3 = 8.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','6',FALSE,1),(v_q,'B','8',TRUE,2),(v_q,'C','12',FALSE,3),(v_q,'D','16',FALSE,4);

-- ── GRADE 4 ──────────────────────────────────────────────────────────────────

SELECT id INTO v_t FROM topics WHERE name='Multi-digit Multiplication' AND grade_id=g_4 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_4,v_tt,'23 × 4 = ?','single_choice','easy',1,'20×4=80, 3×4=12. 80+12=92.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','82',FALSE,1),(v_q,'B','92',TRUE,2),(v_q,'C','102',FALSE,3),(v_q,'D','112',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Factors & Multiples' AND grade_id=g_4 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_4,v_tt,'What are all the factors of 12?','single_choice','easy',1,'Factors of 12: 1×12, 2×6, 3×4. So: 1, 2, 3, 4, 6, 12.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','1, 2, 3, 4, 6, 12',TRUE,1),(v_q,'B','2, 3, 4, 6',FALSE,2),(v_q,'C','1, 2, 4, 6, 12',FALSE,3),(v_q,'D','1, 3, 4, 6, 12',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Fractions & Decimals' AND grade_id=g_4 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_4,v_tt,'What is 3/4 written as a decimal?','single_choice','easy',1,'3 ÷ 4 = 0.75.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','0.34',FALSE,1),(v_q,'B','0.43',FALSE,2),(v_q,'C','0.75',TRUE,3),(v_q,'D','0.85',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Multi-digit Multiplication' AND grade_id=g_4 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_4,v_tt,'143 × 6 = ?','single_choice','medium',1,'100×6=600, 40×6=240, 3×6=18. 600+240+18=858.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','828',FALSE,1),(v_q,'B','858',TRUE,2),(v_q,'C','878',FALSE,3),(v_q,'D','908',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Division with Remainders' AND grade_id=g_4 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_4,v_tt,'29 ÷ 4 = ?','single_choice','medium',1,'4 × 7 = 28. 29 − 28 = 1. So 29 ÷ 4 = 7 remainder 1.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','6 R3',FALSE,1),(v_q,'B','7 R1',TRUE,2),(v_q,'C','7 R3',FALSE,3),(v_q,'D','8 R1',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Angles & Geometry' AND grade_id=g_4 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_4,v_tt,'What type of angle is exactly 90°?','single_choice','medium',1,'An angle of exactly 90° is called a right angle.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','Acute',FALSE,1),(v_q,'B','Right',TRUE,2),(v_q,'C','Obtuse',FALSE,3),(v_q,'D','Straight',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Fractions & Decimals' AND grade_id=g_4 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_4,v_tt,'Which fraction is greater: 3/4 or 5/8?','single_choice','medium',1,'3/4 = 6/8. Since 6/8 > 5/8, then 3/4 > 5/8.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','3/4',TRUE,1),(v_q,'B','5/8',FALSE,2),(v_q,'C','They are equal',FALSE,3),(v_q,'D','Cannot be compared',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Multi-digit Multiplication' AND grade_id=g_4 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_4,v_tt,'52 × 37 = ?','single_choice','hard',1,'52×30=1,560. 52×7=364. 1,560+364=1,924.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','1,814',FALSE,1),(v_q,'B','1,924',TRUE,2),(v_q,'C','2,014',FALSE,3),(v_q,'D','2,124',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Division with Remainders' AND grade_id=g_4 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_4,v_tt,'315 ÷ 7 = ?','single_choice','hard',1,'7 × 45 = 315. Check: 7×40=280, 7×5=35. 280+35=315.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','40',FALSE,1),(v_q,'B','44',FALSE,2),(v_q,'C','45',TRUE,3),(v_q,'D','46',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Multi-digit Multiplication' AND grade_id=g_4 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_4,v_tt,'Maria buys 4 bags of marbles with 36 marbles each. She gives 28 marbles to her brother. How many marbles does Maria have left?','single_choice','hard',1,'4 × 36 = 144. 144 − 28 = 116.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','108',FALSE,1),(v_q,'B','116',TRUE,2),(v_q,'C','120',FALSE,3),(v_q,'D','136',FALSE,4);

-- ── GRADE 5 ──────────────────────────────────────────────────────────────────

SELECT id INTO v_t FROM topics WHERE name='Decimals Operations' AND grade_id=g_5 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_5,v_tt,'3.5 + 2.7 = ?','single_choice','easy',1,'3.5 + 2.7 = 6.2.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','5.2',FALSE,1),(v_q,'B','6.0',FALSE,2),(v_q,'C','6.2',TRUE,3),(v_q,'D','7.2',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Fractions Operations' AND grade_id=g_5 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_5,v_tt,'1/4 + 1/4 = ?','single_choice','easy',1,'Same denominators: add numerators. 1/4 + 1/4 = 2/4 = 1/2.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','1/8',FALSE,1),(v_q,'B','2/8',FALSE,2),(v_q,'C','1/2',TRUE,3),(v_q,'D','1',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Volume' AND grade_id=g_5 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_5,v_tt,'What is the volume of a rectangular box that is 4 cm long, 3 cm wide, and 2 cm tall?','single_choice','easy',1,'Volume = length × width × height = 4 × 3 × 2 = 24 cm³.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','9 cm³',FALSE,1),(v_q,'B','18 cm³',FALSE,2),(v_q,'C','24 cm³',TRUE,3),(v_q,'D','36 cm³',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Fractions Operations' AND grade_id=g_5 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_5,v_tt,'What is 1/2 × 4/5?','single_choice','medium',1,'Multiply numerators and denominators: 1×4 / 2×5 = 4/10 = 2/5.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','5/10',FALSE,1),(v_q,'B','2/5',TRUE,2),(v_q,'C','4/7',FALSE,3),(v_q,'D','8/10',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Decimals Operations' AND grade_id=g_5 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_5,v_tt,'4.2 × 3 = ?','single_choice','medium',1,'Think 42 × 3 = 126, then place decimal: 12.6.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','12.2',FALSE,1),(v_q,'B','12.6',TRUE,2),(v_q,'C','13.2',FALSE,3),(v_q,'D','14.2',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Powers of 10 & Place Value' AND grade_id=g_5 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_5,v_tt,'What is 10³?','single_choice','medium',1,'10³ = 10 × 10 × 10 = 1,000.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','30',FALSE,1),(v_q,'B','300',FALSE,2),(v_q,'C','1,000',TRUE,3),(v_q,'D','10,000',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Coordinate Plane' AND grade_id=g_5 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_5,v_tt,'What are the coordinates of a point 4 units to the right of the origin and 6 units up?','single_choice','medium',1,'x = horizontal (right), y = vertical (up). Point is (4, 6).') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','(6, 4)',FALSE,1),(v_q,'B','(4, 6)',TRUE,2),(v_q,'C','(0, 4)',FALSE,3),(v_q,'D','(6, 0)',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Fractions Operations' AND grade_id=g_5 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_5,v_tt,'2/3 + 3/4 = ?','single_choice','hard',1,'LCD = 12. 2/3 = 8/12, 3/4 = 9/12. Sum = 17/12.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','5/12',FALSE,1),(v_q,'B','5/7',FALSE,2),(v_q,'C','17/12',TRUE,3),(v_q,'D','6/12',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Decimals Operations' AND grade_id=g_5 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_5,v_tt,'14.4 ÷ 0.4 = ?','single_choice','hard',1,'Multiply both by 10: 144 ÷ 4 = 36.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','3.6',FALSE,1),(v_q,'B','36',TRUE,2),(v_q,'C','360',FALSE,3),(v_q,'D','0.36',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Volume' AND grade_id=g_5 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_5,v_tt,'A swimming pool is 10 m long, 5 m wide, and 2 m deep. How many cubic meters of water can it hold?','single_choice','hard',1,'Volume = 10 × 5 × 2 = 100 m³.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','17',FALSE,1),(v_q,'B','34',FALSE,2),(v_q,'C','50',FALSE,3),(v_q,'D','100',TRUE,4);

-- ── GRADE 6 ──────────────────────────────────────────────────────────────────

SELECT id INTO v_t FROM topics WHERE name='Integers & Number System' AND grade_id=g_6 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_6,v_tt,'Order from least to greatest: −3, 5, −7, 2, 0','single_choice','easy',1,'On a number line: −7 < −3 < 0 < 2 < 5.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','−7, −3, 0, 2, 5',TRUE,1),(v_q,'B','−3, −7, 0, 2, 5',FALSE,2),(v_q,'C','5, 2, 0, −3, −7',FALSE,3),(v_q,'D','0, −3, −7, 2, 5',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Ratios & Proportional Relationships' AND grade_id=g_6 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_6,v_tt,'In a class of 30 students, 18 are girls. What is the ratio of boys to girls?','single_choice','easy',1,'Boys = 30−18 = 12. Ratio = 12:18 = 2:3.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','3:2',FALSE,1),(v_q,'B','2:3',TRUE,2),(v_q,'C','3:5',FALSE,3),(v_q,'D','2:5',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Fractions, Decimals & Percents' AND grade_id=g_6 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_6,v_tt,'What is 25% of 80?','single_choice','easy',1,'25% = 1/4. 80 ÷ 4 = 20.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','16',FALSE,1),(v_q,'B','20',TRUE,2),(v_q,'C','25',FALSE,3),(v_q,'D','40',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Expressions & Equations' AND grade_id=g_6 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_6,v_tt,'Simplify: 3x + 5x − 2x','single_choice','medium',1,'(3 + 5 − 2)x = 6x.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','5x',FALSE,1),(v_q,'B','6x',TRUE,2),(v_q,'C','8x',FALSE,3),(v_q,'D','10x',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Integers & Number System' AND grade_id=g_6 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_6,v_tt,'−8 + 15 = ?','single_choice','medium',1,'Start at −8, move 15 to the right: −8 + 15 = 7.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','−23',FALSE,1),(v_q,'B','−7',FALSE,2),(v_q,'C','7',TRUE,3),(v_q,'D','23',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Statistics & Probability' AND grade_id=g_6 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_6,v_tt,'Data set: 4, 7, 7, 9, 8, 7, 5. What is the mode?','single_choice','medium',1,'The mode is the most frequent value. 7 appears 3 times.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','5',FALSE,1),(v_q,'B','7',TRUE,2),(v_q,'C','8',FALSE,3),(v_q,'D','9',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Geometry (Area, Surface Area, Volume)' AND grade_id=g_6 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_6,v_tt,'Find the area of a triangle with base 10 cm and height 6 cm.','single_choice','medium',1,'Area = (1/2) × base × height = (1/2) × 10 × 6 = 30 cm².') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','16 cm²',FALSE,1),(v_q,'B','30 cm²',TRUE,2),(v_q,'C','60 cm²',FALSE,3),(v_q,'D','80 cm²',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Expressions & Equations' AND grade_id=g_6 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_6,v_tt,'Solve for x: 3x + 7 = 22','single_choice','hard',1,'3x = 15 → x = 5.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','x = 4',FALSE,1),(v_q,'B','x = 5',TRUE,2),(v_q,'C','x = 7',FALSE,3),(v_q,'D','x = 9',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Ratios & Proportional Relationships' AND grade_id=g_6 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_6,v_tt,'A map uses a scale of 1 cm : 50 km. If two cities are 7 cm apart on the map, how far apart are they in real life?','single_choice','hard',1,'7 cm × 50 km/cm = 350 km.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','57 km',FALSE,1),(v_q,'B','250 km',FALSE,2),(v_q,'C','350 km',TRUE,3),(v_q,'D','500 km',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Statistics & Probability' AND grade_id=g_6 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_6,v_tt,'Test scores for 5 students: 72, 85, 90, 68, 75. What is the mean (average) score?','single_choice','hard',1,'Sum = 390. Mean = 390 ÷ 5 = 78.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','78',TRUE,1),(v_q,'B','80',FALSE,2),(v_q,'C','82',FALSE,3),(v_q,'D','85',FALSE,4);

-- ── GRADE 7 ──────────────────────────────────────────────────────────────────

SELECT id INTO v_t FROM topics WHERE name='Proportional Relationships' AND grade_id=g_7 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_7,v_tt,'If 5 notebooks cost $12.50, how much do 8 notebooks cost?','single_choice','easy',1,'Price per notebook = $12.50 ÷ 5 = $2.50. For 8: 8 × $2.50 = $20.00.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','$18.00',FALSE,1),(v_q,'B','$20.00',TRUE,2),(v_q,'C','$22.50',FALSE,3),(v_q,'D','$25.00',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Rational Numbers' AND grade_id=g_7 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_7,v_tt,'−4.5 + (−3.5) = ?','single_choice','easy',1,'Adding two negatives: −(4.5 + 3.5) = −8.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','−8',TRUE,1),(v_q,'B','−1',FALSE,2),(v_q,'C','1',FALSE,3),(v_q,'D','8',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Expressions, Equations & Inequalities' AND grade_id=g_7 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_7,v_tt,'Solve: 2x − 5 = 11','single_choice','easy',1,'2x = 16 → x = 8.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','x = 3',FALSE,1),(v_q,'B','x = 8',TRUE,2),(v_q,'C','x = 11',FALSE,3),(v_q,'D','x = 16',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Percents & Financial Literacy' AND grade_id=g_7 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_7,v_tt,'A jacket costs $80. It is on sale for 30% off. What is the sale price?','single_choice','medium',1,'Discount = 30% × $80 = $24. Sale price = $80 − $24 = $56.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','$24',FALSE,1),(v_q,'B','$50',FALSE,2),(v_q,'C','$56',TRUE,3),(v_q,'D','$74',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Rational Numbers' AND grade_id=g_7 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_7,v_tt,'(−3) × (−7) = ?','single_choice','medium',1,'Negative × Negative = Positive. 3 × 7 = 21.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','−21',FALSE,1),(v_q,'B','−10',FALSE,2),(v_q,'C','10',FALSE,3),(v_q,'D','21',TRUE,4);

SELECT id INTO v_t FROM topics WHERE name='Expressions, Equations & Inequalities' AND grade_id=g_7 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_7,v_tt,'Which value of x satisfies 3x − 4 > 8?','single_choice','medium',1,'3x > 12 → x > 4. Only x=5 satisfies: 3(5)−4=11>8.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','x = 2',FALSE,1),(v_q,'B','x = 3',FALSE,2),(v_q,'C','x = 4',FALSE,3),(v_q,'D','x = 5',TRUE,4);

SELECT id INTO v_t FROM topics WHERE name='Statistics & Probability' AND grade_id=g_7 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_7,v_tt,'A bag has 3 red, 5 blue, and 2 green marbles. What is the probability of picking a blue marble?','single_choice','medium',1,'P(blue) = 5/10 = 1/2. Total = 10.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','1/5',FALSE,1),(v_q,'B','1/2',TRUE,2),(v_q,'C','3/10',FALSE,3),(v_q,'D','5/3',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Geometry (Scale, Area, Surface Area)' AND grade_id=g_7 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_7,v_tt,'Find the surface area of a rectangular prism: length 5 cm, width 3 cm, height 4 cm.','single_choice','hard',1,'SA = 2(lw+lh+wh) = 2(15+20+12) = 2×47 = 94 cm².') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','47 cm²',FALSE,1),(v_q,'B','60 cm²',FALSE,2),(v_q,'C','94 cm²',TRUE,3),(v_q,'D','120 cm²',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Proportional Relationships' AND grade_id=g_7 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_7,v_tt,'Two similar triangles have sides in ratio 2:5. If the smaller triangle has a side of 8 cm, what is the corresponding side of the larger?','single_choice','hard',1,'8/x = 2/5 → 2x = 40 → x = 20 cm.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','16 cm',FALSE,1),(v_q,'B','20 cm',TRUE,2),(v_q,'C','25 cm',FALSE,3),(v_q,'D','40 cm',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Percents & Financial Literacy' AND grade_id=g_7 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_7,v_tt,'You invest $500 at a simple interest rate of 4% per year. How much interest will you earn after 3 years?','single_choice','hard',1,'I = P × r × t = $500 × 0.04 × 3 = $60.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','$20',FALSE,1),(v_q,'B','$60',TRUE,2),(v_q,'C','$80',FALSE,3),(v_q,'D','$120',FALSE,4);

-- ── GRADE 8 ──────────────────────────────────────────────────────────────────

SELECT id INTO v_t FROM topics WHERE name='Geometry (Transformations, Pythagorean)' AND grade_id=g_8 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_8,v_tt,'A right triangle has legs of 3 and 4. What is the length of the hypotenuse?','single_choice','easy',1,'c² = 3² + 4² = 9 + 16 = 25. c = √25 = 5.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','5',TRUE,1),(v_q,'B','7',FALSE,2),(v_q,'C','9',FALSE,3),(v_q,'D','25',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Exponents & Scientific Notation' AND grade_id=g_8 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_8,v_tt,'Write 6,500 in scientific notation.','single_choice','easy',1,'6,500 = 6.5 × 1,000 = 6.5 × 10³.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','65 × 10²',FALSE,1),(v_q,'B','6.5 × 10³',TRUE,2),(v_q,'C','0.65 × 10⁴',FALSE,3),(v_q,'D','65 × 100',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Linear Equations & Systems' AND grade_id=g_8 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_8,v_tt,'Solve: 5x = 35','single_choice','easy',1,'x = 35 ÷ 5 = 7.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','x = 5',FALSE,1),(v_q,'B','x = 7',TRUE,2),(v_q,'C','x = 30',FALSE,3),(v_q,'D','x = 175',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Geometry (Transformations, Pythagorean)' AND grade_id=g_8 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_8,v_tt,'A 13 ft ladder leans against a wall. The base is 5 ft from the wall. How high up does the ladder reach?','single_choice','medium',1,'13² − 5² = 169 − 25 = 144. Height = √144 = 12 ft.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','8 ft',FALSE,1),(v_q,'B','12 ft',TRUE,2),(v_q,'C','13 ft',FALSE,3),(v_q,'D','18 ft',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Linear Equations & Systems' AND grade_id=g_8 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_8,v_tt,'If x + y = 10 and x − y = 4, what is the value of x?','single_choice','medium',1,'Add the equations: 2x = 14 → x = 7.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','3',FALSE,1),(v_q,'B','6',FALSE,2),(v_q,'C','7',TRUE,3),(v_q,'D','8',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Functions' AND grade_id=g_8 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_8,v_tt,'Which equation represents a linear function?','single_choice','medium',1,'A linear function has the form y = mx + b. y = 3x + 2 fits this.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','y = x²',FALSE,1),(v_q,'B','y = √x',FALSE,2),(v_q,'C','y = 3x + 2',TRUE,3),(v_q,'D','y = 1/x',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Exponents & Scientific Notation' AND grade_id=g_8 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_8,v_tt,'Simplify: 2³ × 2⁴','single_choice','medium',1,'Same base: add exponents. 2³ × 2⁴ = 2⁷.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','2⁷',TRUE,1),(v_q,'B','2¹²',FALSE,2),(v_q,'C','4⁷',FALSE,3),(v_q,'D','8⁴',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Linear Equations & Systems' AND grade_id=g_8 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_8,v_tt,'What is the slope of the line passing through (2, 3) and (6, 11)?','single_choice','hard',1,'Slope = (11−3)/(6−2) = 8/4 = 2.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','1/2',FALSE,1),(v_q,'B','2',TRUE,2),(v_q,'C','4',FALSE,3),(v_q,'D','8',FALSE,4);

INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_8,v_tt,'Solve the system: y = 2x + 1 and y = −x + 7. What is x?','single_choice','hard',1,'2x + 1 = −x + 7 → 3x = 6 → x = 2.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','x = 1',FALSE,1),(v_q,'B','x = 2',TRUE,2),(v_q,'C','x = 3',FALSE,3),(v_q,'D','x = 4',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Irrational Numbers & Real Number System' AND grade_id=g_8 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_8,v_tt,'Which of the following is an irrational number?','single_choice','hard',1,'√4=2, √9=3, √16=4 are rational. √5 ≈ 2.236... is non-terminating and non-repeating.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','√4',FALSE,1),(v_q,'B','√9',FALSE,2),(v_q,'C','√16',FALSE,3),(v_q,'D','√5',TRUE,4);

-- ── GRADE 9 ──────────────────────────────────────────────────────────────────

SELECT id INTO v_t FROM topics WHERE name='Linear Equations & Inequalities' AND grade_id=g_9 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_9,v_tt,'Solve: 3x + 9 = 24','single_choice','easy',1,'3x = 15 → x = 5.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','x = 3',FALSE,1),(v_q,'B','x = 5',TRUE,2),(v_q,'C','x = 7',FALSE,3),(v_q,'D','x = 11',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Polynomials & Factoring' AND grade_id=g_9 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_9,v_tt,'Simplify: (3x² + 2x) + (x² − 5x)','single_choice','easy',1,'3x²+x²=4x². 2x−5x=−3x. Result: 4x²−3x.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','4x²−3x',TRUE,1),(v_q,'B','4x²+7x',FALSE,2),(v_q,'C','2x²−3x',FALSE,3),(v_q,'D','4x³−3x',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Expressions & Properties' AND grade_id=g_9 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_9,v_tt,'Evaluate 2x² − 3x + 1 when x = 2','single_choice','easy',1,'2(4) − 3(2) + 1 = 8 − 6 + 1 = 3.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','1',FALSE,1),(v_q,'B','3',TRUE,2),(v_q,'C','5',FALSE,3),(v_q,'D','7',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Polynomials & Factoring' AND grade_id=g_9 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_9,v_tt,'Factor: x² − 5x + 6','single_choice','medium',1,'Need two numbers that multiply to 6 and add to −5: −2 and −3. Answer: (x−2)(x−3).') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','(x−1)(x−6)',FALSE,1),(v_q,'B','(x−2)(x−3)',TRUE,2),(v_q,'C','(x+2)(x+3)',FALSE,3),(v_q,'D','(x−2)(x+3)',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Quadratic Functions' AND grade_id=g_9 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_9,v_tt,'What are the solutions to x² − 9 = 0?','single_choice','medium',1,'x² = 9 → x = ±√9 = ±3.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','x = ±3',TRUE,1),(v_q,'B','x = ±9',FALSE,2),(v_q,'C','x = 3 only',FALSE,3),(v_q,'D','x = −3 only',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Linear Equations & Inequalities' AND grade_id=g_9 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_9,v_tt,'Solve: −2x + 6 > 2','single_choice','medium',1,'−2x > −4 → x < 2. (Flip inequality when dividing by a negative.)') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','x < 2',TRUE,1),(v_q,'B','x > 2',FALSE,2),(v_q,'C','x < −2',FALSE,3),(v_q,'D','x > −2',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Systems of Equations' AND grade_id=g_9 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_9,v_tt,'Solve the system: 2x + y = 8 and x − y = 1. What is the solution (x, y)?','single_choice','medium',1,'Add: 3x = 9 → x = 3. Sub: 3 − y = 1 → y = 2.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','(2, 4)',FALSE,1),(v_q,'B','(3, 2)',TRUE,2),(v_q,'C','(4, 0)',FALSE,3),(v_q,'D','(1, 6)',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Quadratic Functions' AND grade_id=g_9 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_9,v_tt,'What is the vertex of the parabola y = x² − 4x + 7?','single_choice','hard',1,'Vertex x = −b/2a = 4/2 = 2. y = 4−8+7 = 3. Vertex: (2, 3).') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','(2, 3)',TRUE,1),(v_q,'B','(4, 7)',FALSE,2),(v_q,'C','(−2, 3)',FALSE,3),(v_q,'D','(2, −3)',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Polynomials & Factoring' AND grade_id=g_9 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_9,v_tt,'Solve: x² + 7x + 12 = 0','single_choice','hard',1,'Factor: (x+3)(x+4) = 0. Solutions: x = −3 or x = −4.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','x = 3, x = 4',FALSE,1),(v_q,'B','x = −3, x = −4',TRUE,2),(v_q,'C','x = −3, x = 4',FALSE,3),(v_q,'D','x = 3, x = −4',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Exponential Functions' AND grade_id=g_9 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_9,v_tt,'A bacteria population doubles every hour. Starting with 50 bacteria, how many are there after 4 hours?','single_choice','hard',1,'P = 50 × 2⁴ = 50 × 16 = 800.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','200',FALSE,1),(v_q,'B','400',FALSE,2),(v_q,'C','800',TRUE,3),(v_q,'D','1,600',FALSE,4);

-- ── GRADE 10 ─────────────────────────────────────────────────────────────────

SELECT id INTO v_t FROM topics WHERE name='Trigonometric Ratios' AND grade_id=g_10 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_10,v_tt,'In a right triangle, if sin(θ) = 3/5, what is cos(θ)?','single_choice','easy',1,'sin²θ + cos²θ = 1 → cos²θ = 1 − 9/25 = 16/25 → cosθ = 4/5.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','3/4',FALSE,1),(v_q,'B','4/5',TRUE,2),(v_q,'C','3/5',FALSE,3),(v_q,'D','5/3',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Coordinate Geometry' AND grade_id=g_10 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_10,v_tt,'What is the midpoint of the segment from (2, 4) to (8, 10)?','single_choice','easy',1,'Midpoint = ((2+8)/2, (4+10)/2) = (5, 7).') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','(3, 5)',FALSE,1),(v_q,'B','(5, 7)',TRUE,2),(v_q,'C','(6, 7)',FALSE,3),(v_q,'D','(10, 14)',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Circles & Theorems' AND grade_id=g_10 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_10,v_tt,'The radius of a circle is 7 cm. What is the circumference? (Use π ≈ 3.14)','single_choice','easy',1,'C = 2πr = 2 × 3.14 × 7 = 43.96 cm.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','21.98 cm',FALSE,1),(v_q,'B','43.96 cm',TRUE,2),(v_q,'C','153.86 cm',FALSE,3),(v_q,'D','49 cm',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Congruence & Similarity' AND grade_id=g_10 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_10,v_tt,'Two similar triangles have sides in ratio 3:5. If the smaller has area 27 cm², what is the area of the larger?','single_choice','medium',1,'Area ratio = (3/5)² = 9/25. Larger area = 27 × (25/9) = 75 cm².') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','45 cm²',FALSE,1),(v_q,'B','55 cm²',FALSE,2),(v_q,'C','75 cm²',TRUE,3),(v_q,'D','135 cm²',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Coordinate Geometry' AND grade_id=g_10 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_10,v_tt,'What is the distance between points (1, 2) and (4, 6)?','single_choice','medium',1,'d = √((4−1)² + (6−2)²) = √(9+16) = √25 = 5.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','3',FALSE,1),(v_q,'B','4',FALSE,2),(v_q,'C','5',TRUE,3),(v_q,'D','7',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Trigonometric Ratios' AND grade_id=g_10 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_10,v_tt,'In right triangle ABC with right angle at C, if AC = 5 and BC = 12, what is tan(A)?','single_choice','medium',1,'tan(A) = opposite/adjacent = BC/AC = 12/5.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','5/12',FALSE,1),(v_q,'B','12/5',TRUE,2),(v_q,'C','5/13',FALSE,3),(v_q,'D','12/13',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Probability' AND grade_id=g_10 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_10,v_tt,'A die is rolled twice. What is the probability of getting a 6 both times?','single_choice','medium',1,'P = 1/6 × 1/6 = 1/36.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','1/6',FALSE,1),(v_q,'B','1/12',FALSE,2),(v_q,'C','1/36',TRUE,3),(v_q,'D','2/6',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Circles & Theorems' AND grade_id=g_10 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_10,v_tt,'A chord is 16 cm long and is 6 cm from the center. What is the radius?','single_choice','hard',1,'Half-chord = 8. r² = 8² + 6² = 64+36 = 100. r = 10 cm.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','8 cm',FALSE,1),(v_q,'B','10 cm',TRUE,2),(v_q,'C','12 cm',FALSE,3),(v_q,'D','14 cm',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Coordinate Geometry' AND grade_id=g_10 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_10,v_tt,'What is the equation of a line through (3, −1) with slope 2?','single_choice','hard',1,'y − (−1) = 2(x−3) → y+1 = 2x−6 → y = 2x−7.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','y = 2x + 5',FALSE,1),(v_q,'B','y = 2x − 7',TRUE,2),(v_q,'C','y = 2x + 3',FALSE,3),(v_q,'D','y = −2x + 5',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Congruence & Similarity' AND grade_id=g_10 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_10,v_tt,'Two triangles have two pairs of congruent angles. Which theorem proves they are similar?','single_choice','hard',1,'The AA (Angle-Angle) similarity theorem: two pairs of congruent angles prove triangles similar.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','SSS',FALSE,1),(v_q,'B','SAS',FALSE,2),(v_q,'C','AA',TRUE,3),(v_q,'D','AAS',FALSE,4);

-- ── GRADE 11 ─────────────────────────────────────────────────────────────────

SELECT id INTO v_t FROM topics WHERE name='Sequences & Series' AND grade_id=g_11 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_11,v_tt,'What is the 8th term of the arithmetic sequence: 3, 7, 11, 15, ...?','single_choice','easy',1,'aₙ = a₁ + (n−1)d = 3 + 7×4 = 31.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','31',TRUE,1),(v_q,'B','33',FALSE,2),(v_q,'C','35',FALSE,3),(v_q,'D','37',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Trigonometry' AND grade_id=g_11 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_11,v_tt,'What is sin(30°)?','single_choice','easy',1,'sin(30°) = 1/2. Standard value to memorize.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','√3/2',FALSE,1),(v_q,'B','1/2',TRUE,2),(v_q,'C','√2/2',FALSE,3),(v_q,'D','1',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Polynomial & Rational Functions' AND grade_id=g_11 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_11,v_tt,'What is the degree of the polynomial 4x³ − 2x² + 7x − 1?','single_choice','easy',1,'The degree is the highest power of x, which is 3.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','1',FALSE,1),(v_q,'B','2',FALSE,2),(v_q,'C','3',TRUE,3),(v_q,'D','4',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Sequences & Series' AND grade_id=g_11 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_11,v_tt,'Find the sum of the first 6 terms of the geometric sequence: 2, 6, 18, 54, ...','single_choice','medium',1,'S₆ = 2(3⁶−1)/(3−1) = 2×728/2 = 728.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','182',FALSE,1),(v_q,'B','242',FALSE,2),(v_q,'C','364',FALSE,3),(v_q,'D','728',TRUE,4);

SELECT id INTO v_t FROM topics WHERE name='Trigonometry' AND grade_id=g_11 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_11,v_tt,'Simplify: sin²θ + cos²θ','single_choice','medium',1,'This is the fundamental Pythagorean identity and always equals 1.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','0',FALSE,1),(v_q,'B','1',TRUE,2),(v_q,'C','sin(2θ)',FALSE,3),(v_q,'D','2',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Conic Sections' AND grade_id=g_11 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_11,v_tt,'What shape is represented by x² + y² = 25?','single_choice','medium',1,'x² + y² = r² is a circle centered at the origin with radius 5.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','Parabola',FALSE,1),(v_q,'B','Ellipse',FALSE,2),(v_q,'C','Circle',TRUE,3),(v_q,'D','Hyperbola',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Probability & Statistics' AND grade_id=g_11 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_11,v_tt,'In how many ways can 4 books be arranged on a shelf?','single_choice','medium',1,'4! = 4 × 3 × 2 × 1 = 24 ways.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','8',FALSE,1),(v_q,'B','16',FALSE,2),(v_q,'C','24',TRUE,3),(v_q,'D','48',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Polynomial & Rational Functions' AND grade_id=g_11 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_11,v_tt,'Find all zeros of f(x) = x³ − 4x','single_choice','hard',1,'f(x) = x(x²−4) = x(x−2)(x+2). Zeros: x = 0, ±2.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','x = 0, ±2',TRUE,1),(v_q,'B','x = 0, ±4',FALSE,2),(v_q,'C','x = ±2',FALSE,3),(v_q,'D','x = 0, 4',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Trigonometry' AND grade_id=g_11 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_11,v_tt,'Solve for x in [0°, 360°]: 2sin(x) − 1 = 0','single_choice','hard',1,'sin(x) = 1/2. x = 30° or x = 180°−30° = 150°.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','30° and 150°',TRUE,1),(v_q,'B','60° and 120°',FALSE,2),(v_q,'C','45° and 135°',FALSE,3),(v_q,'D','30° only',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Sequences & Series' AND grade_id=g_11 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_11,v_tt,'Find the sum of the infinite geometric series: 8 + 4 + 2 + 1 + ...','single_choice','hard',1,'S = a/(1−r) = 8/(1−1/2) = 8/(1/2) = 16.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','12',FALSE,1),(v_q,'B','14',FALSE,2),(v_q,'C','16',TRUE,3),(v_q,'D','32',FALSE,4);

-- ── GRADE 12 ─────────────────────────────────────────────────────────────────

SELECT id INTO v_t FROM topics WHERE name='Limits & Continuity' AND grade_id=g_12 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_12,v_tt,'What is lim(x→3) of (x² − 9)/(x − 3)?','single_choice','easy',1,'Factor: (x−3)(x+3)/(x−3) = x+3. As x→3: 3+3 = 6.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','0',FALSE,1),(v_q,'B','3',FALSE,2),(v_q,'C','6',TRUE,3),(v_q,'D','9',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Derivatives' AND grade_id=g_12 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_12,v_tt,'What is the derivative of f(x) = x³?','single_choice','easy',1,'Power rule: d/dx[xⁿ] = nxⁿ⁻¹. d/dx[x³] = 3x².') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','x²',FALSE,1),(v_q,'B','3x',FALSE,2),(v_q,'C','3x²',TRUE,3),(v_q,'D','x³',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Integrals' AND grade_id=g_12 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_12,v_tt,'What is ∫2x dx?','single_choice','easy',1,'Power rule for integration: ∫xⁿ dx = xⁿ⁺¹/(n+1) + C. ∫2x dx = x² + C.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','2',FALSE,1),(v_q,'B','x²',FALSE,2),(v_q,'C','x² + C',TRUE,3),(v_q,'D','2x² + C',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Derivatives' AND grade_id=g_12 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_12,v_tt,'What is the derivative of f(x) = 3x² − 5x + 2?','single_choice','medium',1,'Apply power rule: d/dx[3x²] = 6x, d/dx[−5x] = −5, d/dx[2] = 0.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','6x − 5',TRUE,1),(v_q,'B','3x − 5',FALSE,2),(v_q,'C','6x + 2',FALSE,3),(v_q,'D','6x² − 5',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Limits & Continuity' AND grade_id=g_12 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_12,v_tt,'What is lim(x→0) of sin(x)/x?','single_choice','medium',1,'This is a standard limit: lim(x→0) sin(x)/x = 1.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','0',FALSE,1),(v_q,'B','1',TRUE,2),(v_q,'C','∞',FALSE,3),(v_q,'D','Does not exist',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Integrals' AND grade_id=g_12 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_12,v_tt,'What is ∫(3x² + 2x) dx?','single_choice','medium',1,'∫3x² dx = x³. ∫2x dx = x². Result: x³ + x² + C.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','6x + 2 + C',FALSE,1),(v_q,'B','x³ + x² + C',TRUE,2),(v_q,'C','3x³ + x² + C',FALSE,3),(v_q,'D','x² + 2 + C',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Applications of Calculus' AND grade_id=g_12 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_12,v_tt,'At what x-value does f(x) = x² − 6x + 8 have a minimum?','single_choice','medium',1,'f''(x) = 2x−6 = 0 → x = 3. f''''(x) = 2 > 0 confirms a minimum.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','x = 2',FALSE,1),(v_q,'B','x = 3',TRUE,2),(v_q,'C','x = 4',FALSE,3),(v_q,'D','x = 6',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Derivatives' AND grade_id=g_12 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_12,v_tt,'If f(x) = (2x + 3)⁴, what is f''(x)?','single_choice','hard',1,'Chain rule: f''(x) = 4(2x+3)³ × 2 = 8(2x+3)³.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','4(2x+3)³',FALSE,1),(v_q,'B','8(2x+3)³',TRUE,2),(v_q,'C','4(2x+3)⁴',FALSE,3),(v_q,'D','(2x+3)³',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Integrals' AND grade_id=g_12 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_12,v_tt,'Evaluate ∫₀² 3x² dx','single_choice','hard',1,'∫3x² dx = x³. Evaluate from 0 to 2: 2³ − 0³ = 8.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','4',FALSE,1),(v_q,'B','6',FALSE,2),(v_q,'C','8',TRUE,3),(v_q,'D','12',FALSE,4);

SELECT id INTO v_t FROM topics WHERE name='Applications of Calculus' AND grade_id=g_12 LIMIT 1;
INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
VALUES(uuid_generate_v4(),v_t,g_12,v_tt,'The position of a particle is s(t) = t³ − 3t² + 4. What is the velocity at t = 2?','single_choice','hard',1,'v(t) = s''(t) = 3t² − 6t. v(2) = 3(4) − 6(2) = 12 − 12 = 0.') RETURNING id INTO v_q;
INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES
(v_q,'A','0',TRUE,1),(v_q,'B','2',FALSE,2),(v_q,'C','4',FALSE,3),(v_q,'D','6',FALSE,4);

END;
$$;
