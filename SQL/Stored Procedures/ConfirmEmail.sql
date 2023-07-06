DELIMITER $$
DROP PROCEDURE IF EXISTS `ConfirmEmail` $$
CREATE PROCEDURE `ConfirmEmail`(IN token CHAR(36))
BEGIN
  DECLARE user_id INT;
  DECLARE creation_time DATETIME;
  
  -- Get the user_id and creation_time associated with the token
  SELECT `user_id`, `created_at` INTO user_id, creation_time FROM `email_confirmations` WHERE `token` = token AND `status` = 'unconfirmed';
  
  -- Check if the token exists
  IF user_id IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Token not found or already confirmed';
  END IF;
  
  -- Check if the token is older than 24 hours
  IF TIMESTAMPDIFF(HOUR, creation_time, NOW()) > 24 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Token expired';
  END IF;
  
  -- Update the status of the email confirmation record to 'confirmed'
  UPDATE `email_confirmations` SET `status` = 'confirmed' WHERE `user_id` = user_id;
  
  -- Update the email_verified flag in the users table
  UPDATE `users` SET `email_verified` = 1 WHERE `id` = user_id;

END$$
DELIMITER ;
