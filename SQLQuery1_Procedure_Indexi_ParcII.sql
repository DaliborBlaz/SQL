USE Northwind
GO
--Podupit u Selectu
SELECT P.ProductName, (
SELECT MAX(Quantity)
FROM [Order Details] AS OD
WHERE P.ProductID=OD.ProductID)
FROM Products AS P
ORDER BY P.ProductName 

--POdupit u WHEREu
SELECT C.CompanyName, C.ContactName, C.City, C.Phone
FROM Customers AS C
WHERE ( SELECT SUM(OD.UnitPrice * OD.Quantity)
		FROM Orders AS O JOIN [Order Details] AS OD
		ON O.OrderID=OD.OrderID
		WHERE C.CustomerID=O.CustomerID) >10000

USE AdventureWorks2017
GO

--Podupit u FROMu
SELECT TOP 1 Rate
FROM(SELECT TOP 4 Rate
FROM HumanResources.EmployeePayHistory
ORDER BY Rate DESC) AS Plate
ORDER BY Rate ASC

USE Northwind
GO


--Kreiranje procedure za insert
CREATE PROCEDURE usp_Products_Insert
(
	 @ProductName nvarchar(40),
	 @SupplierID int= NULL,
	 @CategoryID int=NULL,
	 @QuantityPerUnit nvarchar(20)=NULL,
	 @UnitPrice money=NULL,
	 @UnitsInStock smallint=NULL,
	 @UnitsOnOrder smallint=NULL,
	 @ReorderLevel smallint=NULL,
	 @Discountinued bit

) AS 
BEGIN
	INSERT INTO Products
	VALUES(@ProductName,@SupplierID, @CategoryID, @QuantityPerUnit, @UnitPrice, @UnitsInStock,@UnitsOnOrder,@ReorderLevel, @Discountinued)
END

EXEC usp_Products_Insert @ProductName='CocaCola',
						 @SupplierID=1,
						 @CategoryID=1,
						 @Discountinued=1
SELECT* FROM Products WHERE ProductName LIKE 'coca%'

--Kreiranje stored procedure UPDATE

CREATE PROCEDURE usp_Products_Update
(
	@ProductID INT,
	 @ProductName nvarchar(40),
	 @SupplierID int= NULL,
	 @CategoryID int=NULL,
	 @QuantityPerUnit nvarchar(20)=NULL,
	 @UnitPrice money=NULL,
	 @UnitsInStock smallint=NULL,
	 @UnitsOnOrder smallint=NULL,
	 @ReorderLevel smallint=NULL,
	 @Discontinued bit

) AS 
BEGIN
	UPDATE Products
	SET ProductName=@ProductName,
	SupplierID=@SupplierID, 
	CategoryID=@CategoryID, 
	QuantityPerUnit=@QuantityPerUnit, 
	UnitPrice=@UnitPrice, 
	UnitsInStock=@UnitsInStock,
	UnitsOnOrder=@UnitsOnOrder,
	ReorderLevel=@ReorderLevel, 
	Discontinued=@Discontinued
	WHERE ProductID=@ProductID
END

EXEC usp_Products_Update @ProductName='CocaCola',
						 @SupplierID=1,
						 @CategoryID=1,
						 @UnitPrice=7,
						 @Discontinued=1,
						 @ProductID=78
SELECT* FROM Products WHERE ProductName LIKE 'coca%'

--Kreiranje stored procedure DELETE
CREATE PROCEDURE usp_Products_Delete
(
	@ProductID INT
	
) AS 
BEGIN
	DELETE FROM Products
	WHERE ProductID=@ProductID
END

EXEC usp_Products_Delete @ProductID=78
SELECT* FROM Products WHERE ProductName LIKE 'coca%'

--Procedura nad dvije tabele
CREATE PROCEDURE usp_OrderDetails_Insert
(
	@OrderID int,
	@ProductID int,
	@UnitPrice money,
	@Quantity smallint,
	@Discount real
)
AS
BEGIN
	INSERT INTO [Order Details]
	VALUES (@OrderID, @ProductID, @UnitPrice, @Quantity, @Discount)

	UPDATE Products
	SET UnitsInStock=UnitsInStock-@Quantity
	WHERE ProductID=@ProductID
END

EXEC usp_OrderDetails_Insert 
							 @OrderID=10249,
							 @ProductID=1,
							 @UnitPrice=2,
							 @Quantity=5,
							 @Discount=0.1

SELECT * FROM Products
WHERE ProductID=1

SELECT * FROM [Order Details] WHERE OrderID=10249

--Kreiranje stored procedure SELECT

CREATE PROCEDURE usp_Product_SelectByProductNameOrCategoryID
(
	
	@ProductName nvarchar(40),
	@CategoryID int
)
AS
BEGIN
	SELECT ProductName, UnitPrice, UnitsInStock, UnitsOnOrder
	FROM Products
	WHERE (ProductName=@ProductName OR @ProductName IS NULL) AND
		  (CategoryID=@CategoryID OR @CategoryID IS NULL)
END

EXEC usp_Product_SelectByProductNameOrCategoryID @ProductName='chai'
EXEC usp_Product_SelectByProductNameOrCategoryID @CategoryID=2
EXEC usp_Product_SelectByProductNameOrCategoryID @ProductName='Aniseed Syrup', @CategoryID=2
EXEC usp_Product_SelectByProductNameOrCategoryID @ProductName=null, @CategoryID=null

--TRIGGERI

CREATE DATABASE Test2
GO

USE Test2

CREATE TABLE Kupci(
	KupacID INT PRIMARY KEY IDENTITY (1,1),
	Ime nvarchar (50),
	Prezime nvarchar(50),
	Adresa nvarchar(100)
)
CREATE TABLE KupciAudit(
	AuditID int primary key identity(1,1),
	KupacID INT,
	Ime nvarchar (50),
	Prezime nvarchar(50),
	Adresa nvarchar(100),
	Komanta nvarchar(10),
	Korisnik nvarchar(50),
	Datum datetime
)

CREATE TRIGGER tr_Kupci_Insert
ON Kupci AFTER INSERT AS
	INSERT INTO KupciAudit (
			KupacID, Ime, Prezime, Adresa, Komanta, Korisnik, Datum)
			SELECT i.KupacID, i.Ime, i.Prezime, i.Adresa,'INSERT', SYSTEM_USER, GETDATE()
			FROM inserted AS i

INSERT INTO Kupci(Ime, Prezime, Adresa) VALUES('Jasim','Azemovic','FIT')
INSERT INTO Kupci(Ime, Prezime, Adresa) VALUES('Admir','Sehidic','FIT')

SELECT * FROM Kupci

SELECT * FROM KupciAudit

--Kreiranje AFTER Triggera UPDATE

CREATE TRIGGER tr_Kupci_Update
ON Kupci AFTER UPDATE AS
	INSERT INTO KupciAudit (
			KupacID, Ime, Prezime, Adresa, Komanta, Korisnik, Datum)
			SELECT d.KupacID, d.Ime, d.Prezime, d.Adresa,'DELETE', SYSTEM_USER, GETDATE()
			FROM deleted AS d

UPDATE Kupci SET Ime='Nikola' WHERE KupacID=2

SELECT * FROM Kupci

SELECT * FROM KupciAudit
