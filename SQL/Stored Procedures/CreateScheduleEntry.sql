DELIMITER $$
DROP PROCEDURE IF EXISTS `CreateScheduleEntry` $$
CREATE PROCEDURE `CreateScheduleEntry`(IN schedule_id INT ,IN entity_id INT, IN entity_type INT, IN start_date DATETIME, IN end_date DATETIME, IN recurrence_rule INT)
BEGIN
	DECLARE service_id INT;
	DECLARE schedule_exists INT;

    IF CheckEntityType(entity_id, entity_type) THEN
		-- Check if the project exists
		SELECT COUNT(*) INTO schedule_exists
		FROM `schedules`
		WHERE `project_id` = project_id;
		
		IF schedule_exists = 0 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'The specified schedule does not exist.';
			LEAVE PROCEDURE;
		END IF;	
	
        INSERT INTO schedule_entries(`entity_id`, `entity_type`, `start_date`, `end_date`, `recurrence_rule`)
        VALUES (entity_id, entity_type, start_date, end_date, recurrence_rule);
		
		SELECT LAST_INSERT_ID() INTO entry_id;
		
		INSERT INTO schedules_logs(`entity_id`, `entity_type`, `start_date`, `end_date`, `recurrence_rule`)
        VALUES (entity_id, entity_type, 'Created Entry');
    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Entity does not exist.';
    END IF;
END$$
DELIMITER ;