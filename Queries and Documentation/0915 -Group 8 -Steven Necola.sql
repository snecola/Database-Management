-- =============================================
-- Author:		Steven Necola
-- Create date: 3.20.21
-- 0915- GROUP 8- 20 QUERIES
-- 5 SIMPLE QUERIES
-- 8 MEDIUM QUERIES
-- 7 COMPLEX QUERIES
-- =============================================

-- ================================================
--					SIMPLE
-- ================================================


/*
	Problem 01: [SIMPLE] Find the last customer to order from USA using Northwinds2020TSQLV6
*/
USE [Northwinds2020TSQLV6];
GO

SELECT TOP (1)
       C.CustomerId,
       O.OrderDate,
       C.CustomerContactName,
       C.CustomerCompanyName,
       C.CustomerAddress,
       C.CustomerCity,
       C.CustomerRegion,
       C.CustomerCountry
FROM Sales.[Order] AS O
    INNER JOIN Sales.Customer AS C
        ON C.CustomerId = O.CustomerId
WHERE C.CustomerCountry LIKE N'USA'
ORDER BY O.OrderDate DESC
--FOR JSON PATH, ROOT('Simple 1: Most recent USA customer'), INCLUDE_NULL_VALUES;


/*
	Problem 02: [SIMPLE] Find the SupplierId, Company Name, and Contact Name of every product using Northwinds2020TSQLV6
*/
USE [Northwinds2020TSQLV6];
GO

SELECT P.ProductId,
       P.ProductName,
       P.SupplierId,
       S.SupplierCompanyName,
       S.SupplierContactName
FROM Production.Product AS P
    INNER JOIN Production.Supplier AS S
        ON P.SupplierId = S.SupplierId
--FOR JSON PATH, ROOT('Simple 2: Every Product supplier details'), INCLUDE_NULL_VALUES;

/*
	Problem 03: [SIMPLE] Get all orders placed by customers in the USA in the year 2015
*/
USE Northwinds2020TSQLV6;
GO

SELECT O.OrderId,
       C.CustomerId,
       C.CustomerCountry AS Country,
       O.OrderDate AS OrderDate
FROM Sales.[Order] AS O
    INNER JOIN Sales.Customer AS C
        ON C.CustomerId = O.CustomerId
WHERE C.CustomerCountry LIKE N'USA'
      AND YEAR(O.OrderDate) = 2015
ORDER BY C.CustomerId,
         O.OrderId
--FOR JSON PATH, ROOT('Simple 3: USA Orders 2015'), INCLUDE_NULL_VALUES;

/*
	Problem 04: [SIMPLE] Return the Sales person freight and bonus for every sales person using AdventureWorks2017
*/

USE AdventureWorks2017;
GO

SELECT SP.BusinessEntityID AS ID,
       SUM(OH.Freight) AS TotalSales,
       SP.Bonus AS Bonus
FROM Sales.SalesOrderHeader AS OH
    INNER JOIN Sales.SalesPerson AS SP
        ON SP.BusinessEntityID = OH.SalesPersonID
GROUP BY SP.BusinessEntityID,
         SP.Bonus
ORDER BY TotalSales
--FOR JSON PATH, ROOT('Simple 4: Sales person total freight and bonus'), INCLUDE_NULL_VALUES;

/*
	Problem 05: [SIMPLE] Find the name of every Employee in the Sales department using AdventureWorks2017
*/

USE AdventureWorks2017;
GO

SELECT P.BusinessEntityID,
       P.FirstName,
       P.LastName
FROM Person.Person AS P
    INNER JOIN Sales.SalesPerson AS S
        ON S.BusinessEntityID = P.BusinessEntityID
ORDER BY P.BusinessEntityID
--FOR JSON PATH, ROOT('Simple 5: Sales employees'), INCLUDE_NULL_VALUES;


-- ================================================
--					MEDIUM
-- ================================================

/*
	Problem 06: [MEDIUM] Find the CustomerName, Employee LastName,FirstName , ShipperCompanyName for every order using Northwinds2020TSQLV6
*/
USE [Northwinds2020TSQLV6];
GO

SELECT O.OrderId AS OrderId,
       C.CustomerContactName AS CustomerName,
       CONCAT(E.EmployeeLastName, ', ', E.EmployeeFirstName) AS EmployeeName,
       S.ShipperCompanyName
FROM Sales.[Order] AS O
    INNER JOIN Sales.Customer AS C
        ON C.CustomerId = O.CustomerId
    INNER JOIN HumanResources.Employee AS E
        ON E.EmployeeId = O.EmployeeId
    INNER JOIN Sales.Shipper AS S
        ON S.ShipperId = O.ShipperId
--FOR JSON PATH, ROOT('Medium 1: Every Order Details'), INCLUDE_NULL_VALUES;

/*
	Problem 07: [MEDIUM] Find the 10 longest shipping times it took to ship each order, the shipping company name, phone number, and city using Northwinds2020TSQLV6
*/
USE [Northwinds2020TSQLV6];
GO

SELECT TOP (10)
       O.OrderId AS OrderId,
       DATEDIFF(DAY, O.OrderDate, O.ShipToDate) AS DaysToShip,
       S.ShipperCompanyName,
       S.PhoneNumber,
       O.ShipToCity AS OrderCity,
       O.ShipToCountry AS OrderCountry
FROM Sales.[Order] AS O
    INNER JOIN Sales.Shipper AS S
        ON S.ShipperId = O.ShipperId
WHERE DATEDIFF(DAY, O.OrderDate, O.ShipToDate) >= 1
ORDER BY DaysToShip DESC
--FOR JSON PATH, ROOT('Medium 2: 10 longest shipments'), INCLUDE_NULL_VALUES;

/*
	Problem 08: [MEDIUM] List the order details of every order from the Brazil using Northwinds2020TSQLV6
*/

USE [Northwinds2020TSQLV6];
GO

SELECT O.OrderId,
       C.CustomerCountry,
       OD.ProductId,
       OD.UnitPrice,
       OD.Quantity,
       (OD.UnitPrice * OD.Quantity) AS LineAmount,
       OD.DiscountPercentage,
       (OD.UnitPrice * OD.Quantity * (1 - OD.DiscountPercentage)) AS LineAmountDiscounted
FROM Sales.[Order] AS O
    INNER JOIN Sales.Customer AS C
        ON C.CustomerId = O.CustomerId
    INNER JOIN Sales.OrderDetail AS OD
        ON OD.OrderId = O.OrderId
WHERE C.CustomerCountry LIKE N'Brazil'
ORDER BY O.OrderId,
         LineAmountDiscounted
--FOR JSON PATH, ROOT('Medium 3: Order Details from Brazil'), INCLUDE_NULL_VALUES;





/*
	Problem 09: [MEDIUM] Show the top count of sales made by employees using Northwinds2020TSQLV6
*/
USE [Northwinds2020TSQLV6]
GO

SELECT CONCAT(E.EmployeeLastName, ', ', E.EmployeeFirstName) AS EmployeeFullName,
       COUNT(DISTINCT O.OrderId) AS Orders
FROM Sales.[Order] AS O
    INNER JOIN HumanResources.Employee AS E
        ON E.EmployeeId = O.EmployeeId
GROUP BY CONCAT(E.EmployeeLastName, ', ', E.EmployeeFirstName)
ORDER BY Orders DESC
--FOR JSON PATH, ROOT('Medium 4: Top count of sales made by employees'), INCLUDE_NULL_VALUES;

/*
	Problem 10: [MEDIUM] Return the total quantity for each employee and year using Northwinds2020TSQLV6
*/
USE Northwinds2020TSQLV6;
GO

SELECT O.EmployeeId,
       YEAR(O.OrderDate) AS OrderYear,
       SUM(Quantity) AS Quantity
FROM Sales.[Order] AS O
    INNER JOIN Sales.OrderDetail AS OD
        ON O.OrderId = OD.OrderId
GROUP BY O.EmployeeId,
         YEAR(O.OrderDate)
ORDER BY OrderYear,
         O.EmployeeId
--FOR JSON PATH, ROOT('Medium 5: Employee per year sales quantity'), INCLUDE_NULL_VALUES;

/*
	Problem 11: [MEDIUM] Count how many employees are single or married using [AdventureWorks2017]
*/

USE [AdventureWorks2017];
GO

SELECT MaritalStatus = CASE
                           WHEN E.MaritalStatus LIKE N'M' THEN
                               'Married'
                           WHEN E.MaritalStatus LIKE N'S' THEN
                               'Single'
                           ELSE
                               'Unknown'
                       END,
       COUNT(DISTINCT E.BusinessEntityID) AS StatusCount
FROM HumanResources.Employee AS E
    INNER JOIN HumanResources.EmployeePayHistory AS EP
        ON EP.BusinessEntityID = E.BusinessEntityID
GROUP BY E.MaritalStatus
--FOR JSON PATH, ROOT('Medium 6: Company relationship status'), INCLUDE_NULL_VALUES;

/*
	Problem 12: [MEDIUM] Find employees who are also customers using AdventureWorksDW2017
*/
USE AdventureWorksDW2017;
GO

SELECT DISTINCT
       C.CustomerKey,
       CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
       E.EmployeeKey,
       CONCAT(E.FirstName, ' ', E.LastName) AS EmployeeName
FROM dbo.DimEmployee AS E
    INNER JOIN dbo.DimCustomer AS C
        ON C.FirstName = E.FirstName
           AND C.LastName = E.LastName
ORDER BY CustomerName
--FOR JSON PATH, ROOT('Medium 7:Don't get high off your own supply'), INCLUDE_NULL_VALUES;



/*
	Problem 13: [MEDIUM] FIND THE AVG INCOME OF CUSTOMERS GROUPED BY THEIR EDUCATION using AdventureWorksDW2017
	
*/
USE AdventureWorksDW2017;
GO

SELECT C.EnglishEducation,
       AVG(C.YearlyIncome) AS AverageYearlyIncome
FROM dbo.DimCustomer AS C
GROUP BY C.EnglishEducation
--FOR JSON PATH, ROOT('Medium 8: AVG Income by Education'), INCLUDE_NULL_VALUES;

-- ================================================
--					COMPLEX
-- ================================================


/*
	Problem 14: [COMPLEX] Show the top count of sales made by employees and their total sales amount using Northwinds2020TSQLV6
*/
USE Northwinds2020TSQLV6;
DROP FUNCTION IF EXISTS dbo.EmployeeTotalFreight;
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE FUNCTION dbo.EmployeeTotalFreight
(
    -- Add the parameters for the function here
    @EmployeeId INT
)
RETURNS FLOAT
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Result FLOAT;

    -- Add the T-SQL statements to compute the return value here
    SELECT @Result = SUM(OD.Quantity * OD.UnitPrice)
    FROM Sales.OrderDetail AS OD
        INNER JOIN Sales.[Order] AS O
            ON O.OrderId = OD.OrderId
    WHERE O.EmployeeId = @EmployeeId;

    -- Return the result of the function
    RETURN @Result;

END;
GO

SELECT E.EmployeeId,
       CONCAT(E.EmployeeLastName, ', ', E.EmployeeFirstName) AS EmployeeFullName,
       COUNT(DISTINCT O.OrderId) AS Orders,
       dbo.EmployeeTotalFreight(E.EmployeeId) AS TotalSales
FROM HumanResources.Employee AS E
    INNER JOIN Sales.[Order] AS O
        ON O.EmployeeId = E.EmployeeId
GROUP BY E.EmployeeId,
         CONCAT(E.EmployeeLastName, ', ', E.EmployeeFirstName)
ORDER BY Orders DESC
--FOR JSON PATH, ROOT('Complex 1: Top sales employees'), INCLUDE_NULL_VALUES;




/*
	Problem 15: [COMPLEX] Find the top selling Products in AdventureWorks2017
*/

USE [AdventureWorks2017];
GO

DROP FUNCTION IF EXISTS dbo.QuantitySold;
GO

CREATE FUNCTION dbo.QuantitySold
(
    -- Add the parameters for the function here
    @ProductId INT
)
RETURNS INT
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Result INT;

    -- Add the T-SQL statements to compute the return value here
    SELECT @Result = SUM(OrderQty)
    FROM Sales.SalesOrderDetail
    WHERE ProductID = @ProductId;

    -- Return the result of the function
    RETURN @Result;

END;
GO

SELECT P.ProductID,
       P.[Name],
       dbo.QuantitySold(P.ProductID) AS QuantitySold,
       P.StandardCost,
       (P.StandardCost * dbo.QuantitySold(P.ProductID)) AS TotalEarnings
FROM Production.Product AS P
WHERE dbo.QuantitySold(P.ProductID) IS NOT NULL
ORDER BY QuantitySold DESC
--FOR JSON PATH, ROOT('Complex 2: Top selling products'), INCLUDE_NULL_VALUES;

/*
	Problem 16: [COMPLEX] Find out how many customers have children but don't have them at home anymore using [AdventureWorksDW2017]
*/
USE AdventureWorksDW2017;
GO

DROP FUNCTION IF EXISTS dbo.emptyNest;
GO

CREATE FUNCTION dbo.emptyNest
(
    -- Add the parameters for the function here
    @CustomerKey INT
)
RETURNS CHAR(5)
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Result CHAR(5);

    -- Add the T-SQL statements to compute the return value here
    SELECT @Result = CASE
                         WHEN (C.TotalChildren) > 0
                              AND (C.NumberChildrenAtHome < C.TotalChildren) THEN
                             'TRUE'
                         ELSE
                             'FALSE'
                     END
    FROM dbo.DimCustomer AS C
    WHERE C.CustomerKey = @CustomerKey;

    -- Return the result of the function
    RETURN @Result;

END;
GO

SELECT C.CustomerKey,
       CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
       dbo.emptyNest(C.CustomerKey) AS KidsLeftHome
FROM dbo.DimCustomer AS C
WHERE dbo.emptyNest(C.CustomerKey) LIKE 'TRUE'
--FOR JSON PATH, ROOT('Complex 3: Empty Nest'), INCLUDE_NULL_VALUES;


/*
	Problem 17: [COMPLEX] Find the AVG yearly income of employees grouped by department using AdventureWorksDW2017
*/
USE AdventureWorksDW2017;
GO

DROP FUNCTION IF EXISTS dbo.CalculateYearlyIncome;
GO

CREATE FUNCTION dbo.CalculateYearlyIncome
(
    -- Add the parameters for the function here
    @EmployeeKey INT
)
RETURNS MONEY
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Result MONEY;

    -- Add the T-SQL statements to compute the return value here
    SELECT @Result = (BaseRate * 160 * 12) + (BaseRate * SickLeaveHours)
    FROM dbo.DimEmployee
    WHERE EmployeeKey = @EmployeeKey;

    -- Return the result of the function
    RETURN @Result;

END;
GO

SELECT DepartmentName,
       AVG(dbo.CalculateYearlyIncome(EmployeeKey)) AS AvgIncome
FROM dbo.DimEmployee
GROUP BY DepartmentName
ORDER BY AvgIncome DESC
--FOR JSON PATH, ROOT('Complex 4: AVG Yearly Income by Department '), INCLUDE_NULL_VALUES;



/*
	Problem 18: [COMPLEX] Calculate expected years until retirement for employees.
*/
USE AdventureWorksDW2017;
GO

DROP FUNCTION IF EXISTS dbo.ExpectedRetirementYear;
GO

CREATE FUNCTION dbo.ExpectedRetirementYear
(
    -- Add the parameters for the function here
    @CurrentDate DATE,
    @EmployeeKey INT
)
RETURNS INT
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Result INT;

    -- Add the T-SQL statements to compute the return value here
    SELECT @Result = CASE
                         WHEN DATEDIFF(YEAR, BirthDate, @CurrentDate) > 65 THEN
                             -1
                         ELSE
                             65 - DATEDIFF(YEAR, BirthDate, @CurrentDate)
                     END
    FROM dbo.DimEmployee
    WHERE EmployeeKey = @EmployeeKey;

    -- Return the result of the function
    RETURN @Result;

END;
GO

SELECT EmployeeKey,
       CONCAT(FirstName, ' ', LastName) AS EmployeeName,
       DATEDIFF(YEAR, BirthDate, SYSDATETIME()) EmployeeAge,
       dbo.ExpectedRetirementYear(SYSDATETIME(), EmployeeKey) AS YearsUntilRetirement
FROM dbo.DimEmployee
WHERE dbo.ExpectedRetirementYear(SYSDATETIME(), EmployeeKey) >= 0
ORDER BY YearsUntilRetirement
--FOR JSON PATH, ROOT('Complex 5: Expected Retirement'), INCLUDE_NULL_VALUES;


/*
	Problem 19: [COMPLEX] Employee of the year
*/

USE Northwinds2020TSQLV6;
GO

DROP FUNCTION IF EXISTS dbo.EmployeeOfTheMonth;
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE FUNCTION dbo.EmployeeOfTheMonth
(
    -- Add the parameters for the function here
    @EmployeeId INT,
    @Month INT,
    @Year INT
)
RETURNS FLOAT
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Result FLOAT;

    -- Add the T-SQL statements to compute the return value here
    SELECT @Result = SUM(OD.Quantity * OD.UnitPrice)
    FROM Sales.OrderDetail AS OD
        INNER JOIN Sales.[Order] AS O
            ON O.OrderId = OD.OrderId
    WHERE O.EmployeeId = @EmployeeId
          AND MONTH(O.OrderDate) = @Month
          AND YEAR(O.OrderDate) = @Year;

    -- Return the result of the function
    RETURN @Result;

END;
GO

SELECT MONTH(O.OrderDate) AS 'Month',
       E.EmployeeId,
       (
           SELECT TOP (1)
                  dbo.EmployeeOfTheMonth(E.EmployeeId, MONTH(O.OrderDate), YEAR(O.OrderDate)) AS TotalEarnings
           FROM Sales.[Order] AS O
           ORDER BY TotalEarnings DESC
       ) AS TotalEarnings
FROM HumanResources.Employee AS E
    INNER JOIN Sales.[Order] AS O
        ON O.EmployeeId = E.EmployeeId
WHERE YEAR(O.OrderDate) = 2015
GROUP BY MONTH(O.OrderDate),
         E.EmployeeId
ORDER BY MONTH(O.OrderDate),
         TotalEarnings DESC;
--FOR JSON PATH, ROOT('Complex 6: Employee of the year'), INCLUDE_NULL_VALUES;


/*
	Problem 20: [COMPLEX] Create a location profile for each employee
*/
USE Northwinds2020TSQLV6;
GO

DROP FUNCTION IF EXISTS dbo.EmployeeLocation;
GO

CREATE FUNCTION dbo.EmployeeLocation
(
    -- Add the parameters for the function here
    @EmployeeId INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Result NVARCHAR(MAX);

    -- Add the T-SQL statements to compute the return value here
    SELECT @Result
        = CONCAT(
                    E.EmployeeAddress,
                    ' ',
                    E.EmployeePostalCode,
                    ' ',
                    E.EmployeeCity,
                    ' ',
                    E.EmployeeRegion,
                    ' ',
                    E.EmployeeCountry
                )
    FROM HumanResources.Employee AS E
    WHERE E.EmployeeId = @EmployeeId;

    -- Return the result of the function
    RETURN @Result;

END;
GO

SELECT EmployeeId,
       CONCAT(EmployeeTitleOfCourtesy, ' ', EmployeeLastName, ', ', EmployeeFirstName) AS EmployeeName,
       dbo.EmployeeLocation(EmployeeId) AS EmployeeLocation
FROM HumanResources.Employee
--FOR JSON PATH, ROOT('Complex 7: Location Profiles'), INCLUDE_NULL_VALUES;


-- ================================================
--				Worst queries fixed
-- ================================================
/*
	Problem 02: [SIMPLE] Find the supplier info for every product
*/
USE [Northwinds2020TSQLV6];
GO
SELECT P.ProductId,
   	P.ProductName,
   	P.SupplierId,
   	S.SupplierCompanyName,
   	S.SupplierContactName,
	S.SupplierPhoneNumber
FROM Production.Product AS P
    INNER JOIN Production.Supplier AS S
    	ON P.SupplierId = S.SupplierId
--FOR JSON PATH, ROOT('Simple 2: Every Product supplier details'), INCLUDE_NULL_VALUES;

/*
	Problem 06: [MEDIUM] Find the CustomerName, Employee LastName,FirstName , ShipperCompanyName for every order using Northwinds2020TSQLV6
*/
USE [Northwinds2020TSQLV6];
GO

SELECT O.OrderId AS OrderId,
       C.CustomerContactName AS CustomerName,
       CONCAT(E.EmployeeLastName, ', ', E.EmployeeFirstName) AS EmployeeName,
       S.ShipperCompanyName,
	   S.PhoneNumber AS ShipperPhoneNumber
FROM Sales.[Order] AS O
    INNER JOIN Sales.Customer AS C
        ON C.CustomerId = O.CustomerId
    INNER JOIN HumanResources.Employee AS E
        ON E.EmployeeId = O.EmployeeId
    INNER JOIN Sales.Shipper AS S
        ON S.ShipperId = O.ShipperId
GROUP BY S.PhoneNumber, O.OrderId, CONCAT(E.EmployeeLastName, ', ', E.EmployeeFirstName), S.ShipperCompanyName, C.CustomerContactName
ORDER BY OrderId
--FOR JSON PATH, ROOT('Medium 1: Every Order Details'), INCLUDE_NULL_VALUES;


/*
	Problem 19: [COMPLEX] Employee of the year
*/

USE Northwinds2020TSQLV6;
GO

DROP FUNCTION IF EXISTS dbo.EmployeeOfTheYear;
GO

CREATE FUNCTION dbo.EmployeeOfTheYear
(
	-- Add the parameters for the function here
	@EmployeeId INT,
	@Year INT
)
RETURNS MONEY
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result MONEY

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = SUM(O.Freight)
	FROM Sales.[Order] AS O
		INNER JOIN HumanResources.Employee AS E
			ON E.EmployeeId = O.EmployeeId
	WHERE E.EmployeeId = @EmployeeId AND YEAR(O.OrderDate) = @Year

	-- Return the result of the function
	RETURN @Result

END
GO


SELECT TOP (1)
       E.EmployeeId,
       dbo.EmployeeOfTheYear(E.EmployeeId, 2015) AS EmployeeFreight
FROM HumanResources.Employee AS E
    INNER JOIN Sales.[Order] AS O
        ON O.EmployeeId = E.EmployeeId
GROUP BY E.EmployeeId
ORDER BY EmployeeFreight DESC;
--FOR JSON PATH, ROOT('Complex 6: Employee of the year'), INCLUDE_NULL_VALUES;