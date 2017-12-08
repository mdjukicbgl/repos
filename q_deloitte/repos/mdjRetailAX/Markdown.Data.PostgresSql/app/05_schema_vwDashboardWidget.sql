-- SELECT * FROM dashboard_widget
CREATE OR REPLACE VIEW dashboard_widget
AS
SELECT
  wi.dashboard_id,
  wi.widget_instance_id
FROM widget_instance wi
JOIN widget w ON w.widget_id = wi.widget_id
