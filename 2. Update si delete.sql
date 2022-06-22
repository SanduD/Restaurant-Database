--1. Sa se mareasca salariul angajatilor cu 10%

update Functii
set Salariu=Salariu*1.10

select * from Functii
--2. Sa se micsoreze salariul Bucatarului si ajutorului de bucatar cu 200 de lei.\
update Functii
set Salariu=Salariu-200
where Denumire='Bucatar' or Denumire='Ajutor de bucatar'

select * from Functii where Denumire='Bucatar' or Denumire='Ajutor de bucatar'
--3.  Sa se seteze functia cu ID-ul 3 angajatului Barbusi Darius.

select *  from FunctiiAngajati FA
inner join Angajati A
on A.IdAngajat=FA.IdAngajat
where A.Nume='Barbusi' and A.Prenume='Darius'

update FunctiiAngajati
set FunctiiAngajati.IdFunctie=3 from FunctiiAngajati FA
inner join Angajati A
on A.IdAngajat=FA.IdAngajat
where A.Nume='Barbusi' and A.Prenume='Darius'

select *  from FunctiiAngajati FA
inner join Angajati A
on A.IdAngajat=FA.IdAngajat
where A.Nume='Barbusi' and A.Prenume='Darius'

--4. Angajatul Cioloca Paul a fost promovat in functia de Administrator.
-- Sa se reflecte aceasta schimbare si in baza de date.

select A.Nume,A.Prenume,F.Denumire from FunctiiAngajati FA
inner join Angajati A
on A.IdAngajat=FA.IdAngajat
join Functii F
on F.IdFunctie=FA.IdFunctie
where A.Nume='Cioloca' and A.Prenume='Paul'

update FunctiiAngajati
set FunctiiAngajati.IdFunctie=(select IdFunctie from Functii where Denumire='Director Bucatarie')
from FunctiiAngajati FA
inner join Angajati A
on A.IdAngajat=FA.IdAngajat
where A.Nume='Cioloca' and A.Prenume='Paul'

select A.Nume,A.Prenume,F.Denumire from FunctiiAngajati FA
inner join Angajati A
on A.IdAngajat=FA.IdAngajat
join Functii F
on F.IdFunctie=FA.IdFunctie
where A.Nume='Cioloca' and A.Prenume='Paul'



--5. Sa se inlocuiasca ciorba de burta din comenzi cu ciorba radauteana.

select CC.IdComanda from ContinutComanda CC
join Preparate P
on P.IdPreparat=CC.IdPreparat
where P.Denumire='Ciorba de burta'

update ContinutComanda
set IdPreparat=(select Preparate.IdPreparat from preparate where Denumire='Ciorba radauteana')
from ContinutComanda CC
inner join Preparate P
on P.IdPreparat=CC.IdPreparat
where P.Denumire='Ciorba de burta'

select CC.IdComanda from ContinutComanda CC
join Preparate P
on P.IdPreparat=CC.IdPreparat
where P.Denumire='Ciorba de burta'
--6. Sa se actualizeze campul PretComanda din tabela comenzi cu nota de plata a fiecarei comenzi


select * from Comenzi
update Comenzi
set Comenzi.PretComanda=(
						select sum(CC.Cantitate*P.PretPreparat)
						from ContinutComanda CC
							join Preparate P
							on P.IdPreparat=CC.IdPreparat
							where Comenzi.IdComanda=CC.IdComanda
							group by CC.IdComanda)

select * from Comenzi

--7. Sa se schimbe furnizorul tuturor hotelor cu 
--'ESAROM ROMANIA SRL'

select E.Denumire, F.Denumire from FurnizoriEchipamente FE
join Echipamente E
on E.IdEchipament=FE.IdEchipament
join Furnizori F
on F.IdFurnizor=FE.IdFurnizor
where E.Denumire='Hota'

update FurnizoriEchipamente 
set IdFurnizor=(select IdFurnizor from Furnizori where Denumire='ESAROM ROMANIA SRL')
from FurnizoriEchipamente FE
join Echipamente E
on E.IdEchipament=FE.IdEchipament
where E.Denumire='Hota'

select E.Denumire, F.Denumire from FurnizoriEchipamente FE
join Echipamente E
on E.IdEchipament=FE.IdEchipament
join Furnizori F
on F.IdFurnizor=FE.IdFurnizor
where E.Denumire='Hota'


--8. Sa se actualizeze in tabelul Echipamente, stocul total al fiecarui echipament 
--distribuit de furnizori
select * from Echipamente

update Echipamente
set Cantitate=( select sum(FE.Numar_bucati) from FurnizoriEchipamente FE
				where Echipamente.IdEchipament=FE.IdEchipament
				group by IdEchipament)

select * from Echipamente

--9.Sa se inlocuiasca mararul din ciorba de legume cu morcovul

select P.Denumire, I.Denumire from IngredientePreparate Ipp
join Preparate P
on P.IdPreparat=Ipp.IdPreparat
join Ingrediente I
on I.IdIngredient= Ipp.IdIngredient
where P.Denumire like 'Ciorba de legume'

update IngredientePreparate
set IdIngredient=(select IdIngredient from Ingrediente where Denumire='Morcov')
where IdIngredient=(select IdIngredient from Ingrediente where Denumire='Marar')

select P.Denumire, I.Denumire from IngredientePreparate Ipp
join Preparate P
on P.IdPreparat=Ipp.IdPreparat
join Ingrediente I
on I.IdIngredient= Ipp.IdIngredient
where P.Denumire like 'Ciorba de legume'

--10. Sa se schimbe numarul de telefon al furnizorului de Aragaze din Sibiu, precum si
-- orasul acestuia cu Brasov
select F.Denumire,F.NrTelefon,F.Oras from Furnizori F
join FurnizoriEchipamente FE
on F.IdFurnizor=FE.IdFurnizor
join Echipamente E
on FE.IdEchipament=E.IdEchipament
where E.Denumire='Aragaz' 

update Furnizori
set NrTelefon='0234280567',Oras='Brasov'
from Furnizori F
join FurnizoriEchipamente FE
on F.IdFurnizor=FE.IdFurnizor
join Echipamente E
on FE.IdEchipament=E.IdEchipament
where E.Denumire='Aragaz' and F.Oras='Sibiu'

select F.Denumire,F.NrTelefon,F.Oras from Furnizori F
join FurnizoriEchipamente FE
on F.IdFurnizor=FE.IdFurnizor
join Echipamente E
on FE.IdEchipament=E.IdEchipament
where E.Denumire='Aragaz' 


--11. Sa se creasca capacitatea meselor care apar in tabelul cu rezervari
--cu 2 locuri

select* from Mese

update Mese
set Capacitate+=2
from Mese M
join (select distinct  IdMasa from Rezervari) R
on R.IdMasa=M.IdMasa

select* from Mese

--12. Sa se modifice modalitatea de plata cu 'Din partea casei' a comenzilor
--care au mai putin de 3 preparate
select * from Comenzi

update Comenzi
set ModalitatePlata='Din partea casei'
from Comenzi C
join (select CC.IdComanda,count(CC.IdPreparat) as 'NrComenzi'
		from ContinutComanda CC
		group by CC.IdComanda
		having count(CC.IdPreparat)<=3) as CC
on C.IdComanda=CC.IdComanda

select * from Comenzi

--13. Sa se demita din  functii angajatii care au 2 functii.

select FA.IdAngajat,count (*) as 'NrFunctii' from FunctiiAngajati FA
		join Functii F
		on F.IdFunctie=FA.IdFunctie
		where FA.DataDemitere is null
		group by FA.IdAngajat
		having count(*)>1

update FunctiiAngajati
set DataDemitere=GETDATE()
from FunctiiAngajati FA
join (	select FA.IdAngajat,count (*) as 'NrFunctii' from FunctiiAngajati FA
		join Functii F
		on F.IdFunctie=FA.IdFunctie
		where FA.DataDemitere is null
		group by FA.IdAngajat
		having count(*)>1) as CTE
on FA.IdAngajat=CTE.IdAngajat
where FA.DataDemitere is null

select FA.IdAngajat,count (*) as 'NrFunctii' from FunctiiAngajati FA
		join Functii F
		on F.IdFunctie=FA.IdFunctie
		where FA.DataDemitere is null
		group by FA.IdAngajat
		having count(*)>1

--14. Sa se actualizeze seria facturilor care au furnizor din orase care
--incep cu litera 'B', si sa se acorde un discount de 10%

select Fac.IdFactura,F.Denumire,Fac.Numar,Fac.SumaPlata
from Facturi Fac
inner join Furnizori F
on Fac.IdFurnizor=F.IdFurnizor
where F.Oras like 'B%'

update Facturi
set Serie='BB',SumaPlata=SumaPlata*0.9
from Facturi Fac
inner join Furnizori F
on Fac.IdFurnizor=F.IdFurnizor
where F.Oras like 'B%'

select Fac.IdFactura,F.Denumire,Fac.Numar,Fac.SumaPlata
from Facturi Fac
inner join Furnizori F
on Fac.IdFurnizor=F.IdFurnizor
where F.Oras like 'B%'


--15. Sa se mareasca cantitatea de ingrediente livrata de furnizorul
--'Macelaria AGAPE' cu 10%, sa se mareasca pretul/perUnitate cu 7%

select * from FurnizoriIngrediente FI
join Furnizori F
on FI.IdFurnizor=F.IdFurnizor
where F.Denumire='Macelaria AGAPE'


update FurnizoriIngrediente
set PretUnitate=PretUnitate*1.07,Catitate*=1.1
from FurnizoriIngrediente FI
join Furnizori F
on FI.IdFurnizor=F.IdFurnizor
where F.Denumire='Macelaria AGAPE'

select * from FurnizoriIngrediente FI
join Furnizori F
on FI.IdFurnizor=F.IdFurnizor
where F.Denumire='Macelaria AGAPE'



--------------------------DELETE-----------------------------
--1. Sa se stearga toti furnizorii din Bucuresti

BEGIN TRAN
	
	select * from Furnizori

	ALTER TABLE FurnizoriIngrediente
	DROP CONSTRAINT FK_Furnizori_FurnizoriIngrediente
	alter table FurnizoriIngrediente with CHECK
	add Constraint FK_Furnizori_FurnizoriIngrediente foreign key(IdFurnizor)references Furnizori(IdFurnizor)
	on delete cascade

	ALTER TABLE FurnizoriEchipamente
	DROP CONSTRAINT FK_Furnizori_FurnizoriEchipamente
	alter table FurnizoriEchipamente with CHECK
	add Constraint FK_Furnizori_FurnizoriEchipamente foreign key(IdFurnizor)references Furnizori(IdFurnizor)
	on delete cascade

	alter table Facturi
	DROP CONSTRAINT FK_Furnizori_Facturi
	alter table Facturi with CHECK
	add Constraint FK_Furnizori_Facturi foreign key(IdFurnizor)references Furnizori(IdFurnizor)
	on delete cascade

	delete from Furnizori
	where Oras='Bucuresti'

	select * from Furnizori
rollback

--2. Sa se stearga toate rezervarile care au id impar si au data rezervarii
--intre 2022-05-01 si 2022-06-01

begin tran
	select * from Rezervari

	delete from Rezervari
	where IdRezervare%2=1 and DataRezervare between '2022-05-01' and '2022-06-01'
	
	select * from Rezervari
rollback


--3. sa se stearga cea mai Scumpa factura 

begin tran
	select * from Facturi
	delete top(1) from Facturi
	where SumaPlata=(select top(1) SumaPlata from Facturi order by SumaPlata desc)
	select * from Facturi
rollback

--4. Sa se stearga Factura care are furnizori din orasul Bucuresti

begin tran
	select F.IdFactura,F.Numar,F.SumaPlata, Fur.Oras from Facturi F
	join Furnizori Fur
	on Fur.IdFurnizor=F.IdFurnizor

	delete F from Facturi F
	join Furnizori Fur
	on F.IdFurnizor=Fur.IdFurnizor
	where Fur.Oras='Bucuresti'


	select F.IdFactura,F.Numar,F.SumaPlata, Fur.Oras from Facturi F
	join Furnizori Fur
	on Fur.IdFurnizor=F.IdFurnizor
rollback

--5. Sa se stearga Patrunjelul din toate Preparatele care il contin.

begin tran
	
	select I.Denumire,Ipp.IdPreparat from Ingrediente I
	join IngredientePreparate Ipp
	on ipp.IdIngredient=I.IdIngredient
	where I.Denumire='Patrunjel'

	delete ipp from IngredientePreparate ipp
	join Ingrediente I
	on ipp.IdIngredient=i.IdIngredient
	where I.Denumire='Patrunjel'

	select I.Denumire,Ipp.IdPreparat from Ingrediente I
	join IngredientePreparate Ipp
	on ipp.IdIngredient=I.IdIngredient
	where I.Denumire='Patrunjel'

	
rollback

--6. sa se stearga Ciorbele din toate comenzile

begin tran
	select p.Denumire,CC.IdComanda from Preparate P
	join ContinutComanda CC
	on CC.IdPreparat=P.IdPreparat
	where P.Denumire like 'Ciorba%'
	
	delete CC from ContinutComanda CC
	join Preparate P
	on CC.IdPreparat=P.IdPreparat
	where P.Denumire like 'Ciorba%'

	select p.Denumire,CC.IdComanda from Preparate P
	join ContinutComanda CC
	on CC.IdPreparat=P.IdPreparat
	where P.Denumire like 'Ciorba%'
rollback

--7. Sa se stearga Furnizorii de aragaze 

begin tran
	select E.Denumire,FE.IdFurnizor from Echipamente E
	join FurnizoriEchipamente FE
	on E.IdEchipament= FE.IdEchipament
	where E.Denumire='Aragaz'

	delete FE from FurnizoriEchipamente FE
	join Echipamente E
	on FE.IdEchipament=E.IdEchipament
	where E.Denumire='Aragaz'

	select E.Denumire,FE.IdFurnizor from Echipamente E
	join FurnizoriEchipamente FE
	on E.IdEchipament= FE.IdEchipament
	where E.Denumire='Aragaz'
rollback

--8. Sa se stearga Pieptul de pui din platoul Ciobanului

begin tran
	select P.Denumire,I.Denumire from IngredientePreparate ipp
	join Ingrediente I
	on ipp.IdIngredient=i.IdIngredient
	join Preparate P
	on P.IdPreparat=ipp.IdPreparat
	where P.Denumire='Platoul Ciobanului' and I.Denumire='Piept de pui'


	delete ipp from IngredientePreparate ipp
	join Ingrediente I
	on ipp.IdIngredient=i.IdIngredient
	join Preparate P
	on P.IdPreparat=ipp.IdPreparat
	where P.Denumire='Platoul Ciobanului' and I.Denumire='Piept de pui'

	select P.Denumire,I.Denumire from IngredientePreparate ipp
	join Ingrediente I
	on ipp.IdIngredient=i.IdIngredient
	join Preparate P
	on P.IdPreparat=ipp.IdPreparat
	where P.Denumire='Platoul Ciobanului' and I.Denumire='Piept de pui'

rollback
--9.  Sa se stearga preparatele peste 15 de lei care contin Ceafa de porc

begin tran
	select p.Denumire,I.Denumire, P.IdPreparat from Preparate P
	inner join IngredientePreparate Ipp
	on Ipp.IdPreparat=P.IdPreparat
	inner join Ingrediente I
	on I.IdIngredient=Ipp.IdIngredient
	where P.PretPreparat>=15 and I.Denumire='Ceafa de porc'

	ALTER TABLE ContinutComanda
	DROP CONSTRAINT FK_IdPreparat_ContinutComanda
	alter table ContinutComanda with CHECK
	add Constraint FK_IdPreparat_ContinutComanda foreign key(IdPreparat)references Preparate(IdPreparat)
	on delete cascade

	ALTER TABLE IngredientePreparate
	DROP CONSTRAINT FK_IdPreparat_IngredientePreparate
	alter table IngredientePreparate with CHECK
	add Constraint FK_IdPreparat_IngredientePreparate foreign key(IdPreparat)references Preparate(IdPreparat)
	on delete cascade

	delete P from Preparate P
	inner join IngredientePreparate Ipp
	on Ipp.IdPreparat=P.IdPreparat
	inner join Ingrediente I
	on I.IdIngredient=Ipp.IdIngredient
	where P.PretPreparat>=15 and I.Denumire='Ceafa de porc'

	select p.Denumire,I.Denumire, P.IdPreparat from Preparate P
	inner join IngredientePreparate Ipp
	on Ipp.IdPreparat=P.IdPreparat
	inner join Ingrediente I
	on I.IdIngredient=Ipp.IdIngredient
	where P.PretPreparat>=15 and I.Denumire='Ceafa de porc'
rollback

--10. Sa se stearga Furnizorul de Burta de vita

begin tran
	select F.Denumire,F.NrTelefon,F.Oras from Furnizori F
	inner join FurnizoriIngrediente FI
	on F.IdFurnizor=FI.IdFurnizor
	inner join Ingrediente I
	on I.IdIngredient=FI.IdIngredient
	where I.Denumire='Burta de Vita'

	ALTER TABLE FurnizoriIngrediente
	DROP CONSTRAINT FK_Furnizori_FurnizoriIngrediente
	alter table FurnizoriIngrediente with CHECK
	add Constraint FK_Furnizori_FurnizoriIngrediente foreign key(IdFurnizor)references Furnizori(IdFurnizor)
	on delete cascade

	ALTER TABLE FurnizoriEchipamente
	DROP CONSTRAINT FK_Furnizori_FurnizoriEchipamente
	alter table FurnizoriEchipamente with CHECK
	add Constraint FK_Furnizori_FurnizoriEchipamente foreign key(IdFurnizor)references Furnizori(IdFurnizor)
	on delete cascade

	alter table Facturi
	DROP CONSTRAINT FK_Furnizori_Facturi
	alter table Facturi with CHECK
	add Constraint FK_Furnizori_Facturi foreign key(IdFurnizor)references Furnizori(IdFurnizor)
	on delete cascade

	delete F from Furnizori F
	inner join FurnizoriIngrediente FI
	on F.IdFurnizor=FI.IdFurnizor
	inner join Ingrediente I
	on I.IdIngredient=FI.IdIngredient
	where I.Denumire='Burta de Vita'

	select F.Denumire,F.NrTelefon,F.Oras from Furnizori F
	inner join FurnizoriIngrediente FI
	on F.IdFurnizor=FI.IdFurnizor
	inner join Ingrediente I
	on I.IdIngredient=FI.IdIngredient
	where I.Denumire='Burta de Vita'

rollback

--11. Sa se sterga comenzile toate comenzile mai vechi de o luna
select * from Comenzi

begin TRAN
	select * from Comenzi

	alter table ContinutComanda
	DROP CONSTRAINT FK_IdComanda_ContinutComanda
	alter table ContinutComanda with CHECK
	add Constraint FK_IdComanda_ContinutComanda foreign key(IdComanda)references Comenzi(IdComanda)
	on delete cascade

	delete from Comenzi
	where DATEDIFF(DAY,DataPlasareComanda,'2022-05-13')>=31

	select * from Comenzi
rollback

--12. Sa se stearga angajatii care ai mai mult de 2 ani pe o functie, 
--care s-au nascut intr o luna impara si sunt de sex feminin


begin TRAN
	select A.Nume,A.Prenume,A.DataNastere,A.Sex,F.Denumire from Angajati A
	inner join FunctiiAngajati FA
	on A.IdAngajat=FA.IdAngajat
	inner join Functii F
	on F.IdFunctie=FA.IdFunctie
	where DATEDIFF(month,FA.DataAngajare,'2022-05-13')>=24
		and day(A.DataNastere)%2=1
		and sex='Feminin'

	alter table FunctiiAngajati
	DROP CONSTRAINT FK_IdAngajat_FunctiiAngajati
	alter table FunctiiAngajati with CHECK
	add Constraint FK_IdAngajat_FunctiiAngajati foreign key(IdAngajat)references Angajati(IdAngajat)
	on delete cascade

	delete A from Angajati A
	inner join FunctiiAngajati FA
	on A.IdAngajat=FA.IdAngajat
	inner join Functii F
	on F.IdFunctie=FA.IdFunctie
	where DATEDIFF(month,FA.DataAngajare,'2022-05-13')>=24
		and day(A.DataNastere)%2=1
		and sex='Feminin'

	select A.Nume,A.Prenume,A.DataNastere,A.Sex,F.Denumire from Angajati A
	inner join FunctiiAngajati FA
	on A.IdAngajat=FA.IdAngajat
	inner join Functii F
	on F.IdFunctie=FA.IdFunctie
	where DATEDIFF(month,FA.DataAngajare,'2022-05-13')>=24
		and day(A.DataNastere)%2=1
		and sex='Feminin'
rollback

--13. Sa se stearga mesele care au un Id-ul par, care au capacitate mai mare de 8

begin tran
	select* from Mese
	where IdMasa%2=0 and Capacitate>=8

	alter table Rezervari
	DROP CONSTRAINT FK_IdMasa_Rezervari
	alter table Rezervari with CHECK
	add Constraint FK_IdMasa_Rezervari foreign key(IdMasa)references Mese(IdMasa)
	on delete cascade

	alter table Comenzi
	DROP CONSTRAINT FK_IdMasa_Comenzi
	alter table Comenzi with CHECK
	add Constraint FK_IdMasa_Comenzi foreign key(IdMasa)references Mese(IdMasa)
	on delete cascade

	alter table ContinutComanda
	DROP CONSTRAINT FK_IdComanda_ContinutComanda
	alter table ContinutComanda with CHECK
	add Constraint FK_IdComanda_ContinutComanda foreign key(IdComanda)references Comenzi(IdComanda)
	on delete cascade


	delete from Mese
	where IdMasa%2=0 and Capacitate>=8

	select* from Mese
	where IdMasa%2=0 and Capacitate>=8
rollback	

--14. Sa se stearga functiile care au salariu mai mic de 3000 de lei

begin tran
	select * from Functii
	where Salariu<=3000

	alter table FunctiiAngajati
	DROP CONSTRAINT FK_IdFunctie_FunctiiAngajati
	alter table FunctiiAngajati with CHECK
	add Constraint FK_IdFunctie_FunctiiAngajati foreign key(IdFunctie)references Functii(IdFunctie)
	on delete cascade


	delete from Functii
	where Salariu<=3000


	select * from Functii
	where Salariu<=3000
rollback

 --15. Sa se stearga ingredientele care apar in cel putin 4 retete.

 begin tran
	select Denumire from Ingrediente I
	 where exists(
	 select Ipp.IdIngredient,count(*) as NumarAparitiiIngredient
	 from IngredientePreparate Ipp
	 where I.IdIngredient=Ipp.IdIngredient
	 group by Ipp.IdIngredient
	 having count(*)>=4
	 )

	alter table IngredientePreparate
	DROP CONSTRAINT FK_IdIngredient_IngredientePreparate
	alter table IngredientePreparate with CHECK
	add Constraint FK_IdIngredient_IngredientePreparate foreign key(IdIngredient)references Ingrediente(IdIngredient)
	on delete cascade

	alter table FurnizoriIngrediente
	DROP CONSTRAINT FK_Ingredient_FurnizoriIngrediente
	alter table FurnizoriIngrediente with CHECK
	add Constraint FK_Ingredient_FurnizoriIngrediente foreign key(IdIngredient)references Ingrediente(IdIngredient)
	on delete cascade

	 delete I from Ingrediente I
	 where exists(
	 select Ipp.IdIngredient,count(*) as NumarAparitiiIngredient
	 from IngredientePreparate Ipp
	 where I.IdIngredient=Ipp.IdIngredient
	 group by Ipp.IdIngredient
	 having count(*)>=4
	 )

	 select Denumire from Ingrediente I
	 where exists(
	 select Ipp.IdIngredient,count(*) as NumarAparitiiIngredient
	 from IngredientePreparate Ipp
	 where I.IdIngredient=Ipp.IdIngredient
	 group by Ipp.IdIngredient
	 having count(*)>=4
	 )


 rollback

