-- tables.sql
CREATE TABLE Programs(
    name TEXT PRIMARY KEY,
    abbreviation TEXT NOT NULL UNIQUE
);

CREATE TABLE Students (
	idnr CHAR(10) PRIMARY KEY,
	name TEXT NOT NULL,
	login TEXT NOT NULL UNIQUE,
	program TEXT NOT NULL,
	CONSTRAINT check_idnr CHECK(idnr~'^[0-9]{10}$'),
	FOREIGN KEY(program) REFERENCES Programs,
	UNIQUE(idnr, program)
);

CREATE TABLE Branches (
	name TEXT, 
	program TEXT,
	PRIMARY KEY(name,program),
	FOREIGN KEY(program) REFERENCES Programs
);

CREATE TABLE Departments (
    name TEXT PRIMARY KEY,
    abbreviation TEXT NOT NULL UNIQUE
);

CREATE TABLE Courses (
	code CHAR(6) PRIMARY KEY,
	name TEXT NOT NULL,
	credits DECIMAL NOT NULL,
	department TEXT NOT NULL,
	CONSTRAINT check_more_than_zero CHECK(credits > 0),
	FOREIGN KEY(department) REFERENCES Departments,
	CONSTRAINT check_course_format CHECK(code~'^[A-Z]{3}[0-9]{3}$')
);

CREATE TABLE Prerequisite (
    prerequisiteCourse CHAR(6) NOT NULL,
    course CHAR(6) NOT NULL,
    PRIMARY KEY(prerequisiteCourse, course),
    FOREIGN KEY(prerequisiteCourse) REFERENCES Courses(code),
    FOREIGN KEY(course) REFERENCES Courses(code)
);

CREATE TABLE LimitedCourses (
	code CHAR(6),
	capacity SMALLINT NOT NULL,
	CONSTRAINT more_than_zero CHECK(capacity > 0),
	PRIMARY KEY(code),
	FOREIGN KEY(code) REFERENCES Courses
);

CREATE TABLE HostedBy (
	department TEXT,
	program TEXT,
	PRIMARY KEY (department, program),
	FOREIGN KEY(department) REFERENCES Departments(name),
	FOREIGN KEY(program) REFERENCES Programs
);

CREATE TABLE StudentBranches (
	student CHAR(10),
	branch TEXT NOT NULL,
	program TEXT NOT NULL,
	PRIMARY KEY(student, branch, program),
	FOREIGN KEY(student) REFERENCES Students,
	FOREIGN KEY(branch, program) REFERENCES Branches(name, program),
	FOREIGN KEY(student, program) REFERENCES Students(idnr, program)
);

CREATE TABLE Classifications (
	name TEXT PRIMARY KEY
);

CREATE TABLE Classified (
	course CHAR(6),
	classification TEXT,
	PRIMARY KEY(course, classification),
	FOREIGN KEY(course) REFERENCES Courses(code),
	FOREIGN KEY(classification) REFERENCES Classifications(name)
);

CREATE TABLE MandatoryProgram (
	course CHAR(6),
	program TEXT,
	PRIMARY KEY(course, program),
	FOREIGN KEY(course) REFERENCES Courses(code),
	FOREIGN KEY(program) REFERENCES Programs
);

CREATE TABLE MandatoryBranch (
	course CHAR(6),
	branch TEXT,
	program TEXT,
	PRIMARY KEY(course, branch, program),
	FOREIGN KEY(course) REFERENCES Courses(code),
	FOREIGN KEY(branch, program) REFERENCES Branches(name, program)
);

CREATE TABLE RecommendedBranch (
	course CHAR(6),
	branch TEXT,
	program TEXT,
	PRIMARY KEY(course, branch, program),
	FOREIGN KEY(course) REFERENCES Courses(code),
	FOREIGN KEY(branch, program) REFERENCES Branches(name, program)
);

CREATE TABLE Registered (
	student CHAR(10),
	course CHAR(6),
	PRIMARY KEY(student, course),
	FOREIGN KEY(student) REFERENCES Students(idnr),
	FOREIGN KEY(course) REFERENCES Courses(code)
);

CREATE TABLE Taken(
	student CHAR(10),
	course CHAR(6),
	grade CHAR(1) NOT NULL,
	CONSTRAINT valid_grade CHECK(grade IN ('U', '3', '4', '5')),
	PRIMARY KEY(student, course),
	FOREIGN KEY(student) REFERENCES Students(idnr),
	FOREIGN KEY(course) REFERENCES Courses(code)
);

CREATE TABLE WaitingList (
	student CHAR(10),
	limitedCourse CHAR(6),
	position SERIAL NOT NULL,
	CONSTRAINT status_more_than_zero CHECK(position > 0),
	UNIQUE(limitedCourse, position),
	PRIMARY KEY(student, limitedCourse),
	FOREIGN KEY(student) REFERENCES Students(idnr),
	FOREIGN KEY(limitedCourse) REFERENCES LimitedCourses(code)
);

-- inserts.sql
INSERT INTO Programs VALUES ('Prog1', 'P1');
INSERT INTO Programs VALUES ('Prog2', 'P2');

INSERT INTO Branches VALUES ('B1','Prog1');
INSERT INTO Branches VALUES ('B2','Prog1');
INSERT INTO Branches VALUES ('B1','Prog2');

INSERT INTO Students VALUES ('1111111111','N1','ls1','Prog1');
INSERT INTO Students VALUES ('2222222222','N2','ls2','Prog1');
INSERT INTO Students VALUES ('3333333333','N3','ls3','Prog2');
INSERT INTO Students VALUES ('4444444444','N4','ls4','Prog1');
INSERT INTO Students VALUES ('5555555555','Nx','ls5','Prog2');
INSERT INTO Students VALUES ('6666666666','Nx','ls6','Prog2');
INSERT INTO Students VALUES ('8888888888','Nx','ls8','Prog1');

INSERT INTO Departments VALUES ('Dep1', 'D1');

INSERT INTO Courses VALUES ('CCC111','C1',22.5,'Dep1');
INSERT INTO Courses VALUES ('CCC222','C2',20,'Dep1');
INSERT INTO Courses VALUES ('CCC333','C3',30,'Dep1');
INSERT INTO Courses VALUES ('CCC444','C4',60,'Dep1');
INSERT INTO Courses VALUES ('CCC555','C5',50,'Dep1');
INSERT INTO Courses VALUES ('CCC666','C6',20,'Dep1');

INSERT INTO Prerequisite (course, prerequisiteCourse) VALUES ('CCC555', 'CCC444');

INSERT INTO LimitedCourses VALUES ('CCC222',1);
INSERT INTO LimitedCourses VALUES ('CCC333',2);
INSERT INTO LimitedCourses VALUES ('CCC666',1);

INSERT INTO Classifications VALUES ('math');
INSERT INTO Classifications VALUES ('research');
INSERT INTO Classifications VALUES ('seminar');

INSERT INTO Classified VALUES ('CCC333','math');
INSERT INTO Classified VALUES ('CCC444','math');
INSERT INTO Classified VALUES ('CCC444','research');
INSERT INTO Classified VALUES ('CCC444','seminar');

INSERT INTO HostedBy VALUES ('Dep1', 'Prog1');
INSERT INTO HostedBy VALUES ('Dep1', 'Prog2');

INSERT INTO StudentBranches VALUES ('2222222222','B1','Prog1');
INSERT INTO StudentBranches VALUES ('3333333333','B1','Prog2');
INSERT INTO StudentBranches VALUES ('4444444444','B1','Prog1');
INSERT INTO StudentBranches VALUES ('5555555555','B1','Prog2');

INSERT INTO MandatoryProgram VALUES ('CCC111','Prog1');

INSERT INTO MandatoryBranch VALUES ('CCC333', 'B1', 'Prog1');
INSERT INTO MandatoryBranch VALUES ('CCC444', 'B1', 'Prog2');

INSERT INTO RecommendedBranch VALUES ('CCC222', 'B1', 'Prog1');
INSERT INTO RecommendedBranch VALUES ('CCC333', 'B1', 'Prog2');

INSERT INTO Registered VALUES ('1111111111','CCC111');
INSERT INTO Registered VALUES ('1111111111','CCC222');
INSERT INTO Registered VALUES ('1111111111','CCC333');
INSERT INTO Registered VALUES ('2222222222','CCC222');
INSERT INTO Registered VALUES ('5555555555','CCC222');
INSERT INTO Registered VALUES ('5555555555','CCC333');

INSERT INTO Taken VALUES('4444444444','CCC111','5');
INSERT INTO Taken VALUES('4444444444','CCC222','5');
INSERT INTO Taken VALUES('4444444444','CCC333','5');
INSERT INTO Taken VALUES('4444444444','CCC444','5');

INSERT INTO Taken VALUES('5555555555','CCC111','5');
INSERT INTO Taken VALUES('5555555555','CCC222','4');
INSERT INTO Taken VALUES('5555555555','CCC444','3');

INSERT INTO Taken VALUES('2222222222','CCC111','U');
INSERT INTO Taken VALUES('2222222222','CCC222','U');
INSERT INTO Taken VALUES('2222222222','CCC444','U');

INSERT INTO WaitingList VALUES('3333333333','CCC222',1);
INSERT INTO WaitingList VALUES('3333333333','CCC333',1);
INSERT INTO WaitingList VALUES('2222222222','CCC333',2);

-- views.sql
CREATE VIEW BasicInformation AS
    SELECT stu.idnr, name, login, stu.program, branch
        FROM Students AS stu LEFT OUTER JOIN StudentBranches AS StuB
        ON (stu.idnr = StuB.student);

CREATE VIEW FinishedCourses AS
    SELECT t.student, t.course, t.grade, c.credits, c.name
    FROM Taken AS t, Courses AS c
    WHERE (c.code = t.course);

CREATE VIEW PassedCourses AS
    SELECT student, course, credits
    FROM FinishedCourses
    WHERE (grade<>'U');

CREATE VIEW Registrations AS
    SELECT student, course, COALESCE(status, 'registered') AS status, position
    FROM (SELECT student, position, limitedCourse AS course, 'waiting' AS status FROM WaitingList) AS waiting NATURAL
        FULL OUTER JOIN Registered AS registerd;

CREATE VIEW MandatoryProgramCourses AS
    SELECT binfo.idnr AS student, mandatory.course
    FROM BasicInformation AS binfo, MandatoryProgram AS mandatory
    WHERE (binfo.program = mandatory.program);

CREATE VIEW MandatoryBranchCourses AS
    SELECT binfo.idnr AS student, mandatory.course
    FROM BasicInformation AS binfo, MandatoryBranch AS mandatory
    WHERE binfo.branch = mandatory.branch AND binfo.program = mandatory.program;

CREATE VIEW RecommendedBranchCourses AS
    SELECT binfo.idnr AS student, recommended.course
    FROM BasicInformation AS binfo, RecommendedBranch AS recommended
    WHERE binfo.branch = recommended.branch AND binfo.program = recommended.program;

CREATE VIEW UnreadMandatory AS
    SELECT student, course FROM MandatoryProgramCourses UNION
    SELECT student, course FROM MandatoryBranchCourses
    EXCEPT (SELECT student, course FROM PassedCourses);

CREATE VIEW ClassCredits As
    SELECT student, course, credits, classification AS class
    FROM PassedCourses AS fc
    LEFT JOIN Classified AS c USING(course);

CREATE VIEW PathToGraduationHelper AS
WITH
    -- student
    col0 AS (SELECT idnr AS student FROM students),

    -- total credits
    col1 AS (SELECT student,SUM(credits) AS totalCredits
             FROM PassedCourses GROUP BY student),

    -- mandatory left
    col2 AS (SELECT student,COUNT(course) AS mandatoryLeft
             FROM UnreadMandatory GROUP BY student),

    -- math credits
    col3 AS (SELECT student,SUM(credits) AS credits
             FROM ClassCredits
             WHERE class = 'math'
             GROUP BY student),

    -- research credits
    col4 AS (SELECT student,SUM(credits) AS credits
             FROM ClassCredits
             WHERE class = 'research'
             GROUP BY student),

    -- seminar courses
    col5 AS (SELECT student,COUNT(*) AS course
             FROM ClassCredits
             WHERE class = 'seminar'
             GROUP BY student),

    -- recommended courses
    col6 AS (SELECT student, SUM(credits) AS credits
            FROM PassedCourses AS pc
                RIGHT JOIN RecommendedBranchCourses
                USING (course, student)
                GROUP BY student)

-- Use COALESCE to replace null values with 0.
SELECT col0.student,
       COALESCE(col1.totalCredits,0)   AS totalCredits,
       COALESCE(col2.mandatoryLeft,0)  AS mandatoryLeft,
       COALESCE(col3.credits,0)        AS mathCredits,
       COALESCE(col4.credits,0)        AS researchCredits,
       COALESCE(col5.course,0)         AS seminarCourses,
       COALESCE(col6.credits,0)        AS recommendedcredits
    FROM col0
    -- Use a chain of (left) outer joins to combine them.
    LEFT OUTER JOIN col1 ON (col0.student=col1.student)
    LEFT OUTER JOIN col2 ON (col0.student=col2.student)
    LEFT OUTER JOIN col3 ON (col0.student=col3.student)
    LEFT OUTER JOIN col4 ON (col0.student=col4.student)
    LEFT OUTER JOIN col5 ON (col0.student=col5.student)
    LEFT OUTER JOIN col6 ON (col0.student=col6.student);

CREATE VIEW PathToGraduation AS
    SELECT student,
           totalCredits,
           mandatoryLeft,
           mathCredits,
           researchCredits,
           seminarCourses,
                 mandatoryLeft = 0             -- mandatory courses left
                 AND mathCredits >= 20         -- math credits
                 AND researchCredits >= 10     -- research credits
                 AND seminarCourses  >= 1      -- seminar curses
                 AND recommendedcredits >= 10  -- recommended credits
           AS qualified
        FROM PathToGraduationHelper;