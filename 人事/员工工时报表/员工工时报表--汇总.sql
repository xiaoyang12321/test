-- 汇总表
set session sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
set @start_day='2017-05-01';
set @end_day='2017-05-05';
set @sid="CN010004";
SELECT 
    market_and_store.market,
    market_and_store.operation,
    market_and_store.steering,
    market_and_store.sid,
    market_and_store.sname,
    market_and_store.psncode,
    market_and_store.name,
    market_and_store.position_name,
    market_and_store.employee_attributes,
    employment_mode.employment,
    times_not_holiday AS weekday_hours,
    times_holiday AS holiday_hours,
    times
FROM
    (SELECT 
        b.market,
            b.operation,
            b.steering,
            b.sid,
            b.sname,
            a.psncode,
            a.name,
            a.position_name,
            '本店员工' AS employee_attributes,
            a.attendance_time
    FROM
        (SELECT 
        hrb.bind_sid,
            hrb.psncode,
            hrb.name,
            hrj.position_name,
            hra.sid,
            hra.attendance_time
    FROM
        erp.hr_attendance hra
    JOIN erp.hr_jobinfo hrj ON hra.card_id = hrj.work_check_card
    JOIN erp.hr_basicinfo hrb ON hrj.psncode = hrb.psncode
    LEFT JOIN (SELECT 
        psncode, MAX(effect_date) AS effect_date
    FROM
        erp.hr_dimissioninfo
    GROUP BY psncode) dismiss ON hrj.psncode = dismiss.psncode
    WHERE
        hra.status = 1
            AND IF(dismiss.psncode IS NOT NULL
            AND dismiss.effect_date > hrj.entry_date, FROM_UNIXTIME(dismiss.effect_date, '%Y-%m-%d %H:%i:%s') >= @start_day, 1 = 1)
            AND hra.sid in (@sid)
            AND date(FROM_UNIXTIME(attendance_time)) between @start_day and @end_day) AS a
    LEFT JOIN (SELECT 
        market.market,
            market.operation,
            market.steering,
            store.sid,
            store.sname
    FROM
        (SELECT 
        sid,
            sname,
            representative_id,
            representative_name,
            store_market
    FROM
        de.reporting_cache_store
    GROUP BY sid) AS store
    LEFT JOIN (SELECT 
        rcst1.tid,
            IFNULL(rcst4.name, '') AS market,
            rcst2.name AS operation,
            rcst1.name AS steering
    FROM
        de.reporting_cache_store_taxonomy rcst1
    LEFT JOIN de.reporting_cache_store_taxonomy rcst2 ON rcst1.parent_id = rcst2.tid
    LEFT JOIN de.reporting_cache_store_taxonomy rcst3 ON rcst2.parent_id = rcst3.tid
    LEFT JOIN de.reporting_cache_store_taxonomy rcst4 ON rcst4.tid = rcst3.parent_id
    LEFT JOIN de.reporting_cache_store_taxonomy rcst5 ON rcst5.tid = rcst4.parent_id
    WHERE
        rcst1.category_name = 'market') AS market ON store.store_market = market.tid) AS b ON a.sid = b.sid) AS market_and_store
        LEFT JOIN
    (SELECT 
        j.name, j.psncode, d.name AS employment
    FROM
        erp.hr_jobinfo j
    LEFT JOIN erp.taxonomy_term_data d ON j.job_type = d.tid) AS employment_mode ON market_and_store.psncode = employment_mode.psncode
        LEFT JOIN
    (SELECT 
        name,
            psncode,
            SUM(is_not_holiday * times) AS times_not_holiday,
            SUM(is_holiday * times) AS times_holiday,
            SUM(times) AS times
    FROM
        (SELECT 
        dates,
            a.name,
            psncode,
            IF(b.date IS NULL, 0, 1) AS is_holiday,
            IF(b.date IS NULL, 1, 0) AS is_not_holiday,
            times
    FROM
        (SELECT 
        DATE(FROM_UNIXTIME(attendance_time)) AS dates,
            name,
            psncode,
            (ROUND((end_time1 - start_time1 + end_time2 - start_time2 + end_time3 - start_time3 + end_time4 - start_time4 + end_time5 - start_time5 + end_time6 - start_time6) / 3600, 2)) AS times
    FROM
        erp.hr_attendance hra
    JOIN erp.hr_jobinfo hrj ON hra.card_id = hrj.work_check_card
    WHERE
        date(FROM_UNIXTIME(attendance_time)) between @start_day and @end_day
            AND hra.status = 1
            AND hra.sid in (@sid)) a
    LEFT JOIN erp.hr_attendance_holiday b ON a.dates = b.date) a
    GROUP BY psncode) AS count_time ON market_and_store.psncode = count_time.psncode
GROUP BY psncode , sid
order by sid,psncode