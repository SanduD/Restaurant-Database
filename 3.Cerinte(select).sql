--1.Sa se afiseze toti angajatii
select * from Angajati


--2.Sa se afiseze numele si prenumele angajatiilor de gen Masculin
select Nume,Prenume from Angajati
where Sex='Masculin'

--2.1 Sa se afiseze anagajatii al caror nume incepe cu litera T, de sex masculin, nascuti
--dupa data de '2001-02-04'
select Nume,Prenume,Sex, DataNastere from Angajati
where Nume like 'T%'
	and Sex='Masculin'
	and DataNastere>='2001-02-04'

--3. Sa se afiseze numele, prenumele si data nasterii angajatilor nascuti dupa anul 2000, ordonati alfabetic dupa nume.
select Nume,Prenume, DataNastere from Angajati
where year(DataNastere)>=2000 order by Nume

--3.1Sa se afiseze echipamentele care au Id-ul un numar par
SELECT * 
FROM Echipamente 
WHERE IdEchipament%2 = 0;

--4.Sa se afiseze Furnizorii din Bucuresti
select * from Furnizori
where Oras='Bucuresti'

--4.1 Sa se afiseze Furnizorii din Cluj-Napoca al caror numar de telefon se termina cu 3
--si au id Impar
select * from Furnizori
where Oras='Cluj-Napoca'
	and NrTelefon like '%3'
	and IdFurnizor%2=1

--5.Sa se afiseze Mesele libere
select* from Mese
where Status='Libera'

--6.Sa se afiseze facturile care au suma de plata mai mare de 2500 lei, ordonate descrescator dupa suma de plata
select * from Facturi
where SumaPlata>=2500 order  by SumaPlata desc

--7.Sa se afiseze Preparatele care incep cu litera P
select * from Preparate
where Denumire like 'P%'

--8. Sa se afiseze numele si prenumele angajatilor, a caror prenume se termina in litera 'a'
select Nume,Prenume from Angajati
where Prenume like '%a'


--9. Sa se afiseze comenzile care au fost achitate cu cardul
select * from Comenzi
where ModalitatePlata='Card'

--10.Sa se afiseze Numele si prenumele persoanelor angajate in anul 2020
select distinct A.Nume,A.Prenume from Angajati A
inner join 
FunctiiAngajati F
on A.IdAngajat=F.IdAngajat
where year(F.DataAngajare)=2020

--11. Sa se afiseze Id-ul comenzii si modalitatea de plata, de la mesele de doua persoane care au ca modalitate de plata Cash

select C.IdComanda from Comenzi C
inner join Mese M
on C.IdMasa=M.IdMasa
where M.Capacitate=2 and C.ModalitatePlata='Cash'

--12. Sa se afiseze numele preparatelor din comanda numarul 3

select P.Denumire as 'Preparate Comandate' from ContinutComanda Co
inner join Preparate P
on Co.IdPreparat=P.IdPreparat
where Co.IdComanda=3

--13. Sa se afiseze comenzile care contin ciorba

select IdComanda from ContinutComanda C
inner join Preparate P
on C.IdPreparat=P.IdPreparat
where P.Denumire like 'Ciorba %'

select * from ContinutComanda

--14. Sa se afiseze comanda care contine  Platoul Drumetului, si sa se
--afiseze ingredientele acestuia.

select distinct IdComanda from ContinutComanda C
inner join Preparate P
on C.IdPreparat=P.IdPreparat
inner join IngredientePreparate Ipp
on Ipp.IdPreparat=P.IdPreparat
where P.Denumire='Platoul Drumetului'

--15. Sa se afiseze preparatele sub 20 de lei care contin Patrunjel

select p.Denumire,P.PretPreparat from Preparate P
inner join IngredientePreparate Ipp
on Ipp.IdPreparat=P.IdPreparat
inner join Ingrediente I
on I.IdIngredient=Ipp.IdIngredient
where I.Denumire='Patrunjel' and P.PretPreparat<=20


--16. Sa se afiseze Echipamentele livrate de 'ESAROM ROMANIA SRL'


select E.Denumire,F.Denumire from Echipamente E
inner join FurnizoriEchipamente FE
on E.IdEchipament=FE.IdEchipament
inner join Furnizori F
on F.IdFurnizor=FE.IdFurnizor
where F.Denumire='ESAROM ROMANIA SRL'

--17. Sa se afiseze Furnizorul de piept de pui

select F.Denumire,F.NrTelefon,F.Oras from Furnizori F
inner join FurnizoriIngrediente FI
on F.IdFurnizor=FI.IdFurnizor
inner join Ingrediente I
on I.IdIngredient=FI.IdIngredient
where I.Denumire='Piept de pui'



--18. Sa se afiseze adresa furnizorului de Frigidere
select F.IdFurnizor,F.Denumire,F.Oras,F.NrTelefon from Furnizori F
inner join FurnizoriEchipamente FE
on F.IdFurnizor=FE.IdFurnizor
inner join Echipamente E
on E.IdEchipament=FE.IdEchipament
where E.Denumire='Frigider'



--19. Sa se afiseze Seria, numarul facturii si suma de plate care trebuie 
--achitate furnizorului 'ALIRO MARMIR SRL'

select Serie,Numar,SumaPlata from Facturi Fac
inner join Furnizori Fu
on Fac.IdFurnizor=Fu.IdFurnizor
where Fu.Denumire='ALIRO MARMIR SRL'

--20. Sa se afiseze numele furnizorilor pentru preparatele de la masa 6, care e din Bucuresti

select distinct F.Denumire,F.Oras,F.NrTelefon from Furnizori F
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
where C.IdMasa=6 and F.Oras='Bucuresti'

--21.Sa se afiseze Numele si prenumele Angajatilor ordonate descrescator in functie de salariu
select distinct A.Nume,A.Prenume,F.Salariu from Angajati A
inner join FunctiiAngajati FA
on A.IdAngajat= FA.IdAngajat
inner join Functii F
on FA.IdFunctie=F.IdFunctie
order by F.Salariu desc

--22. Sa se afiseze primele 40% de comenzi ordonate crescator 
--in functie de data
select TOP(40) Percent* from Comenzi
order by DataPlasareComanda ASC

--23. Sa se afiseze top 3 cei mai bogati angajati
select TOP(3) * from Functii
order by Salariu desc

--24. Sa se afiseze personalul angajat intre '01-03-2019' si
--'01-05-2019'
select Nume,Prenume from Angajati A
inner join FunctiiAngajati FA
on Fa.IdAngajat=A.IdAngajat
where FA.DataAngajare between '2019-03-01' and '2019-05-01'

--25. Sa se afiseze istoricul comenzilor de la masa primei
-- rezervari 
 select C.IdComanda,C.DataPlasareComanda from Rezervari R
 inner join Mese M
 on R.IdMasa=M.IdMasa
 inner join Comenzi C
 on C.IdMasa=M.IdMasa
 where M.IdMasa=(select top(1) IdMasa from Rezervari) 

 --26.Sa se afiseze Numele si CNP-ul managerului

 select  Nume,Prenume, CNP from Angajati A
 inner join FunctiiAngajati FA
 on A.IdAngajat=FA.IdAngajat
 inner join Functii F
 on F.IdFunctie=FA.IdFunctie
 where F.Denumire='Manager' and DataDemitere is NULL

 --27. Sa se afiseze Echipamentele care incep cu 'F' si 
 --sunt in cantitate mai mare de 100

 select * from Echipamente
 where Denumire like 'F%' and Cantitate>100

 --28. Sa se afiseze angajatii care au intre 19 si 25 de ani
 select Nume,year(DataNastere) as 'An Nastere' from Angajati
 where (2022-year(DataNastere))>=19 And (2022-year(DataNastere))<=25

 --29. Sa se afiseze preparatele din comenzi care contin
 --'ou'
 
 select distinct P.Denumire from ContinutComanda CC
 inner join Preparate P
 on CC.IdPreparat=P.IdPreparat
 where P.Denumire like '%ou%'

  --29.1 Sa se afiseze preparatele din comenzi care contin
 --'ou' si se termina cu 'ui' si sa se grupeze in functie de numarul de aparitii.

 select  P.Denumire,count(*) as 'NrAparitii' from ContinutComanda CC
 inner join Preparate P
 on CC.IdPreparat=P.IdPreparat
 where P.Denumire like '%ou%'
		and P.Denumire like '%ui'
 group by P.Denumire

 --30. Sa se afiseze Numele,prenumele angajatilor care au lucrat mai 
 --mult de 2 ani pe o functie

 select A.Nume,A.Prenume,F.Denumire from Angajati A
 inner join FunctiiAngajati FA
 on A.IdAngajat=FA.IdAngajat
 inner join Functii F
 on F.IdFunctie=FA.IdFunctie
 where DATEDIFF(month,FA.DataAngajare,'2022-04-27')>=24
 
  --30.1 Sa se afiseze Numele,Prenumele angajatilor care au lucrat mai 
 --mult de 2 ani pe o functie, care s-au nascut intr o zi para si sunt de sex masculin

 select A.Nume,A.Prenume,A.DataNastere,A.Sex,F.Denumire from Angajati A
 inner join FunctiiAngajati FA
 on A.IdAngajat=FA.IdAngajat
 inner join Functii F
 on F.IdFunctie=FA.IdFunctie
 where DATEDIFF(month,FA.DataAngajare,'2022-04-27')>=24
		and day(A.DataNastere)%2=0
		and sex='Masculin'

 --31. Sa se afiseze Furnizorii din Bucuresti care distribuie ingrediente cu un pret pe 
 --unitate mai mic de 5 lei


 select F.IdFurnizor,Denumire,F.Oras from Furnizori F
 where exists
 (
 select FI.IdFurnizor from FurnizoriIngrediente FI
 where F.IdFurnizor=FI.IdFurnizor 
		and FI.PretUnitate<=5
		and F.Oras='Bucuresti'
 )

 --32. Sa se afiseze doar Preparatele care au o lista de ingrediente

 select Denumire from Preparate P
 where exists
 (
 select Ipp.IdIngredient from IngredientePreparate Ipp
 where P.IdPreparat=Ipp.IdPreparat
 )

 --33. Sa se afiseze facturile care trebuiesc achitate firmei 'ALIRO MARMIR SRL'

 select * from Facturi
 where exists
 (
	select IdFurnizor from Furnizori 
	where Facturi.IdFurnizor = Furnizori.IdFurnizor and Furnizori.Denumire='ALIRO MARMIR SRL'
 )

 --34. Sa se afiseze Ingredientele pentru preparatul cu ID-ul 3
 select I.Denumire from Ingrediente I
 where exists
 (
	select * from IngredientePreparate Ipp
	where I.IdIngredient=Ipp.IdIngredient and Ipp.IdPreparat=3
 )

 --35. Sa se afiseze Numele angajatilor care au salariul mai mare de 5000 de lei

 select A.Nume,Prenume from Angajati A
 where exists
 (
	select FA.IdAngajat from FunctiiAngajati FA
	inner join Functii F
	on F.IdFunctie=FA.IdFunctie
	where A.IdAngajat=FA.IdAngajat and F.Salariu>=5000
 )

 --36. Sa se afiseze numele Ingredientelor si Preparatelor 
 select I.Denumire from Ingrediente I
 UNION
 select P.Denumire from Preparate P

 --37. Sa se afiseze orasele in care se afla atat Angajati cat si Furnizori

 select Oras from Angajati
 Intersect
 select F.Oras from Furnizori F

 --38. Sa se afiseze orasele in care sunt Angajati dar nu sunt Furnizori

 
 select Oras from Angajati
 Except
 select F.Oras from Furnizori F


 --39. Sa se afiseze numarul total de comenzi

 select COUNT(*) as NumarTotalComenzi from Comenzi

 --40. Cate comenzi a avut fiecare masa?

 select C.IdMasa,COUNT(*) as NumarComenzi from Comenzi C
 group by C.IdMasa

 --41. Cate comenzi au fost pe zi la fiecare masa?

 select IdComanda, day(C.DataPlasareComanda) as ZiComanda,count(*) as NumarComenzi
 from Comenzi C
 group by IdComanda, day(C.DataPlasareComanda)

 --42. Sa se afiseze cati angajati de sex masculin si feminin sunt

 select A.Sex, Count (*) as NumarAngajati
 from Angajati A
 group by Sex

 --43. Sa se afiseze cate mese au acelasi status

 select M.Status, Count(*) as NumarMese from Mese M
 group by Status

 --44. Sa se afiseze mesele si zilele in care au avut cel putin 2 comenzi

 select C.IdMasa,day(C.DataPlasareComanda) as ZiComanda, count(*) as NumarComenzi
 from Comenzi C
 group by C.IdMasa,day(C.DataPlasareComanda)
 having count(*)>=2

 --45. Sa se afiseze Denumirea ingredientelor care apar in cel putin 4 retete.

 select Denumire from Ingrediente I
 where exists(
 select Ipp.IdIngredient,count(*) as NumarAparitiiIngredient
 from IngredientePreparate Ipp
 where I.IdIngredient=Ipp.IdIngredient
 group by Ipp.IdIngredient
 having count(*)>=4
 )

 --46. Sa se afiseze cati angajati sunt din fiecare oras

 select A.Oras, count(*) as NumarAngajati from Angajati A
 group by A.Oras

 --47. Sa se afiseze orasele din care sunt cel putin 2 angajati

 select A.Oras,count(*) as NumarAngajati from Angajati A
 group by A.Oras
 having count(*)>=2
 order by A.Oras DESC

 --48. Sa se afiseze in ce data a fost efectuata cel 
 --putin o comanda, prima si ultima zi a comenzilor

 select C.IdMasa,count(C.DataPlasareComanda) as ComenziEfectuate,MIN(C.DataPlasareComanda) as PrimaZi,Max(DataPlasareComanda) as UltimaZi
 from Comenzi C
 group by C.IdMasa

 --49. Sa se afiseze in cate din zile au fost efectuate comenzi
 --pe fiecare masa in parte

 select C.IdMasa,count(Distinct C.DataPlasareComanda) as 'Numar de zile'
 from Comenzi C
 group by C.IdMasa

 select * from FurnizoriEchipamente
 --50. Sa se afiseze cate echipamente au fost distribuite de fiecare
 --furnizor, si sa se afiseze numele furnizorului

 select F.IdFurnizor,F.Denumire,count(*) as NrEchipamente 
 from Furnizori F
 join FurnizoriEchipamente FE
	on FE.IdFurnizor=F.IdFurnizor
group by F.IdFurnizor,F.Denumire

--51. Sa se afiseze denumirea furnizorilor care au distribuit
--mai mult de 4 echipamente

select F.Denumire from Furnizori F
where exists
(
	select FE.IdFurnizor,count(*) as NrEchipamente
	from FurnizoriEchipamente FE
	where FE.IdFurnizor=F.IdFurnizor
	group by FE.IdFurnizor
	having count(*)>=4
)

--52. Sa se afiseze sumaTotala de plata a tuturor facturilor

select SUM (SumaPlata) as 'SumaTotala(Lei)' from Facturi

--53. Sa se afiseze suma  de plata pe luna a facturilor

select MONTH(Facturi.DataEmitere) as LunaFacturare, SUM (SumaPlata) as 'SumaTotala(Lei)' 
from Facturi
group by MONTH(Facturi.DataEmitere) 

--54. Sa se afiseze Id-ul meselor care se afla in tabela comenzi
select IdMasa from Mese
intersect
select IdMasa from Comenzi

--55. Sa se afiseze Denumirea Furnizorilor care NU distribuie Ingrediente

select F.IdFurnizor from Furnizori F
except
select FI.IdFurnizor from FurnizoriIngrediente FI


--56. Sa se afiseze cea mai scumpa factura pe fiecare luna
select F.Numar,F.Serie,MAX(F.SumaPlata) as SumaFactura, MONTH(F.DataEmitere) as 'Luna Emitere'
from Facturi F
group by MONTH(F.DataEmitere),F.Numar,F.Serie

--57. Sa se afiseze preparatele care au mai putin de 4 ingrediente

select Ipp.IdPreparat,count(Ipp.IdIngredient) as 'NumarIngrediente' from IngredientePreparate Ipp
group by Ipp.IdPreparat
having count(Ipp.IdIngredient)<=4

--58. Sa se afiseze mesele care apar in tabele de rezervari
select M.IdMasa from Mese M
intersect
select R.IdMasa from Rezervari R

--59. Sa se afiseze media salarilor Angajatilor
select AVG(F.Salariu) as 'MedieSalarii'
from Functii F

--60. Sa se afiseze Angajatii pe varste, numai pt varstele
-- care au peste 2 Angajati

select DATEDIFF(year,A.DataNastere,GETDATE())as 'Varsta',count(A.Nume) as 'NrAngajati'
from Angajati A
group by DATEDIFF(year,A.DataNastere,GETDATE())
having count(A.Nume)>=2

