USE AdventureWorks2012
GO

/*1. Kreirati upit koji prikazuje korisnièko ime zaposlenika (Sve iza znaka „\“, kolona LoginID), 
starost i godine staža. Uslovi su da zaposlenik ima više od 50 godina, više od 10 godina staža i da 
je ženskog spola. Listu sortirati po godinama staža opadajuæim redoslijedom.

2. Prikazati minimalnu, maksimalnu i prosjeènu cijenu proizvoda ali samo onih gdje je cijena (ListPrice)
 veæa od 0. Koristiti aliase.

3. Prikazati ukupan broj proizvoda po modelu (ProductModel9. Lista treba da sadrži ID modela proizvoda i
 ukupan broj proizvoda. Uslov je da proizvod pripada nekom modelu i da je ukupan broj proizvoda veæi od 1.

4. Kreirati upit koji prikazuje 10 najprodavanijih proizvoda. Lista treba da sadrži ID proizvoda i ukupnu
 kolièinu prodaje. Provjeriti da li ima proizvoda sa istom kolièinom prodaje kao zapis pod rednim brojem 10?

5. Kreirati upit koji prikazuje zaradu od prodaje proizvoda. Lista treba da sadrži ID proizvoda, ukupnu zaradu
 bez popusta, te ukupnu zaradu sa popustom. Iznos zarade zaokružiti na dvije decimale. Uslov je da se prikaže
  zarada samo za stavke gdje je bilo popusta. Listu sortirati po zaradi opadajuæim redoslijedom.
*/

SELECT SUBSTRING ([LoginID],CHARINDEX('\',[LoginID])+1,10) AS [Ime zaposlenika], 
		DATEDIFF(year,[BirthDate],GETDATE()) AS Starost,
		DATEDIFF(year,[HireDate],GETDATE()) AS Staz, [Gender]
FROM[HumanResources].[Employee]
WHERE (DATEDIFF(year,[BirthDate],GETDATE()))>50 AND (DATEDIFF(year,[HireDate],GETDATE()))>10 AND [Gender] LIKE '%F%'
ORDER BY Staz desc

SELECT MIN([ListPrice]) AS [Minimalna cijena], MAX([ListPrice]) AS [Maximalna cijena], AVG([ListPrice]) AS [Prosjecna cijena]
FROM[Production].[Product]
WHERE[ListPrice]>0

SELECT COUNT([ProductModelID]) As [ID proizvoda], SUM([ProductID]
FROM[Production].[ProductModel] AS PM
JOIN[Production].[Product] AS P ON.[ProductID]=PM.[ProductModelID]
WHERE