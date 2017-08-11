CREATE TABLE Sales.Orders (
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

SELECT TOP(3) p.FirstName + ' ' + p.LastName,SaleYTD
FROM SalesPerson AS s INNER JOIN Person AS p on s.PersonId = p.PersonId
WHERE s.TerritoryID IS NOT NULL
ORDER BY s.SalesYTD ASC



SELECT Complaints.ComplaintID,Persons.Name
FROM Complaints LEFT OUTER JOIN Contacts on Complaints.ComplaintID = Contacts.ComplaintID
    LEFT OUTER JOIN Persons on Contacts.PersonID = Persons.PersonID

UPDATE 
SET CreditLimit = 1000
WHERE CustomerId = 3


customerid,populaiton


not IsOnCreditHold


CAST (Cust.AccountOpenedDate AS DATE)

GROUP BY DATEPART(day,Cust.AccountOpenedDate)
HAVING COUNT(Cust.CustomerId)

Pivot example:
--Pivot table with one row and five columns
SELECT 'AverageCost' AS Cost_Sorted_By_Production_Days,[0],[1],[2],[3],[4]
FROM
(
    SELECT DaysToManufacture,StandardCost
    FROM Production.Product
) AS SourceTable
PIVOT
(
    AVG(StandardCost)
    FOR DaysToManufacture IN([0],[1],[2],[3],[4])
) AS PivotTable

------------------------------------------------
not on credit hold
cities with population greater than 10000

IN
WHERE
AND [IsOnCreditHold] = 0
---------------------------
--pivot and unpivot sql
---------------------------
--create the table and insert values
use dwhb;
go
CREATE TABLE conform.pvt (VendorID int, Emp1 int, Emp2 int, Emp3 int, Emp4 int, Emp5 int);
GO
INSERT INTO conform.pvt VALUES (101,4,3,5,4,4);
INSERT INTO conform.pvt VALUES (102,4,1,5,5,5);
INSERT INTO conform.pvt VALUES (103,4,3,5,4,4);
INSERT INTO conform.pvt VALUES (104,4,2,5,5,4);
INSERT INTO conform.pvt VALUES (105,5,1,5,5,5);
GO


SELECT * FROM conform.pvt;
SELECT * FROM conform.pvt2;

--Unpivot the table.
SELECT VendorID, Employee, Orders
--INTO conform.pvt2
FROM
    (
        SELECT VendorID, Emp1 AS [1],Emp2 AS [2],Emp3 AS [3],Emp4 AS [4],Emp5 AS [5]
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

SELECT * FROM conform.pvt2;

SELECT * FROM conform.pvt;
--pivot sql use conform.pvt2
SELECT VendorID,[Emp1],[Emp2],[Emp3],[Emp4],[Emp5]
FROM
(
    SELECT Employee,VendorID,Orders FROM conform.pvt2
) AS SourceTable
PIVOT
(
    SUM(Orders) FOR Employee IN (Emp1,[Emp2],[Emp3],[Emp4],[Emp5])
) as pvt
ORDER BY pvt.VendorID

------------------------------------------------------------

SELECT cityID,QuestionID,RawCount
FROM
(
    SELECT QuestionID,Tokyo AS [1],Boston AS [2],London AS [3],[New York] AS [4]
    FROM RawSurvey
) AS t1
UNPIVOT
(
    RawCount FOR cityID in ([1],[2],[3],[4]) 
)
AS t2





active user count for each role
 and the total active user count.
ordered by active user count of each role.
CTEs

SELECT RoleID, count(UserID) AS ActiveUserCount
FROM
tblUsersInRoles LEFT JOIN tblUsers
where tblUsers.IsActive = 1
GROUP BY tblUsersInRoles


------------------------------------------------------------
WITH Acit
