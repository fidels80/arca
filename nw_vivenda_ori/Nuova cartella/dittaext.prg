
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
procedure xBloccoEmissioni
*/------------------------------------------------------------------------------
   lparameters Cdo, Ccli
   if !Isempty(Cdo) and !Isempty(Ccli)
      Noldwa = Select(0)
      Wnumdoc_blk_cli = Xdefault(Xsqlexec2var(TextMerge('Select xBlocco_NumDoc from CF where cd_CF = <<Format4SPT(cCli)>>')),0)
      Xnocontrollonumdoc = Xdefault(Xsqlexec2var(TextMerge('Select xNOControlloNumDOC from CF where cd_CF = <<Format4SPT(cCli)>>')),.F.)
      Wnumdoc_blk_doc = Xdefault(Xsqlexec2var(TextMerge('Select xBlocco_NumDoc from do where cd_do = <<Format4SPT(cDo)>>')),0)
      Xblocco_doc = Xdefault(Xsqlexec2var(TextMerge('Select xBlocco from do where cd_do = <<Format4SPT(cDo)>>')),.F.)
      Wnumdoc_blk = 0
      if !Isempty(Ccli)
         if Wnumdoc_blk_cli>0
            Wnumdoc_blk = Wnumdoc_blk_cli
         endif
         if Wnumdoc_blk=0 and Wnumdoc_blk_doc>0
            Wnumdoc_blk = Wnumdoc_blk_doc
         endif
         if !Xnocontrollonumdoc and Wnumdoc_blk>0
            text 28 F7 0B 00 60 CE FE
				SELECT COUNT(*) FROM DOTES
				WHERE PRELEVABILE = 1 AND RigheEvadibili > 0
				and cd_do = <<Format4SPT(cDO)>> and cd_cf = <<Format4SPT(cCli)>>
				and timeins >= ISNULL((select MAX(T_O.timeins) from dotes T
								inner join dorig R ON R.id_dotes = T.id_dotes
								inner join dorig R_O on R.id_dorig = R_O.id_dorig_evade
								inner join dotes T_O on R_O.id_dotes = T_O.id_dotes
								where T.PRELEVABILE = 1
									and T.cd_do = <<Format4SPT(cDO)>> and T.cd_cf = <<Format4SPT(cCli)>>),'19000101')
									
            endtext
            Nblocked = Xsqlexec2var(Cstmt)
            if Nblocked>=Wnumdoc_blk
               Xmessagebox("Per il Cliente '"+Ccli+"' hai già emesso "+AllTrim(Str(Nblocked))+' Documenti che non sono stati Evasi!')
               if Xblocco_doc
                  Xmessagebox('Impossibile emettere altro Documento!')
                  return .T.
               else
                  Nxmess = Xmessagebox('Vuoi CONTINUARE?',292)
                  if Nxmess=6
                     return .F.
                  else
                     return .T.
                  endif
               endif
            endif
         endif
      endif
      select (Noldwa)
   endif
   return .F.
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
                   Xcostoacquisto with 0
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
               Mnewobject0(oForm.Pf.Pggenerale.Pf.Pggenerale.Cntpagamento,'cntxScontoCassa','cntxScontoCassa',oApp.Persdir+'\Forms\Fedi_DocCommon')
               .Cntpagamento.Cntxscontocassa.Move(.Cntpagamento.Txtscontocassa.Left+.Cntpagamento.Txtscontocassa.Width+10,.Cntpagamento.Txtscontocassa.Top-1,.Cntpagamento.Width-.Cntpagamento.Cntxscontocassa.Left)
               .Cntpagamento.Cntxscontocassa.Txtxscontocassa.Field.Readonly = .T.
               .Cntpagamento.Cntxscontocassa.Visible = .T.
               .Cntpagamento.Cntxscontocassa.Enabled = .T.
               .Cntpagamento.Cntxscontocassa.Anchor = 10
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
         oForm.De.Dorig.Stmt = StrTran(oForm.De.Dorig.Stmt,'/*CIP*/',",xInserzione, xGazzetta,xDataRichiestaCliente,CAST(LEFT(ISNULL(xNoteTecnici,''),239) as varchar(239)) as xNoteTecnici  /*CIP*/ ")
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
         oCol = oGrid.Newcolumn('ColxGazzetta','DORig.xGazzetta','Nr Gazzetta',40)
         oCol.Forecolor = oApp.Color.Aliceblue
         oCol = oGrid.Newcolumn('ColxDataRichiestaCliente','DORig.xDataRichiestaCliente','Dt.Rich.Cliente',50)
         oCol.Forecolor = oApp.Color.Aliceblue
         oCol = oGrid.Newcolumn('ColxNoteTecnici','DORig.xNoteTecnici','NoteTecnici',40)
         oCol.Forecolor = oApp.Color.Aliceblue
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
