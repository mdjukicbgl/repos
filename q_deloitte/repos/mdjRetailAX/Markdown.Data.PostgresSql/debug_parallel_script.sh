#!/usr/bin/env bash

echo BEGIN\;
cat ephemeral/*_schema_*.sql ephemeral/*_procs_*.sql | sed -e "s/ephemeral\./temp$(($1))_/g"
echo SELECT temp$1_get_scenario_data\(          \
  p_model_run_id:=100,                          \
  p_scenario_id:=100,                           \
  p_scenario_week:=897,                         \
  p_schedule_week_min:=890,                     \
  p_schedule_week_max:=900,                     \
  p_weeks_to_extrapolate_on:=3,                 \
  p_decay_backdrop:=0.9,                        \
  p_observed_decay_min:=0.3,                    \
  p_observed_decay_max:=1.2,                    \
  p_markdown_count_start_week:=800,             \
  p_partition_count:=1,                         \
  p_allow_promo_as_markdown:=TRUE,		\
  p_minimum_promo_percentage:=10,		\
  p_observed_decay_cap:=2			\
\)\;                                            \
ROLLBACK\;                                      \
END\;                                           


