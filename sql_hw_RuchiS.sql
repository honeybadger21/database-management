-- Information Management - HW 02 
-- Submitted by: Ruchi Sharma, rs58898 

-- The table structure contains the following info:
-- StudId is an integer Primary Key of 6 digits
-- StdFirstName has up to 30 characters and is not allowed to be empty
-- StdLastName has up to 30 characters and is allowed to be empty
-- TotalScore is a percentage number between 0 and 100, both inclusive expressed in up to two fractional digits
-- CourseName has up to 30 characters and can be NULL
-- Section can be either A or B
-- Stream can be either Accounting, Finance, IB, Marketing, MIS, or Analytics that the student belongs to.

-- Question 1: Show all the records from (all the) table(s) you have created. 

CREATE TABLE Student
(   
  StudID number(6),  
  FirstName varchar2(30) NOT NULL,
  LastName varchar2(30),
  Stream CHAR(10),
  CONSTRAINT stream_chk CHECK (Stream IN ('Accounting', 'Finance', 'IB', 'Marketing', 'MIS', 'Analytics')),
  CONSTRAINT stdpk PRIMARY KEY (StudID)  
);


CREATE TABLE Course 
(   
  StudID number(6),
  TotalScore decimal(5, 2) not null check (TotalScore >= 0 and TotalScore <= 100),
  CourseName varchar2(30),
  Section CHAR(1),
  CONSTRAINT section_chk CHECK (Section IN ('A', 'B')),
  CONSTRAINT fkstudent
  FOREIGN KEY (StudID)
  REFERENCES Student(StudID)
);

INSERT INTO Student (StudID, FirstName,LastName,Stream) VALUES (135791, 'Albert','Einstein','Accounting');
INSERT INTO Student (StudID, FirstName,LastName,Stream) VALUES (246802, 'Homi','Bhabha','Finance');
INSERT INTO Student (StudID, FirstName,LastName,Stream) VALUES (147036, 'Marie','Daly','IB');
INSERT INTO Student (StudID, FirstName,LastName,Stream) VALUES (260482,'Srinivasa','Ramanuja','Analytics');
INSERT INTO Student (StudID, FirstName,LastName,Stream) VALUES (161616,'Marie','Curie','Analytics');
INSERT INTO Student (StudID, FirstName,LastName,Stream) VALUES (271828,'Vikram','Sarabhai','MIS');
INSERT INTO Student (StudID, FirstName,LastName,Stream) VALUES (314159,'Chien','Wu','Marketing');

INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (135791, 99.98,'Physics','A');
INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (246802, 99.99,'Physics','B');
INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (147036,100,'Chemistry','A');
INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (260482,17.29,'Math','A');
INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (161616,88,'Chemistry','B');
INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (271828,19.19,'Astronomy','A');
INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (314159,19.12,'Physics','A');
INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (314159,100,'Chemistry','B');
INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (135791,75,'Chemistry','A');
INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (246802, 48, 'Math','A');
INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (147036, 67,'Math','A');
INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (260482, 92.71,'Chemistry','A');
INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (161616, 88.88,'Astronomy','B');
INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (271828, 91.91,'Physics','A');
INSERT INTO Course (StudID,TotalScore,CourseName,Section) VALUES (314159, 91.21,'Math','A');

select * from Student;
select * from Course;

-- Question 2: Display only the first and last names, and courses each student is enrolled in.

select a.FirstName, a.LastName, b.CourseName from Student a join Course b on a.StudID=b.StudID;

-- Question 3: Which students are failing in which classes, where the failing grade is 40%?

select a.FirstName, a.LastName, b.CourseName from Student a join Course b on a.StudID=b.StudID where b.TotalScore<40;

-- Question 4: Which students from the Analytics stream are failing?

select a.FirstName, a.LastName, b.CourseName from Student a join Course b on a.StudID=b.StudID where b.TotalScore<40 and a.Stream='Analytics';

-- Question 5: Now alter the table(s) by adding a Professor to each class being taught. Right now keep the professor name empty. Show the new table(s). 

ALTER TABLE Course
ADD Professor varchar2(100);

select * from Course;

-- Question 6: Change the student name ‘Marie Curie’ to ‘Pierre Curie’.

UPDATE Student
SET FirstName='Pierre'
WHERE FirstName='Marie' and LastName='Curie';

select * from Student;

-- Question 7: Display the full record for those students whose first name contains the regular expression ‘ie’. For example, the word lied has the regular expression ‘ie’, while lai does not.

select a.StudID, a.FirstName, a.LastName, a.Stream, b.CourseName, b.TotalScore, b.Section from Student a join Course b on a.StudID=b.StudID 
WHERE a.FirstName like('%ie%');

-- Question 8: Find all the students from the Analytics stream whose score is greater than the average of the Analytic stream students.

select distinct a.studID, a.FirstName, a.LastName from Student a join Course b on a.StudID=b.StudID
WHERE a.stream = 'Analytics' and b.totalscore > (select avg(b.totalscore) from Course b join Student a on a.StudID=B.StudID where a.stream = 'Analytics');

-- Question 9:  Print the information from these columns StudID, StdFirstName, StdLastName, TotalScore, CourseName, Section, Stream sorted on the last name of the students. 

select a.StudID, a.FirstName, a.LastName, a.Stream, b.CourseName, b.TotalScore, b.Section from Student a join Course b on a.StudID=b.StudID 
order by a.LastName;

-- Question 10: Find the student who received the highest score on each subject (ignore the sections A and B for each subject to find the topper in each subject). 

select x.FirstName, x.LastName, c.studID, c.Coursename, c.highest from 
(
select b.studID, b.CourseName, a.Highest 
from (select courseName, max(TotalScore) as Highest from Course group by coursename) a
inner join course b on a.highest = b.totalscore
) c
join student x 
on x.studid = c.studid;