-- Obviously only to wipe out EVERYTHING!

USE gts;
DROP TABLE IF EXISTS `pkeys`;
DROP TABLE IF EXISTS `Users`;

DROP DATABASE IF EXISTS gts;

-- as root
DROP USER IF EXISTS 'gts'@'localhost';
FLUSH PRIVILEGES;
