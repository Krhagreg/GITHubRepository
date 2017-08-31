--CREATION COLONNE CORRESPONDANCES

--ALTER TABLE AtooCGA40..JOURNAL_ECHANGES ADD id_echange_old bigint null
--ALTER TABLE AtooCGA40..JOURNAL_ECHANGES ADD id_echange_parent_old bigint null
--ALTER TABLE AtooCGA40..JOURNAL_ECHANGES_PJ ADD fusion int null
--ALTER TABLE AtooCGA40..NATURES_ECHANGES ADD fusion int null
----INSERT INTO TYPES_ECHANGES select * from AtooCGA40..TYPES_ECHANGES where ID_NATURE_ECHANGE in (96,97)
--ALTER TABLE AtooCGA40..TYPES_ECHANGES ADD fusion int null



begin tran
--if ((select count (*) from NATURES_ECHANGES where NATURE in ('ASM','REM','RP0','RT0')) < 1)
--begin

--INSERT INTO NATURES_ECHANGES (LIBELLE_NATURE_ECHANGE, NATURE, ATOO) select LIBELLE_NATURE_ECHANGE, NATURE, ATOO from AtooCGA40..NATURES_ECHANGES where NATURE in ('ASM','REM','RP0','RT0')
--INSERT INTO [dbo].[TYPES_ECHANGES]
--           ([ID_SOURCE_ECHANGE]
--           ,[ID_NATURE_ECHANGE]
--           ,[MANUEL]
--           ,[DELAI]
--           ,[ETAT_EVT]
--           ,[OBJET]
--           ,[ID_SOURCE_ECHANGE_SUIVANT]
--           ,[ID_NATURE_ECHANGE_SUIVANT]
--           ,[ATOO]
--           ,[NIVEAU]
--           ,[JNL_ANA])
--select		[ID_SOURCE_ECHANGE]
--           ,a.ID_NATURE_ECHANGE
--           ,[MANUEL]
--           ,[DELAI]
--           ,[ETAT_EVT]
--           ,[OBJET]
--           ,[ID_SOURCE_ECHANGE_SUIVANT]
--           ,[ID_NATURE_ECHANGE_SUIVANT]
--           ,i.ATOO
--           ,[NIVEAU]
--           ,[JNL_ANA]
--		    from AtooCGA40..TYPES_ECHANGES i inner join AtooCGA40..NATURES_ECHANGES n on i.ID_NATURE_ECHANGE = n.ID_NATURE_ECHANGE inner join NATURES_ECHANGES a on a.NATURE = n.NATURE where i.ID_NATURE_ECHANGE in (123, 151, 155,162) order by 2

--end

if object_id('tempdb..#JOURNAL_ECHANGE_TEMP') is not null
DROP table #JOURNAL_ECHANGE_TEMP

select distinct detail,* from AtooCGA40..journal_echanges  where /*id_echange > 518664 and*/ LEN(detail) > 0 and detail not like ('__/__/__%') and detail not like ('Bure%') and detail not like ('Fac%') and detail not like ('Reg%') and detail not like ('Remb%')
select MAX(ID_ECHANGE) from AtooCGA40..journal_echanges  
select MAX(id_pj) from AtooCGA40..journal_echanges_pj  

select * from types_echanges where id_nature_echange = 38

select 
DATE_ECHANGE as DATE_ECHANGE ,CODE_ACTEUR as CODE_ACTEUR,DETAIL as DETAIL,OBJET as OBJET,ID_SOURCE_ECHANGE as ID_SOURCE_ECHANGE
--,nat_target.ID_NATURE_ECHANGE as ID_NATURE_ECHANGE
,AtooCGA40..NATURES_ECHANGES.ID_NATURE_ECHANGE as ID_NATURE_ECHANGE,AtooCGA40..journal_echanges.OBSERVATION as OBSERVATION,TRG_EMETTEUR as TRG_EMETTEUR,TRG_RECEPTEUR as TRG_RECEPTEUR,MEDIA as MEDIA,DATE_ECHEANCE as DATE_ECHEANCE,ETAT_EVT as ETAT_EVT,DATE_EFFET as DATE_EFFET,CHRONO as CHRONO,type_acteur as type_acteur,ID_ACTEUR as ID_ACTEUR,PRESENCE_PJ as PRESENCE_PJ,case when ID_DOCUMENT_MODEL > '0' then NULL else ID_DOCUMENT_MODEL END as ID_DOCUMENT_MODEL,ANNEE_EXERCICE as ANNEE_EXERCICE,DATE_ACHEVEMENT as DATE_ACHEVEMENT,AtooCGA40..journal_echanges.id_echange as id_echange,AtooCGA40..journal_echanges.id_echange_parent as id_echange_parent,AtooCGA40..journal_echanges.ID_NATURE_ECHANGE as old_id_NATURE_echange
into #JOURNAL_ECHANGE_TEMP
from AtooCGA40..journal_echanges
inner join AtooCGA40..NATURES_ECHANGES on AtooCGA40..NATURES_ECHANGES.ID_NATURE_ECHANGE = AtooCGA40..journal_echanges.ID_NATURE_ECHANGE

--select ID_NATURE_ECHANGE, ID_SOURCE_ECHANGE from #JOURNAL_ECHANGE_TEMP group by ID_NATURE_ECHANGE, ID_SOURCE_ECHANGE order by 1, 2

--select * from #JOURNAL_ECHANGE_TEMP where ID_NATURE_ECHANGE > 150 order by 6
--select * from TYPES_ECHANGES where ID_NATURE_ECHANGE > 150 order by 2
--select * from AtooCGA40..TYPES_ECHANGES where ID_NATURE_ECHANGE in (123, 151, 155,162) order by 2
----select * from AtooCGA40..SOURCES_ECHANGES--* where ID_NATURE_ECHANGE > 150

select * from #JOURNAL_ECHANGE_TEMP 

update #JOURNAL_ECHANGE_TEMP set detail = null where LEN(detail) > 0 and detail not like ('Bure%') and detail not like ('Fac%') and detail not like ('Reg%') and detail not like ('Remb%')


 --group by ID_NATURE_ECHANGE, ID_SOURCE_ECHANGE order by 1, 2

 -- modifier id_echange = 1 et nature echange = 117 par id echange = 1 par nature echange = 209

--ROLLBACK TRAN
--BEGIN TRAN

--INJECTION VALEURS JOURNAL ECHANGES AtooCGA40 ADH





INSERT into AtooCGA40..JOURNAL_ECHANGES
	(DATE_ECHANGE,CODE_ACTEUR,DETAIL,OBJET,ID_SOURCE_ECHANGE,ID_NATURE_ECHANGE,OBSERVATION
		,TRG_EMETTEUR,TRG_RECEPTEUR,MEDIA,DATE_ECHEANCE,ETAT_EVT,DATE_EFFET,CHRONO
		,TYPE_ACTEUR,ID_ACTEUR,PRESENCE_PJ,ID_DOCUMENT_MODEL,ANNEE_EXERCICE,DATE_ACHEVEMENT, id_echange_old, id_echange_parent_old)
select DATE_ECHANGE,'Adherent-' + convert (varchar,cga.ID_ADHERENT),DETAIL,OBJET,ID_SOURCE_ECHANGE,ID_NATURE_ECHANGE, adh.OBSERVATION
		,TRG_EMETTEUR,TRG_RECEPTEUR,MEDIA,DATE_ECHEANCE,ETAT_EVT,DATE_EFFET,CHRONO
		,type_acteur,cga.ID_ADHERENT
		,PRESENCE_PJ, ID_DOCUMENT_MODEL,ANNEE_EXERCICE,DATE_ACHEVEMENT, id_echange,id_echange_parent
from #JOURNAL_ECHANGE_TEMP 
	inner join AtooCGA40..ADHERENTS ADH on ADH.ID_ADHERENT = #JOURNAL_ECHANGE_TEMP.id_acteur
	inner join AtooCGA40..ADHERENTS cga on cga.NUM_ADH_OLD = ADH.NUMERO_ADHERENT

where #JOURNAL_ECHANGE_TEMP.TYPE_ACTEUR in ('ADH')



select OBSERVATION,* from AtooCGA40..journal_echanges  where OBSERVATION is not null

select COUNT(*) from AtooCGA40..journal_echanges where TYPE_ACTEUR in ('ADH', 'COR','EXP') and PRESENCE_PJ = 1

select COUNT(*) from AtooCGA40..journal_echanges where TYPE_ACTEUR in ('COR','EXP')
select COUNT(*) from AtooCGA40..journal_echanges where TYPE_ACTEUR in ('ADH')

--select COUNT(*) from AtooCGA40..JOURNAL_ECHANGES
--left join AtooCGA40..bureaux as IB on IB.id_bureau = AtooCGA40..JOURNAL_ECHANGES.id_acteur and TYPE_ACTEUR = 'COR'
--left join AtooCGA40..BUREAUX on AtooCGA40..BUREAUX.CODE_BUR_OLD = IB.CODE_bureau
--left join AtooCGA40..EXPERTS as IE on IE.ID_EXPERT = AtooCGA40..JOURNAL_ECHANGES.id_acteur
--left join AtooCGA40..EXPERTS on AtooCGA40..EXPERTS.ID_EXP_OLD = IE.ID_EXPERT 
--where
--(
--TYPE_ACTEUR in ('ADH', 'COR','EXP') --and PRESENCE_PJ = 1
--)
--and
--(
--	(
--		AtooCGA40..JOURNAL_ECHANGES.TYPE_ACTEUR = 'EXP'
--		and IE.ID_EXPERT not in 
--		(2,4,6,7,8,10,11,13,15,18,19,19,22,24,25,26,29,29,30,31,32,33,34,35,37,38,39,40,41,42,43,44,45,48,49,50,54,93,95,107,108,109,110,111,112,113,126,128,129,130,131,138,155,425,428,432,446,446,449,452,453,460,468,486,487,489,491,492,496,504,506,516,517,520,521,546,546,548,552,574,589,595,603,604,617,621,626,633,634,635,642,665,665,672,674,680,690,690,691,692,693,696,702,710)
--		and AtooCGA40..EXPERTS.ID_EXPERT is not null
--	)
--	or
--	(
--	AtooCGA40..JOURNAL_ECHANGES.TYPE_ACTEUR = 'COR'
--	and IB.ID_BUREAU not in 
--	(783,784,827,1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,17,18,19,20,21,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,39,40,41,53,79,81,88,91,92,93,94,96,98,108,111,112,113,114,124,140,144)
--	--and DETAIL is not null
--	)
--	or
--	(
--	AtooCGA40..JOURNAL_ECHANGES.TYPE_ACTEUR = 'ADH'
--	)
--)



--select * from #JOURNAL_ECHANGE_TEMP where TYPE_ACTEUR not in ('ADH', 'COR','EXP')

--select distinct ID_NATURE_ECHANGE, ID_SOURCE_ECHANGE from #JOURNAL_ECHANGE_TEMP where ID_SOURCE_ECHANGE=1


--select * from AtooCGA40..JOURNAL_ECHANGES where ID_SOURCE_ECHANGE=2 and ID_NATURE_ECHANGE = 184

--ROLLBACK TRAN

----INJECTION VALEURS JOURNAL ECHANGES AtooCGA40 COR

INSERT into AtooCGA40..JOURNAL_ECHANGES 
	(DATE_ECHANGE,CODE_ACTEUR,DETAIL,OBJET,ID_SOURCE_ECHANGE,ID_NATURE_ECHANGE,OBSERVATION
		,TRG_EMETTEUR,TRG_RECEPTEUR,MEDIA,DATE_ECHEANCE,ETAT_EVT,DATE_EFFET,CHRONO
		,TYPE_ACTEUR,ID_ACTEUR,PRESENCE_PJ,ID_DOCUMENT_MODEL,ANNEE_EXERCICE,DATE_ACHEVEMENT,ID_ECHANGE_OLD, ID_ECHANGE_PARENT_OLD)
select DATE_ECHANGE,'Correspondant-' + convert (varchar,AtooCGA40..BUREAUX.id_bureau) ,DETAIL,OBJET,ID_SOURCE_ECHANGE,ID_NATURE_ECHANGE,#JOURNAL_ECHANGE_TEMP.OBSERVATION
		,TRG_EMETTEUR,TRG_RECEPTEUR,MEDIA,DATE_ECHEANCE,ETAT_EVT,DATE_EFFET,CHRONO
		,type_acteur,AtooCGA40..BUREAUX.id_bureau
		,PRESENCE_PJ,case when ID_DOCUMENT_MODEL > '0' then NULL else ID_DOCUMENT_MODEL END as ID_DOCUMENT_MODEL,ANNEE_EXERCICE,DATE_ACHEVEMENT, #JOURNAL_ECHANGE_TEMP.id_echange,#JOURNAL_ECHANGE_TEMP.id_echange_parent
from #JOURNAL_ECHANGE_TEMP
left join AtooCGA40..bureaux as IB on IB.id_bureau = #JOURNAL_ECHANGE_TEMP.id_acteur and TYPE_ACTEUR = 'COR'
left join AtooCGA40..BUREAUX on AtooCGA40..BUREAUX.CODE_BUR_OLD = IB.CODE_bureau
where 
#JOURNAL_ECHANGE_TEMP.TYPE_ACTEUR = 'COR'and IB.ID_BUREAU not in 
(select BUR_ID_SRC from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
--and DETAIL is not null

order by type_acteur

select * from AtooCGA40..journal_echanges where TYPE_ACTEUR = 'COR'
select * from AtooCGA40..BUREAUX



--INJECTION VALEURS JOURNAL ECHANGES AtooCGA40 EXP

select * from #JOURNAL_ECHANGE_TEMP where TYPE_ACTEUR in ('EXP')
select * from #JOURNAL_ECHANGE_TEMP where /*TYPE_ACTEUR in ('EXP') and*/ OBSERVATION is not null and OBSERVATION <> ''
select * from JOURNAL_ECHANGES where TYPE_ACTEUR in ('EXP') order by 3
select AtooCGA40..EXPERTS.ID_EXP_OLD, * from AtooCGA40..EXPERTS




INSERT into AtooCGA40..JOURNAL_ECHANGES 
	(DATE_ECHANGE,CODE_ACTEUR,DETAIL,OBJET,ID_SOURCE_ECHANGE,ID_NATURE_ECHANGE,OBSERVATION
		,TRG_EMETTEUR,TRG_RECEPTEUR,MEDIA,DATE_ECHEANCE,ETAT_EVT,DATE_EFFET,CHRONO
		,TYPE_ACTEUR,ID_ACTEUR,PRESENCE_PJ,ID_DOCUMENT_MODEL,ANNEE_EXERCICE, DATE_ACHEVEMENT,ID_ECHANGE_OLD, ID_ECHANGE_PARENT_OLD)
select DATE_ECHANGE,'Expert-' + convert (varchar,AtooCGA40..EXPERTS.ID_EXPERT) ,DETAIL,OBJET,ID_SOURCE_ECHANGE,ID_NATURE_ECHANGE,#JOURNAL_ECHANGE_TEMP.OBSERVATION
		,TRG_EMETTEUR,TRG_RECEPTEUR,MEDIA,DATE_ECHEANCE,ETAT_EVT,DATE_EFFET,CHRONO
		,type_acteur,AtooCGA40..EXPERTS.ID_EXPERT 
		,PRESENCE_PJ,case when ID_DOCUMENT_MODEL > '0' then NULL else ID_DOCUMENT_MODEL END as ID_DOCUMENT_MODEL,ANNEE_EXERCICE,DATE_ACHEVEMENT, #JOURNAL_ECHANGE_TEMP.id_echange,#JOURNAL_ECHANGE_TEMP.id_echange_parent
from #JOURNAL_ECHANGE_TEMP
left join AtooCGA40..EXPERTS as IE on IE.ID_EXPERT = #JOURNAL_ECHANGE_TEMP.id_acteur
left join AtooCGA40..EXPERTS on AtooCGA40..EXPERTS.ID_EXP_OLD = IE.ID_EXPERT 
where 
#JOURNAL_ECHANGE_TEMP.TYPE_ACTEUR = 'EXP'
and IE.ID_EXPERT not in 
(select BUR_ID_SRC from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
and AtooCGA40..EXPERTS.ID_EXPERT is not null
--order by 2
--and DETAIL is not null

--order by type_acteur

select * from AtooCGA40..journal_echanges where ID_echange > 518664


--INJECTION VALEURS JOURNAL ECHANGES PJ 

INSERT INTO AtooCGA40..JOURNAL_ECHANGES_PJ
		([ID_ECHANGE], [PJ],[ID_DOC_TYPE], [DESCRIPTION], [FILENAME], [PJ_EXTERNE], [PJ_HASH], [fusion])
select [AtooCGA40]..[journal_echanges].[ID_ECHANGE], [PJ],[ID_DOC_TYPE], [DESCRIPTION], [FILENAME], [PJ_EXTERNE], [PJ_HASH], 1
from AtooCGA40..journal_echanges_pj 
inner join AtooCGA40..journal_echanges on AtooCGA40..journal_echanges.id_echange_old = AtooCGA40..journal_echanges_pj.id_echange
where AtooCGA40..journal_echanges.id_echange_old is not null

UPDATE AtooCGA40..JOURNAL_ECHANGES SET AtooCGA40..JOURNAL_ECHANGES.ID_ECHANGE_PARENT = (
select top (1) JE.id_echange 
from AtooCGA40..journal_echanges as JE where JE.id_echange_old = AtooCGA40..journal_echanges.id_echange_parent_old)
from AtooCGA40..journal_echanges where AtooCGA40..journal_echanges.id_echange_parent_old is not null

--ROLLBACK TRAN
--COMMIT TRAN


--ALTER TABLE AtooCGA40..JOURNAL_ECHANGES DROP column id_echange_old
--ALTER TABLE AtooCGA40..JOURNAL_ECHANGES DROP column id_echange_parent_old
--ALTER TABLE AtooCGA40..JOURNAL_ECHANGES_PJ DROP column fusion
--ALTER TABLE AtooCGA40..NATURES_ECHANGES DROP column fusion
--ALTER TABLE AtooCGA40..TYPES_ECHANGES DROP column fusion


--delete from AtooCGA40..journal_echanges where id_echange_old is not null
--delete from AtooCGA40..journal_echanges_pj where fusion = '1'