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
name VARCHAR(40),address VARCHAR(500),phone VARCHAR(50),
OUT success_msg VARCHAR(100))

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
					SET success_msg = 'PASSWORD SHOULD BE 
									   LONGER THAN 8';
			        SELECT success_msg;
				ELSE
					INSERT INTO Users(user_email,password,user_name ,
					address,phone) 
					VALUES (email,pass,name,address,phone);
					INSERT INTO Sessions(user_id,ngo_id,last_login,
					expiry_login,logged_in)
					VALUES(LAST_INSERT_ID(),null,NOW(),null,1);
					SET success_msg = 'YOU HAVE SUCCESSFULLY 
									    REGISTERED';
					SELECT success_msg;
			END IF;
		END IF;

	END IF;
END//

-- 2
CREATE PROCEDURE AccountExists(email VARCHAR(100),pass VARCHAR(40),
OUT success_msg VARCHAR(100))
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
CREATE PROCEDURE getProject(id INT,OUT success_msg VARCHAR(100))
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
objQuantity INT,OUT success_msg VARCHAR(100))
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

-- ------------ OSAMA--------------------------


CREATE PROCEDURE listFollowedProjects(user_id INT,OUT success_msg VARCHAR(100))
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

CREATE PROCEDURE listMyProjects(id INT,OUT success_msg VARCHAR(100))
BEGIN
IF NOT EXISTS(SELECT Users.user_id FROM Users WHERE Users.user_id = id)
THEN
SET success_msg = 'This user is not registered';
SELECT success_msg;
ELSE
IF ((SELECT User_DonateMoney_Project.user_id FROM User_DonateMoney_Project
	WHERE User_DonateMoney_Project.user_id = id
	UNION
	SELECT User_DonateObject_Project.user_id FROM User_DonateObject_Project
	WHERE User_DonateObject_Project.user_id = id
    UNION
    SELECT User_Volunteer_Project.user_id FROM User_Volunteer_Project
	WHERE User_Volunteer_Project.user_id = id
    UNION
	SELECT User_Follow_Project.user_id FROM User_Follow_Project
	WHERE User_Follow_Project.user_id = id) IS NULL)
THEN 
	SET success_msg = 'You have no projects';
	SELECT success_msg;
ELSE
	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN User_DonateMoney_Project 
	on Projects.project_id = User_DonateMoney_Project.project_id
	WHERE id = User_DonateMoney_Project.user_id

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN User_DonateObject_Project 
	on Projects.project_id = User_DonateObject_Project.project_id
	WHERE id = User_DonateObject_Project.user_id

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN User_Volunteer_Project 
	on Projects.project_id = User_Volunteer_Project.project_id
	WHERE id = User_Volunteer_Project.user_id

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN User_Follow_Project 
	on Projects.project_id = User_Follow_Project.project_id
	WHERE id = User_Follow_Project.user_id;
	END IF;
END IF;	
END//

CREATE PROCEDURE listMyCases(id INT,OUT success_msg VARCHAR(100))
BEGIN
IF NOT EXISTS(SELECT Users.user_id FROM Users WHERE Users.user_id = id)
THEN
SET success_msg = 'This user is not registered';
SELECT success_msg;
ELSE
IF ((SELECT User_DonateMoney_Project.user_id FROM User_DonateMoney_Project
	JOIN Cases ON User_DonateMoney_Project.project_id = Cases.project_id
	WHERE User_DonateMoney_Project.user_id = id
	UNION
	SELECT User_DonateObject_Project.user_id FROM User_DonateObject_Project
	JOIN Cases ON User_DonateObject_Project.project_id = Cases.project_id
	WHERE User_DonateObject_Project.user_id = id
    UNION
    SELECT User_Volunteer_Project.user_id FROM User_Volunteer_Project
	JOIN Cases ON User_Volunteer_Project.project_id = Cases.project_id
	WHERE User_Volunteer_Project.user_id = id
    UNION
	SELECT User_Follow_Project.user_id FROM User_Follow_Project
	JOIN Cases ON User_Follow_Project.project_id = Cases.project_id
	WHERE User_Follow_Project.user_id = id) IS NULL)
THEN 
	SET success_msg = 'You have no Cases';
	SELECT success_msg;
ELSE
	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Cases
	ON Cases.project_id=Projects.project_id
	JOIN User_DonateMoney_Project 
	on Cases.project_id = User_DonateMoney_Project.project_id
	WHERE id = User_DonateMoney_Project.user_id

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Cases
	ON Cases.project_id=Projects.project_id
	JOIN User_DonateObject_Project 
	on Cases.project_id = User_DonateObject_Project.project_id
	WHERE id = User_DonateObject_Project.user_id

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Cases
	ON Cases.project_id=Projects.project_id
	JOIN User_Volunteer_Project 
	on Cases.project_id = User_Volunteer_Project.project_id
	WHERE id = User_Volunteer_Project.user_id

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Cases
	ON Cases.project_id=Projects.project_id
	JOIN User_Follow_Project 
	on Cases.project_id = User_Follow_Project.project_id
	WHERE id = User_Follow_Project.user_id;
	END IF;
END IF;	
END//


















CREATE PROCEDURE listUserCreatedCrowdFundingProjects(id INT,
OUT success_msg VARCHAR(100))
BEGIN
IF NOT EXISTS(SELECT Users.user_id FROM Users WHERE Users.user_id = id)
THEN
	SET success_msg = 'This user is not registered';
	SELECT success_msg;
ELSE
	IF NOT EXISTS(SELECT Crowdfundings.user_id FROM Crowdfundings 
	WHERE Crowdfundings.user_id = id)
	THEN
		SET success_msg = 'You did not create any crowdfunding projects';
		SELECT success_msg;
	ELSE
		SELECT Projects.project_id,ngo_id,project_name,description,
		location,deadline,start_date,done,completed,volunteer,
		donate_money,donate_object,collected_amount,Projects.amount,
		Crowdfundings.verified
		FROM Projects
		RIGHT JOIN Crowdfundings 
		on Projects.project_id = Crowdfundings.project_id
		WHERE id = Crowdfundings.user_id;
	END IF;
END IF;
END//

CREATE PROCEDURE listMyCrowdFundingProjects(id INT,
OUT success_msg VARCHAR(100) )
BEGIN
IF NOT EXISTS(SELECT Users.user_id FROM Users WHERE Users.user_id = id)
THEN
SET success_msg = 'This user is not registered';
SELECT success_msg;
ELSE
IF ((SELECT User_DonateMoney_Project.user_id FROM User_DonateMoney_Project
	JOIN Crowdfundings ON User_DonateMoney_Project.project_id = Crowdfundings.project_id
	WHERE User_DonateMoney_Project.user_id = id 
	UNION
	SELECT User_DonateObject_Project.user_id FROM User_DonateObject_Project
	JOIN Crowdfundings ON User_DonateObject_Project.project_id = Crowdfundings.project_id
	WHERE User_DonateObject_Project.user_id = id 
    UNION
    SELECT User_Volunteer_Project.user_id FROM User_Volunteer_Project
	JOIN Crowdfundings ON User_Volunteer_Project.project_id = Crowdfundings.project_id
	WHERE User_Volunteer_Project.user_id = id 
    UNION
	SELECT User_Follow_Project.user_id FROM User_Follow_Project
	JOIN Crowdfundings ON User_Follow_Project.project_id = Crowdfundings.project_id
	WHERE User_Follow_Project.user_id = id) IS NULL)
THEN 
	SET success_msg = 'You have no Crowdfunding projects';
	SELECT success_msg;
ELSE
	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Crowdfundings
	ON Crowdfundings.project_id=Projects.project_id
	JOIN User_DonateMoney_Project 
	on Crowdfundings.project_id = User_DonateMoney_Project.project_id
	WHERE id = User_DonateMoney_Project.user_id

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Crowdfundings
	ON Crowdfundings.project_id=Projects.project_id
	JOIN User_DonateObject_Project 
	on Crowdfundings.project_id = User_DonateObject_Project.project_id
	WHERE id = User_DonateObject_Project.user_id

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Crowdfundings
	ON Crowdfundings.project_id=Projects.project_id
	JOIN User_Volunteer_Project 
	on Crowdfundings.project_id = User_Volunteer_Project.project_id
	WHERE id = User_Volunteer_Project.user_id

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Crowdfundings
	ON Crowdfundings.project_id=Projects.project_id
	JOIN User_Follow_Project 
	on Crowdfundings.project_id = User_Follow_Project.project_id
	WHERE id = User_Follow_Project.user_id;
	END IF;
END IF;
END//

CREATE PROCEDURE listMyCampaigns(id INT,OUT success_msg VARCHAR(100))
BEGIN
IF NOT EXISTS(SELECT Users.user_id FROM Users WHERE Users.user_id = id)
THEN
SET success_msg = 'This user is not registered';
SELECT success_msg;
ELSE
IF ((SELECT User_DonateMoney_Project.user_id FROM User_DonateMoney_Project
	JOIN Campaigns ON User_DonateMoney_Project.project_id = Campaigns.project_id
	WHERE User_DonateMoney_Project.user_id = id 
	UNION
	SELECT User_DonateObject_Project.user_id FROM User_DonateObject_Project
	JOIN Campaigns ON User_DonateObject_Project.project_id = Campaigns.project_id
	WHERE User_DonateObject_Project.user_id = id 
    UNION
    SELECT User_Volunteer_Project.user_id FROM User_Volunteer_Project
	JOIN Campaigns ON User_Volunteer_Project.project_id = Campaigns.project_id
	WHERE User_Volunteer_Project.user_id = id 
    UNION
	SELECT User_Follow_Project.user_id FROM User_Follow_Project
	JOIN Campaigns ON User_Follow_Project.project_id = Campaigns.project_id
	WHERE User_Follow_Project.user_id = id) IS NULL)
THEN 
	SET success_msg = 'No campaigns';
	SELECT success_msg;
ELSE
	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount,Campaigns.num_attending_members
	FROM Projects
	JOIN Campaigns
	ON Campaigns.project_id=Projects.project_id
	JOIN User_DonateMoney_Project 
	on Campaigns.project_id = User_DonateMoney_Project.project_id
	WHERE id = User_DonateMoney_Project.user_id

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount,Campaigns.num_attending_members
	FROM Projects
	JOIN Campaigns
	ON Campaigns.project_id=Projects.project_id
	JOIN User_DonateObject_Project 
	on Campaigns.project_id = User_DonateObject_Project.project_id
	WHERE id = User_DonateObject_Project.user_id

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount,Campaigns.num_attending_members
	FROM Projects
	JOIN Campaigns
	ON Campaigns.project_id=Projects.project_id
	JOIN User_Volunteer_Project 
	on Campaigns.project_id = User_Volunteer_Project.project_id
	WHERE id = User_Volunteer_Project.user_id

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount,Campaigns.num_attending_members
	FROM Projects
	JOIN Campaigns
	ON Campaigns.project_id=Projects.project_id
	JOIN User_Follow_Project 
	on Campaigns.project_id = User_Follow_Project.project_id
	WHERE id = User_Follow_Project.user_id;
	END IF;
END IF;
END//

CREATE PROCEDURE listNGO(OUT success_msg VARCHAR(100))
BEGIN
IF NOT EXISTS(SELECT * FROM NGOs) 
THEN
	SET success_msg = 'NO NGOs';
	SELECT success_msg;
ELSE
	SELECT * FROM NGOs;
END IF;
END//

CREATE PROCEDURE getUrgentProjects(OUT success_msg VARCHAR(100))
BEGIN
	IF NOT EXISTS(SELECT * FROM Projects Where urgency_id = 1)
	THEN
		SET success_msg = 'NO Urgent Projects';
		SELECT success_msg;
	ELSE
		SELECT * FROM Projects Where urgency_id = 1;
	END IF;
END//

CREATE PROCEDURE getType(IN email VARCHAR(100), OUT type VARCHAR(100))
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




CREATE PROCEDURE createCase(IN NGO_id INT,IN urg_id INT,IN p_name varchar(40),
IN p_description varchar(6000),IN p_location varchar(500),IN p_deadline date,
IN isVolunteer bit,IN isMoney bit,IN isObject bit,IN p_amount INT, OUT p_id INT, OUT output_msg VARCHAR(100))
BEGIN
SET output_msg = '';
SET p_id = -1;
IF EXISTS (SELECT P.project_name
		   FROM Projects P
		   WHERE P.project_name = p_name)
THEN SET output_msg = 'Project name exist';
ELSE INSERT INTO Projects(ngo_id,urgency_id,project_name,description,location,deadline,start_date,done,completed,
				volunteer,donate_money,donate_object,collected_amount,amount)
	 VALUES(NGO_id,urg_id,p_name,p_description,p_location,p_deadline,NOW(),0,0,isVolunteer,isMoney,isObject,0,p_amount);
	 INSERT INTO Cases(project_id) VALUES (LAST_INSERT_ID());
	 SET p_id = LAST_INSERT_ID(); 
END IF;
SELECT p_id,output_msg;
END //

CREATE PROCEDURE addCategoryToProject(IN p_id INT, IN c_id INT)
BEGIN
INSERT INTO Project_Categories(project_id,category_id)
VALUES (p_id,c_id);
END //

CREATE PROCEDURE getRecommendedProjects(OUT success_msg VARCHAR(100))
BEGIN
IF NOT EXISTS(SELECT * FROM Projects WHERE 
(Projects.deadline>= CURDATE() && 
CURDATE() >= date_sub(Projects.deadline, interval 7 day)))
				
THEN
	SET success_msg = 'No Recommended Projects';
	SELECT success_msg;
ELSE
SELECT * FROM Projects WHERE 
(Projects.deadline>= CURDATE() && 
CURDATE() >= date_sub(Projects.deadline, interval 7 day));
END IF;
END//

CREATE PROCEDURE listMyCurCases(id INT,OUT success_msg VARCHAR(100))
BEGIN
IF NOT EXISTS(SELECT Users.user_id FROM Users WHERE Users.user_id = id)
THEN
SET success_msg = 'This user is not registered';
SELECT success_msg;
ELSE
IF ((SELECT User_DonateMoney_Project.user_id FROM User_DonateMoney_Project
	JOIN Cases ON User_DonateMoney_Project.project_id = Cases.project_id
	JOIN Projects
	ON Cases.project_id = Projects.project_id
	WHERE User_DonateMoney_Project.user_id = id
	&& CURDATE()<Projects.deadline && Projects.done = 0
	UNION
	SELECT User_DonateObject_Project.user_id FROM User_DonateObject_Project
	JOIN Cases ON User_DonateObject_Project.project_id = Cases.project_id
	JOIN Projects
	ON Cases.project_id = Projects.project_id
	WHERE User_DonateObject_Project.user_id = id
	&& CURDATE()<Projects.deadline && Projects.done = 0
    UNION
    SELECT User_Volunteer_Project.user_id FROM User_Volunteer_Project
	JOIN Cases ON User_Volunteer_Project.project_id = Cases.project_id
	JOIN Projects
	ON Cases.project_id = Projects.project_id
	WHERE User_Volunteer_Project.user_id = id
	&& CURDATE()<Projects.deadline && Projects.done = 0
    UNION
	SELECT User_Follow_Project.user_id FROM User_Follow_Project
	JOIN Cases ON User_Follow_Project.project_id = Cases.project_id
	JOIN Projects
	ON Cases.project_id = Projects.project_id
	WHERE User_Follow_Project.user_id = id
	&& CURDATE()<Projects.deadline && Projects.done = 0) IS NULL)
THEN 
	SET success_msg = 'NO CURRENT CASES';
	SELECT success_msg;
ELSE
	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Cases
	ON Cases.project_id=Projects.project_id
	JOIN User_DonateMoney_Project 
	on Cases.project_id = User_DonateMoney_Project.project_id
	WHERE id = User_DonateMoney_Project.user_id
	&& CURDATE()<Projects.deadline && Projects.done = 0

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Cases
	ON Cases.project_id=Projects.project_id
	JOIN User_DonateObject_Project 
	on Cases.project_id = User_DonateObject_Project.project_id
	WHERE id = User_DonateObject_Project.user_id
	&& CURDATE()<Projects.deadline && Projects.done = 0

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Cases
	ON Cases.project_id=Projects.project_id
	JOIN User_Volunteer_Project 
	on Cases.project_id = User_Volunteer_Project.project_id
	WHERE id = User_Volunteer_Project.user_id
	&& CURDATE()<Projects.deadline && Projects.done = 0
	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Cases
	ON Cases.project_id=Projects.project_id
	JOIN User_Follow_Project 
	on Cases.project_id = User_Follow_Project.project_id
	WHERE id = User_Follow_Project.user_id
	&& CURDATE()<Projects.deadline && Projects.done = 0;
	END IF;
END IF;	
END//

CREATE PROCEDURE listMyFinishedCases(id INT,OUT success_msg VARCHAR(100))
BEGIN
IF NOT EXISTS(SELECT Users.user_id FROM Users WHERE Users.user_id = id)
THEN
SET success_msg = 'This user is not registered';
SELECT success_msg;
ELSE
IF ((SELECT User_DonateMoney_Project.user_id FROM User_DonateMoney_Project
	JOIN Cases ON User_DonateMoney_Project.project_id = Cases.project_id
	JOIN Projects
	ON Cases.project_id = Projects.project_id
	WHERE User_DonateMoney_Project.user_id = id
	&& Projects.done = 1 && Projects.completed = 0
	UNION
	SELECT User_DonateObject_Project.user_id FROM User_DonateObject_Project
	JOIN Cases ON User_DonateObject_Project.project_id = Cases.project_id
	JOIN Projects
	ON Cases.project_id = Projects.project_id
	WHERE User_DonateObject_Project.user_id = id
	&& Projects.done = 1 && Projects.completed = 0
    UNION
    SELECT User_Volunteer_Project.user_id FROM User_Volunteer_Project
	JOIN Cases ON User_Volunteer_Project.project_id = Cases.project_id
	JOIN Projects
	ON Cases.project_id = Projects.project_id
	WHERE User_Volunteer_Project.user_id = id
	&& Projects.done = 1 && Projects.completed = 0
    UNION
	SELECT User_Follow_Project.user_id FROM User_Follow_Project
	JOIN Cases ON User_Follow_Project.project_id = Cases.project_id
	JOIN Projects
	ON Cases.project_id = Projects.project_id
	WHERE User_Follow_Project.user_id = id
	&& Projects.done = 1 && Projects.completed = 0) IS NULL)
THEN 
	SET success_msg = 'NO FINISHED CASES';
	SELECT success_msg;
ELSE
	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Cases
	ON Cases.project_id=Projects.project_id
	JOIN User_DonateMoney_Project 
	on Cases.project_id = User_DonateMoney_Project.project_id
	WHERE id = User_DonateMoney_Project.user_id
	&& Projects.done = 1 && Projects.completed = 0

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Cases
	ON Cases.project_id=Projects.project_id
	JOIN User_DonateObject_Project 
	on Cases.project_id = User_DonateObject_Project.project_id
	WHERE id = User_DonateObject_Project.user_id
	&& Projects.done = 1 && Projects.completed = 0

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Cases
	ON Cases.project_id=Projects.project_id
	JOIN User_Volunteer_Project 
	on Cases.project_id = User_Volunteer_Project.project_id
	WHERE id = User_Volunteer_Project.user_id
	&& Projects.done = 1 && Projects.completed = 0
	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Cases
	ON Cases.project_id=Projects.project_id
	JOIN User_Follow_Project 
	on Cases.project_id = User_Follow_Project.project_id
	WHERE id = User_Follow_Project.user_id
	&& Projects.done = 1 && Projects.completed = 0;
	END IF;
END IF;	
END//

CREATE PROCEDURE listMyCurCrowdFundingProjects(id INT,
OUT success_msg VARCHAR(100) )
BEGIN
IF NOT EXISTS(SELECT Users.user_id FROM Users WHERE Users.user_id = id)
THEN
SET success_msg = 'This user is not registered';
SELECT success_msg;
ELSE
IF ((SELECT User_DonateMoney_Project.user_id FROM User_DonateMoney_Project
	JOIN Crowdfundings ON User_DonateMoney_Project.project_id = Crowdfundings.project_id
	JOIN Projects ON Crowdfundings.project_id=Projects.project_id
	WHERE User_DonateMoney_Project.user_id = id 
	&& CURDATE()<Projects.deadline && Projects.done = 0
	UNION
	SELECT User_DonateObject_Project.user_id FROM User_DonateObject_Project
	JOIN Crowdfundings ON User_DonateObject_Project.project_id = Crowdfundings.project_id
	JOIN Projects ON Crowdfundings.project_id=Projects.project_id
	WHERE User_DonateObject_Project.user_id = id 
	&& CURDATE()<Projects.deadline && Projects.done = 0
    UNION
    SELECT User_Volunteer_Project.user_id FROM User_Volunteer_Project
	JOIN Crowdfundings ON User_Volunteer_Project.project_id = Crowdfundings.project_id
	JOIN Projects ON Crowdfundings.project_id=Projects.project_id
	WHERE User_Volunteer_Project.user_id = id
	&& CURDATE()<Projects.deadline && Projects.done = 0
    UNION
	SELECT User_Follow_Project.user_id FROM User_Follow_Project
	JOIN Crowdfundings ON User_Follow_Project.project_id = Crowdfundings.project_id
	JOIN Projects ON Crowdfundings.project_id=Projects.project_id
	WHERE User_Follow_Project.user_id = id
	&& CURDATE()<Projects.deadline && Projects.done = 0) IS NULL)
THEN 
	SET success_msg = 'NO CURRENT CROWDFUNDING PROJECTS';
	SELECT success_msg;
ELSE
	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Crowdfundings
	ON Crowdfundings.project_id=Projects.project_id
	JOIN User_DonateMoney_Project 
	on Crowdfundings.project_id = User_DonateMoney_Project.project_id
	WHERE id = User_DonateMoney_Project.user_id
	&& CURDATE()<Projects.deadline && Projects.done = 0

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Crowdfundings
	ON Crowdfundings.project_id=Projects.project_id
	JOIN User_DonateObject_Project 
	on Crowdfundings.project_id = User_DonateObject_Project.project_id
	WHERE id = User_DonateObject_Project.user_id
	&& CURDATE()<Projects.deadline && Projects.done = 0

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Crowdfundings
	ON Crowdfundings.project_id=Projects.project_id
	JOIN User_Volunteer_Project 
	on Crowdfundings.project_id = User_Volunteer_Project.project_id
	WHERE id = User_Volunteer_Project.user_id
	&& CURDATE()<Projects.deadline && Projects.done = 0

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Crowdfundings
	ON Crowdfundings.project_id=Projects.project_id
	JOIN User_Follow_Project 
	on Crowdfundings.project_id = User_Follow_Project.project_id
	WHERE id = User_Follow_Project.user_id
	&& CURDATE()<Projects.deadline && Projects.done = 0;
	END IF;
END IF;
END//

CREATE PROCEDURE listMyFinishedCrowdFundingProjects(id INT,
OUT success_msg VARCHAR(100) )
BEGIN
IF NOT EXISTS(SELECT Users.user_id FROM Users WHERE Users.user_id = id)
THEN
SET success_msg = 'This user is not registered';
SELECT success_msg;
ELSE
IF ((SELECT User_DonateMoney_Project.user_id FROM User_DonateMoney_Project
	JOIN Crowdfundings ON User_DonateMoney_Project.project_id = Crowdfundings.project_id
	JOIN Projects ON Crowdfundings.project_id=Projects.project_id
	WHERE User_DonateMoney_Project.user_id = id 
	&& Projects.done = 1 && Projects.completed = 0
	UNION
	SELECT User_DonateObject_Project.user_id FROM User_DonateObject_Project
	JOIN Crowdfundings ON User_DonateObject_Project.project_id = Crowdfundings.project_id
	JOIN Projects ON Crowdfundings.project_id=Projects.project_id
	WHERE User_DonateObject_Project.user_id = id 
	&& Projects.done = 1 && Projects.completed = 0
    UNION
    SELECT User_Volunteer_Project.user_id FROM User_Volunteer_Project
	JOIN Crowdfundings ON User_Volunteer_Project.project_id = Crowdfundings.project_id
	JOIN Projects ON Crowdfundings.project_id=Projects.project_id
	WHERE User_Volunteer_Project.user_id = id
	&& Projects.done = 1 && Projects.completed = 0
    UNION
	SELECT User_Follow_Project.user_id FROM User_Follow_Project
	JOIN Crowdfundings ON User_Follow_Project.project_id = Crowdfundings.project_id
	JOIN Projects ON Crowdfundings.project_id=Projects.project_id
	WHERE User_Follow_Project.user_id = id
	&& Projects.done = 1 && Projects.completed = 0) IS NULL)
THEN 
	SET success_msg = 'NO FINISHED CROWDFUNDING PROJECTS';
	SELECT success_msg;
ELSE
	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Crowdfundings
	ON Crowdfundings.project_id=Projects.project_id
	JOIN User_DonateMoney_Project 
	on Crowdfundings.project_id = User_DonateMoney_Project.project_id
	WHERE id = User_DonateMoney_Project.user_id
	&& Projects.done = 1 && Projects.completed = 0

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Crowdfundings
	ON Crowdfundings.project_id=Projects.project_id
	JOIN User_DonateObject_Project 
	on Crowdfundings.project_id = User_DonateObject_Project.project_id
	WHERE id = User_DonateObject_Project.user_id
	&& Projects.done = 1 && Projects.completed = 0

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Crowdfundings
	ON Crowdfundings.project_id=Projects.project_id
	JOIN User_Volunteer_Project 
	on Crowdfundings.project_id = User_Volunteer_Project.project_id
	WHERE id = User_Volunteer_Project.user_id
	&& Projects.done = 1 && Projects.completed = 0

	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount
	FROM Projects
	JOIN Crowdfundings
	ON Crowdfundings.project_id=Projects.project_id
	JOIN User_Follow_Project 
	on Crowdfundings.project_id = User_Follow_Project.project_id
	WHERE id = User_Follow_Project.user_id
	&& Projects.done = 1 && Projects.completed = 0;
	END IF;
END IF;
END//

CREATE PROCEDURE listMyCurCampaigns(id INT,OUT success_msg VARCHAR(100))
BEGIN
IF NOT EXISTS(SELECT Users.user_id FROM Users WHERE Users.user_id = id)
THEN
SET success_msg = 'This user is not registered';
SELECT success_msg;
ELSE
IF ((SELECT User_DonateMoney_Project.user_id FROM User_DonateMoney_Project
	JOIN Campaigns ON User_DonateMoney_Project.project_id = Campaigns.project_id
	JOIN Projects ON Projects.project_id = Campaigns.project_id
	WHERE User_DonateMoney_Project.user_id = id
	&& CURDATE()<Projects.deadline && Projects.done = 0
	UNION
	SELECT User_DonateObject_Project.user_id FROM User_DonateObject_Project
	JOIN Campaigns ON User_DonateObject_Project.project_id = Campaigns.project_id
	JOIN Projects ON Projects.project_id = Campaigns.project_id
	WHERE User_DonateObject_Project.user_id = id
	&& CURDATE()<Projects.deadline && Projects.done = 0
    UNION
    SELECT User_Volunteer_Project.user_id FROM User_Volunteer_Project
	JOIN Campaigns ON User_Volunteer_Project.project_id = Campaigns.project_id
	JOIN Projects ON Projects.project_id = Campaigns.project_id
	WHERE User_Volunteer_Project.user_id = id
	&& CURDATE()<Projects.deadline && Projects.done = 0
    UNION
	SELECT User_Follow_Project.user_id FROM User_Follow_Project
	JOIN Campaigns ON User_Follow_Project.project_id = Campaigns.project_id
	JOIN Projects ON Projects.project_id = Campaigns.project_id
	WHERE User_Follow_Project.user_id = id
	&& CURDATE()<Projects.deadline && Projects.done = 0) IS NULL)
THEN 
	SET success_msg = 'NO CURRENT CAMPAIGNS';
	SELECT success_msg;
ELSE
	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount,Campaigns.num_attending_members
	FROM Projects
	JOIN Campaigns
	ON Campaigns.project_id=Projects.project_id
	JOIN User_DonateMoney_Project 
	on Campaigns.project_id = User_DonateMoney_Project.project_id
	WHERE id = User_DonateMoney_Project.user_id
	&& CURDATE()<Projects.deadline && Projects.done = 0
	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount,Campaigns.num_attending_members
	FROM Projects
	JOIN Campaigns
	ON Campaigns.project_id=Projects.project_id
	JOIN User_DonateObject_Project 
	on Campaigns.project_id = User_DonateObject_Project.project_id
	WHERE id = User_DonateObject_Project.user_id
	&& CURDATE()<Projects.deadline && Projects.done = 0
	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount,Campaigns.num_attending_members
	FROM Projects
	JOIN Campaigns
	ON Campaigns.project_id=Projects.project_id
	JOIN User_Volunteer_Project 
	on Campaigns.project_id = User_Volunteer_Project.project_id
	WHERE id = User_Volunteer_Project.user_id
	&& CURDATE()<Projects.deadline && Projects.done = 0
	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount,Campaigns.num_attending_members
	FROM Projects
	JOIN Campaigns
	ON Campaigns.project_id=Projects.project_id
	JOIN User_Follow_Project 
	on Campaigns.project_id = User_Follow_Project.project_id
	WHERE id = User_Follow_Project.user_id
	&& CURDATE()<Projects.deadline && Projects.done = 0;
	END IF;
END IF;
END//

CREATE PROCEDURE listMyFinishedCampaigns(id INT,OUT success_msg VARCHAR(100))
BEGIN
IF NOT EXISTS(SELECT Users.user_id FROM Users WHERE Users.user_id = id)
THEN
SET success_msg = 'This user is not registered';
SELECT success_msg;
ELSE
IF ((SELECT User_DonateMoney_Project.user_id FROM User_DonateMoney_Project
	JOIN Campaigns ON User_DonateMoney_Project.project_id = Campaigns.project_id
	JOIN Projects ON Projects.project_id = Campaigns.project_id
	WHERE User_DonateMoney_Project.user_id = id
	&& Projects.done = 1 && Projects.completed = 0
	UNION
	SELECT User_DonateObject_Project.user_id FROM User_DonateObject_Project
	JOIN Campaigns ON User_DonateObject_Project.project_id = Campaigns.project_id
	JOIN Projects ON Projects.project_id = Campaigns.project_id
	WHERE User_DonateObject_Project.user_id = id
	&& Projects.done = 1 && Projects.completed = 0
    UNION
    SELECT User_Volunteer_Project.user_id FROM User_Volunteer_Project
	JOIN Campaigns ON User_Volunteer_Project.project_id = Campaigns.project_id
	JOIN Projects ON Projects.project_id = Campaigns.project_id
	WHERE User_Volunteer_Project.user_id = id
	&& Projects.done = 1 && Projects.completed = 0
    UNION
	SELECT User_Follow_Project.user_id FROM User_Follow_Project
	JOIN Campaigns ON User_Follow_Project.project_id = Campaigns.project_id
	JOIN Projects ON Projects.project_id = Campaigns.project_id
	WHERE User_Follow_Project.user_id = id
	&& Projects.done = 1 && Projects.completed = 0) IS NULL)
THEN 
	SET success_msg = 'NO FINISHED CAMPAIGNS';
	SELECT success_msg;
ELSE
	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount,Campaigns.num_attending_members
	FROM Projects
	JOIN Campaigns
	ON Campaigns.project_id=Projects.project_id
	JOIN User_DonateMoney_Project 
	on Campaigns.project_id = User_DonateMoney_Project.project_id
	WHERE id = User_DonateMoney_Project.user_id
	&& Projects.done = 1 && Projects.completed = 0
	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount,Campaigns.num_attending_members
	FROM Projects
	JOIN Campaigns
	ON Campaigns.project_id=Projects.project_id
	JOIN User_DonateObject_Project 
	on Campaigns.project_id = User_DonateObject_Project.project_id
	WHERE id = User_DonateObject_Project.user_id
	&& Projects.done = 1 && Projects.completed = 0
	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount,Campaigns.num_attending_members
	FROM Projects
	JOIN Campaigns
	ON Campaigns.project_id=Projects.project_id
	JOIN User_Volunteer_Project 
	on Campaigns.project_id = User_Volunteer_Project.project_id
	WHERE id = User_Volunteer_Project.user_id
	&& Projects.done = 1 && Projects.completed = 0
	UNION

	SELECT Projects.project_id,ngo_id,project_name,description,location,
	deadline,start_date,done,completed,volunteer,donate_money,donate_object,
	collected_amount,Projects.amount,Campaigns.num_attending_members
	FROM Projects
	JOIN Campaigns
	ON Campaigns.project_id=Projects.project_id
	JOIN User_Follow_Project 
	on Campaigns.project_id = User_Follow_Project.project_id
	WHERE id = User_Follow_Project.user_id
	&& Projects.done = 1 && Projects.completed = 0;
	END IF;
END IF;
END//
CREATE PROCEDURE listNGO(OUT success_msg VARCHAR(100))
BEGIN
IF NOT EXISTS(SELECT * FROM NGOs) 
THEN
	SET success_msg = 'NO NGOs';
	SELECT success_msg;
ELSE
	SELECT * FROM NGOs;
END IF;
END//

DELIMITER ;

CALL listMyProjects(1,@out);
CALL listMyCases(1, @OUT);
CALL listUserCreatedCrowdFundingProjects(3,@OUT);
CALL listMyCrowdFundingProjects(2,@OUT);
CALL listMyCampaigns(5,@OUT);
CALL listNGO(@OUT);
CALL getUrgentProjects(@OUT);
CALL getRecommendedProjects(@OUT);
CALL listMyCurCases(1, @OUT);
CALL listMyFinishedCases(1, @OUT);
CALL listMyCurCrowdFundingProjects(1, @OUT);
CALL listMyFinishedCrowdFundingProjects(1, @OUT);
CALL listMyCurCampaigns(1, @OUT);