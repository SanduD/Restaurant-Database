
--61. Sa se creeze o expresie care sa afiseze Numele Angajatilor care au un salariu mai mare de 4000 ron. Afisarea se va face descrescator pe salariu si crescator pe Numele angajatilor

WITH CTE_1(Nume,Prenume,Salariu)
AS
(
	select A.Nume,A.Prenume,F.Salariu from Angajati A
	join FunctiiAngajati FA
	on FA.IdAngajat=A.IdAngajat
	join Functii F
	on F.IdFunctie=FA.IdFunctie
	where F.Salariu>=4000 and FA.DataDemitere is NULL
)
select * from CTE_1
order by Salariu ASC, Nume DESC


--62.Sa se creeze o expresie care sa  afiseze Denumirea,Adresa si nr de telefon al Furnizorului de 'Ceafa de porc', 
go
WITH CTE_2(DenumireFurnizor, Oras,NrTelefon)
AS
(
select F.Denumire,F.Oras,F.NrTelefon from Furnizori F
inner join FurnizoriIngrediente FI
on F.IdFurnizor=FI.IdFurnizor
inner join Ingrediente I
on I.IdIngredient=FI.IdIngredient
where I.Denumire='Ceafa de porc'
)
select * from CTE_2

--63. Sa se creeze o expresie care sa afiseze numarul de comenzi,mai mare ca 2, grupate pe mese plasate dupa data de 12.04.2022
 go
 WITH CTE_3(IdMasa, NrComenzi)
 AS
 (
	Select M.IdMasa,count(C.IdComanda)
	from Mese M
	join Comenzi C
	on C.IdMasa=M.IdMasa
	where C.DataPlasareComanda>='2022/04/12'
	group by M.IdMasa
	having count(C.IdComanda)>=2
 )
 select * from CTE_3

 --64. Sa se creeze o expresie care sa afiseze grupat pe luna cate facturi s-au emis, si care e pretul total al acestora
 go
 with CTE_4 (LunaEmitere, SumaPlata,NrFacturi)
 as
 (
	select MONTH(F.DataEmitere), SUM(F.SumaPlata),Count(F.IdFactura)
	from Facturi F
	group by MONTH(F.DataEmitere)
 )

 select * from CTE_4

 --65. Sa se afiseze Denumirea si Orasul furnizorului preparatelor de la masa 4
 go
 with CTE_5
as
(
	select F.Denumire from Furnizori F
inner join FurnizoriIngrediente FI
on F.IdFurnizor=FI.IdFurnizor
inner join Ingrediente I
on I.IdIngredient=FI.IdIngredient
inner join IngredientePreparate Ipp
on Ipp.IdIngredient=I.IdIngredient
inner join Preparate P
on P.IdPreparat=Ipp.IdPreparat
inner join ContinutComanda CC
on CC.IdPreparat=P.IdPreparat
inner join Comenzi C
on CC.IdComanda=C.IdComanda
where C.IdMasa=4

)
select DISTINCT* from CTE_5

--61  Sa se creeze o expresie care sa afiseze Denumirea Furnizorilor care NU distribuie Ingrediente si au primele 2 cifre din numarul de telefon '02' si sunt din Sibiu sau Constanta
go
WITH CTE_6(IdFurnizor)
AS
(
select F.IdFurnizor from Furnizori F
except
select FI.IdFurnizor from FurnizoriIngrediente FI
)
select F.IdFurnizor,F.Denumire,F.NrTelefon,F.Oras from CTE_6 C
inner join Furnizori F
on C.IdFurnizor=F.IdFurnizor
where F.NrTelefon like '02%'
	and Oras='Sibiu' or 
	Oras ='Constanta'

