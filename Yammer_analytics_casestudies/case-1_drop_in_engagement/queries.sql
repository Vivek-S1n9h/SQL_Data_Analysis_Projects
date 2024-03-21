SELECT DATE_TRUNC('week', e.occurred_at),
       COUNT(DISTINCT e.user_id) AS weekly_active_users
  FROM tutorial.yammer_events e
 WHERE e.event_type = 'engagement'
   AND e.event_name = 'login'
 GROUP BY 1
 ORDER BY 1

/*engagement rate by weekdays */
SELECT
  DISTINCT weekday,
  CASE
    WHEN sub.weekday = 0 THEN 'Sun'
    WHEN sub.weekday = 1 THEN 'Mon'
    WHEN sub.weekday = 2 THEN 'Tue'
    WHEN sub.weekday = 3 THEN 'Wed'
    WHEN sub.weekday = 4 THEN 'Thu'
    WHEN sub.weekday = 5 THEN 'Fri'
    WHEN sub.weekday = 6 THEN 'Sat'
  END AS days,
  COUNT(1) AS activities
FROM
(
    SELECT
      occurred_at,
      EXTRACT(
        'dow'
        FROM
          occurred_at
      ) AS Weekday
    FROM
      tutorial.yammer_events
    WHERE
      occurred_at > '2014-07-27'
  ) sub
GROUP BY
  1
ORDER BY
  1


