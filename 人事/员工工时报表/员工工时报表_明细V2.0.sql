-- 明细表
set session sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
set @start_day='2017-05-01';
set @end_day='2017-05-05';
set @storeid=CN010004;

SELECT 
    store.market_four as market,
    store.market_two as operation,
    store.market_one as steering,
    erp.attendance_storeId as sid,
    erp.attendance_storeName as sname,
    erp.employee_code as psncode,
    erp.employee_name as name,
    erp.attendance_time AS date,
    if(erp.start_time_one=erp.end_time_one,'~',CONCAT(left(erp.start_time_one, 5), '~', left(erp.end_time_one, 5))) time1,
    if(erp.start_time_two=erp.end_time_two,'~',CONCAT(left(erp.start_time_two, 5), '~', left(erp.end_time_two, 5))) time2,
    if(erp.start_time_three=erp.end_time_three,'~',CONCAT(left(erp.start_time_three, 5), '~', left(erp.end_time_three, 5))) time3,
    if(erp.start_time_four=erp.end_time_four,'~',CONCAT(left(erp.start_time_four, 5), '~', left(erp.end_time_four, 5))) time4,
    if(erp.start_time_five=erp.end_time_five,'~',CONCAT(left(erp.start_time_five, 5), '~', left(erp.end_time_five, 5))) time5,
    if(erp.start_time_five=erp.end_time_five,'~',CONCAT(left(erp.start_time_five, 5), '~', left(erp.end_time_six, 5))) time6,
    ifnull(erp.count_time,0) count_times,
    ifnull(erp.reason,'') reason,
    ifnull(erp.approve_user,'') approve_user
FROM datacache.erp_attendance_middle_table erp left join 
datacache.de_store store on store.sid=erp.job_storeId
where erp.attendance_storeId in (@storeid)
and erp.status=1
and erp.attendance_time between @start_day and @end_day
group by erp.attendance_storeId,erp.employee_code,erp.attendance_time