DELIMITER $$
DROP PROCEDURE IF EXISTS `CreateProjectTask` $$
CREATE PROCEDURE `CreateProjectTask`(
    IN name VARCHAR(255), 
    IN description TEXT, 
    IN creator_id INT, 
    IN creator_type_id INT, 
    IN project_id INT
)
BEGIN
    DECLARE project_exists INT;
    DECLARE has_permissions INT;
    DECLARE task_id INT;
	
	IF NOT CheckEntityType(creator_id, creator_type_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Registering entity does not exist.';
	ELSE
		-- Check if the project exists
		SELECT COUNT(*) INTO project_exists
		FROM `projects`
		WHERE `project_id` = project_id;
		
		IF project_exists = 0 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'The specified project does not exist.';
			LEAVE PROCEDURE;
		END IF;

		-- Check if the user has sufficient permissions
		CALL `ProjectPermissionsCheck`(creator_id, project_id) INTO has_permissions;

		IF has_permissions = 0 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'The user does not have sufficient permissions for this action.';
			LEAVE PROCEDURE;
		END IF;

		-- If everything is fine, insert the new task
		INSERT INTO `tasks`(`name`, `description`, `project_id`)
		VALUES (name, description, project_id);
		
		SELECT LAST_INSERT_ID() INTO task_id;
		
		INSERT INTO `projects_logs`(`project_id`, `creator_id`, `creator_type`, `task_id`, `action`)
		VALUES (project_id, creator_id, creator_type_id, task_id, 'Created Task');
	END IF;
END$$
DELIMITER ;