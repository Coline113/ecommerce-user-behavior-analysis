use ecomerce_analysis;
create table  user_frequency as
select
user_id,
count(*) as buy_count
from user_behavior
where behavior='buy'
group by user_id;
select *
from user_frequency
order by buy_count desc
limit 10;
create table user_recency as
select user_id,
max(timestamp) as last_buy_time
from user_behavior
where behavior='buy'
group by user_id;
select *
from user_recency
limit 10;
create table user_rfm as
select
f.user_id,
f.buy_count,
r.last_buy_time
from user_frequency f
join user_recency r 
on f.user_id = r.user_id;
select *
from user_rfm
limit 10;
select 
from_unixtime(max(timestamp)) as max_data
from user_behavior;
CREATE TABLE user_rfm_final AS
SELECT
    user_id,
    buy_count,
    FROM_UNIXTIME(last_buy_time) AS last_buy_date,
    DATEDIFF(
        FROM_UNIXTIME(
            (SELECT MAX(timestamp) FROM user_behavior)
        ),
        FROM_UNIXTIME(last_buy_time)
    ) AS recency
FROM user_rfm;
select
from_unixtime(max(timestamp)) as max_data
from user_behavior;
SELECT 
    timestamp,
    FROM_UNIXTIME(timestamp) AS date_time
FROM user_behavior
ORDER BY timestamp DESC
LIMIT 10;
SELECT 
FROM_UNIXTIME(MAX(timestamp)) AS max_date
FROM user_behavior
WHERE timestamp < 1520000000;
SELECT
    FROM_UNIXTIME(MAX(timestamp)) AS max_date
FROM user_behavior
WHERE timestamp BETWEEN 1500000000 AND 1510000000;
SELECT
    DATE(FROM_UNIXTIME(timestamp)) AS date,
    COUNT(*) AS cnt
FROM user_behavior
WHERE timestamp < 1520000000
GROUP BY date
ORDER BY cnt DESC
LIMIT 20;
DROP TABLE IF EXISTS user_rfm_final;
CREATE TABLE user_rfm_final AS
SELECT
    user_id,
    buy_count,
    FROM_UNIXTIME(last_buy_time) AS last_buy_date,

    DATEDIFF(
        DATE('2017-12-03'),
        DATE(FROM_UNIXTIME(last_buy_time))
    ) AS recency

FROM user_rfm;
SELECT *
FROM user_rfm_final
LIMIT 10;
CREATE TABLE user_rfm_score AS
SELECT
    user_id,
    buy_count,
    recency,

    CASE
        WHEN recency <= 2 THEN 5
        WHEN recency <= 5 THEN 4
        WHEN recency <= 10 THEN 3
        WHEN recency <= 20 THEN 2
        ELSE 1
    END AS R_score,


    CASE
        WHEN buy_count >= 10 THEN 5
        WHEN buy_count >= 5 THEN 4
        WHEN buy_count >= 3 THEN 3
        WHEN buy_count = 2 THEN 2
        ELSE 1
    END AS F_score

FROM user_rfm_final;
SELECT *
FROM user_rfm_score
LIMIT 10;
CREATE TABLE user_segment AS
SELECT
    user_id,
    buy_count,
    recency,
    R_score,
    F_score,

    CASE
        WHEN R_score >=4 AND F_score >=4
            THEN '高价值用户'

        WHEN R_score >=4 AND F_score <4
            THEN '潜力用户'

        WHEN R_score <4 AND F_score >=3
            THEN '一般用户'

        ELSE '流失风险用户'

    END AS user_type

FROM user_rfm_score;
SELECT *
FROM user_segment
LIMIT 20;
SELECT
    user_type,
    COUNT(*) AS user_count
FROM user_segment
GROUP BY user_type
ORDER BY user_count DESC;