CREATE VIEW BasicInformation AS
    SELECT stu.idnr, name, login, stu.program, branch
        FROM Students AS stu LEFT OUTER JOIN StudentBranches AS StuB
        ON (stu.idnr = StuB.student);

CREATE VIEW FinishedCourses AS
    SELECT student, t.course, grade, credits
        FROM Taken AS t JOIN Courses ON (t.course = Courses.code);

CREATE VIEW PassedCourses AS
    SELECT student, course, credits
        FROM FinishedCourses
        WHERE (grade<>'U');

CREATE VIEW Registrations AS
    SELECT student,course,(SELECT 'registered' AS status)
        FROM Registered
    UNION
    SELECT student,limitedCourse,(SELECT 'waiting' AS status)
        FROM WaitingList;

CREATE VIEW UnreadMandatoryHelper AS
    SELECT student, mb.course
        FROM StudentBranches, MandatoryBranch AS mb
        WHERE StudentBranches.branch = mb.branch AND
              StudentBranches.program = mb.program
    UNION
    SELECT Students.idnr, mb.course 
        FROM Students, MandatoryProgram AS mb 
        WHERE Students.program = mb.program;

CREATE VIEW UnreadMandatory AS
    SELECT UnreadMandatoryHelper.student, UnreadMandatoryHelper.course 
        FROM UnreadMandatoryHelper
    EXCEPT 
    SELECT PassedCourses.student, PassedCourses.course 
        FROM PassedCourses;

CREATE VIEW PathToGraduationHelper AS
WITH
    -- student
    col0 AS (SELECT idnr AS student FROM students),

    -- total credits
    col1 AS (SELECT student,sum(credits) AS totalCredits
             FROM PassedCourses GROUP BY student),

    -- mandatory left
    col2 AS (SELECT student,count(course) AS mandatoryLeft
             FROM UnreadMandatory GROUP BY student),

    -- math credits
    col3 AS (SELECT student,sum(credits) AS credits
             FROM PassedCourses, Classified
             WHERE PassedCourses.course = Classified.course AND
                   classification= 'math'
             GROUP BY student),

    -- research credits
    col4 AS (SELECT student,sum(credits) AS credits
             FROM PassedCourses, Classified
             WHERE classification = 'research' AND
                   PassedCourses.course = Classified.course
             GROUP BY student),

    -- seminar courses
    col5 AS (SELECT student,count(PassedCourses.course) AS course
             FROM PassedCourses, Classified
             WHERE PassedCourses.course = Classified.course AND
                   classification = 'seminar'
             GROUP BY student),

    -- recommended courses
    col6 AS (SELECT Students.idnr AS student, sum(PassedCourses.credits) AS credits
            FROM Students, StudentBranches, RecommendedBranch, PassedCourses
            WHERE
                Students.idnr = StudentBranches.student
                AND Students.idnr = PassedCourses.student
                AND StudentBranches.branch = RecommendedBranch.branch
                AND StudentBranches.program = RecommendedBranch.program
                AND PassedCourses.course = RecommendedBranch.course
            GROUP BY students.idnr)

-- Use COALESCE to replace null values with 0.
SELECT col0.student,
       coalesce(col1.totalCredits,0)   AS totalCredits,
       coalesce(col2.mandatoryLeft,0)  AS mandatoryLeft,
       coalesce(col3.credits,0)        AS mathCredits,
       coalesce(col4.credits,0)        AS researchCredits,
       coalesce(col5.course,0)         AS seminarCourses,
       coalesce(col6.credits,0)        AS recommendedcredits
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
