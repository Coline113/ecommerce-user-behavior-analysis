USE ecommerce_analysis;


CREATE TABLE user_behavior (
    user_id BIGINT,
    item_id BIGINT,
    category_id BIGINT,
    behavior VARCHAR(20),
    timestamp BIGINT
);
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
USE ecommerce_analysis;
LOAD DATA LOCAL INFILE
'C:/Users/ASUS/UserBehavior.csv'
INTO TABLE user_behavior
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(user_id,item_id,category_id,behavior,timestamp);
select count(*)
from user_behavior;
select
behavior,
count(*) as behavior_count
from user_behavior
group by behavior
order by behavior_count desc;
select
behavior,
count(distinct user_id) as uses_count
from user_behavior
group by behavior;
select
behavior,
count(distinct user_id) as user_count
from user_behavior
where behavior in ('pv','fav','cart','buy')
group by behavior;
create index idx_user_id
on user_behavior(user_id);
create index idx_behavior
on user_behavior(behavior);
create table user_behavior_user_count as
select
behavior,
count(distinct user_id) as user_count
from user_behavior
group by behavior;
SELECT
    behavior,
    COUNT(DISTINCT user_id) AS user_count
FROM user_behavior
WHERE behavior='pv';
select
count(DISTINCT user_id) as fav_users
from user_behavior
where behavior='fav';
select
count(DISTINCT user_id) as buy_users
from user_behavior
where behavior='buy';
select
count(distinct user_id) as view_user
from user_behavior
where behavior='pv'
group by category_id
order by view_user desc
limit 10;
SELECT
    category_id,
    COUNT(DISTINCT user_id) AS buy_user
FROM user_behavior
WHERE behavior='buy'
GROUP BY category_id
ORDER BY buy_user DESC
LIMIT 10;
select
a.category_id,
a.view_user,
b.buy_user,
round(b.buy_user / a.view_user*100,2) as conversion_rate
from
(
select
category_id,
count(distinct user_id) as view_user
from user_behavior
where behavior='pv'
group by category_id
) a
join
(
select
category_id,
count(distinct user_id) as buy_user
from user_behavior
where behavior='buy'
group by category_id
) b
on a.category_id = b.category_id
where a.view_user >= 1000
order by conversion_rate desc
limit 10;
select
user_id,
count(*) as buy_count
from user_behavior
where behavior='buy'
group by user_id
order by buy_count desc
limit 10;
select
user_id,
max(timestamp) as last_buy_time
from user_behavior
where behavior='buy'
group by user_id
limit 10;
select
a.user_id,
a.buy_count,
b.last_buy_time
from
(
select
user_id,
count(*) as buy_count
from user_behavior
where behavior='buy'
group by user_id
) a
join
(
select
user_id,
max(timestamp) as last_buy_time
from user_behavior
where behavior='buy'
group by user_id
) b
on a.user_id=b.user_id
order by a.buy_count desc
limit 10;
