USE pubs
GO

/*1.  Prikazati listu autora sa sljedeæim kolonama: ID, ime i prezime (spojeno), grad i to samo one autore 
èiji ID poèinje brojem 8 ili dolaze iz grada „Salt Lake City“. Takoðer autorima status ugovora treba biti 1. 
Koristiti aliase nad kolonama. 

2. Prikazati sve tipove knjiga bez duplikata. Listu sortirati po tipu.

3. Prikazati listu prodaje knjiga sa sljedeæim kolonama: ID prodavnice, broj narudžbe i kolièinu,
 ali samo gdje je kolièina izmeðu 10 i 50, ukljuèujuæi i graniène vrijednosti. Rezultat upita sortirati po kolièini 
 opadajuæim redoslijedom. Upit napisati na dva naèina.

4. Prikazati listu knjiga sa sljedeæim kolonama: naslov, tip djela i cijenu. Kao novu kolonu dodati 20% od prikazane
 cijene (npr. Ako je cijena 19.99 u novoj koloni treba da piše 3,998). Naziv kolone se treba zvati „20% od cijene“. 
 Listu sortirati abecedno po tipu djela i po cijeni opadajuæim redoslijedom. Sa liste eliminisati one vrijednosti koje
  u polju cijena imaju nepoznatu vrijednost.
Modifikovati upit tako da prikaže cijenu umanjenu za 20 %. Naziv kolone treba da se zove „Cijena umanjena za 20%“.

5. Prikazati 10 kolièinski najveæih stavki prodaje. Lista treba da sadrži broj narudžbe, datum narudžbe i kolièinu.
 Provjeriti da li ima više stavki sa kolièinom kao posljednja u listi.
*/
SELECT [au_id] AS ID, [au_fname] + '  ' + [au_lname] AS [Ime i Prezime], [city] AS Grad, [contract] AS Ugovor
FROM [dbo].[authors]
WHERE ([au_id] LIKE '8%' OR [city] = 'Salt Lake City') AND [contract] = 1

SELECT DISTINCT [type] AS [Tipovi knjiga]
FROM [dbo].[titles]
ORDER BY [type]

SELECT [stor_id], [ord_num], [qty]
FROM [dbo].[sales]
WHERE [qty] BETWEEN 10 AND 50
ORDER BY [qty] DESC 

SELECT [title] AS Naslov, [type] AS TipDjela, [price] AS Cijena, [price] * 0.2 AS [20 % od cijene], [price]- [price] * 0.2 AS [Umanjeno za 20 %]
FROM [dbo].[titles]
WHERE [price] IS NOT NULL
ORDER BY [type], [price] desc

SELECT TOP 10 [qty], [ord_num], [ord_date]
FROM[dbo].[sales]
ORDER BY [qty] DESC

/*GO - PROVJERA
SELECT TOP 10 WITH TIES [qty], [ord_num], [ord_date]
FROM[dbo].[sales]
ORDER BY [qty] DESC */
