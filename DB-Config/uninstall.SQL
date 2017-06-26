-- Obviously only to wipe out EVERYTHING!

USE gts;
DROP TABLE `pkeys`;
DROP TABLE `Users`;

DROP DATABASE gts;

-- as root
DROP USER 'gts'@'localhost';
