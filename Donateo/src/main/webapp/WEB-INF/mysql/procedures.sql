DELIMITER //

CREATE PROCEDURE logIn(IN email VARCHAR(100),IN pass VARCHAR(40), 
OUT type VARCHAR(10), OUT success_msg VARCHAR(100))
BEGIN
DECLARE u_id INT;
DECLARE NGO_id INT;

IF EXISTS (SELECT *  FROM Users
		   where Users.user_email = email && Users.password=pass ) 
THEN
	SET type = 'user';
	SELECT type;
	SET success_msg = 'LOGGED IN';
	SELECT Users.user_id INTO u_id FROM Users WHERE Users.user_email = email && Users.password = pass;
	UPDATE Sessions
	SET Sessions.last_login = NOW() , logged_in = 1
	WHERE Sessions.user_id = u_id;
ELSE
	IF EXISTS (SELECT *  FROM NGOs
			   where NGOs.ngo_email = email && NGOs.password=pass ) 
	THEN
		SET type = 'NGO';
		SELECT type;
		SET success_msg = 'LOGGED IN';
		SELECT NGOs.ngo_id INTO NGO_id FROM NGOs WHERE NGOs.ngo_email = email && NGOs.password = pass;
		UPDATE Sessions
		SET Sessions.last_login = NOW() , logged_in = 1
		WHERE Sessions.ngo_id = NGO_id;
	ELSE
		SET success_msg = 'EMAIL OR PASSWORD IS WRONG';
		SELECT success_msg;
	END IF;
END IF;
END //


CREATE PROCEDURE addCategoryToProject(IN p_id INT, IN c_id INT)
BEGIN
INSERT INTO Project_Categories(project_id,category_id)
VALUES (p_id,c_id);
END //



CREATE PROCEDURE logOut(id INT, type VARCHAR(10))
BEGIN
	IF (type = 'user')
	THEN
		UPDATE Sessions
		SET Sessions.logged_in = 0
		WHERE Sessions.user_id = id;
	ELSE 
		UPDATE Sessions
		SET Sessions.logged_in = 0
		WHERE Sessions.ngo_id = id;
	END IF;
		
END//








-- ************************ MARINA ************************
-- 1
CREATE PROCEDURE UserRegister(email VARCHAR(100),pass VARCHAR(40),
name VARCHAR(40),address VARCHAR(140),phone VARCHAR(50),
OUT success_msg VARCHAR(40))

BEGIN
	IF EXISTS(SELECT user_email,password FROM Users
			  WHERE user_email = email && password = pass) 
			  
	THEN 
		SET success_msg = 'EMAIL OR PASSWORD ALREADY EXISTS';
		SELECT success_msg;
    ELSE 
		IF EXISTS(SELECT user_name FROM Users
				  WHERE user_name = name)
		THEN 
			SET success_msg = 'USER NAME ALREADY EXISTS';
			SELECT success_msg;

			ELSE
				IF((Select Length(pass)) <= 8)
				THEN
					SET success_msg = 'PASSWORD SHOULD BE LONGER THAN 8';
			        SELECT success_msg;
				ELSE
					INSERT INTO Users(user_email,password,user_name ,
					address,phone) 
					VALUES (email,pass,name,address,phone);
					INSERT INTO Sessions(user_id,ngo_id,last_login,
					expiry_login,logged_in)
					VALUES(LAST_INSERT_ID(),null,NOW(),null,1);
					SET success_msg = 'YOU HAVE SUCCESSFULLY REGISTERED';
					SELECT success_msg;
			END IF;
		END IF;

	END IF;
END//


-- 2
CREATE PROCEDURE AccountExists(email VARCHAR(100),pass VARCHAR(40),
OUT success_msg VARCHAR(40))
BEGIN
	IF EXISTS (SELECT * FROM Users where  email = user_email 
		&& pass=password )
	THEN

		SELECT * FROM Users where  email = user_email 
		&& pass=password;  
		
	ELSE 
		IF EXISTS (SELECT * FROM NGOs where  email = ngo_email 
		&& pass=password )
		THEN

			SELECT * FROM NGOs where  email = ngo_email 
			&& pass=password;
			
		ELSE
			SET success_msg = 'YOU HAVE NOT REGISTERED YET';
			SELECT success_msg;
		END IF;
	END IF;
END//
-- -----------------------EXTRA---------------------------------
CREATE PROCEDURE getProject(id INT,OUT success_msg VARCHAR(40))
BEGIN
IF EXISTS(SELECT * FROM Projects WHERE project_id = id)
	THEN 
		SELECT * FROM Projects WHERE project_id = id;
	ELSE
		SET success_msg = 'THIS PROJECT DOES NOT EXIST';
		SELECT success_msg;
END IF;
END//


CREATE PROCEDURE addObjectToProject(pID INT, objName VARCHAR(40),
objQuantity INT,OUT success_msg VARCHAR(40))
BEGIN
IF EXISTS(SELECT Projects.project_id FROM PROJECTS 
		  WHERE Projects.project_id = pID)
THEN
	INSERT INTO Objects(project_id,object_name,quantity,collected_quantity)
	VALUES (pID,objName,objQuantity,0);
	SET success_msg = 'YOU HAVE INSERTED THE OBJECT';
	SELECT success_msg;
ELSE
	SET success_msg = 'THIS PROJECT DOES NOT EXIST';
	SELECT success_msg;
END IF;
END//

CREATE PROCEDURE  getCategoryId(categoryName VARCHAR(40),
				  OUT success_msg VARCHAR(100))
BEGIN
IF EXISTS (SELECT category_id FROM Category 
			WHERE category_name = categoryName)
THEN
	SELECT category_id INTO success_msg FROM Category 
	WHERE category_name = categoryName;
	SELECT success_msg;
ELSE
	SET success_msg = 'This Category does not exist';
	SELECT success_msg;
END IF;
END//

CREATE PROCEDURE getType(IN email VARCHAR(100), OUT type VARCHAR(10))
BEGIN
IF exists (SELECT U.user_email
FROM Users U
WHERE U.user_email = email)
THEN SET type = 'user';
ELSEIF exists (SELECT N.ngo_email
FROM NGOs N
WHERE N.ngo_email = email)
THEN SET type = 'ngo';
ELSEIF exists (SELECT A.admin_email
FROM Admins A
WHERE A.admin_email = email)
THEN SET type = 'admin';
ELSE SET type = 'not exist';
END IF;
SELECT type;
END //

CREATE PROCEDURE getUserId(IN u_email VARCHAR(100), OUT id INT, OUT output_msg VARCHAR(50))
BEGIN
IF EXISTS (SELECT * 
		   FROM Users U 
		   where U.user_email=u_email)
THEN SELECT U.user_id INTO id
	 FROM Users U 
	 where U.user_email=u_email;
	 SELECT id;
ELSE SET output_msg = 'no such user';
	 SELECT output_msg;
END IF;
END//

CREATE PROCEDURE createCase(IN NGO_id INT,IN urg_id INT,IN p_name varchar(40),
IN p_description varchar(200),IN p_location varchar(100),IN p_deadline date,
IN isVolunteer bit,IN isMoney bit,IN isObject bit,IN p_amount INT, OUT p_id INT, OUT output_msg VARCHAR(50))
BEGIN
SET output_msg = '';
SET p_id = -1;
IF EXISTS (SELECT P.project_name
		   FROM Projects P
		   WHERE P.project_name = p_name)
THEN SET output_msg = 'Project name exist';
ELSE INSERT INTO Projects(ngo_id,urgency_id,project_name,description,location,deadline,volunteer,
				donate_money,donate_object,amount,collected_amount,start_date,done)
	 VALUES(NGO_id,urg_id,p_name,p_description,p_location,p_deadline,isVolunteer,
			isMoney,isObject,p_amount,0,now(),0);
	 INSERT INTO Cases(project_id) VALUES (LAST_INSERT_ID());
	 SET p_id = LAST_INSERT_ID(); 
END IF;
SELECT p_id,output_msg;
END //

CREATE PROCEDURE listFollowedProjects(user_id INT,OUT success_msg VARCHAR(40))
BEGIN
IF EXISTS
	(SELECT * FROM User_Follow_Project
	WHERE user_id = User_Follow_Project.user_id)
THEN
	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date
	FROM Projects
	RIGHT JOIN User_Follow_Project 
	on Projects.project_id = User_Follow_Project.project_id
	WHERE user_id = User_Follow_Project.user_id;
ELSE
	SET success_msg = 'YOU ARE NOT FOLLOWING ANY PROJECTS';
	SELECT success_msg;
END IF;

END//

CREATE PROCEDURE createCampaign(IN NGO_id INT,IN urg_id INT,IN p_name varchar(40),
IN p_description varchar(200),IN p_location varchar(100),IN p_start_date date, IN p_deadline date,
IN isVolunteer bit,IN isMoney bit,IN isObject bit,IN p_amount INT, OUT p_id INT, OUT output_msg VARCHAR(50))
BEGIN
SET output_msg = '';
SET p_id = -1;
IF EXISTS (SELECT P.project_name
		   FROM Projects P
		   WHERE P.project_name = p_name)
THEN SET output_msg = 'Project name exist';
ELSE INSERT INTO Projects(ngo_id,urgency_id,project_name,description,location,deadline,volunteer,
				donate_money,donate_object,amount,collected_amount,start_date,done)
	 VALUES(NGO_id,urg_id,p_name,p_description,p_location,p_deadline,isVolunteer,
			isMoney,isObject,p_amount,0,p_start_date,0);
	 INSERT INTO Campaigns(project_id,num_attending_members) VALUES (LAST_INSERT_ID(), 0);
	 SET p_id = LAST_INSERT_ID(); 
END IF;
SELECT p_id,output_msg;
END //

CREATE PROCEDURE listSuggestedProjects(IN NGO_id INT, OUT output_msg VARCHAR(100))
BEGIN
DECLARE currentDate date;
DECLARE count INT;
SET currentDate = NOW();

SELECT count(*) INTO count
FROM Projects P JOIN Crowdfundings C
WHERE P.project_id = C.project_id AND P.ngo_id = NGO_id;

IF (count>0)
THEN SET output_msg = '';
	 SELECT P.*, U.user_email,U.user_name
	 FROM (Projects P JOIN Crowdfundings C) JOIN Users U
	 WHERE P.project_id = C.project_id AND P.ngo_id = NGO_id AND C.user_id = U.user_id AND C.verified = 0 AND 
	       currentDate>= P.start_date AND currentDate <= P.deadline;
ELSE SET output_msg = 'No suggested projects';
	 SELECT output_msg;
END IF;
END //

CREATE PROCEDURE listprojectsOnGoingProjects(IN NGO_id INT, OUT output_msg VARCHAR(100))
BEGIN
DECLARE count INT;

SELECT count(*) INTO count
FROM Projects P
WHERE P.ngo_id = NGO_id AND P.done = 1 AND P.completed = 0;

IF (count>0)
THEN SET output_msg = '';
	 SELECT P.*
	 FROM Projects P
	 WHERE P.ngo_id = NGO_id AND P.done = 1 AND P.completed = 0;
ELSE SET output_msg = 'No on-going projects';
	 SELECT output_msg;
END IF;
END //

CREATE PROCEDURE listSuccessStories(OUT output_msg VARCHAR(100))
BEGIN
DECLARE count INT;
DECLARE output_msg VARCHAR(100);

SELECT count(*) INTO count
FROM NGO_DeclareSuccessStr_Project;

IF (count>0)
THEN SET output_msg = 'TEST';
	 SELECT output_msg,P.project_id, P.project_name, N.ngo_name, S.story 
	 FROM NGO_DeclareSuccessStr_Project S JOIN (Projects P JOIN NGOs N)
	 WHERE P.project_id = S.project_id AND P.ngo_id = N.ngo_id = S.ngo_id;
ELSE SET output_msg = 'No success stories';
	 SELECT output_msg;
END IF;
END //

CREATE PROCEDURE listNGONotifications(IN NGO_id INT, OUT output_msg VARCHAR(100))
BEGIN
DECLARE count INT;

SELECT count(*) INTO count
FROM NGO_Notification N
WHERE N.ngo_id = NGO_id;

IF (count>0)
THEN SET output_msg = '';
	 SELECT P.project_id, P.project_name , N.notification_id, N.notification_type , N.notification_content
	 FROM Projects P JOIN NGO_Notification N
	 WHERE P.project_id = N.project_id AND N.ngo_id = NGO_id;
else SET output_msg = 'No notifications';
	 SELECT output_msg;
END IF;
END //

CREATE PROCEDURE listNGOCurrentCases(IN NGO_id INT, OUT output_msg VARCHAR(100))
BEGIN
DECLARE count INT;
DECLARE currentDate date;
SET currentDate = NOW();

SELECT count(*) INTO count
FROM Projects P JOIN Cases C
WHERE P.project_id = C.project_id AND P.ngo_id = NGO_id AND P.done = 0 AND 
	  P.start_date<= currentDate AND (currentDate<= P.deadline OR P.deadline is null);

IF (count>0)
THEN SET output_msg = '';
	 SELECT P.*
	 FROM Projects P JOIN Cases C
	 WHERE P.project_id = C.project_id AND P.ngo_id = NGO_id AND P.done = 0 AND 
		   P.start_date<= currentDate AND (currentDate<= P.deadline OR P.deadline is null);
ELSE SET output_msg = 'No cases';
	 SELECT output_msg;
END IF;
END //

CREATE PROCEDURE listNGOCurrentCf(IN NGO_id INT, OUT output_msg VARCHAR(100))
BEGIN
DECLARE count INT;
DECLARE currentDate date;
SET currentDate = NOW();

SELECT count(*) INTO count
FROM Projects P JOIN Crowdfundings C
WHERE P.project_id = C.project_id AND P.ngo_id = NGO_id AND P.done = 0 AND 
	  P.start_date<= currentDate AND (currentDate<= P.deadline OR P.deadline is null) AND C.verified = 1;

IF (count>0)
THEN SET output_msg = '';
	 SELECT P.*
	 FROM Projects P JOIN Crowdfundings C
	 WHERE P.project_id = C.project_id AND P.ngo_id = NGO_id AND P.done = 0 AND 
		   P.start_date<= currentDate AND (currentDate<= P.deadline OR P.deadline is null) AND C.verified = 1;
ELSE SET output_msg = 'Nocrowdfundings crowdfunding projects';
	 SELECT output_msg;
END IF;
END //

CREATE PROCEDURE listNGOCurrentCampaigns(IN NGO_id INT, OUT output_msg VARCHAR(100))
BEGIN
DECLARE count INT;
DECLARE currentDate date;
SET currentDate = NOW();

SELECT count(*) INTO count
FROM Projects P JOIN Campaigns C
WHERE P.project_id = C.project_id AND P.ngo_id = NGO_id AND P.done = 0 AND 
	  (P.start_date<= currentDate OR P.start_date is null) 
		AND (currentDate<= P.deadline OR P.deadline is null);

IF (count>0)
THEN SET output_msg = '';
	 SELECT P.*, C.num_attending_members
	 FROM Projects P JOIN Campaigns C 
	 WHERE P.project_id = C.project_id AND P.ngo_id = NGO_id AND P.done = 0 AND 
		   (P.start_date<= currentDate OR P.start_date is null) 
			AND (currentDate<= P.deadline OR P.deadline is null);
ELSE SET output_msg = 'No campaigns';
	 SELECT output_msg;
END IF;
END //

CREATE PROCEDURE listOnGoingCases(IN NGO_id INT, OUT output_msg VARCHAR(100))
BEGIN
DECLARE count INT;

SELECT count(*) INTO count
FROM Projects P JOIN Cases C ON P.project_id = C.project_id
WHERE P.ngo_id = NGO_id AND P.done = 1 AND P.completed = 0;

IF (count>0)
THEN SET output_msg = '';
	 SELECT P.*
	 FROM Projects P JOIN Cases C ON P.project_id = C.project_id 
	 WHERE P.ngo_id = NGO_id AND P.done = 1 AND P.completed = 0;
ELSE SET output_msg = 'No on-going cases';
	 SELECT output_msg;
END IF;
END //


CREATE PROCEDURE listOnGoingCrowdfundings(IN NGO_id INT, OUT output_msg VARCHAR(100))
BEGIN
DECLARE count INT;

SELECT count(*) INTO count
FROM Projects P JOIN Crowdfundings C ON P.project_id = C.project_id
WHERE P.ngo_id = NGO_id AND P.done = 1 AND P.completed = 0 AND C.verified = 1;

IF (count>0)
THEN SET output_msg = '';
	 SELECT P.*, C.user_id, C.verified
	 FROM Projects P JOIN Crowdfundings C ON P.project_id = C.project_id 
	 WHERE P.ngo_id = NGO_id AND P.done = 1 AND P.completed = 0 AND C.verified = 1;
ELSE SET output_msg = 'No on-going crowdfundings';
	 SELECT output_msg;
END IF;
END //

CREATE PROCEDURE listOnGoingCampaigns(IN NGO_id INT, OUT output_msg VARCHAR(100))
BEGIN
DECLARE count INT;

SELECT count(*) INTO count
FROM Projects P JOIN Campaigns C ON P.project_id = C.project_id
WHERE P.ngo_id = NGO_id AND P.done = 1 AND P.completed = 0;

IF (count>0)
THEN SET output_msg = '';
	 SELECT P.*, C.num_attending_members
	 FROM Projects P JOIN Campaigns C ON P.project_id = C.project_id 
	 WHERE P.ngo_id = NGO_id AND P.done = 1 AND P.completed = 0;
ELSE SET output_msg = 'No on-going campaigns';
	 SELECT output_msg;
END IF;
END //



DELIMITER ;

CALL listSuggestedProjects(1, @out);
CALL listOnGoingProjects(1, @out);
CALL listSuccessStories(@out);
CALL listNGONotifications(1, @out);
CALL listNGOCurrentCases(1, @out);
CALL listNGOCurrentCf(1,@out);
CALL listNGOCurrentCampaigns(1,@out);
CALL listOnGoingCases(1,@out);
CALL listFollowedProjects(1,@out);
DELETE from Users where user_id = 1;