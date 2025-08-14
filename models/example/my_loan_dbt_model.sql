/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/
{{ config(materialized="table") }}

with
    source_data as (

 SELECT  NVL(TRY_TO_NUMBER(RECORD_CONTENT:operation:loan:balance:financeCharge::VARCHAR,8,2),0) as FN_FINANCE_CHARGE,    
               NVL(TRY_TO_NUMBER(bo.value:additionalChargeBalance::varchar,8,2),0) as FN_ADDITIONAL_CHARGEBALANCE, 
               NVL(TRY_TO_NUMBER(de.value:conceptId::varchar,8,2),0) as FC_CONCEPTID, ---add
               NVL(TRY_TO_NUMBER(de.value:itemAmount::varchar,8,2),0) as FI_ITEMAMOUNT, ---add
               NVL(TRY_TO_NUMBER(RECORD_CONTENT:operation:loan:balance:principal::varchar,8,2),0) as FN_PRINCIPAL_BALANCE ,
               NVL(TRY_TO_NUMBER(RECORD_CONTENT:operation:loan:balance:additionalCharge::varchar,8,2),0) as FN_ADDITIONAL_CHARGE,
               NVL(TRY_TO_NUMBER(RECORD_CONTENT:operation:loan:id::varchar,15,0),0) FI_LOAN_ID,
               NVL(TRY_TO_NUMBER(RECORD_CONTENT:operation:loan:adminCenterId::varchar,10,0),0) FI_ADMIN_CENTER,
               1 FI_ID_STATUS,
               null FC_PAID_CHANNEL,
               RECORD_CONTENT:operation:eventDetail:gpsLatitude::VARCHAR(20)	 FC_LATITUDE,
               RECORD_CONTENT:operation:eventDetail:gpsLongitude::VARCHAR(20)	 FC_LONGITUDE,
               RECORD_CONTENT:operation:eventDetail:ipAddress::VARCHAR(15)	 FC_IP_ADDRESS,
               CURRENT_TIMESTAMP FD_INSERTION_DATE,
               CURRENT_USER FC_USER,
               INSERTED_AT FD_INSERTION_DATE_TOPIC,                                         
               FALSE FB_DELETED_FLAG                
         FROM DATABASE_DBT.DBT_MMORALES.TP_CC_LOAN_V1_OPERATION_ADD_2,
      LATERAL FLATTEN(input => RECORD_CONTENT:operation.loan.balanceOperations) AS bo, 
      LATERAL FLATTEN(input => bo.value:details) AS de 
        WHERE INSERTED_AT >  '{{ var('start_date') }}'
          AND INSERTED_AT <= CURRENT_TIMESTAMP()
          AND NVL(TRY_TO_NUMBER(RECORD_CONTENT:operation:loan:id::varchar,15,0),0)  > 0
    )

select *
from source_data
