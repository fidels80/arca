*!*	/*TEXT TO csql TEXTMERGE noshow
*!*	select TOP 10 cd_ar,descrizione,Qta,DataConsegna,Cd_DOSottoCommessa, noteriga from DORig

*!*	ENDTEXT
*!*	xsqlexec(csql,'ins_row')
*!*	Select * From  ins_row Into Cursor tmp_row Readwrite
*!*	Delete From tmp_row



*!*	Create Cursor tmp_riga ( ;
*!*		triade Varchar(200),;
*!*		matricola Varchar(200),;
*!*		cognome Varchar(200),;
*!*		nome Varchar(200),;
*!*		giorno Varchar(200),;
*!*		dalle Varchar(200),;
*!*		alle Varchar(200),;
*!*		durata Varchar(200),;
*!*		durcen Varchar(200),;
*!*		pres  Varchar(200) ,;
*!*		ecc Varchar(200),;
*!*		ClasseA Varchar(200),;
*!*		Classeb Varchar(200),;
*!*		Classec Varchar(200),;
*!*		desA Varchar(200),;
*!*		desB Varchar(200),;
*!*		desx Varchar(200))

*!*	If Messagebox("avvio importazione sei sicuro??",4+48,"IMPORTAZIONE",50000)=6

*!*		svfile= Getfile('csv','File di import','Apri',0)



*!*	*	lcFile = Filetostr(Getfile('txt','File Coin','Apri',0))
*!*	*!*	lcFileName = Sys(2015)+[.TXT]
*!*	*!*	*Strtofile(Substr(lcFile,At(CRLF, lcFile)+2),lcFileName)
*!*	*!*	Strtofile(Substr(lcFile,At(Chr(13)+Chr(10), lcFile)+2),lcFileName)
*!*	*!*	Select tmp_doc
*!*	*!*	Execscript("append from  "+svfile+"  DELIMITED WITH CHARACTER ' '")
*!*		Delete From tmp_riga
*!*		Select tmp_riga
*!*	*EXECSCRIPT("append from  "+svfile+" DELIMITED with ';' ")

*!*		Append From (svfile) Type Delimited ;
*!*			WITH Character ; With "

*!*		Set Step On


*!*	**INSERT INTO tmp_row ( cd_ar,descrizione,Qta,DataConsegna,Cd_DOSottoCommessa, noteriga)

*!*		Select tmp_riga
*!*		Scan
*!*			Select tmp_row
*!*			Append Blank
*!*			Replace tmp_row.cd_Ar With tmp_riga.matricola
*!*			Replace tmp_row.descrizione With tmp_riga.Nome+' '+tmp_riga.cognome
*!*			Replace tmp_row.noteriga With tmp_riga.Pres+' '+tmp_riga.ecc
*!*			Replace tmp_row.dataconsegna With Ctod(tmp_riga.giorno)
*!*			Replace tmp_row.qta With VAL(STRTRAN(tmp_riga.durata,':',''))/100
*!*			*Val(STRTRAN(tmp_riga.durata,":",","))
*!*			Replace tmp_row.Cd_DOSottoCommessa With tmp_riga.triade
*!*		Endscan

*!*		Delete From tmp_row Where cd_Ar Like '%matricola%'

*!*	*blocco articoli
*!*		TEXT TO csql TEXTMERGE noshow
*!*	alter table ar nocheck constraint all
*!*		ENDTEXT
*!*		xsqlexec(csql,'ar1')
*!*		Select Distinct cd_Ar, descrizione From tmp_row Into Cursor chk_ar Readwrite
*!*		Select chk_ar
*!*		Go Top
*!*		Scan
*!*			TEXT TO csql TEXTMERGE noshow
*!*	SELECT COUNT(*)as t FROM ar WHERE cd_ar=<<Format4Spt(chk_ar.cd_Ar)>>
*!*			ENDTEXT
*!*			xsqlexec(csql,'chkart')
*!*			If  chkart.T=0
*!*				TEXT TO csql TEXTMERGE noshow
*!*	INSERT INTO ar (cd_ar,descrizione,cd_aliquota_A,cd_aliquota_V,costostandard)
*!*	select <<Format4Spt(chk_ar.cd_Ar)>>,<<Format4Spt(chk_ar.descrizione)>>,'22','22',0

*!*				ENDTEXT
*!*				xsqlexec(csql,'insar1')
*!*			Endif


*!*		Endscan

*!*		TEXT TO csql TEXTMERGE noshow
*!*	alter table ar check constraint all
*!*		ENDTEXT
*!*		xsqlexec(csql,'ar1')

*!*	*fine blocco articoli

*!*	*blocco sottocommesse
*!*		Select Distinct Cd_DOSottoCommessa  From tmp_row Into Cursor chk_comme Readwrite
*!*		Select chk_comme
*!*		Go Top
*!*		Scan
*!*			TEXT TO csql TEXTMERGE noshow
*!*	SELECT COUNT(*) as t FROM DOSottoCommessa
*!*	where Cd_DOSottoCommessa=<<Format4Spt(chk_comme.Cd_DOSottoCommessa  )>>
*!*	and cd_docommessa=<<Format4Spt(LEFT(chk_comme.Cd_DOSottoCommessa,10)  )>>
*!*			ENDTEXT
*!*			xsqlexec(csql,'inscom')
*!*			If inscom.T=0

*!*				TEXT TO csql TEXTMERGE noshow
*!*	 SELECT COUNT(*)as t FROM docommessa WHERE
*!*	cd_docommessa=<<Format4Spt(LEFT(chk_comme.Cd_DOSottoCommessa,10)  )>>
*!*				ENDTEXT
*!*				xsqlexec(csql,'chkcomp')

*!*				If chkcomp.T=0
*!*					TEXT TO csql TEXTMERGE noshow
*!*	INSERT INTO docommessa (cd_docommessa,descrizione)
*!*	SELECT <<Format4Spt(LEFT(chk_comme.Cd_DOSottoCommessa,10)  )>>,<<Format4Spt(chk_comme.Cd_DOSottoCommessa  )>>
*!*					ENDTEXT
*!*					xsqlexec(csql,'inschkcomp')
*!*				Endif


*!*				TEXT TO csql TEXTMERGE noshow
*!*	insert into DOSottoCommessa (Cd_DOSottoCommessa,Cd_DOCommessa,Descrizione)
*!*	select <<Format4Spt(chk_comme.Cd_DOSottoCommessa)>>,
*!*	<<Format4Spt(LEFT(chk_comme.Cd_DOSottoCommessa,10))>>,
*!*	<<Format4Spt(chk_comme.Cd_DOSottoCommessa)>>
*!*				ENDTEXT
*!*				xsqlexec(csql,'inscom1')
*!*			Endif

*!*		Endscan
*!*	*fine blocco sottocommesse

*!*	SELECT 1 as id_dotes,'mn' as cd_armisura,tmp_row.* FROM tmp_row  INTO CURSOR tmp_row2 readwrite



*!*	cddo = INPUTBOX("inserisci codice documento da creare","codice documento",'OAF')
*!*	cdcf=  INPUTBOX("inserisci codice cliente per il documento","codice Cliente",'F000001')

*!*	CREATE CURSOR dotest (;
*!*	Cd_Do varchar(5),Cd_CF varchar(8),Id_DoTes  int,Id_Dotes_New int)

*!*	SELECT dotest
*!*	APPEND BLANK
*!*	replace dotest.cd_do WITH cddo
*!*	replace dotest.cd_cf WITH cdcf
*!*	replace dotest.id_dotes WITH 1



*!*	If CreateDocument('DoTesT', 'tmp_row2' ) <> 1

*!*	xMessageBox("Errore nella creazione del documento")

*!*	Else

*!*	   Text To cSqlStmt Noshow Textmerge Pretext 7

*!*	     Select NumeroDoc 

*!*	     from   DoTes 

*!*	     Where  Id_DoTes = <<Format4Spt(DoTesT.Id_Dotes_New)>>

*!*	   endtext

*!*	   cNewDoc = xSqlExec2Var(cSqlStmt)

*!*	   xMessageBox(Textmerge("Creato documento : OAF  <<cNewDoc>>"))
*!*	   
*!*	   
*!*	   xwhere=' dotes.Id_Dotes  in ('
*!*				 
*!*					xwhere=xwhere+Str(DoTesT.Id_Dotes_New)+","
*!*			 
*!*				xwhere=xwhere+"0)"
*!*				 
*!*					RunFediWS('Fedi_Doc_CP',,xwhere,)
*!*			 
*!*	   

*!*	Endif







*!*	Endif

*!*	*/

TEXT TO csql TEXTMERGE noshow
select TOP 10 cd_ar,descrizione,Qta,DataConsegna,Cd_DOSottoCommessa, noteriga from DORig
ENDTEXT

xsqlexec(csql,'ins_row')
Select * From  ins_row Into Cursor tmp_row Readwrite

Delete From tmp_row

Create Cursor tmp_riga ( ;
	triade Varchar(200),;
	matricola Varchar(200),;
	cognome Varchar(200),;
	nome Varchar(200),;
	giorno Varchar(200),;
	dalle Varchar(200),;
	alle Varchar(200),;
	durata Varchar(200),;
	durcen Varchar(200),;
	pres  Varchar(200) ,;
	ecc Varchar(200),;
	ClasseA Varchar(200),;
	Classeb Varchar(200),;
	Classec Varchar(200),;
	desA Varchar(200),;
	desB Varchar(200),;
	desx Varchar(200))

If Messagebox("avvio importazione sei sicuro??",4+48,"IMPORTAZIONE",50000)=6
	svfile= Getfile('csv','File di import','Apri',0)
	Delete From tmp_riga
	Select tmp_riga
	Append From (svfile) Type Delimited ;
		WITH Character ; With "
	Set Step On
	Select tmp_riga
	Scan
		Select tmp_row
		Append Blank
		Replace tmp_row.cd_Ar With tmp_riga.matricola
		Replace tmp_row.descrizione With tmp_riga.Nome+' '+tmp_riga.cognome
		Replace tmp_row.noteriga With tmp_riga.Pres+' '+tmp_riga.ecc
		Replace tmp_row.dataconsegna With Ctod(tmp_riga.giorno)
		Replace tmp_row.qta With Val(Strtran(tmp_riga.durcen ,',',''))/100
		*/100
		*Val(STRTRAN(tmp_riga.durata,":",","))
		Replace tmp_row.Cd_DOSottoCommessa With  tmp_riga.Classeb
	Endscan
	Delete From tmp_row Where cd_Ar Like '%matricola%'
	*blocco articoli
	TEXT TO csql TEXTMERGE noshow
			alter table ar nocheck constraint all
	ENDTEXT
	xsqlexec(csql,'ar1')
	Select Distinct cd_Ar, descrizione From tmp_row Into Cursor chk_ar Readwrite
	Select chk_ar
	Go Top
	Scan
		TEXT TO csql TEXTMERGE noshow
				SELECT COUNT(*)as t FROM ar WHERE cd_ar=<<Format4Spt(chk_ar.cd_Ar)>>
		ENDTEXT
		xsqlexec(csql,'chkart')
		If  chkart.T=0
			TEXT TO csql TEXTMERGE noshow
								INSERT INTO ar (cd_ar,descrizione,cd_aliquota_A,cd_aliquota_V,costostandard)
								select <<Format4Spt(chk_ar.cd_Ar)>>,<<Format4Spt(chk_ar.descrizione)>>,'22','22',0
			ENDTEXT
			xsqlexec(csql,'insar1')
		Endif
	Endscan
	TEXT TO csql TEXTMERGE noshow
			alter table ar check constraint all
	ENDTEXT
	xsqlexec(csql,'ar1')
	*fine blocco articoli
	*blocco sottocommesse
*!*		Select Distinct Cd_DOSottoCommessa  From tmp_row Into Cursor chk_comme Readwrite
*!*		Select chk_comme
*!*		Go Top
*!*		SCAN
*!*		
*!*		xCd_DOSottoCommessa=LTRIM(RTRIM(STRTRAN(STRTRAN(chk_comme.Cd_DOSottoCommessa,;
*!*		(LEFT(chk_comme.Cd_DOSottoCommessa,at('.', chk_comme.Cd_DOSottoCommessa)-1)),''),'.','')))
*!*		
*!*		xcd_docommessa=NVL(LTRIM(RTRIM(LEFT(chk_comme.Cd_DOSottoCommessa,at('.', chk_comme.Cd_DOSottoCommessa)-1))),xCd_DOSottoCommessa)
*!*		
*!*		
*!*			TEXT TO csql TEXTMERGE noshow
*!*					SELECT COUNT(*) as t FROM DOSottoCommessa
*!*					where Cd_DOSottoCommessa=<<Format4Spt(xCd_DOSottoCommessa)>>
*!*					/*and cd_docommessa=<<Format4Spt(LEFT(chk_comme.Cd_DOSottoCommessa,10)  )>>*/
*!*					and cd_docommessa=<<Format4Spt(xcd_docommessa)>>
*!*			ENDTEXT
*!*			xsqlexec(csql,'inscom')
*!*			If inscom.T=0

*!*				TEXT TO csql TEXTMERGE noshow
*!*					 SELECT COUNT(*)as t FROM docommessa WHERE
*!*					cd_docommessa=<< Format4Spt(xcd_docommessa)>>
*!*				ENDTEXT
*!*				xsqlexec(csql,'chkcomp')

*!*				If chkcomp.T=0
*!*					TEXT TO csql TEXTMERGE noshow
*!*						INSERT INTO docommessa (cd_docommessa,descrizione)
*!*						SELECT << Format4Spt(xcd_docommessa)>>,
*!*						<< Format4Spt(xcd_docommessa)>>
*!*					ENDTEXT
*!*					xsqlexec(csql,'inschkcomp')
*!*				Endif


*!*		TEXT TO csql TEXTMERGE noshow
*!*					 SELECT COUNT(*)as t FROM DOSottoCommessa WHERE
*!*					cd_docommessa=<< Format4Spt(xcd_docommessa)>> and Cd_DOSottoCommessa=<<Format4Spt(xCd_DOSottoCommessa)>>
*!*				ENDTEXT
*!*				xsqlexec(csql,'chkcompss')

*!*			IF chkcompss.t=0 
*!*				TEXT TO csql TEXTMERGE noshow
*!*							insert into DOSottoCommessa (Cd_DOSottoCommessa,Cd_DOCommessa,Descrizione)
*!*							select <<Format4Spt(xCd_DOSottoCommessa)>>,
*!*							<< Format4Spt(xcd_docommessa)>>,
*!*							<<Format4Spt(xCd_DOSottoCommessa)>>
*!*				ENDTEXT
*!*				xsqlexec(csql,'inscom1')
*!*			ENDIF
*!*			
*!*			
*!*			
*!*			Endif

*!*		Endscan
*!*		*fine blocco sottocommesse


	Select 1 As id_dotes,'mn' As cd_armisura,tmp_row.* From tmp_row  Into Cursor tmp_row2 Readwrite



	cddo = Inputbox('inserisci codice documento da creare','codice documento','OAF')
	cdcf=  Inputbox('inserisci codice cliente per il documento','codice Cliente','F000001')

tmpdatay=LTRIM(RTRIM(str(YEAR(DATE()))))
tmpdatam=LTRIM(RTRIM(str(month(DATE()))))

datad=Inputbox('inserisci la data per il documento ','data documento','01/'+tmpdatam+'/'+tmpdatay)

	Create Cursor dotest (;
		Cd_Do Varchar(5),Cd_CF Varchar(8),id_dotes  Int,Id_Dotes_New Int,datadoc date)


	Select dotest
	Append Blank
	Replace dotest.Cd_Do With cddo
	Replace dotest.Cd_CF With cdcf
	Replace dotest.id_dotes With 1
	replace dotest.datadoc WITH  CTOD(datad)
	
	
	
	
	SELECT tmp_row2
	GO TOP 
	SCAN
	TEXT TO csql TEXTMERGE noshow
	SELECT COUNT(*)as t FROM dorig WHERE cd_ar=<<Format4Spt(tmp_row2.cd_Ar)>> and
	Cd_DOSottoCommessa=<<Format4Spt(tmp_row2.Cd_DOSottoCommessa )>>
	and  dataconsegna=<<Format4Spt(tmp_row.dataconsegna)>>
	and noteriga =<<Format4Spt(tmp_row.noteriga)>>
		and qta =<<Format4Spt(tmp_row.qta)>>
		and cd_do=<<Format4Spt(cddo)>>
	 
	ENDTEXT
	
	tmpchk=xSqlExec2Var(csql)
	IF tmpchk<>0
	
	TEXT TO tmsg TEXTMERGE noshow
	attenzione riga possibilmente già inserita dettagli
	Codice Articolo  : <<Format4Spt(tmp_row2.cd_Ar)>>  
	Descrizione:<<Format4Spt(tmp_row2.descrizione)>>  
	DOSottoCommessa : <<Format4Spt(tmp_row2.Cd_DOSottoCommessa )>>
	Dataconsegna:<<Format4Spt(tmp_row2.dataconsegna)>>
	Noteriga :<<Format4Spt(tmp_row2.noteriga)>>
	Qta :<<Format4Spt(tmp_row2.qta)>>
endtext	
	
	MESSAGEBOX(tmsg,0,"Possibile duplicato")
	
	
	endif
	
	endscan
	
SELECT tmp_row2
GO top


	If CreateDocument('DoTesT', 'tmp_row2' ) <> 1

		xMessageBox('Errore nella creazione del documento')

	Else

		TEXT To cSqlStmt Noshow Textmerge Pretext 7

     Select NumeroDoc

     from   DoTes

     Where  Id_DoTes = <<Format4Spt(DoTesT.Id_Dotes_New)>>

		ENDTEXT

		cNewDoc = xSqlExec2Var(cSqlStmt)

		xMessageBox(Textmerge('Creato documento : '+cddo+' <<cNewDoc>>'))

		xwhere=' dotes.Id_Dotes  in ('

		xwhere=xwhere+Str(dotest.Id_Dotes_New)+','

		xwhere=xwhere+'0)'

		RunFediWS('Fedi_Doc_CP',,xwhere,)

	Endif

Endif

