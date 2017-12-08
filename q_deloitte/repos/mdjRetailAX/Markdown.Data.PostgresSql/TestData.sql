-- Clear database
TRUNCATE model, scenario, recommendation CASCADE;

-- Create model
INSERT INTO model
  (model_id, stage_max, stage_offset_max, decay_default, elasticity_default)
VALUES
  (100, 4, 8, 1.0, 1.0);


INSERT into organisation(organisation_name)
    VALUES ('Deloitte');
INSERT into organisation(organisation_name)
    VALUES ('Meijer');


INSERT into "user"(user_name, organisation_id)
VALUES ('ciamckenna@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('srajendren@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('rney@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('jmcaleer@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('dtmoorhead@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('belove@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('christianfield@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('ruaoneill@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('mmelton@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('zhasan@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('mmelton@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('darrenwhite@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('cthanthrimudalige@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('cclague@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('stadair@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('bscillitoe@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('dellmer@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('nwyland@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('ney.richard@yahoo.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('joshuabarber@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('darrhopkins@deloitte.co.uk',1);
INSERT into "user"(user_name, organisation_id)
VALUES ('ciranmc@yahoo.co.uk',2);
INSERT into "user"(user_name, organisation_id)
VALUES ('sagokhale@deloitte.co.uk',1);


-- Create scenario
INSERT INTO scenario
  (scenario_id, week, schedule_week_min, schedule_week_max, schedule_stage_min, schedule_stage_max, stage_max, stage_offset_max,
 price_floor, scenario_name, schedule_mask, markdown_count_start_week, default_markdown_type,default_decision_state_name, allow_promo_as_markdown, minimum_promo_percentage,organisation_id,created_by)
VALUES
  (100, 897, 890, 897, 1, 4, NULL, NULL, NULL, 'Default scenario 255 (ACTIVE REPLSHMT BTTMS WMN)', 255, 800, 255,'Accepted', FALSE, 0,1,1),
  (101, 897, 890, 897, 1, 4, NULL, NULL, NULL, 'Alternative scenario 170 (TEE SHORT SLV COTTON HIGH SCHO)', 170, 800, 255,'Neutral', TRUE, 0.3,1,1),
  (102, 897, 890, 897, 1, 4, NULL, NULL, NULL, 'Alternative scenario 85 (SPRING AND SUMMER NOVELTY)', 85, 800, 255,'Neutral', FALSE, 0,1,1),
  (103, 897, 890, 897, 1, 4, NULL, NULL, NULL, 'Alternative scenario (Markdown Type - News)', 85, 800, 255,'Neutral', FALSE, 0,1,1),
  (104, 897, 890, 897, 1, 4, NULL, NULL, NULL, 'Meijer scenario (Markdown Type - News)', 85, 800, 255, 'Neutral',FALSE, 0,2,1);

INSERT INTO
  scenario_hierarchy_filter (scenario_id, hierarchy_id)
VALUES
  (100, 7793),
  (100, 15874),
  (100, 15828),
  (100, 15515),
  (100, 14895),
  (100, 13207),
  (100, 11527),

  (101, 7793),
  (101, 15874),
  (101, 15828),
  (101, 15515),
  (101, 14889),
  (101, 10481),

  (102, 7793),
  (102, 15874),
  (102, 15828),
  (102, 15515),
  (102, 14895),
  (102, 13208),

  (103, 7793),
  (103, 15874),
  (103, 15828),
  (103, 15515),
  (103, 14895),
  (103, 13207),
  (103, 11527),

  (104, 7793),
  (104, 15874),
  (104, 15828),
  (104, 15515),
  (104, 14895),
  (104, 13207),
  (104, 11527);

INSERT INTO
  scenario_product_filter (scenario_id, product_id)
VALUES
  (103, 1809111), /* Full Price */
  (103, 1809124), /* Full Price */
  (103, 1734562), /* Full Price */
  (103, 1734565), /* Full Price */
  (103, 1739169), /* Full Price */
  (103, 1739170), /* Full Price */
  (103, 1745889), /* Existing */
  (103, 1764592), /* Existing */
  (103, 1745888), /* Existing */
  (103, 1686601), /* Existing */
  (103, 1745891), /* Existing */
  (103, 1746734), /* Existing */

  (104, 1809111), /* Full Price */
  (104, 1809124), /* Full Price */
  (104, 1734562), /* Full Price */
  (104, 1734565), /* Full Price */
  (104, 1739169), /* Full Price */
  (104, 1739170), /* Full Price */
  (104, 1745889), /* Existing */
  (104, 1764592), /* Existing */
  (104, 1745888), /* Existing */
  (104, 1686601), /* Existing */
  (104, 1745891), /* Existing */
  (104, 1746734); /* Existing */


INSERT INTO scenario_markdown_constraint (scenario_id, week, markdown_type_id)  VALUES
    (100, 1, NULL),
    (100, 2, NULL),
    (100, 3, NULL),
    (100, 4, NULL),
    (100, 5, NULL),
    (100, 6, NULL),
    (100, 7, NULL),
    (100, 8, NULL);

INSERT INTO scenario_markdown_constraint (scenario_id, week, markdown_type_id)  VALUES
    (101, 1, NULL),
    (101, 2, NULL),
    (101, 3, NULL),
    (101, 4, NULL),
    (101, 5, NULL),
    (101, 6, NULL),
    (101, 7, NULL),
    (101, 8, NULL);

INSERT INTO scenario_markdown_constraint (scenario_id, week, markdown_type_id)  VALUES
    (102, 1, NULL),
    (102, 2, NULL),
    (102, 3, NULL),
    (102, 4, NULL),
    (102, 5, NULL),
    (102, 6, NULL),
    (102, 7, NULL),
    (102, 8, NULL);

INSERT INTO scenario_markdown_constraint (scenario_id, week, markdown_type_id)  VALUES
    (103, 1, 7),
    (103, 2, 7),
    (103, 3, 7),
    (103, 4, 7),
    (103, 5, 7),
    (103, 6, 7),
    (103, 7, 7),
    (103, 8, 7);

    INSERT INTO scenario_markdown_constraint (scenario_id, week, markdown_type_id)  VALUES
    (104, 1, NULL),
    (104, 2, NULL),
    (104, 3, NULL),
    (104, 4, NULL),
    (104, 5, NULL),
    (104, 6, NULL),
    (104, 7, NULL),
    (104, 8, NULL);

INSERT INTO price_ladder
  (price_ladder_type_id, description)
VALUES
  (2, 'Unnamed country price ladder (1)'),
  (2, 'Unnamed country price ladder (2)'),
  (2, 'Unnamed country price ladder (3)');

INSERT INTO price_ladder_value (price_ladder_id, "order", value)
VALUES
    (1, 1, 0.1000),
    (1, 2, 0.1500),
    (1, 3, 0.2000),
    (1, 4, 0.2500),
    (1, 5, 0.3000),
    (1, 6, 0.3500),
    (1, 7, 0.4000),
    (1, 8, 0.4500),
    (1, 9, 0.5000),
    (1, 10, 0.5500),
    (1, 11, 0.6000),
    (1, 12, 0.6500),
    (1, 13, 0.7000),
    (1, 14, 0.7500),
    (1, 15, 0.8000),
    (1, 16, 0.8500),
    (1, 17, 0.9000),
    (1, 18, 0.9500),
    (2, 1, 0.1000),
    (2, 2, 0.1500),
    (2, 3, 0.2000),
    (2, 4, 0.2500),
    (2, 5, 0.3000),
    (2, 6, 0.3500),
    (2, 7, 0.4000),
    (2, 8, 0.4500),
    (2, 9, 0.5000),
    (2, 10, 0.5500),
    (2, 11, 0.6000),
    (2, 12, 0.6500),
    (2, 13, 0.7000),
    (2, 14, 0.7500),
    (2, 15, 0.8000),
    (2, 16, 0.8500),
    (2, 17, 0.9000),
    (2, 18, 0.9500),
    (3, 1, 0.1000),
    (3, 2, 0.1500),
    (3, 3, 0.2000),
    (3, 4, 0.2500),
    (3, 5, 0.3000),
    (3, 6, 0.3500),
    (3, 7, 0.4000),
    (3, 8, 0.4500),
    (3, 9, 0.5000),
    (3, 10, 0.5500),
    (3, 11, 0.6000),
    (3, 12, 0.6500),
    (3, 13, 0.7000),
    (3, 14, 0.7500),
    (3, 15, 0.8000),
    (3, 16, 0.8500),
    (3, 17, 0.9000),
    (3, 18, 0.9500);

INSERT INTO dashboard(dashboard_id, dashboard_layout_type_id, title)
VALUES
  (100, 1, 'Test Dashboard')
;

INSERT INTO widget(widget_id, widget_type_id,organisation_id)
VALUES
  (100, 1,1),
  (101, 1,2)
;

INSERT INTO widget_instance(widget_instance_id, widget_id, dashboard_id, layout_ordinal_id, title)
VALUES
  (100, 100, 100, 1, 'Scenarios'),
   (101, 101, 100, 1, 'Meijer Scenarios')
;


INSERT into module(name,description )
    values('Markdown','Provides Price Optimization');


INSERT into role(name, description, module_id)
VALUES ('MARKDOWN_SUPER_ADMINISTRATOR','Super User',1);
INSERT into role(name, description, module_id)
VALUES ('TESTING_RESTRICTED','Restricted role that cant see recommendations',1);

INSERT into user_role(user_id, role_id)
VALUES (1,1);
INSERT into user_role(user_id, role_id)
VALUES (2,1);
INSERT into user_role(user_id, role_id)
VALUES (3,1);
INSERT into user_role(user_id, role_id)
VALUES (4,1);
INSERT into user_role(user_id, role_id)
VALUES (5,1);
INSERT into user_role(user_id, role_id)
VALUES (6,1);
INSERT into user_role(user_id, role_id)
VALUES (7,1);
INSERT into user_role(user_id, role_id)
VALUES (8,1);
INSERT into user_role(user_id, role_id)
VALUES (9,1);
INSERT into user_role(user_id, role_id)
VALUES (10,1);
INSERT into user_role(user_id, role_id)
VALUES (11,1);
INSERT into user_role(user_id, role_id)
VALUES (12,1);
INSERT into user_role(user_id, role_id)
VALUES (13,1);
INSERT into user_role(user_id, role_id)
VALUES (14,1);
INSERT into user_role(user_id, role_id)
VALUES (15,1);
INSERT into user_role(user_id, role_id)
VALUES (16,1);
INSERT into user_role(user_id, role_id)
VALUES (17,1);
INSERT into user_role(user_id, role_id)
VALUES (18,1);
INSERT into user_role(user_id, role_id)
VALUES (20,1);
INSERT into user_role(user_id, role_id)
VALUES (21,1);
INSERT into user_role(user_id, role_id)
VALUES (22,1);
INSERT into user_role(user_id, role_id)
VALUES (23,1);

--TESTING_RESTRICTED for ney.richard@yahoo.co.uk
INSERT into user_role(user_id, role_id)
VALUES (19,2);

INSERT into permission(permission_code, description)
VALUES ('MKD_SCENARIO_CREATE','Allows the user to create a scenario');

INSERT into permission(permission_code, description)
VALUES ('MKD_SCENARIO_CALCULATE','Allows the user to run a scenario calculation');

INSERT into permission(permission_code, description)
VALUES ('MKD_SCENARIO_PUBLISH','Allows the user to publish a scenario');

INSERT into permission(permission_code, description)
VALUES ('MKD_SCENARIO_UPLOAD_FILE','Allows the user to upload product ids to be included in a scenario run');

INSERT into permission(permission_code, description)
VALUES ('MKD_SCENARIO_UPLOAD','Allows the user to upload a scenario');

INSERT into permission(permission_code, description)
VALUES ('MKD_SCENARIO_PREPARE','Allows the user to run a scenario calculation');

INSERT into permission(permission_code, description)
VALUES ('MKD_SCENARIO_VIEW','Allows the user to view a scenario');

INSERT into permission(permission_code, description)
VALUES ('MKD_RECOMMENDATION_ACCEPT','Allows the user to accept a recommendation');

INSERT into permission(permission_code, description)
VALUES ('MKD_RECOMMENDATION_REJECT','Allows the user to reject a recommendation');

INSERT into permission(permission_code, description)
VALUES ('MKD_RECOMMENDATION_REVISE','Allows the user to revise a recommendation');

INSERT into permission(permission_code, description)
VALUES ('MKD_RECOMMENDATION_VIEW','Allows the user to view a recommendation');

INSERT into permission(permission_code, description)
VALUES ('MKD_DASHBOARD_VIEW','Allows the user to view the dashboard');

INSERT into permission(permission_code, description)
VALUES ('MKD_HOME_VIEW','Allows the user to view the home url');


INSERT into role_permission(role_id, permission_id)
VALUES (1,1);
INSERT into role_permission(role_id, permission_id)
VALUES (1,2);
INSERT into role_permission(role_id, permission_id)
VALUES (1,3);
INSERT into role_permission(role_id, permission_id)
VALUES (1,4);
INSERT into role_permission(role_id, permission_id)
VALUES (1,5);
INSERT into role_permission(role_id, permission_id)
VALUES (1,6);
INSERT into role_permission(role_id, permission_id)
VALUES (1,7);
INSERT into role_permission(role_id, permission_id)
VALUES (1,8);
INSERT into role_permission(role_id, permission_id)
VALUES (1,9);
INSERT into role_permission(role_id, permission_id)
VALUES (1,10);
INSERT into role_permission(role_id, permission_id)
VALUES (1,11);
INSERT into role_permission(role_id, permission_id)
VALUES (1,12);
INSERT into role_permission(role_id, permission_id)
VALUES (1,13);

--TESTING_RESTRICTED Permission
INSERT into role_permission(role_id, permission_id)
VALUES (2,1);
INSERT into role_permission(role_id, permission_id)
VALUES (2,2);
INSERT into role_permission(role_id, permission_id)
VALUES (2,3);
INSERT into role_permission(role_id, permission_id)
VALUES (2,4);
INSERT into role_permission(role_id, permission_id)
VALUES (2,5);
INSERT into role_permission(role_id, permission_id)
VALUES (2,6);
INSERT into role_permission(role_id, permission_id)
VALUES (2,7);
INSERT into role_permission(role_id, permission_id)
VALUES (2,12);
INSERT into role_permission(role_id, permission_id)
VALUES (2,13);

insert INTO
scenario_flex_factor
    values(101,12019,3,1.4);

insert INTO
scenario_flex_factor
    values(100,12019,3,1.4);

insert INTO
scenario_flex_factor
    values(100,13207,2,1.6);

insert INTO
scenario_flex_factor
    values(100,7794,2,1.2);

insert INTO
scenario_flex_factor
    values(100,11527,5,2.7);

insert INTO
scenario_flex_factor
    values(100,15874,5,0.8);
