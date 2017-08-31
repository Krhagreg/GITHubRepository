SET NOCOUNT ON
--I] Mise en place tables de travail
--	A] SUPPRESSION DES TABLES TEMPORAIRES

-- supprime table temporaire bureaux
if object_id('tempdb..#COLLABORATEURS_TEMP') is not null
DROP table #COLLABORATEURS_TEMP

-- supprime table temporaire adresses
if object_id('tempdb..#PERSONNES_TEMP') is not null
DROP table #PERSONNES_TEMP



-- cr�ation table temporaire bureaux
select *  
into #COLLABORATEURS_TEMP
from AtooCGA40..COLLABORATEURS

-- cr�ation table temporaire adresses

select * 
into #PERSONNES_TEMP
from AtooCGA40..PERSONNES

-- cr�ation colonne provenance donn�es cabinet comptable

ALTER TABLE #COLLABORATEURS_TEMP ADD is_AtooCGA40 bit not null default 0

-- cr�ation colonne provenance donn�es cabinet comptable

ALTER TABLE #PERSONNES_TEMP ADD is_AtooCGA40 bit not null default 0

--	E] DECLARATION VARIABLE

-- COLLABORATEURS

declare @CUR_ID_COLLABORATEUR bigint
declare @CUR_ID_BUREAU bigint
declare @CUR_ID_PERSONNE bigint
declare @CUR_COMMENTAIRE varchar(500)
declare @CUR_CODE varchar
declare @CUR_HORODATAGE datetime
declare @CUR_SYNCHRO_ID uniqueidentifier

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
declare @CUR_ID_STATUT_EMAIL int
declare @CUR_EMAIL_CCI_LIST varchar(2000)
declare @ID_COL_OLD varchar (50)
declare @ID_BUR_OLD varchar (50)


declare COLLABORATEURS_cursor CURSOR FOR

select 
AtooCGA40..COLLABORATEURS.*,AtooCGA40..personnes.*  from AtooCGA40..COLLABORATEURS  
inner join AtooCGA40..personnes on AtooCGA40..personnes.id_personne = AtooCGA40..COLLABORATEURS.id_personne
where 
ID_COLLABORATEUR in
(select distinct COL_ID_COLLABORATEUR_SRC from AtooPivot.._COL_COMMUNS where COL_EXIST_IN_BOTH = 0 and COL_EXIST_IN_SRC_ONLY = 1)

order by AtooCGA40..collaborateurs.ID_COLLABORATEUR

OPEN COLLABORATEURS_cursor



FETCH NEXT FROM COLLABORATEURS_cursor
	INTO @CUR_ID_COLLABORATEUR,@CUR_ID_BUREAU,@CUR_ID_PERSONNE,@CUR_COMMENTAIRE,@CUR_CODE
		,@CUR_HORODATAGE,@CUR_SYNCHRO_ID,@CUR_ID_PERSONNE,@CUR_ID_TITRE,@CUR_RAISON_SOCIALE,@CUR_NOM,@CUR_PRENOM,@CUR_TELEPHONE_FIXE_PERSO
		,@CUR_TELEPHONE_MOBILE_PERSO,@CUR_TELEPHONE_FAX_PERSO,@CUR_EMAIL_PERSO,@CUR_TYPE_PERSONNE,@CUR_ID_ADRESSE_PERSO
		,@CUR_DATE_NAISSANCE,@CUR_SITE_WEB,@CUR_LOGIN_CGA,@CUR_PASSWORD_CGA,@CUR_TELEPHONE_ALTERNATIVE_PERSO,@CUR_NOM_JEUNE_FILLE,@CUR_MUST_CHANGED_PASSWORD,@CUR_ID_STATUT_EMAIL,@CUR_EMAIL_CCI_LIST

WHILE @@FETCH_STATUS = 0
BEGIN

	declare @_ID_COLLABORATEUR as bigint
	declare @_ID_PERSONNE as bigint

-- Collaborateurs
	
	INSERT INTO #COLLABORATEURS_TEMP
	(ID_BUREAU,ID_PERSONNE,COMMENTAIRE,CODE
	,HORODATAGE,SYNCHRO_ID,IS_AtooCGA40)
	VALUES
	(@CUR_ID_BUREAU,@CUR_ID_PERSONNE,@CUR_COMMENTAIRE,@CUR_CODE
	,@CUR_HORODATAGE,@CUR_SYNCHRO_ID,1)
	
	set @_ID_COLLABORATEUR = @@IDENTITY

	UPDATE #COLLABORATEURS_TEMP set ID_COL_OLD = AtooCGA40..COLLABORATEURS.ID_COLLABORATEUR 
	FROM AtooCGA40..COLLABORATEURS 
	WHERE #COLLABORATEURS_TEMP.ID_PERSONNE = AtooCGA40..COLLABORATEURS.ID_PERSONNE
	and #COLLABORATEURS_TEMP.is_AtooCGA40 = '1' 

	UPDATE #COLLABORATEURS_TEMP set ID_BUR_OLD = AtooCGA40..COLLABORATEURS.ID_BUREAU 
	FROM AtooCGA40..COLLABORATEURS 
	WHERE #COLLABORATEURS_TEMP.ID_PERSONNE = AtooCGA40..COLLABORATEURS.ID_PERSONNE
	and #COLLABORATEURS_TEMP.is_AtooCGA40 = '1' 


-- Personnes 
	
	INSERT INTO #PERSONNES_TEMP
	(ID_TITRE,RAISON_SOCIALE,NOM,PRENOM,TELEPHONE_FIXE,TELEPHONE_MOBILE,TELEPHONE_FAX,EMAIL,TYPE_PERSONNE,ID_ADRESSE
		,DATE_NAISSANCE,SITE_WEB,LOGIN_CGA,PASSWORD_CGA,TELEPHONE_ALTERNATIVE,NOM_JEUNE_FILLE,MUST_CHANGED_PASSWORD,ID_STATUT_EMAIL,EMAIL_CCI_LIST,is_AtooCGA40)
	VALUES
	(@CUR_ID_TITRE,@CUR_RAISON_SOCIALE,@CUR_NOM,@CUR_PRENOM,@CUR_TELEPHONE_FIXE_PERSO,@CUR_TELEPHONE_MOBILE_PERSO,@CUR_TELEPHONE_FAX_PERSO,@CUR_EMAIL_PERSO
		,@CUR_TYPE_PERSONNE,@CUR_ID_ADRESSE_PERSO,@CUR_DATE_NAISSANCE,@CUR_SITE_WEB,@CUR_LOGIN_CGA,@CUR_PASSWORD_CGA,@CUR_TELEPHONE_ALTERNATIVE_PERSO,@CUR_NOM_JEUNE_FILLE,@CUR_MUST_CHANGED_PASSWORD,@CUR_ID_STATUT_EMAIL,@CUR_EMAIL_CCI_LIST,1)
	
	set @_ID_PERSONNE = @@IDENTITY
	
	update #COLLABORATEURS_TEMP set id_personne = @_ID_PERSONNE where id_personne = @CUR_ID_PERSONNE

--	J] FIN REQUETE INJECTION

FETCH NEXT FROM COLLABORATEURS_cursor
	INTO @CUR_ID_COLLABORATEUR,@CUR_ID_BUREAU,@CUR_ID_PERSONNE,@CUR_COMMENTAIRE,@CUR_CODE
		,@CUR_HORODATAGE,@CUR_SYNCHRO_ID,@CUR_ID_PERSONNE,@CUR_ID_TITRE,@CUR_RAISON_SOCIALE,@CUR_NOM,@CUR_PRENOM,@CUR_TELEPHONE_FIXE_PERSO
		,@CUR_TELEPHONE_MOBILE_PERSO,@CUR_TELEPHONE_FAX_PERSO,@CUR_EMAIL_PERSO,@CUR_TYPE_PERSONNE,@CUR_ID_ADRESSE_PERSO
		,@CUR_DATE_NAISSANCE,@CUR_SITE_WEB,@CUR_LOGIN_CGA,@CUR_PASSWORD_CGA,@CUR_TELEPHONE_ALTERNATIVE_PERSO,@CUR_NOM_JEUNE_FILLE,@CUR_MUST_CHANGED_PASSWORD,@CUR_ID_STATUT_EMAIL,@CUR_EMAIL_CCI_LIST

END

CLOSE COLLABORATEURS_cursor
DEALLOCATE COLLABORATEURS_cursor





BEGIN TRAN 

SET IDENTITY_INSERT [AtooCGA40].[dbo].[PERSONNES] ON

INSERT INTO AtooCGA40..PERSONNES
	(ID_PERSONNE,ID_TITRE,RAISON_SOCIALE,NOM,PRENOM,TELEPHONE_FIXE,TELEPHONE_MOBILE,TELEPHONE_FAX,EMAIL,TYPE_PERSONNE,ID_ADRESSE
		,DATE_NAISSANCE,SITE_WEB,LOGIN_CGA,PASSWORD_CGA,TELEPHONE_ALTERNATIVE,NOM_JEUNE_FILLE,MUST_CHANGED_PASSWORD,ID_STATUT_EMAIL)
	SELECT ID_PERSONNE,ID_TITRE,RAISON_SOCIALE,NOM,PRENOM,TELEPHONE_FIXE,TELEPHONE_MOBILE,TELEPHONE_FAX,EMAIL,TYPE_PERSONNE,ID_ADRESSE
		,DATE_NAISSANCE,SITE_WEB,LOGIN_CGA,PASSWORD_CGA,TELEPHONE_ALTERNATIVE,NOM_JEUNE_FILLE,MUST_CHANGED_PASSWORD,ID_STATUT_EMAIL
	FROM #PERSONNES_TEMP
		--inner join #COLLABORATEURS_TEMP on #COLLABORATEURS_TEMP.id_personne = #PERSONNES_TEMP.id_personne 
		where IS_AtooCGA40 = 1

SET IDENTITY_INSERT [AtooCGA40].[dbo].[PERSONNES] OFF

SET IDENTITY_INSERT [AtooCGA40].[dbo].[COLLABORATEURS] ON

INSERT INTO AtooCGA40..COLLABORATEURS
	(ID_COLLABORATEUR,ID_BUREAU,ID_PERSONNE,COMMENTAIRE,CODE
	,HORODATAGE,SYNCHRO_ID,ID_COL_OLD,ID_BUR_OLD)
	SELECT ID_COLLABORATEUR,ID_BUREAU,ID_PERSONNE,COMMENTAIRE,CODE
	,HORODATAGE,SYNCHRO_ID,ID_COL_OLD,ID_BUR_OLD
	FROM #COLLABORATEURS_TEMP
	WHERE IS_AtooCGA40 = 1

SET IDENTITY_INSERT [AtooCGA40].[dbo].[COLLABORATEURS] OFF

update COLLABORATEURS set ID_COL_OLD = cc.COL_ID_COLLABORATEUR_SRC, ID_BUR_OLD = cc.COL_BUR_ID_SRC
--select *
from AtooCGA40..COLLABORATEURS c
inner join AtooPivot.._COL_COMMUNS cc on cc.COL_EXIST_IN_BOTH = 1 and cc.COL_ID_COLLABORATEUR_DST = c.ID_COLLABORATEUR and cc.COL_BUR_ID_DST = c.ID_BUREAU --= cc.COL_ID_COLLABORATEUR_SRC


--select *
--from #COLLABORATEURS_TEMP c
--inner join AtooPivot.._COL_COMMUNS cc on cc.COL_EXIST_IN_BOTH = 1 and cc.COL_ID_COLLABORATEUR_DST = c.ID_COLLABORATEUR and cc.COL_BUR_ID_DST = c.ID_BUREAU --= cc.COL_ID_COLLABORATEUR_SRC
--where c.is_AtooCGA40 = '1' 
----order by 2

--select COUNT (*) from AtooPivot.._col_communs where COL_EXIST_IN_BOTH = 1


---- ROLLBACK TRAN
---- COMMIT TRAN