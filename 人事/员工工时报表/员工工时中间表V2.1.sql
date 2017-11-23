#erp_attendance_middle_table中间表的脚本
set session sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

SET @start_day='2017-06-01';
SET @end_day='2017-06-02';
SET @storeid='CN010003';
            select
                    hra.card_id,#考勤卡号
                    hra.sid as attendance_storeId, #考勤门店id
                    rcs1.sname as attendance_storeName, #归属门店／工作门店名称
                    job.bind_sid as job_storeId, #归属门店／工作门店id
                    rcs2.sname as job_storeName, #归属门店／工作门店名称
                    job.psncode as employee_code,
                    job.name as employee_name, #员工姓名
                    case  when job.position_type=01 then '餐厅'
                              when job.position_type=02 then '外送'
                    else '未知' end as position_type , #职位类型。01餐厅|02外送
                    #if(job.position_type=01,'餐厅','外送') as position_type, #职位类型。01餐厅|02外送
                    tax1.name as position_name,#职位名称
                    tax2.name as job_type, #用工方式
                    if(hra.attendance_time<0,DATE(DATE_ADD(FROM_UNIXTIME(0), INTERVAL hra.attendance_time SECOND)),FROM_UNIXTIME(hra.attendance_time, '%Y-%m-%d')) AS attendance_time, #考勤日期
                    ROUND((if(end_time1=0 or start_time1=0,0,if(start_time1>end_time1,end_time1+86400-start_time1,end_time1- start_time1))+
                       if(end_time2=0 or start_time2=0,0, if(start_time2>end_time2,end_time2+86400-start_time2,end_time2- start_time2))+
                       if(end_time3=0 or start_time3=0,0, if(start_time3>end_time3,end_time3+86400-start_time3,end_time3- start_time3))+
                       if(end_time4=0 or start_time4=0,0, if(start_time4>end_time4,end_time4+86400-start_time4,end_time4- start_time4))+
                       if(end_time5=0 or start_time5=0,0, if(start_time5>end_time5,end_time5+86400-start_time5,end_time5- start_time5)) +
                       if(end_time6=0 or start_time6=0,0, if(start_time6>end_time6,end_time6+86400-start_time6,end_time6- start_time6)))/3600,2) as count_time,
                    if(hra.start_time1=0,'',from_unixtime(hra.start_time1,'%H:%i:%s')) as start_time_one, #开始时间1
                    if(hra.end_time1=0,'',from_unixtime(hra.end_time1,'%H:%i:%s')) as end_time_one,#结束时间1
                    if(hra.start_time2=0,'',from_unixtime(hra.start_time2,'%H:%i:%s')) as start_time_two, #开始时间2
                    if(hra.end_time2=0,'',from_unixtime(hra.end_time2,'%H:%i:%s')) as end_time_two, #结束时间2
                    if(hra.start_time3=0,'',from_unixtime(hra.start_time3,'%H:%i:%s')) as start_time_three, #开始时间3
                    if(hra.end_time3=0,'',from_unixtime(hra.end_time3,'%H:%i:%s')) as end_time_three, #结束时间3
                    if(hra.start_time4=0,'',from_unixtime(hra.start_time4,'%H:%i:%s')) as start_time_four, #开始时间4
                    if(hra.end_time4=0,'',from_unixtime(hra.end_time4,'%H:%i:%s')) as end_time_four, #结束时间4
                    if(hra.start_time5=0,'',from_unixtime(hra.start_time5,'%H:%i:%s')) as start_time_five, #开始时间5
                    if(hra.end_time5=0,'',from_unixtime(hra.end_time5,'%H:%i:%s')) as end_time_five, #结束时间5
					if(hra.start_time6=0,'',from_unixtime(hra.start_time6,'%H:%i:%s')) as start_time_six, #开始时间6
                    if(hra.end_time6=0,'',from_unixtime(hra.end_time6,'%H:%i:%s')) as end_time_six, #结束时间6
                    hra.reason,
                    hra.approve_user,
                    now() as create_time,
                    hra.status,
                    if(holiday.date is null,0,1) holiday
            from erp.hr_attendance  as hra
            left join erp.hr_jobinfo as job on hra.card_id=job.work_check_card
            left join de.reporting_cache_store as rcs1  on rcs1.sid = hra.sid
            left join de.reporting_cache_store as rcs2  on rcs2.sid = job.bind_sid
            left join erp.taxonomy_term_data as tax1 on job.position_name = tax1.tid
            left join erp.taxonomy_term_data as tax2 on job.job_type = tax2.tid
            left join erp.hr_attendance_holiday as holiday on DATE(FROM_UNIXTIME(hra.attendance_time)) = holiday.date
            where
                hra.sid in(@storeid)
                and
                date(from_unixtime(hra.attendance_time)) between @start_day and @end_day