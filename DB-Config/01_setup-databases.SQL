FLUSH PRIVILEGES;
-- Create MySql User
-- TODO: substitute 'test' with your password
CREATE USER 'gts'@'localhost' IDENTIFIED BY 'test';

-- Create database
CREATE DATABASE gts;

-- Grant accesses
GRANT ALL ON gts.* TO 'gts'@'localhost';
FLUSH PRIVILEGES;

-- To see privileges:
-- SHOW GRANTS FOR 'gts'@'localhost';