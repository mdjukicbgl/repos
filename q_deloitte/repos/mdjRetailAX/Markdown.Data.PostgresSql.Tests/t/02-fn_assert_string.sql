-- Start transaction and plan the tests.
BEGIN;

SELECT plan(4);

SELECT lives_ok(
	'SELECT * FROM fn_assert_string(''DEST_READUSER'', ''some value'');', 
	'An environment variable should differ from its value');

SELECT throws_ok(
	'SELECT * FROM fn_assert_string(''DEST_READUSER'', ''${DEST_READUSER}'');', 
	'P0001', 'DEST_READUSER is unset. Please check environment variables.',
	'An unreplaced environment variable throws');

SELECT throws_ok(
	'SELECT * FROM fn_assert_string(''DEST_readuser'', ''${DEST_readUSER}'');', 
	'P0001', 'DEST_readuser is unset. Please check environment variables.',
	'An unreplaced environment variable throws, igoring case');

SELECT throws_ok(
	'SELECT * FROM fn_assert_string(''DEST_readuser'', '''');', 
	'P0001', 'DEST_readuser is unset. Please check environment variables.',
	'An unset environment variable throws');

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK;


