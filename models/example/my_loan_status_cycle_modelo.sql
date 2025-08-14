/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/
{{ config(materialized="table") }}

WITH  SOURCE AS
(
   SELECT
        ROW_NUMBER() OVER (ORDER BY FD_MOVEMENT_DATE) as row_num
        ,FI_LIFE_CYCLE_ID 
	    ,FI_LOAN_ID 
	    ,FI_ADMIN_CENTER 
	    ,FC_STATUS 
	    ,FD_MOVEMENT_DATE 
	    ,FI_ID_STATUS 
	    ,FC_PAID_CHANNEL 
	    ,FC_LATITUDE 
	    ,FC_LONGITUDE
	    ,FC_IP_ADDRESS 
	    ,FD_INSERTION_DATE 
	    ,FC_USER 
	    ,FD_INSERTION_DATE_TOPIC 	
	    ,FB_DELETED_FLAG 
    FROM
        DATABASE_DBT.DBT_MMORALES.TA_LOAN_LIFE_CYCLE
    WHERE NVL(FI_LOAN_ID,0) > 0  

)  SELECT 
         ROW_NUM
        ,FI_LIFE_CYCLE_ID 
	    ,FI_LOAN_ID 
	    ,FI_ADMIN_CENTER 
	    ,FC_STATUS 
	    ,FD_MOVEMENT_DATE 
	    ,FI_ID_STATUS 
	    ,FC_PAID_CHANNEL 
	    ,FC_LATITUDE 
	    ,FC_LONGITUDE
	    ,FC_IP_ADDRESS 
	    ,FD_INSERTION_DATE 
	    ,FC_USER 
	    ,FD_INSERTION_DATE_TOPIC 	
	    ,FB_DELETED_FLAG  
   FROM  SOURCE
   ORDER BY FI_LOAN_ID, FD_MOVEMENT_DATE
