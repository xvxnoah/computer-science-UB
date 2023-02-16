CREATE TABLE Branches (
	name CHAR(2), 
	program CHAR(5),
	PRIMARY KEY(name,program)
);

CREATE TABLE Students (
	idnr CHAR(10) PRIMARY KEY,
	name TEXT NOT NULL,
	login TEXT NOT NULL,
	program CHAR(5) NOT NULL,
	UNIQUE(login),
	CONSTRAINT check_idnr CHECK(idnr~'^[0-9]{10}$')
);

CREATE TABLE Courses (
	code CHAR(6) PRIMARY KEY,
	name TEXT NOT NULL,
	credits DECIMAL NOT NULL,
	department TEXT NOT NULL,
	CONSTRAINT check_course_format CHECK(code~'^[A-Z]{3}[0-9]{3}$'),
	CONSTRAINT check_more_than_zero CHECK(credits > 0)
);

CREATE TABLE LimitedCourses (
	code CHAR(6),
	capacity SMALLINT NOT NULL,
	CONSTRAINT more_than_zero CHECK(capacity > 0),
	PRIMARY KEY(code),
	FOREIGN KEY(code) REFERENCES Courses(code)
);

CREATE TABLE StudentBranches (
	student CHAR(10),
	branch CHAR(2) NOT NULL,
	program CHAR(5) NOT NULL,
	PRIMARY KEY(student),
	FOREIGN KEY(student) REFERENCES Students(idnr),
	FOREIGN KEY(branch, program) REFERENCES Branches(name, program)
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
	program CHAR(5),
	PRIMARY KEY(course, program),
	FOREIGN KEY(course) REFERENCES Courses(code)
);

CREATE TABLE MandatoryBranch (
	course CHAR(6),
	branch CHAR(2),
	program CHAR(5),
	PRIMARY KEY(course, branch, program),
	FOREIGN KEY(course) REFERENCES Courses(code),
	FOREIGN KEY(branch, program) REFERENCES Branches(name, program)
);

CREATE TABLE RecommendedBranch (
	course CHAR(6),
	branch CHAR(2),
	program CHAR(5),
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
	PRIMARY KEY(student, course),
	FOREIGN KEY(student) REFERENCES Students(idnr),
	FOREIGN KEY(course) REFERENCES Courses(code),
	CONSTRAINT valid_grade CHECK(grade IN ('U', '3', '4', '5'))
);

CREATE TABLE WaitingList (
	student CHAR(10),
	course CHAR(6),
	position INT NOT NULL,
	PRIMARY KEY(student, course),
	FOREIGN KEY(student) REFERENCES Students(idnr),
	FOREIGN KEY(course) REFERENCES LimitedCourses(code),
	CONSTRAINT status_more_than_zero CHECK(position > 0)
);