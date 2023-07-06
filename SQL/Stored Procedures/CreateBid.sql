DELIMITER $$
DROP PROCEDURE IF EXISTS `CreateBid` $$
CREATE PROCEDURE `CreateBid`(IN project_id INT, IN issuer_id INT, IN issuer_type INT)
BEGIN
        -- Declare a variable to hold the ID of the newly created bid
    DECLARE bid_id INT;
    DECLARE bid_type INT;

    -- Check if the creator_id corresponds to an existing entity
    IF NOT CheckEntityType(issuer_id, issuer_type) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Registering entity does not exist.';
    ELSE	
        INSERT INTO `bids`(`project_id`, `issuer_id`, `issuer_type`)
        VALUES (issuer_id, issuer_type);
		
		SELECT LAST_INSERT_ID() INTO bid_id;		
		
		INSERT INTO `bids_logs`(`bid_id`, `entity_id`, `entity_type`, `action`)
        VALUES (bid_id, issuer_id, issuer_type, 'created');
		
		SELECT id INTO bid_type FROM entity_types WHERE name = 'Bid';
		
		CALL CreateSchedule(bid_id, bid_type);
		CALL CreateBudget(bid_id, bid_type);
		
    END IF;
END$$
DELIMITER ;
