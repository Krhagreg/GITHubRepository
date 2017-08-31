--delete from AtooPivot.._CAB_BUR_COMMUNS
--delete from AtooPivot.._EXP_COMMUNS
--delete from AtooPivot.._COL_COMMUNS

EXEC AtooPivot..sp_MSForEachTable 'DELETE FROM ?'
GO
