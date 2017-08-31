-- Alimentation table des experts

insert into AtooPivot.._EXP_COMMUNS
select cp.nom,cp.PRENOM,cep.ID_EXPERT,e.ID_EXPERT,cep.ID_BUREAU,ep.ID_BUREAU, 
	CASE WHEN 
	cep.ID_BUREAU in
	(select distinct BUR_ID_DST from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
	and
	ep.ID_BUREAU in
	(select distinct BUR_ID_SRC from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
	THEN 'True' ELSE 'False' 
	END
	,
	CASE WHEN 
	cep.ID_BUREAU in
	(select distinct BUR_ID_DST from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
	and
	ep.ID_BUREAU not in
	(select distinct BUR_ID_SRC from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
	THEN 'True' ELSE 'False' 
	END
	,
	CASE WHEN ep.ID_BUREAU in
	(select distinct BUR_ID_SRC from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
	and
	cep.ID_BUREAU not in
	(select distinct BUR_ID_DST from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
	THEN 'True' ELSE 'False' 
	END
	,
	CASE WHEN cep.ID_BUREAU in
	(select distinct BUR_ID_DST from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
	THEN 'True' ELSE 'False' 
	END
	,
	CASE WHEN ep.ID_BUREAU in
	(select distinct BUR_ID_SRC from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
	THEN 'True' ELSE 'False' 
	END

from AtooAGA40..experts e
inner join AtooAGA40..personnes p on p.id_personne = e.id_personne 
inner join AtooAGA40..EXERCE_POUR ep on ep.ID_EXPERT = e.ID_EXPERT
inner join AtooCGA40..personnes cp on (cp.nom = p.nom and cp.PRENOM = p.prenom)
inner join AtooCGA40..EXERCE_POUR cep on cep.ID_EXPERT = ep.ID_EXPERT
inner join AtooCGA40..EXPERTS ce on ce.ID_PERSONNE = cp.ID_PERSONNE

group by cp.nom,cp.PRENOM,cep.ID_EXPERT,e.ID_EXPERT,cep.ID_BUREAU,ep.ID_BUREAU

select * from AtooPivot.._EXP_COMMUNS
where _EXP_COMMUNS.EXP_ID_EXPERT_DST = 36
