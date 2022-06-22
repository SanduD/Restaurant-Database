--1. Sa se creeze o procedura stocata care sa afiseze angajatii nascuti intre anul xxxx-yyyy. Sa se execute apoi procedura pentru anii 2000-2003.

if OBJECT_ID('Angajati_An1_An2','P') is not null
	drop proc Angajati_An1_An2;
GO

create PROC Angajati_An1_An2
	@An1 as int=1997,
	@An2 as int=2002,
	@numRows int=0 output
as 
BEGIN
	select * from Angajati 
	where year(DataNastere) between @An1 and @An2
	set @numRows=@@ROWCOUNT
	return;
END


DECLARE @numRowsReturned AS INT;
exec Angajati_An1_An2
	@An1=2000,
	@An2=2003,
	@numRows=@numRowsReturned output;

SELECT @numRowsReturned AS 'Number of rows returned'

	
--2. Sa se creeze o procedura stocata care sa afiseze angajatii de un anumit sex, care sunt dintr-un anumit oras si al caror prenume se termina intr o anumita litera. Sa se execute procedura pentru Angajatii de sex Masculin, din orasul Bacau al caror prenume se termina in s.

if object_id('Angajati_sex_oras_litera','P') is not null
	drop proc Angajati_sex_oras_litera

GO
CREATE PROC Angajati_sex_oras_litera
	@mSex as varchar(16),
	@mOras as varchar(16),
	@mLitera as varchar(2),
	@numRows as int =0 output
as
BEGIN
	select IdAngajat,Nume,Prenume,Sex, Oras from Angajati
	where Sex=@mSex
		and Oras=@mOras
		and Nume like @mLitera
	set @numRows=@@ROWCOUNT
	return;
END 

declare @numRowsReturned as int;
exec Angajati_sex_oras_litera
	@mSex='Masculin',
	@mOras='Bacau',
	@mLitera='S%',
	@numRows =@numRowsReturned output;

SELECT @numRowsReturned AS 'Number of rows returned'

--3. Sa se creeze o procedura stocata care sa afiseze mesele care au un anumit status si au avut un numar de rezervari mai mare de 1

if object_id('StatusMese','P') is not null
	drop proc StatusMese

GO
create PROC StatusMese
	@mStatus as varchar(16),
	@mNumarRezervari int,
	@numRows int =0 output

as
BEGIN
	select M.IdMasa,count(R.IdMasa) as 'Numar Rezervari' from Mese M
	join Rezervari R
	on R.IdMasa=M.IdMasa
	where M.Status=@mStatus
	group by M.IdMasa
	having  count(R.IdMasa)>=@mNumarRezervari
	set @numRows=@@ROWCOUNT
	return;
end;

declare @numRowsReturned as int;
exec StatusMese
	@mStatus='Rezervata',
	@mNumarRezervari=1,
	@numRows=@numRowsReturned output;
SELECT @numRowsReturned AS 'Number of rows returned'

--4. Sa se creeze o procedura stocata care sa afiseze Numele,prenumele,cnp-ul si data angajarii persoanelor care sunt angajate dupa o anumita data si care inca lucreaza, si al caror nume se termina cu o anumita litera, iar cnp-ul incepe cu o anumita cifra

if OBJECT_ID('AngajatiData','P') is not null
	drop proc AngajatiData
GO
CREATE PROC AngajatiData
	@mDataAngajare date,
	@mLiteraPrenume varchar(2),
	@mCifraCNP varchar(2)
as
BEGIN 
	select A.Nume,A.Prenume,A.CNP,FA.DataAngajare from Angajati A
	join FunctiiAngajati FA
	on FA.IdAngajat=A.IdAngajat
	where FA.DataAngajare>=@mDataAngajare and FA.DataDemitere is null
			and A.Prenume like @mLiteraPrenume 
			and A.CNP like @mCifraCNP
	return;
END

exec AngajatiData
	@mDataAngajare='2020-02-01',
	@mLiteraPrenume='%a',
	@mCifraCNP='5%'

--5. Sa se creeze o procedura care sa afiseze Id-ul comenzii si modalitatea de plata, de la mesele de o anumita capacitate care au o anumita modalitate de plata


if OBJECT_ID('Capacitate_ModalitatePlate_Mese','P') is not null
	drop proc Capacitate_ModalitatePlata_Mese
GO
CREATE PROC Capacitate_ModalitatePlata_Mese
	@mCapacitate int,
	@mModalitatePlata nvarchar(8)
as
BEGIN 
	select C.IdComanda,C.ModalitatePlata from Comenzi C
	inner join Mese M
	on C.IdMasa=M.IdMasa
	where M.Capacitate=@mCapacitate
		and C.ModalitatePlata=@mModalitatePlata
	return;
END

exec Capacitate_ModalitatePlata_Mese
	@mCapacitate =10,
	@mModalitatePlata='Cash'

--6. Sa se creeze o procedura care sa afiseze comanda care contine un anumit Preparat si sa se afiseze ingredientele acestuia.

if OBJECT_ID('IngredientePreparatComanda','P') is not null
	drop proc IngredientePreparatComanda
GO
CREATE PROC IngredientePreparatComanda
	@mDenumirePreparat1 nvarchar(32),
	@mDenumirePreparat2 nvarchar(32)
as
BEGIN 
	select distinct IdComanda, P.Denumire,I.Denumire from ContinutComanda C
	inner join Preparate P
	on C.IdPreparat=P.IdPreparat
	inner join IngredientePreparate Ipp
	on Ipp.IdPreparat=P.IdPreparat
	inner join Ingrediente I
	on ipp.IdIngredient=I.IdIngredient
	where P.Denumire=@mDenumirePreparat1
		or P.Denumire=@mDenumirePreparat2
	return;
END
select * from Preparate
exec IngredientePreparatComanda 
	@mDenumirePreparat1='Platoul Drumetului',
	@mDenumirePreparat2='Ciorba de legume'


--7. Sa se creeze o procedura sa afiseze Echipamentele livrate de o anumita firma si care se afla pe stoc intr un numar mai mare dat ca parametru procedurii

if OBJECT_ID('FirmaEchipamente','P') is not null
	drop proc FirmaEchipamente
go
create proc FirmaEchipamente
	@numeFirma nvarchar(32),
	@StocMinim int
as
begin
	select E.Denumire,E.Cantitate from Echipamente E
	inner join FurnizoriEchipamente FE
	on E.IdEchipament=FE.IdEchipament
	inner join Furnizori F
	on F.IdFurnizor=FE.IdFurnizor
	where F.Denumire=@numeFirma 
		and E.Cantitate>=@StocMinim
	return
end


exec FirmaEchipamente
	@numeFirma='SC BRILL CATERING SRL',
	@StocMinim=3

--8. Sa se afiseze Numele angajatilor care au lucrat mai mult de x luni pe o functie, care data de nastere dupa un anumit an si care au un anumit sex, si un anumit oras

if OBJECT_ID('Vechime_Angajati','P') is not null
	drop proc Vechime_Angajati
GO

create PROC Vechime_Angajati
	@nrLuni int,
	@anNastere int,
	@mSex nvarchar(8),
	@mOras nvarchar(16)
as
BEGIN
	 select A.Nume,A.Prenume,A.Oras,A.Sex,F.Denumire from Angajati A
	 inner join FunctiiAngajati FA
	 on A.IdAngajat=FA.IdAngajat
	 inner join Functii F
	 on F.IdFunctie=FA.IdFunctie
	 where DATEDIFF(month,FA.DataAngajare,GETDATE())>=@nrLuni
		and year(DataNastere)>=@anNastere
		and A.Oras=@mOras
		and A.Sex=@mSex
	 return
END

exec Vechime_Angajati
	@nrLuni =12,
	@anNastere =2000,
	@mSex ='Masculin',
	@mOras ='Bacau'

--9. Sa se creeze o procedura care sa afiseze denumirea ingredientelor care apar in cel putin intr-un anumit numar de retete si care incep cu o anumita litera.


if OBJECT_ID('AparitiiIntgrediente','P') is not null
	drop proc AparitiiIntgrediente
GO
CREATE PROC AparitiiIntgrediente
	@mNrAparitii int,
	@mLitera varchar(2)
as
BEGIN 
	select I.Denumire,count(*) as 'NrAparitii' from Ingrediente I
	join IngredientePreparate Ipp
	on Ipp.IdIngredient=I.IdIngredient
	where I.Denumire like @mLitera
	group by I.Denumire
	having count(*)>=@mNrAparitii
	return;
END
exec AparitiiIntgrediente
	@mNrAparitii=2,
	@mLitera='P%'


--10. Sa se creeze o procedura care sa afiseze facturile care se afla intre doua sume de plata si care au fost emise dupa o anumita data de catre un furnizor care este dintr-un anumit oras.

if OBJECT_ID('Facturi_suma_furnizori','P') is not null
	drop proc Facturi_suma_furnizori
GO
CREATE PROC Facturi_suma_furnizori
	@mSuma1 int,
	@mSuma2 int,
	@mDataEmitere1 date,
	@mDataEmitere2 date,
	@mOras nvarchar(50),
	@numRows int output
as
BEGIN 
	select IdFactura,Serie,Numar,DataEmitere,SumaPlata from Facturi F
	join Furnizori Fu
	on Fu.IdFurnizor=F.IdFurnizor
	where F.SumaPlata between @mSuma1 and @mSuma2
		and F.DataEmitere between @mDataEmitere1 and @mDataEmitere2
		and FU.Oras=@mOras
	set @numRows=@@ROWCOUNT
	return;
END

declare @numRowsReturned int;
exec Facturi_suma_furnizori
	@mSuma1=500,
	@mSuma2=8000,
	@mDataEmitere1='2020-02-04',
	@mDataEmitere2='2022-05-04',
	@mOras= 'Cluj-Napoca',
	@numRows=@numRowsReturned output

SELECT @numRowsReturned AS 'Number of rows returned'
