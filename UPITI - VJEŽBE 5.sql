USE Northwind
GO

/*1. Kreirati upit koji prikazuje broj proizvoda po kategoriji te ukupnu kolièinu na zalihama.
 Uslov je da stanje na zalihama izmeðu 300 i 500.
 Sortirati po broju proizvoda u kategoriji opadajuæim redoslijedom. */

 SELECT COUNT(P.ProductID) AS 'Broj proizvoda', C.CategoryName, SUM(P.UnitsInStock) AS 'Ukupna kolicina na zalihama'
 FROM [dbo].[Categories] AS C JOIN [dbo].[Products] AS P
 ON C.[CategoryID]=P.[CategoryID]
 GROUP BY C.CategoryName
 HAVING SUM(P.UnitsInStock) BETWEEN 300 AND 500

/*2. Prikazati naziv proizvoda i ukupnu zaradu od prodaje. 
Uslov je da naziv proizvoda poèinje slovom 'S' i da je zarada veæa od 10.000. 
Sortirati po zaradi opadajuæim redoslijedom. Koristiti JOIN operator.*/

SELECT P.[ProductName], SUM(OD.UnitPrice*OD.Quantity) AS 'Ukupna zarada'
FROM[dbo].[Products] AS P JOIN [dbo].[Order Details] AS OD
ON P.[ProductID]=OD.ProductID
WHERE P.ProductName LIKE 'S%'
GROUP BY P.ProductName
HAVING SUM(OD.UnitPrice*OD.Quantity) >10000
ORDER BY [Ukupna zarada] desc

/*3. Deklarisati poruku u formatu:
„Poštovani, želimo Vam sretnu i uspješnu novu godinu!
Nakon toga, u tekst ubaciti naziv dobavljaèa kojem se šalje poruka i to prije zareza u formatu:
Poštovani NEKI DOBAVLJAÈ, želimo...
*/

SELECT 'Poštovani,',[ContactName],' želimo Vam sretnu i uspiješnu novu godinu!'
FROM[dbo].[Suppliers]

/*4. Kompanija je odluèila da svojim zaposlenicima dodjeli mail adrese. 
Za tu svrhu æe se iskoristiti postojeæe podatke iz baze podataka. 
Izlaz treba biti u formatu tri nove kolone: Email, Lozinka i Starost. Uslovi su sljedeæi:
-	Email se formira od podataka u kolonama: LastName, FirstName, 
City i to sljedeæem formatu: LastName.Firstname@City.Com (sve malim slovima),
-	Lozinka se formira od podataka iz kolona: Notes, Title i Address na sljedeæi naèin: 
Spajanjam kolona (Notes, Title i Address). 
Sljedeæi korak jeste da se sadržaj spajanja okrene obrnuto (npr. dbms2013 – 3102smbd). 
Nakon toga, iz dobivenog stringa, preskaèemo prvih 20 karaktera i uzimamo sljedeæih 8. 
Na pojedinim mjestma æe se pojaviti razmak,  isti je potrebno zamjeniti sa znakom #,
-	Starost se formira na osnovu kolone BirthDate i trenutnog datuma.
Mail, lozinka i godine starosti se generišu samo za one klijente koji imaju unesenu adresu. 
*/
SELECT LOWER(LastName+'.'+FirstName+'@'+City+'.com') AS Email,
REVERSE(SUBSTRING(REPLACE(CONVERT(NVARCHAR,[Notes])+[Title]+[Address], ' ', '#'),20,8)) AS Lozinka,
DATEDIFF(year,BirthDate,GETDATE()) AS Starost
FROM[dbo].[Employees]
WHERE [Address] IS NOT NULL

/*5. Vaša kompanija želi saznati koji su to zaposlenici roðeni u 7 mjesecu bilo 
koje godine s ciljem slanja èestitki i odgovarajuæuih poklona. Vaš zadatak je da kreirate listu zaposlenika sa: 
•	imenom, prezimenom, brojem telefona i datumom roðenja,
•	kreirati kolonu koja sadrži podatak o ukupnom broju dana zaposlenja radnika u Vašoj kompaniji,
•	uslov je da su traženi zaposlenici imaju više od 7000 dana staža.
*/

SELECT[FirstName], [LastName],[HomePhone],[BirthDate],
DATEDIFF(day,[HireDate],GETDATE()) AS 'Dani zaposlenja'
FROM[dbo].[Employees]
WHERE DATEDIFF(day,[HireDate],GETDATE())>7000 AND month(BirthDate)=7