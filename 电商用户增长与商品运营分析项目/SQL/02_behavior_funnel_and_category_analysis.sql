USE ecommerce_analysis;

CREATE TABLE behavior_summary AS
SELECT
    behavior,
    COUNT(*) AS behavior_count
FROM user_behavior
GROUP BY behavior;
USE ecommerce_analysis;
create table user_funnel_summary as
select
behavior,
count(distinct user_id) as user_count
FROM user_behavior
where behavior in ('pv','fav','cart','buy')
GROUP BY behavior;
USE ecommerce_analysis;
create table category_view_summary as
select
category_id,
count(distinct user_id) as view_user
FROM user_behavior
where behavior = 'pv'
GROUP BY category_id;
SELECT *
FROM category_view_summary
ORDER BY view_user DESC
LIMIT 10;
USE ecommerce_analysis;
create table category_buy_summary as
select
category_id,
count(distinct user_id) as buy_user
FROM user_behavior
where behavior = 'buy'
GROUP BY category_id;
USE ecommerce_analysis;

SELECT *
FROM category_buy_summary
ORDER BY buy_user DESC
LIMIT 10;
USE ecommerce_analysis;
CREATE TABLE category_conversion_summary AS
SELECT
    v.category_id,
    v.view_user,
    b.buy_user,
    ROUND(b.buy_user / v.view_user * 100, 2) AS conversion_rate
FROM category_view_summary v
JOIN category_buy_summary b
ON v.category_id = b.category_id;
SELECT *
FROM category_conversion_summary
ORDER BY conversion_rate DESC
LIMIT 10;
CREATE TABLE category_conversion_v2 AS
SELECT
    category_id,
    COUNT(DISTINCT CASE WHEN behavior='pv' THEN user_id END) AS view_user,
    COUNT(DISTINCT CASE WHEN behavior='buy' THEN user_id END) AS buy_user
FROM user_behavior
GROUP BY category_id;
select*,
round(buy_user/view_user*100,2) as conversion_rate
from category_conversion_v2
where view_user > 0
order by conversion_rate desc
limit 10;
DROP TABLE IF EXISTS category_conversion_v2;
CREATE TABLE category_conversion_v2 AS
SELECT
    category_id,
    COUNT(DISTINCT CASE 
        WHEN behavior='pv' THEN user_id 
    END) AS view_user,

    COUNT(DISTINCT CASE 
        WHEN behavior='buy' THEN user_id 
    END) AS buy_user

FROM user_behavior

GROUP BY category_id;
SELECT
    category_id,
    view_user,
    buy_user,
    ROUND(
        buy_user / view_user * 100,
        2
    ) AS conversion_rate

FROM category_conversion_v2

WHERE view_user >= 1000


ORDER BY conversion_rate DESC

LIMIT 10;


