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