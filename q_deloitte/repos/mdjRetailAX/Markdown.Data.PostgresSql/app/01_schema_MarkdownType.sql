CREATE TABLE IF NOT EXISTS markdown_type (
  markdown_type_id SERIAL       NOT NULL,
  name             VARCHAR(128) NOT NULL,
  description      VARCHAR(128) NOT NULL,
  CONSTRAINT pk_markdown_type_id PRIMARY KEY (markdown_type_id)
)
;

INSERT INTO markdown_type (markdown_type_id, name, description)
VALUES
  (1, 'Existing','No markdowns are allowed. Only products with existing markdowns are valid.'),
  (2, 'Full Price','No markdowns are allowed. Only products at full price are valid.'),
  (3, 'Existing & Full Price', 'No markdowns are allowed. Products remain at their current price.'),
  (4, 'New', 'Only New markdowns are allowed. Products cannot remain at their current price.'),
  (7, 'New, Existing & Full Price', 'Only New markdowns are allowed. Product may also remain at their current price.'),
  (8, 'Further', 'Only Further markdowns are allowed. Products cannot remain at their current price.'),
  (11, 'Further, Existing & Full Price', 'Only Further markdowns are allowed. Product may also remain at their current price.'),
  (12, 'New & Further', 'New and Further markdowns are allowed. Products cannot remain at their current price.'),
  (15, 'New, Further, Existing & Full Price','Both New and Further markdowns are allowed. Products may also remain at their current price.'),
  (255, 'All', 'All types are allowed')
;