USE [SUSUSHISHI]
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
