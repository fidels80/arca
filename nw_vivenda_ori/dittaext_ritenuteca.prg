
*/------------------------------------------------------------------------------
*/ dittaext_ritenuteca.fxp
*/------------------------------------------------------------------------------


*/==============================================================================
define class DittaExt as Session
*/==============================================================================
   Name = 'DittaExt_RitenuteCA'
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
      do case
         case oBjisa(oForm,'Std_FediForm') and Lower(JustStem(oForm.Classlibrary))=='fedi_articolo'
            Mnewobject0(oForm,'xev_handler_ritenuteca','fedi_articolo_handler',AddBS(oApp.Persdir)+'Forms\ritenuteca.vcx')
         case oBjisa(oForm,'Std_FediForm') and Lower(JustStem(oForm.Classlibrary))=='fedi_cfcli'
            Mnewobject0(oForm,'xev_handler_ritenuteca','fedi_cfcli_handler',AddBS(oApp.Persdir)+'Forms\ritenuteca.vcx')
         case oBjisa(oForm,'Std_FediForm') and Lower(JustStem(oForm.Classlibrary))=='fedi_doc'
            Mnewobject0(oForm,'xev_handler_ritenuteca','fedi_doc_handler',AddBS(oApp.Persdir)+'Forms\ritenuteca.vcx')
         case oBjisa(oForm,'Std_FediForm') and Lower(JustStem(oForm.Classlibrary))=='fedi_doc_ca'
            Mnewobject0(oForm,'xev_handler_ritenuteca','fedi_doc_handler',AddBS(oApp.Persdir)+'Forms\ritenuteca.vcx')
         case oBjisa(oForm,'Std_FediForm') and Lower(JustStem(oForm.Classlibrary))=='fedi_do'
            Mnewobject0(oForm,'xev_handler_ritenuteca','fedi_do_handler',AddBS(oApp.Persdir)+'Forms\ritenuteca.vcx')
         case oBjisa(oForm,'Std_FediForm') and Lower(JustStem(oForm.Classlibrary))=='fedi_cgconto'
            Mnewobject0(oForm,'xev_handler_ritenuteca','fedi_cgconto_handler',AddBS(oApp.Persdir)+'Forms\ritenuteca.vcx')
         case oBjisa(oForm,'Std_FediForm') and Lower(JustStem(oForm.Classlibrary))=='fedi_cgmovt'
            Mnewobject0(oForm,'xev_handler_ritenuteca','fedi_cgmovt_handler',AddBS(oApp.Persdir)+'Forms\ritenuteca.vcx')
         case oBjisa(oForm,'Std_FediForm') and Lower(JustStem(oForm.Classlibrary))=='repo_bilanci'
            Mnewobject0(oForm,'xev_handler_ritenuteca','repo_bilanci_handler',AddBS(oApp.Persdir)+'Forms\ritenuteca.vcx')
         case oBjisa(oForm,'Std_SelForm') and Lower(JustStem(oForm.Classlibrary))=='sel_partitari'
            local oCol
            with oForm.Pf.Pglistamovimenti.Grid
               .Saverecordsource()
               oForm.De.Crmovimenti.Requery('1=0')
               .Restorerecordsource()
               oCol = .Newcolumn('ColCGConto_Origine','CRMovimenti.xCd_CGConto_Origine','Conto Competenza',100)
               oCol.Removeobject(oCol.Currentcontrol)
               Mnewobject(oCol,'Field','SpcConto','Libs\SpcCtrl')
               oCol.Field.Visible = .T.
               oCol.Readonly = .T.
               oCol.Backcolor = RGB(255,220,200)
               oCol = .Newcolumn('ColDSConto_Origine','CRMovimenti.CGContoOrigine_Descrizione','Descrizione Conto Competenza',200)
               oCol.Readonly = .T.
               oCol.Backcolor = RGB(255,220,200)
               oCol = .Newcolumn('ColContropartiteCompetenza','CRMovimenti.Contropartite_Competenza','Contropartite Competenza',250)
               oCol.Removeobject(oCol.Currentcontrol)
               oCol.Sparse = .F.
               Mnewobject(oCol,'Field','StdEdit','Libs\StdCtrl')
               oCol.Field.Borderstyle = 0
               oCol.Field.Backstyle = 0
               oCol.Field.Visible = .T.
               oCol.Readonly = .T.
               oCol.Backcolor = RGB(255,220,200)
               .Initautosavelayout()
            endwith
      endcase
      return .T.
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnDEInit
   */------------------------------------------------------------------------------
      lparameters oForm as FORM
      do case
         case oBjisa(oForm,'Std_SelForm') and Lower(JustStem(oForm.Classlibrary))=='sel_partitari'
            oForm.De.Crmovimenti.Stmt = StrTran(oForm.De.Crmovimenti.Stmt,'/*CIP*/',', CGMovR.Id_CGMovR As xId_CGMovR_Origine, CGMovR.xCd_CGConto_Origine, CGConto_Origine.Descrizione As CGContoOrigine_Descrizione /*CIP*/')
            oForm.De.Crmovimenti.Stmt = StrTran(oForm.De.Crmovimenti.Stmt,'/*TIP*/',' Left Join CGConto CGConto_Origine On CGConto_Origine.Cd_CGConto = CGMovR.xCd_CGConto_Origine /*TIP*/')
            local Cstmt
            text 28 F7 06 00 CE FE
, Replace(STUFF(Convert(varchar(max), (
	Select
		'|' + R.xCd_CGConto_Origine + ' - ' + C.Descrizione
	From CGMovR R
		Inner Join CGConto C On C.Cd_CGConto = R.xCd_CGConto_Origine
	Where R.Id_CGMovT = CGMovR.Id_CGMovT And R.TipoRiga = 1
	Order By R.Riga
	FOR XML Path('')
   )), 1, 1, ''), '|', Char(13) + Char(10)) As Contropartite_Competenza
				
/*CIP*/				
            endtext
            oForm.De.Crmovimenti.Stmt = StrTran(oForm.De.Crmovimenti.Stmt,'/*CIP*/',Cstmt)
            text 28 F7 06 00 CE FE
<ORDERBY>


UPDATE #CRMovimenti
	SET Contropartite_Competenza = 'Diversi (doppio click per dettaglio):' + char(13) + char(10) + Contropartite_Competenza
Where ISNULL(Contropartite_Competenza, '') <> '' And CharIndex(char(13) + char(10), Contropartite_Competenza) > 0


UPDATE #CRMovimenti
	SET Id_SC = SC.Id_SC,
		Sc_TipoRata = Sc.TipoRata,
		Sc_NumFattura = Sc.NumFattura,
		Sc_DataFattura = Sc.DataFattura,
		Sc_DataScadenza = Sc.DataScadenza,
		Sc_Descrizione = Sc.Descrizione
	From #CRMOVIMENTI
		Inner Join CGMovR On CGMovR.Id_CGMovR = #CRMovimenti.xId_CGMovR_Origine
		Inner Join SC On SC.Id_SC = CGMovR.xId_SC_P_RitenuteCA
	Where CGMovR.xGirocontoTransitorio = 1


            endtext
            oForm.De.Crmovimenti.Stmt = StrTran(oForm.De.Crmovimenti.Stmt,'<ORDERBY>',Cstmt)
      endcase
   endproc
   
   
   */------------------------------------------------------------------------------
   procedure OnCreateFTE_XML
   */------------------------------------------------------------------------------
      lparameters Nid_dotes, Cxml
      local oDomdoc as MSXML2.DOMDocument40
      local oNodes as MSXML2.IXMLDOMNodeList, oNode as MSXML2.IXMLDOMNode, oSubnode as MSXML2.IXMLDOMNode, oRefnode as MSXML2.IXMLDOMNode, oChildnode as MSXML2.IXMLDOMNode
      local oXmlritenute, Cstmt
      local oRitdoc as MSXML2.DOMDocument40, Nnode
      text 28 F7 09 00 60 CE FE


/*		
		        <DatiRitenuta>
		          <TipoRitenuta>RT01</TipoRitenuta>
		          <ImportoRitenuta>200.00</ImportoRitenuta>
		          <AliquotaRitenuta>20.00</AliquotaRitenuta>
		          <CausalePagamento>A</CausalePagamento>
		        </DatiRitenuta>
		        <DatiCassaPrevidenziale>
		          <TipoCassa>TC02</TipoCassa>
		          <AlCassa>4.00</AlCassa>
		          <ImportoContributoCassa>40.00</ImportoContributoCassa>
		          <ImponibileCassa>1000.00</ImponibileCassa>
		          <AliquotaIVA>22.00</AliquotaIVA>
      			  <Natura />  -- obbligatorio solo se aliquota iva pari a zero!
      		    </DatiCassaPrevidenziale>
*/


			DECLARE @XmlRitenuta xml, @XmlCassa xml, @XmlRiepilogo xml, @XmlEnasarco xml, @AliquotaIVA Numeric(18, 6), @Natura char(2)
			
			SELECT @XmlRitenuta = (
									Select DatiRitenuta.TipoRitenuta, DatiRitenuta.ImportoRitenuta, DatiRitenuta.AliquotaRitenuta, DatiRitenuta.CausalePagamento
									From (
											Select
												Case
													When Ditta.TipoDitta = 'F' Then 'RT01'
													Else							'RT02'
												End As TipoRitenuta,
												Convert(Numeric(18, 2), DOTotali.xTotaleRitenutaAccontoE) As ImportoRitenuta,
												Convert(Numeric(18, 2), DOTes.xPercentualeRitenuta) As AliquotaRitenuta,
												Coalesce(RTRIM(TipoReddito.Cd_TipoReddito), 'A') As CausalePagamento
											From DOTotali
												Inner Join DOTes On DOTes.Id_DOTes = DOTotali.Id_DOTes
												Inner Join Preferenza On 1=1
												Inner Join Ditta On 1=1
												Left Join TipoReddito On TipoReddito.Cd_TipoReddito = Preferenza.xCd_TipoReddito_Ritenuta
											Where ((DOTes.xCalcolaRitenuta = 1 And DOTotali.xTotaleRitenutaAccontoE != 0) Or (DOTes.xCalcolaContributoIntegrativo = 1 And Exists(Select DORigSpesa.Id_DORigSpesa From DORigSpesa Where DORigSpesa.Id_DOTes = DOTes.Id_DOTes And DORigSpesa.xRigaContributoIntegrativo = 1))) And DOTes.Id_DOTes = <<Format4Spt(nId_DOTes)>>
										) DatiRitenuta
									For Xml Auto, Elements, Root('Document')
								 )


			SELECT @XmlCassa = (
									Select
										TipoCassa,
										AlCassa,
										ImportoContributoCassa,
										ImponibileCassa,
										AliquotaIVA,
										Natura
									From (
										Select
											RTRIM(Preferenza.xCd_xTipoCassaPrevidenza_RA) As TipoCassa,
											Convert(Numeric(18, 2), DOTes.xPercentualeContributoIntegrativo) As AlCassa,
											Convert(Numeric(18, 2), Sum(DORigSpesa.ImportoE)) As ImportoContributoCassa,
											Convert(Numeric(18, 2), Sum(DORigSpesa.xImponibileContributoIntegrativo)) As ImponibileCassa,
											Convert(Numeric(18, 2), Aliquota.Aliquota) As AliquotaIVA,
											Aliquota.Cd_Natura as Natura
										From DORigSpesa
											Inner Join DOTes On DOTes.Id_DOTes = DORigSpesa.Id_DOTes
											Inner Join Aliquota On Aliquota.Cd_Aliquota = DORigSpesa.Cd_Aliquota_R
											Inner Join Preferenza On 1=1
										Where DOTes.xCalcolaContributoIntegrativo = 1 And DORigSpesa.xRigaContributoIntegrativo = 1 And DOTes.Id_DOTes = <<Format4Spt(nId_DOTes)>>
										Group By
											Preferenza.xCd_xTipoCassaPrevidenza_RA,
											DOTes.xPercentualeContributoIntegrativo,
											Aliquota.Aliquota,
											Aliquota.Cd_Natura
/*
										Union All


										Select
											RTRIM(Coalesce(Preferenza.xCd_xTipoCassaPrevidenza_RE, 'TC07')) As TipoCassa,		-- Enasarco = TC07
											Convert(Numeric(18, 2), DOTes.xPercentualeEnasarco) As AlCassa,
											Convert(Numeric(18, 2), DOTotali.xTotaleRitenutaEnasarcoE) As ImportoContributoCassa,
											Convert(Numeric(18, 2), DOTotali.xImponibileEnasarcoE) As ImponibileCassa,
											Convert(Numeric(18, 2), 0) As AliquotaIVA,
											Preferenza.xCd_Natura_Enasarco As Natura
										From DOTotali
											Inner Join DOTes On DOTes.Id_DOTes = DOTotali.Id_DOTes
											Inner Join Preferenza On 1=1
										Where DOTes.xCalcolaEnasarco = 1 And DOTes.Id_DOTes = <<Format4Spt(nId_DOTes)>>
*/
										) DatiCassaPrevidenziale
									For Xml Auto, Elements, Root('Document')
								)


/*
			SELECT @XmlRiepilogo = (
									Select
										AliquotaIVA,
										Natura,
										ImponibileImporto,
										Imposta
									From (
										Select
											Convert(Numeric(18, 2), DOTotali.xTotaleRitenutaEnasarcoE) As ImponibileImporto,
											Convert(Numeric(18, 2), 0) As Imposta,
											Convert(Numeric(18, 2), 0) As AliquotaIVA,
											Preferenza.xCd_Natura_Enasarco As Natura
										From DOTotali
											Inner Join DOTes On DOTes.Id_DOTes = DOTotali.Id_DOTes
											Inner Join Preferenza On 1=1
										Where DOTes.xCalcolaEnasarco = 1 And DOTes.Id_DOTes = <<Format4Spt(nId_DOTes)>>
										) DatiCassaPrevidenziale
									For Xml Auto, Elements, Root('Document')
								)
*/


			SELECT @XmlEnasarco = (
									Select
										TipoDato,
										RiferimentoTesto,
										RiferimentoNumero
									From (
										SELECT
											'CASSA-PREV' As TipoDato,
											Coalesce(Preferenza.xCd_xTipoCassaPrevidenza_RE, 'TC07') + ' - ENASARCO' AS RiferimentoTesto,
											Convert(Numeric(18, 2), -DOTotali.xTotaleRitenutaEnasarcoE) As RiferimentoNumero
										From DOTotali
											Inner Join DOTes On DOTes.Id_DOTes = DOTotali.Id_DOTes
											Inner Join Preferenza On 1=1
										Where DOTes.xCalcolaEnasarco = 1 And DOTotali.xTotaleRitenutaEnasarcoE != 0 And DOTes.Id_DOTes = <<Format4Spt(nId_DOTes)>>
										) AltriDatiGestionali
									For Xml Auto, Elements, Root('Document')
								)


			
			Select TOP 1
				@AliquotaIVA = X.AliquotaIva,
				@Natura = X.Natura					
			From
				(
					Select
						  Cd_Aliquota				= DI.Cd_Aliquota
		 			    , Cd_ReverseCharge		    = DI.Cd_ReverseCharge
						, AliquotaIva				= Max(DI.Aliquota)
						, Natura					= Max(dbo.afn_FE_GetNatura(DI.Cd_Aliquota))
						, ImponibileImporto		    = Sum(DI.ImponibileV)
						, Imposta					= Sum(DI.ImpostaV)
					From
						DOIva	DI			
					Where DI.Id_DoTes = <<nId_DoTes>>
					Group By	DI.Cd_Aliquota, DI.Cd_ReverseCharge
				) X
			Order By	2
								
			SELECT @XmlRitenuta As Ritenuta, @XmlCassa As Cassa, @XmlRiepilogo As Riepilogo, @XmlEnasarco As Enasarco, (SELECT xCalcolaEnasarco FROM DOTes WHERE Id_DOTes = <<Format4Spt(nId_DOTes)>>) As HasEnasarco, (SELECT Preferenza.xCd_Natura_Enasarco FROM Preferenza) As Natura_Enasarco, (SELECT Preferenza.xCd_xTipoCassaPrevidenza_RE FROM Preferenza) As TipoCassaPrevidenza, (SELECT DOTotali.xTotaleRitenutaEnasarcoE FROM DOTotali WHERE Id_DOTes = <<Format4Spt(nId_DOTes)>>) As ImportoEnasarco, @AliquotaIVA As AliquotaIva, @Natura As Natura
				
      endtext
      oXmlritenute = Xsqlexec2obj(Cstmt)
      if VarType(oXmlritenute)<>'O' or (Isempty(oXmlritenute.Ritenuta) and Isempty(oXmlritenute.Cassa) and Isempty(oXmlritenute.Enasarco))
         return Cxml
      endif
      oDomdoc = Newdomdocument(Cxml)
      if VarType(oDomdoc)='O'
         oNode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento')
         if VarType(oNode)=='O'
            if !Isempty(oXmlritenute.Ritenuta)
               oRitdoc = Newdomdocument(oXmlritenute.Ritenuta)
               oSubnode = oRitdoc.Documentelement.Childnodes(0).Clonenode(.T.)
               oRefnode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiRitenuta')
               if VarType(oRefnode)=='O'
                  oNode.Replacechild(oSubnode,oRefnode)
               else
                  oRefnode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiBollo')
                  oRefnode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiBollo')
                  if VarType(oRefnode)<>'O'
                     oRefnode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/ScontoMaggiorazione')
                  endif
                  if VarType(oRefnode)<>'O'
                     oRefnode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/ImportoTotaleDocumento')
                  endif
                  oNode.Insertbefore(oSubnode,oRefnode)
               endif
            endif
            if !Isempty(oXmlritenute.Cassa)
               oRefnode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/ScontoMaggiorazione')
               if VarType(oRefnode)<>'O'
                  oRefnode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/ImportoTotaleDocumento')
               endif
               oRitdoc = Newdomdocument(oXmlritenute.Cassa)
               for Nnode = 0 to oRitdoc.Documentelement.Childnodes.Length-1
                  oSubnode = oRitdoc.Documentelement.Childnodes(Nnode).Clonenode(.T.)
                  oNode.Insertbefore(oSubnode,oRefnode)
               endfor
            endif
         endif
         oNodes = oDomdoc.Documentelement.Selectnodes('FatturaElettronicaBody/DatiBeniServizi/DettaglioLinee')
         if VarType(oNodes)='O' and oNodes.Length>0
            local Nprezzototale, Nriga
            Nriga = 0
            for each oNode in oNodes
               oSubnode = oNode.Selectsinglenode('NumeroLinea')
               Nriga = Max(Nriga,iif(VarType(oSubnode)='O',Val(oSubnode.Text),0))
               oSubnode = oNode.Selectsinglenode('TipoCessionePrestazione')
               if VarType(oSubnode)='O'
                  if !(oSubnode.Text=='AC')
                     loop
                  endif
                  oSubnode = oNode.Selectsinglenode('Descrizione')
                  if VarType(oSubnode)<>'O'
                     loop
                  endif
                  if !Xsqlexists('DORigSpesa','xRigaContributoIntegrativo = 1 And Id_DOTes = '+Format4spt(Nid_dotes)+' And Descrizione = '+Format4spt(oSubnode.Text))
                     loop
                  endif
                  oSubnode = oNode.Selectsinglenode('PrezzoTotale')
                  if VarType(oSubnode)<>'O'
                     loop
                  endif
                  Nprezzototale = Val(oSubnode.Text)
                  oSubnode.Text = '0.00000000'
                  oSubnode = oNode.Selectsinglenode('PrezzoUnitario')
                  if VarType(oSubnode)='O'
                     oSubnode.Text = '0.00000000'
                  endif
                  oSubnode = oNode.Selectsinglenode('Descrizione')
                  oSubnode.Text = oSubnode.Text+' pari a '+AllTrim(Transform(Nprezzototale,'#########.##'))
               endif
            endfor
            if VarType(oXmlritenute)='O' and oXmlritenute.Hasenasarco and !Isempty(oXmlritenute.Importoenasarco)
               if Isempty(oXmlritenute.Natura_enasarco) and Isempty(oXmlritenute.Aliquotaiva) and Isempty(oXmlritenute.Natura)
                  Xmessagebox('ATTENZIONE! Non è stata individuata la Aliquota/Natura per Enasarco (vedi Servizio\Impostazioni, pag. Ritenute).',16)
                  return .F.
               endif
               oSubnode = oDomdoc.Createelement('DettaglioLinee')
               oChildnode = oDomdoc.Createelement('NumeroLinea')
               oChildnode.Text = Transform(Nriga+1)
               oSubnode.Appendchild(oChildnode)
               oChildnode = oDomdoc.Createelement('Descrizione')
               oChildnode.Text = 'Riga ausiliaria per contributo Enasarco'
               oSubnode.Appendchild(oChildnode)
               oChildnode = oDomdoc.Createelement('PrezzoUnitario')
               oChildnode.Text = '0.00'
               oSubnode.Appendchild(oChildnode)
               oChildnode = oDomdoc.Createelement('PrezzoTotale')
               oChildnode.Text = '0.00'
               oSubnode.Appendchild(oChildnode)
               oChildnode = oDomdoc.Createelement('AliquotaIVA')
               oChildnode.Text = iif(!Isempty(oXmlritenute.Natura_enasarco),'0.00',AllTrim(Transform(Xdefault(oXmlritenute.Aliquotaiva,0),'####.##')))
               oSubnode.Appendchild(oChildnode)
               if !Isempty(oXmlritenute.Natura_enasarco) or Isempty(oXmlritenute.Aliquotaiva)
                  oChildnode = oDomdoc.Createelement('Natura')
                  oChildnode.Text = Xdefault(oXmlritenute.Natura_enasarco,oXmlritenute.Natura)
                  oSubnode.Appendchild(oChildnode)
               endif
               oRefnode = oDomdoc.Createelement('AltriDatiGestionali')
               oChildnode = oDomdoc.Createelement('TipoDato')
               oChildnode.Text = 'CASSA-PREV'
               oRefnode.Appendchild(oChildnode)
               oChildnode = oDomdoc.Createelement('RiferimentoTesto')
               oChildnode.Text = Xdefault(oXmlritenute.Tipocassaprevidenza,'TC07')+' - ENASARCO'
               oRefnode.Appendchild(oChildnode)
               oChildnode = oDomdoc.Createelement('RiferimentoNumero')
               oChildnode.Text = AllTrim(Transform(-oXmlritenute.Importoenasarco,'##########.##'))
               oRefnode.Appendchild(oChildnode)
               oSubnode.Appendchild(oRefnode)
               oNode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiBeniServizi')
               oRefnode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo')
               if VarType(oRefnode)=='O'
                  oNode.Insertbefore(oSubnode,oRefnode)
               else
                  oNode.Appendchild(oSubnode)
               endif
               if !Isempty(oXmlritenute.Natura_enasarco)
                  oNodes = oDomdoc.Documentelement.Selectnodes('FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo')
                  local Lfoundriepilogo4enasarco
                  Lfoundriepilogo4enasarco = .F.
                  for each oNode in oNodes
                     oSubnode = oNode.Selectsinglenode('AliquotaIVA')
                     if VarType(oSubnode)='O'
                        if Empty(Val(oSubnode.Text))
                           oSubnode = oNode.Selectsinglenode('Natura')
                           if VarType(oSubnode)='O' and oSubnode.Text=oXmlritenute.Natura_enasarco
                              Lfoundriepilogo4enasarco = .T.
                              exit
                           endif
                        endif
                     endif
                  endfor
                  if !Lfoundriepilogo4enasarco
                     oSubnode = oDomdoc.Createelement('DatiRiepilogo')
                     oChildnode = oDomdoc.Createelement('AliquotaIVA')
                     oChildnode.Text = '0.00'
                     oSubnode.Appendchild(oChildnode)
                     oChildnode = oDomdoc.Createelement('Natura')
                     oChildnode.Text = oXmlritenute.Natura_enasarco
                     oSubnode.Appendchild(oChildnode)
                     oChildnode = oDomdoc.Createelement('ImponibileImporto')
                     oChildnode.Text = '0.00'
                     oSubnode.Appendchild(oChildnode)
                     oChildnode = oDomdoc.Createelement('Imposta')
                     oChildnode.Text = '0.00'
                     oSubnode.Appendchild(oChildnode)
                     oNode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiBeniServizi')
                     oNode.Appendchild(oSubnode)
                  endif
               endif
            endif
         endif
         Cxml = oDomdoc.Xml
      endif
      return Cxml
   endproc
   
   
enddefine
