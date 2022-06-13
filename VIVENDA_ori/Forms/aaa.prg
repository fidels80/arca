 
SELECT reportall
Replace reportall.SqlCommand With StrTran(ReportAll.SqlCommand, 'From CGSaldo_Eng',;
 ',cd_sottocommessa From xCGSaldo_Eng') 

TEXT TO temp1 noshow 
Group By   Cd_CGConto
	Having Sum(Saldo) != 0
) Saldi On Saldi
ENDTEXT
TEXT TO temp2 noshow 
Group By   Cd_CGConto,cd_sottocommessa 
	Having Sum(Saldo) != 0
) Saldi On Saldi
ENDTEXT

Replace reportall.SqlCommand With StrTran(ReportAll.SqlCommand, temp1 , temp2) 

t=strtran(oForm.PF.PgGenerale.Txtxsottocommessa.WCGetWhere(),'saldi.','ac.')

SET STEP ON 
f1=oForm.PF.PgGenerale.Txtxcommessa.field.value

IF LEN(f1)>1
TEXT TO comme texmerge noshow
and saldi.cd_sottocommessa  in (
SELECT cd_sottocommessa   FROM 
 dosottocommessa where cd_docommessa='<<f1>>'
END TRANSACTION text 
ELSE
comme="and 1=1"

Replace reportall.SqlCommand With StrTran(ReportAll.SqlCommand, '<whereComm>', ;
comme) 

Replace reportall.SqlCommand With StrTran(ReportAll.SqlCommand, '<wheresottoc>', ;
'where 1=1 '+t) 
