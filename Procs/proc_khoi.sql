--Chọn món trong menu (Delivery Order)
USE SUSUSHISHI

GO
CREATE PROCEDURE GetBranches
AS
BEGIN
  SELECT BRANCH_ID, BRANCH_NAME FROM RESTAURANT_BRANCH;
END;
GO
CREATE PROCEDURE GetMenuByDishName
  @BranchId CHAR(4),
  @DishName NVARCHAR(100)
AS
BEGIN
  SELECT 
    MC.CATEGORY_NAME,
    (
      SELECT 
        D.DISH_ID, D.DISH_NAME, D.DISH_PRICE
      FROM DISH D
      JOIN DISH_AVAILABLE DA 
        ON DA.DISH_ID = D.DISH_ID AND DA.BRANCH_ID = @BranchId AND DA.IS_AVAILABLE = 1
      WHERE D.CATEGORY_NAME = MC.CATEGORY_NAME
        AND D.DISH_NAME LIKE @DishName
      FOR JSON PATH
    ) AS DISHES
  FROM 
    (SELECT DISTINCT CATEGORY_NAME FROM DISH) MC
  WHERE 
    EXISTS (
      SELECT 1 
      FROM DISH D
      JOIN DISH_AVAILABLE DA ON DA.DISH_ID = D.DISH_ID 
      WHERE DA.BRANCH_ID = @BranchId 
      AND DA.IS_AVAILABLE = 1 
      AND D.CATEGORY_NAME = MC.CATEGORY_NAME
      AND D.DISH_NAME LIKE @DishName
    );
END;
GO
CREATE PROCEDURE GetMenuByBranchId
  @BranchId CHAR(4)
AS
BEGIN
  SELECT 
    MC.CATEGORY_NAME,
    (
      SELECT 
        D.DISH_ID, D.DISH_NAME, D.DISH_PRICE
      FROM DISH D
      JOIN DISH_AVAILABLE DA 
        ON DA.DISH_ID = D.DISH_ID AND DA.BRANCH_ID = @BranchId AND DA.IS_AVAILABLE = 1
      WHERE D.CATEGORY_NAME = MC.CATEGORY_NAME
      FOR JSON PATH
    ) AS DISHES
  FROM 
    (SELECT DISTINCT CATEGORY_NAME FROM DISH) MC;
END;
GO
CREATE PROCEDURE GetMaxOrderID
AS
BEGIN
  SELECT MAX(ORDER_ID) AS MaxOrderID 
  FROM ORDER_;
END;

GO
CREATE PROCEDURE CreateOrder
  @OrderId CHAR(7),
  @OrderDate DATE,
  @BranchId CHAR(4),
  @CustomerId CHAR(7),
  @OrderType VARCHAR(20),
  @OrderTime TIME
AS
BEGIN
  INSERT INTO [ORDER_] (ORDER_ID, ORDER_DATE, BRANCH_ID, CUSTOMER_ID, ORDER_TYPE, ORDER_TIME)
  VALUES (@OrderId, @OrderDate, @BranchId, @CustomerId, @OrderType, @OrderTime);
END;
GO
CREATE PROCEDURE CreateDeliveryOrder
  @OrderId CHAR(7),
  @DeliveryDate DATE,
  @DeliveryTime TIME
AS
BEGIN
  INSERT INTO DELIVERY_ORDER (DORDER_ID, TIME_DELIVERY, DATE_DELIVERY)
  VALUES (@OrderId, @DeliveryTime, @DeliveryDate);
END;
GO
CREATE PROCEDURE AddOrderDish
  @OrderId CHAR(7),
  @DishId CHAR(4),
  @Quantity INT
AS
BEGIN
  INSERT INTO ORDER_DISH (ORDER_ID, DISH_ID, QUANTITY)
  VALUES (@OrderId, @DishId, @Quantity);
END;

--Lưu lịch sử truy cập của khách hàng
GO

CREATE PROCEDURE getUserIdByAccount 
    @USERNAME NVARCHAR(50)
AS
BEGIN
    SELECT 
		AC.PASSWORD,
        CASE 
            WHEN AC.CUSTOMER_ID IS NULL THEN AC.EMPLOYEE_ID
            ELSE AC.CUSTOMER_ID 
        END AS Id,
        AC.ROLE,
        CASE 
            WHEN AC.CUSTOMER_ID IS NULL THEN E.FULL_NAME
            ELSE C.FULL_NAME
        END AS Name
    FROM ACCOUNT AC
    LEFT JOIN EMPLOYEE E ON AC.EMPLOYEE_ID = E.EMPLOYEE_ID
    LEFT JOIN CUSTOMER C ON AC.CUSTOMER_ID = C.CUSTOMER_ID
    WHERE AC.USERNAME = @USERNAME 
END
--Xem điểm, hạng thẻ của khách hàng
GO
CREATE PROCEDURE getMembershipCardInfo
    @CustomerID CHAR(7) -- Thay đổi kiểu dữ liệu cho phù hợp
AS
BEGIN
    SELECT *
    FROM MEMBERSHIP_CARD MC
    WHERE MC.CUSTOMER_ID = @CustomerID; -- So sánh trực tiếp, không chuyển đổi kiểu
END
GO
CREATE PROCEDURE UpdateSessionHistory
    @CustomerId CHAR(7),
    @SessionDuration INT
AS
BEGIN
    UPDATE ONLINE_ACCESS_HISTORY
    SET SESSION_DURATION = @SessionDuration
    WHERE CUSTOMER_ID = @CustomerId
        AND DATE_ACCESSED = CONVERT(DATE, GETDATE())
        AND TIME_ACCESSED = (
            SELECT MAX(TIME_ACCESSED)
            FROM ONLINE_ACCESS_HISTORY
            WHERE CUSTOMER_ID = @CustomerId
        );
END

GO
CREATE PROCEDURE InsertOnlineAccessHistory
    @DateAccessed DATE,
    @TimeAccessed DATETIME,
    @CustomerId CHAR(7),
    @SessionDuration INT
AS
BEGIN
    INSERT INTO ONLINE_ACCESS_HISTORY (DATE_ACCESSED, TIME_ACCESSED, CUSTOMER_ID, SESSION_DURATION)
    VALUES (@DateAccessed, @TimeAccessed, @CustomerId, @SessionDuration);
END;

--Xem doanh thu món bán chạy nhất, chậm nhất theo chi nhánh tại một khoảng thời gian nhất định
GO
CREATE PROCEDURE GetRevenueData
    @startDate DATE,
    @endDate DATE,
    @branchId CHAR(4)
AS
BEGIN
    SELECT od.DISH_ID, D.DISH_NAME, SUM(od.QUANTITY) AS TOTAL_SALES
    FROM ORDER_DISH od
    JOIN DISH D ON D.DISH_ID = od.DISH_ID
    JOIN ORDER_ O ON O.ORDER_ID = od.ORDER_ID AND O.BRANCH_ID = @branchId
    WHERE O.ORDER_DATE BETWEEN @startDate AND @endDate
    GROUP BY od.DISH_ID, D.DISH_NAME
END;
GO
CREATE PROCEDURE GetBestSellingDishes
    @startDate DATE,
    @endDate DATE,
    @branchId CHAR(4)
AS
BEGIN
    SELECT TOP 3 od.DISH_ID, D.DISH_NAME, SUM(od.QUANTITY) AS TOTAL_SALES
    FROM ORDER_DISH od
    JOIN DISH D ON D.DISH_ID = od.DISH_ID
    JOIN ORDER_ O ON O.ORDER_ID = od.ORDER_ID AND O.BRANCH_ID = @branchId
    WHERE O.ORDER_DATE BETWEEN @startDate AND @endDate
    GROUP BY od.DISH_ID, D.DISH_NAME
    ORDER BY TOTAL_SALES DESC
END;
GO
CREATE PROCEDURE GetLeastSellingDishes
    @startDate DATE,
    @endDate DATE,
    @branchId CHAR(4)
AS
BEGIN
    SELECT TOP 3 od.DISH_ID, D.DISH_NAME, SUM(od.QUANTITY) AS TOTAL_SALES
    FROM ORDER_DISH od
    JOIN DISH D ON D.DISH_ID = od.DISH_ID
    JOIN ORDER_ O ON O.ORDER_ID = od.ORDER_ID AND O.BRANCH_ID = @branchId
    WHERE O.ORDER_DATE BETWEEN @startDate AND @endDate
    GROUP BY od.DISH_ID, D.DISH_NAME
    ORDER BY TOTAL_SALES ASC
END;
