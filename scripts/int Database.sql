/* 
=========================================================================
Create Database  and Schemas
===========================================================
Scripts Purpose:
This Scripts creates a new database named 'DataWarehouse' after if it already exists.
If the database exits, it is dropped and recreated, Additionally, the scripts sets up three schemas
within the database 'Bronze','Silver' and 'Gold'.


Warning:
Running this will drop the entire 'DataWarehouse' Database if it exists.
All data in the database willl be permanently deleted. proceed with caution 
and ensure you have proper backups before running this scripts.
*/
Use Master

GO
-- Drop and recreate the 'DataWarehouse' database
IF exists (select 1 from sys.databases where name ='DataWarehouse')
Begin
Alter Database DataWarehouse set SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE Database;
end;
GO
--Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO
USe Datawarehouse
go

--Creating schemas
create schema Bronze;
Go
create schema Silver;
GO
create schema Gold;
GO
