--1
CREATE DATABASE BrojIndexa
GO

USE BrojIndexa
GO


CREATE TABLE Klijenti(
	KlijentID INT NOT NULL IDENTITY (1,1) CONSTRAINT PK_KlijentiID PRIMARY KEY,
	Ime NVARCHAR (30) NOT NULL,
	Prezime NVARCHAR (30) NOT NULL,
	Telefon NVARCHAR (20) NOT NULL,
	Mail NVARCHAR (50) NOT NULL UNIQUE,
	BrojRacuna NVARCHAR (15) NOT NULL,
	KorisnickoIme NVARCHAR (20) NOT NULL,
	Lozinka NVARCHAR (20) NOT NULL,
);

CREATE TABLE Transakcije(
	TransakcijaID INT NOT NULL IDENTITY (1,1) CONSTRAINT PK_TransakcijaID PRIMARY KEY,
	Datum DATETIME NOT NULL,
	Datum2  as DATEPART(YEAR,Datum) persisted,
	TipTransakcije NVARCHAR(30) NOT NULL,
	PosiljalacID INT NOT NULL CONSTRAINT FK_KlijentPosiljalac FOREIGN KEY REFERENCES Klijenti(KlijentID),
	PrimalacID INT NOT NULL CONSTRAINT FK_KlijentPrimalac FOREIGN KEY REFERENCES Klijenti(KlijentID),
	Svrha NVARCHAR(50) NOT NULL,
	Iznos DECIMAL NOT NULL
);
--2
INSERT INTO Klijenti (Ime, Prezime, Telefon,Mail,BrojRacuna,KorisnickoIme, Lozinka)
SELECT TOP 10 P.FirstName, P.LastName, PH.PhoneNumber,EA.EmailAddress,SC.CardNumber, P.FirstName+'.'+P.LastName,RIGHT(PP.PasswordHash,8)
FROM AdventureWorks2017.Person.Person AS P INNER JOIN AdventureWorks2017.Person.PersonPhone AS PH
ON P.BusinessEntityID=PH.BusinessEntityID INNER JOIN AdventureWorks2017.Person.EmailAddress AS EA
ON P.BusinessEntityID=EA.BusinessEntityID INNER JOIN AdventureWorks2017.Sales.PersonCreditCard AS CC
ON P.BusinessEntityID=CC.BusinessEntityID INNER JOIN AdventureWorks2017.Sales.CreditCard AS SC
ON CC.CreditCardID=SC.CreditCardID INNER JOIN AdventureWorks2017.Person.Password AS PP
ON P.BusinessEntityID=PP.BusinessEntityID

SELECT *
FROM Transakcije

INSERT INTO Transakcije(Datum, TipTransakcije, PosiljalacID, PrimalacID, Svrha, Iznos)
VALUES ('2011-05-31 00:00:00.000', 'TipTansakcije1', 1,2,'Svrha1', 10 )

INSERT INTO Transakcije(Datum, TipTransakcije, PosiljalacID, PrimalacID, Svrha, Iznos)
VALUES ('2011-06-20 00:00:00.000', 'TipTansakcije1', 2,3,'Svrha2', 20 )

INSERT INTO Transakcije(Datum, TipTransakcije, PosiljalacID, PrimalacID, Svrha, Iznos)
VALUES ('2011-07-15 00:00:00.000', 'TipTansakcije3', 3,4,'Svrha3', 15 )

INSERT INTO Transakcije(Datum, TipTransakcije, PosiljalacID, PrimalacID, Svrha, Iznos)
VALUES ('2011-01-01 00:00:00.000', 'TipTansakcije1', 4,2,'Svrha4', 100 )

INSERT INTO Transakcije(Datum, TipTransakcije, PosiljalacID, PrimalacID, Svrha, Iznos)
VALUES ('2010-02-12 00:00:00.000', 'TipTansakcije3', 3,2,'Svrha2', 10 )

INSERT INTO Transakcije(Datum, TipTransakcije, PosiljalacID, PrimalacID, Svrha, Iznos)
VALUES ('2012-04-30 00:00:00.000', 'TipTansakcije1', 5,2,'Svrha1', 10 )

INSERT INTO Transakcije(Datum, TipTransakcije, PosiljalacID, PrimalacID, Svrha, Iznos)
VALUES ('2011-10-08 00:00:00.000', 'TipTansakcije4', 5,3,'Svrha3', 37 )

INSERT INTO Transakcije(Datum, TipTransakcije, PosiljalacID, PrimalacID, Svrha, Iznos)
VALUES ('2013-07-13 00:00:00.000', 'TipTansakcije1', 7,8,'Svrha1', 70 )

INSERT INTO Transakcije(Datum, TipTransakcije, PosiljalacID, PrimalacID, Svrha, Iznos)
VALUES ('2015-09-12 00:00:00.000', 'TipTansakcije1', 8,7,'Svrha1', 40 )

INSERT INTO Transakcije(Datum, TipTransakcije, PosiljalacID, PrimalacID, Svrha, Iznos)
VALUES ('2015-05-01 00:00:00.000', 'TipTansakcije4', 9,10,'Svrha1', 120 )

--3

CREATE NONCLUSTERED INDEX ix_Klijenti
ON Klijenti(Ime, Prezime)
INCLUDE (BrojRacuna);

SELECT K.Ime, K.Prezime
FROM Klijenti AS K INNER JOIN Transakcije AS T
ON K.KlijentID=T.PosiljalacID
WHERE K.BrojRacuna LIKE '333%'

ALTER INDEX ix_Klijenti ON Klijenti
DISABLE

--4
CREATE PROCEDURE usp_Klijenti_Insert
(
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
	INSERT INTO Klijenti
	VALUES(@Ime,@Prezime,@Telefon,@Mail,@BrojRacuna,@KorisnickoIme,@Lozinka)
END

EXEC usp_Klijenti_Insert    'Emir',
							'Jahic',
							'123456789',
							'EMIRJAHOC@gmail.com',
							'1111116789',
							'emir.jahic',
							'Emir123'


--5

CREATE VIEW v_Klijenti_Transakcije
AS 
SELECT T.Datum AS 'Datum Transakcije', T.TipTransakcije AS 'Tip Transakcije',
		(SELECT K.Ime + ' ' + K.Prezime
		WHERE K.KlijentID=T.PosiljalacID) AS 'Posiljaoc',
		(SELECT K.BrojRacuna
		WHERE K.KlijentID=T.PosiljalacID) AS 'Br. Racuna Posiljaoca',
		T.Svrha AS 'Svrha',
		T.Iznos AS 'Iznos Transakcije',
		(SELECT Ime + ' ' + Prezime
		FROM Klijenti
		WHERE KlijentID=T.PrimalacID) AS 'Primaoc',
		(SELECT BrojRacuna
		FROM Klijenti
		WHERE KlijentID=T.PrimalacID) AS 'Br. Racuna primaoica'
FROM Klijenti AS K INNER JOIN Transakcije AS T
ON K.KlijentID=T.PosiljalacID


SELECT *
FROM v_Klijenti_Transakcije

--6
Alter PROCEDURE usp_BrRacuna_Select
(
	@BrojRacuna NVARCHAR(15)
)
AS
BEGIN
	SELECT *
	FROM v_Klijenti_Transakcije
	WHERE v_Klijenti_Transakcije.[Br. Racuna Posiljaoca]=@BrojRacuna OR v_Klijenti_Transakcije.[Br. Racuna primaoica]=@BrojRacuna
END

EXEC usp_BrRacuna_Select '77776007284266'

--7

SELECT YEAR(Datum), SUM(Iznos)
 FROM Transakcije
 GROUP BY YEAR(Datum)
 ORDER BY YEAR(Datum)



--8
CREATE PROCEDURE usp_Delete_Klijent1
(
	@KlijentID INT
)
AS
BEGIN
	DELETE FROM Transakcije
	WHERE PrimalacID=@KlijentID OR PosiljalacID=@KlijentID
	DELETE FROM Klijenti
	WHERE KlijentID=@KlijentID
END


--create view cw_Melisa
--as select * from Transakcije where PosiljalacID = 1
--union
--select * from Transakcije where PrimalacID = 1

--select *
--from cw_Melisa

EXEC usp_Delete_Klijent 2

--9

ALTER PROCEDURE usp_Racun_Prezime
(
	@BrojRacuna NVARCHAR(15)=NULL,
	@Prezime NVARCHAR(30)= NULL
)
AS
BEGIN
	SELECT *
	FROM v_Klijenti_Transakcije
	WHERE ([Br. Racuna Posiljaoca]=@BrojRacuna OR @BrojRacuna IS NULL) AND (RIGHT([Posiljaoc],LEN([Posiljaoc])-CHARINDEX(' ',[Posiljaoc]))=@Prezime OR @Prezime IS NULL)
END

EXEC usp_Racun_Prezime 

--10
BACKUP DATABASE BrojIndexa TO
DISK ='DEFAULT'
GO

BACKUP DATABASE BrojIndexa TO
DISK ='DEFAULT' WITH DIFFERENTIAL
GO