CREATE TABLE IF NOT EXISTS decision_state_type (
  decision_state_type_id   SERIAL       NOT NULL,
  decision_state_type_name VARCHAR(255) NOT NULL,
  CONSTRAINT pk_decision_state_type PRIMARY KEY (decision_state_type_id)
);

INSERT INTO decision_state_type (decision_state_type_id, decision_state_type_name)
VALUES
  (0, 'Neutral'),
  (1, 'Accepted'),
  (2, 'Revised'),
  (3, 'Rejected');