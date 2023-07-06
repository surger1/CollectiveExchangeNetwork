DELIMITER $$
DROP PROCEDURE IF EXISTS `RegisterService` $$
CREATE PROCEDURE `RegisterService`(IN name VARCHAR(255), IN description TEXT, IN owner_id INT)
BEGIN
    -- Declare a variable to hold the count of users matching the provided owner_id
    DECLARE userCount INT;

    -- Check if the owner_id corresponds to an existing user
    SELECT COUNT(*) INTO userCount
    FROM users
    WHERE id = owner_id;

    -- If the owner_id is valid, insert the resource; otherwise, raise an error
    IF userCount = 1 THEN
        INSERT INTO `resources`(`name`, `description`, `owner_id`, `status`)
        VALUES (name, description, owner_id, 'not on offer');
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: The owner_id does not correspond to an existing user.';
    END IF;
END$$
DELIMITER ;
