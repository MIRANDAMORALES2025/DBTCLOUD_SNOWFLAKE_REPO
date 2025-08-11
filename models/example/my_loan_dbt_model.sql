/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/
{{ config(materialized="table") }}

with
    source_data as (

        select
            nvl(
                try_to_number(
                    record_content:operation:loan:balance:financecharge::varchar, 8, 2
                ),
                0
            ) as fn_finance_charge,
            nvl(
                try_to_number(bo.value:additionalchargebalance::varchar, 8, 2), 0
            ) as fn_additional_chargebalance,
            nvl(
                try_to_number(
                    record_content:operation:loan:balance:principal::varchar, 8, 2
                ),
                0
            ) as fn_principal_balance,
            nvl(
                try_to_number(
                    record_content:operation:loan:balance:additionalcharge::varchar,
                    8,
                    2
                ),
                0
            ) as fn_additional_charge,
            nvl(
                try_to_number(record_content:operation:loan:id::varchar, 15, 0), 0
            ) fi_loan_id,
            nvl(
                try_to_number(
                    record_content:operation:loan:admincenterid::varchar, 10, 0
                ),
                0
            ) fi_admin_center,
            1 fi_id_status,
            null fc_paid_channel,
            record_content:operation:eventdetail:gpslatitude::varchar(20) fc_latitude,
            record_content:operation:eventdetail:gpslongitude::varchar(20) fc_longitude,
            record_content:operation:eventdetail:ipaddress::varchar(15) fc_ip_address,
            current_timestamp fd_insertion_date,
            current_user fc_user,
            inserted_at fd_insertion_date_topic,
            false fb_deleted_flag
        from
            database_dbt.dbt_mmorales.tp_cc_loan_v1_operation_add_2,
            lateral flatten(
                input => record_content:operation.loan.balanceoperations
            ) as bo
        where
            inserted_at > {{ var("start_date") }}
            and inserted_at <= current_timestamp()
            and nvl(try_to_number(record_content:operation:loan:id::varchar, 15, 0), 0)
            > 0

    )

select *
from source_data
