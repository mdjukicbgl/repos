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

---------------------------------------------------------------------------------------------------
-- update dim_date.....
---------------------------------------------------------------------------------------------------
UPDATE
    conformed.dim_date
SET batch_id                                           = changed_date.batch_id
  , dim_date_id                                        = cast(TO_CHAR(changed_date.calendar_date, 'YYYYMMDD') as int)
  , day_sequence_number                                = changed_date.day_sequence_number
  , week_sequence_number_usa                           = changed_date.week_sequence_number_usa
  , week_sequence_number_eu_iso                        = changed_date.week_sequence_number_eu_iso
  , month_sequence_number                              = changed_date.month_sequence_number
  , is_weekday7_usa                                    = changed_date.is_weekday7_usa
  , is_weekday7_eu_iso                                 = changed_date.is_weekday7_eu_iso
  , calendar_date_eu                                   = changed_date.calendar_date_eu
  , calendar_date_usa                                  = changed_date.calendar_date_usa
  , calendar_day_of_month                              = changed_date.calendar_day_of_month
  , day_with_suffix                                    = changed_date.day_with_suffix
  , calendar_month_number                              = changed_date.calendar_month_number
  , calendar_month_name                                = changed_date.calendar_month_name
  , calendar_month_start_date                          = changed_date.calendar_month_start_date
  , calendar_month_end_date                            = changed_date.calendar_month_end_date
  , calendar_year_month                                = changed_date.calendar_year_month
  , calendar_week_number_usa                           = changed_date.calendar_week_number_usa
  , calendar_week_number_eu                            = changed_date.calendar_week_number_eu
  , calendar_continuum_year_week_number_usa            = changed_date.calendar_continuum_year_week_number_usa
  , calendar_continuum_year_week_number_eu             = changed_date.calendar_continuum_year_week_number_eu
  , calendar_continuum_year_week_number_usa_start_date = changed_date.calendar_continuum_year_week_number_usa_start_date
  , calendar_continuum_year_week_number_usa_end_date   = changed_date.calendar_continuum_year_week_number_usa_end_date
  , calendar_continuum_year_week_number_eu_start_date  = changed_date.calendar_continuum_year_week_number_eu_start_date
  , calendar_continuum_year_week_number_eu_end_date    = changed_date.calendar_continuum_year_week_number_eu_end_date
  , calendar_iso_week_number                           = changed_date.calendar_iso_week_number
  , calendar_continuum_year_iso_week_number            = changed_date.calendar_continuum_year_iso_week_number
  , calendar_continuum_year_iso_week_number_start_date = changed_date.calendar_continuum_year_iso_week_number_start_date
  , calendar_continuum_year_iso_week_number_end_date   = changed_date.calendar_continuum_year_iso_week_number_end_date
  , week_day_number_usa                                = changed_date.week_day_number_usa
  , week_day_number_eu_iso                             = changed_date.week_day_number_eu_iso
  , week_day_name                                      = changed_date.week_day_name
  , calendar_quarter_name                              = changed_date.calendar_quarter_name
  , calendar_quarter_number                            = changed_date.calendar_quarter_number
  , calendar_quarter_day_number                        = changed_date.calendar_quarter_day_number
  , calendar_quarter_month_number                      = changed_date.calendar_quarter_month_number
  , calendar_quarter_start_date                        = changed_date.calendar_quarter_start_date
  , calendar_quarter_end_date                          = changed_date.calendar_quarter_end_date
  , calendar_year                                      = changed_date.calendar_year
  , calendar_year_start_date                           = changed_date.calendar_year_start_date
  , calendar_year_end_date                             = changed_date.calendar_year_end_date
FROM
    (
     SELECT
            ##BATCH_ID## as batch_id
          , sc.dim_date_id
          , sc.day_sequence_number
          , sc.week_sequence_number_usa
          , sc.week_sequence_number_eu_iso
          , sc.month_sequence_number
          , sc.calendar_date
          , sc.is_weekday7_usa
          , sc.is_weekday7_eu_iso
          , sc.calendar_date_eu
          , sc.calendar_date_usa
          , sc.calendar_day_of_month
          , sc.day_with_suffix
          , sc.calendar_month_number
          , sc.calendar_month_name
          , sc.calendar_month_start_date
          , sc.calendar_month_end_date
          , sc.calendar_year_month
          , sc.calendar_week_number_usa
          , sc.calendar_week_number_eu
          , sc.calendar_continuum_year_week_number_usa
          , sc.calendar_continuum_year_week_number_eu
          , sc.calendar_continuum_year_week_number_usa_start_date
          , sc.calendar_continuum_year_week_number_usa_end_date
          , sc.calendar_continuum_year_week_number_eu_start_date
          , sc.calendar_continuum_year_week_number_eu_end_date
          , sc.calendar_iso_week_number
          , sc.calendar_continuum_year_iso_week_number
          , sc.calendar_continuum_year_iso_week_number_start_date
          , sc.calendar_continuum_year_iso_week_number_end_date
          , sc.week_day_number_usa
          , sc.week_day_number_eu_iso
          , sc.week_day_name
          , sc.calendar_quarter_name
          , sc.calendar_quarter_number
          , sc.calendar_quarter_day_number
          , sc.calendar_quarter_month_number
          , sc.calendar_quarter_start_date
          , sc.calendar_quarter_end_date
          , sc.calendar_year
          , sc.calendar_year_start_date
          , sc.calendar_year_end_date
       FROM
            stage.date_dim sc
           JOIN
                conformed.dim_date dc
             ON
                sc.calendar_date = dc.calendar_date
            AND
            (
                sc.dim_date_id                                          <>    dc.dim_date_id
             OR sc.day_sequence_number                                  <>    dc.day_sequence_number
             OR sc.week_sequence_number_usa                             <>    dc.week_sequence_number_usa
             OR sc.week_sequence_number_eu_iso                          <>    dc.week_sequence_number_eu_iso
             OR sc.month_sequence_number                                <>    dc.month_sequence_number
             OR sc.is_weekday7_usa                                      <>    dc.is_weekday7_usa
             OR sc.is_weekday7_eu_iso                                   <>    dc.is_weekday7_eu_iso
             OR sc.calendar_date_eu                                     <>    dc.calendar_date_eu
             OR sc.calendar_date_usa                                    <>    dc.calendar_date_usa
             OR sc.calendar_day_of_month                                <>    dc.calendar_day_of_month
             OR sc.day_with_suffix                                      <>    dc.day_with_suffix
             OR sc.calendar_month_number                                <>    dc.calendar_month_number
             OR sc.calendar_month_name                                  <>    dc.calendar_month_name
             OR sc.calendar_month_start_date                            <>    dc.calendar_month_start_date
             OR sc.calendar_month_end_date                              <>    dc.calendar_month_end_date
             OR sc.calendar_year_month                                  <>    dc.calendar_year_month
             OR sc.calendar_week_number_usa                             <>    dc.calendar_week_number_usa
             OR sc.calendar_week_number_eu                              <>    dc.calendar_week_number_eu
             OR sc.calendar_continuum_year_week_number_usa              <>    dc.calendar_continuum_year_week_number_usa
             OR sc.calendar_continuum_year_week_number_eu               <>    dc.calendar_continuum_year_week_number_eu
             OR sc.calendar_continuum_year_week_number_usa_start_date   <>    dc.calendar_continuum_year_week_number_usa_start_date
             OR sc.calendar_continuum_year_week_number_usa_end_date     <>    dc.calendar_continuum_year_week_number_usa_end_date
             OR sc.calendar_continuum_year_week_number_eu_start_date    <>    dc.calendar_continuum_year_week_number_eu_start_date
             OR sc.calendar_continuum_year_week_number_eu_end_date      <>    dc.calendar_continuum_year_week_number_eu_end_date
             OR sc.calendar_iso_week_number                             <>    dc.calendar_iso_week_number
             OR sc.calendar_continuum_year_iso_week_number              <>    dc.calendar_continuum_year_iso_week_number
             OR sc.calendar_continuum_year_iso_week_number_start_date   <>    dc.calendar_continuum_year_iso_week_number_start_date
             OR sc.calendar_continuum_year_iso_week_number_end_date     <>    dc.calendar_continuum_year_iso_week_number_end_date
             OR sc.week_day_number_usa                                  <>    dc.week_day_number_usa
             OR sc.week_day_number_eu_iso                               <>    dc.week_day_number_eu_iso
             OR sc.week_day_name                                        <>    dc.week_day_name
             OR sc.calendar_quarter_name                                <>    dc.calendar_quarter_name
             OR sc.calendar_quarter_number                              <>    dc.calendar_quarter_number
             OR sc.calendar_quarter_day_number                          <>    dc.calendar_quarter_day_number
             OR sc.calendar_quarter_month_number                        <>    dc.calendar_quarter_month_number
             OR sc.calendar_quarter_start_date                          <>    dc.calendar_quarter_start_date
             OR sc.calendar_quarter_end_date                            <>    dc.calendar_quarter_end_date
             OR sc.calendar_year                                        <>    dc.calendar_year
             OR sc.calendar_year_start_date                             <>    dc.calendar_year_start_date
             OR sc.calendar_year_end_date                               <>    dc.calendar_year_end_date

           )

     ) changed_date
WHERE
    dim_date.calendar_date = changed_date.calendar_date
    ;

---------------------------------------------------------------------------------------------------
-- insert dim_date.....
---------------------------------------------------------------------------------------------------
INSERT  INTO conformed.dim_date
(
    batch_id                                           
  , dim_date_id                                    
  , day_sequence_number                                
  , week_sequence_number_usa                           
  , week_sequence_number_eu_iso                        
  , month_sequence_number
  , calendar_date                                
  , is_weekday7_usa                                    
  , is_weekday7_eu_iso                                 
  , calendar_date_eu                                   
  , calendar_date_usa                                  
  , calendar_day_of_month                              
  , day_with_suffix                                    
  , calendar_month_number                              
  , calendar_month_name                                
  , calendar_month_start_date                          
  , calendar_month_end_date                            
  , calendar_year_month                                
  , calendar_week_number_usa                           
  , calendar_week_number_eu                            
  , calendar_continuum_year_week_number_usa            
  , calendar_continuum_year_week_number_eu             
  , calendar_continuum_year_week_number_usa_start_date 
  , calendar_continuum_year_week_number_usa_end_date   
  , calendar_continuum_year_week_number_eu_start_date  
  , calendar_continuum_year_week_number_eu_end_date    
  , calendar_iso_week_number                           
  , calendar_continuum_year_iso_week_number            
  , calendar_continuum_year_iso_week_number_start_date 
  , calendar_continuum_year_iso_week_number_end_date   
  , week_day_number_usa                                
  , week_day_number_eu_iso                             
  , week_day_name                                      
  , calendar_quarter_name                              
  , calendar_quarter_number                            
  , calendar_quarter_day_number                        
  , calendar_quarter_month_number                      
  , calendar_quarter_start_date                        
  , calendar_quarter_end_date                          
  , calendar_year                                      
  , calendar_year_start_date                           
  , calendar_year_end_date                             
)
SELECT
    ##BATCH_ID## as batch_id
  , cast(TO_CHAR(calendar_date, 'YYYYMMDD') as INT) as dim_date_id                                        
  , day_sequence_number                                
  , week_sequence_number_usa                           
  , week_sequence_number_eu_iso                        
  , month_sequence_number
  , calendar_date                                
  , is_weekday7_usa                                    
  , is_weekday7_eu_iso                                 
  , calendar_date_eu                                   
  , calendar_date_usa                                  
  , calendar_day_of_month                              
  , day_with_suffix                                    
  , calendar_month_number                              
  , calendar_month_name                                
  , calendar_month_start_date                          
  , calendar_month_end_date                            
  , calendar_year_month                                
  , calendar_week_number_usa                           
  , calendar_week_number_eu                            
  , calendar_continuum_year_week_number_usa            
  , calendar_continuum_year_week_number_eu             
  , calendar_continuum_year_week_number_usa_start_date 
  , calendar_continuum_year_week_number_usa_end_date   
  , calendar_continuum_year_week_number_eu_start_date  
  , calendar_continuum_year_week_number_eu_end_date    
  , calendar_iso_week_number                           
  , calendar_continuum_year_iso_week_number            
  , calendar_continuum_year_iso_week_number_start_date 
  , calendar_continuum_year_iso_week_number_end_date   
  , week_day_number_usa                                
  , week_day_number_eu_iso                             
  , week_day_name                                      
  , calendar_quarter_name                              
  , calendar_quarter_number                            
  , calendar_quarter_day_number                        
  , calendar_quarter_month_number                      
  , calendar_quarter_start_date                        
  , calendar_quarter_end_date                          
  , calendar_year                                      
  , calendar_year_start_date                           
  , calendar_year_end_date  
FROM
    stage.date_dim sc
WHERE
    NOT EXISTS
    (
     SELECT 1
       FROM
            conformed.dim_date dc
      WHERE
            dc.calendar_date  = sc.calendar_date
    )
;
