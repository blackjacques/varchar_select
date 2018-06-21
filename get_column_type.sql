CREATE DEFINER=`root`@`localhost` 
  FUNCTION `get_column_type`(p_table_name VARCHAR(50), p_column_name VARCHAR(50)) 
    RETURNS varchar(20) CHARSET utf8
    READS SQL DATA
    DETERMINISTIC
BEGIN
  DECLARE p_column_type VARCHAR(20);
	
	SELECT DATA_TYPE 
	FROM   INFORMATION_SCHEMA.COLUMNS
	WHERE  TABLE_SCHEMA = 'sakila'
	AND    TABLE_NAME   = p_table_name 
	AND    COLUMN_NAME  = p_column_name into p_column_type;
	
	RETURN p_column_type;
END