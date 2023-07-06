DELIMITER $$
CREATE PROCEDURE `LoginUser`(IN email VARCHAR(255), IN password VARCHAR(255), IN api_secret VARCHAR(255), OUT auth_key CHAR(36))
BEGIN
  DECLARE hashed_password VARCHAR(255);
  DECLARE salt VARCHAR(255);
  DECLARE client_id INT;
  DECLARE request_count INT;

  SELECT `password`, `salt` INTO hashed_password, salt FROM `collaborators` WHERE `email` = email;
  
  IF NOT SHA2(CONCAT(password, salt), 256) = hashed_password THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid password';
  END IF;
  
  SELECT `id` INTO client_id FROM `api_clients` WHERE `api_secret` = api_secret;
  IF client_id IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid API client';
  END IF;
  
  SELECT COUNT(*) INTO request_count FROM `login_attempts` 
    WHERE `email` = email AND `timestamp` > NOW() - INTERVAL 1 HOUR;
  
  IF request_count > 30 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rate limit exceeded';
  END IF;
  
  SET auth_key = UUID();
  
  INSERT INTO `login_attempts`(`email`, `timestamp`) VALUES (email, NOW());
  UPDATE `collaborators` SET `auth_key` = auth_key WHERE `email` = email;
END $$
DELIMITER ;
