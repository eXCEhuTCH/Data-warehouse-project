/*
=====================================================
DDL Script : create Gold views 
===========================
Scripts purpose
This script creates views for the gold layer in the data warehouse
the Gold layer represents the final dimension and the fact tables(star schema)

each view performs transformations and combines data from the silver layer to produce a clean, enriched and bussiness-ready dataset

usage:
-these views can be queried directly for reporting and analytics
===============================================================
*/
-
=================================================================
create dimension_customers
=================================================

if OBJECT_ID('gold.dim_customers','V') is NOT null
drop view gold.dim_customers;
go
create view  gold.dim_customers
as
SELECT 
row_number() over(order by ci.cst_id) as customer_key,
CI.CST_ID as customer_id,
CI.CST_KEY customer_number,
CI.cst_firstname as first_name,
CI.cst_lastname last_name,
la.CNTRY country,
CI.cst_marital_status marital_status,
CASE WHEN CI.CST_GNDR = 'n/a' then isnull(ca.gen,'n/a')
WHEN CI.CST_GNDR !=CA.GEN THEN CI.CST_GNDR
ELSE isnull(ci.cst_gndr,'n/a')
end as gender,
ca.BDATE as birthdate,
ci.cst_create_date as create_date
FROM SILVER.crm_cust_info AS CI
LEFT JOIN SILVER.erp_cust_az12 AS CA
ON CA.CID=CI.cst_key
LEFT JOIN SILVER.erp_loc_a101 AS LA
ON LA.CID=CI.cst_key 
  =====================================================
create dimension_products
  ==========================================

if OBJECT_ID('gold.dim_products','V') is NOT null
drop view gold.dim_customers;
go
create view gold.dim_products
AS
select 
row_number() over(order by pi.prd_id) as product_key,
pi.prd_id product_id,
pi.prd_key product_number,
pi.prd_nm as product_name,
pi.cat_id category_id,
cat.CAT as category,
cat.SUBCAT as subcategory,
cat.MAINTENANCE as maintenance,
pi.prd_cost,
pi.prd_line,
pi.prd_start_dt as start_date
from Silver.crm_prd_info as pi
left join silver.erp_px_cat_g1v2 as cat
on pi.cat_id=cat.id
where prd_end_dt is null
================================
create fact_sales
  ==============================

  if OBJECT_ID('gold.fact_sales','V') is NOT null
drop view gold.dim_customers;
go
create view gold.fact_sales
AS
select 
sd.sls_ord_num order_number,
p.product_key,
c.customer_key,
sd.sls_order_dt order_date,
sd.sls_ship_dt shipping_date,
sd.sls_due_dt due_date,
sd.sls_quantity quantity,
sd.sls_sales sales,
sd.sls_price
from silver.crm_sales_details as sd
left join gold.dim_customers c
on c.customer_id=sd.sls_cust_id
left join gold.dim_products as p
on sd.sls_prd_key=p.product_number;







