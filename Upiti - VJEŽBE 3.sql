USE [AdventureWorks2012]
GO

/*1. Kreirati poruku dobrodo�lice za kupce u sljede�em formatu:
Dobrodo�li Ime + Prezime, trenutno vrijeme je 11:20
Upit raditi na dva na�ina, koriste�i funkcije za rad sa stringovima i datumima.
*/

SELECT 'Dobrodosli '+ PP.FirstName +' ' + PP.LastName + ', trenutno vrijeme je: ' , CONVERT(VARCHAR(8), GETDATE(),108)
FROM [Person].[Person] AS PP 
JOIN Sales.Customer AS SC 
ON PP.[BusinessEntityID]=SC.[PersonID]

/*2. Kreirati korisni�ke podatke za kupce: korisni�ko ime i lozinku. 
Korisni�ko ime kreirati koriste�i mail adresu (sve do znaka @), a lozinku koriste�i kolonu PasswordHash 
(presko�iti prvih 5 karaktera i uzeti narednih 8, te ukoliko se pojavljuje karakter '+', zamijeniti ga sa '#'). 
Korisni�ke podatke kreirati samo za kupce koji imaju unesenu titulu a titula je 'Mr.'*/

SELECT  PP.Title AS Titula, SUBSTRING(PE.EmailAddress, 0,CHARINDEX('@', PE.EmailAddress)) AS 'Korisnicko ime',
REPLACE(SUBSTRING (PW.[PasswordHash],6,8),'+','#') AS 'Lozinka'
FROM [Person].[Person] AS PP 
JOIN Sales.Customer AS SC 
ON PP.[BusinessEntityID]=SC.[PersonID]
JOIN [Person].[EmailAddress] AS PE
ON PP.BusinessEntityID=PE.[BusinessEntityID]
JOIN  [Person].[Password] AS PW
ON PP.BusinessEntityID = PW.[BusinessEntityID]
WHERE PP.Title LIKE '%Mr.%'

/*3. Prikazati po�etak i kraj prodaje proizvoda, tako�er, u listu uklju�iti i ukupno trajanje prodaje u mjesecima. Uslovi su: 
da je kraj prodaje proizvoda unesen i da naziv proizvoda po�inje sa L ili M, a zavr�ava sa L. */

SELECT[Name], [SellStartDate] AS 'Po�etak prodaje',[SellEndDate] AS 'Kraj prodaje', DATEDIFF(month,[SellStartDate],[SellEndDate]) AS 'Trajanje prodaje u mjesecima'
FROM[Production].[Product]
WHERE  [SellEndDate] IS NOT NULL AND [Name] LIKE '[LM]%l'

/*4. Prikazati broj narud�be, broj dana do isporuke, ukupan iznos i na�in dostave. 
Kolonu na�in dostave ispisati malim slovima s tim da je po�etno slovo veliko. 
Ukupan iznos narud�be treba biti izme�u 200 i 1000.*/

SELECT SS.[SalesOrderNumber], DATEDIFF(day,SS.OrderDate,SS.[ShipDate]) AS 'Broj dana do ispouke', 
SS.TotalDue, SUBSTRING(PSM.Name,0,2)+LOWER(SUBSTRING(PSM.Name,2,30))
FROM [Sales].[SalesOrderHeader] AS SS
Join [Purchasing].[ShipMethod] AS PSM
ON SS.[ShipMethodID]=PSM.[ShipMethodID]
WHERE SS.TotalDue BETWEEN 200 AND 1000
ORDER BY SS.TotalDue desc

/*5. Prikazati 10 najskupljih stavki narud�be (ID stavke, cijena, koli�ina, ukupno). 
Kolonu ukupno (izra�unata kolona) zaokru�iti na preciznost od dvije decimale. 
Tako�er, potrebno je formatirati izlaz kolona cijena, koli�ina i ukupno. Koristiti sljede�e formate:
	Cijena: 100.20 KM
	Koli�ina: 3 kom.
	Ukupno: 300.60 KM
*/

SELECT TOP 10 [UnitPrice]AS Cijena,[OrderQty] AS Koli�ina,ROUND([LineTotal],2) AS Ukupno,[SalesOrderID] AS IDnarudzbe
FROM[Sales].[SalesOrderDetail]








