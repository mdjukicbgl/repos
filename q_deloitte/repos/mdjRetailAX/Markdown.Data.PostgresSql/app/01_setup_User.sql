DO $$
BEGIN
  PERFORM fn_assert_string('DEST_READUSER', '${DEST_READUSER}');
  PERFORM fn_assert_string('DEST_READPASS', '${DEST_READPASS}');

  IF NOT EXISTS (
    SELECT *
    FROM   pg_catalog.pg_user
    WHERE  usename = '${DEST_READUSER}') THEN

    CREATE ROLE markdown LOGIN PASSWORD '${DEST_READPASS}';
  END IF;
END
$$
