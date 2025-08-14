

{{

  config(      
    
    target_schema='snapshots',      
    strategy='check',   
    unique_key='id',      
    check_cols=['nombre','apellido'] 
    
    )  
}}  

  select 1 as id, 'Lupillo' as nombre, 'Rivera' apellido
  union all
  select 2 as id, 'Lucy' as nombre, 'Gallegos' apellido
  union all
  select 3 as id, 'Blacky' as nombre, 'Cat' apellido
  union all
  select 2 as id, 'Lucy' as nombre, 'Ramos' apellido

  

