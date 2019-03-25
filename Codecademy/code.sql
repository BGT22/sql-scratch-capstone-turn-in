SELECT COUNT (DISTINCT utm_source), 
	COUNT (DISTINCT utm_campaign)
FROM page_visits;

SELECT DISTINCT utm_source AS Source, 
	utm_campaign AS Campaign 
FROM page_visits;

SELECT page_name AS Page , 
	COUNT (timestamp) AS 'Page Loads'
	FROM page_visits
GROUP BY 1;

WITH first_touch AS (
    SELECT user_id,
       MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id),
first_source AS (
	SELECT ft.user_id,
		 ft.first_touch_at,
		pv.utm_source,
			pv.utm_campaign
	FROM first_touch ft
	JOIN page_visits pv
	ON pv.user_id = ft.user_id
	AND pv.timestamp = ft.first_touch_at)

SELECT first_source.utm_campaign AS Campaign,
  	COUNT (*) AS "Total First Touches"
FROM first_source
 GROUP BY 1
ORDER BY 2 ASC;

WITH last_touch AS (
    SELECT user_id,
       MAX(timestamp) AS last_touch_at
    FROM page_visits
    GROUP BY user_id),
last_source AS (
	SELECT last_touch.user_id,
		last_touch.last_touch_at,
		page_visits.utm_source,
		page_visits.utm_campaign
	FROM last_touch 
	JOIN page_visits 
	ON page_visits.user_id = last_touch.user_id
	AND page_visits.timestamp = last_touch.last_touch_at)

SELECT last_source.utm_campaign AS Campaign,
  COUNT (*) AS "Totals Last Touches" 
FROM last_source
 GROUP BY 1
 ORDER BY 2;

SELECT page_name AS Page , 
	COUNT (timestamp) AS 'Page Loads'
FROM page_visits
WHERE page_name LIKE '%purchase%';

WITH last_touch AS (
    SELECT user_id,
       MAX(timestamp) AS last_touch_at
    FROM page_visits
  WHERE page_name LIKE '%purchase%'  
  GROUP BY user_id),
last_source AS (
	SELECT last_touch.user_id,
		last_touch.last_touch_at,
		page_visits.utm_source,
		page_visits.utm_campaign
	FROM last_touch 
	JOIN page_visits 
	ON page_visits.user_id = last_touch.user_id
	AND page_visits.timestamp = last_touch.last_touch_at)

SELECT last_source.utm_campaign AS Campaign,
  COUNT (*) AS "Total Last Touches" 
FROM last_source
GROUP BY 1
ORDER BY 2;
