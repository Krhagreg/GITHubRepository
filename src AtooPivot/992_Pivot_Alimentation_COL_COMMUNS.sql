-- Alimentation table des collaborateurs
insert into AtooPivot.._COL_COMMUNS
select cp.nom,cp.PRENOM,c.ID_COLLABORATEUR,c.ID_BUREAU,ce.ID_COLLABORATEUR,ce.ID_BUREAU, 
	CASE WHEN 
	ce.ID_BUREAU in
	(select distinct BUR_ID_DST from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
	and
	c.ID_BUREAU in
	(select distinct BUR_ID_SRC from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
	THEN 'True' ELSE 'False' 
	END
	,
	CASE WHEN 
	c.ID_BUREAU in
	(select distinct BUR_ID_SRC from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
	and
	ce.ID_BUREAU not in
	(select distinct BUR_ID_DST from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
	THEN 'True' ELSE 'False' 
	END
	,
	CASE WHEN
	ce.ID_BUREAU in
	(select distinct BUR_ID_DST from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
	THEN 'True' ELSE 'False' 
	END
	,
	CASE WHEN c.ID_BUREAU in
	(select distinct BUR_ID_SRC from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
	THEN 'True' ELSE 'False' 
	END

from AtooAGA40..COLLABORATEURS c
inner join AtooAGA40..personnes p on p.id_personne = c.id_personne 
inner join AtooCGA40..personnes cp on (cp.nom = p.nom and cp.PRENOM = p.prenom)
inner join AtooCGA40..COLLABORATEURS ce on ce.ID_PERSONNE = cp.ID_PERSONNE

group by cp.nom,cp.PRENOM,c.ID_COLLABORATEUR,c.ID_BUREAU,ce.ID_COLLABORATEUR,ce.ID_BUREAU


-- Collaborateurs / personnes à creer dans DST
select * from AtooPivot.._col_communs
where col_exist_in_both = 0

-- Collaborateurs existant dans DST mais pas associé 
select * from AtooPivot.._col_communs
where col_exist_in_both = 1 and col_exist_in_src_only = 0

-- Collaborateurs à mettre à jour dans DST
select * from AtooPivot.._col_communs
where col_exist_in_both = 1 and col_exist_in_src_only = 1


select * from AtooPivot.._col_communs
order by 3
