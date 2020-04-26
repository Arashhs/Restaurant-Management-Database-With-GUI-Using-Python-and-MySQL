-- Checking phone numbers

DELIMITER $$

CREATE TRIGGER check_address_phone
BEFORE INSERT
ON address
FOR EACH ROW
BEGIN
  IF (length(NEW.fphone) <> 10) THEN -- Abort when trying to insert this record
      	CALL phone_number_not_valid; -- raise an error to prevent insertion to the table
  END IF;
END
$$


CREATE TRIGGER check_courier_phone
BEFORE INSERT
ON courier
FOR EACH ROW
BEGIN
  IF ((length(NEW.cphone) <> 10) OR not(CAST(NEW.cphone AS CHAR(10)) like '9%')) THEN -- Abort when trying to insert this record
      	CALL phone_number_not_valid; -- raise an error to prevent insertion to the table
  END IF;
END
$$


CREATE TRIGGER check_customer_phone
BEFORE INSERT
ON customer
FOR EACH ROW
BEGIN
  IF ((length(NEW.cphone) <> 10) OR not(CAST(NEW.cphone AS CHAR(10)) like '9%')) THEN -- Abort when trying to insert this record
      	CALL phone_number_not_valid; -- raise an error to prevent insertion to the table
  END IF;
END
$$


-- Triggers for logs

-- menu logs

DELIMITER $$

CREATE TRIGGER ins_menuLog
AFTER insert
ON menu
FOR EACH ROW
BEGIN
    INSERT INTO menu_log VALUES(Now(), 'menu', 'insert', NEW.foodName, NEW.price, new.start, new.end);
END
$$


DELIMITER $$

CREATE TRIGGER update_menuLog
before update
ON menu
FOR EACH ROW
BEGIN
    INSERT INTO menu_log VALUES(Now(), 'menu', 'update', OLD.foodName, OLD.price, OLD.start, OLD.end);
END
$$


DELIMITER $$

CREATE TRIGGER del_menuLog
before delete
ON menu
FOR EACH ROW
BEGIN
    INSERT INTO menu_log VALUES(Now(), 'menu', 'delete', OLD.foodName, OLD.price, OLD.start, OLD.end);
END
$$


-- customer logs

DELIMITER $$

CREATE TRIGGER ins_customerLog
AFTER insert
ON customer
FOR EACH ROW
BEGIN
    INSERT INTO customer_log VALUES(Now(), 'customer', 'insert', NEW.CID, NEW.FName, NEW.LName, NEW.NID, NEW.cphone, NEW.age);
END
$$


DELIMITER $$

CREATE TRIGGER update_customerLog
before update
ON customer
FOR EACH ROW
BEGIN
    INSERT INTO customer_log VALUES(Now(), 'customer', 'update', OLD.CID, OLD.FName, OLD.LName, OLD.NID, OLD.cphone, OLD.age);
END
$$


DELIMITER $$

CREATE TRIGGER del_customerLog
before delete
ON customer
FOR EACH ROW
BEGIN
    INSERT INTO customer_log VALUES(Now(), 'customer', 'delete', OLD.CID, OLD.FName, OLD.LName, OLD.NID, OLD.cphone, OLD.age);
END
$$


-- address logs

DELIMITER $$

CREATE TRIGGER ins_adressLog
AFTER insert
ON address
FOR EACH ROW
BEGIN
    INSERT INTO address_log VALUES(Now(), 'address', 'insert', NEW.AID, NEW.CID, NEW.name, NEW.address, NEW.fphone);
END
$$


DELIMITER $$

CREATE TRIGGER update_addressLog
before update
ON address
FOR EACH ROW
BEGIN
    INSERT INTO address_log VALUES(Now(), 'address', 'update', OLD.AID, OLD.CID, OLD.name, OLD.address, OLD.fphone);
END
$$


DELIMITER $$

CREATE TRIGGER del_addressLog
before delete
ON address
FOR EACH ROW
BEGIN
    INSERT INTO address_log VALUES(Now(), 'address', 'delete', OLD.AID, OLD.CID, OLD.name, OLD.address, OLD.fphone);
END
$$


-- courier logs

DELIMITER $$

CREATE TRIGGER ins_courierLog
AFTER insert
ON courier
FOR EACH ROW
BEGIN
    INSERT INTO courier_log VALUES(Now(), 'courier', 'insert', NEW.CNID, NEW.CID, NEW.CFName, NEW.CLName, NEW.cphone);
END
$$


DELIMITER $$

CREATE TRIGGER update_courierLog
before update
ON courier
FOR EACH ROW
BEGIN
    INSERT INTO courier_log VALUES(Now(), 'courier', 'update', OLD.CNID, OLD.CID, OLD.CFName, OLD.CLName, OLD.cphone);
END
$$


DELIMITER $$

CREATE TRIGGER del_courierLog
before delete
ON courier
FOR EACH ROW
BEGIN
    INSERT INTO courier_log VALUES(Now(), 'courier', 'delete', OLD.CNID, OLD.CID, OLD.CFName, OLD.CLName, OLD.cphone);
END
$$


-- orders logs

DELIMITER $$

CREATE TRIGGER ins_ordersLog
AFTER insert
ON orders
FOR EACH ROW
BEGIN
    INSERT INTO orders_log VALUES(Now(), 'orders', 'insert', NEW.orderID, NEW.orderDate, NEW.customerID, NEW.AID, NEW.courierID);
END
$$


DELIMITER $$

CREATE TRIGGER update_ordersLog
before update
ON orders
FOR EACH ROW
BEGIN
    INSERT INTO orders_log VALUES(Now(), 'orders', 'update', OLD.orderID, OLD.orderDate, OLD.customerID, OLD.AID, OLD.courierID);
END
$$


DELIMITER $$

CREATE TRIGGER del_ordersLog
before delete
ON orders
FOR EACH ROW
BEGIN
    INSERT INTO orders_log VALUES(Now(), 'orders', 'delete', OLD.orderID, OLD.orderDate, OLD.customerID, OLD.AID, OLD.courierID);
END
$$


-- shop logs

DELIMITER $$

CREATE TRIGGER ins_shopLog
AFTER insert
ON shop
FOR EACH ROW
BEGIN
    INSERT INTO shop_log VALUES(Now(), 'shop', 'insert', NEW.SID, NEW.SName, NEW.status);
END
$$


DELIMITER $$

CREATE TRIGGER update_shopLog
before update
ON shop
FOR EACH ROW
BEGIN
    INSERT INTO shop_log VALUES(Now(), 'shop', 'update', OLD.SID, OLD.SName, OLD.status);
END
$$


DELIMITER $$

CREATE TRIGGER del_shopLog
before delete
ON shop
FOR EACH ROW
BEGIN
    INSERT INTO shop_log VALUES(Now(), 'shop', 'delete', OLD.SID, OLD.SName, OLD.status);
END
$$


-- shopItem logs

DELIMITER $$

CREATE TRIGGER ins_shopItemLog
AFTER insert
ON shopItem
FOR EACH ROW
BEGIN
    INSERT INTO shopItem_log VALUES(Now(), 'shopItem', 'insert', NEW.SID, NEW.IID, NEW.IName, NEW.Iprice, NEW.start, NEW.end);
END
$$


DELIMITER $$

CREATE TRIGGER update_shopItemLog
before update
ON shopItem
FOR EACH ROW
BEGIN
    INSERT INTO shopItem_log VALUES(Now(), 'shopItem', 'update', OLD.SID, OLD.IID, OLD.IName, OLD.Iprice, OLD.start, OLD.end);
END
$$


DELIMITER $$

CREATE TRIGGER del_shopItemLog
before delete
ON shopItem
FOR EACH ROW
BEGIN
    INSERT INTO shopItem_log VALUES(Now(), 'shopItem', 'delete', OLD.SID, OLD.IID, OLD.IName, OLD.Iprice, OLD.start, OLD.end);
END
$$




-- shopOrder logs

DELIMITER $$

CREATE TRIGGER ins_shopOrderLog
AFTER insert
ON shopOrder
FOR EACH ROW
BEGIN
    INSERT INTO shopOrder_log VALUES(Now(), 'shopOrder', 'insert', NEW.orderID, new.SID, new.orderDate);
END
$$


DELIMITER $$

CREATE TRIGGER update_shopOrderLog
before update
ON shopOrder
FOR EACH ROW
BEGIN
    INSERT INTO shopOrder_log VALUES(Now(), 'shopOrder', 'update', OLD.orderID, OLD.SID, OLD.orderDate);
END
$$


DELIMITER $$

CREATE TRIGGER del_shopOrderLog
before delete
ON shopOrder
FOR EACH ROW
BEGIN
    INSERT INTO shopOrder_log VALUES(Now(), 'shopOrder', 'delete', OLD.orderID, OLD.SID, OLD.orderDate);
END
$$


-- order_menu logs

DELIMITER $$

CREATE TRIGGER ins_order_menuLog
AFTER insert
ON order_menu
FOR EACH ROW
BEGIN
    INSERT INTO order_menu_log VALUES(Now(), 'order_menu', 'insert', NEW.orderID, NEW.foodName, NEW.price, NEW.unit);
END
$$


DELIMITER $$

CREATE TRIGGER update_order_menuLog
before update
ON order_menu
FOR EACH ROW
BEGIN
    INSERT INTO order_menu_log VALUES(Now(), 'order_menu', 'update', OLD.orderID, OLD.foodName, OLD.price, OLD.unit);
END
$$


DELIMITER $$

CREATE TRIGGER del_order_menuLog
before delete
ON order_menu
FOR EACH ROW
BEGIN
    INSERT INTO order_menu_log VALUES(Now(), 'order_menu', 'delete', OLD.orderID, OLD.foodName, OLD.price, OLD.unit);
END
$$


-- shoporder_items logs

DELIMITER $$

CREATE TRIGGER ins_shoporder_itemsLog
AFTER insert
ON shoporder_items
FOR EACH ROW
BEGIN
    INSERT INTO shoporder_items_log VALUES(Now(), 'shoporder_items', 'insert', NEW.orderID, NEW.SID, NEW.IID, NEW.Iprice, NEW.unit);
END
$$


DELIMITER $$

CREATE TRIGGER update_shoporder_itemsLog
before update
ON shoporder_items
FOR EACH ROW
BEGIN
    INSERT INTO shoporder_items_log VALUES(Now(), 'shoporder_items', 'update', OLD.orderID, OLD.SID, OLD.IID, OLD.Iprice, OLD.unit);
END
$$


DELIMITER $$

CREATE TRIGGER del_shoporder_itemsLog
before delete
ON shoporder_items
FOR EACH ROW
BEGIN
    INSERT INTO shoporder_items_log VALUES(Now(), 'shoporder_items', 'delete', OLD.orderID, OLD.SID, OLD.IID, OLD.Iprice, OLD.unit);
END
$$



-- Stored Procedure to delete logs remaining more than 3 days in the tables

DELIMITER $$

CREATE PROCEDURE refreshLogs()
BEGIN
    delete from address_log
        where date (now()) - date (logTime) > 3;
    delete from courier_log
        where date (now()) - date (logTime) > 3;
    delete from customer_log
        where date (now()) - date (logTime) > 3;
    delete from menu_log
        where date (now()) - date (logTime) > 3;
    delete from order_menu_log
        where date (now()) - date (logTime) > 3;
    delete from orders_log
        where date (now()) - date (logTime) > 3;
    delete from shop_log
        where date (now()) - date (logTime) > 3;
    delete from shoporder_items_log
        where date (now()) - date (logTime) > 3;
    delete from shoporder_log
        where date (now()) - date (logTime) > 3;
    delete from shoporder_items_log
        where date (now()) - date (logTime) > 3;

    END$$
DELIMITER ;