DELIMITER $$
CREATE PROCEDURE `CreateEmailConfirmation`(IN user_email VARCHAR(255), IN token CHAR(36))
BEGIN
  DECLARE user_id INT;

  -- Get the user_id associated with the email
  SELECT `id` INTO user_id FROM `users` WHERE `email` = user_email;
  IF user_id IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email not found';
  END IF;

  -- Insert the new email confirmation record
  INSERT INTO `email_confirmations`(`user_id`, `token`, `status`, `created_at`) VALUES (user_id, token, 'unconfirmed', NOW());

  -- TODO: Send an email to user_email containing a confirmation link which includes the token
END$$
DELIMITER ;
