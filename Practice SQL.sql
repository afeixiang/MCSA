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

