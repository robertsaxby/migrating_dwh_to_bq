SELECT
  t_s_symb AS security,
  TIME( s1.t_dts ) AS bid_time,
  AVG( s2.t_bid_price ) AS avg_bid
FROM
 da304_uc2.trade AS s1 inner join da304_uc2.trade AS s2
ON
  s1.t_dts = s2.t_dts
WHERE
  UNIX_SECONDS(s1.t_dts)
  BETWEEN (UNIX_SECONDS(s1.t_dts) - 60)
  AND UNIX_SECONDS(s1.t_dts)
  AND
  s1.t_dts
  BETWEEN TIMESTAMP("2018-07-11 09:00:00.000")
  AND TIMESTAMP("2018-07-11 11:59:59.999")
GROUP BY
  security, bid_time
ORDER BY
  bid_time ASC;
