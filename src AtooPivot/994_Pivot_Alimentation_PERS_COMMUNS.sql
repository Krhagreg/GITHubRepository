delete from AtooPivot.._PERS_COMMUNS

update AtooAGA40..PERSONNES set RAISON_SOCIALE = null where len(RAISON_SOCIALE) < 1 or RAISON_SOCIALE = '?'
update AtooAGA40..PERSONNES set NOM = null where len(NOM) < 1 or NOM = '?' 
update AtooAGA40..PERSONNES set PRENOM = null where len(PRENOM) < 1 or PRENOM = '?' 
update AtooCGA40..PERSONNES set RAISON_SOCIALE = null where len(RAISON_SOCIALE) < 1 or RAISON_SOCIALE = '?' 
update AtooCGA40..PERSONNES set NOM = null where len(NOM) < 1 or NOM = '?'
update AtooCGA40..PERSONNES set PRENOM = null where len(PRENOM) < 1 or PRENOM = '?' 

-- Alimentation table des personnes SRC
insert into AtooPivot.._PERS_COMMUNS
select distinct null,aa.id_personne,null,aa.type_personne,null,null,null,aa.raison_sociale,aa.nom,aa.prenom,null
from atooaga40..personnes aa
where aa.id_personne > -1 and aa.type_personne not in (-1,0,1,4,12,13,14,15,16)

-- Alimentation table des personnes DST
insert into AtooPivot.._PERS_COMMUNS
select distinct aa.id_personne,null,aa.type_personne,null,aa.raison_sociale,aa.nom,aa.prenom,null,null,null,null
from atoocga40..personnes aa
where aa.id_personne > -1 and aa.type_personne not in (-1,0,1,4,12,13,14,15,16)



select distinct p.[PERS_NOM_DST],ap.NOM,p.[PERS_PRENOM_DST],ap.PRENOM,p.[PERS_ID_PERS_DST],ap.ID_PERSONNE,p.[PERS_ID_TYPE_PERS_DST]--,* 
from AtooPivot.._PERS_COMMUNS p
inner join AtooAGA40..PERSONNES ap on ((p.[PERS_RS_DST] = ap.RAISON_SOCIALE) or (p.[PERS_NOM_DST] = ap.nom and p.[PERS_PRENOM_DST] = ap.prenom)) --and p.[PERS_NOM_DST] is not null and p.[PERS_PRENOM_DST] is not null 
where p.[PERS_ID_TYPE_PERS_DST] not in (-1,0,1,4,12,13,14,15,16)
order by 3

--select * --p.[PERS_RS_DST], ap.RAISON_SOCIALE,p.[PERS_NOM_DST],ap.NOM,p.[PERS_PRENOM_DST],ap.PRENOM,p.[PERS_ID_PERS_DST],ap.ID_PERSONNE,* 
--from AtooPivot.._PERS_COMMUNS p
--inner join AtooPivot.._PERS_COMMUNS ap on p.[PERS_ID_TYPE_PERS_DST] = p.[PERS_ID_TYPE_PERS_SRC] and ((p.[PERS_RS_DST] = ap.RAISON_SOCIALE) or (p.[PERS_NOM_DST] = ap.nom and p.[PERS_PRENOM_DST] = ap.prenom)) --and p.[PERS_NOM_DST] is not null and p.[PERS_PRENOM_DST] is not null 
--where p.[PERS_ID_TYPE_PERS_DST] not in (-1,0,1,4,12,13,14,15,16)


--select * --p.[PERS_RS_DST], ap.RAISON_SOCIALE,p.[PERS_NOM_DST],ap.NOM,p.[PERS_PRENOM_DST],ap.PRENOM,p.[PERS_ID_PERS_DST],ap.ID_PERSONNE,* 
--from AtooAGA40..PERSONNES
--where TYPE_PERSONNE not in (-1,0,1,4,12,13,14,15,16)
--and
--((RAISON_SOCIALE is not null) or (nom is not null and prenom is not null))



select * from AtooPivot.._PERS_COMMUNS
--where pers_rs_dst = pers_rs_src

--select * from AtooPivot.._PERS_COMMUNS
--where pers_nom_dst = pers_nom_src

--select * from AtooPivot.._PERS_COMMUNS
--where pers_nom_dst = pers_nom_src


