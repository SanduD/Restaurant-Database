use master
go
DROP DATABASE IF EXISTS HanulAncutei;
GO
CREATE DATABASE HanulAncutei
ON PRIMARY
(
Name = RestaurantData,
FileName = 'E:\Anul 2\SEM 2\EXAMEN\Baza de date\ProiectBD\HanulAncutei.mdf',
size = 10MB, -- KB, Mb, GB, TB
maxsize = unlimited,
filegrowth = 10MB
),
(
Name = RestaurantData2,
FileName = 'E:\Anul 2\SEM 2\EXAMEN\Baza de date\ProiectBD\HanulAncutei_2.ndf',
size = 10MB, -- KB, Mb, GB, TB
maxsize = unlimited,
filegrowth = 10MB
),
(
Name = RestaurantData3,
FileName = 'E:\Anul 2\SEM 2\EXAMEN\Baza de date\ProiectBD\HanulAncutei_3.ndf',
size = 10MB, -- KB, Mb, GB, TB
maxsize = unlimited,
filegrowth = 10MB
)
LOG ON
(
Name = RestaurantLog1,
FileName = 'E:\Anul 2\SEM 2\EXAMEN\Baza de date\ProiectBD\HanulAncutei_log1.ldf',
size = 10MB, -- KB, Mb, GB, TB
maxsize = unlimited,
filegrowth = 10%
),
(
Name = RestaurantLog2,
FileName = 'E:\Anul 2\SEM 2\EXAMEN\Baza de date\ProiectBD\HanulAncutei_log2.ldf',
size = 10MB, -- KB, Mb, GB, TB
maxsize = unlimited,
filegrowth = 10%
)
go
use HanulAncutei
go
create table Angajati(
IdAngajat int not null identity(1,1) primary key,
Nume nvarchar(64) not null,
Prenume nvarchar (32) not null,
DataNastere date not null,
CNP nvarchar(13) not null,
Sex nvarchar(8),
Oras nvarchar(32)
);

create table Functii(
IdFunctie int not null identity(1,1) primary key,
Denumire nvarchar(32) not null,
Salariu float not null);

create table FunctiiAngajati(
IdAngajat int constraint FK_IdAngajat_FunctiiAngajati foreign key(IdAngajat) references Angajati(IdAngajat),
IdFunctie int constraint FK_IdFunctie_FunctiiAngajati foreign key(IdFunctie) references Functii(IdFunctie),
DataAngajare date,
DataDemitere date);

create table Mese(
IdMasa int not null identity (1,1) primary key,
Capacitate int not null,
Status nvarchar (16));


create table Comenzi(
IdComanda int not null identity (1,1) primary key,
IdMasa int constraint FK_IdMasa_Comenzi foreign key(IdMasa) references Mese(IdMasa),
DataPlasareComanda datetime,
PretComanda float ,
ModalitatePlata nvarchar(16) not null 
);

create table Preparate(
IdPreparat int not null identity (1,1) primary key,
Denumire nvarchar(32) not null,
PretPreparat float not null);

create table ContinutComanda(
IdComanda int constraint FK_IdComanda_ContinutComanda foreign key(IdComanda) references Comenzi(IdComanda),
IdPreparat int constraint FK_IdPreparat_ContinutComanda foreign key(IdPreparat) references Preparate(IdPreparat),
Cantitate int not null
);

create table Ingrediente(
IdIngredient int not null  identity (1,1) primary key,
Denumire nvarchar(32) not null);

create table IngredientePreparate(
IdPreparat int constraint FK_IdPreparat_IngredientePreparate foreign key(IdPreparat) references Preparate(IdPreparat),
IdIngredient int constraint FK_IdIngredient_IngredientePreparate foreign key(IdIngredient) references Ingrediente(IdIngredient),
);

create table Furnizori(
IdFurnizor int not null  identity (1,1) primary key,
Denumire nvarchar(32) not null,
Oras nvarchar(32) not null,
NrTelefon nvarchar(10) not null);

create table FurnizoriIngrediente(
IdIngredient int constraint FK_Ingredient_FurnizoriIngrediente foreign key(IdIngredient) references Ingrediente(IdIngredient),
IdFurnizor int constraint FK_Furnizori_FurnizoriIngrediente foreign key(IdFurnizor) references Furnizori(IdFurnizor),
Catitate int not null,
PretUnitate float not null);


create table Echipamente(
IdEchipament int not null  identity (1,1) primary key,
Denumire nvarchar(32) not null,
Cantitate int);

create table FurnizoriEchipamente(
IdEchipament int constraint FK_Echipament_FurnizoriEchipamente foreign key(IdEchipament) references Echipamente(IdEchipament),
IdFurnizor int constraint FK_Furnizori_FurnizoriEchipamente foreign key(IdFurnizor) references Furnizori(IdFurnizor),
Numar_Bucati int null);


create table Facturi(
IdFactura  int  not null  identity (1,1) primary key,
IdFurnizor int constraint FK_Furnizori_Facturi foreign key(IdFurnizor) references Furnizori(IdFurnizor),
Serie nvarchar(2) not null,
Numar int not null,
DataEmitere date not null, 
SumaPlata float not null);


create table Rezervari(
IdRezervare  int  not null  identity (1,1) primary key,
IdMasa int constraint FK_IdMasa_Rezervari foreign key(IdMasa) references Mese(IdMasa),
NumeClient nvarchar(32) not null,
DataRezervare datetime not null);




insert into Angajati(Nume,Prenume,DataNastere,CNP,Sex,Oras) values
('Sandu','Dragos', '2001-10-26','5011026046200','Masculin','Bacau'),
('Barbusi','Darius', '2001-05-10','5011011146203','Masculin','Valcea'),
('Toader','Radu', '2001-07-25','5022011146102','Masculin','Bacau'),
('Corbu','Nutu', '2002-01-06','2022015566600','Masculin','Bucuresti'),
('Cioloca','Paul', '2000-02-05','5011015566501','Masculin','Reghin'),
('Ursachi','Marta', '2002-04-14','2021011122501','Feminin','Botosani'),
('Sandu','Codruta', '1997-03-30','5970330101112','Feminin','Valcea'),
('Barbusi','Marinela', '1975-01-20','5971010044501','Feminin','Botosani'),
('Toader','Andreea', '1998-12-05','5981205225012','Feminin','Cluj-Napoca'),
('Putin','Vladimir', '1965-06-28','2650628145011','Masculin','Bacau'),
('Cioloca','Ioan', '1970-08-21','2700821122501','Feminin','Reghin'),
('Ursachi','Violeta', '1976-09-25','5760905122501','Feminin','Suceava')

insert into Functii(Denumire,Salariu) values
('Manager',6000),
('Administrator',5000),
('Director bucatarie',5000),
('Bucatar',6000),
('Ajutor de bucatar',3500),
('Spalator de vase',2000),
('Ospatar Sef',4000),
('Barman',3500),
('Chelner',3000),
('Om de serviciu',2000)


insert into FunctiiAngajati(IdAngajat,IdFunctie,DataAngajare,DataDemitere) values
(1,1,'2019-05-26','2020-05-18'),
(2,2,'2019-06-18',null),
(3,4,'2019-03-10','2021-06-17'),
(6,9,'2019-05-25','2020-05-19'),
(6,2,'2020-05-19','2022-02-25'),
(4,8,'2020-01-05','2021-06-20'),
(5,7,'2019-05-26',null),
(6,1,'2022-02-25',null),
(3,3,'2021-06-18',null),
(3,4,'2020-05-10',null),
(7,8,'2019-05-26',null),
(8,10,'2019-03-10',null),
(8,6,'2019-09-20',null),
(9,9,'2019-04-26','2020-05-10'),
(10,6,'2020-08-20',null),
(9,7,'2020-05-10',null),
(11,8,'2019-10-25',null),
(12,10,'2019-05-29','2020-07-20'),
(12,6,'2020-07-20',null)



insert into Mese (Capacitate,Status) values
(2,'Libera'),
(4,'Ocupata'),
(2,'Rezervata'),
(10,'Libera'),
(8,'Rezervata'),
(4,'Ocupata'),
(12,'Libera'),
(16,'Rezervata'),
(2,'Libera'),
(2,'Ocupata'),
(4,'Libera'),
(4,'Rezervata'),
(4,'Ocupata')

insert into Comenzi(IdMasa,DataPlasareComanda,ModalitatePlata) values
(1,'2022-04-10 12:35:20','Cash'),
(4,'2022-04-10 14:12:00','Card'),
(3,'2022-04-11 09:40:19','Cash'),
(6,'2022-04-10 15:50:10','Cash'),
(2,'2022-04-12 19:49:10','Voucher'),
(1,'2022-04-12 21:49:10','Cash'),
(4,'2022-04-12 21:12:00','Cash'),
(3,'2022-04-13 10:22:19','Card'),
(6,'2022-04-13 12:20:20','Card'),
(6,'2022-04-13 13:40:19','Cash'),
(7,'2022-04-14 14:40:19','Card'),
(7,'2022-04-14 14:12:00','Card'),
(8,'2022-04-14 19:49:10','Voucher'),
(4,'2022-04-14 21:20:10','Cash')


insert into Preparate(Denumire,PretPreparat) values
('Ciorba de burta',14),
('Ciorba radauteana',13),
('Ciorba de afumatura',14),
('Ciorba de legume',12),
('Ciorba de vacuta',14),
('Ciorba de perisoare',14),
('Ciorba de fasole',13),
('Aperitiv Moldovenesc',29),
('Aperitiv Oltenesc',26),
('Meniul Zilei',20),
('Meniul Studentului',15),
('Ceafa la gratar',20),
('Cotlet de porc',22),
('Piept de pui',20),
('Pastrama de oaie',30),
('Pastrav la gratar',25),
('Somon',30),
('Ciulama de pui',25),
('Platoul Ciobanului',54),
('Platoul Drumetului',52),
('Platoul Padurarului',80),
('Platou Moldovenesc',99),
('Cartofi prajiti',7),
('Cartofi la ceaun',8),
('Cartofi piure',7),
('Cartofi taranesti',9),
('Orez basmati',8),
('Orez cu legume',7),
('Salata mixta',7),
('Salata de varza',6),
('Salata de varza rosie',6),
('Muraturi',7),
('Papanasi',18),
('Orez cu lapte',14),
('Inghetata de casa',16),
('Cremsnit',14),
('Tortul Casei',16),
('Clatite',16),
('Coca-Cola',8),
('Fanta',8),
('Sprite',8),
('Cappy',8),
('Mirinda',8),
('Sex on the beach',18),
('Mojito',18),
('Hurricane',16),
('Zombie',20),
('White Russian',18),
('Godfather',18),
('Vinul casei',30),
('Feteasca',40),
('Moet',400),
('Prosecco',30),
('Tuborg',7),
('Carlsberg',8),
('Peroni',8),
('Corona extra',15),
('Vodka',10),
('Jagermeister',10),
('B52',12)

insert into ContinutComanda(IdComanda,IdPreparat,Cantitate) values
(1,1,1),(1,2,1),(1,8,1),(1,20,1),(1,14,1),(1,24,1),(1,30,2),(1,39,2),(1,33,2),
(2,2,2),(2,11,2),(2,34,2),(2,60,2),
(3,10,3),(3,33,2),(3,54,3),
(4,3,2),(4,15,1),(4,22,1),(4,29,1),(4,50,2),
(5,20,1),(5,21,1),(5,26,2),(5,31,2),(5,34,2),(5,57,2),
(6,4,2),(6,21,3),(6,50,2),(6,55,2),
(7,2,1),(7,20,2),(7,52,2),
(8,3,1),(8,22,1),(8,53,1),
(9,2,3),(9,4,2),(9,21,1),(9,36,2),(9,27,1),(9,17,1),
(10,6,1),(10,7,2),(10,9,1),(10,12,2),(10,14,1),(10,23,4),(10,56,6),
(11,8,3),(11,2,1),(11,18,2),(11,19,1),(11,40,1),
(12,33,2),(12,34,2),(12,41,2),(12,42,2),
(13,16,1),(13,24,1),(13,44,1),
(14,4,2),(14,20,2),(14,55,2)


insert into Furnizori(Denumire,Oras,NrTelefon) values
('ALIRO MARMIR SRL','Cluj-Napoca','0264708703'),
('SC BRILL CATERING SRL','Cluj-Napoca','0758755992'),
('ESAROM ROMANIA SRL','Sibiu','0269208031'),
('SC VANIMAR BLUE COMPANY SRL','Constanta','0241541910'),
('SC FORTEX COM SRL','Valcea','0214106307'),
('SC DACTRUST SRL','Bucuresti','0758071304'),
('Espina România Prod S.r.l','Timisoara','0722405140 '),
('Macelaria AGAPE','Suceava','0744169483'),
('Fresh Fruits Logistics','Bucuresti','0767917258')

insert into Facturi(IdFurnizor, Serie,Numar,DataEmitere,SumaPlata) values
(1,'EE',100335,'2022-04-01',1504),
(7,'AA',233555,'2022-04-02',5069),
(2,'EE',334532,'2022-04-04',2500),
(3,'AA',321333,'2022-03-25',569),
(5,'EA',456654,'2022-03-30',4532),
(6,'ED',233421,'2022-02-28',4532),
(6,'SW',717433,'2022-05-06',7833),
(8,'KW',016768,'2022-09-16',3017),
(3,'HH',617383,'2022-02-06',4118),
(3,'DC',359214,'2021-07-03',7387),
(2,'QK',337735,'2022-01-06',6427),
(2,'SR',172681,'2022-01-20',2129),
(8,'BH',053505,'2022-06-10',5972),
(8,'RT',574955,'2022-10-22',3499),
(9,'FK',433532,'2022-11-09',5509),
(5,'GJ',855044,'2022-08-28',2886);


insert into Echipamente (Denumire) values
('Aragaz'),
('Hota'),
('Masa inox'),
('Frigider'),
('Lada Frigorifica'),
('Cuptor Pizza'),
('Malaxor'),
('Fripteoza'),
('Gratar grill'),
('Cuptor cu microunde'),
('Fierbator'),
('Masina de curatat cartofi'),
('Blender'),
('Mixer'),
('Farfurii'),
('Bol'),
('Furculite'),
('Linguri'),
('Lingurite')

insert into FurnizoriEchipamente (IdEchipament,IdFurnizor,Numar_Bucati) values
(1,1,2),(1,3,2),
(2,1,3),(2,3,2),(2,2,1),
(3,4,1),(3,5,2),
(4,3,2),(4,4,3),
(5,6,3),(5,5,1),(5,4,2),
(6,2,4),
(7,3,1),(7,5,2),
(8,2,2),(8,3,1),
(9,1,2),(9,2,1),
(10,3,3),
(11,2,2),
(12,4,2),(12,2,1),
(13,3,2),(13,4,1),
(14,5,1),(14,2,1),(14,3,1),
(15,1,500),
(16,1,500),
(17,3,500),
(18,3,500),
(19,3,300)


insert into Ingrediente(Denumire) values
('Patrunjel'),('Marar'),('Busuioc'),('Piept de pui'),('Ceafa de porc'),('Burta de vita'),('Pastrama Oaie'),('Paste integrale'),('Sunca porc'),('Salam uscat'),('Muschi file'),
('Pastrav'),('Somon'),('Orez'),('Cartofi'),('Ceapa'),('Ardei iute'),('Gogonele'),('Lamaie'),('Varza'),('Rosii'),('Castraveti'),('Muschi file'),('Bors'),
('Branza de oaie'),('Branza de vaci'),('Smantana'),('Mustar'),('Fasole'),('Morcov'),('Nuca'),('Otet'),('Ulei'),('Ou'),('Faine'),('Pepene'),('Porumb'),('Apa'),
('Carnati de porc'),('Muschi Afumat'),('Branza de burduf'),('Ciuperci'),('Carne de vacuta'),('Fasole'),('Costita afumata')

insert into FurnizoriIngrediente(IdIngredient,IdFurnizor,Catitate,PretUnitate) values
(1,9,50,1),(2,9,50,1),(3,9,50,2),(4,7,50,24),(5,7,50,2),(6,7,20,30),(7,6,20,5),(8,8,10,40),(9,8,10,60),(10,8,10,50),(11,8,10,55),(12,8,80,15),
(13,7,10,15),(14,9,50,3),(15,9,10,5),(16,9,10,12),(17,9,20,6),(18,9,10,10),(19,7,20,6),(20,9,30,10),(21,9,25,6),(22,8,20,50)


insert into IngredientePreparate(IdPreparat,IdIngredient) values
(1,1),(1,38),(1,6),(1,27),
(2,1),(2,38),(2,4),(2,27),
(3,1),(3,38),(3,45),(2,27),
(4,38),(4,1),(4,24),(4,15),(4,2),
(5,1),(5,38),(5,43),(5,27),
(6,1),(6,38),(6,4),(6,27),
(7,1),(7,38),(7,44),
(12,5),
(14,4),
(19,4),(19,5),(19,7),(19,34),(19,25),(19,18),
(20,4),(20,39),(20,40),(20,41),(20,9),(20,16),(20,18),(20,28),
(18,4),(18,27),(18,42)


insert into Rezervari(IdMasa,NumeClient,DataRezervare) values
(1,'Popescu','2022-04-09 15:00:00'),
(5,'Jipianu','2022-04-10 17:00:00'),
(2,'Ghita','2022-04-10 19:00:00'),
(3,'Iulia','2022-04-11 20:00:00'),
(2,'Paul','2022-04-11 21:00:00'),
(5,'Darius','2022-04-11 12:30:00'),
(5,'Radu','2022-05-12 13:30:00'),
(6,'Istrate','2022-05-12 20:00:00'),
(7,'Elena','2022-05-13 19:30:00'),
(7,'Sebi','2022-05-14 14:00:00')


BACKUP DATABASE HanulAncutei
TO DISK = 'E:\Anul 2\SEM 2\EXAMEN\Baza de date\ProiectBD\HanulAncutei.bak'
WITH init, format, stats = 10
