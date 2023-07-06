DELIMITER $$
DROP PROCEDURE IF EXISTS `CreateComment` $$
CREATE PROCEDURE `CreateComment`(IN content TEXT, IN issuer_id INT, IN issuer_type INT, IN reply_id INT)
BEGIN
        -- Declare a variable to hold the ID of the newly created comment
    DECLARE comment_id INT;

    -- Check if the creator_id corresponds to an existing entity
    IF NOT CheckEntityType(issuer_id, issuer_type) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Registering entity does not exist.';
    ELSE	
        INSERT INTO `comments`(`name`, `description`)
        VALUES (name, description);
		
		SELECT LAST_INSERT_ID() INTO comment_id;		
		
		INSERT INTO `comments_logs`(`comment_id`, `entity_id`, `entity_type`, `action`)
        VALUES (comment_id, issuer_id, issuer_type, 'created');
		
    END IF;
END$$
DELIMITER ;
