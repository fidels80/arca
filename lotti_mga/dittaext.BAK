
*/------------------------------------------------------------------------------
*/ dittaext.fxp
*/------------------------------------------------------------------------------


*/==============================================================================
define class DittaExt as Session
*/==============================================================================
   Name = 'DittaExt'
   */------------------------------------------------------------------------------
   procedure OnLogin
   */------------------------------------------------------------------------------
      text 28 F7 00 00 60 CE FE
			SELECT COUNT(*)
			FROM AR inner join ARLotto on AR.cd_ar = ARLotto.cd_ar
			left join ARLottoARLottoAttributo ARL On ARLotto.Id_ARLotto = ARL.Id_ARLotto
			left join ARLottoAttributo ARLT on ARL.Id_Attributo = ARLT.Id_Attributo and ARLT.Descrizione = 'Obsoleti - Non Utilizzabili'
			WHERE ARL.Id_ARLotto is null AND DataScadenza is not null AND DATEDIFF(DD,getdate(),ARLotto.datascadenza) <= (select ISNULL(xGiorniScadenzaLotti,0) from Preferenza)
      endtext
      Nlottiscad = Xdefault(Xsqlexec2var(Cstmtlotti),0)
      if Nlottiscad>0
         Xmessagebox("Attenzione ... ci sono lotti in Scadenza o Scaduti ... Vai nelle Stampe Articoli per visualizzare il report 'Lotti in Scadenza/Scaduti'!!")
      endif
      return .T.
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnMenuInit
   */------------------------------------------------------------------------------
      lparameters oTv as MSCOMCTLLIB.TreeView
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnMenuNodeClick
   */------------------------------------------------------------------------------
      lparameters oNode as MSCOMCTLLIB.Node
      return .T.
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnFormRun
   */------------------------------------------------------------------------------
      lparameters oForm as FORM
      return .T.
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnCreateFTE_XML
   */------------------------------------------------------------------------------
      lparameters Nid_dotes, Cxml
      return Cxml
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnCreateDDT_XML
   */------------------------------------------------------------------------------
      lparameters Nid_dotes, Cxml
      return Cxml
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnDEInit
   */------------------------------------------------------------------------------
      lparameters oForm as FORM
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnElencoGridInit
   */------------------------------------------------------------------------------
      lparameters oForm, oGrid
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnPgFrameInit
   */------------------------------------------------------------------------------
      lparameters oForm, oPgframe
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnSendMail
   */------------------------------------------------------------------------------
      lparameters oMailinfo, oCallerform, oCallerobj
   endproc
   
   
enddefine
