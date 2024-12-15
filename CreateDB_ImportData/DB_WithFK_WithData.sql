﻿/*
DROP DATABASE SUSUSHISHI
GO
CREATE DATABASE SUSUSHISHI
GO
*/
USE SUSUSHISHI
GO


-- 1.Tạo bảng MEMBERSHIP_CARD
CREATE TABLE MEMBERSHIP_CARD (
    CARD_ID CHAR(7) NOT NULL,
	CARD_TYPE NVARCHAR(15) CHECK(CARD_TYPE IN (N'Thẻ thành viên',N'Thẻ Silver',N'Thẻ Gold')),
    CUSTOMER_ID CHAR(7),
	DATE_ISSUED DATE,
	EMPLOYEE_ID CHAR(7),
	POINTS INT DEFAULT 0,
    CARD_STATUS NVARCHAR(10) CHECK(CARD_STATUS IN ('Active','Inactive')),
	DISCOUNT_AMOUNT INT,
	CONSTRAINT PK_MEMBERSHIP_CARD PRIMARY KEY (CARD_ID)
)
GO

-- 2. Tạo bảng EMPLOYEE
CREATE TABLE EMPLOYEE (
    EMPLOYEE_ID CHAR(7) NOT NULL,
    FULL_NAME NVARCHAR(100) NOT NULL,
	DATE_OF_BIRTH DATE,
	GENDER NCHAR(3) CHECK(GENDER IN (N'Nam',N'Nữ')),
    SALARY INT CHECK (SALARY > 0),
    START_DATE_WORK DATE,
	TERMINATION_DATE DATE,
    DEPARTMENT_ID CHAR(4),
    CONSTRAINT PK_EMPLOYEE PRIMARY KEY (EMPLOYEE_ID)
)
GO

-- 3. Tạo bảng DEPARTMENT
CREATE TABLE DEPARTMENT (
    DEPARTMENT_ID CHAR(4) NOT NULL,
    DEPARTMENT_NAME NVARCHAR(100),
	BRANCH_ID CHAR(4),
    CONSTRAINT PK_DEPARTMENT PRIMARY KEY (DEPARTMENT_ID)
)
GO

-- 4. Tạo bảng WORK_HISTORY
CREATE TABLE WORK_HISTORY (
	BRANCH_START_DATE DATE NOT NULL,
	BRANCH_END_DATE DATE,
	EMPLOYEE_ID CHAR(7) NOT NULL,
    BRANCH_ID CHAR(4),
	CONSTRAINT PK_WORK_HISTORY PRIMARY KEY (BRANCH_START_DATE, EMPLOYEE_ID)
)
GO

-- 5. Tạo bảng RESTAURANT_BRANCH
CREATE TABLE RESTAURANT_BRANCH (
    BRANCH_ID CHAR(4) NOT NULL,
	BRANCH_PHONE VARCHAR(15) NOT NULL,
    BRANCH_NAME NVARCHAR(100) NOT NULL,
	BRANCH_ADDRESS NVARCHAR(255),
	OPEN_TIME TIME,
	CLOSE_TIME TIME,
	CAR_PARK BIT,
	MOTORBIKE_PARK BIT,
	MANAGER_ID CHAR(7),
    AREA_NAME NVARCHAR(50),
    CONSTRAINT PK_RESTAURANT_BRANCH PRIMARY KEY (BRANCH_ID)
)
GO

-- 6. Tạo bảng DISH_AVAILABLE
CREATE TABLE DISH_AVAILABLE (
    BRANCH_ID CHAR(4) NOT NULL,
    DISH_ID CHAR(4) NOT NULL,
    IS_AVAILABLE BIT,
    IS_DELIVERABLE BIT,
	CONSTRAINT PK_DISH_AVAILABLE PRIMARY KEY (BRANCH_ID, DISH_ID)
)
GO

-- 7. Tạo bảng DISH
CREATE TABLE DISH (
    DISH_ID CHAR(4) NOT NULL,
    DISH_NAME NVARCHAR(100),
	CATEGORY_NAME NVARCHAR(100) NOT NULL,
    DISH_PRICE DECIMAL(10,2) CHECK(DISH_PRICE > 0),
    CONSTRAINT PK_DISH PRIMARY KEY (DISH_ID)
)
GO

-- 8. Tạo bảng ONLINE_ACCESS_HISTORY
CREATE TABLE ONLINE_ACCESS_HISTORY (
    DATE_ACCESSED DATETIME NOT NULL,
	TIME_ACCESSED DATETIME NOT NULL,
    CUSTOMER_ID CHAR(7) NOT NULL,
    SESSION_DURATION INT,
	CONSTRAINT PK_ONLINE_ACCESS_HISTORY PRIMARY KEY (DATE_ACCESSED, TIME_ACCESSED, CUSTOMER_ID)
)
GO

-- 9. Tạo bảng BRANCH_RATING
CREATE TABLE BRANCH_RATING (
    RATING_ID CHAR(7) NOT NULL,
	SERVICE_RATING TINYINT CHECK (SERVICE_RATING BETWEEN 0 AND 5),
	LOCATION_RATING TINYINT CHECK (LOCATION_RATING BETWEEN 0 AND 5),
	PRICE_RATING TINYINT CHECK (PRICE_RATING BETWEEN 0 AND 5),
	DISH_QUALITY_RATING TINYINT CHECK (DISH_QUALITY_RATING BETWEEN 0 AND 5),
	ENVIRONMENT_RATING TINYINT CHECK (ENVIRONMENT_RATING BETWEEN 0 AND 5),
	COMMENTS NVARCHAR(200),
    BRANCH_ID CHAR(4),
    RATING_DATE DATETIME,
	INVOICE_ID CHAR(7),
    CONSTRAINT PK_BRANCH_RATING PRIMARY KEY (RATING_ID)
)
GO

-- 10. Tạo bảng INVOICE
CREATE TABLE INVOICE (
    INVOICE_ID CHAR(7) NOT NULL,
    FINAL_AMOUNT INT,
	DISCOUNT_AMOUNT INT,
    ISSUE_DATE DATETIME,
	ISSUE_TIME DATETIME,
    ORDER_ID CHAR(7),
    CONSTRAINT PK_INVOICE PRIMARY KEY (INVOICE_ID)
)
GO

-- 11. Tạo bảng ORDER_DISH
CREATE TABLE ORDER_DISH (
    ORDER_ID CHAR(7) NOT NULL, 
    DISH_ID CHAR(4) NOT NULL,
    QUANTITY TINYINT CHECK (QUANTITY > 0),
    CONSTRAINT PK_ORDER_DISH PRIMARY KEY (ORDER_ID, DISH_ID)
)
GO

-- 12. Tạo bảng DELIVERY_ORDER
CREATE TABLE DELIVERY_ORDER (
    DORDER_ID CHAR(7) NOT NULL,
    TIME_DELIVERY TIME,
	DATE_DELIVERY DATE,
	CONSTRAINT PK_DELIVERY_ORDER PRIMARY KEY (DORDER_ID)
) 
GO

-- 13. Tạo bảng OFFLINE_ORDER
CREATE TABLE OFFLINE_ORDER (
    OFORDER_ID CHAR(7) NOT NULL,
	TABLE_NUMBER TINYINT,
    EMPLOYEE_ID CHAR(7),
    BRANCH_ID CHAR(4),
	EMPLYEE_RATING TINYINT CHECK(EMPLYEE_RATING BETWEEN 1 AND 5),
	CONSTRAINT PK_OFFLINE_ORDER PRIMARY KEY (OFORDER_ID)
)
GO

-- 14. Tạo bảng ONLINE_ORDER
CREATE TABLE ONLINE_ORDER (
    OORDER_ID CHAR(7) NOT NULL,
    ARRIVAL_DATE DATE,
    ARRIVAL_TIME TIME,
    TABLE_NUMBER TINYINT,
    BRANCH_ID CHAR(4),
    CUSTOMER_QUANTITY TINYINT CHECK (CUSTOMER_QUANTITY > 0), 
	CONSTRAINT PK_ONLINE_ORDER PRIMARY KEY (OORDER_ID)
)
GO

-- 15. Tạo bảng ORDER
CREATE TABLE ORDER_ (
    ORDER_ID CHAR(7) NOT NULL,
    ORDER_DATE DATETIME,
    BRANCH_ID CHAR(4),
    CUSTOMER_ID CHAR(7),
    ORDER_TYPE VARCHAR(20),
    ORDER_TIME DATETIME,
    CONSTRAINT PK_ORDER PRIMARY KEY (ORDER_ID)
)
GO

-- 16. Tạo bảng CUSTOMER
CREATE TABLE CUSTOMER (
    CUSTOMER_ID CHAR(7) NOT NULL,
    FULL_NAME NVARCHAR(100) NOT NULL,
    PHONE_NUMBER VARCHAR(15),
    EMAIL VARCHAR(50),
    IDENTITY_CARD VARCHAR(20),
    GENDER NCHAR(3) CHECK (GENDER IN (N'Nam', N'Nữ')),
    CONSTRAINT PK_CUSTOMER PRIMARY KEY (CUSTOMER_ID)
)
GO

-- 17. Tạo bảng TABLE
CREATE TABLE TABLE_ (
    TABLE_NUM TINYINT NOT NULL,
    BRANCH_ID CHAR(4) NOT NULL,
    TABLE_STATUS NVARCHAR(100),
    SEAT_AVAILABLE INT CHECK (SEAT_AVAILABLE > 0) ,
	CONSTRAINT PK_TABLE PRIMARY KEY (TABLE_NUM, BRANCH_ID)
)
GO

-- 18. Tạo bảng ACCOUNT
CREATE TABLE ACCOUNT (
    ACCOUNT_ID CHAR(4) NOT NULL,
    USERNAME NVARCHAR(50),
    PASSWORD VARCHAR(255),
    ROLE NVARCHAR(20),
	EMPLOYEE_ID CHAR(7),
    CUSTOMER_ID CHAR(7),
    CONSTRAINT PK_ACCOUNT PRIMARY KEY (ACCOUNT_ID)
)
GO


--------------------------------- Tạo khóa ngoại----------------------------------------------------
-- 1. MEMBERSHIP_CARD
ALTER TABLE MEMBERSHIP_CARD
ADD 
CONSTRAINT FK_MembershipCard_Customer FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID),
CONSTRAINT FK_MembershipCard_Employee FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID);
GO

-- 2. EMPLOYEE
ALTER TABLE EMPLOYEE
ADD 
CONSTRAINT FK_Employee_Department FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENT(DEPARTMENT_ID);
GO

-- 3. DEPARTMENT
ALTER TABLE DEPARTMENT
ADD 
CONSTRAINT FK_Department_Branch FOREIGN KEY (BRANCH_ID) REFERENCES RESTAURANT_BRANCH(BRANCH_ID);
GO

-- 4. WORK_HISTORY
ALTER TABLE WORK_HISTORY
ADD 
CONSTRAINT FK_WorkHistory_Employee FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID),
CONSTRAINT FK_WorkHistory_Branch FOREIGN KEY (BRANCH_ID) REFERENCES RESTAURANT_BRANCH(BRANCH_ID);
GO

-- 5. RESTAURANT_BRANCH
ALTER TABLE RESTAURANT_BRANCH
ADD 
CONSTRAINT FK_Branch_Manager FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID);
GO

-- 6. DISH_AVAILABLE
ALTER TABLE DISH_AVAILABLE
ADD 
CONSTRAINT FK_DishAvailable_Branch FOREIGN KEY (BRANCH_ID) REFERENCES RESTAURANT_BRANCH(BRANCH_ID),
CONSTRAINT FK_DishAvailable_Dish FOREIGN KEY (DISH_ID) REFERENCES DISH(DISH_ID);
GO

-- 7. ONLINE_ACCESS_HISTORY
ALTER TABLE ONLINE_ACCESS_HISTORY
ADD 
CONSTRAINT FK_OnlineAccessHistory_Customer FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID);
GO

-- 8. BRANCH_RATING
ALTER TABLE BRANCH_RATING
ADD 
CONSTRAINT FK_BranchRating_Branch FOREIGN KEY (BRANCH_ID) REFERENCES RESTAURANT_BRANCH(BRANCH_ID),
CONSTRAINT FK_BranchRating_Invoice FOREIGN KEY (INVOICE_ID) REFERENCES INVOICE(INVOICE_ID);
GO

-- 9. INVOICE
ALTER TABLE INVOICE
ADD 
CONSTRAINT FK_Invoice_Order FOREIGN KEY (ORDER_ID) REFERENCES ORDER_(ORDER_ID);
GO

-- 10. ORDER_DISH
ALTER TABLE ORDER_DISH
ADD 
CONSTRAINT FK_OrderDish_Order FOREIGN KEY (ORDER_ID) REFERENCES ORDER_(ORDER_ID),
CONSTRAINT FK_OrderDish_Dish FOREIGN KEY (DISH_ID) REFERENCES DISH(DISH_ID);
GO

-- 11. DELIVERY_ORDER
ALTER TABLE DELIVERY_ORDER
ADD 
CONSTRAINT FK_DeliveryOrder_Order FOREIGN KEY (DORDER_ID) REFERENCES ORDER_(ORDER_ID);
GO

-- 12. OFFLINE_ORDER
ALTER TABLE OFFLINE_ORDER
ADD 
CONSTRAINT FK_OfflineOrder_Order FOREIGN KEY (OFORDER_ID) REFERENCES ORDER_(ORDER_ID),
CONSTRAINT FK_OfflineOrder_Table FOREIGN KEY (TABLE_NUMBER, BRANCH_ID) REFERENCES TABLE_(TABLE_NUM, BRANCH_ID),
CONSTRAINT FK_OfflineOrder_Employee FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID),
CONSTRAINT FK_OfflineOrder_Branch FOREIGN KEY (BRANCH_ID) REFERENCES RESTAURANT_BRANCH(BRANCH_ID);
GO

-- 13. ONLINE_ORDER
ALTER TABLE ONLINE_ORDER
ADD 
CONSTRAINT FK_OnlineOrder_Order FOREIGN KEY (OORDER_ID) REFERENCES ORDER_(ORDER_ID),
CONSTRAINT FK_OnlineOrder_Table FOREIGN KEY (TABLE_NUMBER, BRANCH_ID) REFERENCES TABLE_(TABLE_NUM, BRANCH_ID),
CONSTRAINT FK_OnlineOrder_Branch FOREIGN KEY (BRANCH_ID) REFERENCES RESTAURANT_BRANCH(BRANCH_ID);
GO

-- 14. ORDER_
ALTER TABLE ORDER_
ADD 
CONSTRAINT FK_Order_Branch FOREIGN KEY (BRANCH_ID) REFERENCES RESTAURANT_BRANCH(BRANCH_ID),
CONSTRAINT FK_Order_Customer FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID);
GO

-- 15. TABLE_
ALTER TABLE TABLE_
ADD 
CONSTRAINT FK_Table_Branch FOREIGN KEY (BRANCH_ID) REFERENCES RESTAURANT_BRANCH(BRANCH_ID);
GO

-- 16. ACCOUNT
ALTER TABLE ACCOUNT
ADD 
CONSTRAINT FK_Account_Employee FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID),
CONSTRAINT FK_Account_Customer FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID);
GO

-------------------------------------- IMPORT DATA---------------------------------
-- 1. ACCOUNT -- 
BULK INSERT ACCOUNT
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\account_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 2. BRANCH_RATING --
BULK INSERT BRANCH_RATING
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\branch_rating_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 3. CUSTOMER --
BULK INSERT CUSTOMER
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\customer_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 4. DELIVERY_ORDER --
BULK INSERT DELIVERY_ORDER
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\delivery_order_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 5. ONLINE_ORDER --
BULK INSERT ONLINE_ORDER
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\online_order_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 6. DEPARTMENT -- 
BULK INSERT DEPARTMENT
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\department_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO
-- 7. DISH_AVAILABLE --
BULK INSERT DISH_AVAILABLE
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\dish_available_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 8. DISH --
BULK INSERT DISH
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\dish_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 9. EMPLOYEE --
BULK INSERT EMPLOYEE
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\employee_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 10. INVOICE --
BULK INSERT INVOICE
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\invoice_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 11. OFFLINE_ORDER --
BULK INSERT OFFLINE_ORDER
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\oforder_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 12. ORDER --
BULK INSERT ORDER_
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\order_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 13. ORDER_DISH --
BULK INSERT ORDER_DISH
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\order_dish_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 14. MEMBERSHIP_CARD --
BULK INSERT MEMBERSHIP_CARD
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\membership_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 15. RESTAURANT_BRANCH --
BULK INSERT RESTAURANT_BRANCH
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\restaurant_branch_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 16. TABLE_ --
BULK INSERT TABLE_
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\table_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- 17. WORK_HISTORY --
BULK INSERT WORK_HISTORY
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\work_history_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO
-- 18. ONLINE_ACCESS_HISTORY --
BULK INSERT ONLINE_ACCESS_HISTORY
FROM 'D:\KHTN\NAM3\1st_Semester\CSDLNC\18_12\online_access_history_data.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	FIRSTROW = 2,
    CODEPAGE = '65001' -- UTF-8
);
GO

