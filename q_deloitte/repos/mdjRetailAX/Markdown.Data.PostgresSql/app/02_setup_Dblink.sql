do $$
begin
    PERFORM fn_assert_string('DW_HOST', '${DW_HOST}');
    PERFORM fn_assert_string('DW_PORT', '${DW_PORT}');
    PERFORM fn_assert_string('DW_DATABASE', '${DW_DATABASE}');
    PERFORM fn_assert_string('DW_USER', '${DW_USER}');
    PERFORM fn_assert_string('DW_PASS', '${DW_PASS}');

    CREATE EXTENSION IF NOT EXISTS postgres_fdw;
    CREATE EXTENSION IF NOT EXISTS dblink;

    IF NOT EXISTS (SELECT 1 FROM pg_foreign_server WHERE srvname = 'datawarehouse') THEN
        CREATE SERVER datawarehouse
                FOREIGN DATA WRAPPER postgres_fdw
                OPTIONS(host '${DW_HOST}', port '${DW_PORT}', dbname '${DW_DATABASE}');

        CREATE USER MAPPING FOR ${DEST_USER}
                SERVER datawarehouse
                OPTIONS (user '${DW_USER}', password '${DW_PASS}');
        GRANT USAGE ON FOREIGN SERVER datawarehouse TO ${DEST_USER};

        CREATE USER MAPPING FOR ${DEST_READUSER}
                SERVER datawarehouse
                OPTIONS (user '${DW_USER}', password '${DW_PASS}');
        GRANT USAGE ON FOREIGN SERVER datawarehouse TO ${DEST_READUSER};
    END IF;
end
$$
