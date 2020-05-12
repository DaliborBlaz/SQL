--1

create database ib150047

use ib150047

create table Proizvodi
(
	ProizvodID int identity(1,1) constraint PK_ProizvodID primary key,
	Sifra nvarchar (25) constraint unique_sifra unique not null,
	Naziv nvarchar (50) not null,
	Kategorija nvarchar (50),
	Podkategorija nvarchar (50),
	Boja nvarchar (15),
	Cijena decimal (15,2) not null,
	StanjeZaliha int not null
)

create table Prodaja
(
	ProdajaID int identity (1,1) constraint PK_ProdajaID primary key,
	ProizvodID int constraint FK_ProizvodID foreign key references Proizvodi(ProizvodID),
	Godina int not null,
	Mjesec int not null,
	UkupnoProdano int not null,
	UkupnoPopust decimal (5,3) not null,
	UkupnoIznos decimal (15,2) not null
)


--2

insert into Proizvodi (Sifra,Naziv ,Kategorija ,Podkategorija,Boja ,Cijena,StanjeZaliha)
values
					  ('Proizvod1', 'Coca-Cola','Pica','Gazirana pica','Crna','1.05',50)

select * from Proizvodi

insert into Prodaja (ProizvodID, Godina, Mjesec, UkupnoProdano, UkupnoPopust, UkupnoIznos)
values
					(1,2017,9,4,0,4.2),
					(1,2017,10,10,5,10),
					(1,2017,11,15,8,14)

select * from Prodaja

set identity_insert Proizvodi on

insert into Proizvodi (ProizvodID,Sifra, Naziv, Kategorija, Podkategorija, Boja, Cijena, StanjeZaliha)

	select distinct p.ProductID, p.ProductNumber,p.Name, pc.Name, psc.Name, p.Color, p.ListPrice, sum(pInv.Quantity)
	from AdventureWorks2014.Production.Product as p inner join AdventureWorks2014.Sales.SalesOrderDetail as sod on p.ProductID=sod.ProductID
													inner join AdventureWorks2014.Sales.SalesOrderHeader as soh on sod.SalesOrderID=soh.SalesOrderID
													inner join AdventureWorks2014.Sales.SalesTerritory as st on st.TerritoryID=soh.TerritoryID
													inner join AdventureWorks2014.Production.ProductSubcategory as psc on p.ProductSubcategoryID=psc.ProductSubcategoryID
													inner join AdventureWorks2014.Production.ProductCategory as pc on pc.ProductCategoryID=psc.ProductCategoryID
													inner join AdventureWorks2014.Production.ProductInventory as pInv on p.ProductID=pInv.ProductID
												
	where [Group] = 'Europe'
	group by p.ProductID, p.ProductNumber,p.Name, pc.Name, psc.Name, p.Color, p.ListPrice
	order by p.ProductID
	
	select * from Proizvodi



insert into Prodaja (ProizvodID, Godina, Mjesec, UkupnoProdano, UkupnoPopust, UkupnoIznos)
	
	select sod.ProductID, year(soh.OrderDate),month(soh.OrderDate), sum(sod.OrderQty), convert(decimal(15,2),round(sum((sod.UnitPrice*sod.UnitPriceDiscount)*sod.OrderQty),2)), convert(decimal(15,2),round(sum((sod.UnitPrice-sod.UnitPrice*sod.UnitPriceDiscount)*sod.OrderQty),2))
	
	from AdventureWorks2014.Sales.SalesOrderDetail as sod 
		inner join AdventureWorks2014.Sales.SalesOrderHeader as soh on sod.SalesOrderID=soh.SalesOrderID
		inner join AdventureWorks2014.Sales.SalesTerritory as st on st.TerritoryID=soh.TerritoryID

	where [Group]='Europe' and sod.ProductID in
								(
									select ProizvodID
									from Proizvodi
								)
	group by sod.ProductID, year(soh.OrderDate), month(soh.OrderDate)
	order by sod.ProductID, year(soh.OrderDate), month(soh.OrderDate)

	
		select * from Prodaja


update Proizvodi 
set StanjeZaliha=(select sum(pInv.Quantity)
				  from AdventureWorks2014.Production.Product as p
				  inner join AdventureWorks2014.Production.ProductInventory as pInv on p.ProductID=pInv.ProductID
				  where p.ProductID=ProizvodID
				  )
where ProizvodID in (
		select ProductID
		from AdventureWorks2014.Production.Product
		
	  )

delete from Prodaja where (
							select proiz.Podkategorija
							from Proizvodi as proiz
							where proiz.ProizvodID=Prodaja.ProizvodID
	
							)='Pedals'



--3

select prod.Godina,prod.Mjesec,proiz.Naziv, prod.UkupnoIznos as 'Sa popustom', prod.UkupnoIznos+prod.UkupnoPopust as 'Bez popusta'
from Proizvodi as proiz inner join Prodaja as prod on proiz.ProizvodID=prod.ProizvodID
where prod.Mjesec=5 and prod.Godina=2013


select prod.Godina,proiz.Naziv, sum(prod.UkupnoIznos) as 'Sa popustom', sum(prod.UkupnoIznos+prod.UkupnoPopust) as 'Bez popusta'
from Proizvodi as proiz inner join Prodaja as prod on proiz.ProizvodID=prod.ProizvodID
where prod.Godina=2013
group by prod.Godina, proiz.Naziv



select Godina, sum(UkupnoIznos) as 'Sa popustom', sum(UkupnoIznos+UkupnoPopust) as 'Bez popusta'
from  Prodaja
group by Godina


select prod.Godina, sum(prod.UkupnoIznos),proiz.Podkategorija
from Proizvodi as proiz inner join Prodaja as prod on proiz.ProizvodID=prod.ProizvodID
where proiz.Kategorija like '%Bikes'
group by prod.Godina,proiz.Podkategorija
