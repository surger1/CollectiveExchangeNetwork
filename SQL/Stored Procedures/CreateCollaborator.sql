DELIMITER $$
DROP PROCEDURE IF EXISTS `CreateUserAccount` $$
CREATE PROCEDURE `CreateUserAccount`(IN email VARCHAR(255), IN password VARCHAR(255), OUT confirm_token CHAR(36))
BEGIN
  DECLARE salt CHAR(20);
  DECLARE hashed_password VARCHAR(255);
  DECLARE user_id INT;
  
  -- Check if user already exists
  SELECT `id` INTO user_id FROM `users` WHERE `email` = email;
  IF user_id IS NOT NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already registered';
  END IF;
  
  -- Generate a random salt
  SET salt = SUBSTRING(MD5(RAND()), -20);
  
  -- Hash the password with the salt
  SET hashed_password = SHA2(CONCAT(password, salt), 256);
  
  -- Insert the new user
  INSERT INTO `users`(`email`, `password`, `salt`) VALUES (email, hashed_password, salt);
  
  -- Generate a confirmation token and store it for email confirmation
  SET confirm_token = UUID();
  
  -- Call a hypothetical procedure that creates an email confirmation record
  CALL `CreateEmailConfirmation`(email, confirm_token);
END$$
DELIMITER ;
