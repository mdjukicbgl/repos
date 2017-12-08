
---------------------------------------------------------------------------------------------------
-- dim_retailer_id added for status_dim & currency_dim - Need to replace the DDL definitions below
---------------------------------------------------------------------------------------------------







CREATE SCHEMA IF NOT EXISTS conformed;

CREATE SCHEMA IF NOT EXISTS markdown;

CREATE SCHEMA IF NOT EXISTS markdown_app;

CREATE SCHEMA IF NOT EXISTS sales;

CREATE SCHEMA IF NOT EXISTS stage;

CREATE TABLE IF NOT EXISTS conformed.bridge_geography_hierarchy ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_hierarchy_node_id bigint  NOT NULL ,
	dim_geography_id     integer  NOT NULL ,
	dim_retailer_id      integer DEFAULT 1 NOT NULL ,
	effective_start_date_time timestamp  NOT NULL ,
	effective_end_date_time timestamp DEFAULT '2500-01-01 00:00:00'::timestamp without time zone NOT NULL ,
	CONSTRAINT pk_bridge_geography_hierarchy PRIMARY KEY ( dim_hierarchy_node_id, dim_geography_id, effective_end_date_time )
 ) DISTKEY (dim_geography_id) COMPOUND SORTKEY (dim_hierarchy_node_id, dim_geography_id, dim_retailer_id, effective_end_date_time, effective_start_date_time);

CREATE TABLE IF NOT EXISTS conformed.bridge_hierarchy_level_subject ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_level_subject_id integer  NOT NULL ,
	dim_hierarchy_id     integer  NOT NULL ,
	hierarchy_node_level smallint DEFAULT 0 NOT NULL ,
	dim_retailer_id      integer DEFAULT 1 NOT NULL ,
	CONSTRAINT pk_bridge_hierarchy_level_subject PRIMARY KEY ( dim_level_subject_id, dim_hierarchy_id, hierarchy_node_level )
 ) DISTKEY (dim_hierarchy_id);

CREATE TABLE IF NOT EXISTS conformed.bridge_product_hierarchy ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_product_id       bigint  NOT NULL ,
	dim_hierarchy_node_id bigint  NOT NULL ,
	dim_retailer_id      integer DEFAULT 1 NOT NULL ,
	effective_start_date_time timestamp  NOT NULL ,
	effective_end_date_time timestamp DEFAULT '2500-01-01 00:00:00'::timestamp without time zone NOT NULL ,
	CONSTRAINT pk_bridge_product_hierarchy PRIMARY KEY ( dim_product_id, dim_hierarchy_node_id, effective_end_date_time )
 ) DISTKEY (dim_product_id) COMPOUND SORTKEY (dim_product_id, dim_hierarchy_node_id, dim_retailer_id, effective_end_date_time, effective_start_date_time, batch_id);

CREATE TABLE IF NOT EXISTS conformed.dim_channel ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_channel_id       integer  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	channel_bkey         varchar(20)  NOT NULL ,
	channel_name         varchar(50)  NOT NULL ,
	channel_description  varchar(250)   ,
	channel_code         varchar(10)   ,
	CONSTRAINT pk_dim_channel PRIMARY KEY ( dim_channel_id )
 )  COMPOUND SORTKEY (dim_channel_id, dim_retailer_id, channel_bkey, channel_name, batch_id);

CREATE TABLE IF NOT EXISTS conformed.dim_currency ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_currency_id      smallint  NOT NULL ,
	currency_bkey        varchar(20)  NOT NULL ,
	currency             varchar(50)  NOT NULL ,
	iso_currency_code    char(3)  NOT NULL ,
	currency_symbol      varchar(4)   ,
	is_active            bool DEFAULT 1 NOT NULL ,
	CONSTRAINT pk_dim_currency PRIMARY KEY ( dim_currency_id )
 )  COMPOUND SORTKEY (dim_currency_id, iso_currency_code, currency_bkey, is_active, batch_id);

CREATE TABLE IF NOT EXISTS conformed.dim_date ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_date_id          integer  NOT NULL ,
	day_sequence_number  integer  NOT NULL ,
	week_sequence_number_usa integer DEFAULT 0 NOT NULL ,
	week_sequence_number_eu_iso integer DEFAULT 0 NOT NULL ,
	month_sequence_number smallint DEFAULT 0 NOT NULL ,
	calendar_date        date  NOT NULL ,
	is_weekday7_usa      bool  NOT NULL ,
	is_weekday7_eu_iso   bool  NOT NULL ,
	calendar_date_eu     char(10)  NOT NULL ,
	calendar_date_usa    char(10)  NOT NULL ,
	calendar_day_of_month integer  NOT NULL ,
	day_with_suffix      varchar(6)  NOT NULL ,
	calendar_month_number integer  NOT NULL ,
	calendar_month_name  varchar(30)  NOT NULL ,
	calendar_month_start_date date  NOT NULL ,
	calendar_month_end_date date  NOT NULL ,
	calendar_year_month  integer  NOT NULL ,
	calendar_week_number_usa smallint  NOT NULL ,
	calendar_week_number_eu smallint  NOT NULL ,
	calendar_continuum_year_week_number_usa integer  NOT NULL ,
	calendar_continuum_year_week_number_eu integer  NOT NULL ,
	calendar_continuum_year_week_number_usa_start_date date  NOT NULL ,
	calendar_continuum_year_week_number_usa_end_date date  NOT NULL ,
	calendar_continuum_year_week_number_eu_start_date date  NOT NULL ,
	calendar_continuum_year_week_number_eu_end_date date  NOT NULL ,
	calendar_iso_week_number integer  NOT NULL ,
	calendar_continuum_year_iso_week_number integer  NOT NULL ,
	calendar_continuum_year_iso_week_number_start_date date  NOT NULL ,
	calendar_continuum_year_iso_week_number_end_date date  NOT NULL ,
	week_day_number_usa  smallint  NOT NULL ,
	week_day_number_eu_iso smallint  NOT NULL ,
	week_day_name        varchar(30)  NOT NULL ,
	calendar_quarter_name varchar(6)  NOT NULL ,
	calendar_quarter_number smallint  NOT NULL ,
	calendar_quarter_day_number integer  NOT NULL ,
	calendar_quarter_month_number integer  NOT NULL ,
	calendar_quarter_start_date date  NOT NULL ,
	calendar_quarter_end_date date  NOT NULL ,
	calendar_year        integer  NOT NULL ,
	calendar_year_start_date date  NOT NULL ,
	calendar_year_end_date date  NOT NULL ,
	CONSTRAINT pk_dim_date PRIMARY KEY ( dim_date_id )
 )  COMPOUND SORTKEY (dim_date_id, calendar_date, month_sequence_number, week_sequence_number_usa, week_sequence_number_eu_iso, day_sequence_number);

CREATE TABLE IF NOT EXISTS conformed.dim_date_fiscal ( 
	batch_id             integer  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	dim_date_id          integer  NOT NULL ,
	is_weekday7          bool  NOT NULL ,
	is_working_day       bool  NOT NULL ,
	is_business_holiday  bool  NOT NULL ,
	is_national_holiday  bool  NOT NULL ,
	fiscal_date_string   char(11)  NOT NULL ,
	fiscal_day_of_month  integer  NOT NULL ,
	fiscal_day_with_suffix varchar(6)  NOT NULL ,
	fiscal_month_number  integer  NOT NULL ,
	fiscal_month_name    varchar(30)  NOT NULL ,
	fiscal_month_start_date date  NOT NULL ,
	fiscal_month_end_date date  NOT NULL ,
	fiscal_year_month    integer  NOT NULL ,
	fiscal_week_number   int2  NOT NULL ,
	fiscal_continuum_week_number smallint DEFAULT 0 NOT NULL ,
	fiscal_continuum_month_number smallint DEFAULT 0 NOT NULL ,
	fiscal_continuum_quarter_number smallint DEFAULT o  ,
	fiscal_continuum_year_week_number integer  NOT NULL ,
	fiscal_continuum_year_week_number_start_date date  NOT NULL ,
	fiscal_continuum_year_week_number_end_date date  NOT NULL ,
	fiscal_week_day_number int2  NOT NULL ,
	fiscal_week_day_name varchar(30)  NOT NULL ,
	fiscal_quarter_name  varchar(6)  NOT NULL ,
	fiscal_quarter_number int2  NOT NULL ,
	fiscal_quarter_day_number integer  NOT NULL ,
	fiscal_quarter_month_number integer  NOT NULL ,
	fiscal_quarter_start_date date  NOT NULL ,
	fiscal_quarter_end_date date  NOT NULL ,
	fiscal_year          integer  NOT NULL ,
	fiscal_year_start_date date  NOT NULL ,
	fiscal_year_end_date date  NOT NULL ,
	CONSTRAINT pk_dim_date_fiscal PRIMARY KEY ( dim_retailer_id, dim_date_id )
 )  COMPOUND SORTKEY (dim_date_id, dim_retailer_id, batch_id);

CREATE TABLE IF NOT EXISTS conformed.dim_geography ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_geography_id     integer  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	location_bkey        varchar(20)  NOT NULL ,
	location_type_bkey   varchar(20) DEFAULT '0'::character varying NOT NULL ,
	effective_start_date_time timestamp  NOT NULL ,
	effective_end_date_time timestamp DEFAULT '2500-01-01 00:00:00'::timestamp without time zone NOT NULL ,
	location_type        varchar(20) DEFAULT 'Unknown'::character varying NOT NULL ,
	location_name        varchar(100)  NOT NULL ,
	city_town            varchar(50)   ,
	county_state         varchar(100)   ,
	country              varchar(50)   ,
	region               varchar(50)   ,
	subregion            varchar(100)   ,
	logitude_position    double precision   ,
	latitude_position    double precision   ,
	trading_start_date   date   ,
	trading_end_date     date   ,
	default_cluster      varchar(30)   ,
	building_floor_space double precision   ,
	stock_allocation_grade varchar(10)   ,
	CONSTRAINT pk_dim_geography PRIMARY KEY ( dim_geography_id )
 )  COMPOUND SORTKEY (dim_geography_id, dim_retailer_id, location_bkey, effective_end_date_time, location_name, country, subregion, region, batch_id);

CREATE TABLE IF NOT EXISTS conformed.dim_hierachy_default ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_hierarchy_subject_id smallint DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer DEFAULT 1 NOT NULL ,
	dim_hierarchy_id     integer  NOT NULL ,
	CONSTRAINT pk_dim_hierachy_default PRIMARY KEY ( dim_hierarchy_subject_id, dim_retailer_id )
 );

CREATE TABLE IF NOT EXISTS conformed.dim_hierachy_subject ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_hierarchy_subject_id smallint  NOT NULL ,
	hierarchy_subject_bkey varchar(20)  NOT NULL ,
	hierarchy_subject    varchar(50)  NOT NULL ,
	CONSTRAINT pk_dim_hierachy_subject PRIMARY KEY ( dim_hierarchy_subject_id )
 );

CREATE TABLE IF NOT EXISTS conformed.dim_hierarchy ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_hierarchy_id     integer  NOT NULL ,
	dim_retailer_id      integer DEFAULT 1 NOT NULL ,
	hierarchy_name       varchar(255)  NOT NULL ,
	dim_hierarchy_subject_id smallint DEFAULT 1 NOT NULL ,
	CONSTRAINT pk_dim_hierarchy PRIMARY KEY ( dim_hierarchy_id )
 )  COMPOUND SORTKEY (dim_hierarchy_id, hierarchy_name, dim_retailer_id, dim_hierarchy_subject_id);

CREATE TABLE IF NOT EXISTS conformed.dim_hierarchy_node ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_hierarchy_node_id bigint  NOT NULL ,
	dim_hierarchy_id     integer  NOT NULL ,
	hierarchy_node_bkey  varchar(255)  NOT NULL ,
	parent_hierarchy_node_bkey varchar(255)   ,
	hierarchy_node_name  varchar(255)  NOT NULL ,
	parent_dim_hierarchy_node_id integer   ,
	effective_start_date_time timestamp  NOT NULL ,
	effective_end_date_time timestamp DEFAULT '2500-01-01 00:00:00'::timestamp without time zone NOT NULL ,
	hierarchy_node_level smallint DEFAULT 0 NOT NULL ,
	hierarchy_breadcrumb_node_name varchar(1024) DEFAULT ''::character varying NOT NULL ,
	hierarchy_breadcrumb_node_id varchar(256)   ,
	is_leaf_node         bool DEFAULT 0 NOT NULL ,
	node_child_count     smallint DEFAULT 0 NOT NULL ,
	node_descendant_count integer DEFAULT 0 NOT NULL ,
	node_leaf_member_count integer DEFAULT 0 NOT NULL ,
	CONSTRAINT pk_dim_hierarchy_node PRIMARY KEY ( dim_hierarchy_node_id )
 )  COMPOUND SORTKEY (batch_id, dim_hierarchy_node_id, dim_hierarchy_id, hierarchy_node_bkey, parent_hierarchy_node_bkey, parent_dim_hierarchy_node_id, effective_end_date_time, effective_start_date_time, hierarchy_breadcrumb_node_name, hierarchy_breadcrumb_node_id, is_leaf_node);

CREATE TABLE IF NOT EXISTS conformed.dim_level_subject ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_level_subject_id integer  NOT NULL ,
	level_subject        varchar(50)  NOT NULL ,
	CONSTRAINT pk_dim_level_subject PRIMARY KEY ( dim_level_subject_id )
 );

CREATE TABLE IF NOT EXISTS conformed.dim_product ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_product_id       bigint  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	product_bkey1        varchar(20)  NOT NULL ,
	product_bkey2        varchar(20) DEFAULT 0 NOT NULL ,
	product_bkey3        varchar(20) DEFAULT 0 NOT NULL ,
	product_bkey4        varchar(20) DEFAULT 0 NOT NULL ,
	effective_start_date_time timestamp  NOT NULL ,
	effective_end_date_time timestamp DEFAULT '2500-01-01 00:00:00'::timestamp without time zone NOT NULL ,
	product_name         varchar(100)  NOT NULL ,
	product_description  varchar(512)   ,
	product_sku_code     varchar(50)   ,
	product_size         varchar(20)   ,
	product_colour_code  char(10)   ,
	product_colour       varchar(50)   ,
	product_gender       varchar(10)   ,
	product_age_group    varchar(50)   ,
	brand_name           varchar(100)   ,
	supplier_name        varchar(50)   ,
	product_status       varchar(30)   ,
	product_planned_end_date date   ,
	CONSTRAINT pk_dimproduct PRIMARY KEY ( dim_product_id )
 )  COMPOUND SORTKEY (dim_product_id, dim_retailer_id, product_bkey1, product_bkey2, product_bkey3, product_bkey4, product_name, product_status, product_planned_end_date, batch_id);

CREATE TABLE IF NOT EXISTS conformed.dim_retailer ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	retailer_bkey        varchar(20)  NOT NULL ,
	parent_retailer_bkey varchar(20)   ,
	retailer_name        varchar(150)  NOT NULL ,
	parent_dim_retailer_id integer   ,
	latest_batch_id      integer DEFAULT 1 NOT NULL ,
	CONSTRAINT pk_dim_retailer PRIMARY KEY ( dim_retailer_id )
 )  COMPOUND SORTKEY (dim_retailer_id, retailer_bkey, parent_retailer_bkey, latest_batch_id);

CREATE TABLE IF NOT EXISTS conformed.dim_seasonality ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_seasonality_id   integer  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	seasonality_bkey     varchar(20)  NOT NULL ,
	year_seasonality_bkey varchar(20)   ,
	seasonality_name     varchar(50)  NOT NULL ,
	year_seasonality_name varchar(50)   ,
	CONSTRAINT pk_dim_seasonality PRIMARY KEY ( dim_seasonality_id )
 )  COMPOUND SORTKEY (dim_seasonality_id, dim_retailer_id, year_seasonality_bkey, year_seasonality_name, batch_id);

CREATE TABLE IF NOT EXISTS conformed.dim_security_role ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_security_role_id integer  NOT NULL ,
	security_role_bkey   varchar(20)  NOT NULL ,
	security_role_name   varchar(50)  NOT NULL ,
	security_role_description varchar(256)   ,
	CONSTRAINT pk_dim_security_role PRIMARY KEY ( dim_security_role_id )
 );

CREATE TABLE IF NOT EXISTS conformed.fact_security_membership ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_security_role_id integer  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	dim_hierarchy_id     integer  NOT NULL ,
	dim_hierarchy_node_id bigint  NOT NULL ,
	CONSTRAINT pk_fact_security_membership PRIMARY KEY ( dim_security_role_id, dim_retailer_id, dim_hierarchy_id, dim_hierarchy_node_id )
 );

CREATE TABLE IF NOT EXISTS conformed.dim_status ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_status_id        integer  NOT NULL ,
	status_type_bkey     varchar(20)  NOT NULL ,
	status_bkey          varchar(20)  NOT NULL ,
	parent_status_bkey   varchar(20)   ,
	status_type          varchar(50)  NOT NULL ,
	status_name          varchar(50)  NOT NULL ,
	parent_dim_status_id integer   ,
	status_hierarchy_level smallint DEFAULT 0 NOT NULL ,
	status_breadcrumb    varchar(512) DEFAULT ''::character varying NOT NULL ,
	is_leaf_node         bool DEFAULT 0 NOT NULL ,
	CONSTRAINT pk_dim_status PRIMARY KEY ( dim_status_id )
 )  COMPOUND SORTKEY (dim_status_id, status_type_bkey, parent_status_bkey, status_name, status_type, is_leaf_node, status_hierarchy_level, status_breadcrumb, batch_id);

CREATE TABLE IF NOT EXISTS markdown.bridge_retailer_markdown ( 
	dim_retailer_id      integer  NOT NULL ,
	dim_markdown_id      integer  NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	CONSTRAINT pk_bridge_retailer_markdown PRIMARY KEY ( dim_retailer_id, dim_markdown_id )
 );

CREATE TABLE IF NOT EXISTS markdown.dim_markdown ( 
	dim_markdown_id      integer  NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	markdown_stage_number int2  NOT NULL ,
	CONSTRAINT pk_dim_markdown PRIMARY KEY ( dim_markdown_id )
 );

CREATE TABLE IF NOT EXISTS markdown.dim_markdown_event ( 
	dim_markdown_event_id integer  NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	markdown_event_bkey  varchar(20)  NOT NULL ,
	markdown_event_type_bkey varchar(20)  NOT NULL ,
	markdown_event_start_date date  NOT NULL ,
	markdown_event_end_date date  NOT NULL ,
	week_count           int2  NOT NULL ,
	markdown_stage       int2  NOT NULL ,
	CONSTRAINT pk_dim_markdown_event PRIMARY KEY ( dim_markdown_event_id ),
	CONSTRAINT fk_dim_markdown_event_dim_retailer FOREIGN KEY ( dim_retailer_id ) REFERENCES conformed.dim_retailer( dim_retailer_id )  
 );

CREATE TABLE IF NOT EXISTS markdown.fact_weekly_sales_markdown ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	dim_date_id          integer DEFAULT 1 NOT NULL ,
	dim_product_id       bigint  NOT NULL ,
	dim_geography_id     integer  NOT NULL ,
	dim_seasonality_id   integer  NOT NULL ,
	dim_channel_id       integer  NOT NULL ,
	dim_currency_id      smallint  NOT NULL ,
	dim_junk_id          integer  NOT NULL ,
	dim_price_status_id  smallint  NOT NULL ,
	gross_margin         double precision   ,
	markdown_price       double precision   ,
	markdown_cost        double precision   ,
	cost_price           double precision   ,
	system_price         double precision   ,
	selling_price        double precision   ,
	original_selling_price double precision   ,
	optimisation_original_selling_price double precision   ,
	provided_selling_price double precision   ,
	provided_original_selling_price double precision   ,
	optimisation_selling_price double precision   ,
	local_tax_rate       double precision   ,
	sales_value          double precision   ,
	sales_quantity       double precision   ,
	store_stock_value    double precision   ,
	store_stock_quantity double precision   ,
	depot_stock_value    double precision   ,
	depot_stock_quantity double precision   ,
	clearance_sales_value double precision   ,
	clearance_sales_quantity double precision   ,
	promotion_sales_value double precision   ,
	promotion_sales_quantity double precision   ,
	store_stock_value_no_negatives double precision   ,
	store_stock_quantity_no_negatives double precision   ,
	intake_plus_future_commitment_quantity double precision   ,
	intake_plus_future_commitment_value double precision   ,
	total_stock_value    double precision   ,
	total_stock_quantity double precision   ,
	CONSTRAINT pk_fact_weekly_sales_markdown PRIMARY KEY ( dim_date_id, dim_product_id, dim_geography_id, dim_seasonality_id, dim_channel_id )
 ) DISTKEY (dim_product_id) COMPOUND SORTKEY (dim_date_id, dim_product_id, dim_geography_id, dim_retailer_id, dim_seasonality_id, dim_channel_id, dim_currency_id, dim_price_status_id, batch_id);

CREATE TABLE IF NOT EXISTS sales.dim_junk ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_junk_id          integer  NOT NULL ,
	CONSTRAINT pk_dim_junk PRIMARY KEY ( dim_junk_id )
 );

CREATE TABLE IF NOT EXISTS sales.fact_daily_price ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	dim_date_id          integer DEFAULT 1 NOT NULL ,
	dim_product_id       bigint  NOT NULL ,
	dim_geography_id     integer  NOT NULL ,
	dim_channel_id       integer  NOT NULL ,
	dim_seasonality_id   integer  NOT NULL ,
	dim_price_status_id  integer  NOT NULL ,
	dim_currency_id      smallint  NOT NULL ,
	system_price         double precision   ,
	selling_price        double precision   ,
	original_selling_price double precision   ,
	previous_selling_price double precision   ,
	CONSTRAINT pk_fact_daily_price PRIMARY KEY ( dim_date_id, dim_product_id, dim_geography_id, dim_channel_id, dim_seasonality_id, dim_price_status_id )
 ) DISTKEY (dim_product_id) COMPOUND SORTKEY (dim_date_id, dim_product_id, dim_retailer_id, dim_price_status_id, dim_geography_id, dim_channel_id, dim_seasonality_id, dim_currency_id, batch_id);

CREATE TABLE IF NOT EXISTS sales.fact_exchange_rate ( 
	dim_date_id          integer DEFAULT 1 NOT NULL ,
	numerator_dim_currency_id int2  NOT NULL ,
	denominator_dim_currency_id int2  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	exchange_rate        decimal(18,10)  NOT NULL ,
	CONSTRAINT pk_fact_exchange_rate PRIMARY KEY ( dim_date_id, numerator_dim_currency_id, denominator_dim_currency_id, dim_retailer_id )
 );

CREATE TABLE IF NOT EXISTS sales.fact_seasonality ( 
	dim_date_id          integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	dim_product_id       bigint  NOT NULL ,
	dim_seasonality_id   integer  NOT NULL ,
	dim_geography_id     integer  NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	CONSTRAINT pk_fact_seasonality PRIMARY KEY ( dim_date_id, dim_retailer_id, dim_product_id, dim_seasonality_id, dim_geography_id )
 );

CREATE TABLE IF NOT EXISTS sales.fact_weekly_sales ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_date_id          integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	dim_product_id       bigint  NOT NULL ,
	dim_geography_id     integer  NOT NULL ,
	dim_currency_id      smallint  NOT NULL ,
	dim_seasonality_id   integer  NOT NULL ,
	dim_price_status_id  integer  NOT NULL ,
	dim_channel_id       integer  NOT NULL ,
	dim_product_status_id integer  NOT NULL ,
	gross_margin         double precision   ,
	sales_value          double precision   ,
	sales_quantity       integer   ,
	local_tax_rate       double precision   ,
	sales_cost           double precision   ,
	markdown_sales_value double precision   ,
	markdown_sales_quantity integer   ,
	promotion_sales_value double precision   ,
	promotion_sales_quantity integer   ,
	retailer_markdown_cost double precision   ,
	CONSTRAINT pk_fact_weekly_sales PRIMARY KEY ( dim_date_id, dim_retailer_id, dim_product_id, dim_geography_id, dim_currency_id, dim_seasonality_id, dim_price_status_id, dim_channel_id )
 ) DISTKEY (dim_product_id) COMPOUND SORTKEY (batch_id, dim_date_id, dim_retailer_id, dim_product_id, dim_geography_id, dim_currency_id, dim_seasonality_id, dim_price_status_id, dim_channel_id, dim_product_status_id);

CREATE TABLE IF NOT EXISTS sales.fact_weekly_stock ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_date_id          integer DEFAULT 1 NOT NULL ,
	dim_product_id       bigint  NOT NULL ,
	dim_geography_id     integer  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	dim_currency_id      smallint  NOT NULL ,
	stock_value          double precision   ,
	stock_quantity       integer   ,
	stock_cost           double precision   ,
	cost_price           double precision   ,
	future_commitment_stock_value double precision   ,
	future_commitment_stock_quantity integer   ,
	future_commitment_stock_cost double precision   ,
	intake_stock_value   double precision   ,
	intake_stock_quantity double precision   ,
	intake_stock_cost    double precision   ,
	transit_stock_value  double precision   ,
	transit_stock_quantity double precision   ,
	transit_stock_cost   double precision   ,
	CONSTRAINT pk_fact_weekly_stock PRIMARY KEY ( dim_date_id, dim_product_id, dim_geography_id )
 ) DISTKEY (dim_product_id) COMPOUND SORTKEY (batch_id, dim_date_id, dim_product_id, dim_geography_id, dim_retailer_id, dim_currency_id);

CREATE TABLE IF NOT EXISTS stage.business_hierarchy_dim ( 
	row_id               bigint DEFAULT "identity"(264648, 0, '1,1'::text) NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	reporting_date       date  NOT NULL ,
	reporting_date_period_type smallint   ,
	hierarchy_name       varchar(50)   ,
	business_key1        varchar(20)   ,
	business_key2        varchar(20)   ,
	business_key3        varchar(20)   ,
	business_key4        varchar(20)   ,
	business_area        varchar(50)   ,
	node_id_level1       varchar(20)   ,
	node_name_level1     varchar(50)   ,
	node_id_level2       varchar(20)   ,
	node_name_level2     varchar(50)   ,
	node_id_level3       varchar(20)   ,
	node_name_level3     varchar(50)   ,
	node_id_level4       varchar(20)   ,
	node_name_level4     varchar(50)   ,
	node_id_level5       varchar(20)   ,
	node_name_level5     varchar(50)   ,
	node_id_level6       varchar(20)   ,
	node_name_level6     varchar(50)   ,
	node_id_level7       varchar(20)   ,
	node_name_level7     varchar(50)   ,
	node_id_level8       varchar(20)   ,
	node_name_level8     varchar(50)   ,
	node_id_level9       varchar(20)   ,
	node_name_level9     varchar(50)   
 );

CREATE TABLE IF NOT EXISTS stage.channel_dim ( 
	row_id               bigint DEFAULT "identity"(264652, 0, '1,1'::text) NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	retailer_bkey        varchar(20)  NOT NULL ,
	dim_retailer_id      integer   ,
	channel_bkey         varchar(20)  NOT NULL ,
	channel_name         varchar(50)  NOT NULL ,
	channel_description  varchar(250)   ,
	channel_code         varchar(10)   ,
	reporting_date       date  NOT NULL ,
	reporting_date_period_type smallint  NOT NULL 
 );

CREATE TABLE IF NOT EXISTS stage.currency_dim ( 
    row_id SMALLINT NOT NULL ENCODE lzo,
    batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
    dim_retailer_id INTEGER DEFAULT 0 NOT NULL ENCODE lzo,
    reporting_date DATE NOT NULL ENCODE lzo,
    reporting_date_period_type SMALLINT NOT NULL ENCODE lzo,
    currency_bkey VARCHAR(20) NOT NULL ENCODE lzo,
    currency VARCHAR(50) NOT NULL ENCODE lzo,
    iso_currency_code CHAR(3) NOT NULL ENCODE lzo,
    currency_symbol VARCHAR(4) ENCODE lzo,
    is_active BOOLEAN DEFAULT 1 NOT NULL 
)
DISTSTYLE EVEN;

CREATE TABLE IF NOT EXISTS stage.date_dim ( 
	row_id               integer  NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	reporting_date       date  NOT NULL ,
	reporting_date_period_type smallint  NOT NULL ,
	dim_date_id          integer  NOT NULL ,
	day_sequence_number  integer  NOT NULL ,
	week_sequence_number_usa integer DEFAULT 0 NOT NULL ,
	week_sequence_number_eu_iso integer DEFAULT 0 NOT NULL ,
	month_sequence_number int2 DEFAULT 0 NOT NULL ,
	calendar_date        date  NOT NULL ,
	is_weekday7_usa      bool  NOT NULL ,
	is_weekday7_eu_iso   bool  NOT NULL ,
	calendar_date_eu     char(10)  NOT NULL ,
	calendar_date_usa    char(10)  NOT NULL ,
	calendar_day_of_month integer  NOT NULL ,
	day_with_suffix      varchar(6)  NOT NULL ,
	calendar_month_number integer  NOT NULL ,
	calendar_month_name  varchar(30)  NOT NULL ,
	calendar_month_start_date date  NOT NULL ,
	calendar_month_end_date date  NOT NULL ,
	calendar_year_month  integer  NOT NULL ,
	calendar_week_number_usa smallint  NOT NULL ,
	calendar_week_number_eu smallint  NOT NULL ,
	calendar_continuum_year_week_number_usa integer  NOT NULL ,
	calendar_continuum_year_week_number_eu integer  NOT NULL ,
	calendar_continuum_year_week_number_usa_start_date date  NOT NULL ,
	calendar_continuum_year_week_number_usa_end_date date  NOT NULL ,
	calendar_continuum_year_week_number_eu_start_date date  NOT NULL ,
	calendar_continuum_year_week_number_eu_end_date date  NOT NULL ,
	calendar_iso_week_number integer  NOT NULL ,
	calendar_continuum_year_iso_week_number integer  NOT NULL ,
	calendar_continuum_year_iso_week_number_start_date date  NOT NULL ,
	calendar_continuum_year_iso_week_number_end_date date  NOT NULL ,
	week_day_number_usa  int2  NOT NULL ,
	week_day_number_eu_iso int2  NOT NULL ,
	week_day_name        varchar(30)  NOT NULL ,
	calendar_quarter_name varchar(6)  NOT NULL ,
	calendar_quarter_number smallint  NOT NULL ,
	calendar_quarter_day_number integer  NOT NULL ,
	calendar_quarter_month_number integer  NOT NULL ,
	calendar_quarter_start_date date  NOT NULL ,
	calendar_quarter_end_date date  NOT NULL ,
	calendar_year        integer  NOT NULL ,
	calendar_year_start_date date  NOT NULL ,
	calendar_year_end_date date  NOT NULL 
 );

CREATE TABLE IF NOT EXISTS stage.exchange_rate_cartesian ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	dim_date_id          integer  NOT NULL ,
	exchange_rate_id     bigint   ,
	numerator_dim_currency_id int2  NOT NULL ,
	denominator_dim_currency_id int2  NOT NULL ,
	exchange_rate        decimal(18,10)  NOT NULL ,
	row_id               bigint   
 );

CREATE TABLE IF NOT EXISTS stage.exchange_rate_duplicate ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	dim_date_id          integer  NOT NULL ,
	numerator_dim_currency_id smallint  NOT NULL ,
	denominator_dim_currency_id smallint  NOT NULL ,
	kept_exchange_rate_row_id bigint   ,
	count_of             integer   
 );

CREATE TABLE IF NOT EXISTS stage.exchange_rate_erroneous ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	dim_date_id          integer  NOT NULL ,
	numerator_dim_currency_id smallint  NOT NULL ,
	denominator_dim_currency_id smallint  NOT NULL ,
	exchange_rate        decimal(18,10)  NOT NULL ,
	exchange_rate_id     bigint   
 );

CREATE TABLE IF NOT EXISTS stage.exchange_rate_measures ( 
	dim_retailer_id      integer   ,
	reporting_date       date  NOT NULL ,
	reporting_date_period_type smallint  NOT NULL ,
	exchange_rate_id     bigint  NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	effective_start_date date  NOT NULL ,
	effective_end_date   date  NOT NULL ,
	numerator_iso_currency_code char(3)  NOT NULL ,
	denominator_iso_currency_code char(3)  NOT NULL ,
	exchange_rate        decimal(18,10)  NOT NULL 
 );

CREATE TABLE IF NOT EXISTS stage.fiscal_calendar_dim ( 
	row_id               integer  NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	reporting_date       date  NOT NULL ,
	reporting_date_period_type smallint  NOT NULL ,
	retailer_bkey        varchar(20)  NOT NULL ,
	calendar_date        date  NOT NULL ,
	dim_retailer_id      integer   ,
	dim_date_id          integer   ,
	is_weekday7          bool   ,
	is_working_day       bool   ,
	is_business_holiday  bool   ,
	is_national_holiday  bool   ,
	fiscal_date_string   char(11)   ,
	fiscal_day_of_month  integer   ,
	fiscal_day_with_suffix varchar(6)   ,
	fiscal_month_number  integer   ,
	fiscal_month_name    varchar(30)   ,
	fiscal_month_start_date date   ,
	fiscal_month_end_date date   ,
	fiscal_year_month    integer   ,
	fiscal_week_number   smallint   ,
	fiscal_continuum_week_number smallint DEFAULT 0  ,
	fiscal_continuum_month_number smallint DEFAULT 0  ,
	fiscal_continuum_quarter_number smallint DEFAULT 0  ,
	fiscal_continuum_year_week_number integer   ,
	fiscal_continuum_year_week_number_start_date date   ,
	fiscal_continuum_year_week_number_end_date date   ,
	fiscal_week_day_number smallint   ,
	fiscal_week_day_name varchar(30)   ,
	fiscal_quarter_name  varchar(6)   ,
	fiscal_quarter_number smallint   ,
	fiscal_quarter_day_number integer   ,
	fiscal_quarter_month_number integer   ,
	fiscal_quarter_start_date date   ,
	fiscal_quarter_end_date date   ,
	fiscal_year          integer   ,
	fiscal_year_start_date date   ,
	fiscal_year_end_date date   
 );

CREATE TABLE IF NOT EXISTS stage.geography_dim ( 
	row_id               bigint DEFAULT "identity"(264656, 0, '1,1'::text) NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	reporting_date       date  NOT NULL ,
	reporting_date_period_type smallint  NOT NULL ,
	location_bkey        varchar(20)  NOT NULL ,
	location_type_bkey   varchar(20) DEFAULT '0'::character varying NOT NULL ,
	location_type        varchar(20) DEFAULT 'Unknown'::character varying NOT NULL ,
	location_name        varchar(100)  NOT NULL ,
	city_town            varchar(50)   ,
	county_state         varchar(100)   ,
	country              varchar(50)   ,
	region               varchar(50)   ,
	subregion            varchar(100)   ,
	logitude_position    double precision   ,
	latitude_position    double precision   ,
	trading_start_date   date   ,
	trading_end_date     date   ,
	default_cluster      varchar(30)   ,
	building_floor_space double precision   ,
	stock_allocation_grade varchar(10)   
 );

CREATE TABLE IF NOT EXISTS stage.geography_type_mapping ( 
	batch_id             integer  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	location_type_bkey   smallint  NOT NULL ,
	location_bkey        varchar(20)  NOT NULL 
 );

CREATE TABLE IF NOT EXISTS stage.geography_type_mapping_dim ( 
	row_id               bigint  NOT NULL ,
	batch_id             integer  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	reporting_date       date  NOT NULL ,
	reporting_date_period_type smallint  NOT NULL ,
	location_type_bkey   smallint  NOT NULL ,
	location_bkey        varchar(20)  NOT NULL 
 );

CREATE TABLE IF NOT EXISTS stage.hierarchy_pivoted ( 
	hierarchy_name       varchar(255)   ,
	business_area        varchar(128)   ,
	business_key         char(18)   ,
	hierarchy_level0_bkey varchar(20)   ,
	hierarchy_level0     varchar(255)   ,
	hierarchy_level1_bkey varchar(20)   ,
	hierarchy_level1     varchar(255)   ,
	hierarchy_level2_bkey varchar(20)   ,
	hierarchy_level2     varchar(255)   ,
	hierarchy_level3_bkey varchar(20)   ,
	hierarchy_level3     varchar(255)   ,
	hierarchy_level4_bkey varchar(20)   ,
	hierarchy_level4     varchar(255)   ,
	hierarchy_level5_bkey varchar(20)   ,
	hierarchy_level5     varchar(255)   ,
	hierarchy_level6_bkey varchar(20)   ,
	hierarchy_level6     varchar(255)   ,
	hierarchy_level7_bkey varchar(20)   ,
	hierarchy_level7     varchar(255)   ,
	hierarchy_level8_bkey varchar(20)   ,
	hierarchy_level8     varchar(255)   ,
	hierarchy_level9_bkey varchar(20)   ,
	hierarchy_level9     varchar(255)   ,
	analytical_period_start_date date   ,
	analytical_period_end_date date   ,
	row_id               integer  NOT NULL 
 );

CREATE TABLE IF NOT EXISTS stage.hierarchy_relationship ( 
	row_id               bigint DEFAULT "identity"(264686, 0, '1,1'::text) NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	business_key         varchar(255)  NOT NULL ,
	hierarchy_node_level smallint  NOT NULL ,
	child_hierarchy_node_id integer  NOT NULL ,
	parent_hierarchy_node_id integer   ,
	is_broken            bool  NOT NULL ,
	CONSTRAINT hierarchy_relationship_pkey PRIMARY KEY ( business_key, hierarchy_node_level, child_hierarchy_node_id )
 );

CREATE TABLE IF NOT EXISTS stage.hierarchy_unpivoted ( 
	batch_id             integer  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	business_key         varchar(255)   ,
	hierarchy_node_bkey  varchar(50)   ,
	hierarchy_node_name  varchar(254)   ,
	hierarchy_level_description varchar(128)   ,
	hierarchy_level      integer   ,
	analytical_period_start_date date   ,
	analytical_period_end_date date   
 );

CREATE TABLE IF NOT EXISTS stage.markdown_measures ( 
	row_id               bigint  NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	reporting_date       date  NOT NULL ,
	reporting_date_period_type smallint  NOT NULL ,
	product_bkey1        varchar(20)   ,
	product_bkey2        varchar(20) DEFAULT 0  ,
	product_bkey3        varchar(20) DEFAULT 0  ,
	product_bkey4        varchar(20) DEFAULT 0  ,
	location_bkey        varchar(20)   ,
	iso_currency_code    char(3)   ,
	year_seasonality_bkey varchar(20)   ,
	price_status_bkey    varchar(20)   ,
	channel_bkey         varchar(20)   ,
	gross_margin         double precision   ,
	markdown_price       double precision   ,
	markdown_cost        double precision   ,
	cost_price           double precision   ,
	system_price         double precision   ,
	selling_price        double precision   ,
	original_selling_price double precision   ,
	optimisation_original_selling_price double precision   ,
	provided_selling_price double precision   ,
	provided_original_selling_price double precision   ,
	optimisation_selling_price double precision   ,
	local_tax_rate       double precision   ,
	sales_value          double precision   ,
	sales_quantity       double precision   ,
	store_stock_value    double precision   ,
	store_stock_quantity double precision   ,
	depot_stock_value    double precision   ,
	depot_stock_quantity double precision   ,
	clearance_sales_value double precision   ,
	clearance_sales_quantity double precision   ,
	promotion_sales_value double precision   ,
	promotion_sales_quantity double precision   ,
	store_stock_value_no_negatives double precision   ,
	store_stock_quantity_no_negatives double precision   ,
	intake_plus_future_commitment_quantity double precision   ,
	intake_plus_future_commitment_value double precision   ,
	total_stock_value    double precision   ,
	total_stock_quantity double precision   
 );

CREATE TABLE IF NOT EXISTS stage.node ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	hierarchy_node_id    integer DEFAULT "identity"(264692, 0, '1,1'::text) NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	hierarchy_node_bkey  varchar(50)   ,
	hierarchy_node_name  varchar(128)  NOT NULL ,
	hierarchy_node_level int2 DEFAULT 0 NOT NULL ,
	is_duplicate_bkey    bool DEFAULT 0 NOT NULL ,
	CONSTRAINT pk_node PRIMARY KEY ( hierarchy_node_id )
 );

CREATE TABLE IF NOT EXISTS stage.price_changes_measures ( 
	row_id               bigint DEFAULT "identity"(264700, 0, '1,1'::text) NOT NULL ,
	batch_id             integer  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	reporting_date       date   ,
	reporting_date_period_type smallint   ,
	location_bkey        varchar(20)   ,
	product_bkey1        varchar(20)   ,
	product_bkey2        varchar(20)   ,
	product_bkey3        varchar(20)   ,
	product_bkey4        varchar(20)   ,
	channel_bkey         varchar(20)   ,
	year_seasonality_bkey varchar(20)   ,
	iso_currency_code    varchar(3)   ,
	price_status_bkey    smallint   ,
	system_price         double precision   ,
	selling_price        double precision   ,
	original_selling_price double precision   
 );

CREATE TABLE IF NOT EXISTS stage.product_dim ( 
	row_id               bigint  NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	reporting_date       date  NOT NULL ,
	reporting_date_period_type smallint  NOT NULL ,
	product_bkey1        varchar(20)  NOT NULL ,
	product_bkey2        varchar(20) DEFAULT 0 NOT NULL ,
	product_bkey3        varchar(20) DEFAULT 0 NOT NULL ,
	product_bkey4        varchar(20) DEFAULT 0 NOT NULL ,
	effective_start_date_time timestamp DEFAULT '2007-01-01 00:00:00'::timestamp without time zone NOT NULL ,
	effective_end_date_time timestamp DEFAULT '2500-01-01 00:00:00'::timestamp without time zone NOT NULL ,
	product_name         varchar(100)  NOT NULL ,
	product_description  varchar(512)   ,
	product_sku_code     varchar(50)   ,
	product_size         varchar(20)   ,
	product_colour_code  char(10)   ,
	product_colour       varchar(50)   ,
	product_gender       varchar(10)   ,
	product_age_group    varchar(50)   ,
	brand_name           varchar(100)   ,
	supplier_name        varchar(50)   ,
	product_status       varchar(30)   ,
	product_planned_end_date date   
 );

CREATE TABLE IF NOT EXISTS stage.product_seasonality_measures ( 
	row_id               bigint DEFAULT "identity"(264662, 0, '1,1'::text) NOT NULL ,
	batch_id             integer  NOT NULL ,
	dim_retailer_id      integer   ,
	reporting_date       varchar(10)  NOT NULL ,
	reporting_date_period_type smallint  NOT NULL ,
	product_bkey1        varchar(20)  NOT NULL ,
	product_bkey2        varchar(20)   ,
	product_bkey3        varchar(20)   ,
	product_bkey4        varchar(20)   ,
	location_bkey        varchar(20)   ,
	seasonality_bkey     varchar(20)  NOT NULL ,
	year_seasonality_bkey varchar(20)  NOT NULL ,
	year_seasonality_start_date date   ,
	year_seasonality_end_date date   
 );

CREATE TABLE IF NOT EXISTS stage.retailer_dim ( 
	row_id               integer  NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	reporting_date       date  NOT NULL ,
	reporting_date_period_type smallint  NOT NULL ,
	retailer_bkey        varchar(20)  NOT NULL ,
	parent_retailer_bkey varchar(20)   ,
	retailer_name        varchar(150)  NOT NULL ,
	parent_dim_retailer_id integer   ,
	latest_batch_id      integer DEFAULT 1 NOT NULL 
 );

CREATE TABLE IF NOT EXISTS stage.sales_measures ( 
	row_id               bigint DEFAULT "identity"(264665, 0, '1,1'::text) NOT NULL ,
	batch_id             integer  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	reporting_date       date   ,
	reporting_date_period_type int2   ,
	location_bkey        varchar(20)   ,
	product_bkey1        varchar(20)   ,
	product_bkey2        varchar(20)   ,
	product_bkey3        varchar(20)   ,
	product_bkey4        varchar(20)   ,
	channel_bkey         varchar(20)   ,
	year_seasonality_bkey varchar(20)   ,
	iso_currency_code    char(3)   ,
	price_status_bkey    int2   ,
	sales_value          double precision   ,
	sales_quantity       integer   ,
	local_tax_rate       double precision   ,
	product_status_bkey  varchar(20)   ,
	gross_margin         double precision   ,
	sales_cost           double precision   ,
	markdown_sales_value double precision   ,
	markdown_sales_quantity integer   ,
	promotion_sales_value double precision   ,
	promotion_sales_quantity integer   ,
	retailer_markdown_cost double precision   
 );

CREATE TABLE IF NOT EXISTS stage.seasonality_dim ( 
	row_id               bigint  NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	reporting_date       date  NOT NULL ,
	reporting_date_period_type smallint  NOT NULL ,
	seasonality_bkey     varchar(20)  NOT NULL ,
	year_seasonality_bkey varchar(20)   ,
	seasonality_name     varchar(50)  NOT NULL ,
	year_seasonality_name varchar(50)   
 );

CREATE TABLE IF NOT EXISTS stage.security_role_dim ( 
	row_id               integer  NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	reporting_date       date  NOT NULL ,
	reporting_date_period_type smallint  NOT NULL ,
	security_role_bkey   varchar(20)  NOT NULL ,
	security_role_name   varchar(50)  NOT NULL ,
	security_role_description varchar(256)   
 );

CREATE TABLE IF NOT EXISTS stage.status_dim ( 
    row_id BIGINT IDENTITY NOT NULL ENCODE lzo,
    batch_id INTEGER DEFAULT 1 NOT NULL ENCODE lzo,
    dim_retailer_id INTEGER DEFAULT 0 NOT NULL ENCODE lzo,
    status_type_bkey VARCHAR(20) NOT NULL ENCODE lzo,
    status_bkey VARCHAR(20) NOT NULL ENCODE lzo,
    parent_status_bkey VARCHAR(20) ENCODE lzo,
    status_type VARCHAR(50) NOT NULL ENCODE lzo,
    status_name VARCHAR(50) NOT NULL ENCODE lzo,
    parent_dim_status_id SMALLINT ENCODE lzo,
    status_hierarchy_level SMALLINT DEFAULT 0 NOT NULL ENCODE lzo,
    status_breadcrumb VARCHAR(512) DEFAULT ''::character varying NOT NULL ENCODE lzo,
    is_leaf_node BOOLEAN DEFAULT 0 NOT NULL 
)
DISTSTYLE EVEN;

CREATE TABLE IF NOT EXISTS stage.stock_measures ( 
	row_id               bigint  NOT NULL ,
	batch_id             integer  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	reporting_date       date   ,
	reporting_date_period_type smallint   ,
	location_bkey        varchar(20)   ,
	product_bkey1        varchar(20)   ,
	product_bkey2        varchar(20)   ,
	product_bkey3        varchar(20)   ,
	product_bkey4        varchar(20)   ,
	product_status_key   varchar(20)   ,
	iso_currency_code    varchar(3)   ,
	stock_value          double precision   ,
	stock_quantity       integer   ,
	stock_cost           double precision   ,
	cost_price           double precision   ,
	future_commitment_stock_value double precision   ,
	future_commitment_stock_quantity integer   ,
	future_commitment_stock_cost double precision   ,
	intake_stock_value   double precision   ,
	intake_stock_quantity double precision   ,
	intake_stock_cost    double precision   ,
	transit_stock_value  double precision   ,
	transit_stock_quantity double precision   ,
	transit_stock_cost   double precision   
 );

CREATE TABLE IF NOT EXISTS stage.hierarchy_node ( 
	row_id               bigint DEFAULT "identity"(264675, 0, '1,1'::text) NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	hierarchy_node_bkey  varchar(50)  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	parent_hierarchy_node_bkey varchar(50)   ,
	hierarchy_node_name  varchar(128)  NOT NULL ,
	hierarchy_node_level smallint   ,
	hierarchy_breadcrumb varchar(1024)   ,
	is_leaf_node         bool DEFAULT 0  ,
	CONSTRAINT hierarchy_node_pkey PRIMARY KEY ( hierarchy_node_bkey )
 );

--CREATE VIEW conformed.uv_bridge_geography_hierarchy_for_merge AS null;

--CREATE VIEW conformed.uv_bridge_product_hierarchy_for_merge AS null;

--CREATE VIEW markdown_app.uv_dim_channel AS null;

--CREATE VIEW markdown_app.uv_dim_currency AS null;

--CREATE VIEW markdown_app.uv_dim_date_weekly_usa AS null;

--COMMENT ON VIEW markdown_app.uv_dim_date_weekly_usa IS 'This view is depricated by uv_dim_data_fiscal';

--CREATE VIEW markdown_app.uv_dim_geography AS null;

--CREATE VIEW markdown_app.uv_dim_hierarchy AS null;

--CREATE VIEW markdown_app.uv_dim_price_status AS null;

--CREATE VIEW markdown_app.uv_dim_product AS null;

--CREATE VIEW markdown_app.uv_dim_retailer AS null;

--CREATE VIEW markdown_app.uv_dim_seasonality AS null;

--CREATE VIEW markdown_app.uv_fact_weekly_sales_basic AS null;

--CREATE VIEW markdown_app.uv_fact_weekly_sales_markdown AS null;

--CREATE VIEW stage.uv_fiscal_calendar_data_file AS null;

ALTER TABLE conformed.dim_status ADD CONSTRAINT fk_dimstatus_dimstatus FOREIGN KEY ( parent_dim_status_id ) REFERENCES conformed.dim_status( dim_status_id );

--COMMENT ON CONSTRAINT fk_dimstatus_dimstatus ON conformed.dim_status IS '';

ALTER TABLE stage.hierarchy_node ADD CONSTRAINT hierarchy_node_parent_hierarchy_node_bkey_fkey FOREIGN KEY ( parent_hierarchy_node_bkey ) REFERENCES stage.hierarchy_node( hierarchy_node_bkey );

--COMMENT ON CONSTRAINT hierarchy_node_parent_hierarchy_node_bkey_fkey ON stage.hierarchy_node IS '';

