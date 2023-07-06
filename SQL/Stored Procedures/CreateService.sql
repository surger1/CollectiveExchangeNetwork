DELIMITER $$
DROP PROCEDURE IF EXISTS `CreateService` $$
CREATE PROCEDURE `CreateService`(IN name VARCHAR(255), IN description TEXT, IN creator_id INT, IN creator_type_id INT)
BEGIN
        -- Declare a variable to hold the ID of the newly created resource
    DECLARE service_id INT;

    -- Check if the creator_id corresponds to an existing entity
    IF NOT CheckEntityType(creator_id, creator_type_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Registering entity does not exist.';
    ELSE
        INSERT INTO `services`(`name`, `description`)
        VALUES (name, description);
		
		SELECT LAST_INSERT_ID() INTO service_id;
		
		INSERT INTO `services_logs`(`service_id`, `entity_id`, `entity_type`, `action`)
        VALUES (service_id, creator_id, creator_type, 'created');
    END IF;
END$$
DELIMITER ;
