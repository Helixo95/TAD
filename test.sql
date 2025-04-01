

SELECT owner, table_name
FROM all_tables
WHERE owner = 'C##NEW_SYS' OR 
      owner = 'C##WITNESS' OR
      owner = 'C##IMPROVEMENT'
ORDER BY owner, table_name
;


SELECT * 
FROM (SELECT table_name
        FROM all_tables) 
WHERE table_name = 'ORDINATEURS';

SELECT column_name, data_type, data_length
FROM all_tab_columns
WHERE table_name = 'ORDINATEURS'
ORDER BY column_id;


DESCRIBE ORDINATEURS;