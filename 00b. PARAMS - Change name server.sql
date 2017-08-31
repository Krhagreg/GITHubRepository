declare @oldServerName varchar(50)
declare @newServerName varchar(50)

--select @@servername
set @oldServerName = 'SRV2K12'
set @newServerName = 'CGDDSKL00931'

set @newServerName = upper(@newServerName)
--select param, valeur from PARAMS
--select param, valeur from PARAMS where valeur like '%:\%'

select param, valeur from PARAMS where valeur like '%' + @oldServerName + '%'

update PARAMS set valeur = replace(valeur, @oldServerName, @newServerName) where valeur like '%' + @oldServerName + '%'

select param, valeur from PARAMS where valeur like '%' + @newServerName + '%'
