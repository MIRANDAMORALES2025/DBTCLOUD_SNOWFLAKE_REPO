{{ config(
    materialized='incremental',
    unique_key='id',
    merge_exclude_columns = ['created_at'],
    tags = ['prueba']
) }}

WITH data AS (
    SELECT 1 AS id, 'Producto A' AS name, 150 AS amount, '2024-01-01'::date AS fecha
    UNION ALL
    SELECT 2, 'Producto B', 50, '2024-01-02'::date
    UNION ALL
    SELECT 3, 'Producto C', 230, '2024-01-03'::date
    UNION ALL
    SELECT 4, 'Producto D', 220, '2024-02-03'::date
    UNION ALL
    SELECT 5, 'Producto E', 100, '2024-02-04'::date
    UNION ALL
    SELECT 6, 'Producto H', 120, '2024-02-05'::date
    UNION ALL
    SELECT 6, 'Producto H', 120, '2024-02-05'::date
    UNION ALL
    SELECT 6, 'Producto H', 120, '2024-02-08'::date
    UNION ALL
    SELECT 16, 'Producto H', 120, '2024-02-08'::date
),


new_records AS (
    SELECT
        d.id,
        d.name,
        d.amount,
        d.fecha,
        CURRENT_TIMESTAMP AS created_at,
        CURRENT_TIMESTAMP AS updated_at,
        d.fecha AS stated_date,
        '9999-12-31'::date AS end_date
    FROM data d
)


SELECT
    id::number(38) as id,
    upper(name) as name,
    amount,
    fecha,
    created_at,
    updated_at,
    stated_date,
    end_date
FROM new_records

--{% if is_incremental() %}
--WHERE fecha > (SELECT MAX(fecha) FROM {{ this }})
--{% endif %}