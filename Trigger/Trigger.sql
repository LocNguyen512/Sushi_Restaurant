﻿USE [SUSUSHISHI]
GO 
---------------------------------------- TRIGGER CHO BẢNG ACCOUNT ----------------------------------------
CREATE OR ALTER TRIGGER TRG_ACCOUNT_VALIDITY
ON ACCOUNT
FOR INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra cả EMPLOYEE_ID và CUSTOMER_ID không được đồng thời cùng Có giá trị
    IF EXISTS (
        SELECT *
        FROM INSERTED
        WHERE EMPLOYEE_ID IS NOT NULL AND CUSTOMER_ID IS NOT NULL
    )
    BEGIN
        RAISERROR('EMPLOYEE_ID và CUSTOMER_ID không thể cùng tồn tại.', 16,1)
    END

    -- Kiểm tra nếu cả EMPLOYEE_ID và CUSTOMER_ID đều NULL thì ROLE phải là "Quản lý công ty"
    IF EXISTS (
        SELECT *
        FROM INSERTED
        WHERE EMPLOYEE_ID IS NULL AND CUSTOMER_ID IS NULL AND ROLE NOT IN ( N'Quản lý công ty')
    )
    BEGIN
		RAISERROR('Nếu EMPLOYEE_ID và CUSTOMER_ID đều trống, ROLE phải là "Quản lý công ty".', 16,1)
    END

    -- Kiểm tra ROLE phải hợp lệ (VÌ ROLE LÚC INSERT CÓ THỂ ĐỂ NULL -> NẾU ROLE KHÁC NULL THÌ TRIGGER CHECK)
    IF EXISTS (
        SELECT *
        FROM INSERTED
        WHERE ROLE NOT IN (N'Khách hàng', N'Quản lý chi nhánh', N'Nhân viên', N'Quản lý công ty')
    )
    BEGIN
		ROLLBACK
        RAISERROR('ROLE không hợp lệ.', 16,1)
    END
	
END

GO
---------------------------------------- TRIGGER CHO BẢNG EMPLOYEE ----------------------------------------
CREATE OR ALTER TRIGGER TRG_EMPLOYEE_VALIDITY
ON EMPLOYEE
FOR INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra tuổi của nhân viên (>= 18 và <= 55)
    IF EXISTS (
        SELECT *
        FROM INSERTED
        WHERE DATEDIFF(YEAR, DATE_OF_BIRTH, GETDATE()) < 18
           OR DATEDIFF(YEAR, DATE_OF_BIRTH, GETDATE()) > 55
    )
    BEGIN
	    ROLLBACK
        RAISERROR('Tuổi của nhân viên phải từ 18 đến 55.', 16, 1);
    END

    -- Kiểm tra start_date >= 18 năm từ date_of_birth
    IF EXISTS (
        SELECT *
        FROM INSERTED
        WHERE DATEDIFF(YEAR, DATE_OF_BIRTH, START_DATE_WORK) < 18
		OR DATEDIFF(YEAR, DATE_OF_BIRTH, START_DATE_WORK) > 55
    )
    BEGIN
		ROLLBACK
        RAISERROR('Ngày bắt đầu làm việc phải >= 18 và <= 55 năm từ ngày sinh.', 16, 1)
    END

    -- Kiểm tra termination_date hợp lệ
    IF EXISTS (
        SELECT *
        FROM INSERTED
        WHERE TERMINATION_DATE IS NOT NULL 
          AND (TERMINATION_DATE <= START_DATE_WORK 
          OR DATEDIFF(YEAR, DATE_OF_BIRTH, COALESCE(TERMINATION_DATE, GETDATE())) > 55)
    )
    BEGIN
		ROLLBACK
        RAISERROR('Ngày kết thúc làm việc không hợp lệ.', 16, 1)
    END

    -- Kiểm tra salary cho department_name "Quản lý chi nhánh" phải lớn nhất
    IF EXISTS (
        SELECT *
        FROM INSERTED I, DEPARTMENT D 
        WHERE I.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.DEPARTMENT_NAME = N'Quản lý chi nhánh'
          AND I.SALARY < (SELECT MAX(SALARY) FROM EMPLOYEE)
    )
    BEGIN
		ROLLBACK
        RAISERROR('Lương của nhân viên thuộc "Quản lý chi nhánh" phải cao nhất.', 16, 1)
    END
END

GO
--- TRIGGER CHO BẢNG CUSTOMER
CREATE OR ALTER TRIGGER TRG_CUSTOMER_VALIDITY
ON CUSTOMER
FOR INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra EMAIL đúng định dạng
    IF EXISTS (
        SELECT *
        FROM INSERTED
        WHERE EMAIL NOT LIKE '%@gmail.com'
    )
    BEGIN
        ROLLBACK;
        RAISERROR('EMAIL không đúng định dạng đuôi @gmail.com.', 16, 1);
    END;
END;
GO
create trigger trg_membership_card
on MEMBERSHIP_CARD
for insert, update
AS
begin
	if EXISTS (SELECT* FROM INSERTED I WHERE (I.CARD_TYPE = N'Thẻ thành viên' AND I.POINTS NOT IN (0, 99)) OR (I.CARD_TYPE = N'Thẻ Silver' AND I.POINTS NOT IN (100, 199)) OR (I.CARD_TYPE = N'Thẻ Gold' AND I.POINTS NOT IN (200, 400)))
	BEGIN
		ROLLBACK;
		RAISERROR('Giá trị points không phù hợp với card_type', 16, 1);
	END
	IF EXISTS (SELECT* FROM INSERTED I, ORDER_ O WHERE I.CUSTOMER_ID = O.CUSTOMER_ID AND I.DATE_ISSUED > O.ORDER_DATE AND I.CARD_TYPE = N'Thẻ thành viên')
	BEGIN
		ROLLBACK;
		RAISERROR('Giá trị date_issued không hợp lệ. date_issued phải nhỏ hơn order_date của customer.', 16, 1);
	END
	IF EXISTS (SELECT* FROM INSERTED I, EMPLOYEE E WHERE I.EMPLOYEE_ID = E.EMPLOYEE_ID AND I.DATE_ISSUED NOT BETWEEN E.START_DATE_WORK AND E.TERMINATION_DATE)
	BEGIN
		ROLLBACK;
		RAISERROR('Giá trị employee_id không hợp lệ. employee_id phải làm việc tại thời điểm thẻ có hiệu lực.', 16, 1);
	END
	
	IF EXISTS (SELECT* FROM INSERTED I WHERE I.CARD_TYPE = N'Thẻ thành viên' AND I.DISCOUNT_AMOUNT <> 50000)
	BEGIN
		UPDATE MEMBERSHIP_CARD
		SET DISCOUNT_AMOUNT = 50000
		FROM INSERTED i
		WHERE I.CARD_TYPE = N'Thẻ thành viên'
	END
	IF EXISTS (SELECT* FROM INSERTED I WHERE I.CARD_TYPE = N'Thẻ Silver' AND I.DISCOUNT_AMOUNT <> 100000)
	BEGIN
		UPDATE MEMBERSHIP_CARD
		SET DISCOUNT_AMOUNT = 100000
		FROM INSERTED i
		WHERE I.CARD_TYPE = N'Thẻ Silver'
	END
	IF EXISTS (SELECT* FROM INSERTED I WHERE I.CARD_TYPE = N'Thẻ Gold' AND I.DISCOUNT_AMOUNT <> 200000)
	BEGIN
		UPDATE MEMBERSHIP_CARD
		SET DISCOUNT_AMOUNT = 200000
		FROM INSERTED i
		WHERE I.CARD_TYPE = N'Thẻ Gold'
	END
end

go
CREATE TRIGGER TRG_WORK_HISTORY
ON WORK_HISTORY
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS(SELECT* FROM INSERTED I WHERE I.BRANCH_START_DATE > I.BRANCH_END_DATE)
	BEGIN
		ROLLBACK;
			RAISERROR('Ngày không hợp lệ. Branch_start_date phải nhỏ hơn branch_end_date.', 16, 1);
	END
	DECLARE @TERMINATION_DATE DATE;
	SET @TERMINATION_DATE = (SELECT E.TERMINATION_DATE FROM EMPLOYEE E);
	IF (@TERMINATION_DATE <> NULL)
	BEGIN
		IF EXISTS(SELECT * FROM INSERTED I, EMPLOYEE E WHERE I.EMPLOYEE_ID = E.EMPLOYEE_ID AND I.BRANCH_END_DATE < E.START_DATE_WORK OR I.BRANCH_END_DATE>E.TERMINATION_DATE)
		BEGIN
			ROLLBACK;
			RAISERROR('Ngày không hợp lệ.', 16, 1);
		END
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT * FROM INSERTED I, EMPLOYEE E WHERE I.EMPLOYEE_ID = E.EMPLOYEE_ID AND I.BRANCH_END_DATE < E.START_DATE_WORK)
		BEGIN
			ROLLBACK;
			RAISERROR('Ngày không hợp lệ.', 16, 1);
		END
	END
END
go

CREATE TRIGGER TRG_ORDER
ON ORDER_
FOR INSERT, UPDATE
AS
BEGIN
	--đặt hàng khi chi nhánh đóng cửa
	IF EXISTS(SELECT * FROM INSERTED I, RESTAURANT_BRANCH RB WHERE I.BRANCH_ID = RB.BRANCH_ID AND I.ORDER_TIME NOT BETWEEN RB.OPEN_TIME AND RB.CLOSE_TIME)
	BEGIN
		ROLLBACK;
		RAISERROR('Thời gian đặt hàng không hợp lệ.', 16, 1);
	END
	--đặt hàng trước khi có thẻ thành viên
	IF EXISTS(SELECT * FROM INSERTED I, MEMBERSHIP_CARD MC WHERE I.CUSTOMER_ID = MC.CUSTOMER_ID AND I.ORDER_DATE < MC.DATE_ISSUED AND MC.CARD_TYPE = N'Thẻ thành viên')
	BEGIN
		ROLLBACK;
		RAISERROR('Ngày đặt hàng không hợp lệ.', 16, 1);
	END
END

