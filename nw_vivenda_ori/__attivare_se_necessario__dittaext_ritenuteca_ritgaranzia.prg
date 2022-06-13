
*/------------------------------------------------------------------------------
*/ __attivare_se_necessario__dittaext_ritenuteca_ritgaranzia.fxp
*/------------------------------------------------------------------------------


*/==============================================================================
define class DittaExt as Session
*/==============================================================================
   Name = 'DittaExt_RitenuteCA_RitGaranzia'
   */------------------------------------------------------------------------------
   procedure OnCreateFTE_XML
   */------------------------------------------------------------------------------
      lparameters Nid_dotes, Cxml
      local oDomdoc as MSXML2.DOMDocument40
      local oNodes as MSXML2.IXMLDOMNodeList, oNode as MSXML2.IXMLDOMNode, oSubnode as MSXML2.IXMLDOMNode, oRefnode as MSXML2.IXMLDOMNode, oChildnode as MSXML2.IXMLDOMNode
      local oXmlritenute, Cstmt
      local oRitdoc as MSXML2.DOMDocument40, Nnode
      text 28 F7 09 00 60 CE FE


			DECLARE @AliquotaIVA Numeric(18, 6), @Natura char(2)
			
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


			Select
				Convert(Numeric(18, 2), DOTotali.xTotaleRitenutaAccontoE) As ImportoRitenuta,
				Convert(Numeric(18, 2), DOTes.xPercentualeRitenuta) As AliquotaRitenuta,
				Convert(Numeric(18, 2), DOTes.xPercentualeImponibileRitenuta) As AliquotaImponibileRitenuta,
				@AliquotaIVA AS AliquotaIVA,
				@Natura As Natura
			From DOTotali
				Inner Join DOTes On DOTes.Id_DOTes = DOTotali.Id_DOTes
				Inner Join Preferenza On 1=1
				Inner Join Ditta On 1=1
				Left Join TipoReddito On TipoReddito.Cd_TipoReddito = Preferenza.xCd_TipoReddito_Ritenuta
			Where DOTes.xCalcolaRitenuta = 1 And DOTotali.xTotaleRitenutaAccontoE != 0 And DOTes.Id_DOTes = <<Format4Spt(nId_DOTes)>>


      endtext
      oXmlritenute = Xsqlexec2obj(Cstmt)
      if VarType(oXmlritenute)<>'O' or Isempty(oXmlritenute.Importoritenuta)
         return Cxml
      endif
      oDomdoc = Newdomdocument(Cxml)
      if VarType(oDomdoc)='O'
         oNode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento')
         if VarType(oNode)=='O'
            oRitnode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiGenerali/DatiGeneraliDocumento/DatiRitenuta')
            if VarType(oRitnode)=='O'
               oNode.Removechild(oRitnode)
            endif
         endif
         oNodes = oDomdoc.Documentelement.Selectnodes('FatturaElettronicaBody/DatiBeniServizi/DettaglioLinee')
         if VarType(oNodes)='O' and oNodes.Length>0
            local Nriga
            Nriga = 0
            for each oNode in oNodes
               oSubnode = oNode.Selectsinglenode('NumeroLinea')
               Nriga = Max(Nriga,iif(VarType(oSubnode)='O',Val(oSubnode.Text),0))
            endfor
            if VarType(oXmlritenute)='O'
               oSubnode = oDomdoc.Createelement('DettaglioLinee')
               oChildnode = oDomdoc.Createelement('NumeroLinea')
               oChildnode.Text = Transform(Nriga+1)
               oSubnode.Appendchild(oChildnode)
               oChildnode = oDomdoc.Createelement('Descrizione')
               oChildnode.Text = 'Riga ausiliaria per ritenuta a garanzia'
               oSubnode.Appendchild(oChildnode)
               oChildnode = oDomdoc.Createelement('PrezzoUnitario')
               oChildnode.Text = '0.00'
               oSubnode.Appendchild(oChildnode)
               oChildnode = oDomdoc.Createelement('PrezzoTotale')
               oChildnode.Text = '0.00'
               oSubnode.Appendchild(oChildnode)
               oChildnode = oDomdoc.Createelement('AliquotaIVA')
               oChildnode.Text = AllTrim(Transform(Xdefault(oXmlritenute.Aliquotaiva,0),'####.##'))
               oSubnode.Appendchild(oChildnode)
               if Isempty(oXmlritenute.Aliquotaiva)
                  oChildnode = oDomdoc.Createelement('Natura')
                  oChildnode.Text = Xdefault(oXmlritenute.Natura,'N3')
                  oSubnode.Appendchild(oChildnode)
               endif
               oRefnode = oDomdoc.Createelement('AltriDatiGestionali')
               oChildnode = oDomdoc.Createelement('TipoDato')
               oChildnode.Text = 'RITE-GARAN'
               oRefnode.Appendchild(oChildnode)
               oChildnode = oDomdoc.Createelement('RiferimentoTesto')
               oChildnode.Text = 'Trattenute a garanzia DPR 207/2010 '
               oRefnode.Appendchild(oChildnode)
               oChildnode = oDomdoc.Createelement('RiferimentoNumero')
               oChildnode.Text = AllTrim(Transform(-oXmlritenute.Importoritenuta,'##########.##'))
               oRefnode.Appendchild(oChildnode)
               oSubnode.Appendchild(oRefnode)
               oNode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiBeniServizi')
               oRefnode = oDomdoc.Documentelement.Selectsinglenode('FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo')
               if VarType(oRefnode)=='O'
                  oNode.Insertbefore(oSubnode,oRefnode)
               else
                  oNode.Appendchild(oSubnode)
               endif
               if Isempty(oXmlritenute.Aliquotaiva)
                  oNodes = oDomdoc.Documentelement.Selectnodes('FatturaElettronicaBody/DatiBeniServizi/DatiRiepilogo')
                  local Lfoundriepilogo4ritenuta
                  Lfoundriepilogo4ritenuta = .F.
                  for each oNode in oNodes
                     oSubnode = oNode.Selectsinglenode('AliquotaIVA')
                     if VarType(oSubnode)='O'
                        if Empty(Val(oSubnode.Text))
                           oSubnode = oNode.Selectsinglenode('Natura')
                           if VarType(oSubnode)='O' and oSubnode.Text=Xdefault(oXmlritenute.Natura,'N3')
                              Lfoundriepilogo4ritenuta = .T.
                              exit
                           endif
                        endif
                     endif
                  endfor
                  if !Lfoundriepilogo4ritenuta
                     oSubnode = oDomdoc.Createelement('DatiRiepilogo')
                     oChildnode = oDomdoc.Createelement('AliquotaIVA')
                     oChildnode.Text = '0.00'
                     oSubnode.Appendchild(oChildnode)
                     oChildnode = oDomdoc.Createelement('Natura')
                     oChildnode.Text = Xdefault(oXmlritenute.Natura,'N3')
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
