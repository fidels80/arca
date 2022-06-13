
*/------------------------------------------------------------------------------
*/ dittaext.fxp
*/------------------------------------------------------------------------------

*/------------------------------------------------------------------------------
procedure xInitToolBar
*/------------------------------------------------------------------------------
   lparameters oForm
   local oBtn, Cform
   with oForm.Toolbar
      oBtn = .Buttons.Add()
      oBtn.Tooltiptext = 'Totale Quotidiani (CTRL+T)'
      oBtn.Visible = .T.
      oBtn.Enabled = .F.
      Cform = oForm.Name
      ON KEY LABEL CTRL+T &cForm..DoCmd('xTotMD')
   endwith
endproc

*/------------------------------------------------------------------------------
procedure xTotMD_Calcolo
*/------------------------------------------------------------------------------
   lparameters oForm
   oDo = oForm.Pf.Pggenerale.Txtcd_do.Field.Fkrecord
   if !oDo.Xrigatot_md
      Xmessagebox('Operazione non abilitata per questo Tipo di Documento!')
      return
   endif
   if oForm.Mode=0
      Xmessagebox('Operazione consentita solo in creazione/modifica del Documento!')
      return
   endif
   if oForm.Toolbar.Buttons('xTotMD').Enabled
      select * from dorig with ( buffering =  .T. ) into cursor crRighe
      select Crrighe
      go top
      locate for Cd_ar='TOT'
      if Found()
         Xmessagebox('La riga col Totale QUOTIDIANI è già presente!')
         return
      else
         Wtotprezzo = 0
         Wtotcosto = 0
         select Crrighe
         go top
         select distinct ;
                Cd_aliquota, ;
                Sum(Prezzototalev) as Prezzot, ;
                Sum(Xtotcosto) as Costot from crRighe where Cd_armisura='MD' and !Isempty(Cd_ar) group by Cd_aliquota into cursor crNewRow
         if RecCount('crNewRow')>0
            select Crnewrow
            go top
            scan
               oForm.Cmdrowadd
               oForm.Pf.Pggenerale.Pf.Pgrighe.Cnt.Grid.Colcd_ar.Stdtext1.Setvalue('TOT',.T.)
               oForm.Pf.Pggenerale.Pf.Pgrighe.Cnt.Grid.Colcd_aliquota.Stdtext1.Setvalue(Crnewrow.Cd_aliquota,.T.)
               oForm.Pf.Pggenerale.Pf.Pgrighe.Cnt.Grid.Colqta.Stdtext1.Setvalue(1,.T.)
               oForm.Pf.Pggenerale.Pf.Pgrighe.Cnt.Grid.Colprezzounitariov.Text1.Setvalue(Crnewrow.Prezzot,.T.)
               oForm.Pf.Pggenerale.Pf.Pgrighe.Cnt.Grid.Colxcostoacquisto.Stdtext1.Setvalue(Xdefault(Crnewrow.Costot,0),.T.)
               oForm.Pf.Pggenerale.Pf.Pgrighe.Cnt.Grid.Colxtotcosto.Stdtext1.Setvalue(Xdefault(Crnewrow.Costot,0),.T.)
               oForm.Pf.Pggenerale.Pf.Pgrighe.Cnt.Setdorig_formulae()
               oForm.Pf.Pggenerale.Pf.Pgrighe.Cnt.Grid.Refresh()
               select Crnewrow
            endscan
            replace in Dorig all for Cd_armisura='MD' and !Isempty(Cd_ar) and Cd_ar<>'TOT' and Prezzounitariov<>0 ;
                   Xprezzounitariov_copy with Prezzounitariov, ;
                   Xcostoacquisto_copy with Xcostoacquisto
            replace in Dorig all for Cd_armisura='MD' and !Isempty(Cd_ar) and Cd_ar<>'TOT' and Prezzounitariov<>0 ;
                   Prezzounitariov with 0, ;
                   Prezzototalev with 0, ;
                   Xcostoacquisto with 0, ;
                   Xtotcosto with 0
            oForm.Pf.Pggenerale.Pf.Pgrighe.Cnt.Grid.Refresh()
         endif
         use in Crnewrow
      endif
      use in Crrighe
      Xmessagebox('Calcolo Totale QUOTIDIANI terminato!')
   endif
endproc


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
         if Type('oForm.PF.PgGenerale.pf.pggenerale')='O'
            with oForm.Pf.Pggenerale.Pf.Pggenerale
               Mnewobject0(oForm.Pf.Pggenerale.Pf.Pggenerale,'txtxEmail','StdField','Libs\StdCtrl')
               Mnewobject0(.Txtxemail,'Field','StdText','Libs\StdCtrl')
               .Txtxemail.laBel.Caption = 'Config.Email'
               .Txtxemail.laBel.Visible = .T.
               .Txtxemail.Field.Controlsource = 'DOTes.cd_xEmailAttach'
               .Txtxemail.Field.Fkselect = 'Select * From xEmailAttach Where Cd_xEmailAttach = <TEXT>'
               .Txtxemail.Field.Init()
               .Txtxemail.Field.Move(1,.Txtxemail.laBel.Top+.Txtxemail.laBel.Height-3,170)
               .Txtxemail.Field.Visible = .T.
               .Txtxemail.Move(.Cntstato.Left,.Cntstato.Top+.Cntstato.Height+10,180,40)
               .Txtxemail.Visible = .T.
               .Txtxemail.Anchor = 9
               .Txtxemail.laBel.Forecolor = RGB(0,0,255)
               .Txtxemail.Field.Forecolor = RGB(0,0,255)
               .Txtxemail.Field.Readonly = .T.
               Mnewobject0(oForm.Pf.Pggenerale.Pf.Pggenerale,'txtxFatturaCliente','StdField','Libs\StdCtrl')
               Mnewobject0(.Txtxfatturacliente,'Field','StdText','Libs\StdCtrl')
               Mnewobject0(.Txtxfatturacliente,'Field2','StdText','Libs\StdCtrl')
               .Txtxfatturacliente.laBel.Caption = 'Fattura Cliente'
               .Txtxfatturacliente.laBel.Visible = .T.
               .Txtxfatturacliente.Field2.Controlsource = 'DOTes.xFatturaCliente'
               .Txtxfatturacliente.Field.Controlsource = 'DOTes.xID_FatturaCliente'
               .Txtxfatturacliente.Field.Move(1,.Txtxfatturacliente.laBel.Top+.Txtxfatturacliente.laBel.Height-3,40)
               .Txtxfatturacliente.Field2.Move(41,.Txtxfatturacliente.laBel.Top+.Txtxfatturacliente.laBel.Height-3,130)
               .Txtxfatturacliente.Field2.Visible = .T.
               .Txtxfatturacliente.Field.Visible = .T.
               .Txtxfatturacliente.Move(.Cntstato.Left,.Cntstato.Top+.Cntstato.Height+60,180,40)
               .Txtxfatturacliente.Visible = .T.
               .Txtxfatturacliente.Anchor = 9
               .Txtxfatturacliente.laBel.Forecolor = RGB(0,0,255)
               .Txtxfatturacliente.Field.Forecolor = RGB(0,0,255)
               .Txtxfatturacliente.Field2.Forecolor = RGB(0,0,255)
               .Txtxfatturacliente.Field.Readonly = .T.
               .Txtxfatturacliente.Field2.Readonly = .T.
               Mnewobject0(oForm.Pf.Pggenerale.Pf.Pggenerale,'xbtnLinkDoc','xbtnDoc',oApp.Persdir+'\Forms\Fedi_DocCommon')
               .Xbtnlinkdoc.Move(.Cntstato.Left,.Cntstato.Top+.Cntstato.Height+110)
               .Xbtnlinkdoc.Visible = .T.
               .Xbtnlinkdoc.Enabled = .T.
               .Xbtnlinkdoc.Anchor = 9
            endwith
         endif
         oForm.Newobject('xExtObj_DOC','C_ExtObj_Fedi_DOC',this.Classlibrary)
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
      if Upper(JustStem(oForm.Classlibrary))=='FEDI_DOCR_CA'
         oForm.De.Dorig.Stmt = StrTran(oForm.De.Dorig.Stmt,'/*CIP*/',',xInserzione  /*CIP*/ ')
      endif
      if Upper(JustStem(oForm.Classlibrary))=='FEDI_DOC' or InList(Upper(JustStem(oForm.Classlibrary)),'FEDI_DOC_AD','FEDI_DOC_CA','FEDI_DOC_CP')
         oForm.De.Dotes.Stmt = StrTran(oForm.De.Dotes.Stmt,'/*CIP*/',",CAST(LEFT(ISNULL(DT_N.nota,''),239) as varchar(239)) as xNotaOGGETTO /*CIP*/ ")
         oForm.De.Dotes.Stmt = StrTran(oForm.De.Dotes.Stmt,'/*TIP*/'," left join DoTesDoNota DT_N on dotes.Id_DoTes = DT_N.Id_DoTes left join DONota DO_N ON DT_N.Id_Nota = DO_N.Id_Nota and DO_N.Cd_Nota = 'OGG' /*TIP*/ ")
      endif
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnElencoGridInit
   */------------------------------------------------------------------------------
      lparameters oForm, oGrid
      if Upper(JustStem(oForm.Classlibrary))=='FEDI_DOCR_CA'
         oCol = oGrid.Newcolumn('ColxInserzione','DORig.xInserzione','Nr Inserzione',40)
         oCol.Forecolor = oApp.Color.Aliceblue
         oGrid.Coldataconsegna.Hdrbase1.Caption = 'Dt.Pubblicazione'
      endif
      if Upper(JustStem(oForm.Classlibrary))=='FEDI_DOC' or InList(Upper(JustStem(oForm.Classlibrary)),'FEDI_DOC_AD','FEDI_DOC_CA','FEDI_DOC_CP')
         oCol = oGrid.Newcolumn('ColxNotaOGGETTO','DOTes.xNotaOGGETTO','Nota OGGETTO',120)
         oCol.Forecolor = oApp.Color.Aliceblue
         oForm.De.Dotes.Acolsinfo( 'xNotaOGGETTO').Remotefullname = 'DT_N.Nota'
      endif
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
      if Upper(JustStem(oCallerform.Classlibrary))=='FEDI_DOC' or InList(Upper(JustStem(oCallerform.Classlibrary)),'FEDI_DOC_AD','FEDI_DOC_CA','FEDI_DOC_CP')
         Cconfig = oCallerform.Pf.Pggenerale.Pf.Pggenerale.Txtxemail.Field.Value
         Noldwa = Select(0)
         if !Isempty(Cconfig)
            text 28 F7 0C 00 60 CE FE
					SELECT DmsDocument.Id_DmsDocument, DmsDocument.FileName
					From xEmailAttach_Dett Inner Join DmsDocument
						On xEmailAttach_Dett.Id_DmsDocument = DmsDocument.Id_DmsDocument
					where xEmailAttach_Dett.cd_xEmailAttach = <<Format4SPT(cConfig)>>
            endtext
            Xsqlexec(Cstmt,'crFiles')
            if RecCount('crFiles')>0
               = Createdirectory(AddBS(oApp.Persdir)+'Allegati',0)
               erase (AddBS(oApp.Persdir)+'Allegati\*.*')
               select Crfiles
               go top
               scan
                  Cfilename = AddBS(oApp.Persdir)+'Allegati\'+AllTrim(Crfiles.Filename)
                  Ndms = oApp.Dms.Extract(Crfiles.Id_dmsdocument,Cfilename,.F.)
                  oMailinfo.oAttachment.Add(Cfilename,JustFName(Cfilename))
                  select Crfiles
               endscan
               DoDefault(oMailinfo,oCallerform,oCallerobj)
               return
            endif
         endif
         select (Noldwa)
      endif
      DoDefault(oMailinfo,oCallerform,oCallerobj)
   endproc
   
   
enddefine
