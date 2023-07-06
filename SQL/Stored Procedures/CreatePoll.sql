DELIMITER $$
DROP PROCEDURE IF EXISTS `CreatePoll` $$
CREATE PROCEDURE `CreatePoll`(IN issuer_id INT, IN issuer_type INT, IN focus_id INT, IN focus_type INT, IN start_date DATETIME, IN end_date DATETIME)
BEGIN
        -- Declare a variable to hold the ID of the newly created poll
    DECLARE poll_id INT;

    -- Check if the creator_id corresponds to an existing entity
    IF NOT CheckEntityType(issuer_id, issuer_type) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Registering entity does not exist.';
	ELSE IF NOT CheckEntityType(focus_id, focus_type) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Focused entity does not exist.';
    ELSE	
        INSERT INTO `polls`(`start_date`, `end_date`, `focus_id`, `focus_type`)
        VALUES (start_date, end_date, focus_id, focus_type);
		
		SELECT LAST_INSERT_ID() INTO poll_id;		
		
		INSERT INTO `polls_logs`(`poll_id`, `entity_id`, `entity_type`, `action`)
        VALUES (poll_id, issuer_id, issuer_type, 'created');
		
    END IF;
END$$
DELIMITER ;
