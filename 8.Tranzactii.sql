
--1. O tranzactie care sa insereze o noua valoare in tabelul Angajati
select @@TRANCOUNT 'First @@TRANCOUNT value'
BEGIN TRAN

	Insert into Angajati(Nume,Prenume,DataNastere,CNP,Sex,Oras) values
	('Toma','Marcu','2001-02-04','5010204456987','Masculin','Simleu')

	select * from Angajati where Nume='Toma'
	select @@TRANCOUNT 'Second @@Trancount value'

commit tran
select @@TRANCOUNT 'Third @@Trancount value'

--2. Sa se realizeze o tranzactie care sa insereze o noua valoare in tabela 
-- Angajati, apoi sa se actualizeze orasul cu 'Borsa' sa se dea commit,
--iar apoi rollback pentru a nu se salva moficarile.

SELECT @@TRANCOUNT; 
BEGIN TRAN;
	SELECT @@TRANCOUNT;

	SET IDENTITY_INSERT Angajati ON;
	Insert into Angajati(IdAngajat,Nume,Prenume,DataNastere,CNP,Sex,Oras) values
	(1001,'Toma','Marcu','2001-02-04','5010204456987','Masculin','Simleu')
	select * from Angajati where Nume='Toma'
		BEGIN TRAN;
		SELECT @@TRANCOUNT;
		UPDATE Angajati
		SET Oras= 'Borsa'
		WHERE Nume = 'Toma' and Prenume='Marcu'

		select * from Angajati where Nume='Toma' and Prenume='Marcu'
		COMMIT
	SET IDENTITY_INSERT Angajati OFF
	select * from Angajati where Nume='Toma' and Prenume='Marcu'
	SELECT @@TRANCOUNT; 
	Rollback TRAN;

select * from Angajati where Nume='Toma' and Prenume='Marcu'
SELECT @@TRANCOUNT; 

--3. Sa se creeze o tranzactie cu blocul try-catch prin care sa se insereze 2 valori
--din care una sa insereze un foreign key care nu exista in tabelul Mese.
-- Sa se afiseze un mesaj corespunzator

begin try
	begin tran
		set identity_insert Rezervari ON

		insert into Rezervari(IdRezervare,IdMasa,NumeClient,DataRezervare) values
		(1001,4,'Ionela','2022-05-13 14:00:00')

		insert into Rezervari(IdRezervare,IdMasa,NumeClient,DataRezervare) values
		(1002,20,'Codruta','2022-05-13 17:00:00')

		set identity_insert Rezervari OFF
	commit tran;
end try

begin catch
	if ERROR_NUMBER()=2627
		begin
			print'Valoare duplicata';
		end
	else if ERROR_NUMBER()=547
			begin
				print 'Constraint violation'
			end
		else
			begin
				print 'Eroare netratata';
			end
	
	if @@TRANCOUNT>0 rollback tran
end catch


--4. Sa se creeze o tranzactie care sa stearga o valoare pe baza numarului de telefon din
--tabela Furnizori 


begin try
	begin tran
		select* from Furnizori
		declare @NumeFurnizor nvarchar(32)='Macelaria AGAPE'
		declare @NumarTelefon varchar(10)='0744169483'

		if @NumarTelefon !=(select NrTelefon from Furnizori where Denumire=@NumeFurnizor)
			THROW 50001,'Numarul de telefon este gresit. Nu se poate sterge Furnizorul',1
		
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

	delete from Furnizori where Denumire=@NumeFurnizor and NrTelefon=@NumarTelefon
	select * from Furnizori
	rollback tran
end try
begin catch
	if ERROR_NUMBER()=50001
		print Error_Message()
	if @@TRANCOUNT>0 rollback tran
end catch


--5. Sa se creeze o tranzactie care testeaza da un nr de telefon introdus este 
--deja existent in tabelul furnizori, al unui furnizor cu Id-ul corespunzator

begin try
	begin tran
		declare @NrTelefon nvarchar(10)='0767917258'
		declare @IdFurnizor int=9

		if(@NrTelefon =(select NrTelefon from Furnizori where IdFurnizor=@IdFurnizor))
			throw 50001,'Numar de telefon deja existent',1

		update Furnizori
		set NrTelefon=@NrTelefon
		where IdFurnizor=@IdFurnizor
	commit tran
end try
begin catch
	if ERROR_NUMBER()=50001 
		print Error_Message()
	if @@TRANCOUNT>0 rollback tran
end catch


--6. Sa se creeze o tranzactie care sa sterga o valoare din tabela Facturi
--daca e mai veche de 60 de zile

select * from Facturi where DATEDIFF(day,DataEmitere,GETDATE())>=60
begin try
	begin tran
		delete from Facturi
		where DATEDIFF(day,DataEmitere,GETDATE())>=60

	commit tran
end try
begin catch
	print Error_Message()
	if @@TRANCOUNT>0 rollback tran
end catch

select * from Facturi where DATEDIFF(day,DataEmitere,GETDATE())>=60


--7. Sa se creeze o tranzactie care sa insereze o noua Factura apoi sa faca 
--update cu o anumita suma daca aceasta este mai mica decat 6000 lei.
--Daca nu este mai mica de 6000 lei sa se faca throw la o eroare.

begin try
	begin tran
		declare @Suma int =5900;

		SET IDENTITY_INSERT Facturi ON;
		insert into Facturi(IdFactura,IdFurnizor,Serie,Numar,DataEmitere,SumaPlata) values
		(1001,4,'ZZ',143223,'2022-05-12',4000)

		--select * from Facturi where IdFactura=1001
		BEGIN TRAN;
			if @Suma<6000
				throw 50003,'Suma este mai mica de 6000 lei. Nu se va face update-ul',1

			UPDATE Facturi
			SET SumaPlata= @Suma
			WHERE IdFactura=1001

		COMMIT
	SET IDENTITY_INSERT Facturi OFF
	rollback tran
end try
begin catch
	if ERROR_NUMBER()=50003
		print Error_Message()
	if @@TRANCOUNT>0 rollback tran
end catch
select * from Facturi where IdFactura=1001



--8. Sa se creeze o tranzactie care inlocuiasca ciorba de legume din comenzi 
--cu o alta ciorba.

select CC.IdComanda from ContinutComanda CC
join Preparate P
on P.IdPreparat=CC.IdPreparat
where P.Denumire='Ciorba de legume'

begin try
	begin tran
		declare @CiorbaNoua nvarchar(32)='Ciorba de gogonele'

		if (select Denumire from Preparate where Denumire='Ciorba de gogonele') is null
			throw 50004, 'Ciorba nu exista in meniu!',1

		update ContinutComanda
		set IdPreparat=(select Preparate.IdPreparat from preparate where Denumire=@CiorbaNoua)
		from ContinutComanda CC
		inner join Preparate P
		on P.IdPreparat=CC.IdPreparat
		where P.Denumire=@CiorbaNoua
	rollback tran
end try
begin catch
	if ERROR_NUMBER()=50004
		print Error_Message()
	if @@TRANCOUNT>0 rollback tran
end catch


--9. Sa se schimbe furnizorul tuturor farfuriilor cu un alt furnizor.
--Daca nu exista sa se afiseze o eroare.

begin try
	begin tran
		declare @Furnizor nvarchar(32)='SanduFarfurii SRL'

		if (select IdFurnizor from Furnizori where Denumire=@Furnizor) is null
			throw 50005,'Furnizorul nu exista!',1

		update FurnizoriEchipamente 
		set IdFurnizor=(select IdFurnizor from Furnizori where Denumire=@Furnizor) 
		from FurnizoriEchipamente FE
		join Echipamente E
		on E.IdEchipament=FE.IdEchipament
		where E.Denumire='Farfurii'

	commit tran
end try
begin catch
	if ERROR_NUMBER()=50005
		print Error_Message()
	if @@TRANCOUNT>0 rollback tran
end catch

--10. Sa se creeze o tranzactie care sa sterga Cartofii si Ceafa de porc
--din toate Preparatele.


begin try
		begin tran

		select I.Denumire,Ipp.IdPreparat from Ingrediente I
		join IngredientePreparate Ipp
		on ipp.IdIngredient=I.IdIngredient
		where I.Denumire='Cartofi' or I.Denumire= 'Ceafa de porc'

		delete ipp from IngredientePreparate ipp
		join Ingrediente I
		on ipp.IdIngredient=i.IdIngredient
		where I.Denumire='Cartofi' or I.Denumire='Ceafa de porc'

		select I.Denumire,Ipp.IdPreparat from Ingrediente I
		join IngredientePreparate Ipp
		on ipp.IdIngredient=I.IdIngredient
		where I.Denumire='Cartofi' or I.Denumire= 'Ceafa de porc'

		rollback tran
end try
begin catch
	print Error_Message()
if @@TRANCOUNT>0 rollback tran
end catch





