
*/------------------------------------------------------------------------------
*/ dittaext_all.fxp
*/------------------------------------------------------------------------------


*/==============================================================================
define class DittaExt as Session
*/==============================================================================
   Name = 'DittaExt'
   */------------------------------------------------------------------------------
   procedure OnLogin
   */------------------------------------------------------------------------------
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
      if Upper(JustStem(oForm.Classlibrary))=='FEDI_DOC' or InList(Upper(JustStem(oForm.Classlibrary)),'FEDI_DOC_AD','FEDI_DOC_CA','FEDI_DOC_CP')
         oForm.Newobject('xExtObj_DOC_ALL','C_ExtObj_Fedi_DOC_ALL',this.Classlibrary)
         if Type('oForm.PF.PgGenerale.pf.pggenerale')='O'
            with oForm.Pf.Pggenerale.Pf.Pggenerale
               Mnewobject0(oForm.Pf.Pggenerale.Pf.Pggenerale,'xbtn_EA','xbtn_EA',oApp.Persdir+'\Forms\Fedi_DocCommon')
               .Xbtn_ea.Move(.Cntstato.Left,.Cntstato.Top+.Cntstato.Height+140)
               .Xbtn_ea.Visible = .T.
               .Xbtn_ea.Enabled = .T.
               .Xbtn_ea.Anchor = 9
            endwith
         endif
      endif
      if Upper(JustStem(oForm.Classlibrary))=='FEDI_ARTICOLO'
         oForm.Newobject('xExtObj_AR','C_ExtObj_Fedi_AR',this.Classlibrary)
      endif
      return .T.
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnSelectFTE_XML
   */------------------------------------------------------------------------------
      lparameters oForm, Nid_dotes, oAlias
      return .F.
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
   procedure xinitcolsinfo
   */------------------------------------------------------------------------------
      DoDefault()
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnDEInit
   */------------------------------------------------------------------------------
      lparameters oForm as FORM
      if Upper(JustStem(oForm.Classlibrary))=='FEDI_DOC' or InList(Upper(JustStem(oForm.Classlibrary)),'FEDI_DOC_AD','FEDI_DOC_CA','FEDI_DOC_CP')
         oForm.De.Dotes.Stmt = StrTran(oForm.De.Dotes.Stmt,'/*CIP*/',",CAST(LEFT(ISNULL(DT_N.nota,''),239) as varchar(239)) as xNotaOGGETTO /*CIP*/ ")
         oForm.De.Dotes.Stmt = StrTran(oForm.De.Dotes.Stmt,'/*TIP*/'," left join DoTesDoNota DT_N on dotes.Id_DoTes = DT_N.Id_DoTes left join DONota DO_N ON DT_N.Id_Nota = DO_N.Id_Nota and DO_N.Cd_Nota = 'OGG' /*TIP*/ ")
         oForm.De.Dotes.Stmt = StrTran(oForm.De.Dotes.Stmt,'/*CIP*/',',DO_TOT.TotImponibileE /*CIP*/ ')
         oForm.De.Dotes.Stmt = StrTran(oForm.De.Dotes.Stmt,'/*TIP*/',' left join DoTotali DO_TOT on dotes.Id_DoTes = DO_TOT.Id_DoTes /*TIP*/ ')
      endif
      if Left(Upper(JustStem(oForm.Classlibrary)),9)=='FEDI_DOCR'
         oForm.De.Dorig.Stmt = StrTran(oForm.De.Dorig.Stmt,'/*CIP*/',',DORig.xEA_Inviata /*CIP*/ ')
      endif
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnElencoGridInit
   */------------------------------------------------------------------------------
      lparameters oForm, oGrid
      if Upper(JustStem(oForm.Classlibrary))=='FEDI_DOC' or InList(Upper(JustStem(oForm.Classlibrary)),'FEDI_DOC_AD','FEDI_DOC_CA','FEDI_DOC_CP')
         oCol = oGrid.Newcolumn('ColxNotaOGGETTO','DOTes.xNotaOGGETTO','Nota OGGETTO',120)
         oCol.Forecolor = oApp.Color.Aliceblue
         oForm.De.Dotes.Acolsinfo( 'xNotaOGGETTO').Remotefullname = 'DT_N.Nota'
         oCol = oGrid.Newcolumn('ColxTotImponibileE','DOTes.TotImponibileE','Imponibile',120)
         oCol.Forecolor = oApp.Color.Aliceblue
         oForm.De.Dotes.Acolsinfo( 'TotImponibileE').Remotefullname = 'DO_TOT.TotImponibileE'
      endif
      if Left(Upper(JustStem(oForm.Classlibrary)),9)=='FEDI_DOCR'
         oCol = oGrid.Newcolumn('ColxEA_Inviata','DORig.xEA_Inviata','Email Inviata il',120)
         oCol.Forecolor = oApp.Color.Aliceblue
      endif
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnPgFrameInit
   */------------------------------------------------------------------------------
      lparameters oForm, oPgframe
      local oNewpage
      if Upper(JustStem(oForm.Classlibrary))=='FEDI_ARTICOLO'
         if !PEMStatus(oForm.Pf,'PgPers_emailAuto',5)
            oNewpage = oPgframe.Newpage('PgPers_emailAuto','Gestione EDITORI')
            oPgframe.Pgpers_emailauto.Enabled = .T.
            Mnewobject1(oPgframe.Pgpers_emailauto,'cnt','PgPers_emailAuto',AddBS(oApp.Persdir)+'Forms\FEDI_ARTICOLO.vcx','',oNewpage)
         endif
      endif
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnSendMail
   */------------------------------------------------------------------------------
      lparameters oMailinfo, oCallerform, oCallerobj
   endproc
   
   
enddefine
