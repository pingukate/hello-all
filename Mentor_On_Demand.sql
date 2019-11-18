
--Database Creation--

create database Mentor_On_Demand

--Implementing script on Database--
use Mentor_On_Demand

--Table Creation--

--User Table--

create table [user]
(
us_Id int identity(1000,1) primary key,
us_Username nvarchar(50) unique not null,
us_Password nvarchar(50) not null,
us_FirstName nvarchar(30) not null,
us_LastName nvarchar(30) not null,
us_ContactNumber bigint not null,
us_Reg_DateTime datetime not null,
us_Reg_Code nvarchar(10) null,
us_Force_Reset_Password nvarchar(100) null,
us_Active nvarchar(10) null
)

ALTER TABLE [user]
ADD CONSTRAINT us_defaultConstraint 
DEFAULT '7777' FOR us_Reg_Code;

ALTER TABLE [user]
ADD CONSTRAINT us_defaultActive 
DEFAULT 'true' FOR us_Active;

ALTER TABLE [user]
ADD CONSTRAINT us_defaultforceReset 
DEFAULT 'false' FOR us_Force_Reset_Password;


--Mentor Table--

create table [mentor]
(
me_Id int identity(1000,1) primary key,
me_Username nvarchar(50) unique not null,
me_Password nvarchar(50) not null,
me_LinkedinURL nvarchar(100) not null,
me_Reg_DateTime datetime not null,
me_Reg_Code nvarchar(10) null,
me_Years_Of_Experience int null,
me_Active nvarchar(10) null
)

ALTER TABLE [mentor]
ADD CONSTRAINT me_defaultConstraint 
DEFAULT '9999' FOR me_Reg_Code;

ALTER TABLE [mentor]
ADD CONSTRAINT me_defaultActive 
DEFAULT 'true' FOR me_Active;

--Skill Table--

create table [skills]
(
sk_Id int identity(1000,1) primary key,
sk_Name nvarchar(50) unique not null,
sk_TOC nvarchar(50) not null,
sk_Duration int not null,
sk_Prerequistes nvarchar(50) null
)

--Mentor Skills--

create table [mentor_skills]
(
ms_Id int identity(1000,1) primary key,
ms_mId int,
ms_sId int,
ms_SelfRating decimal(3,1),
ms_Years_Of_Experience int,
ms_Training_Delivered int,
ms_Facilities_Offered nvarchar(100),
constraint [ms_me_FK] foreign key (ms_mId)
references [mentor] (me_Id),
constraint [ms_us_FK] foreign key (ms_sId)
references [skills] (sk_Id)
)

--Training Table--

create table [training]
(
tr_Id int identity(1000,1) primary key,
tr_uId int,
tr_mId int,
tr_sId int,
tr_Status nvarchar(20),
constraint [tr_me_FK] foreign key (tr_mId)
references [mentor] (me_Id),
constraint [tr_us_FK] foreign key (tr_uId)
references [user] (us_Id),
constraint [tr_sk_FK] foreign key (tr_sId)
references [skills] (sk_Id),
)

ALTER TABLE [training]
ADD CONSTRAINT tr_DefaultStatus 
DEFAULT 'Pending' FOR tr_Status;

--Admin Table--
create table [admin]
(
ad_Id int identity(1000,1) primary key,
ad_Username nvarchar(50),
ad_Password nvarchar(50)
);



--Creating Store Procedures--

--List of technologies/Skills store procedure--

create procedure skillsList with encryption
as
select * from [skills];

exec skillsList;

--User Selecting the mentor for training--

create procedure mentorSelection @uid int, @mid int, @sid int
as
insert into [training](tr_uId,tr_mId,tr_sId) values (@uid,@mid,@sid);

exec mentorSelection 1000,1000,1000

--Get all the mentors details

create procedure mentorsDetails
as
select *
from [mentor] m , [mentor_skills] ms ,[skills] s
where m.me_Id = ms.ms_mId and ms.ms_sId = s.sk_Id

--view user nomination of mentor--

create procedure trainingList @mid int
as
select t.tr_Id, u.us_FirstName,u.us_LastName,s.sk_Name,s.sk_Duration
from [training] t ,[user] u , [skills] s
where t.tr_sId = s.sk_Id and t.tr_uId = u.us_Id and t.tr_mId = @mid

exec trainingList 1000

--login--
--user login--

create procedure userLogin @username nvarchar(50),@password nvarchar(50) with encryption
as 
select * 
from [user]
where us_Username = @username and us_Password = @password and us_Active = 'true'

exec userLogin 'monica@gmail.com' ,'monica'

--mentor login--

create procedure mentorLogin @username nvarchar(50),@password nvarchar(50) with encryption
as
select *
from [mentor]
where me_Username =@username and me_Password = @password and me_Active = 'true'

exec mentorLogin 'pranjalprasun@gmail.com', 'pranjal@1'

--Admin Login--

create procedure adminLogin @username nvarchar(50), @password nvarchar(50) with encryption
as
select * 
from [admin]
where ad_Username =@username and ad_Password = @password 

exec adminLogin 'admin','password'

--SignUp procedure-

--User Registration--

create procedure userRegistration @username nvarchar(50),@password nvarchar(50),@firstname nvarchar(30),@lastname nvarchar(30),@contactno bigint,@regdatetime datetime
as
insert into [user](us_Username,us_Password,us_FirstName,us_LastName,us_ContactNumber,us_Reg_DateTime) values (@username,@password,@firstname,@lastname,@contactno,@regdatetime)

exec userRegistration 'manoj@gmail.com','manoj','Manoj','Darsi',7938504236,'02-02-2015 02:45:00 PM'

--Mentor registration--

create procedure mentorRegistration @username nvarchar(50),@password nvarchar(50),@linkedinURL nvarchar(100),@regdatetime datetime,@yearsExp int
as
insert into [mentor](me_Username,me_Password,me_LinkedinURL,me_Reg_DateTime,me_Years_Of_Experience) values(@username,@password,@linkedinURL,@regdatetime,@yearsExp)

exec mentorRegistration 'sankari@gmail.com','sankari','linkedin.com/sankari','04-04-2016 04:56:00 PM',7