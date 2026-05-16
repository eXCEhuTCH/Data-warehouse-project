/*
=====================================================
DDL Script: Create Bronze Tables
==============================================
Script purose:
This script create in the tables in the 'bronze' shema, dropping existing tables
if they already exist 
Run this script to redefine the DDL structure of 'bronze' Tables
*/


--Table creating
if object_id( 'Bronze.crm_cust_info', 'U') is not null
drop table Bronze.crm_cust_info;

create table Bronze.crm_cust_info
(
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date
);

if object_id( 'bronze.crm_prd_info', 'U') is not null
drop table bronze.crm_prd_info;


create table bronze.crm_prd_info
(
	prd_id int
	,prd_key nvarchar(50)
	,prd_nm nvarchar(50)
	,prd_cost int
	,prd_line nvarchar(50)
	,prd_start_dt DateTime
	,prd_end_dt DAtetime

);
	if object_id( 'bronze.crm_sales_details', 'U') is not null
drop table bronze.crm_sales_details;

create Table bronze.crm_sales_details
(
	sls_ord_num nvarchar(70),
	sls_prd_key nvarchar(60),
	sls_cust_id int,
	sls_order_dt nvarchar(50),
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price int

 )

 if object_id( 'bronze.erp_Cust_AZ12', 'U') is not null
drop table bronze.erp_Cust_AZ12;


 Create Table bronze.erp_cust_az12
 (

 CID nvarchar(50),
 BDATE date,
 GEN nvarchar(50)
 );
 
if object_id( 'bronze.erp_LOC_A101', 'U') is not null
drop table bronze.erp_LOC_A101;
 create Table bronze.erp_loc_a101
 (CID nvarchar(50),
 CNTRY nvarchar(50)
 );

 	if object_id( 'bronze.erp_PX_CAT_G1V2', 'U') is not null
drop table bronze.erp_PX_CAT_G1V2;

 Create Table bronze.erp_px_cat_g1v2
 (
 ID nvarchar(50),
 CAT Nvarchar(50),
 SUBCAT nvarchar(60),
 MAINTENANCE nvarchar(50)
 );

