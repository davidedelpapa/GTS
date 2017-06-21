-- Obviously only to wipe out EVERYTHING!

USE gts;
DROP TABLE `pkeys`;

USE management;
DROP TABLE `Users`;

DROP DATABASE gts;
DROP DATABASE management;

-- as root
DROP USER 'gts'@'localhost';
