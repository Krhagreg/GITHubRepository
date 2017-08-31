--SET IDENTITY_INSERT [AtooCGA].[dbo].TYPES_MANDATS_ATTEST ON
--insert into AtooCGA40..TYPES_MANDATS_ATTEST (ID_TYPE_MANDAT, LIBELLE, ATOO, VISIBLE) SELECT ID_TYPE_MANDAT, LIBELLE, ATOO, VISIBLE FROM AtooCGA40..TYPES_MANDATS_ATTEST where ID_TYPE_MANDAT = 7
--SET IDENTITY_INSERT [AtooCGA].[dbo].TYPES_MANDATS_ATTEST OFF

--ALTER TABLE AtooCGA40..mandats ADD fusion bigint null
--ALTER TABLE AtooCGA40..mandats_ecv ADD fusion bigint null


BEGIN TRAN

INSERT INTO AtooCGA40..MANDATS 
	(ID_TYPE_MANDAT, ID_ADHERENT, DATE_1, DATE_2, COMMENTAIRE, fusion)
SELECT ID_TYPE_MANDAT, AtooCGA40..ADHERENTS.ID_ADHERENT
	, DATE_1, DATE_2, COMMENTAIRE,1 
FROM AtooCGA40..mandats, AtooCGA40..ADHERENTS, AtooCGA40..ADHERENTS as IE
WHERE  AtooCGA40..mandats.id_adherent = IE.ID_ADHERENT
and 'A'+IE.NUMERO_ADHERENT = AtooCGA40..ADHERENTS.NUMERO_ADHERENT_AUXILIAIRE


SELECT * FROM AtooCGA40..TYPES_MANDATS_ATTEST
SELECT * FROM TYPES_MANDATS_ATTEST


INSERT INTO AtooCGA40..MANDATS_ECV 
	(ID_BUREAU, ID_ADHERENT, ADH_DATE_DEBUT, ADH_DATE_FIN, ADH_COMMENTAIRE
	, COR_DATE_DEBUT, COR_DATE_FIN, COR_COMMENTAIRE, ENG_DATE_RECEPTION
	, ENG_COMMENTAIRE, DPEC_DATE_DEBUT, DPEC_DATE_FIN, DPEC_COMMENTAIRE, fusion)
select AtooCGA40..BUREAUX.id_bureau
	, AtooCGA40..ADHERENTS.id_adherent
	, ADH_DATE_DEBUT, ADH_DATE_FIN, ADH_COMMENTAIRE
	, COR_DATE_DEBUT, COR_DATE_FIN, COR_COMMENTAIRE, ENG_DATE_RECEPTION
	, ENG_COMMENTAIRE, DPEC_DATE_DEBUT, DPEC_DATE_FIN, DPEC_COMMENTAIRE, 1
from AtooCGA40..mandats_ecv, AtooCGA40..ADHERENTS, AtooCGA40..BUREAUX, AtooCGA40..ADHERENTS as IA, AtooCGA40..BUREAUX as IB
where AtooCGA40..mandats_ecv.ID_BUREAU = IB.ID_BUREAU
and AtooCGA40..mandats_ecv.id_adherent = IA.ID_ADHERENT
and IB.CODE_bureau = AtooCGA40..BUREAUX.code_bur_old
and 'A'+IA.NUMERO_ADHERENT = AtooCGA40..ADHERENTS.NUMERO_ADHERENT_AUXILIAIRE



/*
ALTER TABLE AtooCGA40..MANDATS DROP column fusion
ALTER TABLE AtooCGA40..MANDATS_ECV DROP column fusion
*/

--select * from BUREAUX

--delete from AtooCGA40..MANDATS where fusion = '1'
--delete from AtooCGA40..MANDATS_ECV where fusion = '1'



--ROLLBACK TRAN
--COMMIT TRAN
