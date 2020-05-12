CREATE DATABASE Pripremi
ON PRIMARY
(
	NAME='Pripremni_dat',
	FILENAME='H:\BP2\Data\Pripremi.mdf',
	FILEGROWTH=10%,
	SIZE=100MB,
	MAXSIZE=UNLIMITED
	
)
LOG ON
(
	NAME='Pripremni_log',
	FILENAME='H:\BP2\Log\Pripremi.ldf',
	FILEGROWTH=10%,
	SIZE=100MB,
	MAXSIZE=UNLIMITED
)

USE Pripremi
GO

CREATE CLUSTERED INDEX idx_index1
ON [Production].[Product](ProductID)

CREATE NONCLUSTERED INDEX idx_nonindex1
ON [Production].[Product](ProductNumber, Name)

CREATE PROCEDURE usp_Insert_Product
(
	@ProductID int,
	@Name nvarchar(50),
	@ProductNumber nvarchar(25),
	@MakeFlag bit,
	@FinishedGoodsFlag bit,
	@SafetyStockLevel smallint,
	@ReorderdPoint smallint,
	@StandardCost money,
	@ListPrice money,
	@DaysToManufacture int,
	@SellStartDate datetime,
	@rowguid uniqueidentifier,
	@ModifiedDate datetime


)
AS
BEGIN
	INSERT INTO Production.Product()
	VALUES()
END


alter PROCEDURE usp_ProdInv_Update1
(
	@ProductID int,
	@LocationID int,
	@Quantity int output
)
AS
BEGIN
	SELECT @Quantity = COUNT(1)
	FROM [Production].[ProductInventory]
	WHERE ProductID=@ProductID AND LocationID=@LocationID
END

declare @Quantity int;
exec usp_ProdInv_Update1 1, 2, @Quantity output
select  @Quantity

CREATE TRIGGER trg_Delete
ON  [Production].[Product] instead of delete
as begin
print 'jebi se'
rollback
end


CREATE VIEW view_ProductInventory AS
SELECT 	PM.Name AS 'Model',
	P.ProductNumber AS 'BrojProizvoda',
	P.Name AS 'Proizvod',
	P.ListPrice AS 'Cijena',
	ISNULL(L.Name, 'Nepoznata lokacija') AS 'Lokacija',
	ISNULL(PIN.Quantity, 0) AS 'Kolicina'
FROM 	Production.ProductModel AS PM JOIN Production.Product AS P 
		ON PM.ProductModelID = P.ProductModelID
	 		LEFT JOIN Production.ProductInventory AS PIN 
	 		ON P.ProductID = PIN.ProductID
	 			LEFT JOIN Production.Location AS L 
	 			ON PIN.LocationID = L.LocationID
GO

create login borkiPC
with password='borki123',
default_database = Pripremi

CREATE USER BORKI FOR LOGIN borkiPC

grant execute on usp_ProdInv_Update to BORKI

grant read_only on Pripremi to BORKI

backup database Pripremi
TO DISK='default'

CREATE TABLE #trig
(
	ProductID int,
	LocationID int,
	ShelfOld nvarchar(10),
	BinOld tinyint,
	QuantityOld smallint,
	rowguid uniqueidentifier,
	ModifiedDateOld datetime,
	
	Korisnik nvarchar(50),
	Komanda nvarchar(10),
	Datum Datetime
)

CREATE TRIGGER tr_Product_Insert
ON [Production].[Product] AFTER INSERT AS
INSERT INTO #trig (ProductID, LocationID, ShelfOld,BinOld,QuantityOld,rowguid,
					ModifiedDateOld, Korisnik, Komanda, Datum)
		SELECT i.ProductID, i.LocationID,i.Shelf, i.Bin, i.Quantity, i.rowguid, i.ModifiedDate,
				SYSTEM_USER, 'insert', GETDATE()
		FROM inserted AS i