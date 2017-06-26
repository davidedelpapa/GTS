-- Create MySql User
-- TODO: substitute ***** with yur password
CREATE USER 'gts'@'localhost' IDENTIFIED BY '*****';

-- Create database
CREATE DATABASE gts;

-- Grant accesses
GRANT ALL ON gts.* TO 'gts'@'localhost';
FLUSH PRIVILEGES;

-- To see privileges:
-- SHOW GRANTS FOR 'gts'@'localhost';