*--------------------------------------------------------------------------------------
* Example2.prg
*--------------------------------------------------------------------------------------
* FoxBarcodeQR example report
*--------------------------------------------------------------------------------------
SET STEP ON 
SET PROCEDURE TO LOCFILE(oapp.homedir+"\PERS\magdemo\Progs\FoxBarcodeQR.prg") ADDITIVE
TEXT TO csql TEXTMERGE noshow
SELECT TOP 1 contaqr FROM x_qr  ORDER BY contaqr desc

ENDTEXT
xsqlexec(csql,'topper')

IF RECCOUNT('topper')=0
storico=1
ELSE
storico=topper.contaqr 
endif
*--- Create FoxBarcodeQR private object
PRIVATE poFbc
m.poFbc = CREATEOBJECT("FoxBarcodeQR")
numero=INPUTBOX("Quanti qr devo creare?","Numero ","1000",5000)
CREATE CURSOR TempQR (TempQR char(15))
SELECT tempqr
FOR i=storico TO storico +VAL(numero)
INSERT INTO TempQR VALUES (PADL(ALLTRIM(STR(i)),9,'0'))

next
*INSERT INTO TempQR VALUES (0)

REPORT FORM FoxBarcodeQR  preview
USE IN TempQR

m.poFbc = NULL
TEXT TO csql TEXTMERGE noshow
INSERT INTO x_qr contaqr values(<<Format4Spt(storico +VAL(numero))>>) 
ENDTEXT
xsqlexec(csql,'ins_topper')