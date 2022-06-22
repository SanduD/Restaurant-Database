--1. Sa se creeze un declansator care sa afiseze un mesaj cand se executa insert in tabela de Angajati

if OBJECT_ID('TriggerINSERT_Angajati','Tr') is not null
	drop trigger TriggerINSERT_Angajati

go
create Trigger TriggerINSERT_Angajati
on Angajati
for Insert
as
BEGIN
	print('S-a executat un INSERT')
END
GO
begin tran
	insert into Angajati(Nume,Prenume,DataNastere,CNP,Sex,Oras) values
	('Popa','Ionut', '2002-12-03','5021203046234','Masculin','Bacau')
	select * from Angajati where Nume='Popa'
rollback

--2.Sa se creeze un declansator care sa afiseze un mesaj de eroare 16,1 cand se executa UPDATE in tabela Angajati.

if OBJECT_ID('TriggerUPDATE_Angajati','Tr') is not null
	drop trigger TriggerUPDATE_Angajati

go
create Trigger TriggerUPDATE_Angajati
on Angajati
for Update
as
BEGIN
	RAISERROR('S-a executat un UPDATE',16,1)
END
GO

begin tran
	Update Angajati
	set Prenume='Darie'
	where Nume='Popa'
	select * from Angajati where Prenume='Darie'
rollback

--3. Sa se creeze un declansator care sa afiseze un mesaj cand se executa DELETE in tabela de Angajati

if OBJECT_ID('TriggerDELETE_Angajati','Tr') is not null
	drop trigger TriggerDELETE_Angajati

go
create Trigger TriggerDELETE_Angajati
on Angajati
for Delete
as
BEGIN
	print('A fost executat un delete in tabela Angajati')
END
GO
begin tran
	delete from Angajati where Nume='Popa'
	select * from Angajati where Nume='Popa'

rollback
	
--4. Sa se creeze un declansator pentru tabela Functii care adauga
--10 lei la salariul medicului inserta

if OBJECT_ID('FunctiiSalariu','Tr') is not null
	drop trigger FunctiiSalariu

go
create Trigger FunctiiSalariu
on Functii
AFTER insert
as
BEGIN
	update Functii
	set Functii.Salariu=Functii.Salariu+10
	from inserted
	where Functii.IdFunctie=inserted.IdFunctie
	print('Ai inserat o noua valoare in tabelul Functii')
END

go 
begin tran
	insert into Functii(Denumire,Salariu) values
	('Ajutor Manager2',3500)
	select * from Functii where Denumire='Ajutor Manager2'

rollback

--5.Sa se creeze un declansator pentru tabela Functii care sa inlocuiasca
--operatia INSERT cu operatia UPDATE, cand dorim inserarea unei noi
--functii, se va declansa update pentru salariul functiilor cu 9 lei,
-- numai pt functiile care au un salariu intre 2000-4000 lei

if OBJECT_ID('Functii_update_insteadOF_insert','Tr') is not null
	drop trigger Functii_update_insteadOF_insert

go
create Trigger Functii_update_insteadOF_insert
on Functii
instead of insert
as
BEGIN
	update Functii
	set Functii.Salariu=Functii.Salariu+9 from inserted
	where Functii.Salariu between 2000 and 4000
END
go 
begin tran
	insert into Functii(Denumire,Salariu) values
	('Ajutor Manager2',3500)
	select * from Functii
rollback

--6. Sa se creeze un trigger care sa afiseze un mesaj de eroare
--daca s-a modificat numarul de telefon al unui furnizor
--si alt mesaj daca s-a modificat altceva
select * from Furnizori

if OBJECT_ID('UpdateError_Furnizori','Tr') is not null
	drop trigger UpdateError_Furnizori

go
create Trigger UpdateError_Furnizori
on Furnizori
for update
as
BEGIN
	if update(NrTelefon)
		RAISERROR('S-a modificat campul NrTelefon',16,1)

	else
		RAISERROR('S-a modificat alt camp din Furnizori',16,1)
END
go 
begin tran
	update Furnizori
	set NrTelefon='0720410777'
	where Denumire='ALIRO MARMIR SRL'

	update Furnizori
	set Oras='Cluj-Napoca'
	where Denumire='ALIRO MARMIR SRL'
rollback

--7.Sa se creeze un trigger care sa afiseze un mesaj de eroare
--daca s-a modificat CNP-ul si data de nastere a unui angajat
--si alt mesaj daca s-a modificat altceva

if OBJECT_ID('UpdateErrorAngajati','Tr') is not null
	drop trigger UpdateErrorAngajati

go
create Trigger UpdateErrorAngajati
on Angajati
for update
as
BEGIN
	if update(DataNastere) and UPDATE(CNP)
		RAISERROR('S-a modificat campul DataNastere si CNP din tabela Angajati',16,1)
	else
		RAISERROR('S-a modificat alt camp din tabelul Angajati',16,1)
END
go
begin tran
	--insert into Angajati(Nume,Prenume,DataNastere,CNP,Sex,Oras) values
	--('Popa','Ionut', '2002-12-03','5021203046234','Masculin','Bacau')

	update Angajati
	set DataNastere='1997-12-03', CNP='5021203046999'
	where nume='Popa'
rollback

--8. Sa se creeze un declansator asupra lui View3 pentru operatiile 
--de DELETE,INSERT,UPDATE sa arunce o eroare. Deoarece nu sunt permise 
--modificari aspura viewurilor care contin tabele multiple

if OBJECT_ID('Trigger_View3','Tr') is not null
	drop trigger Trigger_View3
go
create Trigger Trigger_View3
on View_3
INSTEAD OF Update, insert, delete
as
BEGIN
	RAISERROR('Invalid Operation!!!',16,1)
END
go
begin tran
	insert into View_3(Denumire) values
	('Cuptor pe lemne');
rollback

--9.Sa se afiseze un mesaj de eroare daca una dintre valorile 
--adaugate in tabela Furnizor este NULL.
select * from Furnizori

if OBJECT_ID('Furnizor_InsertedNULL','Tr') is not null
	drop trigger Furnizor_InsertedNULL
GO
create Trigger Furnizor_InsertedNULL
ON Furnizori
for insert
as
BEGIN
	DECLARE @mDenumire nvarchar(64),
	@mOras nvarchar(32),
	@mNrTelefon nvarchar(10)
	
	select @mDenumire= F.Denumire,@mOras=F.Oras, 
	@mNrTelefon=F.NrTelefon
	from Furnizori F
	if(@mDenumire is null or @mNrTelefon is null OR 
		@mNrTelefon is null)
		RAISERROR('Element NULL',16,1)
		return
END
go
begin tran
	insert into Furnizori(Denumire,Oras) values
	('Dragos SRL','Bacau')
rollback
--10. Sa se creeze un Trigger care sa afiseze un mesaj de 
--eroare daca se insereaza un Echipament care exista deja,
--daca nu sa nu l insereze

if OBJECT_ID('Echipament_Existent','TR') is not null
	drop trigger Echipament_Existent
go
create TRIGGER Echipament_Existent
on Echipamente
After Insert
as 
BEGIN
	if exists(select count(*) from inserted I
				join Echipamente C
				on C.Denumire=I.Denumire
				group by I.Denumire
				having count(*)>1)
		raiserror('Ati introdus un echipament care deja exista',16,1)
	else
		print 'e ok'
END
go
begin tran
	insert into Echipamente(Denumire,Cantitate) values
	('Aragaz',2)
rollback

