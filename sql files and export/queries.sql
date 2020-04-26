
-- Total sales
select om.foodName, sum(om.unit) as total_sold, avg(om.price) as unit_price, date (o.orderDate) as on_date
from order_menu om, orders o
where om.orderID = o.orderID
group by om.foodName, date(o.orderDate)
order by on_date;


-- Income for each menu-order
select o.orderID, sum(om.unit * om.price) as total_price, date(orderDate) as on_Date from order_menu om, orders o where om.orderID = o.orderID group by o.orderID;

-- Total income for each day
select on_date, sum(total_price) as total_income from
(select o.orderID, sum(om.unit * om.price) as total_price, date(orderDate) as on_Date from order_menu om, orders o where om.orderID = o.orderID group by o.orderID) as day_order
group by on_date;

-- Order cost for each shop-order
select so.orderID, sum(soi.unit * soi.Iprice) as order_cost, date(orderDate) as on_Date
from shoporder so, shopOrder_Items soi
where so.orderID = soi.orderID
group by so.orderID;



-- Total spent for each day

select on_date, sum(total_price) as total_spent from
(
select so.orderID, sum(soi.unit * soi.Iprice) as total_price, date(orderDate) as on_Date
from shoporder so, shopOrder_Items soi
where so.orderID = soi.orderID
group by so.orderID ) as day_spent
group by on_date;


-- Profit for each day

select spent.on_Date, total_income, total_spent, (total_income - total_spent) as profit
from (select on_date, sum(total_price) as total_income from
(select o.orderID, sum(om.unit * om.price) as total_price, date(orderDate) as on_Date from order_menu om, orders o where om.orderID = o.orderID group by o.orderID) as day_order
group by on_date) as incomes
, (select on_date, sum(total_price) as total_spent from
(
select so.orderID, sum(soi.unit * soi.Iprice) as total_price, date(orderDate) as on_Date
from shoporder so, shopOrder_Items soi
where so.orderID = soi.orderID
group by so.orderID ) as day_spent
group by on_date) as spent
where incomes.on_Date = spent.on_Date;

-- Ordered foods for each user

select c.CID, c.FName, c.LName, om.foodName, sum(om.unit) as times_ordered from order_menu om, orders o, customer c
where om.orderID = o.orderID and o.customerID = c.CID
group by cid, foodName;


-- Food most ordered for each user

select  user_orders.CID, FName, LName, foodName as most_ordered_food, times_ordered
from (
    select max(times_ordered) as max_ordered_times, CID
    from (
        select c.CID, c.FName, c.LName, om.foodName, sum(om.unit) as times_ordered from order_menu om, orders o, customer c
        where om.orderID = o.orderID and o.customerID = c.CID
        group by cid, foodName) as user_orders
        group by CID
    ) as user_orders,
     (
    select c.CID, c.FName, c.LName, om.foodName, sum(om.unit) as times_ordered from order_menu om, orders o, customer c
    where om.orderID = o.orderID and o.customerID = c.CID
    group by cid, foodName
         ) as ordered
where ordered.times_ordered = max_ordered_times and ordered.CID = user_orders.CID;
