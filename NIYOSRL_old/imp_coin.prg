#Define CRLF Chr(13)+Chr(10)
Set Step On

Create Cursor tmp_doc (;
	NumEnte Varchar(200),;
	DEsEnte Varchar(200),;
	NumReparto Varchar(200),;
	DesReparto Varchar(200),;
	Giorno Varchar(200),;
	Codartfor Varchar(200),;
	Barcode Varchar(200),;
	DEcodifica Varchar(200),;
	qta Varchar(200),;
	vallordo Varchar(200),;
	Valsconto Varchar(200))
lcFile = Filetostr(Getfile('txt','File Coin','Apri',0))
lcFileName = Sys(2015)+[.TXT]
Strtofile(Substr(lcFile,At(CRLF, lcFile)+2),lcFileName)

Select tmp_doc
Append From (lcFileName) Delimited With Tab
Delete From tmp_doc Where NumEnte  Like '%Num%'


TEXT TO csql TEXTMERGE noshow
SELECT * FROM dotes WHERE 1=2
ENDTEXT
xsqlexec(csql,'x_dotes')
TEXT TO csql TEXTMERGE noshow
SELECT * FROM dorig WHERE 1=2
ENDTEXT
xsqlexec(csql,'x_dorig')
TEXT TO csql TEXTMERGE noshow

select ar.Cd_AR,alias,ar.Descrizione,ar.Cd_Aliquota_V,ar.Cd_CGConto_Ve,ararmisura.Cd_ARMisura,ls.Prezzo
 from ARAlias
left join AR on ar.Cd_AR=aralias.Cd_AR
left join ARARMisura on ARARMisura.Cd_AR=ar.Cd_AR
left join (select * from LSArticolo where Id_LSRevisione=3) as ls on ls.Cd_AR=ar.Cd_AR
where Alias not like 'N%'

ENDTEXT
xsqlexec(csql,'x_alias')




Select NumEnte From tmp_doc Group By NumEnte Into Cursor x_sedi Readwrite
i=1
Select x_sedi
Scan
	TEXT TO csql TEXTMERGE noshow
SELECT * FROM cfdest WHERE cd_cf='C000016' AND LTRIM(RTRIM(x_coin))=LTRIM(RTRIM(<<Format4Spt(x_sedi.numente)>>))
	ENDTEXT
	xsqlexec(csql,'x_sedecf')
	Select x_dotes
	Append Blank
	Replace id_dotes With i
	Replace cd_do With 'FTA'
	Replace cd_cf With 'C000016'
	Replace datadoc With  Dtoc(Date())
	Replace cd_cfdest With Ltrim(Rtrim(x_sedecf.cd_cfdest))

	Select * From tmp_doc Where NumEnte=x_sedi.NumEnte Into Cursor tmp_rows Readwrite
	Select tmp_rows
	Scan
		Select * From aralias Where Ltrim(Rtrim(Alias))=Ltrim(Rtrim(tmp_rows.Barcode)) Into Cursor tmp_ar Readwrite
		Select x_dorig
		Append Blank
		Replace id_dotes With i
		Replace cd_do With 'FTA'
		Replace cd_cf With 'C000016'
		Replace datadoc With  Dtoc(Date())
		Replace cd_ar With tmp_ar.cd_ar
		Replace cd_armisura With 'pz'
		Replace descrizione With tmp_ar.descrizione
		Replace cd_armisura With tmp_ar.cd_armisura
		Replace cd_aliquota With tmp_ar.cd_aliquotav
		Replace cd_cgconto With tmp_ar.cd_cgconto_ve
		Replace qta With tmp_rows.qta
		Replace noteriga With " Dati vendita Reparto:" +Ltrim(Rtrim(NumReparto))+" " +Ltrim(Rtrim(DesReparto))+" il " +Ltrim(Rtrim(Giorno))+ " BC: " + Ltrim(Rtrim(Barcode))
		Replace  prezzounitariov With tmp_ar.prezzo

		Select tmp_rows




	Endscan
	
If EvadiDocument('x_dotes' ,'x_dorig' ) <> 1
   xMessageBox("Errore in evasione del documento")
Else
   Text To cSqlStmt Noshow Textmerge Pretext 7
      Select NumeroDoc 
      from   DoTes 
      Where  Id_Dotes= <<Format4Spt(tmp_head.Id_Dotes)>>
   endtext
   cNewDoc = xSqlExec2Var(cSqlStmt)
   xMessageBox(Textmerge("Creato  il  documento : <<Format4Spt(tmp_head.cd_do)>> <<cNewDoc>>"))

ENDIF
DELETE FROM x_dotes
DELETE FROM x_dorig

	i=i+1


Select x_sedi


Endscan





