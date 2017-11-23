set session sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';



SELECT
    store_base_info.shichang as storeMarketName,
    store_base_info.yingyun AS operating_area,
    store_base_info.dudao AS supervise_the_area,
    a.bind_sid,
    store_base_info.sname as sname,
    a.psncode,
    a.name,
    b.type_name,
    a.id_number,
    a.sex,
    a.birthday,
    TIMESTAMPDIFF(YEAR,a.birthday,CURDATE()) AS age,
    CASE
        WHEN TIMESTAMPDIFF(YEAR, a.birthday, CURDATE()) > 10 AND TIMESTAMPDIFF(YEAR, a.birthday, CURDATE()) <= 20 THEN '11 - 20'
        WHEN TIMESTAMPDIFF(YEAR, a.birthday, CURDATE()) > 20 AND TIMESTAMPDIFF(YEAR, a.birthday, CURDATE()) <= 30 THEN '21 - 30'
        WHEN TIMESTAMPDIFF(YEAR, a.birthday, CURDATE()) > 30 AND TIMESTAMPDIFF(YEAR, a.birthday, CURDATE()) <= 40 THEN '31 - 40'
        WHEN TIMESTAMPDIFF(YEAR, a.birthday, CURDATE()) > 40 AND TIMESTAMPDIFF(YEAR, a.birthday, CURDATE()) <= 50 THEN '41 - 50'
        WHEN TIMESTAMPDIFF(YEAR, a.birthday, CURDATE()) > 50 AND TIMESTAMPDIFF(YEAR, a.birthday, CURDATE()) <= 60 THEN '51 - 60'
        WHEN TIMESTAMPDIFF(YEAR, a.birthday, CURDATE()) > 60 AND TIMESTAMPDIFF(YEAR, a.birthday, CURDATE()) <= 70 THEN '61 - 70'
        ELSE '' END AS age_group,
    TIMESTAMPDIFF(YEAR, a.entry_date, CURDATE()) AS working_years,
    a.entry_date,
    CASE
        WHEN a.nativeplace = 01 THEN '汉族'
        WHEN a.nativeplace = 02 THEN '状族'
        WHEN a.nativeplace = 03 THEN '回族'
        WHEN a.nativeplace = 04 THEN '藏族'
        WHEN a.nativeplace = 05 THEN '维吾尔族'
        WHEN a.nativeplace = 06 THEN '苗族'
        WHEN a.nativeplace = 07 THEN '瑶族'
        WHEN a.nativeplace = 08 THEN '侗族'
        WHEN a.nativeplace = 09 THEN '彝族'
        WHEN a.nativeplace = 10 THEN '朝鲜族'
        WHEN a.nativeplace = 11 THEN '满族'
        WHEN a.nativeplace = 12 THEN '布依族'
        WHEN a.nativeplace = 13 THEN '蒙古族'
        WHEN a.nativeplace = 14 THEN '白族'
        WHEN a.nativeplace = 15 THEN '土家族'
        WHEN a.nativeplace = 16 THEN '畲族'
        WHEN a.nativeplace = 17 THEN '高山族'
        WHEN a.nativeplace = 18 THEN '傣族'
        WHEN a.nativeplace = 19 THEN '黎族'
        WHEN a.nativeplace = 20 THEN '傈僳族'
        WHEN a.nativeplace = 21 THEN '佤族'
        WHEN a.nativeplace = 22 THEN '哈尼族'
        WHEN a.nativeplace = 23 THEN '哈萨克族'
        WHEN a.nativeplace = 24 THEN '拉祜族'
        WHEN a.nativeplace = 25 THEN '水族'
        WHEN a.nativeplace = 26 THEN '东乡族'
        WHEN a.nativeplace = 27 THEN '纳西族'
        WHEN a.nativeplace = 28 THEN '景颇族'
        WHEN a.nativeplace = 29 THEN '柯尔克孜族'
        WHEN a.nativeplace = 30 THEN '土族'
        WHEN a.nativeplace = 31 THEN '达斡尔族'
        WHEN a.nativeplace = 32 THEN '仫佬族'
        WHEN a.nativeplace = 33 THEN '羌族'
        WHEN a.nativeplace = 34 THEN '布朗族'
        WHEN a.nativeplace = 35 THEN '撒拉族'
        WHEN a.nativeplace = 36 THEN '毛南族'
        WHEN a.nativeplace = 37 THEN '仡佬族'
        WHEN a.nativeplace = 38 THEN '锡伯族'
        WHEN a.nativeplace = 39 THEN '阿昌族'
        WHEN a.nativeplace = 40 THEN '普米族'
        WHEN a.nativeplace = 41 THEN '塔吉克族'
        WHEN a.nativeplace = 42 THEN '怒族'
        WHEN a.nativeplace = 43 THEN '乌兹别克族'
        WHEN a.nativeplace = 44 THEN '俄罗斯族'
        WHEN a.nativeplace = 45 THEN '鄂温克族'
        WHEN a.nativeplace = 46 THEN '德昂族'
        WHEN a.nativeplace = 47 THEN '保安族'
        WHEN a.nativeplace = 48 THEN '裕固族'
        WHEN a.nativeplace = 49 THEN '京族'
        WHEN a.nativeplace = 50 THEN '塔塔尔族'
        WHEN a.nativeplace = 51 THEN '独龙族'
        WHEN a.nativeplace = 52 THEN '鄂伦春族'
        WHEN a.nativeplace = 53 THEN '赫哲族'
        WHEN a.nativeplace = 54 THEN '门巴族'
        WHEN a.nativeplace = 55 THEN '珞巴族'
        WHEN a.nativeplace = 56 THEN '基诺族'
        WHEN a.nativeplace = 57 THEN '其他'
        WHEN a.nativeplace = 58 THEN '外国血统中国籍人士'
        ELSE ''
    END AS nation,
    CASE
        WHEN a.marital_status = 01 THEN '已婚'
        WHEN a.marital_status = 02 THEN '未婚'
        WHEN a.marital_status = 03 THEN '丧偶'
        WHEN a.marital_status = 04 THEN '离异'
        ELSE ''
    END AS marriage,
    CASE
        WHEN a.account_nature = 01 THEN '城镇'
        WHEN a.account_nature = 02 THEN '农村'
        WHEN a.account_nature = 03 THEN '其他'
        ELSE ''
    END AS registered_residence,
    a.account_address,
    CASE
        WHEN a.educational_background = 01 THEN '硕士及以上'
        WHEN a.educational_background = 02 THEN '本科'
        WHEN a.educational_background = 03 THEN '大专'
        WHEN a.educational_background = 04 THEN '中专'
        WHEN a.educational_background = 05 THEN '高中'
        WHEN a.educational_background = 06 THEN '职高'
        WHEN a.educational_background = 07 THEN '中技'
        WHEN a.educational_background = 08 THEN '初中及以下'
        ELSE ''
    END AS education,
    CASE
        WHEN a.political_status = 01 THEN '共产党员'
        WHEN a.political_status = 02 THEN '民主党派'
        WHEN a.political_status = 03 THEN '共青团员'
        WHEN a.political_status = 04 THEN '其他'
        WHEN a.political_status = 05 THEN '群众'
        ELSE ''
    END AS face,
    CASE
        WHEN a.birthplace = 01 THEN '北京市'
        WHEN a.birthplace = 02 THEN '天津市'
        WHEN a.birthplace = 03 THEN '河北省'
        WHEN a.birthplace = 04 THEN '山西省'
        WHEN a.birthplace = 05 THEN '内蒙古自治区'
        WHEN a.birthplace = 06 THEN '辽宁省'
        WHEN a.birthplace = 07 THEN '吉林省'
        WHEN a.birthplace = 08 THEN '黑龙江省'
        WHEN a.birthplace = 09 THEN '上海市'
        WHEN a.birthplace = 10 THEN '江苏省'
        WHEN a.birthplace = 11 THEN '浙江省'
        WHEN a.birthplace = 12 THEN '安徽省'
        WHEN a.birthplace = 13 THEN '福建省'
        WHEN a.birthplace = 14 THEN '江西省'
        WHEN a.birthplace = 15 THEN '山东省'
        WHEN a.birthplace = 16 THEN '湖北省'
        WHEN a.birthplace = 17 THEN '湖南省'
        WHEN a.birthplace = 18 THEN '广东省'
        WHEN a.birthplace = 19 THEN '广西壮族自治区'
        WHEN a.birthplace = 20 THEN '四川省'
        WHEN a.birthplace = 21 THEN '贵州省'
        WHEN a.birthplace = 22 THEN '云南省'
        WHEN a.birthplace = 23 THEN '西藏自治区'
        WHEN a.birthplace = 24 THEN '陕西省'
        WHEN a.birthplace = 25 THEN '甘肃省'
        WHEN a.birthplace = 26 THEN '青海省'
        WHEN a.birthplace = 27 THEN '宁夏回族自治区'
        WHEN a.birthplace = 28 THEN '新疆维吾尔自治区'
        WHEN a.birthplace = 29 THEN '台湾省'
        WHEN a.birthplace = 30 THEN '香港特别行政区'
        WHEN a.birthplace = 31 THEN '澳门特别行政区'
        WHEN a.birthplace = 32 THEN '海南省'
        WHEN a.birthplace = 33 THEN '河南省'
        WHEN a.birthplace = 34 THEN '重庆市'
        ELSE 0
    END AS birthplace,
    a.phone_number,
    a.urgent_contact,
    a.urgent_number,
    IF(c.wage_type = 01, '时薪', '') AS pay_way,
    c.name AS paid_staff,
    c.pay_bank,
    c.cities_account,
    c.bank_name,
    c.bank_account,
    a.health_certificate,
    a.health_certificate_date,
    IFNULL(c.current_wage, '') AS current_wage,
    d.labor_mode,
    e.insured_place
FROM
    (
    
    SELECT
			hrb.e_id,
            hrb.bind_sid,
                hrb.psncode,
                hrb.name,
                hrb.id_number,
                hrb.sex,
                if(hrb.birthday<0,DATE(DATE_ADD(FROM_UNIXTIME(0), INTERVAL birthday SECOND)),FROM_UNIXTIME(hrb.birthday, '%Y-%m-%d')) AS birthday,
                FROM_UNIXTIME(hrj.entry_date, '%Y-%m-%d') AS entry_date,
                hrb.nativeplace,
                hrb.marital_status,
                hrb.account_nature,
                hrb.account_address,
                hrb.educational_background,
                hrb.political_status,
                hrb.birthplace,
                hrb.phone_number,
                hrb.urgent_contact,
                hrb.urgent_number,
                hrj.health_certificate,
                FROM_UNIXTIME(hrj.health_certificate_date, '%Y-%m-%d') AS health_certificate_date,
        date(FROM_UNIXTIME(dismiss.effect_date))
        FROM
            erp.hr_jobinfo hrj
            LEFT JOIN erp.hr_basicinfo hrb ON hrj.psncode = hrb.psncode
        left join erp.hr_dimissioninfo dismiss on hrj.psncode=dismiss.psncode
        WHERE
            hrb.bind_sid in ('CN769010')
		and hrb.pk_psncl in ('01','02','03')
        and if(dismiss.psncode is not null,date(FROM_UNIXTIME(dismiss.effect_date))>='2017-07-17',1=1)
        GROUP BY hrb.psncode
        
        
        
    ) AS a
    LEFT JOIN
    (
        SELECT
        
            j.e_id,j.name,j.psncode,d.name AS type_name
        FROM
            erp.hr_jobinfo j
            JOIN erp.taxonomy_term_data d ON j.position_name = d.tid
    ) AS b ON a.e_id = b.e_id
    LEFT JOIN
    (
    
    
        SELECT
            w.e_id,
            w.name,
            w.psncode,
            w.wage_type,
            d.name AS pay_bank,
            w.cities_account,
            w.bank_name,
            w.bank_account,
            w.current_wage
        FROM
            erp.hr_wageinfo w
            LEFT JOIN erp.taxonomy_term_data d ON w.payroll_bank = d.tid
    ) AS c ON a.e_id = c.e_id
    LEFT JOIN
    (
        SELECT
           j.e_id,j.name, j.psncode,d.name AS labor_mode
        FROM
            erp.hr_jobinfo j
        JOIN erp.taxonomy_term_data d ON j.job_type = d.tid
    ) AS d ON a.e_id = d.e_id
    LEFT JOIN
    (
        SELECT
            b.e_id,b.name,b.psncode,d.name AS insured_place
        FROM
            erp.hr_basicinfo b
            JOIN erp.taxonomy_term_data d ON b.social_security_address = d.tid
    ) AS e ON a.e_id = e.e_id
    left join
    (
        select
            store_info.representative_id,
            store_info.representative_name,
            store_info.sid,
            store_info.sname,
            store_info.dudao_id,
            market.shichang,
            market.yingyun,
            market.dudao
        from
        (SELECT
            representative_id,
            representative_name,
            rcs.sid,
            rcs.sname,
            rcs.store_market as dudao_id
        FROM
            de.reporting_cache_store rcs
        where rcs.sid in ('CN769010')
        ) store_info
        left join
                (
                     select
                        rcst3.parent_id as shicahng_id,
                        ifnull(rcst4.name,'') as shichang,
                        rcst1.parent_id as yingyun_id,
                        rcst2.name as yingyun,
                        rcst1.tid,
                        rcst1.name as dudao
                    from de.reporting_cache_store_taxonomy rcst1
                    join de.reporting_cache_store_taxonomy rcst2 on rcst1.parent_id = rcst2.tid
                    join de.reporting_cache_store_taxonomy rcst3 on rcst2.parent_id = rcst3.tid
                    left join
                    de.reporting_cache_store_taxonomy rcst4 on rcst4.tid = rcst3.parent_id
                    left join
                    de.reporting_cache_store_taxonomy rcst5 on rcst5.tid = rcst4.parent_id
                    where rcst1.category_name = 'market'
                ) as market on store_info.dudao_id = market.tid
    ) as  store_base_info on store_base_info.sid = a.bind_sid
WHERE
    entry_date <= '2017-07-17'  #and birthday is null 
ORDER BY entry_date ASC