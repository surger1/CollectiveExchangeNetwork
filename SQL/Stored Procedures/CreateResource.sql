DELIMITER $$
DROP PROCEDURE IF EXISTS `CreateResource` $$
CREATE PROCEDURE `CreateResource`(IN name VARCHAR(255), IN description TEXT, IN creator_id INT, IN creator_type INT)
BEGIN
    -- Declare a variable to hold the ID of the newly created resource
    DECLARE resource_id INT;

    -- Check if the creator_id corresponds to an existing entity
    IF NOT CheckEntityType(register_id, register_type) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Registering entity does not exist.';
    ELSE
        INSERT INTO `resources`(`name`, `description`)
        VALUES (name, description);
		
		SELECT LAST_INSERT_ID() INTO resource_id;
		
		INSERT INTO `resources_logs`(`resource_id`, `entity_id`, `entity_type`, `action`)
        VALUES (resource_id, creator_id, creator_type, 'created');
    END IF;
END$$
DELIMITER ;
