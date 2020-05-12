CREATE DATABASE Sejla ON PRIMARY (
NAME='Sejla',
FILENAME = 'D:\DBMS_Data',
SIZE = 5MB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 10% )

 LOG ON
(
NAME = 'Sekundarni',
FILENAME= 'D:\Log',
SIZE= 2MB,
MAXSIZE= UNLIMITED,
FILEGROWTH = 5%)

USE Sejla
GO


CREATE TABLE Edukatori (
EdukatorID INT IDENTITY(1,1) PRIMARY KEY (EdukatorID),
Ime NVARCHAR (20) NOT NULL, 
Prezime NVARCHAR (20) NOT NULL,
Titula NVARCHAR (5) NULL,
Email NVARCHAR (20) NULL,
Telefon NVArCHAR (15) NULL,
CV BINARY NULL,
Slika BINARY NULL )

CREATE TABLE Predmeti (
PredmetID INT IDENTITY (1,1) PRIMARY KEY (PredmetID),
Naziv NVARCHAR (30) NOT NULL,
Oznaka NVARCHAR (5) NULL,
ECTS INT NOT NULL )

CREATE TABLE EdukatoriPredmeti (
EdukatorID INT FOREIGN KEY (EdukatorID) REFERENCES Edukatori(EdukatorID),
PredmetID INT FOREIGN KEY (PredmetID) REFERENCES Predmeti (PredmetID), 
Zvanje NVARCHAR (10) NULL,
BrojSati  INT NULL )

CREATE TABLE Fakluteti (
FakultetID INT IDENTITY (1,1) PRIMARY KEY (FakultetID),
Naziv NVARCHAR (30) NOT NULL,
Telefon NVARCHAR (15) NULL, 
Fax NVARCHAR (15) NULL)

ALTER TABLE Edukatori
ADD FakultetID INT FOREIGN KEY (FakultetID) REFERENCES Fakluteti(FakultetID)

ALTER TABLE EdukatoriPredmeti 
ADD FakultetID INT FOREIGN KEY (FakultetID) REFERENCES Fakluteti(FakultetID)

ALTER TABLE Edukatori
ADD Adresa NVARCHAR (30) NULL

ALTER TABLE Predmeti
ALTER COLUMN Ects DECIMAL

/*
3. Kreirati stored proceduru za upis podataka u tabelu Edukatori. Takoðer, kreirati procedure 
za izmjenu i brisanje podataka u istoj tabeli. Koristeæi procedure za upis podataka u tabelu dodati 5 novih edukatora.
*/

CREATE PROCEDURE unos_podataka (
@Ime NVARCHAR (20), 
@Prezime NVARCHAR (20) ,
@Titula NVARCHAR (5),
@Email NVARCHAR (20) ,
@Telefon NVArCHAR (15),
@FakultetID INT,
@CV BINARY=NULL ,
@Slika BINARY = NULL,
@Adresa NVARCHAR (30) )

AS
INSERT INTO Edukatori (Ime, Prezime,Titula,Email,Telefon,FakultetID, CV,Slika,Adresa)
VALUES (@Ime,@Prezime,@Titula,@Email,@Telefon,@FakultetID,@CV,@Slika,@Adresa)

EXEC unos_podataka 'Sejla','Ramovic','Ms.','sejla@','062165909',1,NULL,NULL,'Sjeverni logor'
EXEC unos_podataka 'Lejla','Ramovic','Ms.','sejla@','062165909',1,NULL,NULL,'Sjeverni logor'
EXEC unos_podataka 'Dzejla','Ramovic','Ms.','sejla@','062165909',1,NULL,NULL,'Sjeverni logor'
EXEC unos_podataka 'Sinan','Ramovic','Ms.','sejla@','062165909',1,NULL,NULL,'Sjeverni logor'
EXEC unos_podataka 'Edita','Ramovic','Ms.','sejla@','062165909',1,NULL,NULL,'Sjeverni logor'

SELECT * FROM Edukatori

SELECT * FROM Fakluteti

INSERT INTO Fakluteti
VALUES('FIT','036222555','258369')

/*U tabele Predmeti i Fakulteti dodati po 5 zapisa. Takoðer, u tabelu EduktoriPredmeti 
dodati proizvoljne podatke (ko predaje odreðeni predmet, te na kojem fakultetu).*/

INSERT INTO Predmeti
VALUES('Uvod u baze podataka','UBP',7),
('Programiranje 1','PR1',8),
('Sociologija','SOC',2),
('Komunikacijske tehnologije', 'KT',6),
('Sport i zdravlje','SIZ',2)

INSERT INTO Fakluteti 
VALUES ('Masinski fakultet','0362656','54535435'),
('Nastavnicki fakultet','552345253','788424554'),
('PRirodno matematicki','555555','5566223'),
('Filozofski','55555','66352526'),
('Gradjevinski','48485566','5222363')

INSERT INTO EdukatoriPredmeti
VALUES(1,1,'Prof.',6,1),
(2,2,'Asistent',5,2),
(4,5,'Prof.',9,3)

/*
5. Kreirati pogled (View) koji obuhvata sljedeæe podatke: ime i prezime edukatora (spojeno), 
titula, oznaka predmeta, naziv predmeta, broj ECTS kredita, broj sati.
*/
GO
CREATE VIEW Spisak
AS
SELECT E.[Ime]+' '+E.Prezime AS 'ImePrezime',E.[Titula], P.Oznaka, P.Naziv, EP.BrojSati
FROM Edukatori AS E JOIN [dbo].[EdukatoriPredmeti] AS EP
ON E.[EdukatorID]=EP.EdukatorID JOIN[dbo].[Predmeti] AS P
ON EP.PredmetID = P.PredmetID

SELECT * FROM Spisak
/*6. Kreirati stored proceduru koja æe na osnovu proslijeðenog parametra NazivPredmeta 
prikazti nastavno osoblje angažovano na predmetu. 
Iskoristiti prethodno kreirani view.*/
GO
ALTER PROCEDURE OsobljeNaPredmetuu (
@Naziv NVARCHAR(30),
@ImePrezime NVARCHAR (40))
AS
SELECT *
FROM Spisak AS SP
WHERE @Naziv=SP.Naziv OR SP.ImePrezime=@ImePrezime

EXEC OsobljeNaPredmetuu 'Uvod u baze podataka','Sinan Ramovic'

/*Izmijeniti prethodno kreiranu stored proceduru tako da prima dva parametra:
 NazivPredmeta i ImePrezime edukatora. U zavisnosti od proslijeðenog/ih parametra,
 procedura treba da prikaže podatke o predmetima i nastavnom osoblju.*/

 /*
Koristeæi proceduru za brisanje zapisa u tabeli Edukatori (Zadatak 3) obrisati 2 edukatora. 
Ukoliko edukatori imaju dodijeljene predmete, modifikovati proceduru tako da prethodno obriše sve
 edukatoru dodijeljene predmete, a zatim obriše zapis iz tabele Edukatori.
*/
GO
CREATE PROCEDURE obrisatiEdukatora (
@Ime NVARCHAR (20))
AS
DELETE FROM EdukatoriPredmeti
FROM Edukatori AS E JOIN EdukatoriPredmeti AS EP
ON E.EdukatorID = EP.EdukatorID
WHERE E.Ime=@Ime
DELETE FROM Edukatori
WHERE Ime=@Ime

 EXEC obrisatiEdukatora 'Sejla'

 SELECT * FROM Edukatori