DELIMITER $$
DROP PROCEDURE IF EXISTS `CreateProject` $$
CREATE PROCEDURE `CreateProject`(IN name VARCHAR(255), IN description TEXT, IN creator_id INT, IN creator_type_id INT)
BEGIN
	-- Declare a variable to hold the ID of the newly created organization
	DECLARE project_id INT;
	DECLARE project_type INT;

	-- Check if the creator_id corresponds to an existing entity
    IF NOT CheckEntityType(register_id, register_type) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Registering entity does not exist.';
    ELSE
		INSERT INTO `projects`(`name`, `description`)
		VALUES (name, description);
		
		-- Set the project_id variable to the ID of the newly inserted organization
		SELECT LAST_INSERT_ID() INTO project_id;

		-- Record the creation of the organization in the `organization_log` table
		INSERT INTO `project_log` (`project_id`, `collaborator_id`, `collaborator_type`, `action`)
		VALUES (project_id, register_id, register_type, 'Created Project');
		
		SELECT id INTO project_type FROM entity_types WHERE name = 'Project';
		
		CALL CreateSchedule(project_id, project_type);
		CALL CreateBudget(project_id, project_type);
	END IF
END$$
DELIMITER ;
