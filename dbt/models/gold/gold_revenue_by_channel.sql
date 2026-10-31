-- Gold: paid revenue per sales channel (refunded orders excluded).
-- TODO (step 5.1): write the query. Expected result: 3 rows, total 21,436 GBP.
--   columns: channel, paid_orders (count of distinct order_id), revenue_gbp (sum of line_revenue_gbp)
--   read from: {{ ref('silver_order_lines') }}  ·  keep only status = 'paid'  ·  group by channel


select
    channel,
    count(distinct order_id) as paid_orders,
    sum(line_revenue_gbp) as revenue_gbp
from {{ ref('silver_order_lines') }}
where status = 'paid'
group by channel