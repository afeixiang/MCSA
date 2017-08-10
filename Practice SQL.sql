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