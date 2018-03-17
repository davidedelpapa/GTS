-- Testing Insertions

USE gts;

INSERT INTO `Users`(
 userid,
 username,
 extra
) VALUES (
 '1',
 'testuser',
 'Used for testing purposes'
);

INSERT INTO `pkeys` (
 userid,
 pkey,
 extra
) VALUES (
 '1',
 'TEST',
 'Used for testing purposes'
);
