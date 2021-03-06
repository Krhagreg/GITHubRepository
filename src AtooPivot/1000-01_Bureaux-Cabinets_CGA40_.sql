SET NOCOUNT ON


--I] Mise en place tables de travail
--	A] SUPPRESSION DES TABLES TEMPORAIRES

-- supprime table temporaire cabinet comptable
if object_id('tempdb..#CAB_COMPT_TEMP') is not null
DROP table #CAB_COMPT_TEMP

-- supprime table temporaire fin compte plan
if object_id('tempdb..#FIN_COMPT_PLAN_TEMP') is not null
DROP table #FIN_COMPT_PLAN_TEMP 

-- supprime tablex temporaire fin tiers
if object_id('tempdb..#FIN_TIERS_TEMP') is not null
DROP table #FIN_TIERS_TEMP

--	B] MISE A ZERO DES TABLES DE CORRESPONDANCE



--	C] CREATION TABLE TEMPORAIRES

-- cr�ation table temporaire cabinets comptables
select *
into #CAB_COMPT_TEMP 
from AtooCGA40..CABINETS_COMPTABLES

-- cr�ation table temporaire fin compte plan

select * 
into #FIN_COMPT_PLAN_TEMP
from AtooCGA40..FIN_COMPTES_PLAN

-- cr�ation table temporaire fin tiers

select * 
into #FIN_TIERS_TEMP
from AtooCGA40..FIN_TIERS


--	D] CREATION COLONNE PROVENANCE

-- cr�ation colonne provenance donn�es cabinet comptable

ALTER TABLE #CAB_COMPT_TEMP ADD IS_AtooAGA40 bit not null default 0
ALTER TABLE #CAB_COMPT_TEMP ADD NUMERO_CABINET_OLD int

-- cr�ation colonne provenance donn�es cabinet comptable

ALTER TABLE #FIN_COMPT_PLAN_TEMP ADD IS_AtooAGA40 bit not null default 0

-- cr�ation colonne provenance donn�es cabinet comptable

ALTER TABLE #FIN_TIERS_TEMP ADD IS_AtooAGA40 bit not null default 0


--	E] DECLARATION VARIABLE

-- CABINETS COMPTABLES

declare @CUR_NUMERO_CABINET int
declare @CUR_REF_CABINET varchar(10)
declare @CUR_NOM_CABINET varchar(60)
declare @CUR_NUMERO_OEC varchar(30)
declare @CUR_ID_RESPONSABLE_CABINET bigint
declare @CUR_DATE_INSCRIPTION_ORDRE smalldatetime
declare @CUR_DATE_RADIATION_ORDRE smalldatetime
declare @CUR_DATE_INSCRIPTION_CGA smalldatetime
declare @CUR_DATE_RADIATION_CGA smalldatetime
declare @CUR_DATE_RECEPT_LTR_ENG smalldatetime
declare @CUR_LOGIN_SITE_CABINET varchar(15)
declare @CUR_PASSWORD_SITE_CABINET varchar(20)
declare @CUR_LOGICIEL_COMPTA varchar(60)
declare @CUR_REALISATION_DOG bit
declare @CUR_OBSERVATION varchar(500)
declare @CUR_ID_STATUT_MEMBRE tinyint
declare @CUR_ID_STATUT_COR tinyint
declare @CUR_ID_CASIER int
declare @CUR_ID_GESTION_ADMIN int
declare @CUR_ID_TIERS_CLIENT bigint
declare @CUR_ID_TIERS_FRS bigint
declare @CUR_ABT_JOURNAL bit
declare @CUR_TDFC bit
declare @CUR_PRESTATION_OG char(1)
declare @CUR_INTERVENANT bit
declare @CUR_ID_PED int
declare @CUR_BLOCAGE_TELETRANSMISSION bit
declare @CUR_LOGICIEL_DEMAT varchar (100)
declare @CUR_DERNIER_PED varchar (60)
declare @CUR_BLOCAGE_ENVOI_COPIE_ATT bit
declare @CUR_ID_TYPE_SUIVI tinyint

-- FIN_COMPTES_PLAN

declare @CUR_COMPTE_CC varchar(8)
declare @CUR_LIBELLE_CC varchar(60)
declare @CUR_COMPTE_EXTERNE_CC varchar(8)
declare @CUR_COMPTE_FC varchar(8)
declare @CUR_LIBELLE_FC varchar(60)
declare @CUR_COMPTE_EXTERNE_FC varchar(8)

-- FIN_TIERS

declare @CUR_ID_TIERS_CC bigint
declare @CUR_TYPE_TIERS_CC char(2)
declare @CUR_SOLDE_CC money
declare @CUR_AUTOFACTURATION_CC bit
declare @CUR_RIB_CC varchar(23)
declare @CUR_INTRACOMMUNAUTAIRE_CC varchar(16)
declare @CUR_TITULAIRE_COMPTE_CC varchar(50)
declare @CUR_DOMICILIATION_CC varchar(40)
declare @CUR_AUTORISATION_PRELEVEMENT_CC bit
declare @CUR_ID_PROFIL_FRS_CC tinyint
declare @CUR_MODE_REGLEMENT_PAR_DEFAUT_CC char(1)
declare @CUR_CHRONO_AUTOFACTURATION_CC int
declare @CUR_ID_BLOCAGE_FACT_CC tinyint
declare @CUR_ID_DELAI_REGLEMENT_CC tinyint
declare @CUR_DATE_DEBUT_MANDAT_AUTOFACTURATION_CC smalldatetime
declare @CUR_DATE_FIN_MANDAT_AUTOFACTURATION_CC smalldatetime
declare @CUR_ADMINISTRATEUR_CC bit
declare @CUR_EXONERATION_TVA_CC bit
declare @CUR_PROFESSION_CC varchar(100)
declare @CUR_SOLDE_TC_CC money
declare @CUR_IBAN_CC varchar(34)
declare @CUR_BIC_CC varchar(11)
declare @CUR_IBAN_ORIGINE_CC varchar(35)
declare @CUR_MANDAT_SEPA_CC varchar(35)
declare @CUR_DATE_SIGNATURE_MANDAT_SEPA_CC smalldatetime
declare @CUR_DATE_PREMIER_PRELEVEMENT_CC smalldatetime
declare @CUR_MANDAT_SEPA_ORIGINE_CC varchar(35)
declare @CUR_ID_TIERS_FC bigint
declare @CUR_TYPE_TIERS_FC char(2)
declare @CUR_SOLDE_FC money
declare @CUR_AUTOFACTURATION_FC bit
declare @CUR_RIB_FC varchar(23)
declare @CUR_INTRACOMMUNAUTAIRE_FC varchar(16)
declare @CUR_TITULAIRE_COMPTE_FC varchar(50)
declare @CUR_DOMICILIATION_FC varchar(40)
declare @CUR_AUTORISATION_PRELEVEMENT_FC bit
declare @CUR_ID_PROFIL_FRS_FC tinyint
declare @CUR_MODE_REGLEMENT_PAR_DEFAUT_FC char(1)
declare @CUR_CHRONO_AUTOFACTURATION_FC int
declare @CUR_ID_BLOCAGE_FACT_FC tinyint
declare @CUR_ID_DELAI_REGLEMENT_FC tinyint
declare @CUR_DATE_DEBUT_MANDAT_AUTOFACTURATION_FC smalldatetime
declare @CUR_DATE_FIN_MANDAT_AUTOFACTURATION_FC smalldatetime
declare @CUR_ADMINISTRATEUR_FC bit
declare @CUR_EXONERATION_TVA_FC bit
declare @CUR_PROFESSION_FC varchar(100)
declare @CUR_SOLDE_TC_FC money
declare @CUR_IBAN_FC varchar(34)
declare @CUR_BIC_FC varchar(11)
declare @CUR_IBAN_ORIGINE_FC varchar(35)
declare @CUR_MANDAT_SEPA_FC varchar(35)
declare @CUR_DATE_SIGNATURE_MANDAT_SEPA_FC smalldatetime
declare @CUR_DATE_PREMIER_PRELEVEMENT_FC smalldatetime
declare @CUR_MANDAT_SEPA_ORIGINE_FC varchar(35)
declare @REF_CAB_OLD varchar (10)
declare @NUMERO_CABINET_OLD int

	
--	F] DECLARATION COMPTEUR

-- cabinets comptables

declare @compteur bigint
--select @compteur= chrono2 from chronos 
set @compteur=(select max(ref_cabinet) from AtooCGA40.dbo.CABINETS_COMPTABLES) 
declare @ref_cab varchar (6)


--	G] INJECTION TABLES

DECLARE CABINETS_COMPTABLES_cursor CURSOR FOR

select A.*, TC.*, TF.*, FCPC.*, FCPF.* 
from AtooAGA40..cabinets_comptables as A
left join AtooAGA40..fin_tiers as TC on A.id_tiers_client = TC.id_tiers 
left join AtooAGA40..fin_tiers as TF on A.id_tiers_frs = TF.id_tiers
left join AtooAGA40..fin_comptes_plan as FCPC on TC.COMPTE = FCPC.COMPTE
left join AtooAGA40..fin_comptes_plan as FCPF on TF.COMPTE = FCPF.COMPTE
inner join AtooAGA40..bureaux on AtooAGA40..bureaux.numero_cabinet = A.numero_cabinet
where 
A.NUMERO_CABINET in 
(select CAB_NUM_CAB_SRC from AtooPivot.._CAB_BUR_COMMUNS where CAB_EXIST_IN_BOTH = 0 and CAB_EXIST_IN_SRC_ONLY = 1)

OPEN CABINETS_COMPTABLES_cursor


FETCH NEXT FROM CABINETS_COMPTABLES_cursor 
	INTO @CUR_NUMERO_CABINET,@CUR_REF_CABINET,@CUR_NOM_CABINET,@CUR_NUMERO_OEC,@CUR_ID_RESPONSABLE_CABINET,@CUR_DATE_INSCRIPTION_ORDRE
		,@CUR_DATE_RADIATION_ORDRE,@CUR_DATE_INSCRIPTION_CGA,@CUR_DATE_RADIATION_CGA,@CUR_DATE_RECEPT_LTR_ENG,@CUR_LOGIN_SITE_CABINET
		,@CUR_PASSWORD_SITE_CABINET,@CUR_LOGICIEL_COMPTA,@CUR_REALISATION_DOG,@CUR_OBSERVATION,@CUR_ID_STATUT_MEMBRE,@CUR_ID_STATUT_COR
		,@CUR_ID_CASIER,@CUR_ID_GESTION_ADMIN,@CUR_ID_TIERS_CLIENT,@CUR_ID_TIERS_FRS,@CUR_ABT_JOURNAL,@CUR_TDFC,@CUR_PRESTATION_OG
		,@CUR_INTERVENANT,@CUR_ID_PED,@CUR_BLOCAGE_TELETRANSMISSION,@CUR_LOGICIEL_DEMAT,@CUR_DERNIER_PED,@CUR_BLOCAGE_ENVOI_COPIE_ATT
		,@CUR_ID_TYPE_SUIVI,@CUR_ID_TIERS_CC,@CUR_COMPTE_CC,@CUR_TYPE_TIERS_CC,@CUR_SOLDE_CC,@CUR_AUTOFACTURATION_CC,@CUR_RIB_CC,@CUR_INTRACOMMUNAUTAIRE_CC
		,@CUR_TITULAIRE_COMPTE_CC,@CUR_DOMICILIATION_CC,@CUR_AUTORISATION_PRELEVEMENT_CC,@CUR_ID_PROFIL_FRS_CC,@CUR_MODE_REGLEMENT_PAR_DEFAUT_CC
		,@CUR_CHRONO_AUTOFACTURATION_CC,@CUR_ID_BLOCAGE_FACT_CC,@CUR_ID_DELAI_REGLEMENT_CC,@CUR_DATE_DEBUT_MANDAT_AUTOFACTURATION_CC
		,@CUR_DATE_FIN_MANDAT_AUTOFACTURATION_CC,@CUR_ADMINISTRATEUR_CC,@CUR_EXONERATION_TVA_CC,@CUR_PROFESSION_CC,@CUR_SOLDE_TC_CC
		,@CUR_IBAN_CC,@CUR_BIC_CC,@CUR_IBAN_ORIGINE_CC,@CUR_MANDAT_SEPA_CC,@CUR_DATE_SIGNATURE_MANDAT_SEPA_CC
		,@CUR_DATE_PREMIER_PRELEVEMENT_CC,@CUR_MANDAT_SEPA_ORIGINE_CC
		,@CUR_ID_TIERS_FC,@CUR_COMPTE_FC,@CUR_TYPE_TIERS_FC,@CUR_SOLDE_FC,@CUR_AUTOFACTURATION_FC,@CUR_RIB_FC,@CUR_INTRACOMMUNAUTAIRE_FC
		,@CUR_TITULAIRE_COMPTE_FC,@CUR_DOMICILIATION_FC,@CUR_AUTORISATION_PRELEVEMENT_FC,@CUR_ID_PROFIL_FRS_FC
		,@CUR_MODE_REGLEMENT_PAR_DEFAUT_FC,@CUR_CHRONO_AUTOFACTURATION_FC,@CUR_ID_BLOCAGE_FACT_FC,@CUR_ID_DELAI_REGLEMENT_FC
		,@CUR_DATE_DEBUT_MANDAT_AUTOFACTURATION_FC,@CUR_DATE_FIN_MANDAT_AUTOFACTURATION_FC,@CUR_ADMINISTRATEUR_FC,@CUR_EXONERATION_TVA_FC
		,@CUR_PROFESSION_FC,@CUR_SOLDE_TC_FC
		,@CUR_IBAN_FC,@CUR_BIC_FC,@CUR_IBAN_ORIGINE_FC,@CUR_MANDAT_SEPA_FC,@CUR_DATE_SIGNATURE_MANDAT_SEPA_FC
		,@CUR_DATE_PREMIER_PRELEVEMENT_FC,@CUR_MANDAT_SEPA_ORIGINE_FC
		,@CUR_COMPTE_CC,@CUR_LIBELLE_CC,@CUR_COMPTE_EXTERNE_CC,@CUR_COMPTE_FC
		,@CUR_LIBELLE_FC,@CUR_COMPTE_EXTERNE_FC


WHILE @@FETCH_STATUS = 0
BEGIN

	-- DECLARATION VARIABLE ID_TIERS
		declare @_ID_TIERS_GENERE_CLT as bigint
		declare @_ID_TIERS_GENERE_FRS as bigint
		declare @_NUMERO_CABINET as bigint
		

	-- CABINET COMPTABLE
	
	set @compteur=@compteur + 1
	
	set @ref_cab = left('00000',5 - len (convert (varchar, @compteur))) + convert (varchar, @compteur)

	INSERT INTO #CAB_COMPT_TEMP 
	(REF_CABINET,NOM_CABINET,NUMERO_OEC,ID_RESPONSABLE_CABINET,DATE_INSCRIPTION_ORDRE,DATE_RADIATION_ORDRE,DATE_INSCRIPTION_CGA
		,DATE_RADIATION_CGA,DATE_RECEPT_LTR_ENG,LOGIN_SITE_CABINET,PASSWORD_SITE_CABINET,LOGICIEL_COMPTA,REALISATION_DOG,OBSERVATION
		,ID_STATUT_MEMBRE,ID_STATUT_COR,ID_CASIER,ID_GESTION_ADMIN,ID_TIERS_CLIENT,ID_TIERS_FRS,ABT_JOURNAL,TDFC,PRESTATION_OG
		,INTERVENANT,ID_PED,BLOCAGE_TELETRANSMISSION,LOGICIEL_DEMAT,DERNIER_PED,BLOCAGE_ENVOI_COPIE_ATT, REF_CAB_OLD, NUMERO_CABINET_OLD
		,IS_AtooAGA40)
	VALUES 
		(@ref_cab,@CUR_NOM_CABINET,@CUR_NUMERO_OEC,@CUR_ID_RESPONSABLE_CABINET,@CUR_DATE_INSCRIPTION_ORDRE
		,@CUR_DATE_RADIATION_ORDRE,@CUR_DATE_INSCRIPTION_CGA,@CUR_DATE_RADIATION_CGA,@CUR_DATE_RECEPT_LTR_ENG,@CUR_LOGIN_SITE_CABINET
		,@CUR_PASSWORD_SITE_CABINET,@CUR_LOGICIEL_COMPTA,@CUR_REALISATION_DOG,@CUR_OBSERVATION,@CUR_ID_STATUT_MEMBRE,@CUR_ID_STATUT_COR
		,@CUR_ID_CASIER,@CUR_ID_GESTION_ADMIN,@CUR_ID_TIERS_CLIENT,@CUR_ID_TIERS_FRS,@CUR_ABT_JOURNAL,@CUR_TDFC,@CUR_PRESTATION_OG
		,@CUR_INTERVENANT,@CUR_ID_PED,@CUR_BLOCAGE_TELETRANSMISSION,@CUR_LOGICIEL_DEMAT,@CUR_DERNIER_PED,@CUR_BLOCAGE_ENVOI_COPIE_ATT,@CUR_REF_CABINET, @CUR_NUMERO_CABINET,1)


	-- FIN_COMPTES_PLAN CLIENTS

	INSERT INTO #FIN_COMPT_PLAN_TEMP
	(COMPTE, LIBELLE, COMPTE_EXTERNE, IS_AtooAGA40)
	VALUES ('CC0' + @ref_cab ,@CUR_LIBELLE_CC,'CC0' + @CUR_REF_CABINET, 1)

	-- FIN_COMPTES_PLAN FOURNISSEURS

	INSERT INTO #FIN_COMPT_PLAN_TEMP
	(COMPTE, LIBELLE, COMPTE_EXTERNE, IS_AtooAGA40)
	VALUES ('FC0' + @ref_cab ,@CUR_LIBELLE_FC,'FC0' + @CUR_REF_CABINET, 1)

	-- FIN_TIERS CLIENTS

	INSERT INTO #FIN_TIERS_TEMP
	(COMPTE, TYPE_TIERS, SOLDE, AUTOFACTURATION, RIB, INTRACOMMUNAUTAIRE, TITULAIRE_COMPTE, DOMICILIATION
	,AUTORISATION_PRELEVEMENT, ID_PROFIL_FRS, MODE_REGLEMENT_PAR_DEFAUT, CHRONO_AUTOFACTURATION, ID_BLOCAGE_FACT
	, ID_DELAI_REGLEMENT, DATE_DEBUT_MANDAT_AUTOFACTURATION, DATE_FIN_MANDAT_AUTOFACTURATION, ADMINISTRATEUR, EXONERATION_TVA
	, PROFESSION, SOLDE_TC, #FIN_TIERS_TEMP..IS_AtooAGA40)
	VALUES ('CC0' + @ref_cab, @CUR_TYPE_TIERS_CC, @CUR_SOLDE_CC, @CUR_AUTOFACTURATION_CC, @CUR_RIB_CC
	, @CUR_INTRACOMMUNAUTAIRE_CC, @CUR_TITULAIRE_COMPTE_CC, @CUR_DOMICILIATION_CC,@CUR_AUTORISATION_PRELEVEMENT_CC
	, @CUR_ID_PROFIL_FRS_CC, @CUR_MODE_REGLEMENT_PAR_DEFAUT_CC, @CUR_CHRONO_AUTOFACTURATION_CC, @CUR_ID_BLOCAGE_FACT_CC
	, @CUR_ID_DELAI_REGLEMENT_CC, @CUR_DATE_DEBUT_MANDAT_AUTOFACTURATION_CC, @CUR_DATE_FIN_MANDAT_AUTOFACTURATION_CC, @CUR_ADMINISTRATEUR_CC
	, @CUR_EXONERATION_TVA_CC, @CUR_PROFESSION_CC, @CUR_SOLDE_TC_CC,1)

	set @_ID_TIERS_GENERE_CLT = @@IDENTITY



	-- FIN_TIERS FOURNISSEURS

	INSERT INTO #FIN_TIERS_TEMP
	(COMPTE, TYPE_TIERS, SOLDE, AUTOFACTURATION, RIB, INTRACOMMUNAUTAIRE, TITULAIRE_COMPTE, DOMICILIATION
	,AUTORISATION_PRELEVEMENT, ID_PROFIL_FRS, MODE_REGLEMENT_PAR_DEFAUT, CHRONO_AUTOFACTURATION, ID_BLOCAGE_FACT
	, ID_DELAI_REGLEMENT, DATE_DEBUT_MANDAT_AUTOFACTURATION, DATE_FIN_MANDAT_AUTOFACTURATION, ADMINISTRATEUR, EXONERATION_TVA
	, PROFESSION, SOLDE_TC, #FIN_TIERS_TEMP..IS_AtooAGA40)
	VALUES ('FC0' + @ref_cab, @CUR_TYPE_TIERS_FC, @CUR_SOLDE_FC, @CUR_AUTOFACTURATION_FC, @CUR_RIB_FC
	, @CUR_INTRACOMMUNAUTAIRE_FC, @CUR_TITULAIRE_COMPTE_FC, @CUR_DOMICILIATION_FC,@CUR_AUTORISATION_PRELEVEMENT_FC
	, @CUR_ID_PROFIL_FRS_FC, @CUR_MODE_REGLEMENT_PAR_DEFAUT_FC, @CUR_CHRONO_AUTOFACTURATION_FC, @CUR_ID_BLOCAGE_FACT_FC
	, @CUR_ID_DELAI_REGLEMENT_FC, @CUR_DATE_DEBUT_MANDAT_AUTOFACTURATION_FC, @CUR_DATE_FIN_MANDAT_AUTOFACTURATION_FC, @CUR_ADMINISTRATEUR_FC
	, @CUR_EXONERATION_TVA_FC, @CUR_PROFESSION_FC, @CUR_SOLDE_TC_FC,1)

	set @_ID_TIERS_GENERE_FRS = @@IDENTITY


--	I] Mise � jour id tiers clt et frs
		
		-- clt

	update #CAB_COMPT_TEMP set id_tiers_client = @_ID_TIERS_GENERE_CLT	where id_tiers_client = @CUR_ID_TIERS_CLIENT

		-- frs

	update #CAB_COMPT_TEMP set id_tiers_frs = @_ID_TIERS_GENERE_FRS	where id_tiers_frs = @CUR_ID_TIERS_frs


--	J] FIN REQUETE INJECTION

	FETCH NEXT FROM CABINETS_COMPTABLES_cursor 
	INTO @CUR_NUMERO_CABINET,@CUR_REF_CABINET,@CUR_NOM_CABINET,@CUR_NUMERO_OEC,@CUR_ID_RESPONSABLE_CABINET,@CUR_DATE_INSCRIPTION_ORDRE
		,@CUR_DATE_RADIATION_ORDRE,@CUR_DATE_INSCRIPTION_CGA,@CUR_DATE_RADIATION_CGA,@CUR_DATE_RECEPT_LTR_ENG,@CUR_LOGIN_SITE_CABINET
		,@CUR_PASSWORD_SITE_CABINET,@CUR_LOGICIEL_COMPTA,@CUR_REALISATION_DOG,@CUR_OBSERVATION,@CUR_ID_STATUT_MEMBRE,@CUR_ID_STATUT_COR
		,@CUR_ID_CASIER,@CUR_ID_GESTION_ADMIN,@CUR_ID_TIERS_CLIENT,@CUR_ID_TIERS_FRS,@CUR_ABT_JOURNAL,@CUR_TDFC,@CUR_PRESTATION_OG
		,@CUR_INTERVENANT,@CUR_ID_PED,@CUR_BLOCAGE_TELETRANSMISSION,@CUR_LOGICIEL_DEMAT,@CUR_DERNIER_PED,@CUR_BLOCAGE_ENVOI_COPIE_ATT
		,@CUR_ID_TYPE_SUIVI,@CUR_ID_TIERS_CC,@CUR_COMPTE_CC,@CUR_TYPE_TIERS_CC,@CUR_SOLDE_CC,@CUR_AUTOFACTURATION_CC,@CUR_RIB_CC,@CUR_INTRACOMMUNAUTAIRE_CC
		,@CUR_TITULAIRE_COMPTE_CC,@CUR_DOMICILIATION_CC,@CUR_AUTORISATION_PRELEVEMENT_CC,@CUR_ID_PROFIL_FRS_CC,@CUR_MODE_REGLEMENT_PAR_DEFAUT_CC
		,@CUR_CHRONO_AUTOFACTURATION_CC,@CUR_ID_BLOCAGE_FACT_CC,@CUR_ID_DELAI_REGLEMENT_CC,@CUR_DATE_DEBUT_MANDAT_AUTOFACTURATION_CC
		,@CUR_DATE_FIN_MANDAT_AUTOFACTURATION_CC,@CUR_ADMINISTRATEUR_CC,@CUR_EXONERATION_TVA_CC,@CUR_PROFESSION_CC,@CUR_SOLDE_TC_CC
		,@CUR_IBAN_CC,@CUR_BIC_CC,@CUR_IBAN_ORIGINE_CC,@CUR_MANDAT_SEPA_CC,@CUR_DATE_SIGNATURE_MANDAT_SEPA_CC
		,@CUR_DATE_PREMIER_PRELEVEMENT_CC,@CUR_MANDAT_SEPA_ORIGINE_CC
		,@CUR_ID_TIERS_FC,@CUR_COMPTE_FC,@CUR_TYPE_TIERS_FC,@CUR_SOLDE_FC,@CUR_AUTOFACTURATION_FC,@CUR_RIB_FC,@CUR_INTRACOMMUNAUTAIRE_FC
		,@CUR_TITULAIRE_COMPTE_FC,@CUR_DOMICILIATION_FC,@CUR_AUTORISATION_PRELEVEMENT_FC,@CUR_ID_PROFIL_FRS_FC
		,@CUR_MODE_REGLEMENT_PAR_DEFAUT_FC,@CUR_CHRONO_AUTOFACTURATION_FC,@CUR_ID_BLOCAGE_FACT_FC,@CUR_ID_DELAI_REGLEMENT_FC
		,@CUR_DATE_DEBUT_MANDAT_AUTOFACTURATION_FC,@CUR_DATE_FIN_MANDAT_AUTOFACTURATION_FC,@CUR_ADMINISTRATEUR_FC,@CUR_EXONERATION_TVA_FC
		,@CUR_PROFESSION_FC,@CUR_SOLDE_TC_FC
		,@CUR_IBAN_FC,@CUR_BIC_FC,@CUR_IBAN_ORIGINE_FC,@CUR_MANDAT_SEPA_FC,@CUR_DATE_SIGNATURE_MANDAT_SEPA_FC
		,@CUR_DATE_PREMIER_PRELEVEMENT_FC,@CUR_MANDAT_SEPA_ORIGINE_FC
		,@CUR_COMPTE_CC,@CUR_LIBELLE_CC,@CUR_COMPTE_EXTERNE_CC,@CUR_COMPTE_FC
		,@CUR_LIBELLE_FC,@CUR_COMPTE_EXTERNE_FC
END

CLOSE CABINETS_COMPTABLES_cursor
DEALLOCATE CABINETS_COMPTABLES_cursor

--select * from #CAB_COMPT_TEMP where 
--#CAB_COMPT_TEMP.REF_CAB_OLD is null 
--and 
--#CAB_COMPT_TEMP.IS_AtooAGA40 = 1

--select distinct * from AtooPivot.._CAB_BUR_COMMUNS where CAB_NUM_CAB_DST is not null and CAB_NUM_CAB_SRC is not null 

--select * from AtooAGA40..CABINETS_COMPTABLES where NUMERO_CABINET = 1
--select * from AtooCGA40..CABINETS_COMPTABLES where NUMERO_CABINET = 1
--select distinct * from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 0 and CAB_EXIST_IN_SRC_ONLY = 1







--select * from #CAB_COMPT_TEMP 
--	--left join AtooCGA40..EXPERTS on AtooCGA40..EXPERTS.ID_EXP_OLD = #CAB_COMPT_TEMP.ID_RESPONSABLE_CABINET
--where #CAB_COMPT_TEMP.IS_AtooAGA40 is not null and ID_RESPONSABLE_CABINET is not null and IS_AtooAGA40 = '1'

--update #CAB_COMPT_TEMP set ID_GESTION_ADMIN = '60' where ID_GESTION_ADMIN is not null and IS_AtooAGA40 = '1'

--##################################################


update #CAB_COMPT_TEMP set ID_RESPONSABLE_CABINET = ec.EXP_ID_EXPERT_DST
--select *
	from #CAB_COMPT_TEMP cct
	inner join AtooPivot.._EXP_COMMUNS ec on cct.ID_RESPONSABLE_CABINET = ec.EXP_ID_EXPERT_SRC and ec.EXP_EXIST_IN_BOTH = 1
	where cct.IS_AtooAGA40 is not null



--update #CAB_COMPT_TEMP set ID_PED = '1' where ID_PED = '1' and IS_AtooAGA40 = '1'
--update #CAB_COMPT_TEMP set ID_CASIER = '1' from #CAB_COMPT_TEMP where IS_AtooAGA40 = '1'

--update #CAB_COMPT_TEMP set ID_CASIER = '1' from #CAB_COMPT_TEMP ct inner join AtooAGA40..BUREAUX b on ct.NUMERO_CABINET_old = b.NUMERO_CABINET where b.EMAIL is null and IS_AtooAGA40 = '1'
--update #CAB_COMPT_TEMP set ID_CASIER = '3' from #CAB_COMPT_TEMP ct inner join AtooAGA40..BUREAUX b on ct.NUMERO_CABINET_old = b.NUMERO_CABINET where b.EMAIL is not null and IS_AtooAGA40 = '1'

--select  ct.ID_CASIER, b.EMAIL,  select * from #CAB_COMPT_TEMP ct inner join AtooAGA40..BUREAUX b on ct.NUMERO_CABINET_old = b.NUMERO_CABINET --where b.EMAIL is not null and IS_AtooAGA40 = '1'

--update #CAB_COMPT_TEMP set ID_CASIER = '44' where ID_CASIER = '41' and IS_AtooAGA40 = '1'
--update #CAB_COMPT_TEMP set ID_CASIER = '44' where ID_CASIER is null and IS_AtooAGA40 = '1'

--select ID_CASIER,* from AtooCGA40..CASIERS_COURRIERS
--select ID_CASIER,* from AtooAGA40..CASIERS_COURRIERS


--CABINET
--*******************************************************************************************


BEGIN TRAN
INSERT INTO AtooCGA40..FIN_COMPTES_PLAN
	(COMPTE, LIBELLE, COMPTE_EXTERNE)
	SELECT COMPTE, LIBELLE, COMPTE_EXTERNE
	FROM #FIN_COMPT_PLAN_TEMP
	WHERE #FIN_COMPT_PLAN_TEMP.IS_AtooAGA40= 1 AND COMPTE like 'CC%'

INSERT INTO AtooCGA40..FIN_COMPTES_PLAN
	(COMPTE, LIBELLE, COMPTE_EXTERNE)
	SELECT COMPTE, LIBELLE, COMPTE_EXTERNE
	FROM #FIN_COMPT_PLAN_TEMP
	WHERE #FIN_COMPT_PLAN_TEMP.IS_AtooAGA40= 1 AND COMPTE like 'FC%'


SET IDENTITY_INSERT [AtooCGA40].[dbo].bureaux OFF
SET IDENTITY_INSERT AtooCGA40.dbo.FIN_TIERS ON

INSERT INTO AtooCGA40..FIN_TIERS
	(ID_TIERS, COMPTE, TYPE_TIERS, SOLDE, AUTOFACTURATION, RIB, INTRACOMMUNAUTAIRE, TITULAIRE_COMPTE, DOMICILIATION
	,AUTORISATION_PRELEVEMENT, ID_PROFIL_FRS, MODE_REGLEMENT_PAR_DEFAUT, CHRONO_AUTOFACTURATION, ID_BLOCAGE_FACT
	, ID_DELAI_REGLEMENT, DATE_DEBUT_MANDAT_AUTOFACTURATION, DATE_FIN_MANDAT_AUTOFACTURATION, ADMINISTRATEUR, EXONERATION_TVA
	, PROFESSION, SOLDE_TC)
	SELECT ID_TIERS, COMPTE, TYPE_TIERS, SOLDE, AUTOFACTURATION, RIB, INTRACOMMUNAUTAIRE, TITULAIRE_COMPTE, DOMICILIATION
	,AUTORISATION_PRELEVEMENT, ID_PROFIL_FRS, MODE_REGLEMENT_PAR_DEFAUT, CHRONO_AUTOFACTURATION, ID_BLOCAGE_FACT
	, ID_DELAI_REGLEMENT, DATE_DEBUT_MANDAT_AUTOFACTURATION, DATE_FIN_MANDAT_AUTOFACTURATION, ADMINISTRATEUR, EXONERATION_TVA
	, PROFESSION, SOLDE_TC
		FROM #FIN_TIERS_TEMP
		WHERE #FIN_TIERS_TEMP.IS_AtooAGA40 = 1 AND COMPTE like 'CC%'

INSERT INTO AtooCGA40..FIN_TIERS
	(ID_TIERS, COMPTE, TYPE_TIERS, SOLDE, AUTOFACTURATION, RIB, INTRACOMMUNAUTAIRE, TITULAIRE_COMPTE, DOMICILIATION
	,AUTORISATION_PRELEVEMENT, ID_PROFIL_FRS, MODE_REGLEMENT_PAR_DEFAUT, CHRONO_AUTOFACTURATION, ID_BLOCAGE_FACT
	, ID_DELAI_REGLEMENT, DATE_DEBUT_MANDAT_AUTOFACTURATION, DATE_FIN_MANDAT_AUTOFACTURATION, ADMINISTRATEUR, EXONERATION_TVA
	, PROFESSION, SOLDE_TC)
	SELECT ID_TIERS, COMPTE, TYPE_TIERS, SOLDE, AUTOFACTURATION, RIB, INTRACOMMUNAUTAIRE, TITULAIRE_COMPTE, DOMICILIATION
	,AUTORISATION_PRELEVEMENT, ID_PROFIL_FRS, MODE_REGLEMENT_PAR_DEFAUT, CHRONO_AUTOFACTURATION, ID_BLOCAGE_FACT
	, ID_DELAI_REGLEMENT, DATE_DEBUT_MANDAT_AUTOFACTURATION, DATE_FIN_MANDAT_AUTOFACTURATION, ADMINISTRATEUR, EXONERATION_TVA
	, PROFESSION, SOLDE_TC
		FROM #FIN_TIERS_TEMP
		WHERE #FIN_TIERS_TEMP.IS_AtooAGA40 = 1 AND COMPTE like 'FC%'

SET IDENTITY_INSERT [AtooCGA40].[dbo].[FIN_TIERS] OFF
----select * from FIN_TIERS where ID_TIERS = 'CC010227'
--select * from AtooCGA40..FIN_COMPTES_PLAN where libelle in 
--(	SELECT libelle--, LIBELLE, COMPTE_EXTERNE
--	FROM #FIN_COMPT_PLAN_TEMP
--	WHERE #FIN_COMPT_PLAN_TEMP.IS_AtooAGA40= 1 AND COMPTE like 'CC%'
--	)

SET IDENTITY_INSERT [AtooCGA40].[dbo].[CABINETS_COMPTABLES] ON

INSERT INTO AtooCGA40..CABINETS_COMPTABLES
	(NUMERO_CABINET, REF_CABINET,NOM_CABINET,NUMERO_OEC,ID_RESPONSABLE_CABINET,DATE_INSCRIPTION_ORDRE,DATE_RADIATION_ORDRE,DATE_INSCRIPTION_CGA
		,DATE_RADIATION_CGA,DATE_RECEPT_LTR_ENG,LOGIN_SITE_CABINET,PASSWORD_SITE_CABINET,LOGICIEL_COMPTA,REALISATION_DOG,OBSERVATION
		,ID_STATUT_MEMBRE,ID_STATUT_COR,ID_CASIER,ID_GESTION_ADMIN,ID_TIERS_CLIENT, ID_TIERS_FRS,ABT_JOURNAL,TDFC,PRESTATION_OG
		,INTERVENANT,ID_PED,BLOCAGE_TELETRANSMISSION,LOGICIEL_DEMAT,DERNIER_PED,BLOCAGE_ENVOI_COPIE_ATT,REF_CAB_OLD)
	SELECT
		 NUMERO_CABINET,REF_CABINET,NOM_CABINET,NUMERO_OEC,ID_RESPONSABLE_CABINET,DATE_INSCRIPTION_ORDRE,DATE_RADIATION_ORDRE,DATE_INSCRIPTION_CGA
		,DATE_RADIATION_CGA,DATE_RECEPT_LTR_ENG,LOGIN_SITE_CABINET,PASSWORD_SITE_CABINET,LOGICIEL_COMPTA,REALISATION_DOG,OBSERVATION
		,ID_STATUT_MEMBRE,ID_STATUT_COR,1,null,ID_TIERS_CLIENT,ID_TIERS_FRS,ABT_JOURNAL,TDFC,PRESTATION_OG
		,INTERVENANT,ID_PED,BLOCAGE_TELETRANSMISSION,LOGICIEL_DEMAT,DERNIER_PED,BLOCAGE_ENVOI_COPIE_ATT,REF_CAB_OLD
		FROM #CAB_COMPT_TEMP
		WHERE #CAB_COMPT_TEMP.IS_AtooAGA40 = 1

SET IDENTITY_INSERT [AtooCGA40].[dbo].[CABINETS_COMPTABLES] OFF

--select * from [AtooCGA40]..CABINETS_COMPTABLES
--select * from [AtooAGA40]..CABINETS_COMPTABLES
--select * from BUREAUX


update AtooCGA40..CABINETS_COMPTABLES --inner join 
set 
--select
REF_CAB_OLD = cbc.CAB_REF_CAB_SRC
from AtooCGA40..CABINETS_COMPTABLES cc
inner join AtooPivot.._CAB_BUR_COMMUNS cbc on cbc.CAB_REF_CAB_SRC = cc.REF_CABINET and CAB_EXIST_IN_BOTH = 1 and cc.REF_CAB_OLD is null



---- ROLLBACK TRAN
 COMMIT TRAN
 BEGIN TRAN


--SET NOCOUNT ON
--I] Mise en place tables de travail
--	A] SUPPRESSION DES TABLES TEMPORAIRES

-- supprime table temporaire bureaux
if object_id('tempdb..#BUREAUX_TEMP') is not null
DROP table #BUREAUX_TEMP

-- supprime table temporaire adresses
if object_id('tempdb..#ADRESSES_TEMP') is not null
DROP table #ADRESSES_TEMP



-- cr�ation table temporaire bureaux
select *  
into #BUREAUX_TEMP
from AtooCGA40..BUREAUX

-- cr�ation table temporaire adresses

select * 
into #ADRESSES_TEMP
from AtooCGA40..ADRESSES

-- cr�ation colonne provenance donn�es cabinet comptable

ALTER TABLE #BUREAUX_TEMP ADD is_AtooAGA40 bit not null default 0

-- cr�ation colonne provenance donn�es cabinet comptable

ALTER TABLE #ADRESSES_TEMP ADD is_AtooAGA40 bit not null default 0

--BUREAUX
declare @CUR_ID_BUREAU bigint
declare @CUR_NUMERO_CABINET int
declare @CUR_CODE_BUREAU varchar(15)
declare @CUR_NOM_BUREAU varchar(60)
declare @CUR_PRINCIPAL bit
declare @CUR_ID_ADRESSE_BUREAU bigint
declare @CUR_TELEPHONE_FIXE varchar(10)
declare @CUR_TELEPHONE_FAX varchar(10)
declare @CUR_EMAIL varchar(100)
declare @CUR_SIRET numeric
declare @CUR_ID_CASIER tinyint
declare @CUR_LOGIN_CGA varchar(50)
declare @CUR_PASSWORD_CGA varchar(50)
declare @CUR_ID_TITRE int
declare @CUR_ID_STATUT_COR tinyint
declare @CUR_SITE_WEB varchar(100)
declare @CUR_ID_AGENCE tinyint
declare @CUR_ID_GESTION_ADMIN int
declare @CUR_ID_RESPONSABLE_BUREAU bigint
declare @CUR_HORODATAGE datetime
declare @CUR_SYNCHRO_ID uniqueidentifier
declare @CUR_LISTE_ANOMALIES varchar (3072)
declare @CUR_WEB_BLOCAGE_ACCES bit
declare @CUR_WEB_OPTION_ECV bit
declare @CUR_DATE_ENTREE smalldatetime
declare @CUR_DATE_SORTIE smalldatetime


--REPRISE_CORRESPONDANCE_REF_CABINET_COMPTABLE_AtooAGA40
declare @CUR_REF_CABINET_NEW varchar (50)
declare @CUR_REF_CABINET_OLD varchar (50)
declare @CUR_NUM_CAB_NEW bigint
declare @CUR_NUM_CAB_OLD bigint

--ADRESSES
declare @CUR_ID_ADRESSE bigint
declare @CUR_IDENTITE_DESTINATAIRE varchar(60)
declare @CUR_COMPLEMENT_IDENTIFICATION varchar(60)
declare @CUR_COMPLEMENT_ADRESSE varchar(60)
declare @CUR_NUMERO_VOIE varchar(10)
declare @CUR_TYPE_VOIE int
declare @CUR_LIBELLE_VOIE varchar(60)
declare @CUR_COMPLEMENT_ADRESSE_2 varchar(60)
declare @CUR_CP char(5)
declare @CUR_INSEE char(5)
declare @CUR_INTERNATIONALE bit
declare @CUR_COMPLEMENT_INTERNATIONAL varchar(60)
declare @CUR_ID_PAYS int
declare @CODE_BUR_OLD varchar (50)


-- Injection


DECLARE BUREAUX_cursor CURSOR FOR
select AtooAGA40..bureaux.*, 
AtooAGA40..adresses.*
from AtooAGA40..bureaux
inner join AtooAGA40..adresses on AtooAGA40..adresses.id_adresse = AtooAGA40..bureaux.id_adresse
where AtooAGA40..bureaux.ID_BUREAU in 
(select BUR_ID_SRC from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 0 and CAB_EXIST_IN_SRC_ONLY = 1 and CAB_IS_SAME_REF = 0)
and AtooAGA40..bureaux.principal = 1
order by code_bureau


OPEN BUREAUX_cursor

FETCH NEXT FROM BUREAUX_cursor
	INTO @CUR_ID_BUREAU,@CUR_NUMERO_CABINET,@CUR_CODE_BUREAU,@CUR_NOM_BUREAU,@CUR_PRINCIPAL,@CUR_ID_ADRESSE_BUREAU,@CUR_TELEPHONE_FIXE
		,@CUR_TELEPHONE_FAX,@CUR_EMAIL,@CUR_SIRET,@CUR_ID_CASIER,@CUR_LOGIN_CGA,@CUR_PASSWORD_CGA,@CUR_ID_TITRE,@CUR_ID_STATUT_COR
		,@CUR_SITE_WEB,@CUR_ID_AGENCE,@CUR_ID_GESTION_ADMIN,@CUR_ID_RESPONSABLE_BUREAU,@CUR_HORODATAGE,@CUR_SYNCHRO_ID 
		,@CUR_LISTE_ANOMALIES,@CUR_WEB_BLOCAGE_ACCES,@CUR_WEB_OPTION_ECV,@CUR_DATE_ENTREE,@CUR_DATE_SORTIE,@CUR_ID_ADRESSE,@CUR_IDENTITE_DESTINATAIRE,@CUR_COMPLEMENT_IDENTIFICATION,@CUR_COMPLEMENT_ADRESSE
		,@CUR_NUMERO_VOIE,@CUR_TYPE_VOIE,@CUR_LIBELLE_VOIE,@CUR_COMPLEMENT_ADRESSE_2,@CUR_CP,@CUR_INSEE,@CUR_INTERNATIONALE
		,@CUR_COMPLEMENT_INTERNATIONAL,@CUR_ID_PAYS

WHILE @@FETCH_STATUS = 0
BEGIN

	-- DECLARATION VARIABLE ID_ADRESSE

	declare @_ID_ADRESSE as bigint
	declare @_ID_BUREAU as bigint
	
	-- BUREAUX
	INSERT INTO #BUREAUX_TEMP
		(NUMERO_CABINET, CODE_BUREAU,NOM_BUREAU,PRINCIPAL,ID_ADRESSE,TELEPHONE_FIXE
		,TELEPHONE_FAX,EMAIL,SIRET,ID_CASIER,LOGIN_CGA,PASSWORD_CGA,ID_TITRE,ID_STATUT_COR
		,SITE_WEB,ID_AGENCE,ID_GESTION_ADMIN,ID_RESPONSABLE_BUREAU,HORODATAGE,SYNCHRO_ID 
		,LISTE_ANOMALIES,WEB_BLOCAGE_ACCES,WEB_OPTION_ECV,DATE_ENTREE,DATE_SORTIE,is_AtooAGA40) 
	VALUES
		(@CUR_NUMERO_CABINET,@CUR_CODE_BUREAU,@CUR_NOM_BUREAU,@CUR_PRINCIPAL,@CUR_ID_ADRESSE_BUREAU,@CUR_TELEPHONE_FIXE
		,@CUR_TELEPHONE_FAX,@CUR_EMAIL,@CUR_SIRET,@CUR_ID_CASIER,@CUR_LOGIN_CGA,@CUR_PASSWORD_CGA,@CUR_ID_TITRE,@CUR_ID_STATUT_COR
		,@CUR_SITE_WEB,@CUR_ID_AGENCE,@CUR_ID_GESTION_ADMIN,@CUR_ID_RESPONSABLE_BUREAU,@CUR_HORODATAGE,@CUR_SYNCHRO_ID 
		,@CUR_LISTE_ANOMALIES,@CUR_WEB_BLOCAGE_ACCES,@CUR_WEB_OPTION_ECV,@CUR_DATE_ENTREE,@CUR_DATE_SORTIE,1) 

set @_ID_BUREAU = @@IDENTITY


	-- ADRESSES
	INSERT INTO #ADRESSES_TEMP
		(IDENTITE_DESTINATAIRE,COMPLEMENT_IDENTIFICATION,COMPLEMENT_ADRESSE
		,NUMERO_VOIE,TYPE_VOIE,LIBELLE_VOIE,COMPLEMENT_ADRESSE_2,CP,INSEE,INTERNATIONALE
		,COMPLEMENT_INTERNATIONAL,ID_PAYS,is_AtooAGA40)
	VALUES 
		(@CUR_IDENTITE_DESTINATAIRE,@CUR_COMPLEMENT_IDENTIFICATION,@CUR_COMPLEMENT_ADRESSE
		,@CUR_NUMERO_VOIE,@CUR_TYPE_VOIE,@CUR_LIBELLE_VOIE,@CUR_COMPLEMENT_ADRESSE_2,@CUR_CP,@CUR_INSEE,@CUR_INTERNATIONALE
		,@CUR_COMPLEMENT_INTERNATIONAL,@CUR_ID_PAYS,1)

set @_ID_ADRESSE = @@IDENTITY
	

--	I] Mise � jour id adresse
		
		update #BUREAUX_TEMP set id_adresse = @_ID_ADRESSE where id_adresse = @CUR_ID_ADRESSE

FETCH NEXT FROM BUREAUX_cursor
	INTO @CUR_ID_BUREAU,@CUR_NUMERO_CABINET,@CUR_CODE_BUREAU,@CUR_NOM_BUREAU,@CUR_PRINCIPAL,@CUR_ID_ADRESSE_BUREAU,@CUR_TELEPHONE_FIXE
		,@CUR_TELEPHONE_FAX,@CUR_EMAIL,@CUR_SIRET,@CUR_ID_CASIER,@CUR_LOGIN_CGA,@CUR_PASSWORD_CGA,@CUR_ID_TITRE,@CUR_ID_STATUT_COR
		,@CUR_SITE_WEB,@CUR_ID_AGENCE,@CUR_ID_GESTION_ADMIN,@CUR_ID_RESPONSABLE_BUREAU,@CUR_HORODATAGE,@CUR_SYNCHRO_ID 
		,@CUR_LISTE_ANOMALIES,@CUR_WEB_BLOCAGE_ACCES,@CUR_WEB_OPTION_ECV,@CUR_DATE_ENTREE,@CUR_DATE_SORTIE,@CUR_ID_ADRESSE,@CUR_IDENTITE_DESTINATAIRE,@CUR_COMPLEMENT_IDENTIFICATION,@CUR_COMPLEMENT_ADRESSE
		,@CUR_NUMERO_VOIE,@CUR_TYPE_VOIE,@CUR_LIBELLE_VOIE,@CUR_COMPLEMENT_ADRESSE_2,@CUR_CP,@CUR_INSEE,@CUR_INTERNATIONALE
		,@CUR_COMPLEMENT_INTERNATIONAL,@CUR_ID_PAYS

END

CLOSE BUREAUX_cursor
DEALLOCATE BUREAUX_cursor


update #BUREAUX_TEMP set ID_GESTION_ADMIN = null where #BUREAUX_TEMP.IS_AtooAGA40 = 1

--UPDATE #BUREAUX_TEMP set 
--CODE_BUR_OLD = AtooAGA40..BUREAUX.CODE_BUREAU 
--select * 
--FROM AtooAGA40..BUREAUX, #BUREAUX_TEMP
--WHERE #BUREAUX_TEMP.CODE_BUREAU = AtooAGA40..BUREAUX.CODE_BUREAU
--AND 
--AtooAGA40..bureaux.ID_BUREAU in 
--(select BUR_ID_SRC from AtooPivot.._CAB_BUR_COMMUNS where BUR_EXIST_IN_BOTH = 1)
----and AtooAGA40..bureaux.principal = 1 
--and #BUREAUX_TEMP.is_AtooAGA40 = '1' 
--and CODE_BUR_OLD is null

update #BUREAUX_TEMP set #BUREAUX_TEMP.CODE_BUR_OLD = #CAB_COMPT_TEMP.REF_CAB_OLD, #BUREAUX_TEMP.CODE_BUREAU = #CAB_COMPT_TEMP.REF_CABINET
	, #bureaux_temp.NUMERO_CABINET = #CAB_COMPT_TEMP.NUMERO_CABINET
	--select * 
	from #BUREAUX_TEMP, #CAB_COMPT_TEMP   
	where #BUREAUX_TEMP.NUMERO_CABINET = #CAB_COMPT_TEMP.NUMERO_CABINET_OLD
	and #BUREAUX_TEMP.IS_AtooAGA40 = 1 --and #BUREAUX_TEMP.PRINCIPAL = 1
	--and #CAB_COMPT_TEMP.NUMERO_CABINET_OLD = 10125
				
--update #BUREAUX_TEMP set #BUREAUX_TEMP.CODE_BUREAU = #CAB_COMPT_TEMP.REF_CABINET + SUBSTRING(#BUREAUX_TEMP.CODE_BUREAU, 6, 10)
--			, #bureaux_temp.NUMERO_CABINET = #CAB_COMPT_TEMP.NUMERO_CABINET
--			--select *
--			from #BUREAUX_TEMP, #CAB_COMPT_TEMP   
--			where #BUREAUX_TEMP.NUMERO_CABINET = #CAB_COMPT_TEMP.NUMERO_CABINET_OLD
--			and #BUREAUX_TEMP.IS_AtooAGA40 = 1 and #BUREAUX_TEMP.PRINCIPAL = 1
--			and #BUREAUX_TEMP.CODE_BUR_OLD like convert(varchar, #CAB_COMPT_TEMP.REF_CAB_OLD) + '-[0-9]'

--select * from BUREAUX where CODE_BUREAU > 10460 -- set CODE_BUR_OLD = '00002' where code_bureau  = '00002'


----select CODE_BUR_OLD,* from #BUREAUX_TEMP where is_AtooAGA40 = '1' order by code_bureau



update AtooCGA40..BUREAUX --inner join 
set 
--select
CODE_BUR_OLD = cbc.BUR_CODE_SRC
from AtooCGA40..BUREAUX b
inner join AtooPivot.._CAB_BUR_COMMUNS cbc on cbc.BUR_ID_DST = b.ID_BUREAU and BUR_EXIST_IN_BOTH = 1 /* and CAB_IS_SAME_REF = 0*/ and b.CODE_BUR_OLD is null




SELECT * from #BUREAUX_TEMP where is_AtooAGA40 = '1' --and CODE_BUR_OLD is null



--select distinct (id_casier) from #BUREAUX_TEMP where is_AtooAGA40 = '1'
--update #BUREAUX_TEMP set ID_CASIER = '1' where ID_CASIER is null
--update #BUREAUX_TEMP set ID_CASIER = '43' where ID_CASIER = '40' and IS_AtooAGA40 = '1'
--update #BUREAUX_TEMP set ID_CASIER = '44' where ID_CASIER = '41' and IS_AtooAGA40 = '1'
--update #BUREAUX_TEMP set ID_CASIER = '44' where ID_CASIER is null and IS_AtooAGA40 = '1'

update #BUREAUX_TEMP set ID_RESPONSABLE_BUREAU = AtooCGA40..EXPERTS.ID_EXPERT 
	from #BUREAUX_TEMP 
	inner join AtooCGA40..EXPERTS on AtooCGA40..EXPERTS.ID_EXP_OLD = #BUREAUX_TEMP.ID_RESPONSABLE_BUREAU 
	where #BUREAUX_TEMP.is_AtooAGA40 is not null

update #BUREAUX_TEMP set ID_AGENCE = null


update AtooCGA40..BUREAUX set ID_AGENCE = null --where ID_AGENCE is null

update #CAB_COMPT_TEMP set ID_GESTION_ADMIN = null where ID_GESTION_ADMIN is not null and is_AtooAGA40 = '1'


--BEGIN TRAN 

SET IDENTITY_INSERT [AtooCGA40].[dbo].[ADRESSES] ON

INSERT INTO AtooCGA40..ADRESSES
		(ID_ADRESSE,IDENTITE_DESTINATAIRE,COMPLEMENT_IDENTIFICATION,COMPLEMENT_ADRESSE
		,NUMERO_VOIE,TYPE_VOIE,LIBELLE_VOIE,COMPLEMENT_ADRESSE_2,CP,INSEE,INTERNATIONALE
		,COMPLEMENT_INTERNATIONAL,ID_PAYS)
	SELECT 
		ID_ADRESSE,IDENTITE_DESTINATAIRE,COMPLEMENT_IDENTIFICATION,COMPLEMENT_ADRESSE
		,NUMERO_VOIE,TYPE_VOIE,LIBELLE_VOIE,COMPLEMENT_ADRESSE_2,CP,INSEE,INTERNATIONALE
		,COMPLEMENT_INTERNATIONAL,ID_PAYS
	FROM #ADRESSES_TEMP
		WHERE #ADRESSES_TEMP.is_AtooAGA40 = 1

SET IDENTITY_INSERT [AtooCGA40].[dbo].[ADRESSES] OFF

SET IDENTITY_INSERT [AtooCGA40].[dbo].[BUREAUX] ON

INSERT INTO AtooCGA40..BUREAUX
		(ID_BUREAU, NUMERO_CABINET, CODE_BUREAU,NOM_BUREAU,PRINCIPAL,ID_ADRESSE,TELEPHONE_FIXE
		,TELEPHONE_FAX,EMAIL,SIRET,ID_CASIER,LOGIN_CGA,PASSWORD_CGA,ID_TITRE,ID_STATUT_COR
		,SITE_WEB,ID_AGENCE,ID_GESTION_ADMIN,ID_RESPONSABLE_BUREAU,HORODATAGE,SYNCHRO_ID 
		,LISTE_ANOMALIES,WEB_BLOCAGE_ACCES,WEB_OPTION_ECV,DATE_ENTREE,DATE_SORTIE,CODE_BUR_OLD) 
	SELECT
		ID_BUREAU, NUMERO_CABINET, CODE_BUREAU,NOM_BUREAU,PRINCIPAL,ID_ADRESSE,TELEPHONE_FIXE
		,TELEPHONE_FAX,EMAIL,SIRET,ID_CASIER,LOGIN_CGA,PASSWORD_CGA,ID_TITRE,ID_STATUT_COR
		,SITE_WEB,ID_AGENCE,ID_GESTION_ADMIN,ID_RESPONSABLE_BUREAU,HORODATAGE,SYNCHRO_ID 
		,LISTE_ANOMALIES,WEB_BLOCAGE_ACCES,WEB_OPTION_ECV,DATE_ENTREE,DATE_SORTIE,CODE_BUR_OLD
	FROM #BUREAUX_TEMP
	WHERE #BUREAUX_TEMP.is_AtooAGA40 = 1 

SET IDENTITY_INSERT [AtooCGA40].[dbo].[BUREAUX] OFF








-- ROLLBACK TRAN
-- COMMIT TRAN