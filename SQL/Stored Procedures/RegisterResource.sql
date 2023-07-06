DELIMITER $$
DROP PROCEDURE IF EXISTS `CreateResource` $$
CREATE PROCEDURE `CreateResource`(IN name VARCHAR(255), IN description TEXT, IN register_id INT, IN register_type INT)
BEGIN
    -- Declare a variable to hold the count of users matching the provided owner_id
    DECLARE userCount INT;

    -- Check if the owner_id corresponds to an existing user
    IF NOT CheckEntityType(register_id, register_type) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Registering entity does not exist.';
    ELSE
        INSERT INTO `resources`(`name`, `description`, `owner_id`, `status`)
        VALUES (name, description, owner_id, 'not on offer');
		
		INSERT INTO `resources_logs`(`name`, `description`, `owner_id`, `status`)
        VALUES (name, description, owner_id, 'not on offer');
    END IF;
END$$
DELIMITER ;
