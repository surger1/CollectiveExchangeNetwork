DELIMITER $$
DROP PROCEDURE IF EXISTS `RegisterOrganization` $$
CREATE PROCEDURE `RegisterOrganization`(IN name VARCHAR(255), IN description TEXT, IN register_id INT, IN register_type INT)
BEGIN
	-- Declare a variable to hold the ID of the newly created organization
	DECLARE organization_id INT;

	-- Check if the creator_id corresponds to an existing entity
    IF NOT CheckEntityType(register_id, register_type) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Registering entity does not exist.';
    ELSE
		-- Insert the new organization into the `organization` table
		INSERT INTO `organization`(`name`, `description`)
		VALUES (name, description);

		-- Set the organization_id variable to the ID of the newly inserted organization
		SELECT LAST_INSERT_ID() INTO organization_id;

		-- Record the creation of the organization in the `organization_log` table
		INSERT INTO `organization_log` (`organization_id`, `collaborator_id`, `collaborator_type`, `action`)
		VALUES (organization_id, register_id, register_type, 'Registered Organization');
	END IF;
END$$
DELIMITER ;
