-- 1.
-- Number of distinct campaigns.
SELECT COUNT(DISTINCT utm_campaign) as campaign_count FROM page_visits;
-- Number of distinct sources
SELECT COUNT(DISTINCT utm_source) as source_count FROM page_visits;
-- Number of distinct combinations
SELECT DISTINCT utm_campaign, utm_source FROM page_visits;

-- 2.
-- Pages on the website.
SELECT DISTINCT page_name FROM page_visits;

-- 3.
-- First touches per campaign.
WITH first_touches AS (
SELECT user_id, MIN(timestamp) as 'first_touch_at'
  FROM page_visits
  GROUP BY user_id
)
SELECT pv.utm_campaign, pv.utm_source, COUNT(pv.utm_campaign) as 'first_touch_count'
FROM first_touches ft
JOIN page_visits pv
ON ft.user_id = pv.user_id
AND ft.first_touch_at = pv.timestamp
GROUP BY pv.utm_campaign, pv.utm_source
ORDER BY first_touch_count DESC
;

-- 4.
-- Last touches per campaign
WITH last_touches AS (
SELECT user_id, MAX(timestamp) as 'last_touch_at'
  FROM page_visits
  GROUP BY user_id
)
SELECT pv.utm_campaign, pv.utm_source, COUNT(pv.utm_campaign) as 'last_touch_count'
FROM last_touches lt
JOIN page_visits pv
ON lt.user_id = pv.user_id
AND lt.last_touch_at = pv.timestamp
GROUP BY pv.utm_campaign, pv.utm_source
ORDER BY last_touch_count DESC
;

-- 5.
-- Visitors that make a purchase
SELECT COUNT(DISTINCT user_id) as 'purchase_users'
FROM page_visits
WHERE page_name = '4 - purchase';

-- 6.
-- Last touches on purchase page per campaign
WITH last_touches AS (
SELECT user_id, MAX(timestamp) as 'last_touch_at'
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id
)
SELECT pv.utm_campaign, pv.utm_source, COUNT(pv.utm_campaign) as 'last_touch_count'
FROM last_touches lt
JOIN page_visits pv
ON lt.user_id = pv.user_id
AND lt.last_touch_at = pv.timestamp
GROUP BY pv.utm_campaign, pv.utm_source
ORDER BY last_touch_count DESC
;