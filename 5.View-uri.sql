--66. Sa se creeze un view cu numarul de comenzi efectuate in
--fiecare zi

if OBJECT_ID('View_1','v') is not null
	drop view View_1;
go
create view View_1
as
	select day(c.DataPlasareComanda) as 'ZiComanda', count(C.IdComanda) as 'NumarComenzi'
	from Comenzi C
	group by day(c.DataPlasareComanda)

GO
select * from View_1
--67. Sa se creeze un view cu preparatele grupate pe Numarul de aparitii
--din Comenzi care incept cu litera 'P' si costa intre 40 si 100 lei
go
if OBJECT_ID('View_2','v') is not null
	drop view View_2;
go
create view View_2
as
	select P.Denumire,count(CC.IdPreparat) as 'NrPreparate' from ContinutComanda CC
	inner join Preparate P
	on CC.IdPreparat=P.IdPreparat
	where P.Denumire like 'P%' and P.PretPreparat Between 40 and 100
	group by P.Denumire
go
select * from View_2
--68. Sa se creeze un view care sa contina Denumirea
--echipamentelor care au furnizorul din Cluj-Napoca
go
if OBJECT_ID('View_3','v') is not null
	drop view View_3;
go
create view View_3
as
	select distinct E.Denumire from Echipamente E
	inner join FurnizoriEchipamente FE
	on FE.IdEchipament=E.IdEchipament
	join Furnizori F
	on F.IdFurnizor=FE.IdFurnizor
	where F.Oras='Cluj-Napoca'
go
select * from View_3
--69. Sa se creeze un view cu Angajatii care au fost demisi 
--din Functie
go
if OBJECT_ID('View_4','v') is not null
	drop view View_4;
go
create view View_4
as
	select A.Nume,A.Prenume from Angajati A
	join FunctiiAngajati FA
	on A.IdAngajat=FA.IdAngajat
	where DataDemitere is not null 
go
select * from View_4
--70. Sa se creeze un view cu Angajatii care au fost promovati
--din functie

go
if OBJECT_ID('View_5','v') is not null
	drop view View_5;
go
create view View_5
as
	WITH CTE_6(IdAngajat,Nume,Prenume,DataDemitere)
	AS
	(
		select A.IdAngajat,A.Nume,A.Prenume, FA.DataDemitere from Angajati A
		join FunctiiAngajati FA
		on A.IdAngajat=FA.IdAngajat
		where DataDemitere is not null 
	)
	select Distinct Nume,Prenume from CTE_6 C
	inner join FunctiiAngajati FA
	on FA.IdAngajat=C.IdAngajat
	where Fa.DataAngajare=C.DataDemitere
	go
	select * from View_5