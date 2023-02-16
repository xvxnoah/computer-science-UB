CREATE VIEW CourseQueuePositions AS
    SELECT limitedCourse AS course, student, position AS place
    FROM WaitingList;

CREATE FUNCTION on_register() RETURNS trigger AS
    $$ BEGIN
    -- Student should not already be registered
    -- Student should not already be in waiting list
    IF (SELECT COUNT(*) FROM Registrations WHERE course = NEW.course AND student = NEW.student) > 0 THEN
        RAISE EXCEPTION USING message='Student is already registered', errcode='23505';
    END IF;

    -- If student does not forfill all requisits, raise error
    IF (SELECT COUNT(*) FROM 
            ((SELECT prerequisiteCourse AS course FROM Prerequisite WHERE course = NEW.course) EXCEPT
            (SELECT course FROM PassedCourses WHERE student =  NEW.student)) AS foo) > 0 THEN
        RAISE EXCEPTION USING message='The student does not meet the prerequisites of this course', errcode='23001';
    END IF;

    -- If student has passed the course, raise error
    IF (SELECT COUNT(*) FROM PassedCourses WHERE student = NEW.student AND course = NEW.course) > 0 THEN
        RAISE EXCEPTION 'Student has already taken the course';
    END IF;

    -- If course is full, add to waiting list
    IF (SELECT COUNT(*) FROM LimitedCourses WHERE code = NEW.course) > 0 AND
        (SELECT COUNT(*) FROM Registered WHERE course = NEW.course) >=
        (SELECT capacity FROM LimitedCourses WHERE code = NEW.course) THEN
        INSERT INTO WaitingList (student, limitedCourse, position) VALUES (NEW.student, NEW.course,
            (SELECT COALESCE(MAX(position), 0) + 1 FROM WaitingList WHERE limitedCourse = NEW.course));
    ELSE
        INSERT INTO Registered (student, course) VALUES (NEW.student, NEW.course);
    END IF;
    RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER on_register_trigger
    INSTEAD OF INSERT ON Registrations
    FOR EACH ROW EXECUTE PROCEDURE on_register();

CREATE FUNCTION on_unregister() RETURNS trigger AS
    $$ 
    DECLARE deletedPosition INT;

    BEGIN
    -- if student is in registered -> remove from registered 
    IF (SELECT COUNT(*) FROM Registered WHERE OLD.student = student AND OLD.course = course) = 1 THEN 
        DELETE FROM Registered WHERE OLD.student = student AND OLD.course = course;
        -- check if course is limited
        IF (SELECT COUNT(*) FROM LimitedCourses WHERE OLD.course = code) != 0 THEN
            -- check if course has capacity
            IF (SELECT COUNT(*) FROM Registered WHERE OLD.course = course) < (SELECT capacity FROM LimitedCourses WHERE OLD.course = code) THEN 
                -- check if people is in waiting list for course
                IF (SELECT COUNT(*) FROM WaitingList WHERE OLD.course = limitedCourse) > 0 THEN 
                    -- insert first student in waiting list into registered
                    INSERT INTO Registered VALUES((SELECT student FROM WaitingList WHERE OLD.course = limitedCourse AND position = 1), OLD.course);
                    -- delete first student from waiting list
                    DELETE FROM WaitingList WHERE OLD.course = limitedCourse AND position = 1;
                    -- update all positions of waiting list
                    UPDATE WaitingList SET position = position - 1 WHERE OLD.course = limitedCourse;
                END IF;
            END IF;
        END IF;
    -- if student in waiting list -> remove from waiting list
    ELSIF (SELECT COUNT(*) FROM WaitingList WHERE OLD.student = student AND OLD.course = limitedCourse) = 1 THEN
        -- save position from deleted student 

        deletedPosition := (SELECT position FROM WaitingList WHERE OLD.student = student AND OLD.course = limitedCourse);
        DELETE FROM WaitingList WHERE OLD.student = student AND OLD.course = limitedCourse;
        UPDATE WaitingList SET position = position - 1 WHERE OLD.course = limitedCourse AND position > deletedPosition;
    END IF;

    RETURN OLD;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER on_unregister_trigger
    INSTEAD OF DELETE ON Registrations
    FOR EACH ROW EXECUTE PROCEDURE on_unregister();
