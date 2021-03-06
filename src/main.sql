--COPIE DES DONNEES DE L'ENQUETE EMPLOI
DROP TABLE INED.EE.TCM;
with TCM as (
select cast(row_number() over(order by NUMFA, NOI) as int) as ID,*
from
(SELECT NUMFA, NOLOG, NOI, PRENOM,SEXE, AGE, PERE, MERE, NOICON as CONJOINT ,[LIENPERS1]
FROM [EnqueteEmploi].[SOC18].[Menage] where numfa not in (160405,160407)
union
SELECT NUMFA, NOLOG, NOI, PRENOM,SEXE, AGE, PERE, MERE, NOICON as CONJOINT ,[LIENPERS1]
FROM [EnqueteEmploi].[ARC18].[Menage]) a)

select  a.ID, cast(a.NUMFA as int) as NUMFA, a.NOI, a.PRENOM,a.SEXE, a.AGE,
b.ID as IDPERE, c.ID as IDMERE, d.ID as IDCONJOINT,d.SEXE as SEXECONJOINT, a.LIENPERS1, e.ID as IDPERS1, f.LIEN 
into INED.EE.TCM
from TCM a
left outer join TCM b on a.NUMFA=b.NUMFA and a.PERE=b.NOI
left outer join TCM c on a.NUMFA=c.NUMFA and a.MERE=c.NOI
left outer join TCM d on a.NUMFA=d.NUMFA and a.CONJOINT=d.NOI
left outer join (select * from TCM where NOI=1) e on a.NUMFA=e.NUMFA
left outer join INED.EE.Liens f on a.LIENPERS1=f.idLien


--CREATION DES TROIS VUES PRINCIPALES

CREATE view [EE].[vLinks] as 
select distinct T1.NUMFA, IDFROM, IDTO, T2.PRENOM as [FROM], T3.PRENOM  as [TO],  T1.IDLIEN, EE.Liens.LIEN,
concat(T2.PRENOM,' (',T2.AGE, ' ans) ',EE.Liens.LIEN, ' de ', T3.PRENOM, ' (',T3.Age, ' ans) ') as LIENCLAIR
 from 
(
select  NUMFA, IDPERE as IDFROM, ID as IDTO,  15 as IDLIEN from EE.TCM where IDPERE is not null 
union
select  NUMFA, IDMERE, ID,  16 as IDLIEN from EE.TCM where IDMERE is not null 
union
select  NUMFA, IDCONJOINT, ID,  19 as IDLIEN from EE.TCM where IDCONJOINT is not null and SEXECONJOINT=1
union
select  NUMFA, IDCONJOINT, ID,  20 as IDLIEN from EE.TCM where IDCONJOINT is not null and SEXECONJOINT=2
union
select  NUMFA, ID, IDPERS1,  LIENPERS1 from EE.TCM where LIENPERS1 is not null
) T1
left outer join EE.Liens on T1.IDLIEN=EE.Liens.idLien
left outer join EE.TCM T2 on T1.IDFROM=T2.ID
left outer join EE.TCM T3 on T1.IDTO=T3.ID



create view [EE].[vNodes] as 
select ID,NUMFA, NOI, PRENOM,AGE,SEXE from EE.TCM
GO
/****** Object:  View [EE].[vGenealogy]    Script Date: 19/03/2019 16:08:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [EE].[vGenealogy] as
select numfa, id, concat(t1.child,'-',numfa) as child, year, iif(parent is not null, concat(parent,'-',numfa), null) as parent from
(
select a.numfa, a.IDTO as id, c.PRENOM as child, 2019-c.age as year, b.Prenom as parent from EE.vLinks a
left outer join EE.vNodes b on a.IDFROM=b.ID
left outer join EE.vNodes c on a.IDTO=c.ID
where a.IDLIEN=15
union
select a.numfa, a.IDTO as id, c.PRENOM as child, 2019-c.age as year, b.Prenom as parent from EE.vLinks a
left outer join EE.vNodes b on a.IDFROM=b.ID
left outer join EE.vNodes c on a.IDTO=c.ID
where a.IDLIEN=16
union
select  numfa, id, PRENOM as child, 2019-AGE as year, NULL as parent from EE.TCM where IDMERE is null and IDPERE is null) t1


GO
