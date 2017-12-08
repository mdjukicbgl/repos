-- DROP FUNCTION public.fn_assert_string(TEXT, TEXT);
CREATE OR REPLACE FUNCTION fn_assert_string (
  p_name TEXT,
  p_string TEXT
)
RETURNS void AS $$
BEGIN
  IF (('${' || p_name || '}') ILIKE p_string) OR (LENGTH(COALESCE(TRIM(p_string), '')) = 0) THEN
    RAISE EXCEPTION '% is unset. Please check environment variables.', p_name;
  END IF;
END;
$$ LANGUAGE plpgsql;
