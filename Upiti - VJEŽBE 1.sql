USE Northwind
GO
 /*1.  Prikazati listu zaposlenika sa sljedeæim atributima: ID, ime, prezime i titulu, gdje je ID = 9 ili dolaze iz USA.
2.  Prikazati podatke o narudžbama koje su napravljene prije 19.07.1996. godine. Izlaz treba da sadrži sljedeæe kolone: 
broj narudžbe, datum narudžbe, id kupca, te grad.
3. Prikazati ime kompanije kupca i kontakt telefon i to samo onih koji u svome imenu posjeduju rijeè „Restaurant“. Ukoliko
 naziv kompanije sadrži karakter (-), kupce izbaciti iz rezultata upita.
4. Prikazati listu proizvoda èiji naziv poèinje slovima „S“ ili  „T“, ili je ID proizvoda = 46. Takoðer, lista treba da 
sadrži one proizvode èija je se cijena po komadu kreæe izmeðu 10 i 50. Upit napisati na dva naèina.
5. Prikazati dobavljaèe koji dolaze iz Španije ili Njemaèke a nemaju unesen broj faxa. Formatirati izlaz NULL vrijednosti. 
Upit napisati na dva naèina.
6. Prikazati naziv proizvoda i cijenu gdje je stanje na zalihama manje od naruèene kolièine. Takoðer, u rezultate upita 
ukljuèiti razliku izmeðu naruèene kolièine i stanja zaliha.
7. Prikazati stavke narudžbe (sve kolone) gdje je kolièina narudžbe bila veæa od 100 komada uz odobreni popust.
8. Prikazati proizvode èiji naziv ne poèinje slovima „S“ ili „L“, drugo slovo je nepoznato, a treæe slovo u nazivu je „A“ ili „C“. 
Koristiti wildcard karaktere.
*/

SELECT [EmployeeID], [FirstName],[LastName],[Title]
FROM [dbo].[Employees]
WHERE  [EmployeeID] = 9 OR [Country] = 'USA'

SELECT [OrderID], [OrderDate], [EmployeeID], [ShipCity]
FROM [dbo].[Orders]
WHERE  [OrderDate] < '07.19.1996'

SELECT[CompanyName], [Phone]
FROM[dbo].[Customers]
WHERE [CompanyName] LIKE '%Restaurant%' AND  [CompanyName] NOT LIKE '%-%'

SELECT [ProductID],[ProductName],[UnitPrice]
FROM[dbo].[Products]
WHERE[ProductName] LIKE '[ST]%' OR [ProductID] = 46 OR  [UnitPrice] BETWEEN 10 AND 50
ORDER BY [UnitPrice] desc

SELECT[CompanyName],[Country], ISNULL([Fax],'N/A')
FROM[dbo].[Suppliers]
WHERE [Country] LIKE 'Spain' OR [Country] LIKE 'Germany'

SELECT[ProductName],[UnitPrice], [UnitsInStock]-[UnitsOnOrder]
FROM[dbo].[Products]
WHERE[UnitsInStock]<[UnitsOnOrder]

SELECT *
FROM[dbo].[Order Details]
WHERE [Quantity]>100 AND [Discount]>0

SELECT[ProductName]
FROM[dbo].[Products]
WHERE/*[ProductName] NOT LIKE '[SL]%' AND */[ProductName] LIKE '[^SL]_[AC]%'
