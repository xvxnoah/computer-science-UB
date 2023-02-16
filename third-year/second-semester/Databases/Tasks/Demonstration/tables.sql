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