-- Entities

CREATE table Menu ( foodName varchar(50)
                  , price decimal(10, 2) not null
                  , start DATE not null
                  , end date not null
                  , primary key (foodName, start)
                  , key (foodName, price));


create table customer ( CID INT primary key auto_increment
                      , FName varchar(20) not null
                      , LName varchar(20) not null
                      , NID decimal(10,0) not null
                      , cphone decimal(11,0) not null
                      , age INT(2) not null
                      );

create table address ( AID INT auto_increment primary key
                     , CID INT not null
                     , name varchar(20) not null
                     , address varchar(255) not null
                     , fphone decimal(11,0)
                     , foreign key (CID) references customer(CID));

create table courier ( CNID decimal(10,0) primary key
                     , CID INT auto_increment
                     , CFName varchar(20) not null
                     , CLName varchar(20) not null
                     , cphone decimal(11,0) not null
                     , key (CID));


create table orders ( orderID INT primary key auto_increment
                    , orderDate datetime not null
                    , customerID INT
                    , AID INT
                    , courierID INT
                    , foreign key (customerID) references customer(CID)
                    , foreign key (AID) references address(AID)
                    , foreign key (courierID) references courier(CID));

create table shop ( SID INT primary key auto_increment
                  , SName varchar(255) not null
                  , status ENUM('active', 'inactive'));

create table shopItem( SID INT
                     , IID INT
                     , IName varchar(50) not null
                     , Iprice decimal(10,2)
                     , start date not null
                     , end date not null
                     , primary key (SID, IID, Iprice)
                     , foreign key (SID) references shop(SID));

create table shopOrder( orderID INT primary key auto_increment
                      , SID INT not null
                      , orderDate date not null
                      , foreign key (SID) references shop(SID));



-- Relations

create table order_menu ( orderID INT
                        , foodName varchar(50)
                        , price decimal(10, 2)
                        , unit int default 1
                        , primary key (orderID, foodName, price)
                        , foreign key (orderID) references orders(orderID)
                        , foreign key (foodName, price) references menu(foodName, price));


create table shopOrder_Items ( orderID INT
                             , SID INT
                             , IID INT
                             , Iprice decimal(10,2)
                             , unit int default 1
                             , primary key (orderID, SID, IID, Iprice)
                             , foreign key (orderID) references shopOrder(orderID)
                             , foreign key (SID, IID, Iprice) references shopItem(SID, IID, Iprice));



-- Log tables

-- Entities

CREATE table Menu_log (
                    logTime datetime
                  , logTable varchar(20)
                  , logOperation enum('insert', 'delete', 'update')
                  , foodName varchar(50)
                  , price decimal(10, 2) not null
                  , start DATE not null
                  , end date not null);


create table customer_log (
                        logTime datetime
                      , logTable varchar(20)
                      , logOperation enum('insert', 'delete', 'update')
                      , CID INT
                      , FName varchar(20) not null
                      , LName varchar(20) not null
                      , NID decimal(10,0) not null
                      , cphone decimal(11,0) not null
                      , age INT(2) not null
                      );

create table address_log (
                        logTime datetime
                      , logTable varchar(20)
                      , logOperation enum('insert', 'delete', 'update')
                     , AID INT
                     , CID INT not null
                     , name varchar(20) not null
                     , address varchar(255) not null
                     , fphone decimal(11,0));

create table courier_log (
                        logTime datetime
                      , logTable varchar(20)
                      , logOperation enum('insert', 'delete', 'update')
                    , CNID decimal(10,0)
                     , CID INT
                     , CFName varchar(20) not null
                     , CLName varchar(20) not null
                     , cphone decimal(11,0) not null);


create table orders_log (
                        logTime datetime
                      , logTable varchar(20)
                      , logOperation enum('insert', 'delete', 'update')
                    , orderID INT
                    , orderDate datetime not null
                    , customerID INT
                    , AID INT
                    , courierID INT);

create table shop_log (
                        logTime datetime
                      , logTable varchar(20)
                      , logOperation enum('insert', 'delete', 'update')
                    , SID INT
                  , SName varchar(255) not null
                  , status ENUM('active', 'inactive'));

create table shopItem_log (
                        logTime datetime
                      , logTable varchar(20)
                      , logOperation enum('insert', 'delete', 'update')
                     , SID INT
                     , IID INT
                     , IName varchar(50) not null
                     , Iprice decimal(10,2)
                     , start date not null
                     , end date not null);

create table shopOrder_log (
                        logTime datetime
                      , logTable varchar(20)
                      , logOperation enum('insert', 'delete', 'update')
                      , orderID INT
                      , SID INT not null
                      , orderDate date);



-- Relations

create table order_menu_log (
                            logTime datetime
                      , logTable varchar(20)
                      , logOperation enum('insert', 'delete', 'update')
                        , orderID INT
                        , foodName varchar(50)
                        , price decimal(10, 2)
                        , unit int default 1);


create table shopOrder_Items_log (
                                logTime datetime
                         , logTable varchar(20)
                         , logOperation enum('insert', 'delete', 'update')
                            , orderID INT
                             , SID INT
                             , IID INT
                             , Iprice decimal(10,2)
                             , unit int default 1);

