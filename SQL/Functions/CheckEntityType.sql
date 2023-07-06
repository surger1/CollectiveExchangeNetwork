DELIMITER $$
DROP FUNCTION IF EXISTS `CheckEntityType` $$
CREATE FUNCTION `CheckEntityType`(EntityId INT, EntityTypeId INT) RETURNS BOOLEAN
BEGIN
    DECLARE Exists BOOLEAN DEFAULT FALSE;
    
    SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM entity_types WHERE id = EntityTypeId;

    IF Exists THEN
        CASE EntityTypeId
            WHEN 1 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM collaborators WHERE id = EntityId;
            WHEN 2 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM organizations WHERE id = EntityId;
			WHEN 3 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM projects WHERE id = EntityId;
			WHEN 4 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM memberships WHERE id = EntityId;
			WHEN 5 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM resources WHERE id = EntityId;
			WHEN 6 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM services WHERE id = EntityId;
			WHEN 7 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM skills WHERE id = EntityId;
			WHEN 8 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM polls WHERE id = EntityId;
			WHEN 9 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM events WHERE id = EntityId;
			WHEN 10 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM locations WHERE id = EntityId;
			WHEN 11 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM bids WHERE id = EntityId;
			WHEN 12 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM budgets WHERE id = EntityId;
			WHEN 13 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM roles WHERE id = EntityId;
			WHEN 14 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM rules WHERE id = EntityId;
			WHEN 15 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM comments WHERE id = EntityId;
			WHEN 16 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM ratings WHERE id = EntityId;
			WHEN 17 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM disputes WHERE id = EntityId;
			WHEN 18 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM exchanges WHERE id = EntityId;
			WHEN 19 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM messages WHERE id = EntityId;
			WHEN 20 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM tasks WHERE id = EntityId;
			WHEN 21 THEN 
                SELECT IF(COUNT(*), TRUE, FALSE) INTO Exists FROM votes WHERE id = EntityId;
        END CASE;
    END IF;
	
    RETURN Exists;
END$$
DELIMITER ;
