SHOW databases;
CREATE database OCTACORE;
USE OCTACORE;
SHOW tables;

 CREATE TABLE Block(
 Block_name VARCHAR(20) NOT NULL,
 PRIMARY KEY(Block_name)
 );
 
CREATE TABLE Teaching_staff(
 Faculty_ID VARCHAR(10) NOT NULL,
 FirstName VARCHAR(35) NOT NULL,
 MiddleName VARCHAR(35),
 LastName VARCHAR(35) NOT NULL,
 Email VARCHAR(40) NOT NULL,
 PRIMARY KEY(Faculty_ID),
 UNIQUE(Email)  -- Ensures that each email is unique
);

CREATE TABLE NTeaching_staff (
 Staff_ID VARCHAR(10) NOT NULL,
 F_name VARCHAR(35) NOT NULL,
 M_name VARCHAR(35),
 L_name VARCHAR(35) NOT NULL,
 EmailID VARCHAR(40),
 PRIMARY KEY(Staff_ID),
 UNIQUE(EmailID) -- Ensures that each email is unique
);

CREATE TABLE Job_desc(
 Discipline_name VARCHAR(60),
 Designation VARCHAR(80),
 Room_number VARCHAR(5),
 Building VARCHAR(20) NOT NULL,
 PRIMARY KEY (Discipline_name,Designation,Room_number,Building),
 INDEX (Designation)
);

CREATE TABLE Students(
 Roll_number VARCHAR(15) NOT NULL,
 First_name VARCHAR(35) NOT NULL,
 Middle_name VARCHAR(35),
 Last_name VARCHAR(35) NOT NULL,
 Email_id VARCHAR(40) NOT NULL,
 Discipline VARCHAR(60) NOT NULL,
 Program VARCHAR(20) NOT NULL,
 PRIMARY KEY(Roll_number),
 UNIQUE(Email_id)  -- Ensures that each email is unique
);

CREATE TABLE Facility (
 Facility_name VARCHAR(60) NOT NULL,
 RoomNumber VARCHAR(5),
 BuildingName VARCHAR(20) NOT NULL,
 Email_addr VARCHAR(40),
 PRIMARY KEY(Facility_name)
);


CREATE TABLE Phone(
 Work VARCHAR(10) NOT NULL,
 Home VARCHAR(6),
 Emergency VARCHAR(10),
 PRIMARY KEY(Work)
);

-- drop database OCTACORE;
-- Relationships below

CREATE TABLE Contact(
 Work VARCHAR(10),
 Faculty_ID VARCHAR(10),
 PRIMARY KEY(Faculty_ID,Work),
 FOREIGN KEY(Faculty_ID) REFERENCES Teaching_staff(Faculty_ID),
 FOREIGN KEY(Work) REFERENCES Phone(Work)
);

CREATE TABLE Contact_enquiry(
 Work VARCHAR(10),
 Staff_ID VARCHAR(10),
 PRIMARY KEY(Staff_ID,Work),
 FOREIGN KEY(Staff_ID) REFERENCES NTeaching_staff(Staff_ID),
 FOREIGN KEY(Work) REFERENCES Phone(Work)
);

CREATE TABLE Contact_info(
 Work VARCHAR(10),
 Facility_name VARCHAR(60),
 PRIMARY KEY(Facility_name,Work),
 FOREIGN KEY(Facility_name) REFERENCES Facility (Facility_name),
 FOREIGN KEY(Work) REFERENCES Phone(Work)
);

CREATE TABLE Contact_number(
 Work VARCHAR(10),
 Roll_number VARCHAR(15),
 PRIMARY KEY(Roll_number,Work),
 FOREIGN KEY(Work) REFERENCES Phone(Work),
 FOREIGN KEY(Roll_number) REFERENCES Students(Roll_number)
);

CREATE TABLE To_Contact(
 Block_name VARCHAR(20),
 Work VARCHAR(10),
 PRIMARY KEY(Block_name,Work),
 FOREIGN KEY(Work) REFERENCES Phone(Work),
 FOREIGN KEY(Block_name) REFERENCES Block(Block_name)
);

ALTER TABLE Job_desc
	ADD INDEX (Discipline_name), -- Index on Designation column
	ADD INDEX (Room_number), -- Index on Room_number column
	ADD INDEX (Building)
    ;

CREATE TABLE Work_info(
 Staff_ID VARCHAR(10),
 Designation VARCHAR(80),
 Room_number VARCHAR(5),
 Building VARCHAR(20),
 Discipline_name VARCHAR(60),
 PRIMARY KEY (Discipline_name,Designation,Room_number,Building,Staff_ID),
 FOREIGN KEY(Designation) REFERENCES Job_desc(Designation),
 FOREIGN KEY(Room_number) REFERENCES Job_desc(Room_number),
 FOREIGN KEY(Building) REFERENCES Job_desc(Building),
 FOREIGN KEY (Staff_ID) REFERENCES NTeaching_staff (Staff_ID)
);

CREATE TABLE Specialization(
 Faculty_ID VARCHAR(10),
 Discipline_name VARCHAR(60),
 Designation VARCHAR(80),
 Room_number VARCHAR(5),
 Building VARCHAR(20),
 PRIMARY KEY (Discipline_name,Designation,Room_number,Building,Faculty_ID),
 FOREIGN KEY(Designation) REFERENCES Job_desc(Designation),
 FOREIGN KEY(Discipline_name) REFERENCES Job_desc(Discipline_name),
 FOREIGN KEY(Room_number) REFERENCES Job_desc(Room_number),
 FOREIGN KEY(Building) REFERENCES Job_desc(Building),
 FOREIGN KEY (Faculty_ID) REFERENCES Teaching_staff (Faculty_ID)
 );

CREATE INDEX first_last_idx1 ON Teaching_staff(FirstName, LastName);
CREATE INDEX first_last_idx2 ON NTeaching_staff(F_name, L_name);
CREATE INDEX first_last_idx3 ON Students(First_name, Last_name);

-- inserting values into tables

-- Insert data into Teaching_staff table
INSERT INTO Teaching_staff (Faculty_ID, FirstName, MiddleName, LastName, Email)
VALUES ('cse1', 'Abhishek', NULL, 'Bichhawat', 'abhishek.b@iitgn.ac.in'),
('cse2', 'Anirban', NULL, 'Dasgupta', 'anirbandg@iitgn.ac.in'), 
('cse3', 'Mayank', NULL, 'Singh', 'singh.mayank@iitgn.ac.in'),
('ee1', 'Joycee', NULL, 'Mekie', 'joycee@iitgn.ac.in'),
('mse1', 'Emila', NULL, 'Panda', 'emila@iitgn.ac.in');

INSERT INTO NTeaching_staff (Staff_ID, F_name, M_name, L_name, EmailID)
VALUES ('n1', 'Anil', NULL, 'Kumar', 'anil.k@iitgn.ac.in'),
('n2', 'Yashwant', NULL, 'Chouhan', 'yashwant@iitgn.ac.in'),
('m1', 'Arika', NULL, 'Patel', 'arika_patel@iitgn.ac.in'),
('cd', 'Don', NULL,'Plackal' , 'don.plackal@iitgn.ac.in'),
('jp', 'Jayeshkumar', NULL, 'Prajapati', 'jayesh.prajapati@iitgn.ac.in');

-- Insert data into Job_desc table
INSERT INTO Job_desc (Discipline_name, Designation, Room_number, Building)
VALUES ('Computer Science and Engineering', 'Assistant Professor', '405A', 'AB13'),
('Computer Science and Engineering', 'Professor', '405G', 'AB13'),
('Computer Science and Engineering', 'Assistant Professor', '403B', 'AB13'),
('Electrical Engineering', 'Associate Professor', '327C', 'AB13'),
('Materials Engineering', 'Associate Professor', '306A', 'AB11'),
('Hospitality', 'Junior Accounts Assistant', '308', 'AB3'),
('Hospitality', 'Hospitality Manager', '329', 'AB3'),
('Materials Management', 'Junior Accounts Officer', '111E', 'AB3'),
('Junior Laboratory Assistant', 'Campus Development', '311', 'AB3'),
('Estate and Works', 'Junior Laboratory Attendant','202','AB3');

-- Insert data into Specialization table
INSERT INTO Specialization (Faculty_ID, Discipline_name, Designation, Room_number, Building)
VALUES ('cse1', 'Computer Science and Engineering', 'Assistant Professor', '405A', 'AB13'),
('cse2', 'Computer Science and Engineering', 'Professor', '405G', 'AB13'),
('cse3', 'Computer Science and Engineering', 'Assistant Professor', '403B', 'AB13'),
('ee1', 'Electrical Engineering', 'Associate Professor', '327C', 'AB13'),
('mse1', 'Materials Engineering', 'Associate Professor', '306A', 'AB11');

INSERT INTO Work_info(Staff_ID,Designation,Room_number,Building,Discipline_name)
VALUES ('n1', 'Junior Accounts Assistant', '308', 'AB3', 'Hospitality'),
('n2', 'Hospitality Manager', '329', 'AB3', 'Hospitality'),
('m1', 'Junior Accounts Officer', '111E', 'AB3', 'Materials Management'),
('cd', 'Campus Development', '311', 'AB3', 'Junior Laboratory Assistant'),
('jp', 'Junior Laboratory Attendant','202','AB3','Estate and Works');

INSERT INTO Phone(Work, Home, Emergency) VALUES
('2573','1573', NULL),('2463','1463', NULL),('2538','1538', NULL),('2409','1409',NULL),
('2421','1420',NULL),('2174','1834',NULL),('1217', NULL, NULL),('2163', NULL, NULL),
('2094', NULL, NULL),('1171', NULL, NULL);

INSERT INTO Contact(Faculty_ID, Work) VALUES
('cse1', '2573'),('cse2', '2463'), ('cse3', '2538'),('ee1', '2409'),('mse1', '2421');

INSERT INTO Contact_enquiry(Staff_ID, Work) VALUES
 ('n1', '2174'),('n2', '1217'),('m1', '2163'),('cd', '2094'),('jp', '1171');

-- Insert data into Block
INSERT INTO Block (Block_name) 
VALUES ('Hostel-G'), ('Hostel-H'), ('Hostel-I'), ('Hostel-J'), ('Hostel-K'), ('Hostel-L'), ('Mini Library Hostel');
-- Insert data into Phone
INSERT INTO Phone (Work, Home, Emergency)
VALUES ('1237', null, null), ('1238', null, null), ('1239', null, null), ('1240', null, null), ('1241', null, null), ('1242', null, null), ('1243', null, null);

-- Insert data into to contact table
INSERT INTO To_Contact (Block_name, Work)
VALUES ('Hostel-G', '1237'), ('Hostel-H', '1238'), ('Hostel-I', '1239'), ('Hostel-J', '1240'), ('Hostel-K', '1241'), ('Hostel-K', '1242'), ('Hostel-L', '1243');

INSERT INTO Students (Roll_number, First_name, Middle_name, Last_name, Email_id, Discipline, Program)
VALUES ('20110002', 'Abhishek', 'Balaji', 'Mungekar', 'abhishek.mungekar@iitgn.ac.in', 'Mechanical Engineering', 'Btech'), 
       ('20110003', 'Progyan', 'Balaji', 'Das', 'progyandas@iitgn.ac.in', 'Computer Science Engineering', 'Btech'),
       ('20110004', 'Dhairya', 'Balaji', 'Shah', 'shahdhairya@iitgn.ac.in', 'Computer Science Engineering', 'Btech'),
       ('20110005', 'Varad', 'Desh', 'Seshpande', 'varadseshpande@iitgn.ac.in', 'Chemical Engineering', 'Btech'),
       ('20110006', 'Bhavesh', 'Balaji', 'Jain', 'jainbhavesh@iitgn.ac.in', 'Computer Science Engineering', 'Btech');

INSERT INTO Phone (Work, Home, Emergency)
VALUES ('9000000002', null, null), ('9000000003', null, null), ('9000000004', null, null), ('9000000005', null, null), ('9000000006', null, null);

insert into Contact_number (Work, Roll_number)
values ('9000000002', '20110002'),('9000000003', '20110003'), ('9000000004', '20110004'),('9000000005', '20110005'),('9000000006', '20110006');
       
 -- Facility
insert into Facility (Facility_name, RoomNumber, BuildingName, Email_addr)
values ('Library 1', '107', 'AB3', 'library@iitgn.ac.in'), ('Library 2', '107', 'AB3', 'library@iitgn.ac.in'), ('Library 3', '107', 'AB3', 'library@iitgn.ac.in'),
	   ('Mini Library Hostel', null, 'Hostel E', 'minilibrary@iitgn.ac.in'), ('Library Temporary', '201', 'AB2', null), ('Research Park', '101', 'AB8', 'researchpark@iitgn.ac.in');

INSERT INTO Phone (Work, Home, Emergency)
VALUES ('1127', null, null), ('1128', null, null), ('1129', null, null), ('1130', null, null), ('2099', null, null), ('2811', null, null);

insert into Contact_info(Work, Facility_name)
values ('1127', 'Library 1'), ('1128', 'Library 2'), ('1129', 'Library 2'), ('1130', 'Mini Library Hostel'), ('2099', 'Library Temporary'), ('2811', 'Research Park');


SELECT * FROM Contact_number INNER JOIN Phone ON Contact_number.Work = Phone.Work;

SELECT * FROM Contact_number INNER JOIN Phone ON Contact_number.Work = Phone.Work
INNER JOIN Students ON Contact_number.Roll_number = Students.Roll_number;

SELECT Contact_number.Roll_number, Students.First_name, Students.Middle_name, Students.Last_name,  
	Students.Email_id, Students.Discipline, Students.Program, Contact_number.Work
FROM Contact_number INNER JOIN Phone ON Contact_number.Work = Phone.Work
INNER JOIN Students ON Contact_number.Roll_number = Students.Roll_number;

SELECT * FROM Contact_number NATURAL JOIN Phone;
SELECT * FROM Contact_number right JOIN Phone ON Contact_number.Work = Phone.Work;

insert into Contact_info(Work, Facility_name)
values ('1159', 'Los An');

insert into NTeaching_staff (Staff_ID, F_name, M_name, L_name, EmailID)
VALUES ('j1', 'Rock', 'Duke', 'Johanson', 'don.plackal@iitgn.ac.in');

insert into Students(Roll_number, First_name, Middle_name, Last_name, Email_id, Discipline, Program)
VALUES (252, 'Vinay', 'Amit', 'Mappa', 'mappavinay@iitgn.ac.in', 'Mechanical Engineering', 'Btech');

select * from Students;

-- safe updates is made 0 to delete entries else can't raises an error.
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Students WHERE Roll_number = 252;
SET SQL_SAFE_UPDATES = 1;

SELECT Contact_number.Roll_number, Students.First_name, Students.Middle_name, Students.Last_name,  
	Students.Email_id, Students.Discipline, Students.Program, Contact_number.Work
FROM Contact_number NATURAL JOIN Phone NATURAL JOIN Students;

SELECT * FROM Contact_number WHERE Roll_number LIKE '20__%';

SELECT COUNT(*) AS num_matching_roll_numbers
FROM Contact_number WHERE Roll_number LIKE '20__%';

/* 
	Function to populate the table Teaching_staff with random data
*/
DELIMITER $$
CREATE PROCEDURE Populate_teachers(IN start_num INT, IN num_records INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < num_records DO
        INSERT INTO Teaching_staff (Faculty_ID, FirstName, MiddleName, LastName, Email)
		VALUES 
            (CONCAT(start_num + i), CONCAT('First_name_', i), 'Middle_random', 'Last_random', CONCAT('email', start_num + i, '@example.com'));
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

-- DROP PROCEDURE Populate_teachers;

CALL Populate_teachers(1, 1000);
CALL Populate_teachers(1005, 8000);

-- drop index to compare time taken before and after
DROP INDEX first_last_idx1 ON Teaching_staff; 
SET PROFILING =1;
SELECT * FROM Teaching_staff where FirstName = 'First_name_1582';
SHOW profile;

-- To get time taken with indexing

CREATE INDEX first_last_idx1 ON Teaching_staff(FirstName, LastName);
SELECT * FROM Teaching_staff where FirstName = 'First_name_1582';
SHOW profile;

SET @my_str= 'Hello, World!'; 
SELECT @my_str;
INSERT INTO Teaching_staff (Faculty_ID, FirstName, MiddleName, LastName, Email) VALUES 
            ('asd', CONCAT(@my_str, 24), NULL, 'Last_random', '@example.com');
SELECT * FROM Teaching_staff WHERE Email = '@example.com';
SHOW VARIABLES LIKE 'default_storage_engine';

-- drop database octacore;


-- GROUP 2 responsibility work starts from here....

use octacore;

-- creating an user
create user 'user1' identified by 'password1';

-- Creating View 1
CREATE VIEW view1 AS
SELECT f.Facility_name, f.RoomNumber, f.BuildingName, ci.Work, ci.Facility_name AS additional_column
FROM Facility f
JOIN Contact_info ci ON f.Facility_name = ci.Facility_name;

-- Creating View 2
CREATE VIEW view2 AS
SELECT ts.Faculty_ID, ts.FirstName, ts.LastName, s.Roll_number, s.First_name, s.Last_name, 'ExampleDataType' AS additional_column
FROM Teaching_staff ts
JOIN Students s ON ts.Faculty_ID = SUBSTRING(s.Roll_number, 1, 10);

show grants for user1;

grant select, update, delete on octacore.facility to 'user1';
show grants for user1;

grant select on view1 to 'user1';
show grants for user1;

select * from octacore.facility;

-- goto user1 after running till here

-- come here to revoke and run below code

revoke update, delete on octacore.facility from user1;

-- image storing part of the assignment

SELECT CONCAT_WS(' ', ts.FirstName, ts.MiddleName, ts.LastName) AS Name,
       jd.Designation AS Designation,
       ts.Email AS Email,
       jd.Discipline_name AS Discipline_Section,
       p.Work AS Work,
       CONCAT_WS('/', IFNULL(p.Home, ''), IFNULL(p.Emergency, '')) AS Home_Emerg,
       CONCAT_WS('/', jd.Building, jd.Room_number) AS Office
FROM Teaching_staff ts
JOIN Specialization s ON ts.Faculty_ID = s.Faculty_ID
JOIN Job_desc jd ON s.Discipline_name = jd.Discipline_name
JOIN Contact c ON ts.Faculty_ID = c.Faculty_ID
JOIN Phone p ON c.Work = p.Work
AND s.Designation = jd.Designation
AND s.Room_number = jd.Room_number
AND s.Building = jd.Building;

SELECT CONCAT_WS(' ', nts.F_name, nts.M_name, nts.L_name) AS Name,
       jd.Designation AS Designation,
       nts.EmailID AS Email,
       jd.Discipline_name AS Discipline_Section,
       p.Work AS Work,
       CONCAT_WS('/', IFNULL(p.Home, ''), IFNULL(p.Emergency, '')) AS Home_Emerg,
       CONCAT_WS('/', jd.Building, jd.Room_number) AS Office
FROM NTeaching_staff nts
JOIN Work_info s ON nts.Staff_ID = s.Staff_ID
JOIN Job_desc jd ON s.Discipline_name = jd.Discipline_name
JOIN Contact_enquiry c ON nts.Staff_ID = c.Staff_ID
JOIN Phone p ON c.Work = p.Work
AND s.Designation = jd.Designation
AND s.Room_number = jd.Room_number
AND s.Building = jd.Building;

SELECT CONCAT_WS(' ', st.First_name, st.Middle_name, st.Last_name) AS Name,
       st.Program AS Designation,
       st.Email_id AS Email,
       st.Discipline AS Discipline_Section,
       p.Work AS Work,
       CONCAT_WS('/', IFNULL(p.Home, ''), IFNULL(p.Emergency, '')) AS Home_Emerg,
       CONCAT_WS('/',' ') AS Office
FROM Students st
JOIN Contact_number c ON st.Roll_number = c.Roll_number
JOIN Phone p ON c.Work = p.Work;

SELECT CONCAT_WS(' ', f.Facility_name) AS Name,
       ' ' AS Designation,
       f.Email_addr AS Email,
       ' ' AS Discipline_Section,
       p.Work AS Work,
       CONCAT_WS('/', IFNULL(p.Home, ''), IFNULL(p.Emergency, '')) AS Home_Emerg,
       CONCAT_WS('/', f.BuildingName, f.RoomNumber) AS Office
FROM Contact_info ci
JOIN Facility f ON ci.Facility_name = f.Facility_name
JOIN Phone p ON ci.Work = p.Work;

SELECT b.Block_name AS Name,
       ' ' AS Designation,
		' ' AS Email,
       ' ' AS Discipline_Section,
       p.Work AS Work,
       CONCAT_WS('/', IFNULL(p.Home, ''), IFNULL(p.Emergency, '')) AS Home_Emerg,
       ' '  AS Office
FROM To_Contact c
JOIN Block b ON c.Block_name = b.Block_name
JOIN Phone p ON c.Work = p.Work;

select * from Students;
select * from Phone;
select * from contact_number;