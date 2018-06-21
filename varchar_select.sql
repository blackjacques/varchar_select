CREATE DEFINER=`root`@`localhost` PROCEDURE `varchar_select`(IN p_schema_name varchar(50), IN p_table_name varchar(50))
    READS SQL DATA
BEGIN
  DECLARE p_sql VARCHAR(255) DEFAULT "SELECT ";
  DECLARE num_rows INT DEFAULT 0;
	DECLARE i INT DEFAULT 0;
  DECLARE col_name VARCHAR(50);
	DECLARE col_type VARCHAR(50);
	
  DECLARE col_names CURSOR FOR
  SELECT column_name, column_type
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = p_schema_name 
	AND table_name = p_table_name
  ORDER BY ordinal_position;
	
	OPEN col_names;
	select FOUND_ROWS() into num_rows;
 
	SET i = 1;
	the_loop: LOOP

		IF i > num_rows THEN
				CLOSE col_names;
				LEAVE the_loop;
		END IF;

		FETCH col_names INTO col_name, col_type;     

	  SET p_sql = IF(col_type LIKE 'varchar%', 
		              CONCAT(p_sql, 'CONCAT(\'"\',',col_name, ',\'"\') AS ',col_name, ','),
									CONCAT(p_sql, col_name, ',')
		            );

		SET i = i + 1;  
	END LOOP the_loop;
	
	SET p_sql = CONCAT(TRIM(TRAILING ',' FROM p_sql), ' FROM ', p_table_name);
	
	SET @sqlv = p_sql;
	PREPARE stmt1 FROM @sqlv;
  EXECUTE stmt1;
  DEALLOCATE PREPARE stmt1;
END