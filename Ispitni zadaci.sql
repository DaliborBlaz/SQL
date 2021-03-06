/*1.Zadatak
Kreirati izvjestaj koji za svaku drzavu prikazuje sve njene regione i za svaki region koliko sadrži osoba. 
Uslov je da drzava mora imati dvije ili vise rijeci i da je broj osoba veci od 1000. 
Lista treba da bude poredano abecedno po broju osoba. (2 zapisa)*/

USE AdventureWorks
SELECT CR.Name AS Drzava, SP.Name AS Region, COUNT(A.StateProvinceID) AS BrojOsoba
FROM Person.CountryRegion AS CR INNER JOIN Person.StateProvince AS SP
			ON SP.CountryRegionCode = CR.CountryRegionCode
				INNER JOIN Person.Address AS A
					ON SP.StateProvinceID = A.StateProvinceID
WHERE CR.Name LIKE '% %'
GROUP BY CR.Name, SP.Name
	HAVING COUNT(A.StateProvinceID) > 1000
ORDER BY BrojOsoba

/*2.Zadatak
Kreirati izvjestaj za tri najstarija zaposlenika koji su napravili najveci broj narudzi. 
Izvjestaj treba da sadrzi ime, prezime zaposlenika, broj telefona, datum rodjenja, 
broj uradjenih narudzbi i trenutni broj godina zaposlenika (racunati preko kolone BirthDate).(3 zapisa)*/

USE Northwind
SELECT TOP(3) E.FirstName AS Ime, E.LastName AS Prezime, E.HomePhone AS Telefon, E.BirthDate AS DatumRodjenja,
COUNT(O.OrderID) AS BrojNarudjbi, DATEDIFF(YEAR,E.BirthDate, GETDATE()) AS BrojGodina
FROM dbo.Employees AS E INNER JOIN dbo.Orders AS O
			ON E.EmployeeID = O.EmployeeID
GROUP BY E.FirstName, E.LastName, E.BirthDate, E.HomePhone
ORDER BY BrojGodina DESC

/*3.Zadatak (Tekst bi trebao biti ovako otprilike.)
Kreirati email i lozinku kupcima koji su zenskog spola i koje su udate. 
Email adresu kreirati uz pomoc tabele Person.Contact. 
Email adresa treba da izgleda prezime.ime + ime domene koje treba uzeti iz polja EmailAddress. 
Lozinku kreirati na sljedeci nacin: 
spojiti FirstName sa rowguid iz HumanResources.Employee tabele (prilikom spajanja preskociti 8 znakova 
i uzeti sljedecih 8) i LastName kolonu dodati. Cijeli ovaj string okrenuti od zadnjeg prema prvom. 
Od stringa cijelog preskociti 2 znaka i uzeti narednih 12. Cijeli string treba da bude velikim slovima.  
Gdje god u lozinki ima znak - (crtica) zamijeniti ga sa malim slovom x.(49. zapisa)*/

USE AdventureWorks
SELECT PC.LastName + '.' + PC.FirstName + RIGHT(PC.EmailAddress, 20) AS Email,
REPLACE(UPPER(SUBSTRING(REVERSE(PC.FirstName + SUBSTRING(CONVERT(VARCHAR(36),HRE.rowguid),8,8) + PC.LastName), 2,12)), '-', 'X') AS Lozinka
FROM Person.Contact AS PC INNER JOIN HumanResources.Employee AS HRE
		ON PC.ContactID = HRE.ContactID
WHERE HRE.Gender = 'F' AND HRE.MaritalStatus = 'M'

/*4.Zadatak
Kreirati bazu kroz GUI.*/

/*5. Zadatak
Kreiranje tabela Studenti i StudentiDBMS kroz kod*/

CREATE TABLE Studenti 
(
	IDStudent INT IDENTITY (1,1) PRIMARY KEY,
	Ime NVARCHAR(20) NOT NULL,
	Prezime NVARCHAR(20) NOT NULL,
	Indeks NVARCHAR(6) NOT NULL,
	DatumUpisa DATETIME DEFAULT '2009.9.10'
)

CREATE TABLE StudentiDBMS
(
	IDStudentDBMS INT IDENTITY (1,1) PRIMARY KEY,
	IDStudent INT NOT NULL FOREIGN KEY (IDStudent) REFERENCES dbo.Studenti(IDStudent),
	Aplikacija NVARCHAR(30) NOT NULL,
	Komanda NVARCHAR (100) NOT NULL,
	Korisnik NVARCHAR (30) NOT NULL,
	ImeBaze NVARCHAR (20) NOT NULL
)

/*6.Zadatak
Upisati u tabelu Studenti dvije proizvoljne vrijednosti */

INSERT INTO dbo.Studenti (Ime, Prezime, Indeks, DatumUpisa)
VALUES ('Anes','Lozo','2007','2007.9.15')

INSERT INTO dbo.Studenti (Ime, Prezime, Indeks, DatumUpisa)
VALUES ('Senad','Lozo','2129','2008.9.15')

/*7. Zadatak
U zadatku 7 je bila Jasminova baza StudentiLogDW. Importovati kroz GUI sve podatke iz baze StudentiLogDW 
tabela dbo.podaci u tabelu temp. koji su se desili izmeðu 15 i 16.06.2009 i koji su ostvareni web 
browserima IE 7.0 ili Opera (4300 zapisa).*/ 

/*8.Zadatak
Iz predhodno kreirane tabele temp sve podatke pomocu INSERT SELECT prebaciti u tabelu StudentiDBMS*/

INSERT INTO dbo.StudentiDBMS
SELECT Aplikacija, Komanda, Korisnik, ImeBaze
FROM temp

/*9.Zadatak
Iz tabele Studenti izbrisati jedan zapis*/

DELETE FROM dbo.Studenti
WHERE Ime LIKE 'Anes'

/*10.Zadatak
Kreirati korisnika ispit tako sto cete mapirati login sa servera pod nazivom dbmsKorisnik. 
Jedina premisija koju korisnik gost moze imati jeste SELECT*/

USE [Test]
CREATE USER [ispit] 
FOR LOGIN [BUILTIN\Users]
GRANT SELECT ON [dbo].[Studenti] TO [ispit]
GRANT SELECT ON [dbo].[StudentiDBMS] TO [ispit]

/*11.Zadatak
Kreirati diferencijalni backup vase baze podataka na default lokaciji*/

BACKUP DATABASE [Test] TO 
DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\TestBackup.bak'

BACKUP DATABASE [Test] TO 
DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\TestBackupDiff.bak'
WITH DIFFERENTIAL

/* PARCIJALNI
Zadaci iz prvog parcijalnog su bili: 1, 2 i 4 sa I parcijalnog su isti kao kao na integralnom 1, 2 i 3 zadatak,
5. Zadatak
Kreiranje baze kroz kod.*/

CREATE DATABASE [Baza] ON  PRIMARY 
	(NAME = N'Baza', 
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\Baza.mdf', 
	SIZE = 3072KB, 
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 1024KB),
	
	(NAME = N'Baza_sek', 
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\Baza_sek.ndf', 
	SIZE = 3072KB, 
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 1024KB)

LOG ON 
	(NAME = N'Baza_log', 
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\Baza_log.ldf' , 
	SIZE = 1024KB, 
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10%)
	
/*6. Zadatak 
Je bio nesto slicno ovom 10. sa integralnog
(Kreirati korisnika ispit tako sto cete mapirati login sa servera pod nazivom dbmsKorisnik. 
Jedina premisija koju korisnik gost moze imati jeste SELECT)*/

USE [Test]
CREATE USER [ispit] 
FOR LOGIN [BUILTIN\Users]
GRANT SELECT ON [dbo].[Studenti] TO [ispit]
GRANT SELECT ON [dbo].[StudentiDBMS] TO [ispit]

/*3. Zadatak
Naci zaposlenike koji su imali ukupan broj narudzbi manji od 80. 
Upit treba da sadrzi: Ime i prezime zaposlenika, broj telefona, godina rodjenja (izdvojiti samo godinu iz kolone BirthDate), 
trenutni broj godina zaposlenika (racunati preko kolone BirthDate), ukupni broj narudzbi i grad zaposlenika. (4 zapisa)*/

USE Northwind
SELECT E.FirstName AS Ime, E.LastName AS Prezime, E.HomePhone AS Telefon, YEAR(E.BirthDate) AS GodRodjenja,
DATEDIFF(YEAR,E.BirthDate, GETDATE()) AS TrenBrGod, COUNT(O.OrderID) AS UKUPNO, E.City AS Grad
FROM dbo.Employees AS E INNER JOIN dbo.Orders AS O
		ON E.EmployeeID = O.EmployeeID
GROUP BY E.FirstName, E.LastName, E.HomePhone, E.BirthDate, E.City
	HAVING COUNT(O.OrderID) < 80

/*ISPITNI ZADACI
1.Zadatak
Koristeci bazu podataka AdvantureWorks prikazati listu proizvoda sa sljedecim podacima za svaki proizvod. 
Minimalnu i maksimalnu kolicinu narucenih proizvoda. Takodze, izlaz treba da ima: ukupan broj stavki 
(narudzbi iz tabele) i ukupnu sumu svih narudzbi za pojedini proizvod. Uslov je da je  maksimalna 
kolicina narucenih proizvoda veca od 9 i cijena narucenog proizvoda veca od 2000. (6 zapisa)!*/

USE AdventureWorks
SELECT P.Name, MIN(S.OrderQty) AS Minimalno, MAX(S.OrderQty) AS Maksimalno, COUNT(S.OrderQty)AS UkupanBrStavki,
SUM(S.OrderQty) AS UKUPNO, S.UnitPrice
FROM Production.Product AS P INNER JOIN Sales.SalesOrderDetail AS S
		ON P.ProductID = S.ProductID
GROUP BY P.Name, S.UnitPrice
	HAVING MAX(S.OrderQty)>9 AND S.UnitPrice > 2000

/*2.Zadatak
Koristeci bazu podataka AdvantureWorks, prikazati listu koja sadrzli sljedece elemente: 
ime i prezime kupca zajedno sa gradom, drzavom i kantonima (teritorijom) iz koje dolaze.  
izlaz treba da sadrzi ukupan broj narudzbi za svakog kupca i to samo onih gdje je taj broj veci od 10. 
Lista treba da bude poredana abecedno po teritorijama i broju narudzbi(od vece prema manjoj). (35 zapisa)!*/

USE AdventureWorks
SELECT PC.FirstName, PC.LastName, PA.City, PCR.Name AS Drzava, SST.[Group] AS Kontinent, COUNT (SSOH.SalesOrderID) AS 'Ukupno'
FROM Person.Contact AS PC INNER JOIN Sales.Individual AS SI 
		ON PC.ContactID=SI.ContactID
		INNER JOIN Sales.Customer AS SC 
			ON SI.CustomerID=SC.CustomerID
			INNER JOIN Sales.CustomerAddress AS SCA 
				ON SC.CustomerID=SCA.CustomerID
				INNER JOIN Person.Address AS PA 
					ON SCA.AddressID=PA.AddressID
					INNER JOIN Sales.SalesOrderHeader as SSOH 
						ON SC.CustomerID=SSOH.CustomerID
						INNER JOIN Person.StateProvince AS PSP 
							ON PA.StateProvinceID=PSP.StateProvinceID
							INNER JOIN Person.CountryRegion AS PCR 
								ON PSP.CountryRegionCode=PCR.CountryRegionCode
								INNER JOIN Sales.SalesTerritory AS SST 
									ON SC.TerritoryID=SST.TerritoryID						
GROUP BY PC.FirstName, PC.LastName, PA.City, PCR.Name,SST.[Group]
HAVING COUNT (SSOH.SalesOrderID) > 10
ORDER BY SST.[Group], COUNT(SSOH.SalesOrderID) DESC

/*3. Zadatak
Direktor firme AdvantureWorks, zeli da sazna kolika je ukupna zarada od deset najskupljih artikala
(preko list price kolone). Izlazni izvjestaj treba da sadrzi: ID proizvoda, ime i prezime, 
list price i ukupnu zaradu od prodaje svakog proizvoda posebno. Baza podataka AdvantudeWorks. (8 zapisa)!*/		

USE AdventureWorks
SELECT TOP(8) P.ProductID, P.Name, P.ListPrice, SUM(S.LineTotal) AS UKUPNO
FROM Production.Product AS P INNER JOIN Sales.SalesOrderDetail AS S
		ON P.ProductID = S.ProductID
GROUP BY P.ProductID, P.Name, P.ListPrice
ORDER BY P.ListPrice DESC

/*4. Zadatak
U vasu bazu podataka, kroz GUI, importovati sve zapise iz baze podataka UZORAK tabele dbo.podaci, 
u tabelu dbo.temp sa slijedecim parametrima (prvo napisite upit koji trazi podatke pa onda tek isti iskoristite u import postupku); 
Pronaci korisnika koji je svoje komande pisao u SGL Queri Analyzer alatu i nisu se izvrsile duze od 2000 milisekundi. 
Uslov je da su zapocete i izvrsene u 4 mjesecu. Takodze uslov je da su iste izvrese nad bazom Nortwind.(65 zapisa)! 
Kao polaznu osnovu uzmite slijedecu komandu:

SELECT TOP 100 Komanda, Aplikacija, Korisnik, Trajanje, Pocetak, Kraj, ImeBaze FROM podaci*/

/*5.Zadatak
Vaša kompanija želi nagraditi one zaposlenike koji su napravili najveæi broj narudžbi. 
Nagrada se treba uruèiti na njihov roðendan. Prvi korak jeste kreiranje spiska zaposlenika sa: 
imenom i prezimenom (spojeno), brojem telefona, datumom roðenja i ukupnim brojem odraðenih narudžbi (po zaposleniku). 
Jedan od uslova jeste da se na listi naðu zaposlenici koji su rodeni poslije 01.01.1963. Baza Northwind (3 zapisa).*/

USE Northwind
SELECT E.FirstName + ' ' + E.LastName, E.HomePhone, E.BirthDate, COUNT(O.OrderID) AS UKUPNO
FROM dbo.Employees AS E INNER JOIN dbo.Orders AS O
		ON E.EmployeeID = O.EmployeeID
GROUP BY E.FirstName, E.LastName, E.HomePhone, E.BirthDate
	HAVING E.BirthDate > '01.01.1963'
ORDER BY UKUPNO DESC

/*6.Zadatak
Vaša kompanija pokreće postupak dodjele email adresa. U tom postupku želi iskoristit postojeæe podatke iz tabela 
Orders i Customers (NorthWind). Email adresa treba da bude u dljedeæem obliku 
prva dva slova od ShipCity + CustomerID + prva dva slova od ShipCountry + @fit.ba (sve mala slova). 
Adrese se trebaju formirati samo onim kupcima koji su iz USA i žive u gradu Seattle ili imaju popounjeno polje Fax. 
U obzir dodjele adrese ulaze i kupci iz Kanade. Vodite raèuna da se u tabeli Orders više puta ponavljaju zapisi o istim kupcima. 
To može dovesti do toga da se jedna adresa generiše više puta. Vaš upit treba da izdvoji jedinstvene vrijednosti bez 
ponavljanja i na izlazu pored kolone email treba imati i ShipCountry i ShipCity. (67 zapisa).*/

USE Northwind
SELECT DISTINCT LOWER(SUBSTRING(O.ShipCity,1,2) + C.CustomerID + SUBSTRING(O.ShipCountry,1,2) + '@fit.ba') AS Email, O.ShipCountry, 
O.ShipCity
FROM dbo.Customers AS C INNER JOIN dbo.Orders AS O
		ON C.CustomerID = O.CustomerID
WHERE (C.Country = 'USA'AND C.City = 'Seattle') OR C.Fax IS NOT NULL OR C.Country = 'Canada'

/*7. Zadatak
Marketing odjel od Vas traži izvještaj o proizvodima iz kojeg se vidi ime proizvoda, kolika je cijena po komadu 
(datog proizvoda) koliko jedinica ima u zalihama, a koliko je komada prodato. Uslovi su da izvještaj obuhvati samo 
kategoriju Beverages i da je cijena komada tih proizvoda veæa od 49. Baza podataka Northwind (1 zapis).*/

USE Northwind
SELECT P.ProductName, P.UnitPrice, P.UnitsInStock, SUM(O.Quantity) AS Prodato
FROM dbo.Products AS P INNER JOIN [dbo].[Order Details] AS O
			ON P.ProductID = O.ProductID
				INNER JOIN dbo.Categories AS C
					ON P.CategoryID = C.CategoryID
WHERE C.CategoryName = 'Beverages' AND O.UnitPrice > 49
GROUP BY P.ProductName, P.UnitPrice, P.UnitsInStock

/*8. Zadatak
Na kraju godine Vaša firma želi da nagradi kupce koji su imali najvše narudžbi u toku godine. 
Kako se nagrade dijele po regionima ove godine došao je red na kupce United Kindom. 
Jedan od zahtjeva jeste da su svi iz Londona, da nemaju unesenu sekundarnu adresu i da je zadnja izmjena 
u tabeli Adress bila 09.01.2002. Izlazni izvještaj treba da sadrži: prezime kupca, ukupan broj narudžbi za 
datog kupca sa ukupnim brojem svih kupljenih proizvoda, grad iz kojeg dolazi kupac, sekundarnu adresu i 
datum izmjene adrese. Baza podataka AdventureWorksLT. (2 zapisa)*/

USE AdventureWorksLT
SELECT C.LastName, COUNT(SOH.SalesOrderID), SUM(SOD.OrderQty), A.City, A.AddressLine2, A.ModifiedDate, A.CountryRegion
FROM SalesLT.Customer AS C INNER JOIN SalesLT.SalesOrderHeader AS SOH
		ON C.CustomerID = SOH.CustomerID
					INNER JOIN SalesLT.Address AS A
						ON SOH.ShipToAddressID = A.AddressID
							INNER JOIN SalesLT.SalesOrderDetail AS SOD
								ON SOH.SalesOrderID = SOD.SalesOrderID
WHERE A.CountryRegion='United Kingdom' AND A.City='London' AND A.AddressLine2 IS NULL AND A.ModifiedDate='09.01.2002'
GROUP BY C.LastName, A.City, A.CountryRegion, A.AddressLine2, A.ModifiedDate

/*9.Zadatak
Analiza je pokazala da grad Redmond ima najvecu prodaju. Vasa kompanija zeli utvrditi koji su to 
zaposlenici ostvarili tako dobar rezultat (broj narudzbi). Prvi korak jeste kreiranje spiska zaposlenika sa: 
imenom, prezimenom, brojem telefona, godina rodjenja(potrebno je izdvojiti samo godinu iz atributa BirthDate), 
ukupnim brojem uradjenih narudzbi (po zaposleniku) i gradom zaposlenika. Baza Northwinnd (1 zapis)*/

USE Northwind
SELECT E.FirstName, E.LastName, E.HomePhone, YEAR(E.BirthDate), COUNT(O.OrderID), E.City
FROM dbo.Employees AS E INNER JOIN dbo.Orders AS O
		ON E.EmployeeID = O.EmployeeID
GROUP BY E.FirstName, E.LastName, E.HomePhone, E.City, E.BirthDate
	HAVING E.City = 'Redmond'

/*10. Zadatak
Vaša kompanija pokreèe postupak dodjele email adresa i lozinki svojim kupcima. 
U tom postupku želi iskoristiti postojeæe podatke iz tabele SalesLT.customers  (AdwentureWorksLT). 
Email adresa treba da bude u slijedeæem formatu prezime.ime+ime domene koje trebate uzeti iz polja 
EmailAdress iste tabele tj.uraditi ekstrakt samo tog dijela stringa. Takoðe potrebno je korisnicima 
dodjeliti lozinku po slijedeæem principu: Spojiti FirstName sa rowguid i lastname kolonom. 
Iz nastalog stringa preskoèiti prva 4  znaka i uzeti narednih 10 i to okrenuti od zadnjih prema prvom (reverzno) 
Pazite da prije spajanja sadrzaja kolone rowguid  treba konvertovati u nvarchar
Kao osnovu uzmite slijedeæi upit: (440 zapisa)

USE AdventureWorksLT
SELECT  C.firstname, C.lastname, C.emailaddress, C.rowguid 
FROM SalesLT.Custumers AS C*/

USE AdventureWorksLT
SELECT  C.LastName  + '.' + C.FirstName + RIGHT(C.EmailAddress,20) AS Email,
REVERSE(SUBSTRING((C.FirstName + CONVERT(NVARCHAR(36),C.rowguid)+ C.LastName),5,10)) AS Lozinka
FROM SalesLT.Customer AS C

/*11. Zadatak
Vaša kompanija želi nagraditi 3 zaposlenika koji su napravili najveæi broj narudžbi. 
Prvi korak je kreiranje spiska zaposlenika sa imenom, prezimenom. Brojem telefona, datumom roðenja, 
ukupnim brojem uraðenih narudbi po zaposleniku Zadnja kolona treba da sadrži polje sa trenutnim brojem 
godina svakog zaposlenika(raèunati preko polja BirthDate i neke funkcije) Jedini uslov je da ta.. 
budu starija od 40 godina. Baza nortwind (3 zapisa)*/

USE Northwind
SELECT TOP(3) E.FirstName, E.LastName, E.HomePhone, E.BirthDate, COUNT(O.OrderID) AS BrojNar, 
DATEDIFF(YEAR,E.BirthDate, GETDATE()) AS Godine 
FROM  dbo.Employees AS E INNER JOIN dbo.Orders AS O
		ON E.EmployeeID = O.EmployeeID
GROUP BY E.FirstName, E.LastName, E.HomePhone, E.BirthDate
	HAVING DATEDIFF(YEAR,E.BirthDate, GETDATE()) > 40
ORDER BY BrojNar DESC

/*12.Zadatak
Koristeæi bazu podataka pubs  prikazati listu zaposlenika (ime, prezime,…).. podacima za svakog zaposlenog. 
Minimalna, maksimalna ,srednja i ukupni broj… prodatih artikala (knjiga). Uslov su: ukupna prodaja mora biti 
veća od 200 I PROSJEK Od 25 (10 zapisa) */

USE pubs
SELECT E.fname, E.lname, MIN(S.qty) AS Minim, MAX(S.qty) AS Maks, AVG(S.qty) AS Sred, SUM(S.qty) AS UKUPNO
FROM dbo.employee AS E INNER JOIN dbo.publishers AS P
		ON E.pub_id=P.pub_id
			INNER JOIN dbo.titles AS T
				ON P.pub_id=T.pub_id
					INNER JOIN dbo.sales AS S
						ON T.title_id=S.title_id
GROUP BY E.fname, E.lname
	HAVING SUM(S.qty)>200 AND AVG(S.qty)>25

/*13.Zadatak
Koristeæi bazu Adwentureworks  listu koja sadrži elemente: Ime dobavljaèa proizvoda, ime proizvoda koji-e prodaje, 
minimalnu i maksimalnu kolièinu narudžbe, kolièinu koja je u fazi narudžbe,  boju proizvoda  i broj dana  dana potrebnih 
za proizvodnju datog proizvoda. Uslovi su slijedeæi: Imena proizvoda treba da poèinju sa slovom F i završavaju sa brojem 8 
ili da poèinju sa slovom ... Takoðe maksimalna kolièina narudžbe treba biti 1000, mora imati odreðen broj artikala u  
fazi narudžbe i da je boja proizvoda siva / crna (1 zapis)  */

USE AdventureWorks
SELECT V.Name AS Dobavljc, P.Name AS Proizvod, PV.MinOrderQty, PV.MaxOrderQty, PV.OnOrderQty, P.Color, P.DaysToManufacture
FROM Purchasing.Vendor AS V INNER JOIN Purchasing.ProductVendor AS PV
		ON V.VendorID = PV.VendorID
			INNER JOIN Production.Product AS P
				ON PV.ProductID=P.ProductID
WHERE P.Name LIKE 'F%8' AND PV.MaxOrderQty =1000 AND P.Color = 'Black' OR P.Color='Silver'
				 
/*14. Zadatak
Na kraju godine vaða firma želi da nagradi kupce koji su imali najviše narudžbi u toku godine. 
Kako se nagrade dijele po regionima, ove godine došao je red na kupce iz United Kingdom .Jedan od zahtjeva 
jeste da su svi iz Londona i da nemaju sekundarnu adresu. Izlazni izvještaj treba da sadrži prezime kupca, 
ukupan broj  narudžbi za datog kupca, sa ukupnim brojem svih kupljenih proizvoda, grad iz kjeg dolazi kupac i 
sekundarnu adresu. Baza podataka AdwentureWorksLT (2 zapisa)*/

USE AdventureWorksLT
SELECT C.LastName, COUNT(SOH.SalesOrderID) AS UkupnoNarudjbi, SUM(SOD.OrderQty) AS SviKupProiz, A.City, A.AddressLine2
FROM SalesLT.Customer AS C INNER JOIN SalesLT.SalesOrderHeader AS SOH
		ON C.CustomerID = SOH.CustomerID
					INNER JOIN SalesLT.Address AS A
						ON SOH.ShipToAddressID = A.AddressID
							INNER JOIN SalesLT.SalesOrderDetail AS SOD
								ON SOH.SalesOrderID = SOD.SalesOrderID
WHERE A.CountryRegion='United Kingdom' AND A.City='London' AND A.AddressLine2 IS NULL
GROUP BY C.LastName, A.City, A.AddressLine2