
********************************************
**     ArcaSQL Extension Class Template   **
** (c) 2000-2004 Artel Software House     **
********************************************

Define Class DittaExt As Session

	Name 		  = 'DittaExt'

	** La classe è di tipo session (quindi lavorerà su un datasession privato)
	** Arca istanzierà un oggetto di questa classe (uno solo) e lo terrà attivo
	** per tutta la sessione di lavoro nel contesto di una ditta: eventuali property di 
	**	classe manterranno il loro valore tra le varie chiamate ed anche eventuali tavole
	** aperte rimarrano aperte ed utilizzabili tra le varie invocazioni dei metodi.
	** N.B.: L'oggetto viene rialasciato al cambio ditta ed eventuali tabelle aperte
	**			saranno chiuse automaticamente avendo l'oggetto un datasession privato.
	
	** Molti dei metodi implementatbili con questa estensione sono presenti anche in
	**	ArcaExt: si consiglia l'utilizzo dei metodi di questo oggetto piuttosto che di
	**	quelli di ArcaExt tenendo in tal modo legato ad una ditta ben precisa l'estensione.
	
	Function OnLogin()

		** Viene chiamata dopo il login.
		** L'oggetto oMain non è ancora stato creato mentre l'oggetto oApp è già inizializzato.
		** N.B.: Se la funzione torna .F. il programma verrà terminato.

		** Se servono informazioni relative alla ditta, al server Sql, alla login etc si tenga
		** presente che sono tutte a disposizione o ricavabili anche in questa fase; si veda il
		** commento del metodo OnMenuInit()

		**	DebugOut 'OnLogin() called!'
		**	DebugOut Space(3) + 'Win UserName: ' 	+ xGetUserName()
		**	DebugOut Space(3) + 'Computer Name: ' 	+ xGetComputerName()
		
		Return .T.		&& Continue execution

	EndFunc

	Procedure OnMenuInit(oTV As MSComctlLib.TreeView)

		** Viene chiamata dopo il login ed ad ogni cambio ditta / reinizializzazione del treeview
		**	menu (ad esempio quando viene installata una personalizzazione) per permettere modifiche
		**	dinamiche del menu (per modifiche 'statiche' utilizzare il menu designer).
		** Riceve come parametro l'oggetto TreeView che implementa il menu.
		** Per quando concerne i metodi e le funzionalità esposte da questo oggetto, si rimanda
		** alla documentazione del TreeView control - Controllo standard di Window
		**	Se si possiede MSDN Library, l'help relativo si trova all'indirizzo 
		**		mk:@MSITStore:\\MYSERVER\DVD\MSDN\cmctl198.chm::/html/vbobjtreeview.htm
		**	Ovviamente il path \\MYSERVER\DVD\ andrà sistemato opportunamente...
		**
		** Ogni nodo del treeview (standard o personalizzato che sia) è identificato da un GUID univoco; 
		**	utilizzare il menu designer per conoscere il GUID di un dato nodo del tree.
		** Tips: il campo "Node Key" del menu designer è selezionabile anche se non modificabile: in questo
		**		   modo il GUID può essere copiato in clipboard con Ctrl+C
		
		** Esempio di rimozione del nodo anagrafiche: 	
		** oTV.RemoveNode('FCD27329-8E97-4615-ABB1-93593519E9CC')
		
		** oApp.Ditta e oApp.Server riportano il nome dell'utente di Windows e del Server Sql
		**	Se servono ulteriori informazioni circa l'utente di DB, si può eseguire la query
		**	xSqlExec('Select User_Name() AS [User_Name], SUser_SName() AS [Suser_SName], u.IsLogin, u.IsNtName, u.IsNtGroup, u.IsNtUser, u.IsSqlUser From SysUsers u Where u.uid = user_id()', 'UserInfo')
		
		**	xSqlExec('Select User_Name() AS [User_Name], SUser_SName() AS [Suser_SName], u.IsLogin, u.IsNtName, u.IsNtGroup, u.IsNtUser, u.IsSqlUser From SysUsers u Where u.uid = user_id()', 'UserInfo')

		**	DebugOut 'OnMenuInit() called!'

		**	DebugOut Space(3) + 'Ditta: ' 			+ oApp.Ditta
		**	DebugOut Space(3) + 'Server: ' 			+ oApp.Server

		**	DebugOut Space(3) + 'User_Name: ' 		+ 				 UserInfo.User_Name
		**	DebugOut Space(3) + 'SUser_AName: ' 	+ 			  	 UserInfo.SUser_SName
		**	DebugOut Space(3) + 'IsLogin: ' 			+        IIf(UserInfo.IsLogin   = 1, 'Si', 'No')
		**	DebugOut Space(3) + 'IsNtName: ' 		+        IIf(UserInfo.IsNtName  = 1, 'Si', 'No')
		**	DebugOut Space(3) + 'IsNtGroup: ' 		+        IIf(UserInfo.IsNtGroup = 1, 'Si', 'No')
		**	DebugOut Space(3) + 'IsNtUser: ' 		+        IIf(UserInfo.IsNtUser  = 1, 'Si', 'No')
		**	DebugOut Space(3) + 'IsSqlUser: ' 		+        IIf(UserInfo.IsSqlUser = 1, 'Si', 'No')		

	EndProc
	
	Function OnMenuNodeClick(oNode As MSComctlLib.Node)
	
		Return .T.
	
	EndFunc

	Function OnFormRun(oForm As Form)
		
		** Viene chiamata ogni volta che viene istanzianta una form
		** Normalmente in questa fase l'oggetto oForm non è ancora visibile, 
		**	ma in taluni casi questo potrebbe non essere vero; non è garantito: 
		**	testare se servisse la property .Visible.
		** La funzione può tornare .F. nel qual caso la form verrà distrutta.

		**	DebugOut 'OnFormRun() called!'
		**	DebugOut Space(3) + 'Name: '				+ oForm.Name
		**	DebugOut Space(3) + 'Caption: '			+ oForm.Caption
		**	DebugOut Space(3) + 'ClassLibrary: '	+ oForm.ClassLibrary

		**	If PemStatus(oForm, 'OriginalCaption', 5)
		**		oForm.OriginalCaption = 'Tony Solver© - ' + oForm.Caption
		**	Else
		**		oForm.Caption         = 'Tony Solver© - ' + oForm.Caption
		**	Endif

		Return .T.		&& Continue execution
	
	EndFunc

	Function OnDEInit(oForm As Form)
		** Viene chiamata dall'init del DE

		**If Upper(JustFname(oForm.ClassLibrary)) = 'FEDI_ARTICOLO'
		**	oForm.DE.AR.Stmt = Strtran(oForm.DE.AR.Stmt, '/*CIP*/', ",xProva=1")                    
		**EndIf 
	EndFunc 

	Function OnElencoGridInit(oForm, oGrid)  
		** Viene chiamata dall'init della griglia delle pagina ELENCO

		**Local oCol
		**If Upper(JustFname(oForm.ClassLibrary))== 'FEDI_DO')                 
		**	oCol = oGrid.NewColumn('ColxTipoDoc', 'DO.xTipoDoc', 'Doc. Pers.', 40)
		**	oCol.Backcolor = oApp.Color.Aliceblue
		**	oCol.Forecolor = oApp.Color.Maroon
		**Endif
	EndFunc

	Function OnPgFrameInit(oForm, oPgFrame)  
		** Viene chiamata dall'init del PF delle std_fediform

		**Local oNewPage
		**If Upper(JustFname(oForm.ClassLibrary)) == 'FEDI_DO') 
		**	oNewPage = oPgFrame.NewPage('xPgPers', Pag. Pers.')
		**	oPgFrame.xPgPers.Enabled = .T.
		**	MNewObject0(oPgFrame. xPgPers, 'cnt', 'xpg', Addbs(oApp.HomeDir)+'Libs\stdctrl.vcx', '')      
		**EndIf
	EndFunc

	** -------------------------------------------------------------------------------------------------------

	Function OnDOPrel_CreateNewDoTes(nFrom, cStmt)
	
		** nFrom				1 DOPUSH - 2 DOPRELIEVO - 3 DOPRELIEVOCREAZIONE - 4 PRELIEVOCONTROLLATO
		** cStmt	BYREF		Stmt usato per creare il record DoTes del nuovo documento che si sta emmettendo
		**						n.b.: solo per il DOPUSH (1) non sono presenti tutti i campi standard e personalizzati di DoTes.
		
		** Modificare cStmt per cambiare la struttura della WA DoTes.
		
		* If nFrom = 1	&& DOPUSH
		* 	cStmt = Strtran(cStmt, '/*CIP*/', ',Attributi, ExtraInfo /*CIP*/')
		* EndIf 
		
	EndFunc 
	

	Function OnDOPrel_PopulateNewDoTes(nFrom, oForm, oDoTes, oDoTes_Evadibili)
	
		** nFrom				1 DOPUSH - 2 DOPRELIEVO - 3 DOPRELIEVOCREAZIONE - 4 PRELIEVOCONTROLLATO
		** oForm				è la form di prelievo
		** oDoTes				Rappresenta il record DoTes del nuovo documento che si sta emettendo
		** oDoTes_Evadibili		Collection del Id_DOTes dei documenti che saranno evasi
		
		** Modificare le property di oDoTes per valorizzare il record di DoTes come desiderato.

		Set Datasession To (oForm.DataSessionID)		
			
	 	* Local i  
	 	* For i = 1 To oDoTes_Evadibili.Count 	 	
	 	* 	? oDoTes_Evadibili(i)
	 	* Next 
	 
		** Voglio valorizzare Attributi e Extra Info con i valori presenti nel primo documento evadibile:
	 	* If  !PemStatus(oDoTes, 'ExtraInfo', 5)
	 	* 	AddProperty(oDoTes, 'ExtraInfo', null)
	 	* EndIf 
	 	* If  !PemStatus(oDoTes, 'Attributi', 5)
	 	* 	AddProperty(oDoTes, 'Attributi', null)
	 	* EndIf 

		* Local oRec
	 	* oRec = xSqlExec2Obj('Select Attributi, ExtraInfo From DoTes Where Id_DOTes = ' + FormatI4Spt(oDoTes_Evadibili(1)))

		* oDoTes.ExtraInfo = oRec.ExtraInfo
		* oDoTes.Attributi = oRec.Attributi
	 	
	EndFunc 

	** -------------------------------------------------------------------------------------------------------

	Procedure OnSelectFTE_XML(oForm, nId_DoTes, oAlias)

		Set Datasession To (oForm.DataSessionID)
		MESSAGEBOX(oForm.DataSessionID)
		SET STEP ON 
		** Viene chiamata prima della creazione di un xml della fatturazione elettronica
		** Il primo parametro è la form di creazione dell'xml; il secondo indica l'id del documento interessato; il terzo parametro è un oggetto che elenca le WA disponibili (vedere property .Alias_**** )
		** Bisogna modificare i valori della WA.
	
Return .T. && Continue execution

	EndProc

	Function OnCreateFTE_XML(nId_DoTes, cXml)
		MESSAGEBOX(cXml)
		SET STEP ON
		STRTOFILE(cxml,"c:\test\fte.xml")
		** Viene chiamata ogni volta che viene creato un xml della fatturazione elettronica
		** Il primo parametro indica l'id del documento interessato; il secondo parametro è il testo Xml
		** Bisogna ritornare il testo Xml modificato.
oXML = CREATEOBJECT('MSXML2.DomDocument')

oXML.ASYNC = .F.

  * Load the document into the object, if this was a stream instead
  * of a file name, we would use loadXML(cCharStream)
  oXML.loadXML(cXml)
oRootNode = oXML.documentElement

  * What is the root tag name?
  cRootTagName = oRootNode.tagName

  * Get all the nodes in the document with the special '*'
  * parameter, we could just pass in a tag name to get the
  * node list for that specific tag
  oNodeList = oRootNode.getElementsByTagName("*")

  * How many nodes did we retrieve
  nNumNodes = oNodeList.LENGTH

  * Go through all the nodes in the NodeList.
  * Note that Attribute and Character/Text Data is NOT
  * counted as part of this list, you must get that data
  * separately, this list only contains tag elements
  * Note that this uses C like array positioning by
  * starting at zero
  FOR nPos = 0 TO (nNumNodes-1) STEP 1
    * Get the next node in the list
    oNode = oNodeList.ITEM(nPos)

    * What is the value of this node, if it is an element
    * then this value is the tag name
    cParentName = oNode.nodeName

    * Does this node have any children?
    bHasChild = oNode.hasChildNodes()

    * What is the node type, element or text?
    nType = oNode.nodeType

    IF nType = 1
      * This is an element/tag so it may have
      * attributes.  We can get those attributes
      * by name or in a list.
      * Since this example function traverses thru
      * the xml tree, it would not be very efficient
      * to query every single node for a particular
      * attribute, this is just to show how it could
      * be done.

      * if the attribute does not exist, returns .NULL.
      * otherwise we get the attribute value
      cAttrValue = oNode.getAttribute("my_attribute")

      * We could also get a NamedNodeMap accessing 
      * the attributes property
      oAttributeList = oNode.attributes

      * how many attributes do we have
      nNumAttr = oAttributeList.length

      * Get the attribute using the list
      cAttrValue = oAttributeList.getNamedItem("my_attribute")
    ENDIF

    IF bHasChild
      * Ok, we know we have children but what type are they?
      * Just test the first one to see if it is something
      * other than an element and if so, get it
      IF oNode.firstChild.nodeType != 1
        * We know we have something other than an element, get
        * the tag name of the element we are parsing
        cTagName = oNode.tagName

        * Get the node list and determine how man child
        * nodes this element has
        oChildNodeList = oNode.childNodes
        nChildLen = oChildNodeList.LENGTH

        * Go through all child nodes and grab the non-element
        * data to do with what you like
        FOR nPass = 0 TO (nChildLen-1) STEP 1
          oChildNode = oChildNodeList.ITEM(nPass)
          cValue = oChildNode.nodeValue
          cName = oChildNode.nodeName
          nType = oChildNode.nodeType
          bHasChild = oChildNode.hasChildNodes()

          * For now just look for text types, other
          * types can be added later if needed
          DO CASE
            CASE nType = 3
              * Text node
              cTextData = oChildNode.DATA
              nTextDataLen = oChildNode.LENGTH
            CASE nType = 4
              * CData Section node
              cTextData = oChildNode.DATA
              nTextDataLen = oChildNode.LENGTH
            OTHERWISE
              * Some other node we don't care about
              * right now
          ENDCASE
        ENDFOR
      ENDIF
    ENDIF
  ENDFOR

  

		Return cXml

	EndFunc

	Function OnCreateDDT_XML(nId_DoTes, cXml)
		
		** Viene chiamata ogni volta che viene creato un xml dei DDT elettronici (DESPATCH_ADVICE PEPPOL)
		** Il primo parametro indica l'id del documento interessato; il secondo parametro è il testo Xml
		** Bisogna ritornare il testo Xml modificato.

		Return cXml

	EndFunc

	** -------------------------------------------------------------------------------------------------------

	Function OnCompileMail(cTo, cCC, cBCC, cSubject, cBody, aAttachment, aAttachments, oCallerForm, oCallerObj)  
		** Viene chiamata prima della compilazione della mail
		**
		**		cTo			BYREF	(lista di indirizzi mail separti da ";")
		**		cCc			BYREF	(lista di indirizzi mail separti da ";")
		**		cBcc		BYREF	(lista di indirizzi mail separti da ";")
		**		cSubject	BYREF
		**		cBody		BYREF	(testo)
		**		aAttachment	BYREF	(array)
		**
		** L'oggetto oCallerForm è la form dalla quale è stata inviata la mail
		**
		** L'oggetto oCallerObj  è l'oggetto che ha inviato la mail 
		** (in caso di RepoForm o stampa Documenti, questo parametro non viene passato)
		**
	EndFunc

	Function OnSendMail(oMailInfo, oCallerForm, oCallerObj)  
		** Viene chiamata prima dell'invio della mail
		**
		** L'oggetto oMailInfo contiente le seguenti property:
		** 		.From
		**		.To				(lista di indirizzi mail separti da ";")
		**		.Cc				(lista di indirizzi mail separti da ";")
		**		.Ccn			(lista di indirizzi mail separti da ";")
		**		.Subject
		**		.Body			(testo html)
		**		.oAttachment	(Collection); per aggiungere un nuovo item eseguire: 
		**									  oMailInfo.oAttachment.Add(cFileName, JustFname(cFileName))
		**
		** L'oggetto oCallerForm è la form dalla quale è stata inviata la mail
		**
		** L'oggetto oCallerObj  è l'oggetto che ha inviato la mail 
		** (in caso di RepoForm o stampa Documenti, questo parametro non viene passato)
		**
	EndFunc

	** -------------------------------------------------------------------------------------------------------

	Function OnInsertGPIstanzaAttivita(nId_GPIstanzaAttivita, nId_GPIstanzaAttivita_Parent)  
		** Viene chiamata dalla creazione Processi e dal Push
		**
		** 	nId_GPIstanzaAttivita			Id dell'attività appena creata
		**	nId_GPIstanzaAttivita_Parent	Id del parent dell'attività appena creata
		**
	EndFunc

	** -------------------------------------------------------------------------------------------------------

	Function WebTicketing_Query()		
		** Viene chiamata per poter visualizzare i bottoni per l'invio di Web Ticketing
		** nella toolbar delle form e nei messaggi di errore

		Return .F.		&& .T. per mostrare i bottoni del WebTicketing
	EndFunc

	Function WebTicketing(oTicketInfo)
		** Chiamata per gestire i WebTicket.
		**
		** Riceve l'oggetto oTicketInfo con le seguenti property:
		**		Subject					: oggetto del ticket
		**		ApplicationData			: informazioni aggiuntive
		**		ProductCode				: nome prodotto
		**		Description				: descrizione ticket (vuoto di default)
		**		FileName_AboutCapture1	: percorso del file con l'immagine della form About, posizionata nella prima page
		**		FileName_AboutCapture2	: percorso del file con l'immagine della form About, posizionata nella seconda page
		**		FileName_ScreenCapture	: percorso del file con l'immagine dello schermo
		
		** A questo punto è possibile inviare una mail ad un proprio indirizzo oppure collegarsi ad un proprio web-service 
		** per inviare le informazioni.
		    		    
	EndFunc

	** -------------------------------------------------------------------------------------------------------

	Function FlussiFin_GetMasterWorkBook()
		** Chiamata per modificare il modello di partenza per creare il foglio Excel "Situazione Complessiva" dei Flussi Finanziari

		Local cXltxFileName
		cXltxFileName = ''

		** cXltxFileName = Addbs(oApp.PersDir) + 'FF_SituazioneComplessiva.xltx'

		Return cXltxFileName

	EndFunc

	Function FlussiFin_OnCreateMasterWorkBook(oExcelApp, oWorkbook)
		** Chiamata fatta alla foglio Excel "Situazione Complessiva" dei Flussi Finanziari. Si può modificare il layout del foglio.
	
		** oExcelApp	è l'applicazione Excel
		** oWorkbook	è il work book creato

		** Esempi:

		** Local oWorksheet, oPivotTable
	
		** oWorksheet = oWorkBook.Worksheets('CashFlow')

		** ** Aggiorno le tabelle pivot
		** For Each oPivotTable In oWorksheet.PivotTables
		** 	 oPivotTable.RefreshTable()
		** Next

		** oExcelApp.CommandBars("PivotTable"   ).Visible = .F.
		** oExcelApp.CommandBars("External Data").Visible = .F.
		** oWorkbook.ShowPivotTableFieldList = .F.

		** oExcelApp.ActiveWindow.DisplayGridlines 	 = .F.
		** oExcelApp.ActiveWindow.DisplayHeadings 	 = .F.
		** oExcelApp.ActiveWindow.DisplayWorkbookTabs = .F.

	EndFunc

	Function FlussiFin_GetDetailWorkBook()
		** Chiamata per modificare il modello di partenza per creare il foglio Excel "Situazione Dettagliata" dei Flussi Finanziari

		Local cXltxFileName
		cXltxFileName = ''

		Return cXltxFileName

	EndFunc

	Function FlussiFin_OnCreateDetailWorkBook(oExcelApp, oWorkbook)
		** Chiamata fatta alla foglio Excel "Situazione Dettagliata" dei Flussi Finanziari. Si può modificare il layout del foglio.
	
		** oExcelApp	è l'applicazione Excel
		** oWorkbook	è il work book creato

		** Esempi:
		** oExcelApp.CommandBars("PivotTable"   ).Visible = .F.
		** oExcelApp.CommandBars("External Data").Visible = .F.
		** oWorkbook.ShowPivotTableFieldList = .F.

		** oExcelApp.ActiveWindow.DisplayGridlines 	 = .F.
		** oExcelApp.ActiveWindow.DisplayHeadings 	 = .F.
		** oExcelApp.ActiveWindow.DisplayWorkbookTabs = .F.

	EndFunc


	**************************************************************************************
	** Aggiungere qui eventuali metodi che possano servire come funzioni/procedure
	**	globali sempre a disposizione. Per invocarli bisogna passare tramite l'oggetto
	**	pubblico oApp che mantiene in .ArcaExt l'unica istanza di oggetto di questa classe.

	**	Es.: oApp.ArcaExt.MyTestProcedure(10, 6, '###,###.##')
	
	**	Function MyTestProcedure(nInt1, nInt2, cPic)
	**		MessageBox(Tran(nInt1 * nInt2, cPic), 'oApp.ArcaExt.MyTestProcedure(' + Tran(nInt1) + ', ' + Tran(nInt2) + ', "' + cPic + '")')
	**	EndFunc
	
EndDef

*************************************************************************************
** Da qui in poi si possono aggiungere funzioni e/o Procedure.
** Dette funzioni/procedure saranno utilizzabili dai metodi della classe sopra definita;
**	se invece si intende utilizzarle globalmente in Arca fintando che la relativa ditta 
**	è in uso (in un report, durante una validazione di un campo, etc...) bisognerà far 
**	tornare .T. all'apposito metodo .AddToProcedureSpace() dell'oggetto ArcaExt.
**
** N.B.: Ci potrebbero essere potenziali conflitti con eventuali funzioni/procedure con lo 
**			stesso nome presenti in Arca (oggi o in futuro): utilizzare pertanto nomi che inizino
**			con i caratteri 'x_' per evitare questo problema oppure aggiungere metodi alla
**			classe ArcaExt e richiamarli come fossero funzioni/procedure per mezzo dell'oggetto
**			pubblico oApp come descritto sopra.

** Es.: Due funzioni molto banali di esempio:

**	Function x_Test1()
**		Messagebox('Test1')
**	EndFunc

**	Function x_Test2(xVar)
**		Messagebox(Tran(xVar))
**	EndFunc