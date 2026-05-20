/*
=======================================================
Stored Procedure: Load silver Layer (source--> bronze)
=====================================================
Script Purpose 
This srored procedure loads data into the 'silver' schema from bronze schema
It performs the following actions:
-Truncates the silver tables before loading data.
-insert data into silver schema from th bronze schema

Parameters;
none.
This stored procedure does not accept any parameters any value
Usage Example:
EXEC bronze.load_silver
=====================================================
*/

Create or Alter procedure SILVER.load_bronze as
     Begin
     DECLARE @start_time as Datetime, @end_time as Datetime;
      bEGIN TRY
            print '======================================================';
            print 'loading silver layer';
            print '========================================'
            print '-----------------------------------------';
            print 'loading crm sources';
            print '-----------------------------------------'
            Set @start_time =getdate();
            print'>>truncating table: silver.crm_cust_info';
    TRUNCATE TABLE silver.crm_cust_info;
    print'>>inserting table: silver.crm_cust_info';
    insert into silver.crm_cust_info
    (cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr,cst_create_date)
    select 
    cst_id,
    cst_key,
    trim(cst_firstname) cst_firstname,
    trim(cst_lastname) cst_lastname,
    case when cst_marital_status ='S' then 'Single '
    when cst_marital_status = 'M' then 'Married'
    when cst_marital_status is null then 'n/a'
    end as cst_marital_status,
    case 
    cst_gndr
    when 'M' then 'Male' when  'F' then 'Female'  else 'n/a'
    end as cst_gndr,
    cst_create_date
    from 
    (
    select *,
    row_number() over(partition by cst_id order by cst_create_date desc) as flag
    from bronze.crm_cust_info
    where  cst_id is  not null
    )t
    
    where flag =1
    Set @end_time=getdate();
            print'>>> load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
            print'-----------------------------'
    PRINT'TABLE silver.erp_cust_az12'
    print'-------------------'
    
     Set @start_time =getdate();
            print'>>truncating table: silver.erp_cust_az12';
    TRUNCATE TABLE silver.erp_cust_az12
    print'>>inserting table:  silver.erp_cust_az12';
    insert into silver.erp_cust_az12
    (
    cid,
    bdate,
    GEN
    )
    
    select 
    case when cid like 'nas%' then substring(cid,4,len(cid)) else cid end cid,
    case when bdate > getdate() then null else BDATE end as bdate,
    case when upper(trim(gen)) = 'F' or upper(trim(gen))= 'FEMALE' then 'Female'
    when upper(trim(gen)) in('M','MALE') then 'Male'
    else 'n/a'
    end gen
    from
     Bronze.[erp_cust_az12]
    
     Set @end_time=getdate();
            print'>>> load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
            print'-----------------------------'
    
     PRINT'silver.crm_prd_info'
    PRINT'================================'
     Set @start_time =getdate();
     print'>>truncating table:silver.crm_prd_info';
    TRUNCATE TABLE silver.crm_prd_info
    print'>>inserting table: silver.crm_prd_info';
    insert into silver.crm_prd_info
    (
    	prd_id,
    	cat_id
    	,prd_key 
    	,prd_nm 
    	,prd_cost 
    	,prd_line 
    	,prd_start_dt 
    	,prd_end_dt 
    	)
    select 
    prd_id,
    Replace(Left(Upper(prd_key),5),'-','_') as cat_id,
     substring(prd_key,7,len(prd_key)) as prd_key,
    prd_nm,
    coalesce(prd_cost,0)  as prd_cost,
    case trim(upper(prd_line))
    when  'M' then 'Mountains'
    when 'R'then 'Roads'
    when 'S' then 'other sales'
    when 'T' then 'Touring'
    when  null then 'n/a'
    end  as prd_line,
    prd_start_dt,
    lead(prd_start_dt) over(partition by prd_key order by prd_start_dt) -1 as prd_end_dt
    from bronze.crm_prd_info
    Set @end_time=getdate();
            print'>>> load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
            print'-----------------------------'
    
    		 Set @start_time =getdate();
     print'>>truncating table: silver.crm_sales_details';
    PRINT'========================================='
    TRUNCATE TABLE silver.crm_sales_details
    print'>>inserting table: silver.crm_sales_details';
    insert into silver.crm_sales_details
    (
    	sls_ord_num,
    	sls_prd_key ,
    	sls_cust_id ,
    	sls_order_dt,
    	sls_ship_dt ,
    	sls_due_dt ,
    	sls_sales ,
    	sls_quantity,
    	sls_price)
    select 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    case when sls_order_dt <=0 then null
    when len(sls_order_dt) !=8 then null else
    cast(cast(sls_order_dt as varchar) as date)  end sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    case when 
    sls_sales is   null  or sls_sales  <=0 or sls_sales !=  abs(sls_quantity) * abs(
    case when sls_price is null or sls_price <=0 then abs(sls_sales)/abs(sls_quantity)
    else sls_price end)
    then abs(sls_quantity) * abs(
    case when sls_price is null or sls_price <=0 then abs(sls_sales)/abs(sls_quantity)
    else sls_price end)
    else abs(sls_sales)
    end as sls_sales,
    sls_quantity,
    case when sls_price is null or sls_price <=0 then abs(sls_sales)/abs(sls_quantity)
    else sls_price end as sls_price
    from bronze.crm_sales_details
    Set @end_time=getdate();
            print'>>> load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
            print'-----------------------------'
    		 Set @start_time =getdate();
     print'>>truncating table: silver.erp_loc_a101';
    PRINT'TABLE  silver.erp_loc_a101;'
    TRUNCATE TABLE  silver.erp_loc_a101;
    print'>>inserting table: silver.erp_loc_a101';
    insert into silver.erp_loc_a101 (
    cid,
    cntry)
    
    select replace(cid,'-','') as cid,
    case when trim(CNTRY) ='DE' or trim(cntry)= 'Germany' then 'Germany'
    when trim(cntry) in('US','United States','USA') then 'United States'
    when trim(cntry) is null or trim(cntry)='' then 'n/a'
    else CNTRY 
    end cntry
    from bronze.erp_loc_a101
    
    Set @end_time=getdate();
            print'>>> load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
            print'-----------------------------'
    PRINT'=========================='
    PRINT' TABLE silver.erp_px_cat_g1v2'
     Set @start_time =getdate();
     print'>>truncating table: silver.crm_cust_info';
    TRUNCATE TABLE silver.erp_px_cat_g1v2
    print'>>inserting table: silver.erp_px_cat_g1v2';
    insert into silver.erp_px_cat_g1v2
    (
    ID,
    CAT,
    SUBCAT,
    MAINTENANCE)
    select ID,
    CAT,
    SUBCAT,
    MAINTENANCE
    from Bronze.erp_px_cat_g1v2
    Set @end_time=getdate();
            print'>>> load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
            print'-----------------------------'
               print'-----------------------------';
      end try
      Begin Catch
      print '============================================';
      print'ERROR OCCURED WHEN LOADING BRONZE LAYER';
      PRINT'ERROR MESSAGE' + ERROR_MESSAGE();
      PRINT'ERROR MESSAGE' + CAST (ERROR_NUMBER() AS NVARCHAR(20));
   PRINT 'ERROR MESSAGR' + CAST(ERROR_STATE() AS NVARCHAR(20));
     print '============================================';
  end catch
END;
