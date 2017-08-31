SET NOCOUNT ON
--I] Mise en place tables de travailTEMPORAIRES
--	A] SUPPRESSION DES TABLES TEMPORAIRES

-- supprime table temporaire exerce pour
if object_id('tempdb..#EXERCE_POUR_TEMP') is not null
DROP table #EXERCE_POUR_TEMP

-- création table temporaire exerce pour

select *
into #EXERCE_POUR_TEMP
from AtooCGA40..EXERCE_POUR
where PRINCIPAL = 1


-- création colonne provenance données cabinet comptable

ALTER TABLE #EXERCE_POUR_TEMP ADD is_AtooCGA40 bit not null default 0

-- EXERCE POUR

declare @CUR_ID_BUREAU bigint
declare @CUR_ID_EXPERT bigint
declare @CUR_LIGNE_DIRECTE_BUREAU varchar (10)
declare @CUR_PRINCIPAL bit 
declare @CUR_HORODATAGE datetime 
declare @CUR_SYNCHRO_ID uniqueidentifier
declare @CUR_ID_EXP_OLD varchar (50)
declare @CUR_ID_BUR_OLD varchar (50)

declare EXERCE_POUR_cursor CURSOR FOR


select aep.* 
from AtooCGA40..exerce_pour aep
inner join AtooPivot.._EXP_COMMUNS ec on aep.id_expert = ec.EXP_ID_EXPERT_SRC and aep.ID_BUREAU = ec.EXP_BUR_ID_SRC and ec.EXP_EXIST_IN_DST_ONLY = 1 and aep.PRINCIPAL = 1


OPEN EXERCE_POUR_cursor
FETCH NEXT FROM EXERCE_POUR_cursor
	INTO @CUR_ID_BUREAU,@CUR_ID_EXPERT,@CUR_LIGNE_DIRECTE_BUREAU,@CUR_PRINCIPAL
		,@CUR_HORODATAGE,@CUR_SYNCHRO_ID
		
WHILE @@FETCH_STATUS = 0

BEGIN

	INSERT INTO #EXERCE_POUR_TEMP
	(ID_BUREAU,ID_EXPERT,LIGNE_DIRECTE_BUREAU,PRINCIPAL
	,HORODATAGE,SYNCHRO_ID,IS_AtooCGA40, ID_EXP_OLD, ID_BUR_OLD)
	VALUES
	(@CUR_ID_BUREAU,@CUR_ID_EXPERT,@CUR_LIGNE_DIRECTE_BUREAU,@CUR_PRINCIPAL
	,null,null,1, @CUR_ID_EXPERT, @CUR_ID_BUREAU)


FETCH NEXT FROM EXERCE_POUR_cursor
	INTO @CUR_ID_BUREAU,@CUR_ID_EXPERT,@CUR_LIGNE_DIRECTE_BUREAU,@CUR_PRINCIPAL
		,@CUR_HORODATAGE,@CUR_SYNCHRO_ID
END

CLOSE EXERCE_POUR_cursor
DEALLOCATE EXERCE_POUR_cursor



update #EXERCE_POUR_TEMP set 
#EXERCE_POUR_TEMP.ID_EXPERT = ec.EXP_ID_EXPERT_DST,
#EXERCE_POUR_TEMP.ID_BUREAU = ec.EXP_BUR_ID_DST
--select *
from #EXERCE_POUR_TEMP  aep
inner join AtooPivot.._EXP_COMMUNS ec on 
	aep.id_expert = ec.EXP_ID_EXPERT_SRC 
	and 
	aep.ID_BUREAU = ec.EXP_BUR_ID_SRC 
	and 
	ec.EXP_EXIST_IN_DST_ONLY = 1
where aep.is_AtooCGA40 = '1' 



-- ROLLBACK TRAN


--select b.NOM_BUREAU,* from EXERCE_POUR ep
--inner join AtooCGA40..EXPERTS e on e.ID_EXPERT = ep.ID_EXPERT
--inner join AtooCGA40..PERSONNES p on p.ID_PERSONNE = e.ID_PERSONNE
--inner join AtooCGA40..BUREAUX b on b.ID_bureau = ep.ID_BUREAU
--and p.nom like 'caillabet'
--and e.ID_EXPERT =  500

--select b.NOM_BUREAU,* from EXERCE_POUR ep
--inner join EXPERTS e on e.ID_EXPERT = ep.ID_EXPERT
--inner join PERSONNES p on p.ID_PERSONNE = e.ID_PERSONNE
--inner join BUREAUX b on b.ID_bureau = ep.ID_BUREAU
--and p.nom like 'caillabet'
--and e.ID_EXPERT =  500

--select b.NOM_BUREAU,* from #EXERCE_POUR_TEMP ep
--inner join AtooCGA40..EXPERTS e on e.ID_EXPERT = ep.ID_EXPERT
--inner join AtooCGA40..PERSONNES p on p.ID_PERSONNE = e.ID_PERSONNE
--inner join AtooCGA40..BUREAUX b on b.ID_bureau = ep.ID_BUREAU
--and p.nom like 'caillabet'
--and ep.is_AtooCGA40 =  '1'
--and e.ID_EXPERT =  500

--select b.NOM_BUREAU,* from #EXERCE_POUR_TEMP ep
--inner join EXPERTS e on e.ID_EXPERT = ep.ID_EXPERT
--inner join PERSONNES p on p.ID_PERSONNE = e.ID_PERSONNE
--inner join BUREAUX b on b.ID_bureau = ep.ID_BUREAU
--and p.nom like 'caillabet'
--and ep.is_AtooCGA40 =  '1'
--and e.ID_EXPERT =  500


--update AtooCGA40..EXERCE_pour set
--select * 
----ID_BUR_OLD = ec.EXP_BUR_ID_SRC,
----ID_EXP_OLD = ec.EXP_ID_EXPERT_SRC
--from AtooCGA40..EXERCE_pour ep
--inner join AtooPivot.._EXP_COMMUNS ec on ep.ID_BUR_OLD = ec.EXP_BUR_ID_SRC and ep.ID_EXP_OLD = ec.EXP_ID_EXPERT_SRC
--where ec.EXP_BUR_SRC_IS_IN_BUR_COMMUN = 1


--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	938	 where ID_BUREAU =	1029
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	936	 where ID_BUREAU =	818
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	933	 where ID_BUREAU =	1035
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	930	 where ID_BUREAU =	807
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	927	 where ID_BUREAU =	822
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	925	 where ID_BUREAU =	1056
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	924	 where ID_BUREAU =	798
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	922	 where ID_BUREAU =	785
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	907	 where ID_BUREAU =	1105
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	900	 where ID_BUREAU =	865
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	896	 where ID_BUREAU =	1058
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	895	 where ID_BUREAU =	850
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	893	 where ID_BUREAU =	791
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	892	 where ID_BUREAU =	740
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	891	 where ID_BUREAU =	1052
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	887	 where ID_BUREAU =	154
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	885	 where ID_BUREAU =	828
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	883	 where ID_BUREAU =	1059
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	879	 where ID_BUREAU =	1041
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	878	 where ID_BUREAU =	802
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	877	 where ID_BUREAU =	81
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	873	 where ID_BUREAU =	1050
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	867	 where ID_BUREAU =	857
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	866	 where ID_BUREAU =	87
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	865	 where ID_BUREAU =	1024
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	858	 where ID_BUREAU =	833
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	851	 where ID_BUREAU =	40
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	845	 where ID_BUREAU =	148
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	844	 where ID_BUREAU =	188
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	841	 where ID_BUREAU =	825
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	840	 where ID_BUREAU =	790
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	834	 where ID_BUREAU =	129
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	831	 where ID_BUREAU =	822
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	827	 where ID_BUREAU =	810
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	826	 where ID_BUREAU =	109
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	825	 where ID_BUREAU =	859
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	822	 where ID_BUREAU =	806
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	821	 where ID_BUREAU =	70
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	818	 where ID_BUREAU =	801
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	817	 where ID_BUREAU =	1089
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	816	 where ID_BUREAU =	67
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	812	 where ID_BUREAU =	202
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	811	 where ID_BUREAU =	860
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	810	 where ID_BUREAU =	797
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	807	 where ID_BUREAU =	44
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	802	 where ID_BUREAU =	1089
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	800	 where ID_BUREAU =	867
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	798	 where ID_BUREAU =	814
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	794	 where ID_BUREAU =	783
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	792	 where ID_BUREAU =	107
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	789	 where ID_BUREAU =	1039
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	787	 where ID_BUREAU =	763
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	785	 where ID_BUREAU =	47
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	783	 where ID_BUREAU =	768
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	781	 where ID_BUREAU =	831
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	780	 where ID_BUREAU =	795
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	777	 where ID_BUREAU =	756
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	776	 where ID_BUREAU =	737
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	775	 where ID_BUREAU =	754
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	773	 where ID_BUREAU =	770
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	770	 where ID_BUREAU =	742
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	769	 where ID_BUREAU =	123
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	767	 where ID_BUREAU =	747
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	750	 where ID_BUREAU =	743
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	749	 where ID_BUREAU =	751
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	142	 where ID_BUREAU =	829
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	140	 where ID_BUREAU =	205
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	138	 where ID_BUREAU =	204
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	136	 where ID_BUREAU =	980
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	133	 where ID_BUREAU =	796
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	130	 where ID_BUREAU =	758
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	128	 where ID_BUREAU =	4
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	116	 where ID_BUREAU =	739
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	112	 where ID_BUREAU =	153
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	111	 where ID_BUREAU =	152
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	108	 where ID_BUREAU =	149
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	107	 where ID_BUREAU =	148
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	105	 where ID_BUREAU =	1067
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	98	 where ID_BUREAU =	136
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	96	 where ID_BUREAU =	126
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	94	 where ID_BUREAU =	124
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	92	 where ID_BUREAU =	116
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	91	 where ID_BUREAU =	112
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	88	 where ID_BUREAU =	110
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	80	 where ID_BUREAU =	848
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	78	 where ID_BUREAU =	31
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	75	 where ID_BUREAU =	1087
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	71	 where ID_BUREAU =	92
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	61	 where ID_BUREAU =	741
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	59	 where ID_BUREAU =	724
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	53	 where ID_BUREAU =	68
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	42	 where ID_BUREAU =	26
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	41	 where ID_BUREAU =	55
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	40	 where ID_BUREAU =	54
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	39	 where ID_BUREAU =	53
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	37	 where ID_BUREAU =	48
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	36	 where ID_BUREAU =	46
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	33	 where ID_BUREAU =	42
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	32	 where ID_BUREAU =	1026
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	31	 where ID_BUREAU =	39
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	30	 where ID_BUREAU =	38
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	29	 where ID_BUREAU =	37
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	28	 where ID_BUREAU =	36
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	27	 where ID_BUREAU =	34
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	26	 where ID_BUREAU =	33
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	25	 where ID_BUREAU =	30
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	24	 where ID_BUREAU =	29
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	23	 where ID_BUREAU =	28
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	22	 where ID_BUREAU =	186
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	21	 where ID_BUREAU =	25
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	20	 where ID_BUREAU =	181
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	19	 where ID_BUREAU =	22
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	18	 where ID_BUREAU =	21
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	17	 where ID_BUREAU =	20
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	16	 where ID_BUREAU =	19
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	15	 where ID_BUREAU =	18
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	14	 where ID_BUREAU =	17
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	12	 where ID_BUREAU =	15
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	11	 where ID_BUREAU =	14
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	10	 where ID_BUREAU =	12
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	9	 where ID_BUREAU =	11
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	8	 where ID_BUREAU =	10
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	7	 where ID_BUREAU =	9
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	5	 where ID_BUREAU =	7
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	4	 where ID_BUREAU =	6
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	3	 where ID_BUREAU =	3
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	2	 where ID_BUREAU =	2
--update AtooCGA40..EXERCE_pour set ID_BUR_OLD = 	1	 where ID_BUREAU =	1



-- ROLLBACK TRAN

--select * from EXERCE_POUR where 


	--select * from EXERCE_POUR ep 
	--inner join EXERCE_POUR e on ep.ID_EXPERT = e.ID_EXPERT and ep.ID_BUREAU = e.ID_BUREAU 
	--where 
	--ep.id_expert in (select distinct ID_EXPERT from #EXERCE_POUR_temp where is_AtooCGA40 =  1)
	--and
	--ep.ID_BUREAU not in (select distinct ID_BUREAU from #EXERCE_POUR_temp where is_AtooCGA40 =  1)
	--and ep.principal = 1
	--order by 2 desc

--	--select * from #EXERCE_POUR_TEMP ep 
--	--inner join AtooCGA40..EXPERTS e on e.ID_EXPERT = ep.ID_EXPERT
--	--inner join AtooCGA40..PERSONNES p on p.ID_personne = e.ID_personne
--	--where ep.id_expert = 500

--	select * from #EXERCE_POUR_TEMP ep 
--	inner join AtooCGA40..EXERCE_POUR p on p.ID_personne = e.ID_EXPERT and ep.ID_BUREAU = e.ID_BUREAU 
--	inner join EXERCE_POUR e on ep.ID_EXPERT = e.ID_EXPERT and ep.ID_BUREAU = e.ID_BUREAU 
--	and is_AtooCGA40 =  '1'
--	and ep.principal = 1
--	where 
--	ep.id_expert in (select distinct ID_EXPERT from EXERCE_POUR)
--	and
--	ep.ID_BUREAU in (select distinct ID_BUREAU from EXERCE_POUR)
--	and is_AtooCGA40 =  1
--	order by 2 desc




----select * from #EXERCE_POUR_TEMP cep where ID_EXP_OLD = 672
--select * from EXERCE_POUR where ID_BUREAU = 154
--select * from bureaux where ID_BUREAU = 94
--select * from bureaux where CODE_BUR_OLD = 10141

--select * from experts where ID_EXPERT in (508)
--select * from EXERCE_POUR where id_exp_old = 537



--select * from AtooCGA40..EXERCE_POUR where ID_BUREAU = 887
--select * from AtooCGA40..bureaux where ID_BUREAU = 887
--select * from AtooCGA40..BUREAUX where ID_BUREAU in (887) 

--select * from AtooCGA40..experts where ID_EXPERT in (537)
--select * from AtooCGA40..EXERCE_POUR where ID_EXPERT = 537



--select ep.id_expert,* from AtooCGA40..BUREAUX b
--inner join AtooCGA40..EXERCE_POUR ep on b.ID_BUREAU = ep.ID_BUREAU
--inner join AtooCGA40..experts e on e.ID_expert = ep.ID_expert
--where
--b.ID_BUREAU in (32)
--and
--b.CODE_BUREAU = '10197'

--select * from AtooCGA40..EXERCE_POUR ep 
--where
--ep.ID_BUREAU in (943)


--select * from BUREAUX b
--inner join EXERCE_POUR ep on b.ID_BUREAU = ep.ID_BUREAU
--where 
--b.ID_BUREAU = 1269

--select p.NOM,* from #EXERCE_POUR_TEMP ep 
--inner join AtooCGA40..EXPERTS e on e.ID_EXPERT = ep.ID_EXPERT
--inner join AtooCGA40..PERSONNES p on p.ID_personne = e.ID_personne
--where ep.ID_BUREAU = 871


----select * from EXERCE_POUR ep 
----where
----ep.ID_EXPERT in (49,59)




--order by 1


BEGIN TRAN


--INSERT INTO AtooCGA40..EXERCE_POUR	(ID_BUREAU,ID_EXPERT,LIGNE_DIRECTE_BUREAU,PRINCIPAL)
--select bcga.ID_BUREAU, ce.ID_EXPERT, aep.LIGNE_DIRECTE_BUREAU, aep.PRINCIPAL
--from AtooCGA40..exerce_pour aep
--inner join AtooCGA40..experts e on e.id_expert = aep.id_expert 
--inner join AtooCGA40..experts ce on ce.id_exp_old = aep.id_expert
--inner join AtooCGA40..BUREAUX BAGA on BAGA.ID_BUREAU = aep.ID_BUREAU
--inner join AtooCGA40..BUREAUX BCGA on BCGA.CODE_BUR_OLD = BAGA.CODE_BUREAU
--where 
--aep.PRINCIPAL = 1 
--and aep.ID_BUREAU not in (1,2,3,4,5,7,8,9,10,11,12,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,36,37,39,40,41,42,53,59,61,71,75,78,80,88,91,92,94,96,98,105,107,108,111,112,116,128,130,133,136,138,140,142,749,750,767,769,770,773,775,776,777,780,781,783,784,785,787,789,792,794,798,800,802,807,810,811,812,816,817,818,821,822,825,826,827,831,834,840,841,844,845,851,858,865,866,867,873,877,878,879,883,885,887,891,892,893,895,896,900,907,922,924,925,927,930,933,936,938)
--order by 1

--INSERT INTO AtooCGA40..EXERCE_POUR	(ID_BUREAU,ID_EXPERT,LIGNE_DIRECTE_BUREAU,PRINCIPAL)
--select bcga.ID_BUREAU, ce.ID_EXPERT, aep.LIGNE_DIRECTE_BUREAU, aep.PRINCIPAL
--from AtooCGA40..exerce_pour aep
--inner join AtooCGA40..experts e on e.id_expert = aep.id_expert 
--inner join AtooPivot.._EXP_COMMUNS ec on e.id_expert = ec.EXP_ID_EXPERT_SRC and ec.EXP_EXIST_IN_BOTH = 1 and ec.EXP_EXIST_IN_SRC_ONLY = 1
--where 
--aep.PRINCIPAL = 1 
--order by 1

----select ec.EXP_BUR_ID_DST, ec.EXP_ID_EXPERT_DST, aep.LIGNE_DIRECTE_BUREAU, aep.PRINCIPAL, ec.EXP_ID_EXPERT_SRC, ec.EXP_BUR_ID_SRC
--select distinct ec.EXP_BUR_ID_DST,ec.EXP_ID_EXPERT_DST,*
--from AtooCGA40..exerce_pour aep
--inner join AtooPivot.._EXP_COMMUNS ec on 
--	aep.id_expert = ec.EXP_ID_EXPERT_SRC and aep.ID_BUREAU = ec.EXP_BUR_ID_SRC and ec.EXP_EXIST_IN_DST_ONLY = 1 --and ec.EXP_BUR_SRC_IS_IN_BUR_COMMUN = 0
----inner join AtooCGA40..EXERCE_POUR cep on ec.EXP_BUR_ID_DST = cep.ID_BUREAU and ec.EXP_ID_EXPERT_DST = cep.ID_EXPERT and cep.PRINCIPAL = 1
--where 
--aep.PRINCIPAL = 1 
----and 
----ec.EXP_ID_EXPERT_SRC = 537


INSERT INTO AtooCGA40..EXERCE_POUR
	(ID_BUREAU,ID_EXPERT,LIGNE_DIRECTE_BUREAU,PRINCIPAL,HORODATAGE,SYNCHRO_ID,ID_BUR_OLD,ID_EXP_OLD)
	select ID_BUREAU,ID_EXPERT,LIGNE_DIRECTE_BUREAU,PRINCIPAL,null,null,ID_BUR_OLD,ID_EXP_OLD from #EXERCE_POUR_TEMP
	where 
	is_AtooCGA40 = 1
	and
	ID_BUREAU not in (26,44,54,42,810,857)

	--rollback tran



--	SELECT ept.ID_BUREAU,ept.ID_EXPERT,ept.LIGNE_DIRECTE_BUREAU,ept.PRINCIPAL,null,null,ept.ID_BUR_OLD,ept.ID_EXP_OLD
--	FROM #EXERCE_POUR_TEMP ept, AtooCGA40..EXERCE_POUR ep
--	where 
--	ept.is_AtooCGA40 = 1
--	ept.ID_BUREAU = ep.ID_BUR_OLD and ept.ID_EXPERT = ep.ID_EXP_OLD 
--	and ep.ID_BUREAU not in 
--(
--	SELECT distinct ID_BUREAU
--	FROM #EXERCE_POUR_TEMP
--	WHERE IS_AtooCGA40 = 1 and PRINCIPAL = 1 and id_bureau not in (54,810,857,42,44,26) and ID_EXPERT not in (40,528,503) 
--	group by ID_BUREAU
--)
--and 
--ep.ID_EXPERT not in (
--	SELECT distinct ID_EXPERT
--	FROM #EXERCE_POUR_TEMP
--	WHERE IS_AtooCGA40 = 1 and PRINCIPAL = 1 and ID_EXPERT not in (40,528)
--	group by ID_EXPERT
--)
--and ept.PRINCIPAL = 1
--and ept.ID_BUR_OLD in (10,42)


--	select * from AtooCGA40..EXERCE_POUR
--	where ID_BUREAU in 
--(
--	SELECT distinct ID_BUREAU
--	FROM #EXERCE_POUR_TEMP
--	WHERE IS_AtooCGA40 = 1 and PRINCIPAL = 1 and id_bureau not in (54,810,857,42,44) and ID_EXPERT not in (40,528) 
--	group by ID_BUREAU
--)
--and 
--ID_EXPERT in (
--	SELECT distinct ID_EXPERT
--	FROM #EXERCE_POUR_TEMP
--	WHERE IS_AtooCGA40 = 1 and PRINCIPAL = 1 and ID_EXPERT not in (40,528)
--	group by ID_EXPERT
--)
--and PRINCIPAL = 1


--group by ID_BUREAU,ID_EXPERT

--INSERT INTO AtooCGA40..EXERCE_POUR	(ID_BUREAU,ID_EXPERT,LIGNE_DIRECTE_BUREAU,PRINCIPAL,ID_EXP_OLD,ID_BUR_OLD)
--select distinct ec.EXP_BUR_ID_DST, ec.EXP_ID_EXPERT_DST, aep.LIGNE_DIRECTE_BUREAU, aep.PRINCIPAL, ec.EXP_ID_EXPERT_SRC, ec.EXP_BUR_ID_SRC
--from 
--AtooCGA40..exerce_pour aep
--inner join AtooPivot.._EXP_COMMUNS ec on 
--	aep.id_expert = ec.EXP_ID_EXPERT_SRC 
--	and 
--	aep.ID_BUREAU = ec.EXP_BUR_ID_SRC 
--	and 
--	ec.EXP_EXIST_IN_DST_ONLY = 1
----,
----AtooCGA40..EXERCE_POUR cep 
--where 
--aep.PRINCIPAL = 1 
----and 
----cep.PRINCIPAL = 1
----and 
----(cep.ID_EXPERT <> 537 and cep.ID_BUREAU <> 749)
--order by 5


--select ec.EXP_BUR_ID_DST, ec.EXP_ID_EXPERT_DST, aep.LIGNE_DIRECTE_BUREAU, aep.PRINCIPAL, ec.EXP_ID_EXPERT_SRC, ec.EXP_BUR_ID_SRC
----select *
--from AtooCGA40..exerce_pour aep
--inner join AtooPivot.._EXP_COMMUNS ec on aep.id_expert = ec.EXP_ID_EXPERT_SRC and aep.ID_BUREAU = ec.EXP_BUR_ID_SRC --and ec.EXP_EXIST_IN_BOTH = 1-- and ec.EXP_EXIST_IN_SRC_ONLY = 1
--where 
--aep.PRINCIPAL = 1 
--order by 6



--INSERT INTO AtooCGA40..EXERCE_POUR
--	(ID_BUREAU,ID_EXPERT,LIGNE_DIRECTE_BUREAU,PRINCIPAL,HORODATAGE,SYNCHRO_ID,ID_EXP_OLD,ID_BUR_OLD)
--	SELECT ID_BUREAU,ID_EXPERT,LIGNE_DIRECTE_BUREAU,PRINCIPAL,HORODATAGE,SYNCHRO_ID,ID_EXP_OLD,ID_BUR_OLD
--	FROM #EXERCE_POUR_TEMP
--	WHERE IS_AtooCGA40 = 1 

--update AtooCGA40..EXERCE_POUR
--set 
--select *
----select
----id_expert = ec.EXP_ID_EXPERT_DST,
----id_bureau = ec.EXP_BUR_ID_DST,
----HORODATAGE = null,
----SYNCHRO_ID = null
--from  #EXERCE_POUR_TEMP ep
--inner join AtooPivot.._EXP_COMMUNS ec on ep.ID_EXP_OLD = ec.EXP_ID_EXPERT_SRC and ep.ID_BUR_OLD = ec.EXP_BUR_ID_SRC  /*and ec.EXP_EXIST_IN_BOTH = 0 */and ec.EXP_EXIST_IN_DST_ONLY = 0 --and ep.principal = 1

--select *
----ep.id_expert , ec.EXP_ID_EXPERT_DST,
----ep.id_bureau , ec.EXP_BUR_ID_DST
--from  #EXERCE_POUR_TEMP ep --where ep.ID_EXP_OLD is null order by 2
----inner join AtooPivot.._EXP_COMMUNS ec on ep.ID_EXPert = ec.EXP_ID_EXPERT_DST and ep.ID_BUREAU = ec.EXP_BUR_ID_DST and ec.EXP_EXIST_IN_BOTH = 0-- and ec.EXP_EXIST_IN_SRC_ONLY = 0 and ep.principal = 1
--inner join AtooPivot.._EXP_COMMUNS ec on ep.ID_EXP_OLD = ec.EXP_ID_EXPERT_SRC and ep.ID_BUR_OLD = ec.EXP_ID_EXPERT_SRC


 -- ROLLBACK TRAN
 -- COMMIT TRAN