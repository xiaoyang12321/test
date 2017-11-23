set @start_day='2017-11-01';
set @end_day='2017-11-01';


select
  m.orderId,
  date(m.addTime) date,
  m.addTime,
  c.updateTime,,
  c.addTime complainTime,
  m.storeId,
  m.storeName,
  complainText,
  complainType,
  complainOperator,
  complainTypeId,
  complainTypeFatherId,
  userPhone,
  ifnull(isDelete,2) isDelete,
  orderStatus,
  orderType,
  m.orderPlatformSource,
  now() createTime
from oc.order_complain c
right join
(
  select
    orderId,
    addTime,
    storeId,
    storeName,
    orderStatus,
    orderPlatformSource,
    orderType
  from oc.order_master
  where date(addTime) between @start_day and @end_day
  and storeId in ('CN010002') and orderSource = 'gfs'
)m on m.orderId = c.orderId