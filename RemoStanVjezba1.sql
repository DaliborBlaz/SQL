USE IB150161
go

INSERT INTO Klijenti(Ime,Prezime,Telefon,Mail,BrojRacuna,KorisnickoIme,Lozinka)
SELECT CONVERT(NVARCHAR(30),PP.FirstName),CONVERT(NVARCHAR(30),PP.LastName),PPP.PhoneNumber,PEA.EmailAddress,CONVERT(NVARCHAR(10),SC.AccountNumber),CONVERT(NVARCHAR(20),(PP.FirstName+'.'+PP.LastName)),RIGHT(CONVERT(NVARCHAR(MAX),PAS.PasswordHash),8)
FROM AdventureWorks2017.Person.Person AS PP JOIN AdventureWorks2017.Sales.Customer AS SC
ON PP.BusinessEntityID=SC.PersonID JOIN AdventureWorks2017.Person.PersonPhone AS PPP
ON PP.BusinessEntityID=PPP.BusinessEntityID JOIN AdventureWorks2017.Person.EmailAddress AS PEA
ON PP.BusinessEntityID=PEA.BusinessEntityID JOIN AdventureWorks2017.Person.Password AS PAS
ON PP.BusinessEntityID=PAS.BusinessEntityID

SELECT *
FROM Klijenti
ORDER BY BrojRacuna
where KlijentID=1 OR KlijentID=2 
INSERT INTO Transakcije(Datum, TipTransakcije,PosiljalacID,PrimalacID,Svrha,Iznos)
VALUES('2018-12-22','Uplata', 852, 924,'Poklon',300),
		('2018-10-02','Uplata', 844, 925,'Plata',124),
		('2018-12-22','Uplata', 891, 976,'Regres',33),
		('2018-12-22','Uplata', 5229, 5345,'Poklon',241),
		('2018-12-22','Uplata', 5237, 5340,'Regres',30740),
		('2018-12-22','Uplata', 5234, 5348,'Putarina',324),
		('2018-12-22','Uplata', 5240, 12524,'Stipendija',3921),
		('2018-12-22','Uplata', 5312, 12531,'Plata',3323),
		('2018-12-22','Uplata', 5309, 12533,'Poklon',1212),
		('2018-12-22','Uplata', 5311, 12566,'Stipendija',921)


CREATE NONCLUSTERED INDEX ix_KlijentiImePrezime
ON Klijenti(Ime, Prezime)
INCLUDE (BrojRacuna)

SELECT Ime,Prezime,BrojRacuna
FROM Klijenti
WHERE Ime like '[MAS]%' AND Prezime like '[LBR]%' 

ALTER INDEX ix_KlijentiImePrezime ON Klijenti DISABLE
GO

CREATE PROCEDURE usp_InsertKlijenti
(
	@KlijentID INT,
	@Ime NVARCHAR(30),
	@Prezime NVARCHAR(30),
	@Telefon NVARCHAR(20),
	@Mail NVARCHAR(50),
	@BrojRacuna NVARCHAR(15),
	@KorisnickoIme NVARCHAR(20),
	@Lozinka NVARCHAR(20)
)
AS
BEGIN
	INSERT INTO Klijenti(KlijentID,Ime,Prezime,Telefon,Mail,BrojRacuna,KorisnickoIme,Lozinka)
	SELECT @KlijentID,@Ime, @Prezime,@Telefon,@Mail,@BrojRacuna,@KorisnickoIme,@Lozinka
END

SET IDENTITY_INSERT Klijenti ON

EXEC usp_InsertKlijenti 1, 'Remo', 'Omer', '061233133', 'remoomer@gmail.com', '123431123', 'omer.remo', 'lozninka'
EXEC usp_InsertKlijenti 2, 'Make', 'Omer', '061233133', 'MaketheKita@gmail.com', '123431123', 'omer.remo', 'lozninka'

SET IDENTITY_INSERT Klijenti OFF

 Kreirati view sa sljedećom definicijom. Objekat treba da prikazuje datum transakcije, tip transakcije, ime i prezime pošiljaoca (spojeno),
  broj računa pošiljaoca, ime i prezime primaoca (spojeno), broj računa primaoca, svrhu i iznos transakcije.  

  Alter VIEW vw_PosiljaocPrimaocTransakcija AS
  SELECT T.Datum AS 'Datum Transakcije', 
		T.TipTransakcije AS Tip, 
		(SELECT K.Ime +' '+K.Prezime
		FROM Klijenti AS K
		WHERE T.PosiljalacID=K.KlijentID) AS Posiljaoc,
		(SELECT BrojRacuna
		FROM Klijenti AS K
		WHERE T.PosiljalacID=K.KlijentID)AS RacunPosiljaoca,
		(SELECT K.Ime +' '+K.Prezime
		FROM Klijenti AS K
		WHERE T.PrimalacID=K.KlijentID) AS Primalac,
		(SELECT BrojRacuna
		FROM Klijenti AS K
		WHERE T.PosiljalacID=K.KlijentID)AS RacunPrimaoca,
		T.Svrha AS Svrha,
		T.Iznos
  FROM Transakcije AS T


Alter PROCEDURE usp_SearchBrojRacuna
(
	@BrojRacuna NVARCHaR(15)
)
AS
BEGIN
SELECT *
FROM [dbo].[vw_PosiljaocPrimaocTransakcija]
WHERE [RacunPosiljaoca] = @BrojRacuna
END


EXEC usp_SearchBrojRacuna 'AW00029487'


SELECT *
From [dbo].[vw_PosiljaocPrimaocTransakcija]


Kreirati upit koji prikazuje sumaran iznos svih transakcija po godinama, sortirano po godinama. U rezultatu upita prikazati samo dvije kolone: 
kalendarska godina i ukupan iznos transakcija u godini.  

INSERT INTO Transakcije(Datum, TipTransakcije,PosiljalacID,PrimalacID,Svrha,Iznos)
VALUES('2018-12-22','Uplata', 852, 924,'Poklon',300),
		('2018-10-02','Uplata', 844, 925,'Plata',124),
		('2017-12-22','Uplata', 891, 976,'Regres',33),
		('2017-12-22','Uplata', 5229, 5345,'Poklon',241),
		('2017-12-22','Uplata', 5237, 5340,'Regres',30740),
		('2016-12-22','Uplata', 5234, 5348,'Putarina',324),
		('2016-12-22','Uplata', 5240, 12524,'Stipendija',3921),
		('2015-12-22','Uplata', 5312, 12531,'Plata',3323),
		('2015-12-22','Uplata', 5309, 12533,'Poklon',1212),
		('2013-12-22','Uplata', 5311, 12566,'Stipendija',921)

SELECT YEAR(Datum), SUM(Iznos)
FROM Transakcije
GROUP BY YEAR(Datum)


 CREATE PROCEDURE usp_ObrisiKlijenta
 (
	@KlijentID INT
 )
 AS
 BEGIN
 DELETE FROM Transakcije
 WHERE PosiljalacID=@KlijentID OR PrimalacID=@KlijentID

 DELETE FROM Klijenti
 WHERE KlijentID=@KlijentID
 END


 select * from Transakcije
 
 exec usp_ObrisiKlijenta 852

  
  ALTER PROCEDURE usp_SearchByBrojRacunaOrPrezime
  (
	@BrojRacuna NVARCHAR(15)=NULL,
	@Prezime NVARCHAR(30)=NULL
  )
  AS
  BEGIN
  SELECT [Datum Transakcije],[Tip],[Posiljaoc],[RacunPosiljaoca],[Primalac],[RacunPrimaoca],[Svrha],[Iznos]
  FROM [dbo].[vw_PosiljaocPrimaocTransakcija]
  WHERE (SUBSTRING([Posiljaoc],(CHARINDEX(' ',[Posiljaoc])),50) like @Prezime OR @Prezime IS NULL) AND ([RacunPosiljaoca]=@BrojRacuna OR @BrojRacuna IS NULL)
  END



EXEC usp_SearchByBrojRacunaOrPrezime @BrojRacuna=NULL, @Prezime=NULL


EXEC usp_SearchByBrojRacunaOrPrezime @BrojRacuna='AW00029487'

BACKUP DATABASE IB150161 TO
DISK='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\IB150161.bak'

BACKUP DATABASE IB150161 TO
DISK='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\IB150161log.bak'
WITH DIFFERENTIAL
USE master

DROP DATABASE IB150161

RESTORE DATABASE IB150161 
FROM DISK='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\IB150161.bak'
WITH REPLACE 
use master


CREATE DATABASE Baza123
ON PRIMARY
(
	NAME='Baza123',
	FILENAME='C:\data\Baza123.mdf',
	SIZE=10MB,
	MAXSIZE=UNLIMITED,
	FILEGROWTH=10%
),
(
	NAME='Baza123_sek',
	FILENAME='C:\data\Baza123_sek.ndf',
	SIZE=10MB,
	MAXSIZE=UNLIMITED,
	FILEGROWTH=10%
)
LOG ON
(
	NAME='Baza123_log',
	FILENAME='C:\data\Baza123.ldf',
	SIZE=10MB,
	MAXSIZE=UNLIMITED,
	FILEGROWTH=10%
)
Use Baza123
create table Klijenti
(
	KlijentID INT IDENTITY(1,1) CONSTRAINT PK_KlijentID PRIMARY KEY,
	Ime NVARCHAR(50) not null,
	Prezime NVARCHAR(50) not null,
	Drzava NVARCHAR(50) not null,
	Grad NVARCHAR(50) not null,
	Email NVARCHAR(50) not null,
	Telefon NVARCHAR(50) not null
)
Create table Izleti
(
	IzletID INT IDENTITY(1,1) CONSTRAINT PK_IzletID PRIMARY KEY,
	Naziv NVARCHAR(100) NOT NULL,
	DatumPolaska DATE NOT NULL,
	DatumPovratka DATE NOT NULL,
	Cijena Decimal not null,
	Opis NVARCHAR(MAX)
)
create table Prijave
(
	KlijentID INT CONSTRAINT FK_Klijent_Prijave FOREIGN KEY (KlijentID) REFERENCES Klijenti(KlijentID),
	IzletID INT CONSTRAINT FK_Izlet_Prijave FOREIGN KEY (IzletID) REFERENCES Izleti(IzletID),
	CONSTRAINT PK_KlijentID_IzletID PRIMARY KEY (KlijentID,IzletID),
	Datum DATE NOT NULL,
	BrojOdraslih INT NOT NULL,
	BrojDjece INT NOT NULL
)


INSERT INTO Klijenti
SELECT  P.FirstName, P.LastName, CR.Name, PA.City, EA.EmailAddress, PHO.PhoneNumber
FROM AdventureWorks2017.Person.Person AS P JOIN AdventureWorks2017.Sales.SalesPerson AS SP
ON P.BusinessEntityID=SP.BusinessEntityID JOIN AdventureWorks2017.Person.BusinessEntityAddress AS BEA
ON P.BusinessEntityID=BEA.BusinessEntityID JOIN AdventureWorks2017.Person.Address AS PA
ON BEA.AddressID=PA.AddressID JOIN AdventureWorks2017.Person.StateProvince AS PSP
ON PA.StateProvinceID=PSP.StateProvinceID JOIN AdventureWorks2017.Person.CountryRegion AS CR
ON PSP.CountryRegionCode=CR.CountryRegionCode JOIN AdventureWorks2017.Person.EmailAddress AS EA
ON P.BusinessEntityID=EA.BusinessEntityID JOIN AdventureWorks2017.Person.PersonPhone AS PHO
ON P.BusinessEntityID=PHO.BusinessEntityID

INSERT INTO Izleti
VALUES ('Zlaca','2018-6-16','2018-6-18', 50, 'Gori Hala na Zlaci Idemo ludo idemo jako'),
		('Jahorina','2017-01-6','2017-01-10', 230, 'Gori Hala na Jahorini Idemo ludo idemo jako'),
		('Herceg Novi','2016-7-17','2016-7-29', 250, 'Gori Hala U Herceg Novom Idemo ludo idemo jako')


Kreirati uskladištenu proceduru za unos nove prijave. Proceduri nije potrebno proslijediti parametar Datum. Datum se uvijek postavlja na trenutni. Koristeći kreiranu proceduru u tabelu Prijave dodati 10 prijava.



CREATE PROCEDURE usp_Insert_Prijava
(
	@KlijentID INT,
	@IzletID INT,
	@BrojOdraslih INT,
	@BrojDjece INT
)
AS
BEGIN
INSERT INTO Prijave(KlijentID, IzletID, Datum, BrojOdraslih, BrojDjece)
SELECT @KlijentID, @IzletID, GETDATE(), @BrojOdraslih, @BrojDjece
END

SELECT *
from Prijave

EXEC usp_Insert_Prijava 1,2,4,5
EXEC usp_Insert_Prijava 2,2,2,1
EXEC usp_Insert_Prijava 3,2,1,3
EXEC usp_Insert_Prijava 4,2,0,2
EXEC usp_Insert_Prijava 6,3,1,1
EXEC usp_Insert_Prijava 5,3,4,1
EXEC usp_Insert_Prijava 3,3,1,2
EXEC usp_Insert_Prijava 1,4,4,0
EXEC usp_Insert_Prijava 8,4,1,1
EXEC usp_Insert_Prijava 9,4,2,5
EXEC usp_Insert_Prijava 10,4,2,3

Kreirati index koji će spriječiti dupliciranje polja Email u tabeli Klijenti. Obavezno testirati ispravnost kreiranog indexa.

CREATE UNIQUE NONCLUSTERED  INDEX  UQ_EmailKlijent ON Klijenti(Email)



Svim izletima koji imaju više od 3 prijave cijenu umanjiti za 10%.


SELECT I.Cijena-(I.Cijena*0.1), I.Naziv
FROM Izleti AS I JOIN Prijave AS P
ON P.IzletID=I.IzletID
GROUP BY I.Cijena, I.Naziv
HAVING COUNT(P.KlijentID)>3

Kreirati view (pogled) koji prikazuje podatke o izletu: šifra, naziv, datum polaska, datum povratka i cijena, te ukupan broj prijava na izletu, ukupan broj putnika, ukupan broj odraslih i ukupan broj djece. 
Obavezno prilagoditi format datuma (dd.mm.yyyy).

CREATE VIEW vw_Izlet AS
SELECT I.Naziv AS Naziv, 
		CONVERT(nvarchar(10), CAST(I.DatumPolaska AS DATE),104) AS DatumPolaska,
		CONVERT(nvarchar(10), CAST(I.DatumPovratka AS DATE),104)  AS DatumPovratka,
		I.Cijena AS Cijena,
		COUNT(P.KlijentID) AS BrojPrijava,
		SUM(P.BrojOdraslih) AS BrojOdraslih,
		SUM(P.BrojDjece) AS BrojDjece,
		SUM(P.BrojOdraslih)+SUM(P.BrojDjece) AS UkupnoPutnika
FROM Izleti as I JOIN Prijave as P
ON I.IzletID=P.IzletID
GROUP BY Naziv, DatumPolaska, DatumPovratka, Cijena

a) Kreirati tabelu IzletiHistorijaCijena u koju je potrebno pohraniti identifikator izleta kojem je cijena izmijenjena, datum izmjene cijene, staru i novu cijenu. Voditi računa o tome da se jednom izletu može više puta mijenjati cijena te svaku izmjenu treba zapisati u ovu tabelu.

b) Kreirati trigger koji će pratiti izmjenu cijene u tabeli Izleti te za svaku izmjenu u prethodno kreiranu tabelu pohraniti podatke izmijeni.

c) Za određeni izlet (proizvoljno) ispisati sljdedeće podatke: naziv izleta, datum polaska, datum povratka, trenutnu cijenu te kompletnu historiju izmjene cijena tj. datum izmjene, staru i novu cijenu.

CREATE TABLE IzletiHistorijaCijena
(
	IzletiHistorijaCijenaID INT IDENTITY(1,1) CONSTRAINT PK_IzletiHistorijaCijenaID PRIMARY KEY,
	IzletID int,
	Datum Date,
	StaraCijena decimal,
	NovaCijena decimal,
)


CREATE TRIGGER tr_Update_Izlet
 ON Izleti AFTER UPDATE AS
 INSERT INTO IzletiHistorijaCijena
 SELECT d.IzletID,
		GETDATE(),
		d.Cijena,
		i.Cijena
FROM DELETED as d JOIN INSERTED as i
on d.IzletID=i.IzletID

UPDATE Izleti
SET Cijena=11212
WHERE IzletID=4


SELECT * 
FROM IzletiHistorijaCijena


SELECT I.Naziv, I.DatumPolaska, I.Cijena, H.StaraCijena, H.Datum
FROM Izleti as I JOIN IzletiHistorijaCijena As H
ON I.IzletID=H.IzletID
WHERE I.IzletID=2

CREATE TRIGGER tr_delete_Izlet
 ON Izleti INSTEAD OF DELETE AS
 INSERT INTO IzletiHistorijaCijena
 SELECt
		GETDATE(),
FROM DELETED as d JOIN INSERTED as i
on d.IzletID=i.IzletID
PRINT 'NE ME RE'
ROLLBACK


UPDATE Izleti
SET Cijena=11212
WHERE IzletID=4


DELETE FROM Izleti
WHERE IzletID=2

SYSTEM_USER()

Kroz SQL kod napraviti bazu podataka koja nosi ime vašeg broja dosijea, a zatim u svojoj bazi podataka kreirati tabele sa sljedećom strukturom:
Klijenti
Ime, polje za unos 50 karaktera (obavezan unos)
Prezime, polje za unos 50 karaktera (obavezan unos)
Grad, polje za unos 50 karaktera (obavezan unos)
Email, polje za unos 50 karaktera (obavezan unos)
Telefon, polje za unos 50 karaktera (obavezan unos)
Racuni
DatumOtvaranja, polje za unos datuma (obavezan unos)
TipRacuna, polje za unos 50 karaktera (obavezan unos)
BrojRacuna, polje za unos 16 karaktera (obavezan unos)
Stanje, polje za unos decimalnog broja (obavezan unos)
Transakcije 
Datum, polje za unos datuma i vremena (obavezan unos)
Primatelj polje za unos 50 karaktera –  (obavezan unos)
BrojRacunaPrimatelja, polje za unos 16 karaktera (obavezan unos)
MjestoPrimatelja, polje za unos 50 karaktera (obavezan unos)
AdresaPrimatelja, polje za unos 50 karaktera (nije obavezan unos)
Svrha, polje za unos 200 karaktera (nije obavezan unos)
Iznos, polje za unos decimalnog broja (obavezan unos)
Napomena: Klijent može imati više otvorenih računa, dok se svaki račun veže isključivo za jednog klijenta. Sa računa klijenta se provode transakcije, dok se svaka pojedinačna transakcija provodi sa jednog računa.

create database IB123456
go
