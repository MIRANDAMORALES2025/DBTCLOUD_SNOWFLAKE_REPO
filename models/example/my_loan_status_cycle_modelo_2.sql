/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/
{{ config(materialized="table") }}

WITH  SOURCE AS
(
   SELECT ROW_NUM, FI_LOAN_ID,FD_MOVEMENT_DATE
     FROM {{ ref('my_loan_status_cycle_modelo') }}


)  SELECT row_num  N , FI_LOAN_ID, FD_MOVEMENT_DATE
   FROM  SOURCE 
   