CREATE TABLE conformed.bridge_geography_hierarchy
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_hierarchy_node_id BIGINT NOT NULL ENCODE none,
	dim_geography_id INTEGER NOT NULL ENCODE none DISTKEY,
	dim_retailer_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	effective_start_date_time TIMESTAMP NOT NULL ENCODE none,
	effective_end_date_time TIMESTAMP DEFAULT '2500-01-01 00:00:00'::timestamp without time zone NOT NULL ENCODE none
)
SORTKEY
(
	dim_hierarchy_node_id,
	dim_geography_id,
	dim_retailer_id,
	effective_end_date_time,
	effective_start_date_time,
	batch_id
);


CREATE TABLE conformed.bridge_hierarchy_level_subject
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_level_subject_id INTEGER NOT NULL ENCODE lzo,
	dim_hierarchy_id INTEGER NOT NULL ENCODE lzo DISTKEY,
	hierarchy_node_level SMALLINT DEFAULT 0 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo
);

ALTER TABLE conformed.bridge_hierarchy_level_subject
ADD CONSTRAINT pk_bridge_hierarchy_level_subject
PRIMARY KEY (dim_level_subject_id, dim_hierarchy_id, hierarchy_node_level);



CREATE TABLE conformed.bridge_product_hierarchy
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_product_id BIGINT NOT NULL ENCODE none DISTKEY,
	dim_hierarchy_node_id BIGINT NOT NULL ENCODE none,
	dim_retailer_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	effective_start_date_time TIMESTAMP NOT NULL ENCODE none,
	effective_end_date_time TIMESTAMP DEFAULT '2500-01-01 00:00:00'::timestamp without time zone NOT NULL ENCODE none
)
SORTKEY
(
	dim_product_id,
	dim_hierarchy_node_id,
	dim_retailer_id,
	effective_end_date_time,
	effective_start_date_time,
	batch_id
);


CREATE TABLE conformed.dim_channel
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_channel_id INTEGER NOT NULL ENCODE none,
	dim_retailer_id INTEGER NOT NULL ENCODE none,
	channel_bkey VARCHAR(20) NOT NULL ENCODE none,
	channel_name VARCHAR(50) NOT NULL ENCODE none,
	channel_description VARCHAR(250) ENCODE lzo,
	channel_code VARCHAR(10) ENCODE lzo
)
DISTSTYLE EVEN
SORTKEY
(
	dim_channel_id,
	dim_retailer_id,
	channel_bkey,
	channel_name,
	batch_id
);


CREATE TABLE conformed.dim_currency
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_currency_id SMALLINT NOT NULL ENCODE none,
	currency_bkey VARCHAR(20) NOT NULL ENCODE none,
	currency VARCHAR(50) NOT NULL ENCODE lzo,
	iso_currency_code CHAR(3) NOT NULL ENCODE none,
	currency_symbol VARCHAR(4) ENCODE lzo,
	is_active BOOLEAN DEFAULT 1 NOT NULL ENCODE none
)
DISTSTYLE EVEN
SORTKEY
(
	dim_currency_id,
	iso_currency_code,
	currency_bkey,
	is_active,
	batch_id
);


CREATE TABLE conformed.dim_data_status
(
	dim_data_status_id BIGINT IDENTITY NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;

ALTER TABLE conformed.dim_data_status
ADD CONSTRAINT pk_dimdatastatus
PRIMARY KEY (dim_data_status_id);



CREATE TABLE conformed.dim_date
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_date_id INTEGER NOT NULL ENCODE none,
	day_sequence_number INTEGER NOT NULL ENCODE none,
	week_sequence_number_usa INTEGER DEFAULT 0 NOT NULL ENCODE none,
	week_sequence_number_eu_iso INTEGER DEFAULT 0 NOT NULL ENCODE none,
	month_sequence_number SMALLINT DEFAULT 0 NOT NULL ENCODE none,
	calendar_date DATE NOT NULL ENCODE none,
	is_weekday7_usa BOOLEAN NOT NULL ENCODE none,
	is_weekday7_eu_iso BOOLEAN NOT NULL ENCODE none,
	calendar_date_eu CHAR(10) NOT NULL ENCODE lzo,
	calendar_date_usa CHAR(10) NOT NULL ENCODE lzo,
	calendar_day_of_month INTEGER NOT NULL ENCODE lzo,
	day_with_suffix VARCHAR(6) NOT NULL ENCODE lzo,
	calendar_month_number INTEGER NOT NULL ENCODE lzo,
	calendar_month_name VARCHAR(30) NOT NULL ENCODE lzo,
	calendar_month_start_date DATE NOT NULL ENCODE lzo,
	calendar_month_end_date DATE NOT NULL ENCODE lzo,
	calendar_year_month INTEGER NOT NULL ENCODE lzo,
	calendar_week_number_usa SMALLINT NOT NULL ENCODE lzo,
	calendar_week_number_eu SMALLINT NOT NULL ENCODE lzo,
	calendar_continuum_year_week_number_usa INTEGER NOT NULL ENCODE lzo,
	calendar_continuum_year_week_number_eu INTEGER NOT NULL ENCODE lzo,
	calendar_continuum_year_week_number_usa_start_date DATE NOT NULL ENCODE lzo,
	calendar_continuum_year_week_number_usa_end_date DATE NOT NULL ENCODE lzo,
	calendar_continuum_year_week_number_eu_start_date DATE NOT NULL ENCODE lzo,
	calendar_continuum_year_week_number_eu_end_date DATE NOT NULL ENCODE lzo,
	calendar_iso_week_number INTEGER NOT NULL ENCODE lzo,
	calendar_continuum_year_iso_week_number INTEGER NOT NULL ENCODE lzo,
	calendar_continuum_year_iso_week_number_start_date DATE NOT NULL ENCODE lzo,
	calendar_continuum_year_iso_week_number_end_date DATE NOT NULL ENCODE lzo,
	week_day_number_usa SMALLINT NOT NULL ENCODE lzo,
	week_day_number_eu_iso SMALLINT NOT NULL ENCODE lzo,
	week_day_name VARCHAR(30) NOT NULL ENCODE lzo,
	calendar_quarter_name VARCHAR(6) NOT NULL ENCODE lzo,
	calendar_quarter_number SMALLINT NOT NULL ENCODE lzo,
	calendar_quarter_day_number INTEGER NOT NULL ENCODE lzo,
	calendar_quarter_month_number INTEGER NOT NULL ENCODE lzo,
	calendar_quarter_start_date DATE NOT NULL ENCODE lzo,
	calendar_quarter_end_date DATE NOT NULL ENCODE lzo,
	calendar_year INTEGER NOT NULL ENCODE lzo,
	calendar_year_start_date DATE NOT NULL ENCODE lzo,
	calendar_year_end_date DATE NOT NULL ENCODE lzo
)
DISTSTYLE EVEN
SORTKEY
(
	dim_date_id,
	calendar_date,
	month_sequence_number,
	week_sequence_number_usa,
	week_sequence_number_eu_iso,
	day_sequence_number
);


CREATE TABLE conformed.dim_date_fiscal
(
	batch_id INTEGER NOT NULL ENCODE none,
	dim_retailer_id INTEGER NOT NULL ENCODE none,
	dim_date_id INTEGER NOT NULL ENCODE none,
	is_weekday7 BOOLEAN NOT NULL ENCODE none,
	is_working_day BOOLEAN NOT NULL ENCODE none,
	is_business_holiday BOOLEAN NOT NULL ENCODE none,
	is_national_holiday BOOLEAN NOT NULL ENCODE none,
	fiscal_date_string CHAR(11) NOT NULL ENCODE lzo,
	fiscal_day_of_month INTEGER NOT NULL ENCODE lzo,
	fiscal_day_with_suffix VARCHAR(6) NOT NULL ENCODE lzo,
	fiscal_month_number INTEGER NOT NULL ENCODE lzo,
	fiscal_month_name VARCHAR(30) NOT NULL ENCODE lzo,
	fiscal_month_start_date DATE NOT NULL ENCODE lzo,
	fiscal_month_end_date DATE NOT NULL ENCODE lzo,
	fiscal_year_month INTEGER NOT NULL ENCODE lzo,
	fiscal_week_number SMALLINT NOT NULL ENCODE lzo,
	fiscal_continuum_week_number SMALLINT DEFAULT 0 NOT NULL ENCODE lzo,
	fiscal_continuum_month_number SMALLINT DEFAULT 0 NOT NULL ENCODE lzo,
	fiscal_continuum_quarter_number SMALLINT DEFAULT 0 ENCODE lzo,
	fiscal_continuum_year_week_number INTEGER NOT NULL ENCODE lzo,
	fiscal_continuum_year_week_number_start_date DATE NOT NULL ENCODE lzo,
	fiscal_continuum_year_week_number_end_date DATE NOT NULL ENCODE lzo,
	fiscal_week_day_number SMALLINT NOT NULL ENCODE lzo,
	fiscal_week_day_name VARCHAR(30) NOT NULL ENCODE lzo,
	fiscal_quarter_name VARCHAR(6) NOT NULL ENCODE lzo,
	fiscal_quarter_number SMALLINT NOT NULL ENCODE lzo,
	fiscal_quarter_day_number INTEGER NOT NULL ENCODE lzo,
	fiscal_quarter_month_number INTEGER NOT NULL ENCODE lzo,
	fiscal_quarter_start_date DATE NOT NULL ENCODE lzo,
	fiscal_quarter_end_date DATE NOT NULL ENCODE lzo,
	fiscal_year INTEGER NOT NULL ENCODE lzo,
	fiscal_year_start_date DATE NOT NULL ENCODE lzo,
	fiscal_year_end_date DATE NOT NULL ENCODE lzo,
	fiscal_year_quarter_month_number CHAR(8) DEFAULT 'YYYYQNMM'::bpchar ENCODE lzo
)
DISTSTYLE EVEN
SORTKEY
(
	dim_date_id,
	dim_retailer_id,
	batch_id
);


CREATE TABLE conformed.dim_geography
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_geography_id INTEGER NOT NULL ENCODE none,
	dim_retailer_id INTEGER NOT NULL ENCODE none,
	location_bkey VARCHAR(20) NOT NULL ENCODE none,
	location_type_bkey VARCHAR(20) DEFAULT '0'::character varying NOT NULL ENCODE lzo,
	effective_start_date_time TIMESTAMP NOT NULL ENCODE lzo,
	effective_end_date_time TIMESTAMP DEFAULT '2500-01-01 00:00:00'::timestamp without time zone NOT NULL ENCODE none,
	location_type VARCHAR(20) DEFAULT 'Unknown'::character varying NOT NULL ENCODE lzo,
	location_name VARCHAR(100) NOT NULL ENCODE none,
	location_description VARCHAR(256) ENCODE lzo,
	location_subtype VARCHAR(30) ENCODE lzo,
	location_status VARCHAR(20) ENCODE lzo,
	city_town VARCHAR(50) ENCODE lzo,
	county_state VARCHAR(100) ENCODE lzo,
	country VARCHAR(50) ENCODE none,
	region VARCHAR(50) ENCODE none,
	subregion VARCHAR(100) ENCODE none,
	logitude_position DOUBLE PRECISION ENCODE none,
	latitude_position DOUBLE PRECISION ENCODE none,
	trading_start_date DATE ENCODE lzo,
	trading_end_date DATE ENCODE lzo,
	default_cluster VARCHAR(30) ENCODE lzo,
	building_floor_space DOUBLE PRECISION ENCODE none,
	stock_allocation_grade VARCHAR(10) ENCODE lzo
)
DISTSTYLE EVEN
SORTKEY
(
	dim_geography_id,
	dim_retailer_id,
	location_bkey,
	effective_end_date_time,
	location_name,
	country,
	subregion,
	region,
	batch_id
);


CREATE TABLE conformed.dim_hierachy_default
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_hierarchy_subject_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_hierarchy_id INTEGER NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;

ALTER TABLE conformed.dim_hierachy_default
ADD CONSTRAINT pk_dim_hierachy_default
PRIMARY KEY (dim_hierarchy_subject_id, dim_retailer_id);



CREATE TABLE conformed.dim_hierachy_subject
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_hierarchy_subject_id INTEGER NOT NULL ENCODE lzo,
	hierarchy_subject_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	hierarchy_subject VARCHAR(50) NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;

ALTER TABLE conformed.dim_hierachy_subject
ADD CONSTRAINT pk_dim_hierachy_subject
PRIMARY KEY (dim_hierarchy_subject_id);



CREATE TABLE conformed.dim_hierarchy
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_hierarchy_id INTEGER NOT NULL ENCODE none,
	dim_retailer_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	hierarchy_name VARCHAR(255) NOT NULL ENCODE none,
	dim_hierarchy_subject_id INTEGER DEFAULT 1 NOT NULL ENCODE none
)
DISTSTYLE EVEN
SORTKEY
(
	dim_hierarchy_id,
	hierarchy_name,
	dim_retailer_id,
	dim_hierarchy_subject_id
);


CREATE TABLE conformed.dim_hierarchy_node
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_hierarchy_node_id BIGINT NOT NULL ENCODE none,
	dim_hierarchy_id INTEGER NOT NULL ENCODE none,
	hierarchy_node_bkey VARCHAR(255) NOT NULL ENCODE none,
	parent_hierarchy_node_bkey VARCHAR(255) ENCODE none,
	hierarchy_node_name VARCHAR(255) NOT NULL ENCODE lzo,
	parent_dim_hierarchy_node_id INTEGER ENCODE none,
	effective_start_date_time TIMESTAMP NOT NULL ENCODE none,
	effective_end_date_time TIMESTAMP DEFAULT '2500-01-01 00:00:00'::timestamp without time zone NOT NULL ENCODE none,
	hierarchy_node_level SMALLINT DEFAULT 0 NOT NULL ENCODE lzo,
	hierarchy_breadcrumb_node_name VARCHAR(1024) DEFAULT ''::character varying NOT NULL ENCODE none,
	hierarchy_breadcrumb_node_id VARCHAR(256) ENCODE none,
	is_leaf_node BOOLEAN DEFAULT 0 NOT NULL ENCODE none,
	node_child_count SMALLINT DEFAULT 0 NOT NULL ENCODE lzo,
	node_descendant_count INTEGER DEFAULT 0 NOT NULL ENCODE lzo,
	node_leaf_member_count INTEGER DEFAULT 0 NOT NULL ENCODE lzo
)
DISTSTYLE EVEN
SORTKEY
(
	batch_id,
	dim_hierarchy_node_id,
	dim_hierarchy_id,
	hierarchy_node_bkey,
	parent_hierarchy_node_bkey,
	parent_dim_hierarchy_node_id,
	effective_end_date_time,
	effective_start_date_time,
	hierarchy_breadcrumb_node_name,
	hierarchy_breadcrumb_node_id,
	is_leaf_node
);


CREATE TABLE conformed.dim_level_subject
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_level_subject_id INTEGER NOT NULL ENCODE lzo,
	level_subject VARCHAR(50) NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;

ALTER TABLE conformed.dim_level_subject
ADD CONSTRAINT pk_dim_level_subject
PRIMARY KEY (dim_level_subject_id);



CREATE TABLE conformed.dim_product
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_product_id BIGINT NOT NULL ENCODE none,
	dim_retailer_id INTEGER NOT NULL ENCODE none,
	product_bkey1 VARCHAR(20) NOT NULL ENCODE none,
	product_bkey2 VARCHAR(20) DEFAULT 0 NOT NULL ENCODE none,
	product_bkey3 VARCHAR(20) DEFAULT 0 NOT NULL ENCODE none,
	product_bkey4 VARCHAR(20) DEFAULT 0 NOT NULL ENCODE none,
	effective_start_date_time TIMESTAMP NOT NULL ENCODE lzo,
	effective_end_date_time TIMESTAMP DEFAULT '2500-01-01 00:00:00'::timestamp without time zone NOT NULL ENCODE lzo,
	product_name VARCHAR(100) NOT NULL ENCODE none,
	product_description VARCHAR(512) ENCODE lzo,
	product_sku_code VARCHAR(50) ENCODE lzo,
	product_size VARCHAR(20) ENCODE lzo,
	product_colour_code CHAR(10) ENCODE lzo,
	product_colour VARCHAR(50) ENCODE lzo,
	product_gender VARCHAR(10) ENCODE lzo,
	product_age_group VARCHAR(50) ENCODE lzo,
	brand_name VARCHAR(100) ENCODE lzo,
	supplier_name VARCHAR(50) ENCODE lzo,
	product_status VARCHAR(30) ENCODE none,
	product_planned_end_date DATE ENCODE none
)
DISTSTYLE EVEN
SORTKEY
(
	dim_product_id,
	dim_retailer_id,
	product_bkey1,
	product_bkey2,
	product_bkey3,
	product_bkey4,
	product_name,
	product_status,
	product_planned_end_date,
	batch_id
);


CREATE TABLE conformed.dim_retailer
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE none,
	retailer_bkey VARCHAR(20) NOT NULL ENCODE none,
	parent_retailer_bkey VARCHAR(20) ENCODE none,
	retailer_name VARCHAR(150) NOT NULL ENCODE lzo,
	parent_dim_retailer_id INTEGER ENCODE lzo,
	latest_batch_id INTEGER DEFAULT 1 NOT NULL ENCODE none
)
DISTSTYLE EVEN
SORTKEY
(
	dim_retailer_id,
	retailer_bkey,
	parent_retailer_bkey,
	latest_batch_id
);


CREATE TABLE conformed.dim_seasonality
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_seasonality_id INTEGER NOT NULL ENCODE none,
	dim_retailer_id INTEGER NOT NULL ENCODE none,
	seasonality_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	year_seasonality_bkey VARCHAR(20) ENCODE none,
	seasonality_name VARCHAR(50) NOT NULL ENCODE lzo,
	year_seasonality_name VARCHAR(50) ENCODE none
)
DISTSTYLE EVEN
SORTKEY
(
	dim_seasonality_id,
	dim_retailer_id,
	year_seasonality_bkey,
	year_seasonality_name,
	batch_id
);


CREATE TABLE conformed.dim_security_role
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_security_role_id INTEGER NOT NULL ENCODE lzo,
	security_role_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	security_role_name VARCHAR(50) NOT NULL ENCODE lzo,
	security_role_description VARCHAR(256) ENCODE lzo
)
DISTSTYLE EVEN;

ALTER TABLE conformed.dim_security_role
ADD CONSTRAINT pk_dim_security_role
PRIMARY KEY (dim_security_role_id);



CREATE TABLE conformed.dim_status
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_status_id INTEGER NOT NULL ENCODE none,
	status_type_bkey VARCHAR(20) NOT NULL ENCODE none,
	status_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	parent_status_bkey VARCHAR(20) ENCODE none,
	status_type VARCHAR(50) NOT NULL ENCODE none,
	status_name VARCHAR(50) NOT NULL ENCODE none,
	parent_dim_status_id INTEGER ENCODE lzo,
	status_hierarchy_level SMALLINT DEFAULT 0 NOT NULL ENCODE none,
	status_breadcrumb VARCHAR(512) DEFAULT ''::character varying NOT NULL ENCODE none,
	is_leaf_node BOOLEAN DEFAULT 0 NOT NULL ENCODE none
)
DISTSTYLE EVEN
SORTKEY
(
	dim_status_id,
	status_type_bkey,
	parent_status_bkey,
	status_name,
	status_type,
	is_leaf_node,
	status_hierarchy_level,
	status_breadcrumb,
	batch_id
);


CREATE TABLE conformed.fact_security_membership
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_security_role_id INTEGER NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	dim_hierarchy_id INTEGER NOT NULL ENCODE lzo,
	dim_hierarchy_node_id BIGINT NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;

ALTER TABLE conformed.fact_security_membership
ADD CONSTRAINT pk_fact_security_membership
PRIMARY KEY (dim_security_role_id, dim_retailer_id, dim_hierarchy_id, dim_hierarchy_node_id);



CREATE TABLE markdown.bridge_retailer_markdown
(
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	dim_markdown_id INTEGER NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;

ALTER TABLE markdown.bridge_retailer_markdown
ADD CONSTRAINT pk_bridge_retailer_markdown
PRIMARY KEY (dim_retailer_id, dim_markdown_id);



CREATE TABLE markdown.dim_markdown
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_markdown_id INTEGER NOT NULL ENCODE lzo,
	markdown_stage_number SMALLINT NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;

ALTER TABLE markdown.dim_markdown
ADD CONSTRAINT pk_dim_markdown
PRIMARY KEY (dim_markdown_id);



CREATE TABLE markdown.dim_markdown_event
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_markdown_event_id INTEGER NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	markdown_event_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	markdown_event_type_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	markdown_event_start_date DATE NOT NULL ENCODE lzo,
	markdown_event_end_date DATE NOT NULL ENCODE lzo,
	week_count SMALLINT NOT NULL ENCODE lzo,
	markdown_stage SMALLINT NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;

ALTER TABLE markdown.dim_markdown_event
ADD CONSTRAINT pk_dim_markdown_event
PRIMARY KEY (dim_markdown_event_id);



CREATE TABLE markdown.dim_price_status
(
	dim_price_status_id BIGINT IDENTITY NOT NULL ENCODE lzo,
	batch_id NUMERIC(10, 0) DEFAULT 1 NOT NULL ENCODE lzo,
	price_status_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	price_status VARCHAR(50) NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;

ALTER TABLE markdown.dim_price_status
ADD CONSTRAINT pk_dimpricestatus
PRIMARY KEY (dim_price_status_id);



CREATE TABLE markdown.fact_weekly_sales_markdown
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_retailer_id INTEGER NOT NULL ENCODE none,
	dim_date_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_product_id BIGINT NOT NULL ENCODE none DISTKEY,
	dim_geography_id INTEGER NOT NULL ENCODE none,
	dim_seasonality_id INTEGER NOT NULL ENCODE none,
	dim_channel_id INTEGER NOT NULL ENCODE none,
	dim_currency_id SMALLINT NOT NULL ENCODE none,
	dim_junk_id INTEGER NOT NULL ENCODE lzo,
	dim_price_status_id SMALLINT NOT NULL ENCODE none,
	gross_margin DOUBLE PRECISION ENCODE none,
	markdown_price DOUBLE PRECISION ENCODE none,
	markdown_cost DOUBLE PRECISION ENCODE none,
	cost_price DOUBLE PRECISION ENCODE none,
	system_price DOUBLE PRECISION ENCODE none,
	selling_price DOUBLE PRECISION ENCODE none,
	original_selling_price DOUBLE PRECISION ENCODE none,
	optimisation_original_selling_price DOUBLE PRECISION ENCODE none,
	provided_selling_price DOUBLE PRECISION ENCODE none,
	provided_original_selling_price DOUBLE PRECISION ENCODE none,
	optimisation_selling_price DOUBLE PRECISION ENCODE none,
	local_tax_rate DOUBLE PRECISION ENCODE none,
	sales_value DOUBLE PRECISION ENCODE none,
	sales_quantity DOUBLE PRECISION ENCODE none,
	store_stock_value DOUBLE PRECISION ENCODE none,
	store_stock_quantity DOUBLE PRECISION ENCODE none,
	depot_stock_value DOUBLE PRECISION ENCODE none,
	depot_stock_quantity DOUBLE PRECISION ENCODE none,
	clearance_sales_value DOUBLE PRECISION ENCODE none,
	clearance_sales_quantity DOUBLE PRECISION ENCODE none,
	promotion_sales_value DOUBLE PRECISION ENCODE none,
	promotion_sales_quantity DOUBLE PRECISION ENCODE none,
	store_stock_value_no_negatives DOUBLE PRECISION ENCODE none,
	store_stock_quantity_no_negatives DOUBLE PRECISION ENCODE none,
	intake_plus_future_commitment_quantity DOUBLE PRECISION ENCODE none,
	intake_plus_future_commitment_value DOUBLE PRECISION ENCODE none,
	total_stock_value DOUBLE PRECISION ENCODE none,
	total_stock_quantity DOUBLE PRECISION ENCODE none
)
SORTKEY
(
	dim_date_id,
	dim_product_id,
	dim_geography_id,
	dim_retailer_id,
	dim_seasonality_id,
	dim_channel_id,
	dim_currency_id,
	dim_price_status_id,
	batch_id
);

ALTER TABLE markdown.fact_weekly_sales_markdown
ADD CONSTRAINT pk_fact_weekly_sales_markdown
PRIMARY KEY (dim_date_id, dim_product_id, dim_geography_id, dim_seasonality_id, dim_channel_id);



CREATE TABLE sales.dim_junk
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_junk_id INTEGER NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE sales.fact_daily_price
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_retailer_id INTEGER NOT NULL ENCODE none,
	dim_date_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_product_id BIGINT NOT NULL ENCODE none DISTKEY,
	dim_geography_id INTEGER NOT NULL ENCODE none,
	dim_channel_id INTEGER NOT NULL ENCODE none,
	dim_seasonality_id INTEGER NOT NULL ENCODE none,
	dim_price_status_id INTEGER NOT NULL ENCODE none,
	dim_currency_id SMALLINT NOT NULL ENCODE none,
	system_price DOUBLE PRECISION ENCODE none,
	selling_price DOUBLE PRECISION ENCODE none,
	original_selling_price DOUBLE PRECISION ENCODE none,
	previous_selling_price DOUBLE PRECISION ENCODE none
)
SORTKEY
(
	dim_date_id,
	dim_product_id,
	dim_retailer_id,
	dim_price_status_id,
	dim_geography_id,
	dim_channel_id,
	dim_seasonality_id,
	dim_currency_id,
	batch_id
);

ALTER TABLE sales.fact_daily_price
ADD CONSTRAINT pk_fact_daily_price
PRIMARY KEY (dim_date_id, dim_product_id, dim_geography_id, dim_channel_id, dim_seasonality_id, dim_price_status_id);



CREATE TABLE sales.fact_exchange_rate
(
	dim_date_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	numerator_dim_currency_id SMALLINT NOT NULL ENCODE lzo,
	denominator_dim_currency_id SMALLINT NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	exchange_rate NUMERIC(18, 10) NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE sales.fact_seasonality
(
	dim_date_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	dim_product_id BIGINT NOT NULL ENCODE lzo,
	dim_seasonality_id INTEGER NOT NULL ENCODE lzo,
	dim_geography_id INTEGER NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE sales.fact_weekly_sales
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	dim_date_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_product_id BIGINT NOT NULL ENCODE none DISTKEY,
	dim_geography_id INTEGER NOT NULL ENCODE none,
	dim_currency_id SMALLINT NOT NULL ENCODE none,
	dim_seasonality_id INTEGER NOT NULL ENCODE none,
	dim_price_status_id INTEGER NOT NULL ENCODE none,
	dim_channel_id INTEGER NOT NULL ENCODE none,
	dim_product_status_id INTEGER NOT NULL ENCODE none,
	gross_margin DOUBLE PRECISION ENCODE none,
	sales_value DOUBLE PRECISION ENCODE none,
	sales_quantity INTEGER ENCODE lzo,
	local_tax_rate DOUBLE PRECISION ENCODE none,
	sales_cost DOUBLE PRECISION ENCODE none,
	markdown_sales_value DOUBLE PRECISION ENCODE none,
	markdown_sales_quantity INTEGER ENCODE lzo,
	promotion_sales_value DOUBLE PRECISION ENCODE none,
	promotion_sales_quantity INTEGER ENCODE lzo,
	retailer_markdown_cost DOUBLE PRECISION ENCODE none
)
SORTKEY
(
	batch_id,
	dim_date_id,
	dim_retailer_id,
	dim_product_id,
	dim_geography_id,
	dim_currency_id,
	dim_seasonality_id,
	dim_price_status_id,
	dim_channel_id,
	dim_product_status_id
);

ALTER TABLE sales.fact_weekly_sales
ADD CONSTRAINT pk_fact_weekly_sales
PRIMARY KEY (dim_date_id, dim_retailer_id, dim_product_id, dim_geography_id, dim_currency_id, dim_seasonality_id, dim_price_status_id, dim_channel_id);



CREATE TABLE sales.fact_weekly_stock
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_retailer_id INTEGER NOT NULL ENCODE none,
	dim_date_id INTEGER DEFAULT 1 NOT NULL ENCODE none,
	dim_product_id BIGINT NOT NULL ENCODE none DISTKEY,
	dim_geography_id INTEGER NOT NULL ENCODE none,
	dim_currency_id SMALLINT NOT NULL ENCODE none,
	stock_value DOUBLE PRECISION ENCODE none,
	stock_quantity INTEGER ENCODE lzo,
	stock_cost DOUBLE PRECISION ENCODE none,
	cost_price DOUBLE PRECISION ENCODE none,
	future_commitment_stock_value DOUBLE PRECISION ENCODE none,
	future_commitment_stock_quantity INTEGER ENCODE lzo,
	future_commitment_stock_cost DOUBLE PRECISION ENCODE none,
	intake_stock_value DOUBLE PRECISION ENCODE none,
	intake_stock_quantity DOUBLE PRECISION ENCODE none,
	intake_stock_cost DOUBLE PRECISION ENCODE none,
	transit_stock_value DOUBLE PRECISION ENCODE none,
	transit_stock_quantity DOUBLE PRECISION ENCODE none,
	transit_stock_cost DOUBLE PRECISION ENCODE none
)
SORTKEY
(
	batch_id,
	dim_date_id,
	dim_product_id,
	dim_geography_id,
	dim_retailer_id,
	dim_currency_id
);

ALTER TABLE sales.fact_weekly_stock
ADD CONSTRAINT pk_fact_weekly_stock
PRIMARY KEY (dim_date_id, dim_product_id, dim_geography_id);



CREATE TABLE stage.business_hierarchy_dim
(
	row_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	reporting_date DATE NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT ENCODE lzo,
	hierarchy_name VARCHAR(50) ENCODE lzo,
	business_key1 VARCHAR(20) ENCODE lzo,
	business_key2 VARCHAR(20) ENCODE lzo,
	business_key3 VARCHAR(20) ENCODE lzo,
	business_key4 VARCHAR(20) ENCODE lzo,
	business_area VARCHAR(50) ENCODE lzo,
	node_id_level1 VARCHAR(20) ENCODE lzo,
	node_name_level1 VARCHAR(50) ENCODE lzo,
	node_id_level2 VARCHAR(20) ENCODE lzo,
	node_name_level2 VARCHAR(50) ENCODE lzo,
	node_id_level3 VARCHAR(20) ENCODE lzo,
	node_name_level3 VARCHAR(50) ENCODE lzo,
	node_id_level4 VARCHAR(20) ENCODE lzo,
	node_name_level4 VARCHAR(50) ENCODE lzo,
	node_id_level5 VARCHAR(20) ENCODE lzo,
	node_name_level5 VARCHAR(50) ENCODE lzo,
	node_id_level6 VARCHAR(20) ENCODE lzo,
	node_name_level6 VARCHAR(50) ENCODE lzo,
	node_id_level7 VARCHAR(20) ENCODE lzo,
	node_name_level7 VARCHAR(50) ENCODE lzo,
	node_id_level8 VARCHAR(20) ENCODE lzo,
	node_name_level8 VARCHAR(50) ENCODE lzo,
	node_id_level9 VARCHAR(20) ENCODE lzo,
	node_name_level9 VARCHAR(50) ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.channel_dim
(
	row_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	reporting_date DATE NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
	channel_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	channel_name VARCHAR(50) NOT NULL ENCODE lzo,
	channel_description VARCHAR(250) ENCODE lzo,
	channel_code VARCHAR(10) ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.currency_dim
(
	row_id SMALLINT NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER DEFAULT 0 NOT NULL ENCODE lzo,
	reporting_date DATE NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
	currency_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	currency VARCHAR(50) NOT NULL ENCODE lzo,
	iso_currency_code CHAR(3) NOT NULL ENCODE lzo,
	currency_symbol VARCHAR(4) ENCODE lzo,
	is_active BOOLEAN DEFAULT 1 NOT NULL ENCODE none
)
DISTSTYLE EVEN;


CREATE TABLE stage.date_dim
(
	row_id INTEGER NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER DEFAULT 0 NOT NULL ENCODE lzo,
	reporting_date DATE NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
	dim_date_id INTEGER NOT NULL ENCODE lzo,
	day_sequence_number INTEGER NOT NULL ENCODE lzo,
	week_sequence_number_usa INTEGER DEFAULT 0 NOT NULL ENCODE lzo,
	week_sequence_number_eu_iso INTEGER DEFAULT 0 NOT NULL ENCODE lzo,
	month_sequence_number SMALLINT DEFAULT 0 NOT NULL ENCODE lzo,
	calendar_date DATE NOT NULL ENCODE lzo,
	is_weekday7_usa BOOLEAN NOT NULL ENCODE none,
	is_weekday7_eu_iso BOOLEAN NOT NULL ENCODE none,
	calendar_date_eu CHAR(10) NOT NULL ENCODE lzo,
	calendar_date_usa CHAR(10) NOT NULL ENCODE lzo,
	calendar_day_of_month INTEGER NOT NULL ENCODE lzo,
	day_with_suffix VARCHAR(6) NOT NULL ENCODE lzo,
	calendar_month_number INTEGER NOT NULL ENCODE lzo,
	calendar_month_name VARCHAR(30) NOT NULL ENCODE lzo,
	calendar_month_start_date DATE NOT NULL ENCODE lzo,
	calendar_month_end_date DATE NOT NULL ENCODE lzo,
	calendar_year_month INTEGER NOT NULL ENCODE lzo,
	calendar_week_number_usa SMALLINT NOT NULL ENCODE lzo,
	calendar_week_number_eu SMALLINT NOT NULL ENCODE lzo,
	calendar_continuum_year_week_number_usa INTEGER NOT NULL ENCODE lzo,
	calendar_continuum_year_week_number_eu INTEGER NOT NULL ENCODE lzo,
	calendar_continuum_year_week_number_usa_start_date DATE NOT NULL ENCODE lzo,
	calendar_continuum_year_week_number_usa_end_date DATE NOT NULL ENCODE lzo,
	calendar_continuum_year_week_number_eu_start_date DATE NOT NULL ENCODE lzo,
	calendar_continuum_year_week_number_eu_end_date DATE NOT NULL ENCODE lzo,
	calendar_iso_week_number INTEGER NOT NULL ENCODE lzo,
	calendar_continuum_year_iso_week_number INTEGER NOT NULL ENCODE lzo,
	calendar_continuum_year_iso_week_number_start_date DATE NOT NULL ENCODE lzo,
	calendar_continuum_year_iso_week_number_end_date DATE NOT NULL ENCODE lzo,
	week_day_number_usa SMALLINT NOT NULL ENCODE lzo,
	week_day_number_eu_iso SMALLINT NOT NULL ENCODE lzo,
	week_day_name VARCHAR(30) NOT NULL ENCODE lzo,
	calendar_quarter_name VARCHAR(6) NOT NULL ENCODE lzo,
	calendar_quarter_number SMALLINT NOT NULL ENCODE lzo,
	calendar_quarter_day_number INTEGER NOT NULL ENCODE lzo,
	calendar_quarter_month_number INTEGER NOT NULL ENCODE lzo,
	calendar_quarter_start_date DATE NOT NULL ENCODE lzo,
	calendar_quarter_end_date DATE NOT NULL ENCODE lzo,
	calendar_year INTEGER NOT NULL ENCODE lzo,
	calendar_year_start_date DATE NOT NULL ENCODE lzo,
	calendar_year_end_date DATE NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.exchange_rate_cartesian
(
	row_id BIGINT ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	dim_date_id INTEGER NOT NULL ENCODE lzo,
	exchange_rate_id BIGINT ENCODE lzo,
	numerator_dim_currency_id SMALLINT NOT NULL ENCODE lzo,
	denominator_dim_currency_id SMALLINT NOT NULL ENCODE lzo,
	exchange_rate NUMERIC(18, 10) NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.exchange_rate_duplicate
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	dim_date_id INTEGER NOT NULL ENCODE lzo,
	numerator_dim_currency_id SMALLINT NOT NULL ENCODE lzo,
	denominator_dim_currency_id SMALLINT NOT NULL ENCODE lzo,
	kept_exchange_rate_row_id BIGINT ENCODE lzo,
	count_of INTEGER ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.exchange_rate_erroneous
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	dim_date_id INTEGER NOT NULL ENCODE lzo,
	numerator_dim_currency_id SMALLINT NOT NULL ENCODE lzo,
	denominator_dim_currency_id SMALLINT NOT NULL ENCODE lzo,
	exchange_rate NUMERIC(18, 10) NOT NULL ENCODE lzo,
	exchange_rate_id BIGINT ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.exchange_rate_measures
(
	row_id BIGINT ENCODE lzo,
	dim_retailer_id INTEGER ENCODE lzo,
	reporting_date DATE NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
	exchange_rate_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	effective_start_date DATE NOT NULL ENCODE lzo,
	effective_end_date DATE NOT NULL ENCODE lzo,
	numerator_iso_currency_code CHAR(3) NOT NULL ENCODE lzo,
	denominator_iso_currency_code CHAR(3) NOT NULL ENCODE lzo,
	exchange_rate NUMERIC(18, 10) NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.fiscal_calendar_dim
(
	row_id INTEGER NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	reporting_date DATE NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
	calendar_date DATE NOT NULL ENCODE lzo,
	dim_date_id INTEGER ENCODE lzo,
	is_weekday7 BOOLEAN ENCODE none,
	is_working_day BOOLEAN ENCODE none,
	is_business_holiday BOOLEAN ENCODE none,
	is_national_holiday BOOLEAN ENCODE none,
	fiscal_date_string CHAR(11) ENCODE lzo,
	fiscal_day_of_month INTEGER ENCODE lzo,
	fiscal_day_with_suffix VARCHAR(6) ENCODE lzo,
	fiscal_month_number INTEGER ENCODE lzo,
	fiscal_month_name VARCHAR(30) ENCODE lzo,
	fiscal_month_start_date DATE ENCODE lzo,
	fiscal_month_end_date DATE ENCODE lzo,
	fiscal_year_month INTEGER ENCODE lzo,
	fiscal_week_number SMALLINT ENCODE lzo,
	fiscal_continuum_week_number SMALLINT DEFAULT 0 ENCODE lzo,
	fiscal_continuum_month_number SMALLINT DEFAULT 0 ENCODE lzo,
	fiscal_continuum_quarter_number SMALLINT DEFAULT 0 ENCODE lzo,
	fiscal_continuum_year_week_number INTEGER ENCODE lzo,
	fiscal_continuum_year_week_number_start_date DATE ENCODE lzo,
	fiscal_continuum_year_week_number_end_date DATE ENCODE lzo,
	fiscal_week_day_number SMALLINT ENCODE lzo,
	fiscal_week_day_name VARCHAR(30) ENCODE lzo,
	fiscal_quarter_name VARCHAR(6) ENCODE lzo,
	fiscal_quarter_number SMALLINT ENCODE lzo,
	fiscal_quarter_day_number INTEGER ENCODE lzo,
	fiscal_quarter_month_number INTEGER ENCODE lzo,
	fiscal_quarter_start_date DATE ENCODE lzo,
	fiscal_quarter_end_date DATE ENCODE lzo,
	fiscal_year INTEGER ENCODE lzo,
	fiscal_year_start_date DATE ENCODE lzo,
	fiscal_year_end_date DATE ENCODE lzo,
	fiscal_year_quarter_month_number CHAR(8) DEFAULT 'YYYYQNMM'::bpchar ENCODE lzo
)
DISTSTYLE EVEN
SORTKEY
(
	dim_date_id,
	dim_retailer_id,
	batch_id
);


CREATE TABLE stage.geography_dim
(
	row_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	reporting_date DATE NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
	location_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	location_type_bkey VARCHAR(20) DEFAULT '0'::character varying NOT NULL ENCODE lzo,
	location_type VARCHAR(20) DEFAULT 'Unknown'::character varying NOT NULL ENCODE lzo,
	location_name VARCHAR(100) NOT NULL ENCODE lzo,
	location_description VARCHAR(256) ENCODE lzo,
	location_subtype VARCHAR(30) ENCODE lzo,
	location_status VARCHAR(20) ENCODE lzo,
	city_town VARCHAR(50) ENCODE lzo,
	county_state VARCHAR(100) ENCODE lzo,
	country VARCHAR(50) ENCODE lzo,
	region VARCHAR(50) ENCODE lzo,
	subregion VARCHAR(100) ENCODE lzo,
	logitude_position DOUBLE PRECISION ENCODE none,
	latitude_position DOUBLE PRECISION ENCODE none,
	trading_start_date DATE ENCODE lzo,
	trading_end_date DATE ENCODE lzo,
	default_cluster VARCHAR(30) ENCODE lzo,
	building_floor_space DOUBLE PRECISION ENCODE none,
	stock_allocation_grade VARCHAR(10) ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.geography_type_mapping
(
	batch_id INTEGER NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	location_type_bkey SMALLINT NOT NULL ENCODE lzo,
	location_bkey VARCHAR(20) NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.geography_type_mapping_dim
(
	row_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	reporting_date DATE NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
	location_type_bkey SMALLINT NOT NULL ENCODE lzo,
	location_bkey VARCHAR(20) NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.hierarchy_node
(
	row_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	hierarchy_node_bkey VARCHAR(50) NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	parent_hierarchy_node_bkey VARCHAR(50) ENCODE lzo,
	hierarchy_node_name VARCHAR(128) NOT NULL ENCODE lzo,
	hierarchy_node_level SMALLINT ENCODE lzo,
	hierarchy_breadcrumb VARCHAR(1024) ENCODE lzo,
	is_leaf_node BOOLEAN DEFAULT 0 ENCODE none
)
DISTSTYLE EVEN;


CREATE TABLE stage.hierarchy_pivoted
(
	hierarchy_name VARCHAR(255) ENCODE lzo,
	business_area VARCHAR(128) ENCODE lzo,
	business_key CHAR(18) ENCODE lzo,
	hierarchy_level0_bkey VARCHAR(20) ENCODE lzo,
	hierarchy_level0 VARCHAR(255) ENCODE lzo,
	hierarchy_level1_bkey VARCHAR(20) ENCODE lzo,
	hierarchy_level1 VARCHAR(255) ENCODE lzo,
	hierarchy_level2_bkey VARCHAR(20) ENCODE lzo,
	hierarchy_level2 VARCHAR(255) ENCODE lzo,
	hierarchy_level3_bkey VARCHAR(20) ENCODE lzo,
	hierarchy_level3 VARCHAR(255) ENCODE lzo,
	hierarchy_level4_bkey VARCHAR(20) ENCODE lzo,
	hierarchy_level4 VARCHAR(255) ENCODE lzo,
	hierarchy_level5_bkey VARCHAR(20) ENCODE lzo,
	hierarchy_level5 VARCHAR(255) ENCODE lzo,
	hierarchy_level6_bkey VARCHAR(20) ENCODE lzo,
	hierarchy_level6 VARCHAR(255) ENCODE lzo,
	hierarchy_level7_bkey VARCHAR(20) ENCODE lzo,
	hierarchy_level7 VARCHAR(255) ENCODE lzo,
	hierarchy_level8_bkey VARCHAR(20) ENCODE lzo,
	hierarchy_level8 VARCHAR(255) ENCODE lzo,
	hierarchy_level9_bkey VARCHAR(20) ENCODE lzo,
	hierarchy_level9 VARCHAR(255) ENCODE lzo,
	analytical_period_start_date DATE ENCODE lzo,
	analytical_period_end_date DATE ENCODE lzo,
	row_id INTEGER NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.hierarchy_relationship
(
	row_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	business_key VARCHAR(255) NOT NULL ENCODE lzo,
	hierarchy_node_level SMALLINT NOT NULL ENCODE lzo,
	child_hierarchy_node_id INTEGER NOT NULL ENCODE lzo,
	parent_hierarchy_node_id INTEGER ENCODE lzo,
	is_broken BOOLEAN NOT NULL ENCODE none
)
DISTSTYLE EVEN;


CREATE TABLE stage.hierarchy_unpivoted
(
	batch_id INTEGER NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	business_key VARCHAR(255) ENCODE lzo,
	hierarchy_node_bkey VARCHAR(50) ENCODE lzo,
	hierarchy_node_name VARCHAR(254) ENCODE lzo,
	hierarchy_level_description VARCHAR(128) ENCODE lzo,
	hierarchy_level INTEGER ENCODE lzo,
	analytical_period_start_date DATE ENCODE lzo,
	analytical_period_end_date DATE ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.markdown_measures
(
	row_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	reporting_date DATE NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
	product_bkey1 VARCHAR(20) ENCODE lzo,
	product_bkey2 VARCHAR(20) DEFAULT 0 ENCODE lzo,
	product_bkey3 VARCHAR(20) DEFAULT 0 ENCODE lzo,
	product_bkey4 VARCHAR(20) DEFAULT 0 ENCODE lzo,
	location_bkey VARCHAR(20) ENCODE lzo,
	iso_currency_code CHAR(3) ENCODE lzo,
	year_seasonality_bkey VARCHAR(20) ENCODE lzo,
	price_status_bkey VARCHAR(20) ENCODE lzo,
	channel_bkey VARCHAR(20) ENCODE lzo,
	gross_margin DOUBLE PRECISION ENCODE none,
	markdown_price DOUBLE PRECISION ENCODE none,
	markdown_cost DOUBLE PRECISION ENCODE none,
	cost_price DOUBLE PRECISION ENCODE none,
	system_price DOUBLE PRECISION ENCODE none,
	selling_price DOUBLE PRECISION ENCODE none,
	original_selling_price DOUBLE PRECISION ENCODE none,
	optimisation_original_selling_price DOUBLE PRECISION ENCODE none,
	provided_selling_price DOUBLE PRECISION ENCODE none,
	provided_original_selling_price DOUBLE PRECISION ENCODE none,
	optimisation_selling_price DOUBLE PRECISION ENCODE none,
	local_tax_rate DOUBLE PRECISION ENCODE none,
	sales_value DOUBLE PRECISION ENCODE none,
	sales_quantity DOUBLE PRECISION ENCODE none,
	store_stock_value DOUBLE PRECISION ENCODE none,
	store_stock_quantity DOUBLE PRECISION ENCODE none,
	depot_stock_value DOUBLE PRECISION ENCODE none,
	depot_stock_quantity DOUBLE PRECISION ENCODE none,
	clearance_sales_value DOUBLE PRECISION ENCODE none,
	clearance_sales_quantity DOUBLE PRECISION ENCODE none,
	promotion_sales_value DOUBLE PRECISION ENCODE none,
	promotion_sales_quantity DOUBLE PRECISION ENCODE none,
	store_stock_value_no_negatives DOUBLE PRECISION ENCODE none,
	store_stock_quantity_no_negatives DOUBLE PRECISION ENCODE none,
	intake_plus_future_commitment_quantity DOUBLE PRECISION ENCODE none,
	intake_plus_future_commitment_value DOUBLE PRECISION ENCODE none,
	total_stock_value DOUBLE PRECISION ENCODE none,
	total_stock_quantity DOUBLE PRECISION ENCODE none
)
DISTSTYLE EVEN;


CREATE TABLE stage.node
(
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	hierarchy_node_id INTEGER NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	hierarchy_node_bkey VARCHAR(50) ENCODE lzo,
	hierarchy_node_name VARCHAR(128) NOT NULL ENCODE lzo,
	hierarchy_node_level SMALLINT DEFAULT 0 NOT NULL ENCODE lzo,
	is_duplicate_bkey BOOLEAN DEFAULT 0 NOT NULL ENCODE none
)
DISTSTYLE EVEN;


CREATE TABLE stage.price_changes_measures
(
	row_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	reporting_date DATE ENCODE lzo,
	reporting_date_period_type SMALLINT ENCODE lzo,
	location_bkey VARCHAR(20) ENCODE lzo,
	product_bkey1 VARCHAR(20) ENCODE lzo,
	product_bkey2 VARCHAR(20) ENCODE lzo,
	product_bkey3 VARCHAR(20) ENCODE lzo,
	product_bkey4 VARCHAR(20) ENCODE lzo,
	channel_bkey VARCHAR(20) ENCODE lzo,
	year_seasonality_bkey VARCHAR(20) ENCODE lzo,
	iso_currency_code VARCHAR(3) ENCODE lzo,
	price_status_bkey SMALLINT ENCODE lzo,
	system_price DOUBLE PRECISION ENCODE none,
	selling_price DOUBLE PRECISION ENCODE none,
	original_selling_price DOUBLE PRECISION ENCODE none
)
DISTSTYLE EVEN;


CREATE TABLE stage.product_dim
(
	row_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	reporting_date DATE NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
	product_bkey1 VARCHAR(20) NOT NULL ENCODE lzo,
	product_bkey2 VARCHAR(20) DEFAULT 0 NOT NULL ENCODE lzo,
	product_bkey3 VARCHAR(20) DEFAULT 0 NOT NULL ENCODE lzo,
	product_bkey4 VARCHAR(20) DEFAULT 0 NOT NULL ENCODE lzo,
	product_name VARCHAR(100) NOT NULL ENCODE lzo,
	product_description VARCHAR(512) ENCODE lzo,
	product_sku_code VARCHAR(50) ENCODE lzo,
	product_size VARCHAR(20) ENCODE lzo,
	product_colour_code CHAR(10) ENCODE lzo,
	product_colour VARCHAR(50) ENCODE lzo,
	product_gender VARCHAR(10) ENCODE lzo,
	product_age_group VARCHAR(50) ENCODE lzo,
	brand_name VARCHAR(100) ENCODE lzo,
	supplier_name VARCHAR(50) ENCODE lzo,
	product_status VARCHAR(30) ENCODE lzo,
	product_planned_end_date DATE ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.product_seasonality_measures
(
	row_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER ENCODE lzo,
	reporting_date VARCHAR(10) NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
	product_bkey1 VARCHAR(20) NOT NULL ENCODE lzo,
	product_bkey2 VARCHAR(20) ENCODE lzo,
	product_bkey3 VARCHAR(20) ENCODE lzo,
	product_bkey4 VARCHAR(20) ENCODE lzo,
	location_bkey VARCHAR(20) ENCODE lzo,
	seasonality_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	year_seasonality_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	year_seasonality_start_date DATE ENCODE lzo,
	year_seasonality_end_date DATE ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.retailer_dim
(
	row_id INTEGER NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	reporting_date DATE NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
	retailer_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	parent_retailer_bkey VARCHAR(20) ENCODE lzo,
	retailer_name VARCHAR(150) NOT NULL ENCODE lzo,
	parent_dim_retailer_id INTEGER ENCODE lzo,
	latest_batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.sales_measures
(
	row_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	reporting_date DATE ENCODE lzo,
	reporting_date_period_type SMALLINT ENCODE lzo,
	location_bkey VARCHAR(20) ENCODE lzo,
	product_bkey1 VARCHAR(20) ENCODE lzo,
	product_bkey2 VARCHAR(20) ENCODE lzo,
	product_bkey3 VARCHAR(20) ENCODE lzo,
	product_bkey4 VARCHAR(20) ENCODE lzo,
	channel_bkey VARCHAR(20) ENCODE lzo,
	year_seasonality_bkey VARCHAR(20) ENCODE lzo,
	iso_currency_code CHAR(3) ENCODE lzo,
	price_status_bkey SMALLINT ENCODE lzo,
	sales_value DOUBLE PRECISION ENCODE none,
	sales_quantity INTEGER ENCODE lzo,
	local_tax_rate DOUBLE PRECISION ENCODE none,
	product_status_bkey VARCHAR(20) ENCODE lzo,
	gross_margin DOUBLE PRECISION ENCODE none,
	sales_cost DOUBLE PRECISION ENCODE none,
	markdown_sales_value DOUBLE PRECISION ENCODE none,
	markdown_sales_quantity INTEGER ENCODE lzo,
	promotion_sales_value DOUBLE PRECISION ENCODE none,
	promotion_sales_quantity INTEGER ENCODE lzo,
	retailer_markdown_cost DOUBLE PRECISION ENCODE none
)
DISTSTYLE EVEN;


CREATE TABLE stage.seasonality_dim
(
	row_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	reporting_date DATE NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
	seasonality_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	year_seasonality_bkey VARCHAR(20) ENCODE lzo,
	seasonality_name VARCHAR(50) NOT NULL ENCODE lzo,
	year_seasonality_name VARCHAR(50) ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.security_role_dim
(
	row_id INTEGER NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	reporting_date DATE NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
	security_role_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	security_role_name VARCHAR(50) NOT NULL ENCODE lzo,
	security_role_description VARCHAR(256) ENCODE lzo
)
DISTSTYLE EVEN;


CREATE TABLE stage.status_dim
(
	row_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER DEFAULT 0 NOT NULL ENCODE lzo,
	reporting_date DATE NOT NULL ENCODE lzo,
	reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
	status_type_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	status_bkey VARCHAR(20) NOT NULL ENCODE lzo,
	parent_status_bkey VARCHAR(20) ENCODE lzo,
	status_type VARCHAR(50) NOT NULL ENCODE lzo,
	status_name VARCHAR(50) NOT NULL ENCODE lzo,
	parent_dim_status_id SMALLINT ENCODE lzo,
	status_hierarchy_level SMALLINT DEFAULT 0 NOT NULL ENCODE lzo,
	status_breadcrumb VARCHAR(512) DEFAULT ''::character varying NOT NULL ENCODE lzo,
	is_leaf_node BOOLEAN DEFAULT 0 NOT NULL ENCODE none
)
DISTSTYLE EVEN;


CREATE TABLE stage.stock_measures
(
	row_id BIGINT NOT NULL ENCODE lzo,
	batch_id INTEGER NOT NULL ENCODE lzo,
	dim_retailer_id INTEGER NOT NULL ENCODE lzo,
	reporting_date DATE ENCODE lzo,
	reporting_date_period_type SMALLINT ENCODE lzo,
	location_bkey VARCHAR(20) ENCODE lzo,
	product_bkey1 VARCHAR(20) ENCODE lzo,
	product_bkey2 VARCHAR(20) ENCODE lzo,
	product_bkey3 VARCHAR(20) ENCODE lzo,
	product_bkey4 VARCHAR(20) ENCODE lzo,
	product_status_key VARCHAR(20) ENCODE lzo,
	iso_currency_code VARCHAR(3) ENCODE lzo,
	stock_value DOUBLE PRECISION ENCODE none,
	stock_quantity INTEGER ENCODE lzo,
	stock_cost DOUBLE PRECISION ENCODE none,
	cost_price DOUBLE PRECISION ENCODE none,
	future_commitment_stock_value DOUBLE PRECISION ENCODE none,
	future_commitment_stock_quantity INTEGER ENCODE lzo,
	future_commitment_stock_cost DOUBLE PRECISION ENCODE none,
	intake_stock_value DOUBLE PRECISION ENCODE none,
	intake_stock_quantity DOUBLE PRECISION ENCODE none,
	intake_stock_cost DOUBLE PRECISION ENCODE none,
	transit_stock_value DOUBLE PRECISION ENCODE none,
	transit_stock_quantity DOUBLE PRECISION ENCODE none,
	transit_stock_cost DOUBLE PRECISION ENCODE none
)
DISTSTYLE EVEN;


CREATE OR REPLACE VIEW markdown_app.uv_dim_channel AS 
 SELECT dc.dim_channel_id, dc.dim_retailer_id, dc.channel_bkey, dc.channel_name, dc.channel_description, dc.channel_code
   FROM conformed.dim_channel dc
  WHERE (EXISTS ( SELECT 1
           FROM conformed.dim_retailer dr
          WHERE dc.batch_id <= dr.latest_batch_id AND dc.dim_retailer_id = dr.dim_retailer_id));


CREATE OR REPLACE VIEW markdown_app.uv_dim_currency AS 
 SELECT dim_currency.dim_currency_id, dim_currency.currency, dim_currency.iso_currency_code, dim_currency.currency_symbol, dim_currency.is_active
   FROM conformed.dim_currency
  WHERE dim_currency.is_active = 1::boolean;


CREATE OR REPLACE VIEW markdown_app.uv_dim_date_fiscal AS 
 SELECT ddf.dim_retailer_id, dd.calendar_date, ddf.dim_date_id, ddf.is_weekday7, ddf.is_working_day, ddf.is_business_holiday, ddf.is_national_holiday, ddf.fiscal_date_string, ddf.fiscal_day_of_month, ddf.fiscal_day_with_suffix, ddf.fiscal_month_number, ddf.fiscal_month_name, ddf.fiscal_month_start_date, ddf.fiscal_month_end_date, ddf.fiscal_year_month, ddf.fiscal_week_number, dd.day_sequence_number AS fiscal_continuum_day_number, ddf.fiscal_continuum_week_number, ddf.fiscal_continuum_month_number, ddf.fiscal_continuum_quarter_number, ddf.fiscal_continuum_year_week_number, ddf.fiscal_continuum_year_week_number_start_date, ddf.fiscal_continuum_year_week_number_end_date, ddf.fiscal_week_day_number, ddf.fiscal_week_day_name, ddf.fiscal_quarter_name, ddf.fiscal_quarter_number, ddf.fiscal_quarter_day_number, ddf.fiscal_quarter_month_number, ddf.fiscal_quarter_start_date, ddf.fiscal_quarter_end_date, ddf.fiscal_year, ddf.fiscal_year_start_date, ddf.fiscal_year_end_date, ddf.fiscal_year_quarter_month_number
   FROM conformed.dim_date_fiscal ddf
   JOIN conformed.dim_date dd ON ddf.dim_date_id = dd.dim_date_id
  WHERE (EXISTS ( SELECT 1
      FROM conformed.dim_retailer dr
     WHERE ddf.batch_id <= dr.latest_batch_id AND ddf.dim_retailer_id = dr.dim_retailer_id));


CREATE OR REPLACE VIEW markdown_app.uv_dim_date_fiscal_week AS 
 SELECT ddf.dim_retailer_id, dd.calendar_date, ddf.dim_date_id, ddf.is_weekday7, ddf.is_working_day, ddf.is_business_holiday, ddf.is_national_holiday, ddf.fiscal_date_string, ddf.fiscal_day_of_month, ddf.fiscal_day_with_suffix, ddf.fiscal_month_number, ddf.fiscal_month_name, ddf.fiscal_month_start_date, ddf.fiscal_month_end_date, ddf.fiscal_year_month, ddf.fiscal_week_number, ddf.fiscal_continuum_week_number, ddf.fiscal_continuum_month_number, ddf.fiscal_continuum_quarter_number, ddf.fiscal_continuum_year_week_number, ddf.fiscal_continuum_year_week_number_start_date, ddf.fiscal_continuum_year_week_number_end_date, ddf.fiscal_week_day_number, ddf.fiscal_week_day_name, ddf.fiscal_quarter_name, ddf.fiscal_quarter_number, ddf.fiscal_quarter_day_number, ddf.fiscal_quarter_month_number, ddf.fiscal_quarter_start_date, ddf.fiscal_quarter_end_date, ddf.fiscal_year, ddf.fiscal_year_start_date, ddf.fiscal_year_end_date, ddf.fiscal_year_quarter_month_number
   FROM conformed.dim_date_fiscal ddf
   JOIN conformed.dim_date dd ON ddf.dim_date_id = dd.dim_date_id
  WHERE ddf.is_weekday7 = 1::boolean AND (EXISTS ( SELECT 1
      FROM conformed.dim_retailer dr
     WHERE ddf.batch_id <= dr.latest_batch_id AND ddf.dim_retailer_id = dr.dim_retailer_id));


CREATE OR REPLACE VIEW markdown_app.uv_dim_geography AS 
 SELECT dg.dim_geography_id, dg.dim_retailer_id, dg.location_bkey, dg.location_type_bkey, dg.effective_start_date_time, dg.effective_end_date_time, dg.location_type, dg.location_name, dg.city_town, dg.county_state, dg.country, dg."region", dg.subregion, dg.logitude_position, dg.latitude_position, dg.trading_start_date, dg.trading_end_date, dg.default_cluster, dg.building_floor_space, dg.stock_allocation_grade, dh.dim_hierarchy_id, 
        CASE
            WHEN dhd.dim_hierarchy_id IS NOT NULL THEN 1::boolean
            ELSE 0::boolean
        END AS is_default_hierarchy, dh.hierarchy_name, COALESCE(dhn10.dim_hierarchy_node_id, dhn9.dim_hierarchy_node_id, dhn8.dim_hierarchy_node_id, dhn7.dim_hierarchy_node_id, dhn6.dim_hierarchy_node_id, dhn5.dim_hierarchy_node_id, dhn4.dim_hierarchy_node_id, dhn3.dim_hierarchy_node_id, dhn2.dim_hierarchy_node_id, dhn.dim_hierarchy_node_id) AS dim_hierarchy_node_id, dhn.hierarchy_node_name AS hierarchy_level_0, dhn2.hierarchy_node_name AS hierarchy_level_1, dhn3.hierarchy_node_name AS hierarchy_level_2, dhn4.hierarchy_node_name AS hierarchy_level_3, dhn5.hierarchy_node_name AS hierarchy_level_4, dhn6.hierarchy_node_name AS hierarchy_level_5, dhn7.hierarchy_node_name AS hierarchy_level_6, dhn8.hierarchy_node_name AS hierarchy_level_7, dhn9.hierarchy_node_name AS hierarchy_level_8, dhn10.hierarchy_node_name AS hierarchy_level_9
   FROM conformed.dim_geography dg
   LEFT JOIN (conformed.bridge_geography_hierarchy bgh
   JOIN (conformed.dim_hierachy_subject dhs
   JOIN conformed.dim_hierarchy dh ON dhs.dim_hierarchy_subject_id = dh.dim_hierarchy_subject_id AND dhs.hierarchy_subject_bkey::text = 'GEOGRAPHY'::character varying::text
   LEFT JOIN conformed.dim_hierachy_default dhd ON dh.dim_hierarchy_id = dhd.dim_hierarchy_id
   JOIN conformed.dim_hierarchy_node dhn ON dh.dim_hierarchy_id = dhn.dim_hierarchy_id AND dhn.parent_dim_hierarchy_node_id IS NULL AND getdate() >= dhn.effective_start_date_time AND getdate() <= dhn.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn2 ON dhn.dim_hierarchy_node_id = dhn2.parent_dim_hierarchy_node_id AND getdate() >= dhn2.effective_start_date_time AND getdate() <= dhn2.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn3 ON dhn2.dim_hierarchy_node_id = dhn3.parent_dim_hierarchy_node_id AND getdate() >= dhn3.effective_start_date_time AND getdate() <= dhn3.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn4 ON dhn3.dim_hierarchy_node_id = dhn4.parent_dim_hierarchy_node_id AND getdate() >= dhn4.effective_start_date_time AND getdate() <= dhn4.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn5 ON dhn4.dim_hierarchy_node_id = dhn5.parent_dim_hierarchy_node_id AND getdate() >= dhn5.effective_start_date_time AND getdate() <= dhn5.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn6 ON dhn5.dim_hierarchy_node_id = dhn6.parent_dim_hierarchy_node_id AND getdate() >= dhn6.effective_start_date_time AND getdate() <= dhn6.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn7 ON dhn6.dim_hierarchy_node_id = dhn7.parent_dim_hierarchy_node_id AND getdate() >= dhn7.effective_start_date_time AND getdate() <= dhn7.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn8 ON dhn7.dim_hierarchy_node_id = dhn8.parent_dim_hierarchy_node_id AND getdate() >= dhn8.effective_start_date_time AND getdate() <= dhn8.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn9 ON dhn8.dim_hierarchy_node_id = dhn9.parent_dim_hierarchy_node_id AND getdate() >= dhn9.effective_start_date_time AND getdate() <= dhn9.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn10 ON dhn9.dim_hierarchy_node_id = dhn10.parent_dim_hierarchy_node_id AND getdate() >= dhn10.effective_start_date_time AND getdate() <= dhn10.effective_end_date_time) ON COALESCE(dhn10.dim_hierarchy_node_id, dhn9.dim_hierarchy_node_id, dhn8.dim_hierarchy_node_id, dhn7.dim_hierarchy_node_id, dhn6.dim_hierarchy_node_id, dhn5.dim_hierarchy_node_id, dhn4.dim_hierarchy_node_id, dhn3.dim_hierarchy_node_id, dhn2.dim_hierarchy_node_id, dhn.dim_hierarchy_node_id) = bgh.dim_hierarchy_node_id AND getdate() >= bgh.effective_start_date_time AND getdate() <= bgh.effective_end_date_time) ON dg.dim_geography_id = bgh.dim_geography_id
  WHERE getdate() >= dg.effective_start_date_time AND getdate() <= dg.effective_end_date_time AND (EXISTS ( SELECT 1
   FROM conformed.dim_retailer dr
  WHERE dg.batch_id <= dr.latest_batch_id AND dg.dim_retailer_id = dr.dim_retailer_id));


CREATE OR REPLACE VIEW markdown_app.uv_dim_hierarchy AS 
 SELECT dh.dim_hierarchy_id, dh.batch_id, dh.dim_retailer_id, dh.hierarchy_name, dhs.hierarchy_subject, 
        CASE
            WHEN dhd.dim_hierarchy_id IS NOT NULL THEN 1::boolean
            ELSE 0::boolean
        END AS is_default_hierarchy
   FROM conformed.dim_hierachy_subject dhs
   JOIN conformed.dim_hierarchy dh ON dhs.dim_hierarchy_subject_id = dh.dim_hierarchy_subject_id
   LEFT JOIN conformed.dim_hierachy_default dhd ON dh.dim_hierarchy_id = dhd.dim_hierarchy_id
  WHERE (EXISTS ( SELECT 1
   FROM conformed.dim_retailer dr
  WHERE dh.batch_id <= dr.latest_batch_id AND dh.dim_retailer_id = dr.dim_retailer_id));


CREATE OR REPLACE VIEW markdown_app.uv_dim_hierarchy_node AS 
 SELECT dhn.dim_hierarchy_node_id, dhn.batch_id, dh.dim_retailer_id, dhn.dim_hierarchy_id, dhn.hierarchy_node_bkey, dhn.parent_hierarchy_node_bkey, dhn.parent_dim_hierarchy_node_id, dhn.effective_start_date_time, dhn.effective_end_date_time, dhn.hierarchy_node_name, dhn.hierarchy_node_level, dhn.hierarchy_breadcrumb_node_name, dhn.hierarchy_breadcrumb_node_id, dhn.is_leaf_node
   FROM conformed.dim_hierarchy dh
   JOIN conformed.dim_hierarchy_node dhn ON dh.dim_hierarchy_id = dhn.dim_hierarchy_id
  WHERE (EXISTS ( SELECT 1
      FROM conformed.dim_retailer dr
     WHERE dh.batch_id <= dr.latest_batch_id AND dh.dim_retailer_id = dr.dim_retailer_id));


CREATE OR REPLACE VIEW markdown_app.uv_dim_price_status AS 
 SELECT dim_status.dim_status_id AS dim_price_status_id, dim_status.batch_id, dim_status.status_bkey AS price_status_bkey, dim_status.status_name AS price_status, dim_status.status_breadcrumb, dim_status.is_leaf_node
   FROM conformed.dim_status
  WHERE dim_status.status_type_bkey::text = '2'::character varying::text;


CREATE OR REPLACE VIEW markdown_app.uv_dim_product AS 
 SELECT dp.dim_product_id, dp.dim_retailer_id, dp.product_bkey1, dp.product_bkey2, dp.product_bkey3, dp.product_bkey4, dp.effective_start_date_time, dp.effective_end_date_time, dp.product_name, dp.product_description, dp.product_sku_code, dp.product_size, dp.product_colour_code, dp.product_colour, dp.product_gender, dp.product_age_group, dp.brand_name, dp.supplier_name, dp.product_status, dp.product_planned_end_date, dh.dim_hierarchy_id, 
        CASE
            WHEN dhd.dim_hierarchy_id IS NOT NULL THEN 1::boolean
            ELSE 0::boolean
        END AS is_default_hierarchy, dh.hierarchy_name, COALESCE(dhn10.dim_hierarchy_node_id, dhn9.dim_hierarchy_node_id, dhn8.dim_hierarchy_node_id, dhn7.dim_hierarchy_node_id, dhn6.dim_hierarchy_node_id, dhn5.dim_hierarchy_node_id, dhn4.dim_hierarchy_node_id, dhn3.dim_hierarchy_node_id, dhn2.dim_hierarchy_node_id, dhn.dim_hierarchy_node_id) AS dim_hierarchy_node_id, dhn.hierarchy_node_name AS hierarchy_level_0, dhn2.hierarchy_node_name AS hierarchy_level_1, dhn3.hierarchy_node_name AS hierarchy_level_2, dhn4.hierarchy_node_name AS hierarchy_level_3, dhn5.hierarchy_node_name AS hierarchy_level_4, dhn6.hierarchy_node_name AS hierarchy_level_5, dhn7.hierarchy_node_name AS hierarchy_level_6, dhn8.hierarchy_node_name AS hierarchy_level_7, dhn9.hierarchy_node_name AS hierarchy_level_8, dhn10.hierarchy_node_name AS hierarchy_level_9
   FROM conformed.dim_product dp
   LEFT JOIN (conformed.bridge_product_hierarchy bph
   JOIN (conformed.dim_hierachy_subject dhs
   JOIN conformed.dim_hierarchy dh ON dhs.dim_hierarchy_subject_id = dh.dim_hierarchy_subject_id AND dhs.hierarchy_subject_bkey::text = 'PRODUCT'::character varying::text
   LEFT JOIN conformed.dim_hierachy_default dhd ON dh.dim_hierarchy_id = dhd.dim_hierarchy_id
   JOIN conformed.dim_hierarchy_node dhn ON dh.dim_hierarchy_id = dhn.dim_hierarchy_id AND dhn.parent_dim_hierarchy_node_id IS NULL AND getdate() >= dhn.effective_start_date_time AND getdate() <= dhn.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn2 ON dhn.dim_hierarchy_node_id = dhn2.parent_dim_hierarchy_node_id AND getdate() >= dhn2.effective_start_date_time AND getdate() <= dhn2.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn3 ON dhn2.dim_hierarchy_node_id = dhn3.parent_dim_hierarchy_node_id AND getdate() >= dhn3.effective_start_date_time AND getdate() <= dhn3.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn4 ON dhn3.dim_hierarchy_node_id = dhn4.parent_dim_hierarchy_node_id AND getdate() >= dhn4.effective_start_date_time AND getdate() <= dhn4.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn5 ON dhn4.dim_hierarchy_node_id = dhn5.parent_dim_hierarchy_node_id AND getdate() >= dhn5.effective_start_date_time AND getdate() <= dhn5.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn6 ON dhn5.dim_hierarchy_node_id = dhn6.parent_dim_hierarchy_node_id AND getdate() >= dhn6.effective_start_date_time AND getdate() <= dhn6.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn7 ON dhn6.dim_hierarchy_node_id = dhn7.parent_dim_hierarchy_node_id AND getdate() >= dhn7.effective_start_date_time AND getdate() <= dhn7.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn8 ON dhn7.dim_hierarchy_node_id = dhn8.parent_dim_hierarchy_node_id AND getdate() >= dhn8.effective_start_date_time AND getdate() <= dhn8.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn9 ON dhn8.dim_hierarchy_node_id = dhn9.parent_dim_hierarchy_node_id AND getdate() >= dhn9.effective_start_date_time AND getdate() <= dhn9.effective_end_date_time
   LEFT JOIN conformed.dim_hierarchy_node dhn10 ON dhn9.dim_hierarchy_node_id = dhn10.parent_dim_hierarchy_node_id AND getdate() >= dhn10.effective_start_date_time AND getdate() <= dhn10.effective_end_date_time) ON COALESCE(dhn10.dim_hierarchy_node_id, dhn9.dim_hierarchy_node_id, dhn8.dim_hierarchy_node_id, dhn7.dim_hierarchy_node_id, dhn6.dim_hierarchy_node_id, dhn5.dim_hierarchy_node_id, dhn4.dim_hierarchy_node_id, dhn3.dim_hierarchy_node_id, dhn2.dim_hierarchy_node_id, dhn.dim_hierarchy_node_id) = bph.dim_hierarchy_node_id AND getdate() >= bph.effective_start_date_time AND getdate() <= bph.effective_end_date_time) ON dp.dim_product_id = bph.dim_product_id
  WHERE getdate() >= dp.effective_start_date_time AND getdate() <= dp.effective_end_date_time AND (EXISTS ( SELECT 1
   FROM conformed.dim_retailer dr
  WHERE dp.batch_id <= dr.latest_batch_id AND dp.dim_retailer_id = dr.dim_retailer_id));


CREATE OR REPLACE VIEW markdown_app.uv_dim_seasonality AS 
 SELECT ds.dim_seasonality_id, ds.batch_id, ds.dim_retailer_id, ds.seasonality_bkey, ds.seasonality_name
   FROM conformed.dim_seasonality ds
  WHERE (EXISTS ( SELECT 1
           FROM conformed.dim_retailer dr
          WHERE ds.batch_id <= dr.latest_batch_id AND ds.dim_retailer_id = dr.dim_retailer_id));


CREATE OR REPLACE VIEW markdown_app.uv_fact_daily_price AS 
 SELECT fdp.batch_id, fdp.dim_date_id, fdp.dim_retailer_id, fdp.dim_product_id, fdp.dim_geography_id, fdp.dim_currency_id, fdp.dim_channel_id, fdp.dim_seasonality_id, fdp.dim_price_status_id, fdp.system_price, fdp.selling_price, fdp.original_selling_price, fdp.previous_selling_price
   FROM sales.fact_daily_price fdp
  WHERE (EXISTS ( SELECT 1
           FROM conformed.dim_retailer dr
          WHERE fdp.dim_retailer_id = dr.dim_retailer_id AND fdp.batch_id <= dr.latest_batch_id));


CREATE OR REPLACE VIEW markdown_app.uv_fact_weekly_markdown_v2 AS 
 SELECT fwsm.batch_id, fwsm.dim_date_id, fwsm.dim_retailer_id, fwsm.dim_product_id, fwsm.dim_geography_id, fwsm.dim_currency_id, fwsm.dim_seasonality_id, fwsm.dim_junk_id, fwsm.dim_price_status_id, fwsm.dim_channel_id, fwsm.gross_margin, fwsm.markdown_price, fwsm.markdown_cost, fwsm.cost_price, fwsm.system_price, fwsm.selling_price, fwsm.original_selling_price, fwsm.optimisation_original_selling_price, fwsm.provided_selling_price, fwsm.provided_original_selling_price, fwsm.optimisation_selling_price, fwsm.local_tax_rate, fwsm.sales_value, fwsm.sales_quantity, fwsm.store_stock_value, fwsm.store_stock_quantity, fwsm.depot_stock_value, fwsm.depot_stock_quantity, fwsm.clearance_sales_value, fwsm.clearance_sales_quantity, fwsm.promotion_sales_value, fwsm.promotion_sales_quantity, fwsm.store_stock_value_no_negatives, fwsm.store_stock_quantity_no_negatives, fwsm.intake_plus_future_commitment_quantity, fwsm.intake_plus_future_commitment_value, fwsm.total_stock_value, fwsm.total_stock_quantity
   FROM markdown.fact_weekly_sales_markdown fwsm
  WHERE (EXISTS ( SELECT 1
           FROM conformed.dim_retailer dr
          WHERE fwsm.dim_retailer_id = dr.dim_retailer_id AND fwsm.batch_id <= dr.latest_batch_id));


CREATE OR REPLACE VIEW markdown_app.uv_fact_weekly_sales AS 
 SELECT fws.batch_id, fws.dim_date_id, fws.dim_retailer_id, fws.dim_product_id, fws.dim_geography_id, fws.dim_currency_id, fws.dim_seasonality_id, fws.dim_price_status_id, fws.dim_channel_id, fws.dim_product_status_id, fws.gross_margin, fws.sales_value, fws.sales_quantity, fws.local_tax_rate, fws.sales_cost, fws.markdown_sales_value, fws.markdown_sales_quantity, fws.promotion_sales_value, fws.promotion_sales_quantity, fws.retailer_markdown_cost
   FROM sales.fact_weekly_sales fws
  WHERE (EXISTS ( SELECT 1
           FROM conformed.dim_retailer dr
          WHERE fws.dim_retailer_id = dr.dim_retailer_id AND fws.batch_id <= dr.latest_batch_id));


CREATE OR REPLACE VIEW markdown_app.uv_fact_weekly_sales_basic AS 
 SELECT fwsm.dim_date_id, fwsm.dim_retailer_id, fwsm.dim_product_id, fwsm.dim_geography_id, fwsm.dim_currency_id, fwsm.dim_seasonality_id, fwsm.dim_junk_id, fwsm.dim_price_status_id, fwsm.dim_channel_id, fwsm.gross_margin AS scanned_margin, fwsm.clearance_sales_value, fwsm.clearance_sales_quantity, fwsm.promotion_sales_value, fwsm.promotion_sales_quantity, fwsm.store_stock_value_no_negatives, fwsm.store_stock_quantity_no_negatives, fwsm.markdown_price, fwsm.system_price AS full_price, fwsm.provided_selling_price AS provided_csp, fwsm.provided_original_selling_price AS provided_osp, fwsm.selling_price AS current_selling_price, fwsm.original_selling_price, fwsm.cost_price, fwsm.store_stock_value, fwsm.store_stock_quantity, fwsm.depot_stock_value, fwsm.depot_stock_quantity, fwsm.local_tax_rate AS vat, fwsm.sales_value, fwsm.sales_quantity, fwsm.intake_plus_future_commitment_quantity, fwsm.intake_plus_future_commitment_value, fwsm.total_stock_value, fwsm.total_stock_quantity, fwsm.markdown_cost, fwsm.optimisation_selling_price AS optimisation_csp, fwsm.optimisation_original_selling_price AS optimisation_osp
   FROM markdown.fact_weekly_sales_markdown fwsm
  WHERE (EXISTS ( SELECT 1
           FROM conformed.dim_retailer dr
          WHERE fwsm.batch_id <= dr.latest_batch_id AND fwsm.dim_retailer_id = dr.dim_retailer_id));


CREATE OR REPLACE VIEW markdown_app.uv_fact_weekly_sales_basic_aggregated AS 
 SELECT dt.dim_product_id, dt.fiscal_continuum_week_number, dt.optimisation_osp, dt.optimisation_csp, dt.sales_quantity, dt.total_sales_quantity, dt.total_sales_value, dt.sum_total_stock_quantity, dt.total_stock_quantity, dt.total_stock_value, dt.total_store_stock_quantity, dt.total_store_stock_value, dt.total_depot_stock_quantity, dt.total_depot_stock_value, dt.total_intake_plus_future_commitment_quantity, dt.total_intake_plus_future_commitment_value, dt.cost_price, dt.price_status, dt.price_status_id, dt.previous_price_status, dt.previous_price_status_id, 
        CASE
            WHEN dt.price_status_id::text = 2::character varying::text AND dt.previous_price_status_id = 3::character varying::text THEN 1
            ELSE 0
        END AS is_md_preceded_by_promotion, 
        CASE
            WHEN dt.price_status_id::text = 3::character varying::text THEN 1
            ELSE 0
        END AS is_promotional_price_change, 
        CASE
            WHEN dt.price_status_id::text = 1::character varying::text THEN 1
            ELSE 0
        END AS is_full_price
   FROM ( SELECT fwsb.dim_product_id, ddwuv.fiscal_continuum_week_number, "max"(fwsb.optimisation_osp)::numeric(34,4) AS optimisation_osp, avg(fwsb.optimisation_csp)::numeric(34,4) AS optimisation_csp, avg(fwsb.sales_quantity)::integer AS sales_quantity, sum(fwsb.sales_quantity)::integer AS total_sales_quantity, sum(fwsb.sales_value)::integer AS total_sales_value, sum(fwsb.total_stock_quantity)::integer AS sum_total_stock_quantity, avg(fwsb.total_stock_quantity)::integer AS total_stock_quantity, sum(fwsb.total_stock_value)::integer AS total_stock_value, sum(fwsb.store_stock_quantity)::integer AS total_store_stock_quantity, sum(fwsb.store_stock_value)::integer AS total_store_stock_value, sum(fwsb.depot_stock_quantity)::integer AS total_depot_stock_quantity, sum(fwsb.depot_stock_value)::integer AS total_depot_stock_value, sum(fwsb.intake_plus_future_commitment_quantity)::integer AS total_intake_plus_future_commitment_quantity, sum(fwsb.intake_plus_future_commitment_value)::integer AS total_intake_plus_future_commitment_value, avg(fwsb.cost_price)::numeric(34,4) AS cost_price, cps.price_status, cps.price_status_bkey AS price_status_id, pg_catalog.lead(cps.price_status::text, 1)
          OVER( 
          PARTITION BY fwsb.dim_product_id
          ORDER BY ddwuv.fiscal_continuum_week_number DESC) AS previous_price_status, pg_catalog.lead(cps.price_status_bkey::text, 1)
          OVER( 
          PARTITION BY fwsb.dim_product_id
          ORDER BY ddwuv.fiscal_continuum_week_number DESC) AS previous_price_status_id
           FROM markdown_app.uv_dim_date_fiscal_week ddwuv
      JOIN markdown_app.uv_fact_weekly_sales_basic fwsb ON ddwuv.dim_date_id = fwsb.dim_date_id
   JOIN ( SELECT pg_catalog.row_number()
             OVER( 
             PARTITION BY cpsbc.dim_product_id, cpsbc.fiscal_continuum_week_number
             ORDER BY cpsbc.total_stock_quantity DESC) AS rank, cpsbc.dim_product_id, cpsbc.fiscal_continuum_week_number, cpsbc.price_status, cpsbc.price_status_bkey, cpsbc.price_status_rank, cpsbc.total_stock_quantity
              FROM ( SELECT fwsb.dim_product_id, ddwuv.fiscal_continuum_week_number, dps.price_status, dps.price_status_bkey, pg_catalog.dense_rank()
                     OVER( 
                     PARTITION BY fwsb.dim_product_id, ddwuv.fiscal_continuum_week_number
                     ORDER BY count(dps.price_status) DESC) AS price_status_rank, sum(fwsb.total_stock_quantity) AS total_stock_quantity
                      FROM markdown_app.uv_dim_date_fiscal_week ddwuv
                 JOIN markdown_app.uv_fact_weekly_sales_basic fwsb ON ddwuv.dim_date_id = fwsb.dim_date_id
            JOIN markdown_app.uv_dim_price_status dps ON fwsb.dim_price_status_id = dps.dim_price_status_id
           GROUP BY fwsb.dim_product_id, ddwuv.fiscal_continuum_week_number, dps.price_status, dps.price_status_bkey) cpsbc
             WHERE cpsbc.price_status_rank = 1
             GROUP BY cpsbc.dim_product_id, cpsbc.fiscal_continuum_week_number, cpsbc.price_status, cpsbc.price_status_bkey, cpsbc.price_status_rank, cpsbc.total_stock_quantity) cps ON cps.dim_product_id = fwsb.dim_product_id AND cps.fiscal_continuum_week_number = ddwuv.fiscal_continuum_week_number AND cps.rank = 1
  WHERE fwsb.dim_retailer_id = 1 AND fwsb.optimisation_csp IS NOT NULL
  GROUP BY fwsb.dim_product_id, ddwuv.fiscal_continuum_week_number, cps.price_status, cps.price_status_bkey, cps.price_status_rank) dt;


CREATE OR REPLACE VIEW markdown_app.uv_fact_weekly_stock AS 
 SELECT fws.batch_id, fws.dim_date_id, fws.dim_retailer_id, fws.dim_product_id, fws.dim_geography_id, fws.dim_currency_id, fws.stock_value, fws.stock_quantity, fws.stock_cost, fws.cost_price, fws.future_commitment_stock_value, fws.future_commitment_stock_quantity, fws.future_commitment_stock_cost, fws.intake_stock_value, fws.intake_stock_quantity, fws.intake_stock_cost, fws.transit_stock_value, fws.transit_stock_quantity, fws.transit_stock_cost
   FROM sales.fact_weekly_stock fws
  WHERE (EXISTS ( SELECT 1
           FROM conformed.dim_retailer dr
          WHERE fws.dim_retailer_id = dr.dim_retailer_id AND fws.batch_id <= dr.latest_batch_id));


CREATE OR REPLACE VIEW stage.uv_dedup_node AS 
 SELECT min(n.hierarchy_node_id) AS hierarchy_node_id, d.hierarchy_node_bkey, d.hierarchy_node_name, d.hierarchy_node_level
   FROM ( SELECT n.hierarchy_node_bkey, 
                CASE
                    WHEN n.is_duplicate_bkey = 0::boolean THEN n.hierarchy_node_name
                    ELSE 'Unknown Duplicate Name'::character varying
                END AS hierarchy_node_name, min(n.hierarchy_node_level) AS hierarchy_node_level
           FROM stage.node n
          GROUP BY n.hierarchy_node_bkey, 
                CASE
                    WHEN n.is_duplicate_bkey = 0::boolean THEN n.hierarchy_node_name
                    ELSE 'Unknown Duplicate Name'::character varying
                END) d
   JOIN stage.node n ON d.hierarchy_node_bkey::text = n.hierarchy_node_bkey::text AND d.hierarchy_node_level = n.hierarchy_node_level
  GROUP BY d.hierarchy_node_bkey, d.hierarchy_node_name, d.hierarchy_node_level;


CREATE OR REPLACE VIEW stage.uv_hierarchy_relationship_leaf_members AS 
 SELECT hr.parent_hierarchy_node_id, hr.child_hierarchy_node_id, hr.hierarchy_node_level, hr.business_key, hr.is_broken
   FROM stage.hierarchy_relationship hr
  WHERE (EXISTS ( SELECT 1
           FROM ( SELECT hr.business_key, "max"(hr.hierarchy_node_level) AS hierarchy_node_level
                   FROM stage.hierarchy_relationship hr
                  GROUP BY hr.business_key) ml
          WHERE hr.business_key::text = ml.business_key::text AND hr.hierarchy_node_level = ml.hierarchy_node_level));


CREATE OR REPLACE VIEW stage.uv_normalised_hierarchy_relationship AS 
 SELECT hr.parent_hierarchy_node_id, hr.child_hierarchy_node_id
   FROM stage.hierarchy_relationship hr
  WHERE hr.is_broken = 0::boolean
  GROUP BY hr.parent_hierarchy_node_id, hr.child_hierarchy_node_id;


