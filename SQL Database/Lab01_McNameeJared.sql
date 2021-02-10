--Jared McNamee
--Dec 1 2019
--Lab 01 Rider DB

--Database Deletion
--=========================================================
--use [master]
--go

--drop database if exists jmcnamee1_lab01
--go
--=========================================================
--Database Creation
--=========================================================
--create database jmcnamee1_lab01
--go
--=========================================================
--Table Deletion
--=========================================================
--drop table if exists Sessions

--drop table if exists Bikes

--drop table if exists Riders

--drop table if exists Class
--go
--=========================================================
--Table Creation
--=========================================================
--create table Class
--(
--	--Field Specs
--	ClassID nchar(6) not null ,
--	ClassDescription nvarchar(50) not null,
--	--Table Constraints
--	constraint pk_Class_ClassID primary key (ClassID)
--)

--create table Riders
--(
--	--Field Specs
--	RiderID int not null identity(10,1),
--	Name nvarchar(50) not null,
--	ClassID nchar(6),
--	--Constraints
--	constraint chk_Rider_Name check(len(Name) > 4),
--	--Table Constraints
--	constraint pk_Riders_RiderID primary key(RiderID),
--	constraint fk_Riders_Class foreign key (ClassID)
--	references Class (ClassID) on delete no action
--)

--create table Bikes
--(
--	--Field Specs
--	BikeID nchar(6) not null,
--	StableDate date not null default GetDate(),
--	--Constraints
--	constraint chk_Bikes_BikeID check(BikeID like '[0-9][0-9][0-9][HYS]-[AP]'),
--	--Table Constraints
--	constraint pk_Bikes_BikeID primary key (BikeID)
--)

--create table Sessions
--(
--	--Field Specs
--	RiderID int not null,
--	BikeID nchar(6) not null,
--	SessionDate datetime not null,
--	Laps int,
--	--Constraints
--	constraint chk_Session_Date check(SessionDate > '1 Sep 2019'),
--	--Table Constraints
--	constraint pk_Session_Date_Laps primary key (RiderID, BikeID, SessionDate)
--)

----Create Sessions Index
--create index NCI_RiderID_BikeID on Sessions(RiderID,BikeID)
--go

----Alters to the Session Table

----Generic Constraint adds
--alter table Sessions
--add constraint ck_Sessions_Laps check(Laps >= 10)

----Table Constraint adds
--alter table Sessions
--add constraint fk_Sessions_Riders foreign key (RiderID)
--references Riders (RiderID) on delete no action

--alter table Sessions
--add constraint fk_Sessions_Bikes foreign key (BikeID)
--references Bikes (BikeID) on delete no action
----=========================================================



