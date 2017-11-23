
use oc;
set @start_day = '2017-11-01 00:00:00';
set @end_day = '2017-11-01 23:59:59';
set @jin = '1785,1573,1575,1576,1201,1202,1415,1428,37,1536,1537,1538,1539,1566,1567,1568,1569,1570,1571,1572,38,40,42,0,307,10001,1506,309,311,971,973,975,977,979,981,983,985,1111,1113,1325,1327,1329,1331,1333,1335,1337,1343,1345,1347,1349,1490,1491,1492,1493,1494,1495,1496,1497,1498,1499,1504,1565 ,35,44,45,46,47,59,81,83,1474,1475,1476,1477,1478,1479,1480,1481,1482,1483,1484,1485,1486,91,71,1414,1509,1356,1416,1417,1418,1422,1510,1514,1519,1522,1523,1524,1200,73,75,77,1578,1579,1580,1582,1583,1697,1699,1701';
set @shou='59,73,75,77,91';
set @storeid='';

select
  m.orderId,
  storeId,
  storeName,
  date(addTime) date,
  totalAmount,
  freight,
  payAmount,
  totalAmount-freight-ifnull(jin,0)-ifnull(packing_charges,0)-ifnull(meals_charges,0) clean_s,
  totalAmount-freight-ifnull(shou,0)-ifnull(packing_charges,0)-ifnull(meals_charges,0) sale_s,
  ifnull(packing_charges,0) packing_charges,
  ifnull(meals_charges,0) meals_charges,
  orderPlatformSource,
  userName,
  userPhone,
  deliveryMan,
  deliveryManPhone,
  isChange,
  deliveryWay,
  addressName,
  ifnull(cancelOrderOperator,'') cancelOrderOperator,
  ext,
  addTime,
  bookTime,
  receiveTime,
  mealsTime,
  payTime,
  deliveryTime,
  returnTime,
  cancelTime,
  orderStatus,
  orderType,
  now() createTime
from
(
  select
    orderId,
    storeId,
    storeName,
    totalAmount,
    payAmount,
    freight,
    orderPlatformSource,
    isChange,
    deliveryWay,
    userName,
    userPhone,
    deliveryMan,
    deliveryManPhone,
    cancelOrderOperator,
    ext,
    addTime,
    bookTime,
    receiveTime,
    mealsTime,
    payTime,
    deliveryTime,
    returnTime,
    cancelTime,
    orderStatus,
    orderType
  from oc.order_master
  where storeId in (@storeid)
  and addTime between @start_day and @end_day
  and orderSource = 'gfs'
  and orderType in (0,101,102,103,104)
  union all
  (
       select
         m.orderId,
         max(m.storeId) storeId,
         max(m.storeName) storeName,
         sum(vl2.payAmount) totalAmount,
         sum(vl2.payAmount) payAmount,
         max(m.freight) freight,
         max(m.orderPlatformSource) orderPlatformSource,
         max(m.isChange) isChange,
         max(m.deliveryWay) deliveryWay,
         max(m.userName) userName,
         max(m.userPhone) userPhone,
         max(m.deliveryMan) deliveryMan,
         max(m.deliveryManPhone) deliveryManPhone,
         max(m.cancelOrderOperator) cancelOrderOperator,
         max(m.ext) ext,
         max(m.addTime) addTime,
         max(m.bookTime) bookTime,
         max(m.receiveTime) receiveTime,
         max(m.mealsTime) mealsTime,
         max(m.payTime) payTime,
         max(m.deliveryTime) deliveryTime,
         max(m.returnTime) returnTime,
         max(m.cancelTime) cancelTime,
         max(m.orderStatus) orderStatus,
         max(m.orderType) orderType
       from
       (
         select
           *
         from oc.order_master
         where addTime between @start_day and @end_day
         and storeId in (@storeid) and orderType in (105,106)
         and orderstatus = 4 and paystatus = 1 and orderSource = 'gfs'
       )m
       left join datacache.sales_voucher_list vl1 on m.orderId = vl1.orderId
       left join
       (
         select
           orderId,
           voucher,
           if(discount = 0,100,discount*10)*price payAmount
         from datacache.sales_voucher_list
         where orderType in (101,102,103,104)
       )vl2 on vl1.voucher = vl2.voucher
       left join oc.order_master m2 on m2.orderId = vl2.orderId
       where m2.orderstatus = 4
       group by m.orderId
  )
)m
left join
(
  select
    m.orderId,
    sum(if(find_in_set(discountId,@shou),d.discountAmount,0)) as shou,
    sum(if(find_in_set(discountId,@jin),d.discountAmount,0)) as jin
  from oc.order_discount d
  right join
  (
    select
      orderId
    from oc.order_master
    where storeId in (@storeid)
    and addTime between @start_day and @end_day
    and orderSource = 'gfs' and orderType = 0
  )m on m.orderId = d.orderId
  group by m.orderId
)dis on m.orderId = dis.orderId
left join
(
  select
    m.orderId,
    sum(if(basic_category_tid in ('3533'),totalPrice,0)) packing_charges,
    sum(if(basic_category_tid in ('4711'),totalPrice,0)) meals_charges
  from oc.order_detail d
  left join oc.order_master m on m.orderId = d.orderId
  right join
  (
    select sku,basic_category_tid
    from datacache.de_product
    where basic_category_tid in ('3533','4711')
  )procate on procate.sku = d.productId
  where m.addTime between @start_day and @end_day
  and m.storeId in (@storeid) and orderSource = 'gfs' and orderType = 0
  group by d.orderId
)det on m.orderId = det.orderId
left join
(
  select
    m.orderId,
    any_value(a.addressName) as addressName
  from oc.order_address a
  right join
  (
    select
      orderId
    from oc.order_master
    where storeId in (@storeid)
    and addTime between @start_day and @end_day
    and orderSource = 'gfs' and orderType = 0
  )m on a.orderId = m.orderId
  group by m.orderId
) AS oa ON m.orderId = oa.orderId




