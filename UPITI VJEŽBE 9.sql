USE pubs
go

ALTER PROCEDURE unosautora 
(
@au_id VARCHAR (11),
@au_lname VARCHAR (40), 
@au_fname VARCHAR (20),
@phone CHAR (12),
@address VARCHAR (40),
@city VARCHAR (20),
@state CHAR (2),
@zip CHAR (5),
@contract BIT = NULL,
@title_id VARCHAR (6),
@title_id2 VARCHAR (6),
@au_ord TINYINT,
@royaltyper INT)

AS 

INSERT INTO [dbo].[authors] (au_id,au_lname, au_fname,phone,address,city,state,zip,contract)
VALUES (@au_id, @au_lname,@au_fname,@phone,@address,@city,@state,@zip,@contract)
INSERT INTO [dbo].[titleauthor] (au_id, title_id, au_ord,royaltyper)
VALUES (@au_id,@title_id,@au_ord ,@royaltyper),
(@au_id, @title_id2,@au_ord,@royaltyper)

GO
EXEC unosautora '111-11-1112', 'Ramovic', 'Sejla','062165909','Fazlagica','Gorazde','GZ','73000',0,'BU1032','BU1111',1,1

SELECT * FROM 
[dbo].[authors]

SELECT * FROM titleauthor

GO
CREATE PROCEDURE izmjena_autora (
@address VARCHAR (40),
@city VARCHAR (20)
)
AS
UPDATE [dbo].[authors]
SET address=@address
WHERE zip='73000'
UPDATE [dbo].[authors]
SET city = @city
WHERE zip='73000'

EXEC izmjena_autora 'Oborci','Donji Vakuf'

GO
CREATE Procedure izbrisi_autora
(@au_id VARCHAR (11))
AS
DELETE FROM [dbo].[authors]
Where au_id= @au_id

EXEC izbrisi_autora '111-11-1112'


/*5. Kreirati pogled (view) sa sljedeæim podacima: naziv izdavaèa, 
ime i prezime autora (odvojeno), naziv knjige, zarada od prodaje knjige/a.*/

GO
CREATE VIEW Prodajaknjige
AS
SELECT P.pub_name AS Izdavac, A.au_fname AS Ime, A.au_lname As Prezime, T.title As Naziv_knjige, SUM(S.[qty]*T.price) AS Zarada
FROM [dbo].[authors] AS A JOIN [dbo].[titleauthor] As TA
ON A.au_id = TA.au_id JOIN [dbo].[titles] AS T 
ON TA.title_id=T.title_id JOIN [dbo].[sales] AS S
ON T.title_id=S.title_id JOIN [dbo].[publishers] AS P
ON P.pub_id=T.pub_id
GROUP BY P.pub_name, A.au_fname, A.au_lname, T.title

SELECT * FROM Prodajaknjige

/*6. Kreirati proceduru koja prima sljedeæe parametre: ime i prezime autora, naziv izdavaèa, 
naziv knjige. U zavisnosti od proslijeðenog parametra procedura treba da 
vrati zaradu od prodaje knjige/a. Koristiti view kreiran u zadatku 5.*/

GO
CREATE PROCEDURE zaradaODprodaje (
@au_fname VARCHAR (20),
@au_lname VARCHAR (40),
@pub_name VARCHAR (40),
@title VARCHAR (80)
)
 AS
SELECT PK.Zarada
FROM Prodajaknjige AS PK
WHERE @au_fname=PK.Ime AND @au_lname=PK.Prezime AND @pub_name=PK.Izdavac AND @title=PK.Naziv_knjige

EXEC zaradaODprodaje 'Sejla','Ramovic','Algodata Infosystems','Cooking with Computers: Surreptitious Balance Sheets'

/* Kreirati trigger (INSTEAD OF) koji æe sprijeèiti izvršavanje DELETE komande nad tabelom titleauthor. 
Ukoliko se pokuša obrisati zapis u tabeli titleauthor ispisati odgovarajuæu poruku. 
Koristiti komandu PRINT za ispis poruke. */






