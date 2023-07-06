DELIMITER $$
DROP PROCEDURE IF EXISTS `CreateEvent` $$
CREATE PROCEDURE `CreateEvent`(IN name VARCHAR(255), IN description TEXT, IN start_date DATETIME, IN end_date DATETIME, IN organizer_id INT, IN organizer_type INT, IN location_id INT, IN parent_event_id INT)
BEGIN
	DECLARE event_id INT;
	
    IF NOT CheckEntityType(organizer_id, organizer_type) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Organizer does not exist.';
    ELSE
        INSERT INTO `events`(`name`, `description`, `start_date`, `end_date`, `location_id`, `parent_event_id`)
        VALUES (name, description, start_date, end_date, organizer_id, organizer_type, location_id, parent_event_id);
	
	    SELECT LAST_INSERT_ID() INTO event_id;	
	
	    INSERT INTO `events_logs` (`event_id`, `organizer_id`, `organizer_type`, `action`)
	    VALUES (event_id, organizer_id, organizer_type, 'Created Event');
    END IF;
END$$
DELIMITER ;
