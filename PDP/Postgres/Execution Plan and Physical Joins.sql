--explain (analyze)
--explain (analyze, verbose, costs, settings, buffers, wal, timing, summary)
--explain (analyze, verbose, buffers, format json)
explain (generic_plan)
select * from customer where first_name = 'firstname78078';

[
  {
    "Plan": {
      "Node Type": "Index Scan",
      "Parallel Aware": false,
      "Async Capable": false,
      "Scan Direction": "Forward",
      "Index Name": "idx_mul_full_name",
      "Relation Name": "customer",
      "Schema": "public",
      "Alias": "customer",
      "Startup Cost": 0.42,
      "Total Cost": 8.44,
      "Plan Rows": 1,
      "Plan Width": 75,
      "Actual Startup Time": 0.026,
      "Actual Total Time": 0.027,
      "Actual Rows": 1,
      "Actual Loops": 1,
      "Output": ["customer_id", "first_name", "last_name", "email", "modified_date", "age", "active"],
      "Index Cond": "((customer.first_name)::text = 'firstname78078'::text)",
      "Rows Removed by Index Recheck": 0,
      "Shared Hit Blocks": 4, --shared buffers fetched from CACHE
      "Shared Read Blocks": 0, --shared buffers read from DISK
      "Shared Dirtied Blocks": 0,
      "Shared Written Blocks": 0,
      "Local Hit Blocks": 0,
      "Local Read Blocks": 0,
      "Local Dirtied Blocks": 0,
      "Local Written Blocks": 0,
      "Temp Read Blocks": 0,
      "Temp Written Blocks": 0
    },
    "Planning": {
      "Shared Hit Blocks": 0,
      "Shared Read Blocks": 0,
      "Shared Dirtied Blocks": 0,
      "Shared Written Blocks": 0,
      "Local Hit Blocks": 0, 
      "Local Read Blocks": 0, 
      "Local Dirtied Blocks": 0,
      "Local Written Blocks": 0,
      "Temp Read Blocks": 0,
      "Temp Written Blocks": 0
    },
    "Planning Time": 0.131,
    "Triggers": [
    ],
    "Execution Time": 0.043
  }
]



select * from pg_stats where tablename = 'customer'; --view on pg_statistic
select * from pg_statistic;
select * from pg_stats where tablename = 'employeepayhistory'; --view on pg_statistic
-- [ ! ] pg_statistic should not be readable by the public, since even statistical information about a table's contents might be considered sensitive. (Example: minimum and maximum values of a salary column might be quite interesting.) pg_stats is a publicly readable view on pg_statistic that only exposes information about those tables that are readable by the current user;

select * from customer;
analyze (verbose) customer(age); --analyzing "public.customer"
--"customer": scanned 14190 of 14190 pages, containing 1000000 live rows and 0 dead rows; 30000 rows in sample, 1000000 estimated total rows
 



