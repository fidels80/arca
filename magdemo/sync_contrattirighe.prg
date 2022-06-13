SET STEP ON 
TEXT TO csql TEXTMERGE noshow
select (select id_xcontratto from xcontratto where   Cd_xContratto=dorig.xCd_xContratto     )as mimmo,dorig.xCd_xContratto,
dorig.* from dorig where xcd_xcontratto is not null and  datadoc<='20140228'

ENDTEXT
xsqlexec(csql,'righe')
 

TEXT TO csql TEXTMERGE noshow

select * from dbo.xContrattoSviluppo where  Id_DOTes is null and DataFattura <='20140228' order by Riga desc

ENDTEXT
xsqlexec(csql,'x_con')

SELECT righe 



SCAN
TEXT TO csql TEXTMERGE noshow

UPDATE xContrattoSviluppo SET evasa=1, id_dotes=<<Format4Spt(righe.id_dotes )>> where id_xcontratto=
<<Format4Spt(righe.mimmo)>> and datafattura=<<Format4Spt(righe.datadoc )>> and Id_DOTes is null and DataFattura <='20140228'

ENDTEXT
xsqlexec(csql,'x_con')




ENDSCAN





