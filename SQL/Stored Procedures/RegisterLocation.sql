DELIMITER $$
DROP PROCEDURE IF EXISTS `RegisterLocation` $$
CREATE PROCEDURE `RegisterLocation`(IN name VARCHAR(255), IN description TEXT, IN `address` TEXT, IN register_id INT, IN register_type INT, IN parent_location_id INT)
BEGIN
	DECLARE location_id INT;
	
    IF NOT CheckEntityType(register_id, register_type) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Registering entity does not exist.';
    ELSE
        INSERT INTO `locations`(`name`, `description`, `address`, `parent_location_id`)
        VALUES (name, description, address, parent_location_id);
	
	    SELECT LAST_INSERT_ID() INTO location_id;
	
	    INSERT INTO `locations_logs` (`location_id`, `register_id`, `register_type`, `action`)
	    VALUES (location_id, register_id, register_type, 'Registered Location');
    END IF;
END$$
DELIMITER ;
