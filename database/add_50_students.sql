-- Add 50 More Students to School Fee Register Database
-- This script adds 50 additional students with diverse data

USE school_fee_register;

-- Insert 50 additional students
INSERT INTO students (student_id, first_name, last_name, date_of_birth, gender, address, phone, email, parent_name, parent_phone, parent_email, class_id, academic_year_id, admission_date, is_active) VALUES

-- Class 1 Students (11-20)
('STU011', 'Ethan', 'Martinez', '2015-02-14', 'MALE', '159 River Road, Lakeside', '+1234567910', 'ethan.martinez@email.com', 'Carlos Martinez', '+1234567911', 'carlos.martinez@email.com', 1, 1, '2024-06-01', TRUE),
('STU012', 'Mia', 'Garcia', '2015-04-28', 'FEMALE', '753 Sunset Boulevard, Westend', '+1234567912', 'mia.garcia@email.com', 'Maria Garcia', '+1234567913', 'maria.garcia@email.com', 1, 1, '2024-06-01', TRUE),
('STU013', 'Alexander', 'Rodriguez', '2015-01-03', 'MALE', '951 Mountain View, Highland', '+1234567914', 'alexander.rodriguez@email.com', 'Jose Rodriguez', '+1234567915', 'jose.rodriguez@email.com', 1, 1, '2024-06-01', TRUE),
('STU014', 'Charlotte', 'Lee', '2015-06-19', 'FEMALE', '357 Ocean Drive, Coastal', '+1234567916', 'charlotte.lee@email.com', 'David Lee', '+1234567917', 'david.lee@email.com', 1, 1, '2024-06-01', TRUE),
('STU015', 'Daniel', 'Gonzalez', '2015-09-11', 'MALE', '486 Forest Lane, Woodland', '+1234567918', 'daniel.gonzalez@email.com', 'Roberto Gonzalez', '+1234567919', 'roberto.gonzalez@email.com', 1, 1, '2024-06-01', TRUE),

-- Class 2 Students (21-30)
('STU016', 'Harper', 'Perez', '2014-03-25', 'FEMALE', '264 Valley Street, Meadow', '+1234567920', 'harper.perez@email.com', 'Luis Perez', '+1234567921', 'luis.perez@email.com', 2, 1, '2024-06-01', TRUE),
('STU017', 'Sebastian', 'Turner', '2014-07-08', 'MALE', '837 Hillcrest Avenue, Summit', '+1234567922', 'sebastian.turner@email.com', 'Richard Turner', '+1234567923', 'richard.turner@email.com', 2, 1, '2024-06-01', TRUE),
('STU018', 'Evelyn', 'Phillips', '2014-11-30', 'FEMALE', '593 Garden Court, Bloomfield', '+1234567924', 'evelyn.phillips@email.com', 'Thomas Phillips', '+1234567925', 'thomas.phillips@email.com', 2, 1, '2024-06-01', TRUE),
('STU019', 'Jack', 'Campbell', '2014-05-17', 'MALE', '741 Brookside Road, Streamside', '+1234567926', 'jack.campbell@email.com', 'Kevin Campbell', '+1234567927', 'kevin.campbell@email.com', 2, 1, '2024-06-01', TRUE),
('STU020', 'Abigail', 'Parker', '2014-08-22', 'FEMALE', '925 Lakeshore Drive, Waterside', '+1234567928', 'abigail.parker@email.com', 'Steven Parker', '+1234567929', 'steven.parker@email.com', 2, 1, '2024-06-01', TRUE),

-- Class 3 Students (31-40)
('STU021', 'Owen', 'Evans', '2013-12-05', 'MALE', '183 Park Avenue, Greenfield', '+1234567930', 'owen.evans@email.com', 'Brian Evans', '+1234567931', 'brian.evans@email.com', 3, 1, '2024-06-01', TRUE),
('STU022', 'Emily', 'Edwards', '2013-02-18', 'FEMALE', '472 College Street, University', '+1234567932', 'emily.edwards@email.com', 'Gary Edwards', '+1234567933', 'gary.edwards@email.com', 3, 1, '2024-06-01', TRUE),
('STU023', 'Dylan', 'Collins', '2013-06-29', 'MALE', '639 Washington Road, Capitol', '+1234567934', 'dylan.collins@email.com', 'Timothy Collins', '+1234567935', 'timothy.collins@email.com', 3, 1, '2024-06-01', TRUE),
('STU024', 'Elizabeth', 'Stewart', '2013-10-14', 'FEMALE', '851 Jefferson Lane, Liberty', '+1234567936', 'elizabeth.stewart@email.com', 'Ronald Stewart', '+1234567937', 'ronald.stewart@email.com', 3, 1, '2024-06-01', TRUE),
('STU025', 'Nathan', 'Sanchez', '2013-04-07', 'MALE', '294 Lincoln Way, Heritage', '+1234567938', 'nathan.sanchez@email.com', 'Miguel Sanchez', '+1234567939', 'miguel.sanchez@email.com', 3, 1, '2024-06-01', TRUE),

-- Class 4 Students (41-50)
('STU026', 'Sofia', 'Morris', '2012-01-23', 'FEMALE', '756 Roosevelt Drive, Progress', '+1234567940', 'sofia.morris@email.com', 'Jeffrey Morris', '+1234567941', 'jeffrey.morris@email.com', 4, 1, '2024-06-01', TRUE),
('STU027', 'Isaac', 'Rogers', '2012-07-16', 'MALE', '418 Kennedy Boulevard, Memorial', '+1234567942', 'isaac.rogers@email.com', 'Scott Rogers', '+1234567943', 'scott.rogers@email.com', 4, 1, '2024-06-01', TRUE),
('STU028', 'Avery', 'Reed', '2012-11-09', 'FEMALE', '583 Johnson Street, Legacy', '+1234567944', 'avery.reed@email.com', 'Eric Reed', '+1234567945', 'eric.reed@email.com', 4, 1, '2024-06-01', TRUE),
('STU029', 'Luke', 'Cook', '2012-03-31', 'MALE', '927 Davis Avenue, Tradition', '+1234567946', 'luke.cook@email.com', 'Stephen Cook', '+1234567947', 'stephen.cook@email.com', 4, 1, '2024-06-01', TRUE),
('STU030', 'Ella', 'Morgan', '2012-09-12', 'FEMALE', '365 Wilson Road, Future', '+1234567948', 'ella.morgan@email.com', 'Andrew Morgan', '+1234567949', 'andrew.morgan@email.com', 4, 1, '2024-06-01', TRUE),

-- Class 5 Students (51-60)
('STU031', 'Carter', 'Bell', '2011-05-26', 'MALE', '148 Murphy Lane, Innovation', '+1234567950', 'carter.bell@email.com', 'Raymond Bell', '+1234567951', 'raymond.bell@email.com', 5, 1, '2024-06-01', TRUE),
('STU032', 'Madison', 'Murphy', '2011-12-03', 'FEMALE', '672 Bailey Street, Discovery', '+1234567952', 'madison.murphy@email.com', 'Patrick Murphy', '+1234567953', 'patrick.murphy@email.com', 5, 1, '2024-06-01', TRUE),
('STU033', 'Julian', 'Richardson', '2011-08-19', 'MALE', '835 Cox Avenue, Exploration', '+1234567954', 'julian.richardson@email.com', 'Sean Richardson', '+1234567955', 'sean.richardson@email.com', 5, 1, '2024-06-01', TRUE),
('STU034', 'Scarlett', 'Cox', '2011-01-15', 'FEMALE', '491 Howard Drive, Adventure', '+1234567956', 'scarlett.cox@email.com', 'Keith Cox', '+1234567957', 'keith.cox@email.com', 5, 1, '2024-06-01', TRUE),
('STU035', 'Aaron', 'Ward', '2011-06-28', 'MALE', '723 Torres Road, Journey', '+1234567958', 'aaron.ward@email.com', 'Lawrence Ward', '+1234567959', 'lawrence.ward@email.com', 5, 1, '2024-06-01', TRUE),

-- Class 6 Students (61-70)
('STU036', 'Victoria', 'Torres', '2010-04-11', 'FEMALE', '156 Peterson Lane, Horizon', '+1234567960', 'victoria.torres@email.com', 'Juan Torres', '+1234567961', 'juan.torres@email.com', 6, 1, '2024-06-01', TRUE),
('STU037', 'Adrian', 'Gray', '2010-10-24', 'MALE', '384 James Street, Vision', '+1234567962', 'adrian.gray@email.com', 'Peter Gray', '+1234567963', 'peter.gray@email.com', 6, 1, '2024-06-01', TRUE),
('STU038', 'Luna', 'Ramirez', '2010-07-07', 'FEMALE', '597 Brooks Avenue, Dream', '+1234567964', 'luna.ramirez@email.com', 'Antonio Ramirez', '+1234567965', 'antonio.ramirez@email.com', 6, 1, '2024-06-01', TRUE),
('STU039', 'Leo', 'James', '2010-02-20', 'MALE', '941 Kelly Drive, Hope', '+1234567966', 'leo.james@email.com', 'Henry James', '+1234567967', 'henry.james@email.com', 6, 1, '2024-06-01', TRUE),
('STU040', 'Grace', 'Watson', '2010-11-13', 'FEMALE', '275 Sanders Road, Faith', '+1234567968', 'grace.watson@email.com', 'Douglas Watson', '+1234567969', 'douglas.watson@email.com', 6, 1, '2024-06-01', TRUE),

-- Class 7 Students (71-80)
('STU041', 'Hudson', 'Brooks', '2009-03-08', 'MALE', '638 Price Lane, Wisdom', '+1234567970', 'hudson.brooks@email.com', 'Ralph Brooks', '+1234567971', 'ralph.brooks@email.com', 7, 1, '2024-06-01', TRUE),
('STU042', 'Chloe', 'Kelly', '2009-09-21', 'FEMALE', '459 Bennett Street, Knowledge', '+1234567972', 'chloe.kelly@email.com', 'Roy Kelly', '+1234567973', 'roy.kelly@email.com', 7, 1, '2024-06-01', TRUE),
('STU043', 'Eli', 'Sanders', '2009-05-04', 'MALE', '782 Wood Avenue, Learning', '+1234567974', 'eli.sanders@email.com', 'Bobby Sanders', '+1234567975', 'bobby.sanders@email.com', 7, 1, '2024-06-01', TRUE),
('STU044', 'Penelope', 'Price', '2009-12-17', 'FEMALE', '315 Barnes Drive, Education', '+1234567976', 'penelope.price@email.com', 'Johnny Price', '+1234567977', 'johnny.price@email.com', 7, 1, '2024-06-01', TRUE),
('STU045', 'Liam', 'Bennett', '2009-08-30', 'MALE', '847 Ross Road, Growth', '+1234567978', 'liam.bennett@email.com', 'Danny Bennett', '+1234567979', 'danny.bennett@email.com', 7, 1, '2024-06-01', TRUE),

-- Class 8 Students (81-90)
('STU046', 'Layla', 'Wood', '2008-01-25', 'FEMALE', '192 Henderson Lane, Success', '+1234567980', 'layla.wood@email.com', 'Russell Wood', '+1234567981', 'russell.wood@email.com', 8, 1, '2024-06-01', TRUE),
('STU047', 'Nora', 'Barnes', '2008-06-18', 'FEMALE', '534 Coleman Street, Achievement', '+1234567982', 'nora.barnes@email.com', 'Louis Barnes', '+1234567983', 'louis.barnes@email.com', 8, 1, '2024-06-01', TRUE),
('STU048', 'Mason', 'Ross', '2008-11-01', 'MALE', '761 Jenkins Avenue, Excellence', '+1234567984', 'mason.ross@email.com', 'Philip Ross', '+1234567985', 'philip.ross@email.com', 8, 1, '2024-06-01', TRUE),
('STU049', 'Riley', 'Henderson', '2008-04-14', 'FEMALE', '293 Perry Drive, Victory', '+1234567986', 'riley.henderson@email.com', 'Jimmy Henderson', '+1234567987', 'jimmy.henderson@email.com', 8, 1, '2024-06-01', TRUE),
('STU050', 'Lucas', 'Coleman', '2008-09-27', 'MALE', '618 Long Road, Triumph', '+1234567988', 'lucas.coleman@email.com', 'Albert Coleman', '+1234567989', 'albert.coleman@email.com', 8, 1, '2024-06-01', TRUE),

-- Class 9 Students (91-100)
('STU051', 'Zoe', 'Jenkins', '2007-02-10', 'FEMALE', '945 Perry Street, Leadership', '+1234567990', 'zoe.jenkins@email.com', 'Joe Jenkins', '+1234567991', 'joe.jenkins@email.com', 9, 1, '2024-06-01', TRUE),
('STU052', 'Miles', 'Perry', '2007-07-23', 'MALE', '276 Powell Avenue, Courage', '+1234567992', 'miles.perry@email.com', 'Tommy Perry', '+1234567993', 'tommy.perry@email.com', 9, 1, '2024-06-01', TRUE),
('STU053', 'Hazel', 'Long', '2007-12-06', 'FEMALE', '583 Hughes Drive, Strength', '+1234567994', 'hazel.long@email.com', 'Fred Long', '+1234567995', 'fred.long@email.com', 9, 1, '2024-06-01', TRUE),
('STU054', 'Theo', 'Powell', '2007-05-19', 'MALE', '816 Flores Road, Honor', '+1234567996', 'theo.powell@email.com', 'Wayne Powell', '+1234567997', 'wayne.powell@email.com', 9, 1, '2024-06-01', TRUE),
('STU055', 'Violet', 'Hughes', '2007-10-02', 'FEMALE', '147 Butler Lane, Integrity', '+1234567998', 'violet.hughes@email.com', 'Alan Hughes', '+1234567999', 'alan.hughes@email.com', 9, 1, '2024-06-01', TRUE),

-- Class 10 Students (101-110)
('STU056', 'Felix', 'Flores', '2006-03-15', 'MALE', '369 Simmons Street, Character', '+1234568000', 'felix.flores@email.com', 'Juan Flores', '+1234568001', 'juan.flores@email.com', 10, 1, '2024-06-01', TRUE),
('STU057', 'Aria', 'Butler', '2006-08-28', 'FEMALE', '592 Foster Avenue, Dignity', '+1234568002', 'aria.butler@email.com', 'Bruce Butler', '+1234568003', 'bruce.butler@email.com', 10, 1, '2024-06-01', TRUE),
('STU058', 'Kai', 'Simmons', '2006-01-11', 'MALE', '825 Gonzales Drive, Respect', '+1234568004', 'kai.simmons@email.com', 'Willie Simmons', '+1234568005', 'willie.simmons@email.com', 10, 1, '2024-06-01', TRUE),
('STU059', 'Lily', 'Foster', '2006-06-24', 'FEMALE', '158 Bryant Road, Compassion', '+1234568006', 'lily.foster@email.com', 'Jordan Foster', '+1234568007', 'jordan.foster@email.com', 10, 1, '2024-06-01', TRUE),
('STU060', 'Axel', 'Gonzales', '2006-11-07', 'MALE', '741 Alexander Lane, Kindness', '+1234568008', 'axel.gonzales@email.com', 'Oscar Gonzales', '+1234568009', 'oscar.gonzales@email.com', 10, 1, '2024-06-01', TRUE);

-- Add corresponding parent users for the new students
INSERT INTO users (username, email, password, role, first_name, last_name, phone, is_active) VALUES
-- Parents for Class 1 students
('parent11', 'carlos.martinez@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Carlos', 'Martinez', '1234567910', TRUE),
('parent12', 'maria.garcia@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Maria', 'Garcia', '1234567912', TRUE),
('parent13', 'jose.rodriguez@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Jose', 'Rodriguez', '1234567914', TRUE),
('parent14', 'david.lee@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'David', 'Lee', '1234567916', TRUE),
('parent15', 'roberto.gonzalez@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Roberto', 'Gonzalez', '1234567918', TRUE),

-- Parents for Class 2 students
('parent16', 'luis.perez@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Luis', 'Perez', '1234567920', TRUE),
('parent17', 'richard.turner@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Richard', 'Turner', '1234567922', TRUE),
('parent18', 'thomas.phillips@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Thomas', 'Phillips', '1234567924', TRUE),
('parent19', 'kevin.campbell@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Kevin', 'Campbell', '1234567926', TRUE),
('parent20', 'steven.parker@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Steven', 'Parker', '1234567928', TRUE),

-- Parents for Class 3 students
('parent21', 'brian.evans@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Brian', 'Evans', '1234567930', TRUE),
('parent22', 'gary.edwards@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Gary', 'Edwards', '1234567932', TRUE),
('parent23', 'timothy.collins@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Timothy', 'Collins', '1234567934', TRUE),
('parent24', 'ronald.stewart@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Ronald', 'Stewart', '1234567936', TRUE),
('parent25', 'miguel.sanchez@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Miguel', 'Sanchez', '1234567938', TRUE),

-- Parents for Class 4 students
('parent26', 'jeffrey.morris@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Jeffrey', 'Morris', '1234567940', TRUE),
('parent27', 'scott.rogers@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Scott', 'Rogers', '1234567942', TRUE),
('parent28', 'eric.reed@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Eric', 'Reed', '1234567944', TRUE),
('parent29', 'stephen.cook@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Stephen', 'Cook', '1234567946', TRUE),
('parent30', 'andrew.morgan@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Andrew', 'Morgan', '1234567948', TRUE),

-- Parents for Class 5 students
('parent31', 'raymond.bell@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Raymond', 'Bell', '1234567950', TRUE),
('parent32', 'patrick.murphy@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Patrick', 'Murphy', '1234567952', TRUE),
('parent33', 'sean.richardson@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Sean', 'Richardson', '1234567954', TRUE),
('parent34', 'keith.cox@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Keith', 'Cox', '1234567956', TRUE),
('parent35', 'lawrence.ward@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Lawrence', 'Ward', '1234567958', TRUE),

-- Parents for Class 6 students
('parent36', 'juan.torres@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Juan', 'Torres', '1234567960', TRUE),
('parent37', 'peter.gray@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Peter', 'Gray', '1234567962', TRUE),
('parent38', 'antonio.ramirez@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Antonio', 'Ramirez', '1234567964', TRUE),
('parent39', 'henry.james@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Henry', 'James', '1234567966', TRUE),
('parent40', 'douglas.watson@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Douglas', 'Watson', '1234567968', TRUE),

-- Parents for Class 7 students
('parent41', 'ralph.brooks@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Ralph', 'Brooks', '1234567970', TRUE),
('parent42', 'roy.kelly@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Roy', 'Kelly', '1234567972', TRUE),
('parent43', 'bobby.sanders@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Bobby', 'Sanders', '1234567974', TRUE),
('parent44', 'johnny.price@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Johnny', 'Price', '1234567976', TRUE),
('parent45', 'danny.bennett@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Danny', 'Bennett', '1234567978', TRUE),

-- Parents for Class 8 students
('parent46', 'russell.wood@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Russell', 'Wood', '1234567980', TRUE),
('parent47', 'louis.barnes@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Louis', 'Barnes', '1234567982', TRUE),
('parent48', 'philip.ross@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Philip', 'Ross', '1234567984', TRUE),
('parent49', 'jimmy.henderson@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Jimmy', 'Henderson', '1234567986', TRUE),
('parent50', 'albert.coleman@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Albert', 'Coleman', '1234567988', TRUE),

-- Parents for Class 9 students
('parent51', 'joe.jenkins@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Joe', 'Jenkins', '1234567990', TRUE),
('parent52', 'tommy.perry@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Tommy', 'Perry', '1234567992', TRUE),
('parent53', 'fred.long@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Fred', 'Long', '1234567994', TRUE),
('parent54', 'wayne.powell@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Wayne', 'Powell', '1234567996', TRUE),
('parent55', 'alan.hughes@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Alan', 'Hughes', '1234567998', TRUE),

-- Parents for Class 10 students
('parent56', 'juan.flores@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Juan', 'Flores', '1234568000', TRUE),
('parent57', 'bruce.butler@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Bruce', 'Butler', '1234568002', TRUE),
('parent58', 'willie.simmons@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Willie', 'Simmons', '1234568004', TRUE),
('parent59', 'jordan.foster@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Jordan', 'Foster', '1234568006', TRUE),
('parent60', 'oscar.gonzales@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Oscar', 'Gonzales', '1234568008', TRUE);

-- Display summary
SELECT 
    'Students added successfully!' as message,
    COUNT(*) as total_students,
    'Now you have ' || COUNT(*) || ' students in the database' as summary
FROM students;

-- Show distribution by class
SELECT 
    c.class_name,
    COUNT(s.id) as student_count
FROM classes c
LEFT JOIN students s ON c.id = s.class_id
GROUP BY c.id, c.class_name
ORDER BY c.class_level; 