-- registered to unlimited course
DO $$
BEGIN
    INSERT INTO Registrations VALUES ('2222222222', 'CCC111');
    ASSERT (SELECT student FROM Registered WHERE course = 'CCC111' AND student = '2222222222') IS NOT NULL, 'Student was not registered to unlimited course';
    ASSERT (SELECT student FROM WaitingList WHERE limitedCourse = 'CCC111' AND student = '2222222222') IS NULL, 'Student was added to waiting list for unlimited course';
END
$$;

-- registered to limited course
DO $$
BEGIN
    INSERT INTO Registrations VALUES ('2222222222', 'CCC666');
    ASSERT (SELECT student FROM Registered WHERE course = 'CCC666' AND student = '2222222222') IS NOT NULL, 'Student was not added to limited course';
    ASSERT (SELECT student FROM WaitingList WHERE limitedCourse = 'CCC666' AND student = '2222222222') IS NULL, 'Student was added to waiting list';
END
$$;

-- waiting for limited course
DO $$
BEGIN
    INSERT INTO Registrations VALUES ('3333333333', 'CCC666');
    ASSERT (SELECT student FROM WaitingList WHERE limitedCourse = 'CCC666' AND student = '3333333333') IS NOT NULL, 'Student was not added to waiting list';
    ASSERT (SELECT student FROM Registered WHERE course = 'CCC666' AND student = '3333333333') IS NULL, 'Student was added to registered';
END
$$;

-- removed from a waiting list (with additional students in it)
DO $$
BEGIN
    INSERT INTO Registrations VALUES ('1111111111', 'CCC666');
    INSERT INTO Registrations VALUES ('4444444444', 'CCC666');
    INSERT INTO Registrations VALUES ('5555555555', 'CCC666');
    DELETE FROM Registrations WHERE student = '4444444444' AND course = 'CCC666';
    ASSERT (SELECT student FROM WaitingList WHERE student = '4444444444' AND limitedCourse = 'CCC666') IS NULL, 'Student were not successfully removed from waiting list';
END
$$;

-- unregistered from unlimited course
DO $$
DECLARE
    n_students INT;
BEGIN
    n_students = (SELECT COUNT(*) FROM Registered WHERE course = 'CCC111');
    
    DELETE FROM Registrations WHERE student = '1111111111' AND course = 'CCC111';
    
    ASSERT (SELECT COUNT(*) FROM Registered WHERE course = 'CCC111') = n_students - 1, 'One student was not removed';
END
$$;

-- unregistered from limited course without waiting list
DO $$
DECLARE
    n_registered_students INT;
BEGIN
    INSERT INTO LimitedCourses VALUES ('CCC111', 1);

    n_registered_students = (SELECT COUNT(*) FROM Registered WHERE course = 'CCC111');
    
    DELETE FROM Registrations WHERE student = '2222222222' AND course = 'CCC111';
    
    ASSERT (SELECT COUNT(*) FROM Registered WHERE course = 'CCC111') = n_registered_students - 1, 'Student was not removed';
END
$$;

-- unregistered from limited course with waiting list
DO $$
DECLARE
    n_waiting_students INT;
    n_registered_students INT;
BEGIN
    n_registered_students = (SELECT COUNT(*) FROM Registered WHERE course = 'CCC333');
    n_waiting_students = (SELECT COUNT(*) FROM WaitingList WHERE limitedCourse = 'CCC333');
    
    DELETE FROM Registrations WHERE student = '5555555555' AND course = 'CCC333';
    
    ASSERT (SELECT COUNT(*) FROM Registered WHERE course = 'CCC333') = n_registered_students, 'New student should replace old student';
    ASSERT (SELECT COUNT(*) FROM WaitingList WHERE limitedCourse = 'CCC333') = n_waiting_students - 1, 'Student was not removed from waiting list';
END
$$;

-- unregiestered from overfull course with waiting list
DO $$
DECLARE
    n_waiting_students INT;
    n_registered_students INT;
BEGIN
    n_registered_students = (SELECT COUNT(*) FROM Registered WHERE course = 'CCC222');
    n_waiting_students = (SELECT COUNT(*) FROM WaitingList WHERE limitedCourse = 'CCC222');
    
    DELETE FROM Registrations WHERE student = '2222222222' AND course = 'CCC222';
    
    ASSERT (SELECT COUNT(*) FROM Registered WHERE course = 'CCC222') = n_registered_students - 1, 'One student was not removed';
    ASSERT (SELECT COUNT(*) FROM WaitingList WHERE limitedCourse = 'CCC222') = n_waiting_students, 'Student was removed from waiting list';
END
$$;

-- Register the same student for the same course again, and check that you get an error response.
DO $$
BEGIN
    INSERT INTO Registrations VALUES ('2222222222', 'CCC111');
    INSERT INTO Registrations VALUES ('2222222222', 'CCC111');
    RAISE EXCEPTION 'Registering student twice does not result in exception';
EXCEPTION
    WHEN unique_violation THEN
    -- Do nothing, since this is expected
END
$$;

-- register student to course they don't have prerequisites for
DO $$
BEGIN
    INSERT INTO Registrations VALUES ('1111111111', 'CCC555');
    
    RAISE EXCEPTION 'Registering student to a course when missing prerequisite course does not result in exception.';
EXCEPTION
    WHEN restrict_violation THEN
        ASSERT (SELECT student FROM Registered WHERE student = '1111111111' AND course = 'CCC555') IS NULL;
END
$$;

-- unregister student from course they're registered to and register again
DO $$
BEGIN
    ASSERT (SELECT student FROM Registered WHERE student = '2222222222' AND course = 'CCC666') IS NOT NULL;
    DELETE FROM Registrations WHERE student = '2222222222' AND course = 'CCC666';
    ASSERT (SELECT student FROM Registered WHERE student = '2222222222' AND course = 'CCC666') IS NULL;
    INSERT INTO Registrations VALUES ('2222222222', 'CCC666');
    ASSERT (SELECT position FROM WaitingList WHERE student = '2222222222' AND limitedCourse = 'CCC666') = (SELECT MAX(position) FROM WaitingList WHERE limitedCourse = 'CCC666');
END
$$;

-- unregister and re-register the same student for the same restricted course
DO $$
DECLARE 
    studentPosition1 INT;
    studentPosition2 INT;
BEGIN
    INSERT INTO Registrations VALUES ('8888888888', 'CCC666');
    studentPosition1 = (SELECT position FROM WaitingList WHERE student = '8888888888' AND limitedCourse = 'CCC666');
    ASSERT (SELECT position FROM WaitingList WHERE student = '8888888888' AND limitedCourse = 'CCC666') = (SELECT MAX(position) FROM WaitingList WHERE limitedCourse = 'CCC666');
    DELETE FROM Registrations WHERE student = '8888888888' AND course = 'CCC666';
    ASSERT (SELECT student FROM Registrations WHERE student = '8888888888' AND course = 'CCC666') IS NULL;
    INSERT INTO Registrations VALUES ('8888888888', 'CCC666');
    studentPosition2 = (SELECT position FROM WaitingList WHERE student = '8888888888' AND limitedCourse = 'CCC666');
    ASSERT (SELECT position FROM WaitingList WHERE student = '8888888888' AND limitedCourse = 'CCC666') = (SELECT MAX(position) FROM WaitingList WHERE limitedCourse = 'CCC666');
    ASSERT studentPosition1 = studentPosition2;
END
$$;