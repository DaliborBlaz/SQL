/*1.	Kreirati bazu podataka koju �ete imenovati Va�im brojem dosijea.

2.	U Va�oj bazi podataka kreirati tabelu Proizvodi sa sljede�im kolonama:
�	ProizvodID, primarni klju� (automatski generator vrijednosti),
�	Naziv, polje za pohranu 30 karaktera (obavezan unos),
�	Cijena, polje za pohranu decimalnih brojeva (obavezan unos),
�	Zalihe, polje za pohranu cijelih brojeva (obavezan unos).
3.	Iz baze podataka AdventureWorks2014, u tabelu Proizvodi, prebaciti 5 najprodavanijih bicikala, i to sljede�e kolone:
�	Naziv bicikla (Name) -> Naziv
�	Cijena po komadu (ListPrice) -> Cijena,
�	Ukupna prodana koli�ina -> Zalihe.
4.	U Va�oj bazi podataka kreirati tabelu Narudzbe sa sljede�im kolonama:
�	NarudzbaID, primarni klju� (automatski generator vrijednosti),
�	Datum, polje za pohranu datuma i vremena (obavezan unos),
�	ProizvodID, spoljni klju� i referenca na tabelu Proizvodi,
�	Kolicina, polje za pohranu cijelih brojeva (obavezan unos).
*/

CREATE DATABASE IB130266

USE IB130266
GO

CREATE TABLE Proizvodi (
ProizvodID INT IDENTITY(1,1) PRIMARY KEY not null,
Naziv NVARCHAR(30) not null,
Cijena DECIMAL not null,
Zalihe INT not null)

CREATE TABLE Narudzbe (
NarudzbaID INT IDENTITY (1,1) PRIMARY KEY not null,
Datum DATETIME not null,
ProizvodID INT FOREIGN KEY (ProizvodID) REFERENCES Proizvodi(ProizvodID) not null,
Kolicina INT not null)

ALTER TABLE Narudzbe
ALTER COLUMN Datum DATETIME

INSERT INTO [IB130266].[dbo].[Proizvodi]
SELECT TOP 5 PP.Name, PP.ListPrice, SUM(SOD.OrderQty) AS 'Prodana koli�ina'
FROM [AdventureWorks2012].[Production].[Product] AS PP JOIN [AdventureWorks2012].[Production].[ProductSubcategory] AS PS
ON PP.ProductSubcategoryID=PS.ProductSubcategoryID JOIN [AdventureWorks2012].[Production].[ProductCategory] AS PC
ON PS.ProductCategoryID=PC.ProductCategoryID JOIN AdventureWorks2012.[Sales].[SalesOrderDetail] AS SOD
ON PP.ProductID=SOD.ProductID
WHERE PC.Name LIKE 'Bikes'
GROUP BY PP.Name, PP.ListPrice
ORDER BY SUM(SOD.OrderQty) DESC

/*5.	U Va�oj bazi podataka kreirajte stored proceduru koja �e slu�iti za unos narud�bi. 
Podatke je obavezno unijeti preko parametara. Tako�er, u istoj proceduri dodati a�uriranje 
polja Zalihe (tabela Proizvodi), u zavisnosti od naru�ene koli�ine. 
Proceduru pohranite pod nazivom usp_Narudzbe_Insert. Testirati ispravnost procedure.*/
GO
ALTER PROCEDURE usp_Narudzbe_Insert
@Datum DATETIME,
@ProizvodID INT,
@Kolicina INT
AS
BEGIN
INSERT INTO Narudzbe (Datum, ProizvodID, Kolicina)
VALUES (@Datum,@ProizvodID,@Kolicina)

UPDATE Proizvodi SET Zalihe= Zalihe-@Kolicina
WHERE ProizvodID=@ProizvodID
END

GO
EXEC usp_Narudzbe_Insert '2012-12-12 12:12:12:000' ,1,7

/*6.	U Va�oj bazi podataka kreirajte view (pogled) koji �e sadr�avati sve kolone iz 
tabele Proizvodi, te ukupnu naru�enu koli�inu iz tabele Narudzbe.
View pohranite pod nazivom view_Narudzbe_Ukupno.*/

GO
CREATE VIEW view_Narudzbe_Ukupno
AS
SELECT P.ProizvodID, P.Naziv, P.Cijena, P.Zalihe, N.Kolicina
FROM [dbo].[Proizvodi] AS P JOIN [dbo].[Narudzbe] AS N
ON P.ProizvodID=N.ProizvodID

SELECT * FROM view_Narudzbe_Ukupno

/*7.	U Va�oj bazi podataka kreirajte stored proceduru koja �e na osnovu proslije�enog 
parametra @Naziv prikazati naziv proizvoda, cijenu i ukupnu naru�enu koli�inu. 
U proceduri iskoristite prethodno kreirani view. 
Proceduru pohranite pod nazivom usp_Proizvodi_Narudzbe. Testirati ispravnost procedure.*/

GO
ALTER PROCEDURE usp_Proizvodi_Narudzbe
@Naziv NVARCHAR(30)
AS
SELECT Naziv,Cijena,Kolicina
FROM view_Narudzbe_Ukupno
WHERE Naziv=@Naziv

EXEC usp_Proizvodi_Narudzbe 'Mountain-200 Black, 38'


/*8.	U Va�oj bazi podataka kreirajte stored proceduru koja �e slu�iti za izmjenu podataka o proizvodu. 
Podatke je obavezno unijeti preko parametara. Proceduru pohranite pod nazivom usp_Proizvodi_Update. 
Testirati ispravnost procedure.*/

CREATE PROCEDURE usp_Proizvodi_Update
@ProizvodID INT,
@Naziv NVARCHAR(30),
@Cijena INT,
@Zalihe INT
AS 
BEGIN
UPDATE Proizvodi
SET Naziv=@Naziv
WHERE ProizvodID=@ProizvodID

UPDATE Proizvodi
SET Cijena=@Cijena
WHERE ProizvodID=@ProizvodID

UPDATE Proizvodi
SET Zalihe=@Zalihe
WHERE ProizvodID=@ProizvodID
END

EXEC usp_Proizvodi_Update 1, 'Biciklo',150,25

SELECT * FROM Proizvodi

/*
9.	U Va�oj bazi podataka kreirajte stored proceduru koja �e slu�iti za brisanje proizvoda. 
Proceduru pohranite pod nazivom usp_Proizvodi_Delete. Testirati ispravnost procedure.
*/

ALTER PROCEDURE usp_Proizvodi_Delete
@ProizvodID INT
AS
DELETE FROM Narudzbe
WHERE ProizvodID=@ProizvodID
DELETE FROM Proizvodi
WHERE ProizvodID=@ProizvodID

EXEC usp_Proizvodi_Delete 4

SELECT * FROM Proizvodi
SELECT * FROM Narudzbe

/*10.	U Va�oj bazi podataka kreirajte trigger koji �e sprije�iti brisanje proizvoda. 
Trigger pohraniti pod nazivom tr_Proizvodi_Delete. Testirati ispravnost triggera. */

GO
CREATE TRIGGER tr_Proizvodi_Delete
ON Proizvodi
INSTEAD OF DELETE
AS
PRINT ('Nema brisanja!')























