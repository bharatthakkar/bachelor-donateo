CREATE SCHEMA `DonationCrowdfundingProject` ;

-- MARINA
CREATE TABLE Admins(
admin_id INT PRIMARY KEY AUTO_INCREMENT,
admin_email varchar(100) UNIQUE NOT NULL,
password varchar(40) NOT NULL);

-- MARINA
CREATE TABLE Users(
user_id INT PRIMARY KEY AUTO_INCREMENT,
user_email varchar(100) UNIQUE NOT NULL,
password varchar(40) NOT NULL,
user_name varchar(40) UNIQUE NOT NULL,
address varchar(500),
phone varchar(50),
points INT,
creditcard_num varchar(20));

-- MARINA
CREATE TABLE User_Speciality(
speciality_id INT AUTO_INCREMENT,
user_id INT,
speciality_name varchar(40)NOT NULL,
PRIMARY KEY (speciality_id,user_id),
FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- MARINA
CREATE TABLE NGOs(
ngo_id INT PRIMARY KEY AUTO_INCREMENT,
admin_id INT,
ngo_email varchar(100) UNIQUE NOT NULL,
password varchar(40) NOT NULL,
ngo_name varchar(40) UNIQUE NOT NULL,
photo varchar(100),
description varchar (6000) NOT NULL,
website_link varchar(500),
phone varchar(50),
FOREIGN KEY (admin_id) REFERENCES Admins (admin_id));

-- MARINA
CREATE TABLE NGO_Speciality(
speciality_id INT AUTO_INCREMENT,
ngo_id INT,
speciality_name VARCHAR(40) NOT NULL,
PRIMARY KEY(speciality_id,ngo_id),
FOREIGN KEY (ngo_id) REFERENCES NGOs (ngo_id)ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE Sessions(
session_id INT PRIMARY KEY AUTO_INCREMENT,
user_id INT,
ngo_id INT,
last_login DATE NOT NULL,
expiry_login DATE,
logged_in BIT,
FOREIGN KEY (user_id) REFERENCES Users (user_id));


-- DALIA
CREATE TABLE Urgency(
urgency_id INT PRIMARY KEY AUTO_INCREMENT,
urgency_name VARCHAR(40),
description VARCHAR(6000));

-- DALIA
CREATE TABLE Projects(
project_id INT PRIMARY KEY AUTO_INCREMENT,
ngo_id INT,
urgency_id INT,
project_name varchar(40) UNIQUE NOT NULL,
description varchar(6000) NOT NULL,
location varchar(500),
deadline DATE,
start_date DATE,
done bit,
completed bit,
volunteer bit,
donate_money bit,
donate_object bit,
collected_amount INT,
amount INT,
FOREIGN KEY (ngo_id) REFERENCES NGOs (ngo_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (urgency_id) REFERENCES Urgency (urgency_id));

-- DALIA
CREATE TABLE ProjectPhotos(
photo_id INT AUTO_INCREMENT,
project_id INT,
photo_url VARCHAR(500) NOT NULL,
PRIMARY KEY(photo_id,project_id),
FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- DALIA
CREATE TABLE ProjectVideos(
video_id INT AUTO_INCREMENT,
project_id INT,
video_url VARCHAR(500) NOT NULL,
PRIMARY KEY(video_id,project_id),
FOREIGN KEY (project_id) REFERENCES Projects (project_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- DALIA
CREATE TABLE Cases(
project_id INT PRIMARY KEY,
FOREIGN KEY (project_id) references Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- DALIA
CREATE Table Crowdfundings(
project_id INT PRIMARY KEY,
user_id INT,
verified BIT,
FOREIGN KEY (project_id) references Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (user_id) references Users(user_id));

-- DALIA
CREATE TABLE Campaigns(
project_id INT PRIMARY KEY,
num_attending_members INT,
FOREIGN KEY (project_id) references Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- MARINA
CREATE TABLE Objects(
object_id INT AUTO_INCREMENT,
project_id INT,
collected_quantity INT,
quantity INT,
object_name VARCHAR(40) NOT NULL,
PRIMARY KEY(object_id,project_id),
FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- MARINA
CREATE TABLE Transactions(
transaction_id INT AUTO_INCREMENT,
project_id INT,
user_id INT,
type VARCHAR(40),
amount INT,
date DATE,
time TIME,
done BIT,
PRIMARY KEY(transaction_id,project_id,user_id),
FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- DALIA
CREATE TABLE Progress(
progress_id INT AUTO_INCREMENT,
project_id INT,
progress_name VARCHAR(40) NOT NULL,
progress_type VARCHAR(40) NOT NULL,
date DATE,
percentage INT,
PRIMARY KEY(progress_id,project_id),
FOREIGN KEY (project_id) references Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE,
CHECK ((percentage>=0) AND (percentage<=100)));

-- DALIA
CREATE TABLE Category(
category_id INT PRIMARY KEY AUTO_INCREMENT,
category_name VARCHAR(40));


-- MARINA
CREATE TABLE Questions(
question_id INT AUTO_INCREMENT,
user_id INT,
project_id INT,
content VARCHAR(1000),
answer_content VARCHAR(1000),
PRIMARY KEY(question_id,project_id,user_id),
FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- DALIA
CREATE TABLE ExpertQuestions(
expQuestion_id INT PRIMARY KEY AUTO_INCREMENT,
user_id INT,
content varchar(1000) NOT NULL,
speciality VARCHAR(40) NOT NULL,
FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- MARINA
CREATE TABLE User_DonateMoney_Project(
user_id INT,
project_id INT,
amount INT,
type VARCHAR(40),
date DATE,
time TIME,
PRIMARY KEY(user_id,project_id),
FOREIGN KEY (project_id) references Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (user_id) references Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- DALIA
CREATE TABLE User_Volunteer_Project(
user_id INT,
project_id INT,
PRIMARY KEY(user_id,project_id),
FOREIGN KEY (project_id) references Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (user_id) references Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- DALIA
CREATE TABLE Volunteering_Days(
day_id INT PRIMARY KEY AUTO_INCREMENT,
project_id INT,
user_id INT,
day VARCHAR(40) NOT NULL,
FOREIGN KEY (project_id) references Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (user_id) references Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- MARINA
CREATE TABLE User_Follow_Project(
user_id INT,
project_id INT,
PRIMARY KEY(user_id,project_id),
FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- MARINA
CREATE TABLE User_DonateObject_Project(
user_id INT,
project_id INT,
object_id INT,
donated_quantity INT,
PRIMARY KEY(user_id,project_id,object_id),
FOREIGN KEY (project_id) references Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (user_id) references Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (object_id) references Objects(object_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- DALIA
CREATE TABLE NGO_DeclareSuccessStr_Project(
ngo_id INT,
project_id INT,
story VARCHAR(6000) NOT NULL,
PRIMARY KEY (ngo_id, project_id),
FOREIGN KEY (ngo_id) references NGOs(ngo_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (project_id) references Projects(project_id));

-- MARINA
CREATE TABLE SuccessStr_Photo(
photo_id INT AUTO_INCREMENT,
ngo_id INT,
project_id INT,
photo_url VARCHAR(500),
PRIMARY KEY (photo_id,ngo_id,project_id),
FOREIGN KEY (ngo_id) REFERENCES NGOs(ngo_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- MARINA
CREATE TABLE SuccessStr_Video(
video_id INT AUTO_INCREMENT,
ngo_id INT,
project_id INT,
video_url VARCHAR(500),
PRIMARY KEY (video_id,ngo_id,project_id),
FOREIGN KEY (ngo_id) REFERENCES NGOs(ngo_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- DALIA
CREATE TABLE NGO_Reject_Project(
ngo_id INT,
project_id INT,
PRIMARY KEY (ngo_id,project_id),
FOREIGN KEY (ngo_id) references NGOs(ngo_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (project_id) references Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- DALIA 
CREATE TABLE Project_Categories(
project_id INT,
category_id INT,
PRIMARY KEY(project_id,category_id),
FOREIGN KEY (category_id) references Category(category_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (project_id) references Projects(project_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- MARINA
CREATE TABLE User_Notification(
notification_id INT AUTO_INCREMENT,
user_id INT,
project_id INT,
notification_type VARCHAR(40),
notification_content VARCHAR(1000),
PRIMARY KEY (notification_id,user_id,project_id),
FOREIGN KEY (user_id) REFERENCES Users (user_id)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (project_id) REFERENCES Projects (project_id)
ON DELETE CASCADE ON UPDATE CASCADE);

-- MARINA
CREATE TABLE NGO_Notification(
notification_id INT AUTO_INCREMENT,
ngo_id INT,
project_id INT,
notification_type VARCHAR(40),
notification_content VARCHAR(1000),
PRIMARY KEY (notification_id,ngo_id,project_id),
FOREIGN KEY (ngo_id) REFERENCES NGOs (ngo_id)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (project_id) REFERENCES Projects (project_id)
ON DELETE CASCADE ON UPDATE CASCADE);

-- DALIA 
CREATE TABLE User_Answer_ExpertQuestion(
expQuestion_id INT,
expert_id INT,
answer VARCHAR(1000),
PRIMARY KEY(expQuestion_id,expert_id),
FOREIGN KEY (expQuestion_id) REFERENCES ExpertQuestions (expQuestion_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (expert_id) REFERENCES Users (user_id) ON DELETE CASCADE ON UPDATE CASCADE);






