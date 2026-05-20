/*
=====================================================
DDL Script: Create silver Tables
==============================================
Script purose:
This script create in the tables in the 'silver' shema, dropping existing tables
if they already exist 
Run this script to redefine the DDL structure of 'silver' Tables
*/

if object_id( 'silver.crm_cust_info', 'U') is not null
drop table silver.crm_cust_info;

create table silver.crm_cust_info
(
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date,
  dwh_creation_date datetime2 default getdate()
);

if object_id( 'silver.crm_prd_info', 'U') is not null
drop table silver.crm_prd_info;
create table silver.crm_prd_info
(
	prd_id int,
  cat_id,
	,prd_key nvarchar(50)
	,prd_nm nvarchar(50)
	,prd_cost int
	,prd_line nvarchar(50)
	,prd_start_dt Date
	,prd_end_dt Date,
  dwh_creation_date datetime2 default getdate()
);
	if object_id( 'silver.crm_sales_details', 'U') is not null
drop table silver.crm_sales_details;
create Table silver.crm_sales_details
(
	sls_ord_num nvarchar(70),
	sls_prd_key nvarchar(60),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price int
 dwh_creation_date datetime2 default getdate()

 )
 if object_id( 'silver.erp_Cust_AZ12', 'U') is not null
drop table silver.erp_Cust_AZ12;
 Create Table silver.erp_cust_az12
 (
 CID nvarchar(50),
 BDATE date,
 GEN nvarchar(50),
dwh_creation_date datetime2 default getdate()
 );

if object_id( 'silver.erp_LOC_A101', 'U') is not null
drop table silver.erp_LOC_A101;
 create Table silver.erp_loc_a101
 (CID nvarchar(50),
 CNTRY nvarchar(50),
dwh_creation_date datetime2 default getdate()
 );
 	if object_id( 'silver.erp_PX_CAT_G1V2', 'U') is not null
drop table silver.erp_PX_CAT_G1V2;
 Create Table silver.erp_px_cat_g1v2
 (
 ID nvarchar(50),
 CAT Nvarchar(50),
 SUBCAT nvarchar(60),
 MAINTENANCE nvarchar(50),
dwh_creation_date datetime2 default getdate()
 );
