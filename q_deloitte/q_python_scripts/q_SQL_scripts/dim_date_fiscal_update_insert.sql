
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
	fiscal_continuum_quarter_number smallint DEFAULT 0 NOT NULL ,
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

---------------------------------------------------------------------------------------------------
-- update dim_date_fiscal.....
---------------------------------------------------------------------------------------------------
UPDATE 
       conformed.dim_date_fiscal
   SET batch_id                                      = changed_date_fiscal.batch_id
     , is_weekday7                                   = changed_date_fiscal.is_weekday7
     , is_working_day                                = changed_date_fiscal.is_working_day
     , is_business_holiday                           = changed_date_fiscal.is_business_holiday
     , is_national_holiday                           = changed_date_fiscal.is_national_holiday
     , fiscal_date_string                            = changed_date_fiscal.fiscal_date_string
     , fiscal_day_of_month                           = changed_date_fiscal.fiscal_day_of_month
     , fiscal_day_with_suffix                        = changed_date_fiscal.fiscal_day_with_suffix
     , fiscal_month_number                           = changed_date_fiscal.fiscal_month_number
     , fiscal_month_name                             = changed_date_fiscal.fiscal_month_name
     , fiscal_month_start_date                       = changed_date_fiscal.fiscal_month_start_date
     , fiscal_month_end_date                         = changed_date_fiscal.fiscal_month_end_date
     , fiscal_year_month                             = changed_date_fiscal.fiscal_year_month
     , fiscal_week_number                            = changed_date_fiscal.fiscal_week_number
     , fiscal_continuum_year_week_number             = changed_date_fiscal.fiscal_continuum_year_week_number           
     , fiscal_continuum_year_week_number_start_date  = changed_date_fiscal.fiscal_continuum_year_week_number_start_date
     , fiscal_continuum_year_week_number_end_date    = changed_date_fiscal.fiscal_continuum_year_week_number_end_date  
     , fiscal_week_day_number                        = changed_date_fiscal.fiscal_week_day_number                      
     , fiscal_week_day_name                          = changed_date_fiscal.fiscal_week_day_name                        
     , fiscal_quarter_name                           = changed_date_fiscal.fiscal_quarter_name                         
     , fiscal_quarter_number                         = changed_date_fiscal.fiscal_quarter_number                       
     , fiscal_quarter_day_number                     = changed_date_fiscal.fiscal_quarter_day_number                   
     , fiscal_quarter_month_number                   = changed_date_fiscal.fiscal_quarter_month_number                 
     , fiscal_quarter_start_date                     = changed_date_fiscal.fiscal_quarter_start_date                   
     , fiscal_quarter_end_date                       = changed_date_fiscal.fiscal_quarter_end_date                     
     , fiscal_year                                   = changed_date_fiscal.fiscal_year                                 
     , fiscal_year_start_date                        = changed_date_fiscal.fiscal_year_start_date                      
     , fiscal_year_end_date                          = changed_date_fiscal.fiscal_year_end_date                        
FROM
(
 SELECT
        ##BATCH_ID## as batch_id 
      , sc.dim_retailer_id
      , sc.dim_date_id                                      
      , sc.is_weekday7                                  
      , sc.is_working_day                               
      , sc.is_business_holiday                          
      , sc.is_national_holiday
      , sc.fiscal_date_string                           
      , sc.fiscal_day_of_month                          
      , sc.fiscal_day_with_suffix                       
      , sc.fiscal_month_number                          
      , sc.fiscal_month_name                            
      , sc.fiscal_month_start_date                      
      , sc.fiscal_month_end_date                        
      , sc.fiscal_year_month                            
      , sc.fiscal_week_number                           
      , sc.fiscal_continuum_year_week_number            
      , sc.fiscal_continuum_year_week_number_start_date 
      , sc.fiscal_continuum_year_week_number_end_date   
      , sc.fiscal_week_day_number                       
      , sc.fiscal_week_day_name                         
      , sc.fiscal_quarter_name                          
      , sc.fiscal_quarter_number                        
      , sc.fiscal_quarter_day_number                    
      , sc.fiscal_quarter_month_number                  
      , sc.fiscal_quarter_start_date                    
      , sc.fiscal_quarter_end_date                      
      , sc.fiscal_year                                  
      , sc.fiscal_year_start_date                       
      , sc.fiscal_year_end_date 
   FROM
        stage.fiscal_calendar_dim sc
       JOIN
            conformed.dim_date_fiscal dc
         ON
            sc.dim_date_id = dc.dim_date_id
        AND
        (
            sc.batch_id                                      <> dc.batch_id
         OR sc.is_weekday7                                   <> dc.is_weekday7
         OR sc.is_working_day                                <> dc.is_working_day
         OR sc.is_business_holiday                           <> dc.is_business_holiday
         OR sc.is_national_holiday                           <> dc.is_national_holiday
         OR sc.fiscal_date_string                            <> dc.fiscal_date_string
         OR sc.fiscal_day_of_month                           <> dc.fiscal_day_of_month
         OR sc.fiscal_day_with_suffix                        <> dc.fiscal_day_with_suffix
         OR sc.fiscal_month_number                           <> dc.fiscal_month_number
         OR sc.fiscal_month_name                             <> dc.fiscal_month_name
         OR sc.fiscal_month_start_date                       <> dc.fiscal_month_start_date
         OR sc.fiscal_month_end_date                         <> dc.fiscal_month_end_date
         OR sc.fiscal_year_month                             <> dc.fiscal_year_month
         OR sc.fiscal_week_number                            <> dc.fiscal_week_number
         OR sc.fiscal_continuum_year_week_number             <> dc.fiscal_continuum_year_week_number           
         OR sc.fiscal_continuum_year_week_number_start_date  <> dc.fiscal_continuum_year_week_number_start_date
         OR sc.fiscal_continuum_year_week_number_end_date    <> dc.fiscal_continuum_year_week_number_end_date  
         OR sc.fiscal_week_day_number                        <> dc.fiscal_week_day_number                      
         OR sc.fiscal_week_day_name                          <> dc.fiscal_week_day_name                        
         OR sc.fiscal_quarter_name                           <> dc.fiscal_quarter_name                         
         OR sc.fiscal_quarter_number                         <> dc.fiscal_quarter_number                       
         OR sc.fiscal_quarter_day_number                     <> dc.fiscal_quarter_day_number                   
         OR sc.fiscal_quarter_month_number                   <> dc.fiscal_quarter_month_number                 
         OR sc.fiscal_quarter_start_date                     <> dc.fiscal_quarter_start_date                   
         OR sc.fiscal_quarter_end_date                       <> dc.fiscal_quarter_end_date                     
         OR sc.fiscal_year                                   <> dc.fiscal_year                                 
         OR sc.fiscal_year_start_date                        <> dc.fiscal_year_start_date                      
         OR sc.fiscal_year_end_date                          <> dc.fiscal_year_end_date                        
       )
 --WHERE
       --sc.batch_id = ##BATCH_ID##

     ) changed_date_fiscal
WHERE
      dim_date_fiscal.dim_date_id      = changed_date_fiscal.dim_date_id
  AND dim_date_fiscal.dim_retailer_id  = changed_date_fiscal.dim_retailer_id
;

---------------------------------------------------------------------------------------------------
-- insert dim_date_fiscal.....
---------------------------------------------------------------------------------------------------
INSERT INTO conformed.dim_date_fiscal (
	     batch_id
       , dim_retailer_id
       , dim_date_id
       , is_weekday7
       , is_working_day
       , is_business_holiday
       , is_national_holiday
       , fiscal_date_string
       , fiscal_day_of_month
       , fiscal_day_with_suffix
       , fiscal_month_number
       , fiscal_month_name
       , fiscal_month_start_date
       , fiscal_month_end_date
       , fiscal_year_month
       , fiscal_week_number
       , fiscal_continuum_week_number
       , fiscal_continuum_month_number
       , fiscal_continuum_quarter_number
       , fiscal_continuum_year_week_number
       , fiscal_continuum_year_week_number_start_date
       , fiscal_continuum_year_week_number_end_date
       , fiscal_week_day_number
       , fiscal_week_day_name
       , fiscal_quarter_name
       , fiscal_quarter_number
       , fiscal_quarter_day_number
       , fiscal_quarter_month_number
       , fiscal_quarter_start_date
       , fiscal_quarter_end_date
       , fiscal_year
       , fiscal_year_start_date
       , fiscal_year_end_date
) 
SELECT   ##BATCH_ID## as batch_id
       , dim_retailer_id
       , dim_date_id
       , is_weekday7
       , is_working_day
       , is_business_holiday
       , is_national_holiday
       , fiscal_date_string
       , fiscal_day_of_month
       , fiscal_day_with_suffix
       , fiscal_month_number
       , fiscal_month_name
       , fiscal_month_start_date
       , fiscal_month_end_date
       , fiscal_year_month
       , fiscal_week_number
       , fiscal_continuum_week_number
       , fiscal_continuum_month_number
       , fiscal_continuum_quarter_number
       , fiscal_continuum_year_week_number
       , fiscal_continuum_year_week_number_start_date
       , fiscal_continuum_year_week_number_end_date
       , fiscal_week_day_number
       , fiscal_week_day_name
       , fiscal_quarter_name
       , fiscal_quarter_number
       , fiscal_quarter_day_number
       , fiscal_quarter_month_number
       , fiscal_quarter_start_date
       , fiscal_quarter_end_date
       , fiscal_year
       , fiscal_year_start_date
       , fiscal_year_end_date
  FROM
    stage.fiscal_calendar_dim sc
WHERE
    NOT EXISTS
    (
     SELECT 1
       FROM
            conformed.dim_date_fiscal dc
      WHERE
            dc.dim_retailer_id  = sc.dim_retailer_id
        AND dc.dim_date_id      = sc.dim_date_id
    )
    --AND sc.batch_id = ##BATCH_ID##
;

