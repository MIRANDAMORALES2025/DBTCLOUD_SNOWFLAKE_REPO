{{ config(materialized='ephemeral') }}

WITH data AS (
    SELECT 1 AS id, 'Producto A' AS name, 150 AS amount
    UNION ALL
    SELECT 2, 'Producto B', 50
    UNION ALL
    SELECT 3, 'Producto C', 200
)

SELECT
    id,
    name,
    amount,
    CASE WHEN amount > 100 THEN 'High' ELSE 'Low' END AS amount_category
FROM data
--left join {{ this }} on {{ this }}.id = data.id