USE SUSUSHISHI
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
        ROLLBACK;
        RAISERROR('EMPLOYEE_ID và CUSTOMER_ID không thể cùng tồn tại.', 16, 1);
    END;

    -- Xác định ROLE dựa trên các điều kiện
    UPDATE ACCOUNT
    SET ROLE = 
        CASE 
            WHEN I.CUSTOMER_ID IS NOT NULL THEN N'Khách hàng'
            WHEN I.EMPLOYEE_ID IS NOT NULL THEN 
                CASE 
                    WHEN D.DEPARTMENT_NAME = N'Quản lý chi nhánh' THEN N'Quản lý chi nhánh'
                    ELSE N'Nhân viên'
                END
            ELSE N'Quản lý công ty'
        END
    FROM INSERTED I
    LEFT JOIN EMPLOYEE E ON I.EMPLOYEE_ID = E.EMPLOYEE_ID
    LEFT JOIN DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    WHERE ACCOUNT.ACCOUNT_ID = I.ACCOUNT_ID;
END;
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
        ROLLBACK;
        RAISERROR('Tuổi của nhân viên phải từ 18 đến 55.', 16, 1);
    END;

    -- Kiểm tra start_date >= 18 năm từ date_of_birth
    IF EXISTS (
        SELECT *
        FROM INSERTED
        WHERE DATEDIFF(YEAR, DATE_OF_BIRTH, START_DATE_WORK) < 18
           OR DATEDIFF(YEAR, DATE_OF_BIRTH, START_DATE_WORK) > 55
    )
    BEGIN
        ROLLBACK;
        RAISERROR('Ngày bắt đầu làm việc phải >= 18 và <= 55 năm từ ngày sinh.', 16, 1);
    END;

    -- Kiểm tra termination_date hợp lệ
    IF EXISTS (
        SELECT *
        FROM INSERTED
        WHERE TERMINATION_DATE IS NOT NULL 
          AND (TERMINATION_DATE <= START_DATE_WORK 
          OR DATEDIFF(YEAR, DATE_OF_BIRTH, COALESCE(TERMINATION_DATE, GETDATE())) > 55)
    )
    BEGIN
        ROLLBACK;
        RAISERROR('Ngày kết thúc làm việc không hợp lệ.', 16, 1);
    END;

    -- Kiểm tra salary cho department_name "Quản lý chi nhánh" phải lớn nhất
    IF EXISTS (
        SELECT *
        FROM INSERTED I
        JOIN DEPARTMENT D ON I.DEPARTMENT_ID = D.DEPARTMENT_ID
        WHERE D.DEPARTMENT_NAME = N'Quản lý chi nhánh'
          AND I.SALARY < (SELECT MAX(SALARY) FROM EMPLOYEE)
    )
    BEGIN
        ROLLBACK;
        RAISERROR('Lương của nhân viên thuộc "Quản lý chi nhánh" phải cao nhất.', 16, 1);
    END;
END;
GO

---------------------------------------- TRIGGER CHO BẢNG CUSTOMER ----------------------------------------
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

---------------------------------------- TRIGGER CHO BẢNG MEMBERSHIP_CARD ----------------------------------------
CREATE TRIGGER TRG_MEMBERSHIP_CARD
ON MEMBERSHIP_CARD
FOR INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra giá trị points không phù hợp với card_type
    IF EXISTS (
        SELECT *
        FROM INSERTED I
        WHERE (I.CARD_TYPE = N'Thẻ thành viên' AND I.POINTS NOT BETWEEN 0 AND 99) 
           OR (I.CARD_TYPE = N'Thẻ Silver' AND I.POINTS NOT BETWEEN 100 AND 199) 
           OR (I.CARD_TYPE = N'Thẻ Gold' AND I.POINTS NOT BETWEEN 200 AND 400)
    )
    BEGIN
        ROLLBACK;
        RAISERROR('Giá trị POINTS không phù hợp với card_type.', 16, 1);
    END;

    -- Kiểm tra date_issued
    IF EXISTS (
        SELECT *
        FROM INSERTED I
        JOIN ORDER_ O ON I.CUSTOMER_ID = O.CUSTOMER_ID
        WHERE I.DATE_ISSUED > O.ORDER_DATE AND I.CARD_TYPE = N'Thẻ thành viên'
    )
    BEGIN
        ROLLBACK;
        RAISERROR('Giá trị DATE_ISSUED không hợp lệ. DATE_ISSUED phải nhỏ hơn ORDER_DATE của CUSTOMER.', 16, 1);
    END;

    -- Kiểm tra employee_id làm việc tại thời điểm thẻ có hiệu lực
    IF EXISTS (
        SELECT *
        FROM INSERTED I
        JOIN EMPLOYEE E ON I.EMPLOYEE_ID = E.EMPLOYEE_ID
        WHERE I.DATE_ISSUED NOT BETWEEN E.START_DATE_WORK AND E.TERMINATION_DATE
    )
    BEGIN
        ROLLBACK;
        RAISERROR('Giá trị EMPLOYEE_ID không hợp lệ. EMPLOYEE_ID phải làm việc tại thời điểm thẻ có hiệu lực.', 16, 1);
    END;

    -- Cập nhật discount_amount
    UPDATE MEMBERSHIP_CARD
    SET DISCOUNT_AMOUNT = 
        CASE
            WHEN I.CARD_TYPE = N'Thẻ thành viên' THEN 50000
            WHEN I.CARD_TYPE = N'Thẻ Silver' THEN 100000
            WHEN I.CARD_TYPE = N'Thẻ Gold' THEN 200000
        END
    FROM INSERTED I
    WHERE MEMBERSHIP_CARD.CARD_ID = I.CARD_ID;
END;
GO

---------------------------------------- TRIGGER CHO BẢNG WORK_HISTORY ----------------------------------------
CREATE TRIGGER TRG_WORK_HISTORY
ON WORK_HISTORY
FOR INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra branch_start_date và branch_end_date
    IF EXISTS (
        SELECT *
        FROM INSERTED I
        WHERE I.BRANCH_START_DATE > I.BRANCH_END_DATE
    )
    BEGIN
        ROLLBACK;
        RAISERROR('Ngày không hợp lệ. BRANCH_START_DATE phải nhỏ hơn BRANCH_END_DATE.', 16, 1);
    END;

    -- Kiểm tra branch_end_date với termination_date và start_date_work
    IF EXISTS (
        SELECT *
        FROM INSERTED I
        JOIN EMPLOYEE E ON I.EMPLOYEE_ID = E.EMPLOYEE_ID
        WHERE I.BRANCH_END_DATE < E.START_DATE_WORK 
           OR (E.TERMINATION_DATE IS NOT NULL AND I.BRANCH_END_DATE > E.TERMINATION_DATE)
    )
    BEGIN
        ROLLBACK;
        RAISERROR('Ngày không hợp lệ.', 16, 1);
    END;
END;
GO

---------------------------------------- TRIGGER CHO BẢNG ORDER_ ----------------------------------------
CREATE TRIGGER TRG_ORDER
ON ORDER_
FOR INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra thời gian đặt hàng với thời gian mở cửa chi nhánh
    IF EXISTS (
        SELECT *
        FROM INSERTED I
        JOIN RESTAURANT_BRANCH RB ON I.BRANCH_ID = RB.BRANCH_ID
        WHERE I.ORDER_TIME NOT BETWEEN RB.OPEN_TIME AND RB.CLOSE_TIME
    )
    BEGIN
        ROLLBACK;
        RAISERROR('Thời gian đặt hàng không hợp lệ.', 16, 1);
    END;

    -- Kiểm tra ngày đặt hàng với ngày phát hành thẻ thành viên
    IF EXISTS (
        SELECT *
        FROM INSERTED I
        JOIN MEMBERSHIP_CARD MC ON I.CUSTOMER_ID = MC.CUSTOMER_ID
        WHERE I.ORDER_DATE < MC.DATE_ISSUED AND MC.CARD_TYPE = N'Thẻ thành viên'
    )
    BEGIN
        ROLLBACK;
        RAISERROR('Ngày đặt hàng không hợp lệ.', 16, 1);
    END;
END;
GO
