---------------------------
-- Création Champ id new --
---------------------------

--ALTER TABLE AtooAGA40..TABLEX_TVA ADD ID_ADH_NEW varchar(50)  null 
--ALTER TABLE AtooAGA40..TABLEX_TVA ADD ID_BUR_NEW varchar(50)  null 
--ALTER TABLE AtooAGA40..TABLEX_TVA ADD ID_EXP_NEW varchar(50)  null
--ALTER TABLE AtooAGA40..TABLEX_TVA ADD ID_COL_NEW varchar(50)  null

------------------------
-- Maj ID_NEW_ADH CGA --
------------------------

update AtooAGA40..TABLEX_TVA set ID_ADH_NEW = a.ID_ADHERENT 
from AtooAGA40..TABLEX_TVA 
left join AtooAGA40..ADHERENTS as IA on IA.ID_ADHERENT = AtooCGA40..TABLEX_TVA.ID_ADHERENT 
left join AtooCGA40..ADHERENTS a on a.NUMERO_ADHERENT_AUXILIAIRE = 'A' + IA.NUMERO_ADHERENT 
where 
a.NUMERO_ADHERENT_AUXILIAIRE is not null
and 
a.id_adherent is not null
and 
ia.id_adherent is not null

------------------------
-- Maj ID_NEW_BUR CGA --
------------------------

update AtooAGA40..TABLEX_TVA set id_bur_new = cb.ID_BUREAU 
from AtooAGA40..TABLEX_TVA tt
inner join AtooCGA40..BUREAUX cb on cb.id_bur_old = tt.ID_BUREAU

------------------------
-- Maj ID_EXP_NEW AGA --
------------------------

update AtooAGA40..TABLEX_TVA set ID_EXP_NEW = ce.id_expert
from AtooAGA40..TABLEX_TVA tt 
inner join AtooCGA40..Experts ce on ce.id_EXP_old = tt.ID_expert

----------------------------------
-- Maj ID_NEW_COL DEJA EXISTANT --
----------------------------------

update AtooAGA40..TABLEX_TVA set ID_COL_NEW = c.ID_COLLABORATEUR
from AtooAGA40..TABLEX_TVA tt
inner join AtooCGA40..COLLABORATEURS c on c.ID_COL_OLD = tt.ID_COLLABORATEUR


--------------------------
-- INJECTION TABLEX_TVA --
--------------------------

BEGIN TRAN

INSERT INTO AtooCGA40..TABLEX_TVA 
		(DATE_CREATION, ID_ADHERENT, DATE_DEBUT_EXERCICE
		, DATE_CLOTURE_EXERCICE, DATE_RECEPTION_DF, LIASSE
		, TDFC, TYPE_IMPOSITION_TVA, ID_BUREAU, ID_EXPERT
		, ID_COLLABORATEUR, DF_RECTIFICATIF, TRG_IMP 
		, DATE_IMP, DF_TO_PRINT, MONTANT_TVA_DUE 
		, MONTANT_TVA_DEDUCTIBLE, MONTANT_BASE_HT)
	SELECT DATE_CREATION, ID_ADH_NEW, DATE_DEBUT_EXERCICE
		, DATE_CLOTURE_EXERCICE, DATE_RECEPTION_DF, LIASSE
		, TDFC, TYPE_IMPOSITION_TVA, ID_BUR_NEW, ID_EXP_NEW
		, ID_COL_NEW, DF_RECTIFICATIF, TRG_IMP  
		, DATE_IMP, DF_TO_PRINT, MONTANT_TVA_DUE 
		, MONTANT_TVA_DEDUCTIBLE, MONTANT_BASE_HT 
	FROM AtooAGA40..TABLEX_TVA
	
--select * from AtooCGA40..TABLEX_TVA
--select * from TABLEX_TVA

--select * from AtooCGA40..TABLEX
--select * from TABLEX

-- ROLLBACK TRAN
-- COMMIT TRAN

/*
ALTER TABLE AtooCGA40..TABLEX_TVA DROP column ID_ADH_NEW
ALTER TABLE AtooCGA40..TABLEX_TVA DROP column ID_BUR_NEW
ALTER TABLE AtooCGA40..TABLEX_TVA DROP column ID_EXP_NEW
ALTER TABLE AtooCGA40..TABLEX_TVA DROP column ID_COL_NEW
*/