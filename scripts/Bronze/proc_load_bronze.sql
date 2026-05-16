/*
=======================================================
Stored Procedure: Load Bronze Layer (source--> bronze)
=====================================================
Script Purpose 
This srored procedure loads data into the 'bronze' schema from external csv files
It performs the following actions:
-Truncates the bronze tables before loading data.
---Uses the 'BULK INSERT' command to load data frim files to bronze tables.

Parameters;
none.
This stored procedure does not accept any parameters any value
Usage Example
EXEC bronze.load_bronze
=====================================================
*/

Create or Alter procedure bronze.load_bronze as
 Begin
 DECLARE @start_time as Datetime, @end_time as Datetime;
  bEGIN trY
         print '======================================================';
        print 'loading bronze layer';
        print '========================================'
        print '-----------------------------------------';
        print 'loading crm sources';
        print '-----------------------------------------'
        Set @start_time =getdate();
        print'>>truncating table: bronze.crm_cust_info';
         truncate table bronze.crm_cust_info;
         print'>>inserting table: bronze.crm_cust_info';
        BUlk insert bronze.crm_cust_info
        from 'C:\Users\bosur\Downloads\DATA WAREHOUSE\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        with
        ( 
        Firstrow =2 ,
        Fieldterminator= ',',
        Tablock
        );
        Set @end_time=getdate();
        print'>>> load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
        print'-----------------------------'
        Set @start_time =getdate();
        print'>>truncating table: bronze.crm_prd_info';
        truncate table bronze.crm_prd_info;
         print'>>inserting table: bronze.crm_prd_info';
        BUlk insert bronze.crm_prd_info
        from 'C:\Users\bosur\Downloads\DATA WAREHOUSE\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        with
        ( 
        Firstrow =2 ,
        Fieldterminator= ',',
        Tablock
        );
       Set @end_time=getdate();
        print'>>> load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
        print'-------------'
        Set @start_time =getdate();
         truncate table bronze.crm_sales_details
          print'>>inserting table:bronze.crm_sales_details';
        BUlk insert bronze.crm_sales_details
        from 'C:\Users\bosur\Downloads\DATA WAREHOUSE\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        with
        ( 
        Firstrow =2 ,
        Fieldterminator= ',',
        Tablock
        );
      
       Set @end_time=getdate();
        print'>>> load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';

        print 'loading erp sources';
        print '-----------------------------------------';

        print'>>truncating table:bronze.erp_cust_az12';
          Set @start_time =getdate();
         truncate table bronze.erp_cust_az12;
           print'>>inserting table:bronze.erp_cust_az12';
        BUlk insert bronze.erp_cust_az12
        from 'C:\Users\bosur\Downloads\DATA WAREHOUSE\sql-data-warehouse-project\datasets\source_erp\cust_Az12.csv'
        with
        ( 
        Firstrow =2 ,
        Fieldterminator= ',',
        Tablock
        );
              
       Set @end_time=getdate();
        print'>>> load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
        print'-----------------------------'
          Set @start_time =getdate();
        print'>>truncating table:bronze.erp_loc_a101';

         truncate table bronze.erp_loc_a101;
            print'>>inserting table:bronze.bronze.erp_loc_a101'
        BUlk insert bronze.erp_loc_a101
        from 'C:\Users\bosur\Downloads\DATA WAREHOUSE\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        with
        ( 
        Firstrow =2 ,
        Fieldterminator= ',',
        Tablock
        );
          Set @end_time=getdate();
        print'>>> load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
        print'-----------------------------';
          Set @start_time =getdate();
        print'>>truncating table:bronze.erp_px_cat_g1v2';

         truncate table bronze.erp_px_cat_g1v2;
            print'>>inserting table:bronze.bronze.erp_px_cat_g1v2'
        BUlk insert bronze.erp_px_cat_g1v2
        from 'C:\Users\bosur\Downloads\DATA WAREHOUSE\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        with
        ( 
        Firstrow =2 ,
        Fieldterminator= ',',
        Tablock
        );
          Set @end_time=getdate();
   print'>>> load duration:' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
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
