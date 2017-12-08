DROP VIEW IF EXISTS markdown_app.uv_price_changes;

CREATE OR REPLACE VIEW markdown_app.uv_price_changes AS 
 SELECT	iup.dim_product_id, 
 		iup.week_sequence_number_usa, 
		iup.sales_quantity, 
		iup.previous_quantity, 
		iup.optimisation_csp, 
		iup.previous_price, 
		iup.is_md_preceded_by_promotion, 
		iup.is_promotional_price_change, 
		iup.is_full_price
   FROM ( SELECT pg_catalog.row_number()
          OVER( 
	          PARTITION BY	cte_identify_markdown_events.dim_product_id, 
			  				cte_identify_markdown_events.optimisation_csp
	          ORDER BY cte_identify_markdown_events.week_sequence_number_usa) AS rank, 
			  			cte_identify_markdown_events.dim_product_id, 
						cte_identify_markdown_events.week_sequence_number_usa, 
						cte_identify_markdown_events.sales_quantity, 
						cte_identify_markdown_events.previous_quantity, 
						cte_identify_markdown_events.optimisation_csp, 
						cte_identify_markdown_events.previous_price, 
						cte_identify_markdown_events.is_md_preceded_by_promotion, 
						cte_identify_markdown_events.is_promotional_price_change, 
						cte_identify_markdown_events.is_full_price
	           FROM ( SELECT	iea.dim_product_id, 
			   					iea.week_sequence_number_usa, 
								iea.sales_quantity, 
								iea.previous_quantity, 
								iea.optimisation_csp, 
								iea.previous_price, 
								iea.is_md_preceded_by_promotion, 
								iea.is_promotional_price_change, 
								iea.is_full_price
	                   FROM ( SELECT	fwsba.dim_product_id, 
					   					fwsba.week_sequence_number_usa, 
										fwsba.sales_quantity, 
										pg_catalog.lead(fwsba.sales_quantity, 1)
							                          OVER( 
									                          PARTITION BY fwsba.dim_product_id
									                          ORDER BY 	fwsba.week_sequence_number_usa DESC) AS previous_quantity, 
                                        fwsba.optimisation_csp, 
                                        pg_catalog.lead(fwsba.optimisation_csp, 1)
                                                    OVER( 
                                                            PARTITION BY fwsba.dim_product_id
                                                            ORDER BY 	fwsba.week_sequence_number_usa DESC) AS previous_price, 
							  			fwsba.is_md_preceded_by_promotion, 
										fwsba.is_promotional_price_change, 
										fwsba.is_full_price
	                           FROM markdown_app.uv_fact_weekly_sales_basic_aggregated fwsba) iea
	              		WHERE iea.optimisation_csp < iea.previous_price) cte_identify_markdown_events
					) iup
  			WHERE iup.rank = 1;
