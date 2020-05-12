CREATE DATABASE IB130266

USE IB130266

/*2.	U Vašoj bazi podataka kreirati tabele sa sljedeæim parametrima:
•	Studenti
•	StudentID, automatski generator vrijednosti i primarni kljuè
•	BrojDosijea, polje za unos 10 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
•	Ime, polje za unos 35 UNICODE karaktera (obavezan unos)
•	Prezime, polje za unos 35 UNICODE karaktera (obavezan unos)
•	Godina studija, polje za unos cijelog broja (obavezan unos)
•	NacinStudiranja, polje za unos 10 UNICODE karaktera (obavezan unos) DEFAULT je Redovan
•	Email, polje za unos 50 karaktera (nije obavezan)  
•	Nastava
•	NastavaID, automatski generator vrijednosti i primarni kljuè
•	Datum, polje za unos datuma i vremana (obavezan unos)
•	Predmet, polje za unos 20 UNICODE karaktera (obavezan unos)
•	Nastavnik, polje za unos 50 UNICODE karaktera (obavezan unos)
•	Ucionica, polje za unos 20 UNICODE karaktera (obavezan unos)
•	Prisustvo
•	PrisustvoID, automatski generator vrijednosti i primarni kljuè
•	StudentID, spoljni kljuè prema tabeli Studenti
•	NastavaID, spoljni kljuè prema tabeli Nastava

3.	Kreirati tabelu Predmeti sa sljedeæim parametrima:
•	PredmetID, automatski generator vrijednosti i primarni kljuè
•	Naziv, polje za unos 30 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
*/

CREATE TABLE Studenti (
StudentID INT IDENTITY(1,1) PRIMARY KEY not null,
BrojDosijea NVARCHAR(10) UNIQUE not null,
Ime NVARCHAR(35) not null,
Prezime NVARCHAR(35) not null,
GodinaStudija NVARCHAR (10) not null,
NacinStudiranja NVARCHAR(10) DEFAULT 'Redovan' not null,
Email NVARCHAR (50))

CREATE TABLE Nastava(
NastavaID INT IDENTITY(1,1) PRIMARY KEY not null,
Datum DATETIME not null,
Predmet NVARCHAR (20) not null,
Nastavnik NVARCHAR ( 50) not null,
Ucionica NVARCHAR (20) not null)

CREATE TABLE Prisustvo(
PrisustvoID INT IDENTITY(1,1) PRIMARY KEY not null,
StudentID INT FOREIGN KEY (StudentID) REFERENCES Studenti(StudentID) not null,
NastavaID INT FOREIGN KEY (NastavaID) REFERENCES Nastava(NastavaID) not null)

CREATE TABLE Predmeti(
PredmetID INT IDENTITY(1,1) PRIMARY KEY not null,
Naziv NVARCHAR (30) UNIQUE not null)

/*Modifikovati tabelu Nastava (ukloniti kolonu Predmet) i povezati je sa tabelom Predmeti. 
Koristeæi INSERT komandu u tabelu Predmeti unijeti tri zapisa.

4.	Koristeæi bazu podataka AdventureWorksLT2012 i tabelu SalesLT.Customer, preko INSERT i 
SELECT komande importovati 10 zapisa u tabelu Studenti i to sljedeæe kolone:
•	Prva tri karaktera kolone Phone -> BrojDosijea
•	FirstName -> Ime
•	LastName -> Prezime
•	2 -> GodinaStudija
•	DEFAULT -> NacinStudiranja
•	EmailAddress -> Email
*/

ALTER TABLE Nastava
DROP COLUMN Predmet

alter table Studenti
drop column GodinaStudija

Alter table Studenti
add GodinaStudija INT not null


ALTER TABLE Nastava
ADD PredmetID INT FOREIGN KEY (PredmetID) REFERENCES Predmeti(PredmetID)

INSERT INTO Predmeti
VALUES ('Uvod u baze podataka'),
('Sistemi za upravljanje bazama'),
('Programiranje 1')

INSERT INTO Studenti
VALUES 
('IB130266','Sejla','Ramovic',DEFAULT, 'sejla@live.com',2),
('IB130163','Elmar','Fazlagic',DEFAULT,'elmar@live.com',2),
('IB130164','Anur','Becir',DEFAULT,'anur@live.com',2),
('IB130165','Asim','Hajd',DEFAULT,'asim@live.com',2),
('IB130167','Lamija','Borcak',DEFAULT,'lamija@live.com',2)

/*5.	U Vašoj bazi podataka kreirajte stored proceduru koja æe na osnovu proslijeðenih 
parametara raditi izmjenu (UPDATE) podataka u tabeli Studenti. Proceduru pohranite pod nazivom usp_Studenti_Update. 
Koristeæi prethodno kreiranu proceduru izmijenite jedan zapis sa Vašim podacima.*/

CREATE PROCEDURE usp_Studenti_Update
@StudentID INT,
@BrojDosijea NVARCHAR (10),
@Ime NVARCHAR (30),
@Prezime NVARCHAR (30),
@NacinStudiranja NVARCHAR ( 10),
@Email NVARCHAR (50),
@GodinaStudija INT
AS
BEGIN
UPDATE Studenti
SET BrojDosijea=@BrojDosijea
WHERE StudentID=@StudentID

UPDATE Studenti
SET Ime=@Ime
WHERE StudentID=@StudentID

UPDATE Studenti
SET Prezime=@Prezime
WHERE StudentID=@StudentID

UPDATE Studenti
SET NacinStudiranja=@NacinStudiranja
WHERE StudentID=@StudentID

UPDATE Studenti
SET Email=@Email
WHERE StudentID=@StudentID

UPDATE Studenti
SET GodinaStudija=@GodinaStudija
WHERE StudentID=@StudentID

END

EXEC usp_Studenti_Update 3,'IB123456', 'Lejla','Ramovic', 'Redovan','lejla@live.com',3


