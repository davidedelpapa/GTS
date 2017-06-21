-- Testing Insertions

USE management;

INSERT INTO `Users`(
 userid,
 extra
) VALUES (
 '1',
 'Used for testing purposes'
);

USE gts;

INSERT INTO `pkeys` (
 userid,
 pkey,
 extra
) VALUES (
 '1',
 'TEST',
 'Used for testing purposes'
);
