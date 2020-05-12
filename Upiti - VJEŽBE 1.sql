USE Northwind
GO
 /*1.  Prikazati listu zaposlenika sa sljede�im atributima: ID, ime, prezime i titulu, gdje je ID = 9 ili dolaze iz USA.
2.  Prikazati podatke o narud�bama koje su napravljene prije 19.07.1996. godine. Izlaz treba da sadr�i sljede�e kolone: 
broj narud�be, datum narud�be, id kupca, te grad.
3. Prikazati ime kompanije kupca i kontakt telefon i to samo onih koji u svome imenu posjeduju rije� �Restaurant�. Ukoliko
 naziv kompanije sadr�i karakter (-), kupce izbaciti iz rezultata upita.
4. Prikazati listu proizvoda �iji naziv po�inje slovima �S� ili  �T�, ili je ID proizvoda = 46. Tako�er, lista treba da 
sadr�i one proizvode �ija je se cijena po komadu kre�e izme�u 10 i 50. Upit napisati na dva na�ina.
5. Prikazati dobavlja�e koji dolaze iz �panije ili Njema�ke a nemaju unesen broj faxa. Formatirati izlaz NULL vrijednosti. 
Upit napisati na dva na�ina.
6. Prikazati naziv proizvoda i cijenu gdje je stanje na zalihama manje od naru�ene koli�ine. Tako�er, u rezultate upita 
uklju�iti razliku izme�u naru�ene koli�ine i stanja zaliha.
7. Prikazati stavke narud�be (sve kolone) gdje je koli�ina narud�be bila ve�a od 100 komada uz odobreni popust.
8. Prikazati proizvode �iji naziv ne po�inje slovima �S� ili �L�, drugo slovo je nepoznato, a tre�e slovo u nazivu je �A� ili �C�. 
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
