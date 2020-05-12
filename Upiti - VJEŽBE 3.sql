USE [AdventureWorks2012]
GO

/*1. Kreirati poruku dobrodošlice za kupce u sljedeæem formatu:
Dobrodošli Ime + Prezime, trenutno vrijeme je 11:20
Upit raditi na dva naèina, koristeæi funkcije za rad sa stringovima i datumima.
*/

SELECT 'Dobrodosli '+ PP.FirstName +' ' + PP.LastName + ', trenutno vrijeme je: ' , CONVERT(VARCHAR(8), GETDATE(),108)
FROM [Person].[Person] AS PP 
JOIN Sales.Customer AS SC 
ON PP.[BusinessEntityID]=SC.[PersonID]

/*2. Kreirati korisnièke podatke za kupce: korisnièko ime i lozinku. 
Korisnièko ime kreirati koristeæi mail adresu (sve do znaka @), a lozinku koristeæi kolonu PasswordHash 
(preskoèiti prvih 5 karaktera i uzeti narednih 8, te ukoliko se pojavljuje karakter '+', zamijeniti ga sa '#'). 
Korisnièke podatke kreirati samo za kupce koji imaju unesenu titulu a titula je 'Mr.'*/

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

/*3. Prikazati poèetak i kraj prodaje proizvoda, takoðer, u listu ukljuèiti i ukupno trajanje prodaje u mjesecima. Uslovi su: 
da je kraj prodaje proizvoda unesen i da naziv proizvoda poèinje sa L ili M, a završava sa L. */

SELECT[Name], [SellStartDate] AS 'Poèetak prodaje',[SellEndDate] AS 'Kraj prodaje', DATEDIFF(month,[SellStartDate],[SellEndDate]) AS 'Trajanje prodaje u mjesecima'
FROM[Production].[Product]
WHERE  [SellEndDate] IS NOT NULL AND [Name] LIKE '[LM]%l'

/*4. Prikazati broj narudžbe, broj dana do isporuke, ukupan iznos i naèin dostave. 
Kolonu naèin dostave ispisati malim slovima s tim da je poèetno slovo veliko. 
Ukupan iznos narudžbe treba biti izmeðu 200 i 1000.*/

SELECT SS.[SalesOrderNumber], DATEDIFF(day,SS.OrderDate,SS.[ShipDate]) AS 'Broj dana do ispouke', 
SS.TotalDue, SUBSTRING(PSM.Name,0,2)+LOWER(SUBSTRING(PSM.Name,2,30))
FROM [Sales].[SalesOrderHeader] AS SS
Join [Purchasing].[ShipMethod] AS PSM
ON SS.[ShipMethodID]=PSM.[ShipMethodID]
WHERE SS.TotalDue BETWEEN 200 AND 1000
ORDER BY SS.TotalDue desc

/*5. Prikazati 10 najskupljih stavki narudžbe (ID stavke, cijena, kolièina, ukupno). 
Kolonu ukupno (izraèunata kolona) zaokružiti na preciznost od dvije decimale. 
Takoðer, potrebno je formatirati izlaz kolona cijena, kolièina i ukupno. Koristiti sljedeæe formate:
	Cijena: 100.20 KM
	Kolièina: 3 kom.
	Ukupno: 300.60 KM
*/

SELECT TOP 10 [UnitPrice]AS Cijena,[OrderQty] AS Kolièina,ROUND([LineTotal],2) AS Ukupno,[SalesOrderID] AS IDnarudzbe
FROM[Sales].[SalesOrderDetail]








