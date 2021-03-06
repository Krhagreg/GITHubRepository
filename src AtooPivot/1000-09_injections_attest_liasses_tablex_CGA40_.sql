---------------------------
-- Cr�ation Champ id new --
---------------------------

--ALTER TABLE AtooAGA40..TABLEX ADD ID_ADH_NEW varchar(50)  null 
--ALTER TABLE AtooAGA40..TABLEX ADD ID_BUR_NEW varchar(50)  null 
--ALTER TABLE AtooAGA40..TABLEX ADD ID_EXP_NEW varchar(50)  null
--ALTER TABLE AtooAGA40..TABLEX ADD ID_COL_NEW varchar(50)  null
--ALTER TABLE AtooAGA40..TABLEX ADD ID_JUSTIF_CONF_FEC int
--ALTER TABLE AtooAGA40..TABLEX ADD ID_DEMANDE_MISE_CONF_FEC int
--select top 1 * from AtooAGA40..TABLEX 

------------------------
-- Maj ID_NEW_ADH CGA --
------------------------
begin tran
--select COUNT(*) from AtooAGA40..TABLEX

--select NUMERO_ADHERENT_AUXILIAIRE, * from ADHERENTS where 
--NUM_ADH_OLD is not null

update AtooAGA40..TABLEX set id_adh_new = a.ID_ADHERENT 
from AtooAGA40..TABLEX 
inner join AtooAGA40..ADHERENTS as IA on IA.ID_ADHERENT = AtooAGA40..TABLEX.ID_ADHERENT 
inner join AtooCGA40..ADHERENTS a on a.NUMERO_ADHERENT_AUXILIAIRE = 'A' + IA.NUMERO_ADHERENT
where 
a.NUMERO_ADHERENT_AUXILIAIRE is not null
and 
a.id_adherent is not null
and 
ia.id_adherent is not null

------------------------
-- Maj ID_NEW_BUR CGA --
------------------------

update AtooAGA40..TABLEX set id_bur_new = cb.ID_BUREAU 
from AtooAGA40..TABLEX t
inner join AtooCGA40..BUREAUX cb on cb.id_bur_old = t.ID_BUREAU

------------------------
-- Maj ID_ECHANGE_CONF_FEC --
------------------------

update AtooAGA40..TABLEX set ID_JUSTIF_CONF_FEC = je.id_echange
from AtooAGA40..TABLEX 
inner join AtooCGA40..JOURNAL_ECHANGES je on je.ID_ACTEUR = AtooAGA40..TABLEX.ID_ADH_NEW and je.ID_SOURCE_ECHANGE = 1 and je .ID_NATURE_ECHANGE = -57 and je.TYPE_ACTEUR ='ADH' 
where (AtooAGA40..TABLEX.ID_ECHANGE_JUSTIFICATIF_CONFORMITE_FEC is not null)

update AtooAGA40..TABLEX set ID_DEMANDE_MISE_CONF_FEC = je.id_echange
from AtooAGA40..TABLEX 
inner join AtooCGA40..JOURNAL_ECHANGES je on je.ID_ACTEUR = AtooAGA40..TABLEX.ID_ADH_NEW and je.ID_SOURCE_ECHANGE = 1 and je .ID_NATURE_ECHANGE = -58 and je.TYPE_ACTEUR ='ADH' 
where (AtooAGA40..TABLEX.ID_ECHANGE_DEMANDE_MISE_EN_CONFORMITE_FEC is not null)

--rollback tran

------------------------
-- Maj ID_NEW_EXP CGA --
------------------------

update AtooAGA40..TABLEX set ID_EXP_NEW = ce.id_expert
from AtooAGA40..TABLEX t 
inner join AtooCGA40..Experts ce on ce.id_EXP_old = t.ID_expert

----------------------------------
-- Maj ID_NEW_COL DEJA EXISTANT --
----------------------------------

update AtooAGA40..TABLEX set ID_COL_NEW = c.ID_COLLABORATEUR
from AtooAGA40..TABLEX t
inner join AtooCGA40..COLLABORATEURS c on c.ID_COL_OLD = t.ID_COLLABORATEUR

--------------------------
-- INJECTION TABLEX --
---------------------------- 

--CREATION COLONNES

ALTER TABLE AtooCGA40..liasses_tablex ADD fusion int null
ALTER TABLE AtooCGA40..liasses_brutes ADD id_liasse_brute_old bigint null
ALTER TABLE AtooCGA40..tablex ADD id_tablex_old bigint null

BEGIN TRAN

-- INJECTIONS LIASSES_BRUTES 


INSERT INTO AtooCGA40..LIASSES_BRUTES 
	(DATE_ENREG, ID_ADHERENT, EXERCICE, LIASSE, CHECKSUM_XML_FILE, id_liasse_brute_old)
	SELECT DATE_ENREG, AtooCGA40..ADHERENTS.ID_ADHERENT, EXERCICE, LIASSE, CHECKSUM_XML_FILE, id_liasse_brute  
	FROM AtooAGA40..LIASSES_BRUTES, AtooCGA40..ADHERENTS, AtooAGA40..ADHERENTS as IA
	WHERE AtooAGA40..LIASSES_BRUTES.ID_ADHERENT = IA.ID_ADHERENT 
	AND IA.NUMERO_ADHERENT =  AtooCGA40..ADHERENTS.NUM_ADH_OLD



	
-- INJECTION TABLEX
	INSERT INTO AtooCGA40..TABLEX 
		(DATE_CREATION, ID_ADHERENT, DATE_DEBUT_EXERCICE
		, DATE_CLOTURE_EXERCICE, DATE_RECEPTION_DF, INFO_ADM, LIASSE
		, PRESENCE_DECLARATION, PRESENCE_LIASSE, PRESENCE_OG, PRESENCE_DOG, ID_STATUT_ATT, ID_STATUT_ARI, ID_STATUT_ECV, ID_STATUT_DOG
		, ID_STATUT_9Y, DATE_STATUT_ATT, DATE_STATUT_ARI, DATE_STATUT_ECV, DATE_STATUT_DOG, TDFC, TDFC_OG, TDFC_DG, NAF_STAT, REPONSE_ECV
		, REPONSE_ARI, DOG, DF_PROVISOIRE, PAC, RESULTAT, EFFECTIF, COMMENTAIRE, TYPE_IMPOSITION, CATEGORIE_FISCALE, REGIME_FISCAL, ID_BUREAU
		, ID_EXPERT 
		, MANDAT_ECV, EXCLUSION_STAT, REPONSE_DG, PRESENCE_BRC, ID_STATUT_BRC, ENVOI_ECV, LISTE_ANOMALIES_ATT
		, PRESENCE_BRA, DF_RECTIFICATIF, TRG_ARI, TRG_ECV, TRG_DOG, ID_CORRES_DG, TRG_ATT, TRG_IMP, DATE_IMP, PRESENCE_BALANCE, FIDEVT
		, ID_MILLESIME, CODE_PROFESSION, COMMENTAIRE_ARI, NOMENCLATURE, ID_STATUT_REG, DATE_STATUT_REG, REPONSE_REG, TRG_REG, COMMENTAIRE_REG
		, ID_COLLABORATEUR, ID_STATUT_PRE, DATE_STATUT_PRE, PREV, TRG_PRE, INDICE_CRITICITE, CACHING, DATE_DEBUT_ARI, DATE_DEBUT_ECV
		, DATE_DEBUT_REG, DATE_DEBUT_ATT, DATE_DEBUT_DOG, DATE_DEBUT_PRE, ENVOI_TDFC_OGA, PRESENCE_CVAE
		, ID_STATUT_CRM, DATE_DEBUT_CRM, DATE_STATUT_CRM, TRG_CRM, ID_SITUATION_CRM, COMMENTAIRE_CRM
		, CRM, PRESENCE_TVA, DF_TO_PRINT, TVA_NB_DECLA, TVA_TOTAL_DUE, TVA_TOTAL_DEDUCTIBLE
		, REPONSES_ECV_EN_ATTENTE, ECV_DEMANDE_RECTIF_OGA, ECV_TOTAL_ANOS, ECV_TOTAL_QUESTIONS
		, ECV_TOTAL_QUESTIONS_NON_SATISFAISANTE, TVA_NB_DECLA_EDI, TVA_DUREE_DERNIERE_DECLA
		, TVA_DUREE_TOTALE_COUVERTURE, TVA_DATE_DEBUT_COUVERTURE, TVA_DATE_FIN_COUVERTURE
		, TVA_NB_PERIODES_MANQUANTES, TVA_A_RECEVOIR, MEDIA_IMP, IS_CRM_RECTIF, ANNEE_CLOTURE, DECLARATIONS_DES_LOYERS, NB_DECLARATIONS_DES_LOYERS, NB_DECLARATIONS_DES_LOYERS_EDI
		, SIREN, ROF, ETAT_AFFECTATION_STATS, ID_STATUT_EPS, DATE_DEBUT_EPS, DATE_STATUT_EPS, TRG_EPS, COMMENTAIRE_EPS, EPS, DPEC, PRESENCE_FEC, PRESENCE_GRAND_LIVRE, TOTAL_CONTROLES_PIECES
		, TOTAL_CONTROLES_PIECES_DOCS, TOTAL_CONTROLES_PIECES_CLOS, ID_STATUT_CONTROLE_FEC, TOTAL_CONTROLES_PIECES_PALIER1, TOTAL_CONTROLES_PIECES_PALIER2, TOTAL_CONTROLES_PIECES_QUOTA_PALIER2
		, ANNEE_EPS, TOTAL_DOCUMENTS_EPS, TOTAL_DOCUMENTS_EPS_SANS_RATTACHEMENT, ID_STATUT_FEC, DATE_STATUT_FEC, DATE_DEBUT_FEC, TRG_FEC, COMPTA_INFORMATISEE, TENUE_COMPTA_COR
		, ID_ECHANGE_JUSTIFICATIF_CONFORMITE_FEC, ID_ECHANGE_DEMANDE_MISE_EN_CONFORMITE_FEC, CRM_DATA, CA, ID_TABLEX_OLD)



   
	SELECT  AtooAGA40..TABLEX.DATE_CREATION, AtooAGA40..TABLEX.ID_ADH_new, AtooAGA40..TABLEX.DATE_DEBUT_EXERCICE
		, DATE_CLOTURE_EXERCICE, DATE_RECEPTION_DF, INFO_ADM, LIASSE
		, PRESENCE_DECLARATION, PRESENCE_LIASSE, PRESENCE_OG, PRESENCE_DOG, ID_STATUT_ATT, ID_STATUT_ARI, ID_STATUT_ECV, ID_STATUT_DOG
		, ID_STATUT_9Y, DATE_STATUT_ATT, DATE_STATUT_ARI, DATE_STATUT_ECV, DATE_STATUT_DOG, TDFC, TDFC_OG, TDFC_DG, NAF_STAT, REPONSE_ECV
		, REPONSE_ARI, DOG, DF_PROVISOIRE, PAC, RESULTAT, EFFECTIF, AtooAGA40..TABLEX.COMMENTAIRE, TYPE_IMPOSITION, CATEGORIE_FISCALE, AtooAGA40..TABLEX.REGIME_FISCAL, AtooAGA40..TABLEX.ID_BUR_NEW
		, AtooAGA40..TABLEX.ID_EXP_new 
		, MANDAT_ECV, EXCLUSION_STAT, REPONSE_DG, PRESENCE_BRC, ID_STATUT_BRC, ENVOI_ECV, LISTE_ANOMALIES_ATT
		, PRESENCE_BRA, DF_RECTIFICATIF, TRG_ARI, TRG_ECV, TRG_DOG, ID_CORRES_DG, TRG_ATT, TRG_IMP, DATE_IMP, PRESENCE_BALANCE, FIDEVT
		, NULL, CODE_PROFESSION, COMMENTAIRE_ARI, AtooAGA40..TABLEX.NOMENCLATURE, ID_STATUT_REG, DATE_STATUT_REG, REPONSE_REG, TRG_REG, COMMENTAIRE_REG
		, AtooAGA40..TABLEX.ID_COL_new, ID_STATUT_PRE, DATE_STATUT_PRE, PREV, TRG_PRE, INDICE_CRITICITE, CACHING, DATE_DEBUT_ARI, DATE_DEBUT_ECV
		, DATE_DEBUT_REG, DATE_DEBUT_ATT, DATE_DEBUT_DOG, DATE_DEBUT_PRE, ENVOI_TDFC_OGA, PRESENCE_CVAE
		, ID_STATUT_CRM, DATE_DEBUT_CRM, DATE_STATUT_CRM, TRG_CRM, ID_SITUATION_CRM, COMMENTAIRE_CRM
		, CRM, PRESENCE_TVA, DF_TO_PRINT, TVA_NB_DECLA, TVA_TOTAL_DUE, TVA_TOTAL_DEDUCTIBLE
		, REPONSES_ECV_EN_ATTENTE, ECV_DEMANDE_RECTIF_OGA, ECV_TOTAL_ANOS, ECV_TOTAL_QUESTIONS
		, ECV_TOTAL_QUESTIONS_NON_SATISFAISANTE, TVA_NB_DECLA_EDI, TVA_DUREE_DERNIERE_DECLA
		, TVA_DUREE_TOTALE_COUVERTURE, TVA_DATE_DEBUT_COUVERTURE, TVA_DATE_FIN_COUVERTURE
		, AtooAGA40..TABLEX.TVA_NB_PERIODES_MANQUANTES, TVA_A_RECEVOIR,  MEDIA_IMP, IS_CRM_RECTIF, ANNEE_CLOTURE, DECLARATIONS_DES_LOYERS, NB_DECLARATIONS_DES_LOYERS, NB_DECLARATIONS_DES_LOYERS_EDI
		, SIREN, AtooAGA40..TABLEX.ROF, ETAT_AFFECTATION_STATS, ID_STATUT_EPS, DATE_DEBUT_EPS, DATE_STATUT_EPS, TRG_EPS, COMMENTAIRE_EPS, EPS, DPEC, PRESENCE_FEC, PRESENCE_GRAND_LIVRE, TOTAL_CONTROLES_PIECES
		, TOTAL_CONTROLES_PIECES_DOCS, TOTAL_CONTROLES_PIECES_CLOS, ID_STATUT_CONTROLE_FEC, TOTAL_CONTROLES_PIECES_PALIER1, TOTAL_CONTROLES_PIECES_PALIER2, TOTAL_CONTROLES_PIECES_QUOTA_PALIER2
		, ANNEE_EPS, TOTAL_DOCUMENTS_EPS, TOTAL_DOCUMENTS_EPS_SANS_RATTACHEMENT, ID_STATUT_FEC, DATE_STATUT_FEC, DATE_DEBUT_FEC, TRG_FEC, COMPTA_INFORMATISEE, TENUE_COMPTA_COR
		, AtooAGA40..TABLEX.ID_JUSTIF_CONF_FEC, AtooAGA40..TABLEX.ID_DEMANDE_MISE_CONF_FEC, CRM_DATA, CA, AtooAGA40..TABLEX.ID_TABLEX 
	FROM AtooAGA40..TABLEX
		inner join AtooAGA40..ADHERENTS as IA on IA.ID_ADHERENT = AtooAGA40..TABLEX.ID_ADHERENT 
		left join AtooCGA40..ADHERENTS on AtooCGA40..ADHERENTS.NUM_ADH_OLD = IA.NUMERO_ADHERENT 
		left join AtooAGA40..BUREAUX as IB on IB.ID_BUREAU = AtooAGA40..TABLEX.ID_BUREAU 
		left join AtooCGA40..BUREAUX on AtooCGA40..BUREAUX.CODE_BUR_OLD = IB.CODE_BUREAU
		left join AtooAGA40..EXPERTS as IE on IE.ID_EXPERT = AtooAGA40..TABLEX.ID_EXPERT 
		left join AtooCGA40..EXPERTS on AtooCGA40..EXPERTS.ID_EXP_OLD = IE.ID_EXPERT 
		left join AtooAGA40..COLLABORATEURS as IC on IC.ID_COLLABORATEUR = AtooAGA40..TABLEX.ID_COLLABORATEUR 
		left join AtooCGA40..COLLABORATEURS on AtooCGA40..COLLABORATEURS.ID_COL_OLD = IC.ID_COLLABORATEUR 
		order by AtooAGA40..TABLEX.ID_TABLEX--AtooAGA40..TABLEX.DATE_CREATION desc, DATE_STATUT_ARI desc


		

	INSERT INTO AtooCGA40..LIASSES_TABLEX 
		(ID_LIASSE, ID_TABLEX, fusion)
	SELECT AtooCGA40..LIASSES_BRUTES.ID_LIASSE_BRUTE, AtooCGA40..TABLEX.ID_TABLEX, 1
		FROM AtooAGA40..LIASSES_TABLEX, AtooCGA40..LIASSES_BRUTES, AtooCGA40..TABLEX 
		WHERE AtooAGA40..LIASSES_TABLEX.ID_LIASSE = AtooCGA40..LIASSES_BRUTES.ID_LIASSE_BRUTE_OLD
		AND AtooAGA40..LIASSES_TABLEX.ID_TABLEX = AtooCGA40..TABLEX.ID_TABLEX_OLD

--select * from tablex where id_adherent = 71366

--ROLLBACK TRAN
--COMMIT TRAN

-- SUPPRESSION COLONNES
/*
ALTER TABLE AtooAGA40..TABLEX DROP column ID_ADH_NEW
ALTER TABLE AtooAGA40..TABLEX DROP column ID_BUR_NEW
ALTER TABLE AtooAGA40..TABLEX DROP column ID_EXP_NEW
ALTER TABLE AtooAGA40..TABLEX DROP column ID_COL_NEW
ALTER TABLE AtooAGA40..TABLEX DROP column ID_JUSTIF_CONF_FEC
ALTER TABLE AtooAGA40..TABLEX DROP column ID_DEMANDE_MISE_CONF_FEC
ALTER TABLE AtooCGA40..liasses_tablex DROP column fusion
ALTER TABLE AtooCGA40..liasses_brutes DROP column id_liasse_brute_old
ALTER TABLE AtooCGA40..tablex DROP column id_tablex_old
*/



