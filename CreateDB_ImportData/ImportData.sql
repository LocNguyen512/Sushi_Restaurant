USE [SUSUSHISHI]
--------------------------------------------  IMPORT DATA  --------------------------------------------
go
-- ACCOUNT -- 

BULK INSERT ACCOUNT
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\account_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);

-- AREA -- 
BULK INSERT AREA
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\area_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- BRANCH_RATING --
BULK INSERT BRANCH_RATING
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\branch_rating_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO
-- CARD_TYPE --
insert into CARD_TYPE (TYPE, DISCOUNT_AMOUNT) values ('The thanh vien', 100000);
insert into CARD_TYPE (TYPE, DISCOUNT_AMOUNT) values ('The silver', 200000);
insert into CARD_TYPE (TYPE, DISCOUNT_AMOUNT) values ('The gold', 500000);
GO
-- CUSTOMER --
BULK INSERT CUSTOMER
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\customer_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);

GO
-- DELIVERY_ORDER --
BULK INSERT DELIVERY_ORDER
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\dorder_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO
-- DEPARTMENT -- 
BULK INSERT DEPARTMENT
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\department_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);

GO
-- MENU_CATEGORY --
INSERT INTO [dbo].[MENU_CATEGORY] ([CATEGORY_ID], [CATEGORY_NAME])
VALUES 
('C001', N'Khai vị'),
('C002', N'Sashimi combo'),
('C003', N'Nigiri'),
('C004', N'Tempura'),
('C005', N'Udon'),
('C006', N'Lẩu'),
('C007', N'Lunch set'),
('C008', N'Các món nước');
GO
-- DISH --
INSERT INTO [dbo].[DISH] ([DISH_ID], [DISH_NAME], [DISH_PRICE], [CATEGORY_ID])
VALUES
-- Khai vị
('0001', N'Trứng hấp', 50000, 'C001'),
('0002', N'Súp miso', 45000, 'C001'),
('0003', N'Súp chay', 60000, 'C001'),
('0004', N'Trứng cá hồi', 70000, 'C001'),

-- Sashimi combo
('0005', N'Sashimi tổng hợp', 150000, 'C002'),
('0006', N'Sashimi cá hồi đặc biệt', 180000, 'C002'),
('0007', N'Sashimi cá ngừ', 120000, 'C002'),

-- Nigiri
('0008', N'Cá ngừ (2 miếng)', 80000, 'C003'),
('0009', N'Cá hồi (2 miếng)', 90000, 'C003'),
('0010', N'Lươn cá hồi nướng sốt (2 miếng)', 100000, 'C003'),

-- Tempura
('0011', N'Tempura tôm', 120000, 'C004'),
('0012', N'Tempura rau', 70000, 'C004'),

-- Udon
('0013', N'Udon xào', 95000, 'C005'),
('0014', N'Udon canh', 110000, 'C005'),

-- Hotpot
('0015', N'Lẩu hải sản', 250000, 'C006'),
('0016', N'Lẩu thịt bò', 230000, 'C006'),

-- Lunch set
('0017', N'Lunch set 1', 180000, 'C007'),
('0018', N'Lunch set 2', 200000, 'C007'),

-- Các món nước
('0019', N'Nước cam', 35000, 'C008'),
('0020', N'Nước trà xanh', 30000, 'C008'),
('0021', N'Sinh tố dưa hấu', 40000, 'C008');

GO
-- DISH_AVAILABLE --
BULK INSERT DISH_AVAILABLE
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\dish_available_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO
-- EMPLOYEE --
BULK INSERT EMPLOYEE
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\employee_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO
-- INVOICE --
BULK INSERT INVOICE
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\invoice_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO
-- MEMBERSHIP_CARD --
BULK INSERT MEMBERSHIP_CARD
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\membership_card_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);

GO
-- OFFLINE_ORDER --
BULK INSERT OFFLINE_ORDER
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\oforder_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO
-- ONLINE_ACCESS_HISTORY --
BULK INSERT ONLINE_ACCESS_HISTORY
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\online_access_history_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO
-- ONLINE_ORDER --
BULK INSERT ONLINE_ORDER
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\oorder_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO
-- ORDER --
BULK INSERT dbo.[ORDER]
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\order_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO
-- ORDER_DISH --
BULK INSERT ORDER_DISH
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\order_dish_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO
-- RESTAURANT_BRANCH --
BULK INSERT RESTAURANT_BRANCH
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\restaurant_branch_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO
-- TABLE_ --
BULK INSERT TABLE_
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\table_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO
-- WORK_HISTORY --
BULK INSERT WORK_HISTORY
FROM 'D:\lhyen\HCMUS\3rd_year\HK1\CSDL_NC\Sushi_Restaurant\CreateDB_ImportData\work_history_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);