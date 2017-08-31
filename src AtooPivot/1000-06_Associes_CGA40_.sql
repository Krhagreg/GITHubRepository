SET NOCOUNT ON
--I] Mise en place tables de travail
--	A] SUPPRESSION DES TABLES TEMPORAIRES

-- supprime table temporaire bureaux
if object_id('tempdb..#ASSOCIES_TEMP') is not null
DROP table #ASSOCIES_TEMP

-- supprime table temporaire adresses
if object_id('tempdb..#PERSONNES_TEMP') is not null
DROP table #PERSONNES_TEMP

-- supprime tablex temporaire adresses
if object_id('tempdb..#ADRESSES_TEMP') is not null
DROP table #ADRESSES_TEMP

-- cr�ation table temporaire bureaux
select *  
into #ASSOCIES_TEMP
from AtooCGA40..ASSOCIES

-- cr�ation table temporaire adresses

select * 
into #PERSONNES_TEMP
from AtooCGA40..PERSONNES

-- cr�ation table temporaire adresses 

select * 
into #ADRESSES_TEMP 
from AtooCGA40..ADRESSES

-- cr�ation colonne provenance donn�es cabinet comptable

ALTER TABLE #ASSOCIES_TEMP ADD is_AtooCGA40 bit not null default 0

-- cr�ation colonne provenance donn�es cabinet comptable

ALTER TABLE #PERSONNES_TEMP ADD is_AtooCGA40 bit not null default 0

-- cr�ation colonne provenance donn�es adherents

ALTER TABLE #ADRESSES_TEMP ADD is_AtooCGA40 bit not null default 0


--	E] DECLARATION VARIABLE

-- ASSOCIES

declare @CUR_ID_ASSOCIE bigint
declare @CUR_ID_ADHERENT bigint
declare @CUR_ID_PERSONNE bigint
declare @CUR_ID_STATUT_ASSOCIE tinyint
declare @CUR_DATE_ENTREE datetime
declare @CUR_DATE_SORTIE datetime
declare @CUR_CODE varchar (10)
declare @CUR_ID_ASS_OLD varchar (50)

--PERSONNES

declare @CUR_ID_TITRE int
declare @CUR_RAISON_SOCIALE varchar(50)
declare @CUR_NOM varchar(40)
declare @CUR_PRENOM varchar(40)
declare @CUR_TELEPHONE_FIXE_PERSO varchar(18)
declare @CUR_TELEPHONE_MOBILE_PERSO varchar(18)
declare @CUR_TELEPHONE_FAX_PERSO varchar(18)
declare @CUR_EMAIL_PERSO varchar(100)
declare @CUR_TYPE_PERSONNE int
declare @CUR_ID_ADRESSE_PERSO bigint
declare @CUR_DATE_NAISSANCE smalldatetime
declare @CUR_SITE_WEB varchar(100)
declare @CUR_LOGIN_CGA varchar(15)
declare @CUR_PASSWORD_CGA varchar(15)
declare @CUR_TELEPHONE_ALTERNATIVE_PERSO varchar(18)
declare @CUR_NOM_JEUNE_FILLE varchar (40)
declare @CUR_MUST_CHANGED_PASSWORD bit
declare @CUR_ID_STATUT_EMAIL tinyint
declare @CUR_EMAIL_CCI_LIST varchar(2000)
declare @ID_EXP_OLD varchar (50)


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


declare ASSOCIES_cursor CURSOR FOR

select AtooCGA40..associes.*,AtooCGA40..personnes.*,AtooCGA40..ADRESSES.*
from AtooCGA40..associes 
left join AtooCGA40..personnes on AtooCGA40..personnes.id_personne = AtooCGA40..associes.id_personne 
left join AtooCGA40..adresses on AtooCGA40..adresses.id_adresse = AtooCGA40..personnes.id_adresse
order by AtooCGA40..associes.id_personne


OPEN ASSOCIES_cursor

FETCH NEXT FROM ASSOCIES_cursor
	INTO @CUR_ID_ASSOCIE,@CUR_ID_ADHERENT,@CUR_ID_PERSONNE,@CUR_ID_STATUT_ASSOCIE
		,@CUR_DATE_ENTREE,@CUR_DATE_SORTIE,@CUR_CODE,@CUR_ID_PERSONNE,@CUR_ID_TITRE,@CUR_RAISON_SOCIALE,@CUR_NOM,@CUR_PRENOM,@CUR_TELEPHONE_FIXE_PERSO
		,@CUR_TELEPHONE_MOBILE_PERSO,@CUR_TELEPHONE_FAX_PERSO,@CUR_EMAIL_PERSO,@CUR_TYPE_PERSONNE,@CUR_ID_ADRESSE_PERSO
		,@CUR_DATE_NAISSANCE,@CUR_SITE_WEB,@CUR_LOGIN_CGA,@CUR_PASSWORD_CGA,@CUR_TELEPHONE_ALTERNATIVE_PERSO,@CUR_NOM_JEUNE_FILLE,@CUR_MUST_CHANGED_PASSWORD
		,@CUR_ID_STATUT_EMAIL,@CUR_EMAIL_CCI_LIST,@CUR_ID_ADRESSE,@CUR_IDENTITE_DESTINATAIRE,@CUR_COMPLEMENT_IDENTIFICATION,@CUR_COMPLEMENT_ADRESSE
		,@CUR_NUMERO_VOIE,@CUR_TYPE_VOIE,@CUR_LIBELLE_VOIE,@CUR_COMPLEMENT_ADRESSE_2,@CUR_CP,@CUR_INSEE,@CUR_INTERNATIONALE
		,@CUR_COMPLEMENT_INTERNATIONAL,@CUR_ID_PAYS
		
WHILE @@FETCH_STATUS = 0
BEGIN

	declare @_ID_ASSOCIE as bigint
	declare @_ID_PERSONNE as bigint
	declare @_ID_ADRESSE as bigint

-- Experts
	
	INSERT INTO #ASSOCIES_TEMP
	(ID_ADHERENT,ID_PERSONNE,ID_STATUT_ASSOCIE,DATE_ENTREE,DATE_SORTIE,CODE,IS_AtooCGA40)
	VALUES
	(@CUR_ID_ADHERENT,@CUR_ID_PERSONNE,@CUR_ID_STATUT_ASSOCIE
	,@CUR_DATE_ENTREE,@CUR_DATE_SORTIE,@CUR_CODE,1)
	
	set @_ID_ASSOCIE = @@IDENTITY

	UPDATE #ASSOCIES_TEMP set ID_ASS_OLD = AtooCGA40..ASSOCIES.ID_ASSOCIE
	FROM AtooCGA40..ASSOCIES WHERE #ASSOCIES_TEMP.ID_PERSONNE = AtooCGA40..ASSOCIES.ID_PERSONNE
	and #ASSOCIES_TEMP.is_AtooCGA40 = '1' 

-- Personnes 
	
	INSERT INTO #PERSONNES_TEMP
	(ID_TITRE,RAISON_SOCIALE,NOM,PRENOM,TELEPHONE_FIXE,TELEPHONE_MOBILE,TELEPHONE_FAX,EMAIL,TYPE_PERSONNE,ID_ADRESSE
		,DATE_NAISSANCE,SITE_WEB,LOGIN_CGA,PASSWORD_CGA,TELEPHONE_ALTERNATIVE,NOM_JEUNE_FILLE,MUST_CHANGED_PASSWORD
		,ID_STATUT_EMAIL,EMAIL_CCI_LIST,is_AtooCGA40)
	VALUES
	(@CUR_ID_TITRE,@CUR_RAISON_SOCIALE,@CUR_NOM,@CUR_PRENOM,@CUR_TELEPHONE_FIXE_PERSO
	,@CUR_TELEPHONE_MOBILE_PERSO,@CUR_TELEPHONE_FAX_PERSO,@CUR_EMAIL_PERSO,@CUR_TYPE_PERSONNE,@CUR_ID_ADRESSE_PERSO
	,@CUR_DATE_NAISSANCE,@CUR_SITE_WEB,@CUR_LOGIN_CGA,@CUR_PASSWORD_CGA,@CUR_TELEPHONE_ALTERNATIVE_PERSO,@CUR_NOM_JEUNE_FILLE,@CUR_MUST_CHANGED_PASSWORD
	,@CUR_ID_STATUT_EMAIL,@CUR_EMAIL_CCI_LIST,1)
	
	set @_ID_PERSONNE = @@IDENTITY
	
	update #ASSOCIES_TEMP set id_personne = @_ID_PERSONNE where id_personne = @CUR_ID_PERSONNE

	-- ADRESSES
	
	INSERT INTO #ADRESSES_TEMP
		(IDENTITE_DESTINATAIRE,COMPLEMENT_IDENTIFICATION,COMPLEMENT_ADRESSE
		,NUMERO_VOIE,TYPE_VOIE,LIBELLE_VOIE,COMPLEMENT_ADRESSE_2,CP,INSEE,INTERNATIONALE
		,COMPLEMENT_INTERNATIONAL,ID_PAYS,#ADRESSES_TEMP..is_AtooCGA40)
	VALUES 
		(@CUR_IDENTITE_DESTINATAIRE,@CUR_COMPLEMENT_IDENTIFICATION,@CUR_COMPLEMENT_ADRESSE
		,@CUR_NUMERO_VOIE,@CUR_TYPE_VOIE,@CUR_LIBELLE_VOIE,@CUR_COMPLEMENT_ADRESSE_2,@CUR_CP,@CUR_INSEE,@CUR_INTERNATIONALE
		,@CUR_COMPLEMENT_INTERNATIONAL,@CUR_ID_PAYS,1)

set @_ID_ADRESSE = @@IDENTITY

	

	

--	I] Mise � jour id adresse
		
		update #PERSONNES_TEMP set id_adresse = @_ID_ADRESSE where id_adresse = @CUR_ID_ADRESSE
	

--	J] FIN REQUETE INJECTION

FETCH NEXT FROM ASSOCIES_cursor
	INTO @CUR_ID_ASSOCIE,@CUR_ID_ADHERENT,@CUR_ID_PERSONNE,@CUR_ID_STATUT_ASSOCIE
		,@CUR_DATE_ENTREE,@CUR_DATE_SORTIE,@CUR_CODE,@CUR_ID_PERSONNE,@CUR_ID_TITRE,@CUR_RAISON_SOCIALE,@CUR_NOM,@CUR_PRENOM,@CUR_TELEPHONE_FIXE_PERSO
		,@CUR_TELEPHONE_MOBILE_PERSO,@CUR_TELEPHONE_FAX_PERSO,@CUR_EMAIL_PERSO,@CUR_TYPE_PERSONNE,@CUR_ID_ADRESSE_PERSO
		,@CUR_DATE_NAISSANCE,@CUR_SITE_WEB,@CUR_LOGIN_CGA,@CUR_PASSWORD_CGA,@CUR_TELEPHONE_ALTERNATIVE_PERSO,@CUR_NOM_JEUNE_FILLE,@CUR_MUST_CHANGED_PASSWORD
		,@CUR_ID_STATUT_EMAIL,@CUR_EMAIL_CCI_LIST
		,@CUR_ID_ADRESSE,@CUR_IDENTITE_DESTINATAIRE,@CUR_COMPLEMENT_IDENTIFICATION,@CUR_COMPLEMENT_ADRESSE
		,@CUR_NUMERO_VOIE,@CUR_TYPE_VOIE,@CUR_LIBELLE_VOIE,@CUR_COMPLEMENT_ADRESSE_2,@CUR_CP,@CUR_INSEE,@CUR_INTERNATIONALE
		,@CUR_COMPLEMENT_INTERNATIONAL,@CUR_ID_PAYS
	
END

CLOSE ASSOCIES_cursor
DEALLOCATE ASSOCIES_cursor

	update #ASSOCIES_TEMP set ID_ADHERENT = AtooCGA40..ADHERENTS.ID_ADHERENT 
	from #ASSOCIES_TEMP, AtooCGA40..ASSOCIES, AtooCGA40..ADHERENTS as IA , AtooCGA40..ADHERENTS
	where #ASSOCIES_TEMP.ID_ASS_OLD = AtooCGA40..ASSOCIES.ID_ASSOCIE 
	and AtooCGA40..ASSOCIES.ID_ADHERENT = IA.ID_ADHERENT
	and IA.NUMERO_ADHERENT = AtooCGA40..ADHERENTS.NUM_ADH_OLD 
	
select * 
	from #ASSOCIES_TEMP, AtooCGA40..ASSOCIES, AtooCGA40..ADHERENTS as IA , AtooCGA40..ADHERENTS
	where #ASSOCIES_TEMP.ID_ASS_OLD = AtooCGA40..ASSOCIES.ID_ASSOCIE 
	and AtooCGA40..ASSOCIES.ID_ADHERENT = IA.ID_ADHERENT
	and IA.NUMERO_ADHERENT = AtooCGA40..ADHERENTS.NUM_ADH_OLD

select * from #ASSOCIES_TEMP
select * from AtooCGA40..ASSOCIES
select * from ASSOCIES
select * from #ADRESSES_TEMP
	

BEGIN TRAN

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
			WHERE is_AtooCGA40 = 1

SET IDENTITY_INSERT [AtooCGA40].[dbo].[ADRESSES] OFF

SET IDENTITY_INSERT [AtooCGA40].[dbo].[PERSONNES] ON

INSERT INTO AtooCGA40..PERSONNES
	(ID_PERSONNE,ID_TITRE,RAISON_SOCIALE,NOM,PRENOM,TELEPHONE_FIXE,TELEPHONE_MOBILE,TELEPHONE_FAX,EMAIL,TYPE_PERSONNE,ID_ADRESSE
		,DATE_NAISSANCE,SITE_WEB,LOGIN_CGA,PASSWORD_CGA,TELEPHONE_ALTERNATIVE,NOM_JEUNE_FILLE,MUST_CHANGED_PASSWORD,ID_STATUT_EMAIL,EMAIL_CCI_LIST)
	SELECT ID_PERSONNE,ID_TITRE,RAISON_SOCIALE,NOM,PRENOM,TELEPHONE_FIXE,TELEPHONE_MOBILE,TELEPHONE_FAX,EMAIL,TYPE_PERSONNE,ID_ADRESSE
		,DATE_NAISSANCE,SITE_WEB,LOGIN_CGA,PASSWORD_CGA,TELEPHONE_ALTERNATIVE,NOM_JEUNE_FILLE,MUST_CHANGED_PASSWORD,ID_STATUT_EMAIL,EMAIL_CCI_LIST
	FROM #PERSONNES_TEMP
	WHERE IS_AtooCGA40 = 1

SET IDENTITY_INSERT [AtooCGA40].[dbo].[PERSONNES] OFF

SET IDENTITY_INSERT [AtooCGA40].[dbo].[ASSOCIES] ON

INSERT INTO AtooCGA40..ASSOCIES
	(ID_ASSOCIE,ID_ADHERENT,ID_PERSONNE,ID_STATUT_ASSOCIE,DATE_ENTREE,DATE_SORTIE,CODE,ID_ASS_OLD)
	SELECT ID_ASSOCIE,ID_ADHERENT,ID_PERSONNE,ID_STATUT_ASSOCIE,DATE_ENTREE,DATE_SORTIE,CODE,ID_ASS_OLD
	FROM #ASSOCIES_TEMP
	WHERE IS_AtooCGA40 = 1

SET IDENTITY_INSERT [AtooCGA40].[dbo].[ASSOCIES] OFF

select * from #ASSOCIES_TEMP
select * from AtooCGA40..ASSOCIES
select * from ASSOCIES

-- ROLLBACK TRAN
-- COMMIT TRAN