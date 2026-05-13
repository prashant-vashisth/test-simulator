-- =============================================================================
-- Kindergarten Mathematics — 15 topics, 15 questions each (225 total)
-- Indian context throughout; money section uses Indian currency (₹).
-- Run in Supabase SQL Editor. Safe to re-run (deletes & recreates).
-- =============================================================================

DO $$
DECLARE
  v_kg  UUID := '33333333-0000-0000-0000-000000000000'; -- Kindergarten
  v_sub UUID := '44444444-0001-0000-0000-000000000001'; -- NWEA Mathematics
  v_tt  UUID := '22222222-0000-0000-0000-000000000001'; -- NWEA MAP
  -- topic vars
  v_t1  UUID; v_t2  UUID; v_t3  UUID; v_t4  UUID; v_t5  UUID;
  v_t6  UUID; v_t7  UUID; v_t8  UUID; v_t9  UUID; v_t10 UUID;
  v_t11 UUID; v_t12 UUID; v_t13 UUID; v_t14 UUID; v_t15 UUID;
  q UUID; -- reused per question
BEGIN

  -- session_answers.question_id is ON DELETE RESTRICT, so clear those rows first
  DELETE FROM session_answers
  WHERE question_id IN (
    SELECT q.id FROM questions q
    JOIN topics t ON t.id = q.topic_id
    WHERE t.grade_id = v_kg AND t.subject_id = v_sub
  );

  -- Now safe to delete topics — questions and answer_options cascade automatically
  DELETE FROM topics WHERE grade_id = v_kg AND subject_id = v_sub;

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 1 · Counting 1 to 5
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Counting 1 to 5',v_sub,v_kg,'Count and identify numbers 1 through 5',1)
  RETURNING id INTO v_t1;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'Aarav has 3 pencils in his bag. How many pencils does he have?','single_choice','easy',1,'Count each pencil: one, two, three. There are 3 pencils.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',false,2),(q,'C','3',true,3),(q,'D','4',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'Diya sees 4 birds sitting on a fence. How many birds does she see?','single_choice','easy',1,'Count each bird: one, two, three, four. There are 4 birds.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','3',false,2),(q,'C','4',true,3),(q,'D','5',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'Meera put 5 blocks in a row. How many blocks are in her row?','single_choice','easy',1,'Count each block: one, two, three, four, five. There are 5 blocks.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','4',false,2),(q,'C','5',true,3),(q,'D','6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'Which number shows how many fingers are on one hand?','single_choice','easy',1,'We have 5 fingers on one hand: thumb, index, middle, ring, and little finger.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','4',false,2),(q,'C','5',true,3),(q,'D','6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'Priya has 2 apples. Her mother gives her 1 more. How many apples does she have now?','single_choice','easy',1,'2 apples and 1 more apple makes 3 apples.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',false,2),(q,'C','3',true,3),(q,'D','4',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'What number comes right after 3 when counting?','single_choice','medium',1,'When counting forward: 1, 2, 3, 4. The number after 3 is 4.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','3',false,2),(q,'C','4',true,3),(q,'D','5',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'Ishaan draws circles: O O O O. How many circles did he draw?','single_choice','medium',1,'Count each circle: one, two, three, four. There are 4 circles.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','4',true,2),(q,'C','5',false,3),(q,'D','6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'Priya counts her stickers: 1, 2, ___, 4, 5. What number is missing?','single_choice','medium',1,'The counting order is 1, 2, 3, 4, 5. The missing number is 3.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',false,2),(q,'C','3',true,3),(q,'D','6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'What number comes just before 5 when counting?','single_choice','medium',1,'Counting forward: 1, 2, 3, 4, 5. The number just before 5 is 4.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','4',true,2),(q,'C','5',false,3),(q,'D','6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'Naina has fewer apples than Kavya. Kavya has 4 apples. How many apples could Naina have?','single_choice','medium',1,'Fewer means a smaller number. Any number less than 4 works. 3 is less than 4.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','5',false,1),(q,'B','4',false,2),(q,'C','3',true,3),(q,'D','6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'Vivaan has 1 red ball, 1 blue ball, and 1 green ball. How many balls does he have altogether?','single_choice','medium',1,'1 + 1 + 1 = 3 balls.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',false,2),(q,'C','3',true,3),(q,'D','4',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'A triangle has 3 sides. A square has 4 sides. Which shape has MORE sides?','single_choice','medium',1,'4 is greater than 3, so the square has more sides.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Triangle',false,1),(q,'B','Square',true,2),(q,'C','Both have the same',false,3),(q,'D','Neither',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'Put these numbers in order from smallest to largest: 3, 1, 4, 2, 5. Which number comes THIRD?','single_choice','hard',1,'Ordered: 1, 2, 3, 4, 5. The third number is 3.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',false,2),(q,'C','3',true,3),(q,'D','4',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'Dev has 4 stickers. He wants 5 stickers. How many MORE stickers does he need?','single_choice','hard',1,'5 - 4 = 1. Dev needs 1 more sticker.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','0',false,1),(q,'B','1',true,2),(q,'C','2',false,3),(q,'D','3',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t1,v_kg,v_tt,'Ananya lines up 5 dolls. The third doll wears a red hat. How many dolls are in front of the doll with the red hat?','single_choice','hard',1,'The 3rd doll has positions 1 and 2 in front of it — that is 2 dolls.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',true,2),(q,'C','3',false,3),(q,'D','4',false,4);

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 2 · Counting 6 to 10
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Counting 6 to 10',v_sub,v_kg,'Count and identify numbers 6 through 10',2)
  RETURNING id INTO v_t2;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'Dev draws 7 stars on his paper. How many stars did he draw?','single_choice','easy',1,'Count each star: one, two, three, four, five, six, seven. There are 7 stars.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','5',false,1),(q,'B','6',false,2),(q,'C','7',true,3),(q,'D','8',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'A spider has 8 legs. How many legs does one spider have?','single_choice','easy',1,'A spider always has 8 legs.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','6',false,1),(q,'B','7',false,2),(q,'C','8',true,3),(q,'D','9',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'Riya counted 9 flowers in the garden. How many flowers did she count?','single_choice','easy',1,'Riya counted 9 flowers.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','7',false,1),(q,'B','8',false,2),(q,'C','9',true,3),(q,'D','10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'Our fingers and toes make a total of 20. How many fingers do we have on both hands together?','single_choice','easy',1,'We have 5 fingers on each hand. 5 + 5 = 10 fingers on both hands.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','8',false,1),(q,'B','9',false,2),(q,'C','10',true,3),(q,'D','20',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'Aditya has 6 crayons in his box. How many crayons does he have?','single_choice','easy',1,'Aditya has 6 crayons.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','5',false,1),(q,'B','6',true,2),(q,'C','7',false,3),(q,'D','8',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'What number comes right after 7 when counting?','single_choice','medium',1,'Counting: 6, 7, 8. The number after 7 is 8.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','6',false,1),(q,'B','7',false,2),(q,'C','8',true,3),(q,'D','9',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'Priya counts objects and reaches 9. What is the NEXT number she should say?','single_choice','medium',1,'Counting forward: 8, 9, 10. The next number after 9 is 10.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','8',false,1),(q,'B','9',false,2),(q,'C','10',true,3),(q,'D','11',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'Which number is between 6 and 8?','single_choice','medium',1,'Between 6 and 8 on the number line is 7.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','5',false,1),(q,'B','6',false,2),(q,'C','7',true,3),(q,'D','9',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'Aarav has 10 marbles. Rohan has 8 marbles. Who has MORE marbles?','single_choice','medium',1,'10 is greater than 8, so Aarav has more marbles.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Aarav',true,1),(q,'B','Rohan',false,2),(q,'C','They have the same',false,3),(q,'D','Cannot tell',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'What number comes just before 10 when counting?','single_choice','medium',1,'Counting: 8, 9, 10. The number before 10 is 9.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','8',false,1),(q,'B','9',true,2),(q,'C','10',false,3),(q,'D','11',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'Kavya counts: 6, 7, 8, ___, 10. What number is missing?','single_choice','medium',1,'The sequence is 6, 7, 8, 9, 10. The missing number is 9.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','7',false,1),(q,'B','8',false,2),(q,'C','9',true,3),(q,'D','11',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'Meera lined up 10 toys. She counted 7 of them. How many MORE does she still need to count?','single_choice','medium',1,'10 - 7 = 3. She needs to count 3 more toys.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','3',true,2),(q,'C','4',false,3),(q,'D','7',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'Ishaan lines up 10 toy cars. The 7th car is yellow. How many cars come AFTER the yellow car?','single_choice','hard',1,'After position 7 come positions 8, 9, and 10. That is 3 cars.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','3',true,2),(q,'C','4',false,3),(q,'D','7',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'Naina has more than 7 stickers but fewer than 10 stickers. Which number shows how many she might have?','single_choice','hard',1,'Greater than 7 and less than 10 means 8 or 9. Option 8 fits.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','7',false,1),(q,'B','8',true,2),(q,'C','10',false,3),(q,'D','11',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t2,v_kg,v_tt,'A number is 2 less than 10. What is that number?','single_choice','hard',1,'10 - 2 = 8. The number is 8.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','7',false,1),(q,'B','8',true,2),(q,'C','9',false,3),(q,'D','12',false,4);

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 3 · Ordering and Comparing Numbers to 10
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Ordering and Comparing Numbers to 10',v_sub,v_kg,'Compare and order numbers up to 10 using greater than, less than, and equal to',3)
  RETURNING id INTO v_t3;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'Which number is GREATER: 3 or 7?','single_choice','easy',1,'7 is further along the number line than 3, so 7 is greater.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','7',true,2),(q,'C','Both are equal',false,3),(q,'D','Cannot tell',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'Which number is LESS: 5 or 8?','single_choice','easy',1,'5 comes before 8 on the number line, so 5 is less.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','5',true,1),(q,'B','8',false,2),(q,'C','Both are equal',false,3),(q,'D','Cannot tell',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'Arjun has 6 stickers. Riya has 9 stickers. Who has MORE stickers?','single_choice','easy',1,'9 is greater than 6, so Riya has more stickers.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Arjun',false,1),(q,'B','Riya',true,2),(q,'C','They have the same',false,3),(q,'D','Cannot tell',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'What number comes BEFORE 8 when counting?','single_choice','easy',1,'Counting: 6, 7, 8. The number before 8 is 7.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','6',false,1),(q,'B','7',true,2),(q,'C','8',false,3),(q,'D','9',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'Which is the SMALLEST number: 2, 8, or 5?','single_choice','easy',1,'2 comes first on the number line, so 2 is the smallest.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',true,1),(q,'B','5',false,2),(q,'C','8',false,3),(q,'D','They are all the same',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'Priya has 7 books. Dev has 7 books. Who has MORE books?','single_choice','medium',1,'7 equals 7. They have the same number of books.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Priya',false,1),(q,'B','Dev',false,2),(q,'C','They have the same number',true,3),(q,'D','Cannot tell',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'Look at these numbers: 3, 8, 5, 1, 6. Which number is the GREATEST?','single_choice','medium',1,'Compare all numbers. 8 is the largest of 3, 8, 5, 1, and 6.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','6',false,2),(q,'C','8',true,3),(q,'D','5',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'Which statement is TRUE?','single_choice','medium',1,'7 < 9 means 7 is less than 9, which is correct.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','9 > 10',false,1),(q,'B','5 = 6',false,2),(q,'C','7 < 9',true,3),(q,'D','3 > 4',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'Rohan''s number is greater than 5 but less than 8. Which number could be Rohan''s?','single_choice','medium',1,'Greater than 5 and less than 8: the options are 6 or 7. Here, 6 fits.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',false,1),(q,'B','5',false,2),(q,'C','6',true,3),(q,'D','9',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'A caterpillar is 5th in line. How many caterpillars are in FRONT of it?','single_choice','medium',1,'5th means there are 4 caterpillars before it: 1st, 2nd, 3rd, 4th.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','4',true,2),(q,'C','5',false,3),(q,'D','6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'Which number is between 4 and 7 on the number line?','single_choice','medium',1,'Between 4 and 7 are: 5 and 6. Option 5 fits.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','5',true,2),(q,'C','7',false,3),(q,'D','8',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'Put these numbers in order from LEAST to GREATEST: 7, 2, 9, 4. Which number comes SECOND?','single_choice','medium',1,'Ordered: 2, 4, 7, 9. The second number is 4.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','4',true,2),(q,'C','7',false,3),(q,'D','9',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'Naina is 4th in line. Vivaan is 7th in line. How many children are BETWEEN them?','single_choice','hard',1,'Between 4th and 7th are positions 5 and 6. That is 2 children.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',true,2),(q,'C','3',false,3),(q,'D','4',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'A number is 3 more than 6. What is that number?','single_choice','hard',1,'6 + 3 = 9. The number is 9.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','8',false,2),(q,'C','9',true,3),(q,'D','10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t3,v_kg,v_tt,'If you arrange 10, 1, 7, 4, 9 from greatest to least, which number is THIRD?','single_choice','hard',1,'Greatest to least: 10, 9, 7, 4, 1. The third number is 7.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',false,1),(q,'B','9',false,2),(q,'C','7',true,3),(q,'D','10',false,4);

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 4 · Numbers to 20 — Teen Numbers
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Numbers to 20',v_sub,v_kg,'Identify, count, and understand teen numbers 11 through 20',4)
  RETURNING id INTO v_t4;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'Which number is ELEVEN?','single_choice','easy',1,'Eleven is written as 11.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','10',false,1),(q,'B','11',true,2),(q,'C','12',false,3),(q,'D','20',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'How do you write THIRTEEN?','single_choice','easy',1,'Thirteen is written as 13.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','30',false,1),(q,'B','12',false,2),(q,'C','13',true,3),(q,'D','31',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'Which number comes right after 15?','single_choice','easy',1,'Counting: 14, 15, 16. The number after 15 is 16.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','14',false,1),(q,'B','15',false,2),(q,'C','16',true,3),(q,'D','17',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'Priya counted 18 buttons. How many ones are in the number 18?','single_choice','easy',1,'18 = 1 ten + 8 ones. There are 8 ones.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','8',true,2),(q,'C','10',false,3),(q,'D','18',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'The number 14 has 1 ten and how many ones?','single_choice','easy',1,'14 = 1 ten + 4 ones. There are 4 ones.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','4',true,2),(q,'C','10',false,3),(q,'D','14',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'The number 17 has 1 ten and some ones. How many ones does 17 have?','single_choice','medium',1,'17 = 1 ten + 7 ones. There are 7 ones.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','7',true,2),(q,'C','10',false,3),(q,'D','17',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'Count forward from 12. What are the NEXT three numbers?','single_choice','medium',1,'After 12 come 13, 14, 15.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','13, 14, 15',true,1),(q,'B','11, 10, 9',false,2),(q,'C','12, 12, 12',false,3),(q,'D','14, 16, 18',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'Aarav has a ten-frame that is full (10) and 3 more counters beside it. What number does this show?','single_choice','medium',1,'10 counters + 3 counters = 13.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','10',false,2),(q,'C','13',true,3),(q,'D','31',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'Which number is between 17 and 19?','single_choice','medium',1,'Between 17 and 19 on the number line is 18.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','16',false,1),(q,'B','17',false,2),(q,'C','18',true,3),(q,'D','20',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'Rohan says the number that has 1 ten and 6 ones. What number is he saying?','single_choice','medium',1,'1 ten + 6 ones = 16.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','6',false,1),(q,'B','10',false,2),(q,'C','16',true,3),(q,'D','61',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'Diya counts backward from 20. Which number comes right AFTER 20 when counting backward?','single_choice','medium',1,'Counting backward from 20: 20, 19, 18... The first number after 20 going backward is 19.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','21',false,1),(q,'B','20',false,2),(q,'C','19',true,3),(q,'D','18',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'How many numbers are BETWEEN 10 and 20 (not counting 10 or 20 themselves)?','single_choice','medium',1,'The numbers between 10 and 20 are: 11,12,13,14,15,16,17,18,19. That is 9 numbers.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','8',false,1),(q,'B','9',true,2),(q,'C','10',false,3),(q,'D','20',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'Kavya has a full ten-frame (10) and 8 more counters. How many counters does she have in all?','single_choice','hard',1,'10 + 8 = 18 counters.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','8',false,1),(q,'B','10',false,2),(q,'C','18',true,3),(q,'D','20',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'If you count backward from 20 by ones, what is the 5th number you say?','single_choice','hard',1,'20, 19, 18, 17, 16. The 5th number is 16.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','14',false,1),(q,'B','15',false,2),(q,'C','16',true,3),(q,'D','20',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t4,v_kg,v_tt,'Meera''s number has 1 ten and some ones. It comes just before 15. What is Meera''s number?','single_choice','hard',1,'The number just before 15 is 14. 14 = 1 ten + 4 ones.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','12',false,1),(q,'B','13',false,2),(q,'C','14',true,3),(q,'D','16',false,4);

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 5 · Skip Counting and Numbers to 100
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Skip Counting and Numbers to 100',v_sub,v_kg,'Count by tens, explore the hundred chart, and understand groups of ten',5)
  RETURNING id INTO v_t5;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'Count by 10s: 10, 20, ___. What comes next?','single_choice','easy',1,'Each number goes up by 10. After 20 comes 30.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','21',false,1),(q,'B','25',false,2),(q,'C','30',true,3),(q,'D','40',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'How many TENS are in 50?','single_choice','easy',1,'50 = 5 tens. Count by tens: 10, 20, 30, 40, 50 — that is 5 tens.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','3',false,2),(q,'C','5',true,3),(q,'D','50',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'Count by 10s: 10, 20, 30, 40, ___. What comes next?','single_choice','easy',1,'Each number increases by 10. After 40 comes 50.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','41',false,1),(q,'B','45',false,2),(q,'C','50',true,3),(q,'D','60',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'Which number comes after 39 on the number chart?','single_choice','easy',1,'After 39 comes 40.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','30',false,1),(q,'B','38',false,2),(q,'C','40',true,3),(q,'D','49',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'How many tens are in 100?','single_choice','easy',1,'100 = 10 tens. Count: 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 — that is 10 tens.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','5',false,2),(q,'C','10',true,3),(q,'D','100',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'Arjun skip-counts by 10 starting at 10. What is the 4th number he says?','single_choice','medium',1,'10, 20, 30, 40. The 4th number is 40.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','30',false,1),(q,'B','40',true,2),(q,'C','50',false,3),(q,'D','14',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'What number is missing? 10, 20, ___, 40, 50','single_choice','medium',1,'The pattern goes up by 10 each time. Between 20 and 40 is 30.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','25',false,1),(q,'B','30',true,2),(q,'C','35',false,3),(q,'D','45',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'Priya has 3 groups of 10 stickers. How many stickers does she have in all?','single_choice','medium',1,'3 groups of 10 = 10 + 10 + 10 = 30 stickers.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','13',false,2),(q,'C','30',true,3),(q,'D','103',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'Which number comes just before 70 on the number chart?','single_choice','medium',1,'Before 70 on the chart is 69.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','60',false,1),(q,'B','68',false,2),(q,'C','69',true,3),(q,'D','71',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'Dev counts groups of 10 pencils. He has 6 groups. How many pencils does he have?','single_choice','medium',1,'6 groups of 10 = 10 + 10 + 10 + 10 + 10 + 10 = 60 pencils.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','16',false,1),(q,'B','56',false,2),(q,'C','60',true,3),(q,'D','106',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'Count by 10s. What is the 7th number when you start at 10?','single_choice','medium',1,'10, 20, 30, 40, 50, 60, 70. The 7th number is 70.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','60',false,1),(q,'B','70',true,2),(q,'C','80',false,3),(q,'D','7',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'Which number is between 50 and 60 on the number chart?','single_choice','medium',1,'55 is between 50 and 60.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','49',false,1),(q,'B','55',true,2),(q,'C','60',false,3),(q,'D','65',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'Meera has 80 beads. She puts them into groups of 10. How many groups does she make?','single_choice','hard',1,'80 divided into groups of 10: 10+10+10+10+10+10+10+10 = 80. That is 8 groups.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','7',false,1),(q,'B','8',true,2),(q,'C','9',false,3),(q,'D','80',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'Aarav starts at 0 and counts by tens. He counts 9 times. What number does he reach?','single_choice','hard',1,'0, 10, 20, 30, 40, 50, 60, 70, 80, 90. After 9 counts he reaches 90.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','80',false,1),(q,'B','90',true,2),(q,'C','100',false,3),(q,'D','9',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t5,v_kg,v_tt,'Vivaan has 5 groups of 10 beads and 5 extra beads. How many beads does he have?','single_choice','hard',1,'5 groups of 10 = 50. Plus 5 more = 55 beads.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','10',false,1),(q,'B','15',false,2),(q,'C','50',false,3),(q,'D','55',true,4);

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 6 · Addition to 5
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Addition to 5',v_sub,v_kg,'Add two numbers with sums up to 5; write and solve addition sentences',6)
  RETURNING id INTO v_t6;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'What is 1 + 1?','single_choice','easy',1,'1 and 1 more makes 2.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','0',false,1),(q,'B','1',false,2),(q,'C','2',true,3),(q,'D','3',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'What is 2 + 3?','single_choice','easy',1,'2 and 3 more makes 5.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',false,1),(q,'B','5',true,2),(q,'C','6',false,3),(q,'D','23',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'Priya has 2 apples. She gets 1 more apple. How many apples does she have now?','single_choice','easy',1,'2 apples + 1 apple = 3 apples.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',false,2),(q,'C','3',true,3),(q,'D','4',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'What is 0 + 4?','single_choice','easy',1,'Adding 0 to any number does not change it. 0 + 4 = 4.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','0',false,1),(q,'B','3',false,2),(q,'C','4',true,3),(q,'D','5',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'What is 3 + 2?','single_choice','easy',1,'3 and 2 more makes 5.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','4',false,2),(q,'C','5',true,3),(q,'D','6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'Aarav has 1 orange and 4 mangoes. How many fruits does he have altogether?','single_choice','medium',1,'1 + 4 = 5 fruits altogether.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','4',false,2),(q,'C','5',true,3),(q,'D','6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'What number makes this true? ___ + 2 = 5','single_choice','medium',1,'3 + 2 = 5. The missing number is 3.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',false,2),(q,'C','3',true,3),(q,'D','7',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'Rohan drew 2 circles and then 2 more circles. How many circles did he draw in all?','single_choice','medium',1,'2 + 2 = 4 circles.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','3',false,2),(q,'C','4',true,3),(q,'D','5',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'Which addition sentence equals 4?','single_choice','medium',1,'1 + 3 = 4. The answer is 4.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1 + 1',false,1),(q,'B','1 + 3',true,2),(q,'C','2 + 3',false,3),(q,'D','3 + 3',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'Kavya put 3 blocks in a box. Then she put 0 more blocks in the box. How many blocks are in the box?','single_choice','medium',1,'Adding 0 changes nothing. 3 + 0 = 3.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','0',false,1),(q,'B','3',true,2),(q,'C','4',false,3),(q,'D','5',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'Diya has 2 red balloons and 2 blue balloons. How many balloons does she have in all?','single_choice','medium',1,'2 + 2 = 4 balloons.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','3',false,2),(q,'C','4',true,3),(q,'D','5',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'What is 4 + 1?','single_choice','medium',1,'4 and 1 more makes 5.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','4',false,2),(q,'C','5',true,3),(q,'D','6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'Naina had some pencils. She got 2 more and now has 5. How many did she start with?','single_choice','hard',1,'? + 2 = 5. So ? = 5 - 2 = 3. She started with 3.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',false,2),(q,'C','3',true,3),(q,'D','7',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'Which two numbers add up to exactly 5?','single_choice','hard',1,'2 + 3 = 5. The other options do not equal 5.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4 + 4',false,1),(q,'B','3 + 3',false,2),(q,'C','2 + 3',true,3),(q,'D','1 + 2',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t6,v_kg,v_tt,'Arjun has 1 ladoo. His sister gives him some more ladoos. Now Arjun has 5 ladoos. How many ladoos did his sister give him?','single_choice','hard',1,'1 + ? = 5. So ? = 5 - 1 = 4. His sister gave him 4 ladoos.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',false,2),(q,'C','3',false,3),(q,'D','4',true,4);

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 7 · Addition to 10
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Addition to 10',v_sub,v_kg,'Add two numbers with sums up to 10; make 10; solve addition word problems',7)
  RETURNING id INTO v_t7;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'What is 5 + 3?','single_choice','easy',1,'5 and 3 more makes 8.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','7',false,1),(q,'B','8',true,2),(q,'C','9',false,3),(q,'D','53',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'What is 4 + 6?','single_choice','easy',1,'4 and 6 make exactly 10.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','8',false,1),(q,'B','9',false,2),(q,'C','10',true,3),(q,'D','46',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'What is 7 + 1?','single_choice','easy',1,'7 and 1 more makes 8.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','6',false,1),(q,'B','7',false,2),(q,'C','8',true,3),(q,'D','9',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'Priya has 5 red flowers and 4 yellow flowers. How many flowers does she have in all?','single_choice','easy',1,'5 + 4 = 9 flowers.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','5',false,1),(q,'B','8',false,2),(q,'C','9',true,3),(q,'D','10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'What is 6 + 0?','single_choice','easy',1,'Adding 0 to any number does not change it. 6 + 0 = 6.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','0',false,1),(q,'B','5',false,2),(q,'C','6',true,3),(q,'D','7',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'Rohan scored 3 points in round one and 7 points in round two. How many points did he score altogether?','single_choice','medium',1,'3 + 7 = 10 points.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',false,1),(q,'B','7',false,2),(q,'C','10',true,3),(q,'D','37',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'What number completes this? ___ + 5 = 10','single_choice','medium',1,'5 + 5 = 10. The missing number is 5.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',false,1),(q,'B','5',true,2),(q,'C','6',false,3),(q,'D','15',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'Meera has 6 biscuits. Her mother gives her 3 more. How many biscuits does Meera have now?','single_choice','medium',1,'6 + 3 = 9 biscuits.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','6',false,2),(q,'C','9',true,3),(q,'D','10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'Which addition sentence has a sum of 8?','single_choice','medium',1,'4 + 4 = 8. The other options do not equal 8.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3 + 3',false,1),(q,'B','4 + 4',true,2),(q,'C','5 + 4',false,3),(q,'D','6 + 4',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'Kavya put 4 marbles in a bag and then added 4 more. How many marbles are in the bag?','single_choice','medium',1,'4 + 4 = 8 marbles.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',false,1),(q,'B','6',false,2),(q,'C','8',true,3),(q,'D','10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'Aarav drew 7 stars on Monday and 2 stars on Tuesday. How many stars did he draw altogether?','single_choice','medium',1,'7 + 2 = 9 stars.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','5',false,1),(q,'B','7',false,2),(q,'C','9',true,3),(q,'D','10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'What is 9 + 1?','single_choice','medium',1,'9 and 1 more makes 10.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','8',false,1),(q,'B','9',false,2),(q,'C','10',true,3),(q,'D','11',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'Dev has some oranges. His father gives him 4 more and now Dev has 10 oranges. How many did Dev start with?','single_choice','hard',1,'? + 4 = 10. So ? = 10 - 4 = 6. Dev started with 6.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',false,1),(q,'B','6',true,2),(q,'C','7',false,3),(q,'D','14',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'Diya adds two different numbers to get 10. Both numbers must be greater than 3. Which two numbers work?','single_choice','hard',1,'4 + 6 = 10, and both 4 and 6 are greater than 3.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2 + 8',false,1),(q,'B','3 + 7',false,2),(q,'C','4 + 6',true,3),(q,'D','5 + 6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t7,v_kg,v_tt,'Naina buys 8 stickers on Monday. On Tuesday she buys some more. Now she has 10 stickers. How many did she buy on Tuesday?','single_choice','hard',1,'8 + ? = 10. So ? = 10 - 8 = 2. She bought 2 stickers on Tuesday.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',true,2),(q,'C','3',false,3),(q,'D','8',false,4);

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 8 · Subtraction to 5
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Subtraction to 5',v_sub,v_kg,'Take away and find differences for numbers up to 5; subtraction word problems',8)
  RETURNING id INTO v_t8;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'What is 5 - 2?','single_choice','easy',1,'Start with 5 and take away 2: 5, 4, 3. The answer is 3.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','3',true,2),(q,'C','4',false,3),(q,'D','7',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'What is 4 - 1?','single_choice','easy',1,'Start with 4 and take away 1: the answer is 3.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','3',true,2),(q,'C','4',false,3),(q,'D','5',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'Priya has 3 mangoes. She eats 1. How many mangoes does she have left?','single_choice','easy',1,'3 - 1 = 2 mangoes left.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',true,2),(q,'C','3',false,3),(q,'D','4',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'What is 5 - 0?','single_choice','easy',1,'Taking away 0 changes nothing. 5 - 0 = 5.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','0',false,1),(q,'B','4',false,2),(q,'C','5',true,3),(q,'D','10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'What is 3 - 3?','single_choice','easy',1,'When you take away all of a group, nothing is left. 3 - 3 = 0.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','0',true,1),(q,'B','1',false,2),(q,'C','3',false,3),(q,'D','6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'Arjun has 5 crayons. He gives 2 to his friend. How many crayons does Arjun have now?','single_choice','medium',1,'5 - 2 = 3 crayons left.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','3',true,2),(q,'C','4',false,3),(q,'D','7',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'What number makes this true? 5 - ___ = 2','single_choice','medium',1,'5 - 3 = 2. The missing number is 3.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',false,2),(q,'C','3',true,3),(q,'D','7',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'Kavya had 4 stickers. She lost some and now has 2. How many stickers did she lose?','single_choice','medium',1,'4 - ? = 2. So ? = 4 - 2 = 2. She lost 2 stickers.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',true,2),(q,'C','4',false,3),(q,'D','6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'Which number sentence shows taking 3 away from 5?','single_choice','medium',1,'Subtraction means taking away. Taking 3 from 5 is written 5 - 3.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3 - 5',false,1),(q,'B','5 + 3',false,2),(q,'C','5 - 3',true,3),(q,'D','3 + 5',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'Rohan has 5 biscuits. He gives 1 to his sister and 1 to his brother. How many biscuits does he have left?','single_choice','medium',1,'5 - 1 - 1 = 3 biscuits left.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',false,2),(q,'C','3',true,3),(q,'D','5',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'What is 4 - 0?','single_choice','medium',1,'Taking away 0 changes nothing. 4 - 0 = 4.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','0',false,1),(q,'B','1',false,2),(q,'C','4',true,3),(q,'D','8',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'Aarav had 5 books. He returned some to the library. Now he has 4 books. How many books did he return?','single_choice','medium',1,'5 - ? = 4. So ? = 5 - 4 = 1. He returned 1 book.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',true,1),(q,'B','4',false,2),(q,'C','5',false,3),(q,'D','9',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'Meera had some flowers. She gave away 3. Now she has 2 flowers. How many did she start with?','single_choice','hard',1,'? - 3 = 2. So ? = 2 + 3 = 5. She started with 5 flowers.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','3',false,2),(q,'C','5',true,3),(q,'D','6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'What is 5 - 2 - 1?','single_choice','hard',1,'Work left to right: 5 - 2 = 3, then 3 - 1 = 2.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',true,2),(q,'C','3',false,3),(q,'D','4',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t8,v_kg,v_tt,'Diya had 5 apples. She shared them equally between 2 friends and kept 1 for herself. How many apples did each friend get?','single_choice','hard',1,'5 - 1 (kept) = 4 given away. Shared equally between 2 friends: 4 / 2 = 2 each.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',true,2),(q,'C','3',false,3),(q,'D','5',false,4);

END;
$$;

-- =============================================================================
-- PART 2 — Topics 9–15
-- =============================================================================
DO $$
DECLARE
  v_kg  UUID := '33333333-0000-0000-0000-000000000000';
  v_sub UUID := '44444444-0001-0000-0000-000000000001';
  v_tt  UUID := '22222222-0000-0000-0000-000000000001';
  v_t9  UUID; v_t10 UUID; v_t11 UUID; v_t12 UUID;
  v_t13 UUID; v_t14 UUID; v_t15 UUID;
  q UUID;
BEGIN

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 9 · Subtraction to 10
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Subtraction to 10',v_sub,v_kg,'Take away and find differences for numbers up to 10; subtraction word problems',9)
  RETURNING id INTO v_t9;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'What is 10 - 3?','single_choice','easy',1,'Start at 10 and count back 3: 9, 8, 7. The answer is 7.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','6',false,1),(q,'B','7',true,2),(q,'C','8',false,3),(q,'D','13',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'What is 8 - 4?','single_choice','easy',1,'8 take away 4 equals 4.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',true,1),(q,'B','5',false,2),(q,'C','6',false,3),(q,'D','12',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'What is 9 - 2?','single_choice','easy',1,'9 take away 2 equals 7.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','6',false,1),(q,'B','7',true,2),(q,'C','9',false,3),(q,'D','11',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'Priya has 10 flowers. She gives away 5. How many flowers does she have left?','single_choice','easy',1,'10 - 5 = 5 flowers left.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',false,1),(q,'B','5',true,2),(q,'C','6',false,3),(q,'D','15',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'What is 7 - 7?','single_choice','easy',1,'When you take away all of a group, nothing remains. 7 - 7 = 0.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','0',true,1),(q,'B','1',false,2),(q,'C','7',false,3),(q,'D','14',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'Rohan caught 8 fish. He threw 3 back in the water. How many fish does he have now?','single_choice','medium',1,'8 - 3 = 5 fish.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','5',true,2),(q,'C','8',false,3),(q,'D','11',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'What number makes this true? 10 - ___ = 6','single_choice','medium',1,'10 - 4 = 6. The missing number is 4.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','4',true,2),(q,'C','6',false,3),(q,'D','16',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'Kavya counted 9 birds on a branch. Then 4 birds flew away. How many birds are left?','single_choice','medium',1,'9 - 4 = 5 birds.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',false,1),(q,'B','5',true,2),(q,'C','9',false,3),(q,'D','13',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'Which addition sentence is related to 7 - 3 = 4?','single_choice','medium',1,'4 + 3 = 7 is the related addition fact. If 7 - 3 = 4, then 4 + 3 = 7.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4 + 3 = 7',true,1),(q,'B','7 + 3 = 10',false,2),(q,'C','3 - 7 = 4',false,3),(q,'D','4 - 3 = 1',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'Aarav has 10 marbles. He gives some to his friend. Now he has 6. How many did he give away?','single_choice','medium',1,'10 - ? = 6. So ? = 10 - 6 = 4. He gave away 4 marbles.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',true,1),(q,'B','6',false,2),(q,'C','10',false,3),(q,'D','16',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'What is 10 - 1?','single_choice','medium',1,'10 take away 1 equals 9.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','8',false,1),(q,'B','9',true,2),(q,'C','10',false,3),(q,'D','11',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'Dev scored 9 runs. His team needs 10 runs to win. How many more runs does his team need?','single_choice','medium',1,'10 - 9 = 1. They need 1 more run.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','0',false,1),(q,'B','1',true,2),(q,'C','9',false,3),(q,'D','10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'Naina baked 10 ladoos. She gave 3 to her neighbour and 3 to her grandmother. How many ladoos does she have left?','single_choice','hard',1,'3 + 3 = 6 given away. 10 - 6 = 4 ladoos left.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','4',true,2),(q,'C','6',false,3),(q,'D','7',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'A number subtracted from 10 gives the same answer as 6 - 3. What is that number?','single_choice','hard',1,'6 - 3 = 3. We need 10 - ? = 3, so ? = 7.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','7',true,2),(q,'C','6',false,3),(q,'D','10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t9,v_kg,v_tt,'Ishaan has 8 stickers. Meera has 3 fewer stickers than Ishaan. How many stickers does Meera have?','single_choice','hard',1,'Fewer means subtract. 8 - 3 = 5. Meera has 5 stickers.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','5',true,2),(q,'C','8',false,3),(q,'D','11',false,4);

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 10 · Mixed Operations
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Mixed Operations',v_sub,v_kg,'Choose between adding and subtracting; explore fact families and related facts',10)
  RETURNING id INTO v_t10;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'What is 3 + 4?','single_choice','easy',1,'3 and 4 more makes 7.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','6',false,1),(q,'B','7',true,2),(q,'C','8',false,3),(q,'D','34',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'What is 8 - 5?','single_choice','easy',1,'8 take away 5 equals 3.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','3',true,2),(q,'C','4',false,3),(q,'D','13',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'Priya had 6 balloons. One popped. How many balloons does she have?','single_choice','easy',1,'6 - 1 = 5 balloons.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','5',true,1),(q,'B','6',false,2),(q,'C','7',false,3),(q,'D','8',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'What is 0 + 9?','single_choice','easy',1,'Adding 0 changes nothing. 0 + 9 = 9.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','0',false,1),(q,'B','8',false,2),(q,'C','9',true,3),(q,'D','90',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'What is 10 - 10?','single_choice','easy',1,'Taking all away from a group leaves nothing. 10 - 10 = 0.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','0',true,1),(q,'B','1',false,2),(q,'C','10',false,3),(q,'D','20',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'Arjun has 4 pencils. He finds 3 more, then loses 2. How many pencils does he have now?','single_choice','medium',1,'4 + 3 = 7, then 7 - 2 = 5 pencils.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',false,1),(q,'B','5',true,2),(q,'C','7',false,3),(q,'D','9',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'Which number sentence is CORRECT?','single_choice','medium',1,'9 - 4 = 5. Check each: 5+3=8 not 7; 9-4=5 correct; 6+2=8 not 9; 7-3=4 not 3.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','5 + 3 = 7',false,1),(q,'B','9 - 4 = 5',true,2),(q,'C','6 + 2 = 9',false,3),(q,'D','7 - 3 = 3',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'What is 3 + 4 - 2?','single_choice','medium',1,'Work left to right: 3 + 4 = 7, then 7 - 2 = 5.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','4',false,2),(q,'C','5',true,3),(q,'D','9',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'Kavya has 7 books. She gives 2 to her sister and gets 1 from her brother. How many books does Kavya have now?','single_choice','medium',1,'7 - 2 = 5, then 5 + 1 = 6 books.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','5',false,1),(q,'B','6',true,2),(q,'C','7',false,3),(q,'D','9',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'Which pair of numbers has both a SUM of 9 and a DIFFERENCE of 1?','single_choice','medium',1,'4 + 5 = 9 and 5 - 4 = 1. Both conditions are met.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4 and 5',true,1),(q,'B','3 and 6',false,2),(q,'C','2 and 7',false,3),(q,'D','1 and 8',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'Meera solved 6 maths problems. She got 4 correct. How many did she get wrong?','single_choice','medium',1,'6 - 4 = 2 problems wrong.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',true,1),(q,'B','4',false,2),(q,'C','6',false,3),(q,'D','10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'Priya has 3 red beads and 4 blue beads. She gives away all her blue beads. Then her mother gives her 5 more beads. How many beads does Priya have now?','single_choice','medium',1,'She starts with 3 red + 4 blue = 7. Gives away 4 blue: 3 left. Gets 5 more: 3 + 5 = 8.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',false,1),(q,'B','7',false,2),(q,'C','8',true,3),(q,'D','12',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'Dev has 5 stickers. He gives 1 to Aarav and then gets 3 from Naina. How many stickers does Dev have now?','single_choice','hard',1,'5 - 1 = 4, then 4 + 3 = 7 stickers.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','5',false,2),(q,'C','7',true,3),(q,'D','9',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'2 + 8 = 10. Which related subtraction fact is CORRECT?','single_choice','hard',1,'If 2 + 8 = 10, then 10 - 2 = 8 and 10 - 8 = 2 are the related subtraction facts. Option 10 - 2 = 8 is listed.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','10 - 8 = 8',false,1),(q,'B','2 - 10 = 8',false,2),(q,'C','10 - 2 = 8',true,3),(q,'D','8 + 2 = 6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t10,v_kg,v_tt,'Rohan has some marbles. He gets 3 more and now has 10. Then he loses 4. How many marbles does he have at the end?','single_choice','hard',1,'He had 10 - 3 = 7 to start. Then 10 - 4 = 6 at the end.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3',false,1),(q,'B','6',true,2),(q,'C','7',false,3),(q,'D','10',false,4);

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 11 · Patterns
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Patterns',v_sub,v_kg,'Identify, extend, and create repeating and growing patterns',11)
  RETURNING id INTO v_t11;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'What comes next? Red, Blue, Red, Blue, ___','single_choice','easy',1,'The pattern alternates Red, Blue. After Blue comes Red.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Red',true,1),(q,'B','Blue',false,2),(q,'C','Green',false,3),(q,'D','Yellow',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'What comes next? Circle, Square, Circle, Square, ___','single_choice','easy',1,'The pattern alternates Circle, Square. After Square comes Circle.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Triangle',false,1),(q,'B','Circle',true,2),(q,'C','Square',false,3),(q,'D','Hexagon',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'What comes next? 1, 2, 3, 1, 2, 3, ___','single_choice','easy',1,'The pattern 1, 2, 3 repeats. After 3 comes 1 again.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',true,1),(q,'B','2',false,2),(q,'C','3',false,3),(q,'D','4',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'Priya makes a pattern: Tall, Short, Tall, Short. What comes NEXT in her pattern?','single_choice','easy',1,'The pattern alternates Tall, Short. After Short comes Tall.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Tall',true,1),(q,'B','Short',false,2),(q,'C','Medium',false,3),(q,'D','Nothing',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'A pattern goes: Star, Star, Heart, Star, Star, ___. What comes next?','single_choice','easy',1,'The repeating unit is (Star, Star, Heart). After Star, Star comes Heart.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Star',false,1),(q,'B','Heart',true,2),(q,'C','Moon',false,3),(q,'D','Star Star',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'Kavya makes a pattern: Red, Blue, Green, Red, Blue, Green. How often does the pattern repeat?','single_choice','medium',1,'The repeating unit is (Red, Blue, Green) — 3 colours. The pattern repeats every 3 beads.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Every 1 bead',false,1),(q,'B','Every 2 beads',false,2),(q,'C','Every 3 beads',true,3),(q,'D','Every 6 beads',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'Aarav draws: Square, Square, Triangle, Triangle, Square, Square, Triangle, Triangle. What are the NEXT TWO shapes?','single_choice','medium',1,'The repeating unit is (Square, Square, Triangle, Triangle). After Triangle, Triangle comes Square, Square.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Square, Square',true,1),(q,'B','Triangle, Square',false,2),(q,'C','Triangle, Triangle',false,3),(q,'D','Square, Triangle',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'A number pattern is: 2, 4, 6, 8, ___. What comes next?','single_choice','medium',1,'Each number increases by 2. After 8 comes 10.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','9',false,1),(q,'B','10',true,2),(q,'C','12',false,3),(q,'D','18',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'Which is an AB repeating pattern?','single_choice','medium',1,'An AB pattern alternates two items. Red, Blue, Red, Blue, Red, Blue does exactly that.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Red, Red, Blue, Red, Red, Blue',false,1),(q,'B','Red, Blue, Red, Blue, Red, Blue',true,2),(q,'C','Red, Blue, Blue, Red, Blue, Blue',false,3),(q,'D','Red, Blue, Green, Red, Blue, Green',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'Rohan has a growing pattern: 1, 2, 3, 4, ___. What comes next?','single_choice','medium',1,'Each number increases by 1. After 4 comes 5.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',false,1),(q,'B','5',true,2),(q,'C','6',false,3),(q,'D','1',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'Meera makes a growing pattern: 1 block, 2 blocks, 3 blocks, 4 blocks, adding 1 each time. How many blocks will be in the 6th group?','single_choice','medium',1,'The pattern goes 1, 2, 3, 4, 5, 6. The 6th group has 6 blocks.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','5',false,1),(q,'B','6',true,2),(q,'C','7',false,3),(q,'D','10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'Which is NOT a repeating pattern?','single_choice','medium',1,'1, 2, 3, 4, 5, 6 is a growing pattern — it does not repeat. The others are all repeating.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1, 2, 1, 2, 1, 2',false,1),(q,'B','A, B, A, B, A, B',false,2),(q,'C','1, 2, 3, 4, 5, 6',true,3),(q,'D','Red, Blue, Red, Blue',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'What is wrong with this pattern? Red, Blue, Green, Red, Blue, Yellow, Red, Blue, Green','single_choice','hard',1,'The repeating unit is (Red, Blue, Green). Yellow breaks the pattern — it should be Green.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Yellow should be Green',true,1),(q,'B','The last Green should be Yellow',false,2),(q,'C','The first Red should be Yellow',false,3),(q,'D','There is no error',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'A growing pattern starts: 2, 4, 6, 8 — each number is 2 more than the one before. What is the 6th number?','single_choice','hard',1,'2, 4, 6, 8, 10, 12. The 6th number is 12.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','10',false,1),(q,'B','12',true,2),(q,'C','14',false,3),(q,'D','20',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t11,v_kg,v_tt,'Diya makes: Circle, Square, Triangle, Circle, Square, Triangle. If the pattern continues, what is the 10th shape?','single_choice','hard',1,'The repeating unit has 3 shapes. 10 / 3 = 3 remainder 1. So the 10th shape is the 1st in the unit: Circle.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Circle',true,1),(q,'B','Square',false,2),(q,'C','Triangle',false,3),(q,'D','Hexagon',false,4);

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 12 · Shapes and Their Properties
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Shapes and Their Properties',v_sub,v_kg,'Identify and describe 2D and 3D shapes; count sides and corners',12)
  RETURNING id INTO v_t12;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'How many sides does a triangle have?','single_choice','easy',1,'A triangle always has exactly 3 sides.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','3',true,2),(q,'C','4',false,3),(q,'D','5',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'How many corners does a square have?','single_choice','easy',1,'A square has 4 corners (also called vertices).') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','3',false,2),(q,'C','4',true,3),(q,'D','5',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'Which shape is perfectly round with NO corners?','single_choice','easy',1,'A circle is a perfectly round shape with no straight sides or corners.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Square',false,1),(q,'B','Triangle',false,2),(q,'C','Rectangle',false,3),(q,'D','Circle',true,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'A box looks like which 3D shape?','single_choice','easy',1,'A box has 6 flat rectangular faces — it is a cuboid (or rectangular prism). A cube is a special box with all equal square faces.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Sphere',false,1),(q,'B','Cone',false,2),(q,'C','Cube',true,3),(q,'D','Cylinder',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'A ball is shaped like which 3D shape?','single_choice','easy',1,'A ball is round in all directions — it is a sphere.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Cube',false,1),(q,'B','Sphere',true,2),(q,'C','Cylinder',false,3),(q,'D','Cone',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'Priya''s shape has 4 equal sides and 4 corners. What shape is it?','single_choice','medium',1,'A square has 4 equal sides and 4 corners.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Rectangle',false,1),(q,'B','Triangle',false,2),(q,'C','Square',true,3),(q,'D','Circle',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'How many sides does a rectangle have?','single_choice','medium',1,'A rectangle has 4 sides: 2 long sides and 2 short sides.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','3',false,2),(q,'C','4',true,3),(q,'D','6',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'Which 3D shape has a circular base and comes to a point at the top?','single_choice','medium',1,'A cone has a circular base and a pointed top.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Cylinder',false,1),(q,'B','Cube',false,2),(q,'C','Sphere',false,3),(q,'D','Cone',true,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'Aarav''s shape has 6 sides. What is the name of this shape?','single_choice','medium',1,'A shape with 6 sides is called a hexagon.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Pentagon',false,1),(q,'B','Hexagon',true,2),(q,'C','Octagon',false,3),(q,'D','Triangle',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'Which 3D shape has NO flat faces at all?','single_choice','medium',1,'A sphere is perfectly round and has no flat faces anywhere.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Cube',false,1),(q,'B','Cylinder',false,2),(q,'C','Sphere',true,3),(q,'D','Cone',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'A rectangle and a square are alike because they BOTH have:','single_choice','medium',1,'Both a rectangle and a square have exactly 4 sides and 4 corners.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3 sides',false,1),(q,'B','All equal sides',false,2),(q,'C','4 sides',true,3),(q,'D','No corners',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'Which real-world object looks like a cylinder?','single_choice','medium',1,'A can of tomatoes has two circular ends and a curved side — it is a cylinder.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','A book',false,1),(q,'B','An ice-cream cone',false,2),(q,'C','A can of tomatoes',true,3),(q,'D','A cricket ball',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'Kavya''s shape has 5 sides. She adds 1 more side to make a new shape. What is the new shape called?','single_choice','hard',1,'5 sides + 1 = 6 sides. A shape with 6 sides is a hexagon.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Pentagon',false,1),(q,'B','Hexagon',true,2),(q,'C','Heptagon',false,3),(q,'D','Square',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'Which statement about a cube is TRUE?','single_choice','hard',1,'A cube has exactly 6 faces, and all 6 faces are equal squares.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','It has 4 faces',false,1),(q,'B','It has 6 equal square faces',true,2),(q,'C','It has no edges',false,3),(q,'D','It is round',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t12,v_kg,v_tt,'Rohan cuts a cone straight across the middle horizontally. What shape does the cut surface make?','single_choice','hard',1,'Cutting a cone horizontally produces a circular cross-section.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Square',false,1),(q,'B','Triangle',false,2),(q,'C','Circle',true,3),(q,'D','Rectangle',false,4);

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 13 · Measurement and Data
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Measurement and Data',v_sub,v_kg,'Compare lengths, weights, and capacities; read simple picture graphs',13)
  RETURNING id INTO v_t13;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'Priya has a long pencil and a short pencil. Which one is longer?','single_choice','easy',1,'The long pencil is longer — that is what "long" means.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','The short pencil',false,1),(q,'B','The long pencil',true,2),(q,'C','They are the same',false,3),(q,'D','Cannot tell',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'An elephant is ___ than a cat.','single_choice','easy',1,'An elephant is much heavier than a cat.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Lighter',false,1),(q,'B','Smaller',false,2),(q,'C','Heavier',true,3),(q,'D','Shorter',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'Which holds MORE water: a small cup or a large bucket?','single_choice','easy',1,'A large bucket holds far more water than a small cup.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Small cup',false,1),(q,'B','Large bucket',true,2),(q,'C','They hold the same',false,3),(q,'D','Cannot tell',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'Aarav is TALLER than Rohan. Who is SHORTER?','single_choice','easy',1,'If Aarav is taller, then Rohan must be shorter.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Aarav',false,1),(q,'B','Rohan',true,2),(q,'C','Both are the same',false,3),(q,'D','Cannot tell',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'A book is heavier than a feather. A feather is ___ than a book.','single_choice','easy',1,'If the book is heavier, then the feather must be lighter.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Heavier',false,1),(q,'B','Taller',false,2),(q,'C','Lighter',true,3),(q,'D','Wider',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'Kavya measures a ribbon using small paper clips and gets 5. Meera measures the same ribbon using bigger paper clips and gets 3. Whose paper clips are bigger?','single_choice','medium',1,'Bigger units mean fewer are needed to measure the same length. Meera used fewer clips, so her clips are bigger.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Kavya''s',false,1),(q,'B','Meera''s',true,2),(q,'C','Both are the same size',false,3),(q,'D','Cannot tell',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'Priya draws a picture graph: 4 sun stickers for sunny days and 2 cloud stickers for cloudy days. How many MORE sunny days were there than cloudy days?','single_choice','medium',1,'4 sunny days - 2 cloudy days = 2 more sunny days.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',true,1),(q,'B','4',false,2),(q,'C','6',false,3),(q,'D','8',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'Rohan''s pencil is 8 cubes long. Diya''s pencil is 5 cubes long. How much LONGER is Rohan''s pencil?','single_choice','medium',1,'8 - 5 = 3 cubes longer.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2 cubes',false,1),(q,'B','3 cubes',true,2),(q,'C','5 cubes',false,3),(q,'D','13 cubes',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'Ishaan sorts his toys by colour. He has 3 red, 5 blue, and 2 yellow toys. Which colour group has the FEWEST toys?','single_choice','medium',1,'2 is the smallest number among 3, 5, and 2. Yellow has the fewest toys.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Red',false,1),(q,'B','Blue',false,2),(q,'C','Yellow',true,3),(q,'D','All are equal',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'A class counted favourite fruits: 6 like bananas, 4 like apples, 7 like mangoes. How many children were counted in all?','single_choice','medium',1,'6 + 4 + 7 = 17 children counted.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','7',false,1),(q,'B','10',false,2),(q,'C','17',true,3),(q,'D','20',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'Which shows the CORRECT way to measure the length of a pencil with cubes?','single_choice','medium',1,'To measure length, cubes must be placed end to end from one tip to the other with no gaps.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Place cubes in a pile',false,1),(q,'B','Place cubes end to end from tip to tip',true,2),(q,'C','Place cubes far apart',false,3),(q,'D','Count the pencil''s sides',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'Naina puts 3 cubes end to end to measure a book. Each cube is 2 cm long. How long is the book?','single_choice','medium',1,'3 cubes x 2 cm each = 6 cm long.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','3 cm',false,1),(q,'B','5 cm',false,2),(q,'C','6 cm',true,3),(q,'D','9 cm',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'In Aditya''s class, 5 students chose cricket, 3 chose football, and 4 chose badminton. How many students are in the class?','single_choice','hard',1,'5 + 3 + 4 = 12 students.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','9',false,1),(q,'B','11',false,2),(q,'C','12',true,3),(q,'D','15',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'Vivaan''s box holds 10 marbles when full. He has 4 marbles. How many MORE marbles does he need to fill the box?','single_choice','hard',1,'10 - 4 = 6. He needs 6 more marbles.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4',false,1),(q,'B','6',true,2),(q,'C','10',false,3),(q,'D','14',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t13,v_kg,v_tt,'Arjun measures his classroom using his foot and takes 15 steps. His friend Karan takes 12 steps across the same room. Whose foot is longer?','single_choice','hard',1,'Fewer steps to cover the same distance means each step is longer. Karan took fewer steps, so his foot is longer.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Arjun''s foot',false,1),(q,'B','Karan''s foot',true,2),(q,'C','Both feet are the same',false,3),(q,'D','Cannot tell',false,4);

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 14 · Time
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Time',v_sub,v_kg,'Read clocks at the hour and half-hour; understand sequence of daily events',14)
  RETURNING id INTO v_t14;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'A clock shows 3 o''clock. What time is it?','single_choice','easy',1,'When the hour hand points to 3 and the minute hand points to 12, the time is 3:00.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2:00',false,1),(q,'B','3:00',true,2),(q,'C','4:00',false,3),(q,'D','12:00',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'How many hours are in one day?','single_choice','easy',1,'There are 24 hours in one full day.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','12',false,1),(q,'B','24',true,2),(q,'C','60',false,3),(q,'D','7',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'How many minutes are in one hour?','single_choice','easy',1,'There are 60 minutes in one hour.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','12',false,1),(q,'B','24',false,2),(q,'C','60',true,3),(q,'D','100',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'Priya goes to school in the ___.','single_choice','easy',1,'School usually starts in the morning.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Midnight',false,1),(q,'B','Morning',true,2),(q,'C','Late evening',false,3),(q,'D','During the night',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'On a clock, which hand is the SHORT hand?','single_choice','easy',1,'The short hand on a clock is the hour hand. It points to the hour.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','The second hand',false,1),(q,'B','The minute hand',false,2),(q,'C','The hour hand',true,3),(q,'D','Both hands are equal',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'The short hand (hour hand) points to 7. The long hand (minute hand) points to 12. What time is it?','single_choice','medium',1,'Hour hand at 7, minute hand at 12 means it is exactly 7:00.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','12:07',false,1),(q,'B','7:00',true,2),(q,'C','7:12',false,3),(q,'D','12:00',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'Aarav sleeps at 9 o''clock at night and wakes up at 7 o''clock in the morning. About how many hours does he sleep?','single_choice','medium',1,'From 9 PM to 7 AM is 10 hours.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2 hours',false,1),(q,'B','7 hours',false,2),(q,'C','10 hours',true,3),(q,'D','16 hours',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'A clock shows half past 5. What time is this?','single_choice','medium',1,'Half past 5 means 30 minutes after 5 o''clock, which is 5:30.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','5:00',false,1),(q,'B','5:30',true,2),(q,'C','5:15',false,3),(q,'D','6:00',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'School starts at 8 o''clock. It is now 7 o''clock. How much time is left before school starts?','single_choice','medium',1,'From 7:00 to 8:00 is exactly 1 hour.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Half an hour',false,1),(q,'B','1 hour',true,2),(q,'C','2 hours',false,3),(q,'D','7 hours',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'Kavya eats lunch at 12 o''clock. She eats dinner 6 hours later. What time does she eat dinner?','single_choice','medium',1,'12 + 6 = 18, which is 6:00 in the evening.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4:00',false,1),(q,'B','5:00',false,2),(q,'C','6:00',true,3),(q,'D','8:00',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'The hour hand points to 2 and the minute hand points to 12. What time is it?','single_choice','medium',1,'Hour hand at 2, minute hand at 12 means exactly 2:00.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','12:02',false,1),(q,'B','2:00',true,2),(q,'C','2:12',false,3),(q,'D','12:00',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'Which activity takes about 1 minute?','single_choice','medium',1,'Washing hands takes about 1 minute. The other activities take much longer.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Growing a plant',false,1),(q,'B','Washing your hands',true,2),(q,'C','Building a house',false,3),(q,'D','Watching a film',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'Rohan''s clock shows 4:30. In 1 hour, what time will it be?','single_choice','hard',1,'4:30 plus 1 hour equals 5:30.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','4:00',false,1),(q,'B','4:31',false,2),(q,'C','5:00',false,3),(q,'D','5:30',true,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'Diya''s class lasts from 9 o''clock to 11 o''clock. How long does her class last?','single_choice','hard',1,'From 9:00 to 11:00 is 2 hours.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1 hour',false,1),(q,'B','2 hours',true,2),(q,'C','9 hours',false,3),(q,'D','11 hours',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t14,v_kg,v_tt,'Ishaan starts homework at half past 4 (4:30) and finishes at 5 o''clock. How long did he work on his homework?','single_choice','hard',1,'From 4:30 to 5:00 is 30 minutes.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','15 minutes',false,1),(q,'B','30 minutes',true,2),(q,'C','1 hour',false,3),(q,'D','45 minutes',false,4);

  -- ══════════════════════════════════════════════════════════════════
  -- TOPIC 15 · Indian Currency
  -- ══════════════════════════════════════════════════════════════════
  INSERT INTO topics(id,name,subject_id,grade_id,description,display_order)
  VALUES(uuid_generate_v4(),'Indian Currency',v_sub,v_kg,'Identify rupee coins (Rs. 1, 2, 5, 10); count and compare small amounts of money',15)
  RETURNING id INTO v_t15;

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'What is the value of one rupee (Rs. 1) coin?','single_choice','easy',1,'A one-rupee coin is worth exactly Rs. 1.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Rs. 2',false,1),(q,'B','Rs. 1',true,2),(q,'C','Rs. 5',false,3),(q,'D','Rs. 10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'Which coin has the GREATEST value: Rs. 1, Rs. 2, Rs. 5, or Rs. 10?','single_choice','easy',1,'Rs. 10 is the largest amount among Rs. 1, Rs. 2, Rs. 5, and Rs. 10.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Rs. 1',false,1),(q,'B','Rs. 2',false,2),(q,'C','Rs. 5',false,3),(q,'D','Rs. 10',true,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'Priya has two Rs. 1 coins. How much money does she have?','single_choice','easy',1,'Rs. 1 + Rs. 1 = Rs. 2.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Rs. 1',false,1),(q,'B','Rs. 2',true,2),(q,'C','Rs. 3',false,3),(q,'D','Rs. 4',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'Aarav has a Rs. 5 coin. How much is it worth?','single_choice','easy',1,'A Rs. 5 coin is worth exactly five rupees.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Rs. 1',false,1),(q,'B','Rs. 2',false,2),(q,'C','Rs. 5',true,3),(q,'D','Rs. 10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'How many Rs. 1 coins equal one Rs. 5 coin?','single_choice','easy',1,'It takes five Rs. 1 coins to make Rs. 5.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','1',false,1),(q,'B','2',false,2),(q,'C','3',false,3),(q,'D','5',true,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'Rohan has one Rs. 2 coin and one Rs. 5 coin. How much money does he have?','single_choice','medium',1,'Rs. 2 + Rs. 5 = Rs. 7.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Rs. 2',false,1),(q,'B','Rs. 5',false,2),(q,'C','Rs. 7',true,3),(q,'D','Rs. 10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'Kavya has three Rs. 1 coins. She wants to buy an eraser that costs Rs. 5. How much MORE money does she need?','single_choice','medium',1,'She has Rs. 3 and needs Rs. 5. Rs. 5 - Rs. 3 = Rs. 2 more.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Rs. 1',false,1),(q,'B','Rs. 2',true,2),(q,'C','Rs. 3',false,3),(q,'D','Rs. 5',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'Meera has one Rs. 10 coin and one Rs. 2 coin. How much money does she have?','single_choice','medium',1,'Rs. 10 + Rs. 2 = Rs. 12.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Rs. 8',false,1),(q,'B','Rs. 10',false,2),(q,'C','Rs. 12',true,3),(q,'D','Rs. 20',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'Dev buys a pencil for Rs. 3. He pays with a Rs. 5 coin. How much change does he get back?','single_choice','medium',1,'Rs. 5 - Rs. 3 = Rs. 2 change.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Rs. 1',false,1),(q,'B','Rs. 2',true,2),(q,'C','Rs. 3',false,3),(q,'D','Rs. 5',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'Diya has two Rs. 5 coins. How much money does she have?','single_choice','medium',1,'Rs. 5 + Rs. 5 = Rs. 10.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Rs. 5',false,1),(q,'B','Rs. 10',true,2),(q,'C','Rs. 15',false,3),(q,'D','Rs. 25',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'Arjun has one Rs. 1 coin, one Rs. 2 coin, and one Rs. 5 coin. How much money does he have altogether?','single_choice','medium',1,'Rs. 1 + Rs. 2 + Rs. 5 = Rs. 8.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Rs. 5',false,1),(q,'B','Rs. 7',false,2),(q,'C','Rs. 8',true,3),(q,'D','Rs. 10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'Which group of coins equals exactly Rs. 10?','single_choice','medium',1,'Two Rs. 5 coins = Rs. 5 + Rs. 5 = Rs. 10.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Two Rs. 2 coins',false,1),(q,'B','One Rs. 5 and one Rs. 2',false,2),(q,'C','Two Rs. 5 coins',true,3),(q,'D','One Rs. 10 and one Rs. 2',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'Naina has one Rs. 10 coin, one Rs. 5 coin, and two Rs. 2 coins. How much money does she have?','single_choice','hard',1,'Rs. 10 + Rs. 5 + Rs. 2 + Rs. 2 = Rs. 19.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Rs. 15',false,1),(q,'B','Rs. 17',false,2),(q,'C','Rs. 19',true,3),(q,'D','Rs. 21',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'Vivaan wants to buy a toy that costs Rs. 20. He has one Rs. 10 coin and three Rs. 2 coins. How much MORE money does he need?','single_choice','hard',1,'He has Rs. 10 + Rs. 2 + Rs. 2 + Rs. 2 = Rs. 16. He needs Rs. 20 - Rs. 16 = Rs. 4 more.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','Rs. 4',true,1),(q,'B','Rs. 6',false,2),(q,'C','Rs. 8',false,3),(q,'D','Rs. 10',false,4);

  INSERT INTO questions(id,topic_id,grade_id,test_type_id,question_text,question_type,difficulty,points,explanation)
  VALUES(uuid_generate_v4(),v_t15,v_kg,v_tt,'Priya has the same amount of money as Rohan. Priya has two Rs. 5 coins. Rohan has only Rs. 2 coins. How many Rs. 2 coins does Rohan have?','single_choice','hard',1,'Priya has Rs. 10. Rohan needs Rs. 10 using Rs. 2 coins. Rs. 10 / Rs. 2 = 5 coins.') RETURNING id INTO q;
  INSERT INTO answer_options(question_id,option_label,option_text,is_correct,display_order) VALUES (q,'A','2',false,1),(q,'B','4',false,2),(q,'C','5',true,3),(q,'D','10',false,4);

END;
$$;
