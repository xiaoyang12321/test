-- 汇总表
set session sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
set @start_day='2017-05-01';
set @end_day='2017-05-05';
set @storeid='CN010004';
SELECT 
    store.market_four market,
    store.market_two operation,
    store.market_one steering,
    erp.attendance_storeId as sid,
    erp.attendance_storeName as sname,
    erp.employee_code as psncode,
    erp.employee_name as name,
    erp.position_name,
    '本店员工' as employee_attributes,
    erp.job_type as employment,
    sum(if(erp.holiday=0,erp.count_time,0)) AS weekday_hours,
    sum(if(erp.holiday=1,erp.count_time,0)) AS holiday_hours,
    sum(erp.count_time) times
FROM datacache.erp_attendance_middle_table erp 
left join datacache.de_store store on store.sid=erp.job_storeId
where erp.attendance_storeId in (@storeid)
and erp.status=1
and erp.attendance_time between @start_day and @end_day
group by erp.attendance_storeId,erp.employee_code