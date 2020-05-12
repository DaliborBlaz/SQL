USE Northwind
GO

/*1. Kreirati upit koji prikazuje broj proizvoda po kategoriji te ukupnu koli�inu na zalihama.
 Uslov je da stanje na zalihama izme�u 300 i 500.
 Sortirati po broju proizvoda u kategoriji opadaju�im redoslijedom. */

 SELECT COUNT(P.ProductID) AS 'Broj proizvoda', C.CategoryName, SUM(P.UnitsInStock) AS 'Ukupna kolicina na zalihama'
 FROM [dbo].[Categories] AS C JOIN [dbo].[Products] AS P
 ON C.[CategoryID]=P.[CategoryID]
 GROUP BY C.CategoryName
 HAVING SUM(P.UnitsInStock) BETWEEN 300 AND 500

/*2. Prikazati naziv proizvoda i ukupnu zaradu od prodaje. 
Uslov je da naziv proizvoda po�inje slovom 'S' i da je zarada ve�a od 10.000. 
Sortirati po zaradi opadaju�im redoslijedom. Koristiti JOIN operator.*/

SELECT P.[ProductName], SUM(OD.UnitPrice*OD.Quantity) AS 'Ukupna zarada'
FROM[dbo].[Products] AS P JOIN [dbo].[Order Details] AS OD
ON P.[ProductID]=OD.ProductID
WHERE P.ProductName LIKE 'S%'
GROUP BY P.ProductName
HAVING SUM(OD.UnitPrice*OD.Quantity) >10000
ORDER BY [Ukupna zarada] desc

/*3. Deklarisati poruku u formatu:
�Po�tovani, �elimo Vam sretnu i uspje�nu novu godinu!
Nakon toga, u tekst ubaciti naziv dobavlja�a kojem se �alje poruka i to prije zareza u formatu:
Po�tovani NEKI DOBAVLJA�, �elimo...
*/

SELECT 'Po�tovani,',[ContactName],' �elimo Vam sretnu i uspije�nu novu godinu!'
FROM[dbo].[Suppliers]

/*4. Kompanija je odlu�ila da svojim zaposlenicima dodjeli mail adrese. 
Za tu svrhu �e se iskoristiti postoje�e podatke iz baze podataka. 
Izlaz treba biti u formatu tri nove kolone: Email, Lozinka i Starost. Uslovi su sljede�i:
-	Email se formira od podataka u kolonama: LastName, FirstName, 
City i to sljede�em formatu: LastName.Firstname@City.Com (sve malim slovima),
-	Lozinka se formira od podataka iz kolona: Notes, Title i Address na sljede�i na�in: 
Spajanjam kolona (Notes, Title i Address). 
Sljede�i korak jeste da se sadr�aj spajanja okrene obrnuto (npr. dbms2013 � 3102smbd). 
Nakon toga, iz dobivenog stringa, preska�emo prvih 20 karaktera i uzimamo sljede�ih 8. 
Na pojedinim mjestma �e se pojaviti razmak,  isti je potrebno zamjeniti sa znakom #,
-	Starost se formira na osnovu kolone BirthDate i trenutnog datuma.
Mail, lozinka i godine starosti se generi�u samo za one klijente koji imaju unesenu adresu. 
*/
SELECT LOWER(LastName+'.'+FirstName+'@'+City+'.com') AS Email,
REVERSE(SUBSTRING(REPLACE(CONVERT(NVARCHAR,[Notes])+[Title]+[Address], ' ', '#'),20,8)) AS Lozinka,
DATEDIFF(year,BirthDate,GETDATE()) AS Starost
FROM[dbo].[Employees]
WHERE [Address] IS NOT NULL

/*5. Va�a kompanija �eli saznati koji su to zaposlenici ro�eni u 7 mjesecu bilo 
koje godine s ciljem slanja �estitki i odgovaraju�uih poklona. Va� zadatak je da kreirate listu zaposlenika sa: 
�	imenom, prezimenom, brojem telefona i datumom ro�enja,
�	kreirati kolonu koja sadr�i podatak o ukupnom broju dana zaposlenja radnika u Va�oj kompaniji,
�	uslov je da su tra�eni zaposlenici imaju vi�e od 7000 dana sta�a.
*/

SELECT[FirstName], [LastName],[HomePhone],[BirthDate],
DATEDIFF(day,[HireDate],GETDATE()) AS 'Dani zaposlenja'
FROM[dbo].[Employees]
WHERE DATEDIFF(day,[HireDate],GETDATE())>7000 AND month(BirthDate)=7