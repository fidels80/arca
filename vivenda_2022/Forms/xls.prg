loExcel = CREATEOBJECT("Excel.Application") && Create the Excel object
*loexcel.workbooks.open("yourSheet.xls")
percorso=SYS(2003)+"\pers\"+STRTRAN(oapp.osqlconn.ditta,'ADB_','')+ "\exp01.xlsx"
*percorso=oapp.HomeDir+"\pers\+STRTRAN(oapp.osqlconn.ditta,'ADB_','')+ "exp01.xlsx"
*img"+Ltrim(Rtrim(Str(dorigall.id_dotes)))+"\")
*oapp.homedir+
 loWorkBook = loExcel.Workbooks.open(percorso)&& add a new workbook
 loWorkSheet = loWorkBook.Sheets(1) && select first sheet
  loExcel.Visible = .T.
  WAIT windows "pulizia file template iniziata" nowait
  SET STEP ON
 FOR i=6 TO 306
  WAIT windows "pulizia file template riga " +STR(i) nowait
 r="A"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
IF LTRIM(RTRIM(lorange.value))<>""
loRange.value=""

 r="B"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""

 r="C"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
 r="D"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
 r="E"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
 r="F"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
 r="G"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
 r="H"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
 r="I"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""

 r="j"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
 r="k"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""

 r="L"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
 r="M"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
 r="N"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
 r="O"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
 r="P"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
r="q"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
r="r"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
r="s"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
r="t"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
r="u"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
r="v"+ltrim(RTRIM(str(I)))
loRange = loWorkSheet.Range(R)
loRange.value=""
*i=i+1
ENDIF

ENDFOR
WAIT windows "pulizia file template terminata" nowait
 *loRange = loWorkSheet.Range("A1") && select cell A1
 *loRange.value = "Hello World" && assign a value to A1
 *loRange = loWorkSheet.Range("B1") && select cell B1
 *loRange.value = 1234567890 && assign a value to B1
 && display Excel