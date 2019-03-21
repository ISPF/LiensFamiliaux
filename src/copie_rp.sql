with IDBIS as (select IDBI, row_number() over(order by IDBI) as ID from RP2017.Cube.BI),
IDFLS as (select IDFL, row_number() over(order by IDFL) as NUMFA from (select distinct IDFL from RP2017.Cube.BI) a),

BI1 as (
SELECT a.IDBI, a.IDFL, a.IDInd, a.Age3112 as AGE, a.B01 as SEXE,
c.Prénom as PRENOM, c.LienParente
from RP2017.Cube.BI a
left outer join RP2017.dbo.FL b on a.IDFL=b.IDFL
left outer join RP2017.dbo.FL_ListeA c on b.ROW_INDEX=c.FL_Int_ROW_INDEX and a.IDBI=concat(a.IDFL,'_', right(concat('00',c.BI),2))
where a.CatCom is null and IndividusRP=1),

BI2 as 
(select b.ID, c.NUMFA, IDInd as NOI, 
ltrim(rtrim(isnull(PRENOM, concat('P',b.ID)))) as PRENOM, AGE, SEXE 
from BI1 a
left outer join IDBIS b on a.IDBI=b.IDBI
left outer join IDFLS c on a.IDFL=c.IDFL)
--order by a.idbi)

/*select c.ID, NUMFA, NOI, d.PRENOM, AGE, c.SEXE 
into INED.RP.BI
from 
(select a.*, ABS(CHECKSUM(NEWID())) % IDMAX+1 as IDAlea from BI2 a
left outer join (select SEXE, max(id) as IDMAX from Prenoms group by SEXE) b on a.SEXE=b.SEXE) c
left outer join Prenoms d on c.SEXE=d.SEXE and c.IDAlea=d.ID

alter table INED.RP.BI ALTER COLUMN ID INTEGER NOT NULL
alter table INED.RP.BI ALTER COLUMN AGE INTEGER 
alter table INED.RP.BI ALTER COLUMN SEXE INTEGER
alter table INED.RP.BI ADD CONSTRAINT PK_IDBI PRIMARY KEY (ID);*/

select  distinct d.NUMFA, b.ID as IDFROM, c.ID as IDTO, e.PRENOM as [FROM], f.PRENOM as [TO], e.SEXE, h.idLien,h.LIEN,
concat(e.PRENOM,' (',e.AGE, ' ans) ',h.LIEN, ' de ', f.PRENOM, ' (',f.Age, ' ans) ') as LIENCLAIR
into INED.RP.Liens
from RP2017.dbo.Liens a
left outer join IDBIS b on a.IDBI1=b.IDBI
left outer join IDBIS c on a.IDBI2=c.IDBI
left outer join IDFLS d on a.IDFL=d.IDFL
left outer join INED.RP.BI e on b.ID=e.id
left outer join INED.RP.BI f on c.ID=f.id
left outer join INED.RP.NKL_Liens g on a.idLienParente=g.idLienParente and e.SEXE=g.Sexe
left outer join INED.EE.NKL_Liens h on g.idLienParentEE=h.idLien
where d.NUMFA is not null and b.ID is not null and c.id is not null and h.idLien is not null
order by d.NUMFA, b.ID



--TODO : create primary key
alter table INED.RP.Liens ALTER COLUMN NUMFA INTEGER NOT NULL
alter table INED.RP.Liens ALTER COLUMN IDFROM INTEGER NOT NULL
alter table INED.RP.Liens ALTER COLUMN IDTO INTEGER NOT NULL
alter table INED.RP.Liens ALTER COLUMN idLien INTEGER NOT NULL
alter table INED.RP.Liens ADD CONSTRAINT PK_RPLiens PRIMARY KEY (NUMFA, IDFROM, IDTO, idLIEN);



CREATE INDEX RPLiensNUMFA_ix ON INED.RP.Liens (NUMFA, IDFROM);


CREATE view [RP].[vGenealogy] as
select numfa, id, concat(t1.child,'-',numfa) as child, year, iif(parent is not null, concat(parent,'-',numfa), null) as parent from
(
select a.numfa, a.IDTO as id, c.PRENOM as child, 2019-c.age as year, b.Prenom as parent from RP.Liens a
left outer join RP.BI b on a.IDFROM=b.ID
left outer join RP.BI c on a.IDTO=c.ID
where a.IDLIEN=15
union
select a.numfa, a.IDTO as id, c.PRENOM as child, 2019-c.age as year, b.Prenom as parent from RP.Liens a
left outer join RP.BI b on a.IDFROM=b.ID
left outer join RP.BI c on a.IDTO=c.ID
where a.IDLIEN=16) t1
