CREATE TABLE Sales.Orders
(
    OrderID INT NOT NULL,
    OrderDate DATE NULL,
    ShippedDate DATE NULL,
    Status VARCHAR(10),
    CONSTRAINT PK_ORDERS PRIMARY KEY CLUSTERED
)

DELETE
FROM Sales.Orders
WHERE OrderDate < '20120101'
    AND ShippedDate IS NOT NULL;

SELECT TOP(3)
    p.FirstName + ' ' + p.LastName, SaleYTD
FROM SalesPerson AS s INNER JOIN Person AS p on s.PersonId = p.PersonId
WHERE s.TerritoryID IS NOT NULL
ORDER BY s.SalesYTD ASC



SELECT Complaints.ComplaintID, Persons.Name
FROM Complaints LEFT OUTER JOIN Contacts on Complaints.ComplaintID = Contacts.ComplaintID
    LEFT OUTER JOIN Persons on Contacts.PersonID = Persons.PersonID

UPDATE 
SET CreditLimit = 1000
WHERE CustomerId = 3


customerid,populaiton


not IsOnCreditHold


CAST
(Cust.AccountOpenedDate AS DATE)

GROUP BY DATEPART
(day,Cust.AccountOpenedDate)
HAVING COUNT
(Cust.CustomerId)

Pivot
example:
--Pivot table with one row and five columns
SELECT 'AverageCost' AS Cost_Sorted_By_Production_Days, [0], [1], [2], [3], [4]
FROM
    (
    SELECT DaysToManufacture, StandardCost
    FROM Production.Product
) AS SourceTable
PIVOT
(
    AVG(StandardCost)
    FOR DaysToManufacture IN([0],[1],[2],[3],[4])
) AS PivotTable

------------------------------------------------
not on credit hold
cities
with population greater than 10000

IN
WHERE
AND [IsOnCreditHold] = 0
---------------------------
--pivot and unpivot sql
---------------------------
--create the table and insert values
use dwhb;
go
CREATE TABLE conform.pvt
(
    VendorID int,
    Emp1 int,
    Emp2 int,
    Emp3 int,
    Emp4 int,
    Emp5 int
);
GO
INSERT INTO conform.pvt
VALUES
    (101, 4, 3, 5, 4, 4);
INSERT INTO conform.pvt
VALUES
    (102, 4, 1, 5, 5, 5);
INSERT INTO conform.pvt
VALUES
    (103, 4, 3, 5, 4, 4);
INSERT INTO conform.pvt
VALUES
    (104, 4, 2, 5, 5, 4);
INSERT INTO conform.pvt
VALUES
    (105, 5, 1, 5, 5, 5);
GO


SELECT *
FROM conform.pvt;
SELECT *
FROM conform.pvt2;

--Unpivot the table.
SELECT VendorID, Employee, Orders
--INTO conform.pvt2
FROM
    (
        SELECT VendorID, Emp1 AS [1], Emp2 AS [2], Emp3 AS [3], Emp4 AS [4], Emp5 AS [5]
    FROM conform.pvt
    ) AS p
UNPIVOT
    (Orders FOR Employee IN ([1],[2],[3],[4],[5]) -- (Emp1,Emp2,Emp3,Emp4,Emp5)
    ) AS unpvt;
GO
---------------------------
--clean the workspace
--DROP TABLE conform.pvt
--DROP TABLE conform.pvt2
---------------------------

SELECT *
FROM conform.pvt2;

SELECT *
FROM conform.pvt;
--pivot sql use conform.pvt2
SELECT VendorID, [Emp1], [Emp2], [Emp3], [Emp4], [Emp5]
FROM
    (
    SELECT Employee, VendorID, Orders
    FROM conform.pvt2
) AS SourceTable
PIVOT
(
    SUM(Orders) FOR Employee IN (Emp1,[Emp2],[Emp3],[Emp4],[Emp5])
) as pvt
ORDER BY pvt.VendorID

------------------------------------------------------------

SELECT cityID, QuestionID, RawCount
FROM
    (
    SELECT QuestionID, Tokyo AS [1], Boston AS [2], London AS [3], [New York] AS [4]
    FROM RawSurvey
) AS t1
UNPIVOT
(
    RawCount FOR cityID in ([1],[2],[3],[4]) 
)
AS t2





--active user count for each role
 --and the total active user count.
--ordered by active user count of each role.
--CTEs

SELECT RoleID, count(UserID) AS ActiveUserCount
FROM
    tblUsersInRoles LEFT JOIN tblUsers 
where tblUsers.IsActive = 1
GROUP BY tblUsersInRoles


------------------------------------------------------------
WITH Acit
__________________________________________________
create or alter view Sales.CustTop5OrderValues
with
    SCHEMABINDING
AS

    WITH
        C1
        AS
        (
            SELECT
                O.orderid, O.custid,
                cast(sum(OD.qty * OD.unitprice * (1-OD.discount))
            AS NUMERIC(12,2)) AS val
            FROM Sales.Orders AS O
                INNER JOIN Sales.OrderDetails AS OD
                ON O.orderid = OD.orderid
            GROUP BY
        O.orderid,O.custid
        ),
        C2
        AS
        (
            SELECT
                custid, val,
                ROW_NUMBER() OVER (PARTITION BY custid ORDER BY val desc,orderid Desc) as pos
            FROM C1
        )

    SELECT custid, [1], [2], [3], [4], [5]
    FROM C2
    PIVOT(MAX(val) FOR pos IN ([1],[2],[3],[4],[5])) AS P;
GO

CREATE OR ALTER VIEW Sales.OrderValuePcts
WITH
    SCHEMABINDING
AS

    WITH
        OrderTotals
        AS
        (
            SELECT
                O.orderid, O.custid,
                cast(sum(OD.qty * OD.unitprice*(1-OD.discount)) as NUMERIC(12,2)) AS val
            FROM Sales.Orders AS O
                INNER JOIN Sales.OrderDetails AS OD
                ON O.orderid = OD.orderid
            GROUP BY
        O.orderid,O.custid
        )
    SELECT
        orderid, sutid, val,
        cast(val / sum(val) OVER()* 100.0 as NUMERIC(5,2)) AS pctall,
        cast(val / sum(val) OVER (PARTITION BY custid)* 100.0 as NUMERIC(5,2)) AS pctcust
    FROM OrderTotals;
GO


CREATE OR ALTER FUNCTION dbo.GetPage(@pagenum AS BIGINT, @pagesize AS BIGINT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
    SELECT ROW_NUMBER() OVER(ORDER BY orderdate,orderid) AS rownum,
    orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate,orderid
    OFFSET (@pagenum - 1) * @pagesize ROWS FETCH NEXT @pagesize ROWS
    ONLY;
GO

DROP FUNCTION IF EXISTS dbo.GetSubtree;
GO
CREATE FUNCTION dbo.GetSubtree(@mgr AS INT,@maxlevels AS INT = NULL)
RETURN TABLE
WITH SCHEMABINDING
AS
RETURN
WITH
    EmpsCTE
    AS
    (
            SELECT empid, CAST(NULL AS INT) AS mgrid, empname, salary, 0 as lvl,
                CAST('.' AS VARCHAR(900)) AS sortpath
            FROM dbo.Employees
            WHERE empid = @mgr

        UNION ALL

            SELECT S.empid, S.mgrid, S.empname, S.salary, M.lvl+1 AS lvl,
                CAST(M.sortpath + CAST(S.empid AS VARCHAR(10)) + '.' AS VARCHAR(900)) AS sortpath
            FROM EmpsCTE AS M
                INNER JOIN dbo.Employees AS S
                ON S.mgrid = M.empid
                    AND (M.lvb<@maxlevels OR @maxlevels IS NULL)
    )
SELECT empid, mgrid, empname, salary, lvl, sortpath
FROM EmpsCTE


--------------------------------------------------------------------------
USE TSQLV4
GO
CREATE OR ALTER VIEW    Sales.OrderTotals
    WITH SCHEMABINDING

--------------------------------------------------------------------------
SELECT productid, productname, unitprice, dicontinued,
    CASE discontinued
        WHEN 0 THEN 'NO'
        WHEN 1 THEN 'YES'
        ELSE 'UNKNOWN'
    END AS discontinued_desc
FROM Production.Products;


--------------------------------------------------------------------------

SELECT productid, productname, unitprice,
    CASE 
        WHEN unitprice < 20.00 THEN 'Low'
        WHEN unitprice < 40.00 THEN 'Medium'
        WHEN unitprice >= 40.00 THEN 'High'
        ELSE 'Unknown'
    END AS pricerange
FROM Production.Products

--------------------------------------------------------------------------
EXEC sys.sp_set_session_context
    @key = N'language', @value = 'us_english', @read_only = 1;

SELECT SESSION_CONTEXT(N'language') AS [language];
