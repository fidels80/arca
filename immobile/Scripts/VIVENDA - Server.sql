exec dbo.asp_du_AddAlterColumn 'DO', 'xAggiornaUltimoCosto', 'bit not null', '0', 'xAggiornaUltimoCosto'
exec dbo.asp_du_AddAlterColumn 'DORig', 'xCostoAcquisto', 'Numeric(18,6) null', '0', 'xCostoAcquisto'

exec dbo.asp_du_DropFunction 'xARCostoUltimoEng'
GO
CREATE FUNCTION [dbo].[xARCostoUltimoEng] (@DATA DateTime = Null, @CD_AR varchar(20))
Returns Table
As
Return

Select DoRig.Cd_AR, DoRig.Id_DoRig, 
	xCostoAcquisto As  ValoreE,
	Convert(Text, dbo.afn_FormatNumeroDoc_ById(DoRig.Id_DoTes))  As  Info
From DoRig
	Join (Select Max(Convert(Binary(2), Convert(Integer,DataDoc))  + Convert(Binary(4), Id_DoRig)) As DataDoc_IdDoRig  
			From Do Join DoRig On DoRig.Cd_Do = Do.Cd_Do
			 Where Do.xAggiornaUltimoCosto  = 1 
				And ((@CD_AR Is null and DoRig.Cd_AR is not null) or DoRig.Cd_AR= @CD_AR)
				And DoRig.PrezzoTotaleE > 0
				And DoRig.xCostoAcquisto > 0
				And DoRig.TipoPC != 'C'
				And (@DATA Is Null Or DoRig.DataDoc <= @DATA)
				And DoRig.Esecutivo = 1
 			Group By Cd_AR) X On DoRig.Id_DoRig = Convert(Integer, Substring(X.DataDoc_IdDoRig, 3,4))
GO

exec dbo.asp_du_DropProcedure 'xasp_ARCostoUltimoEng_Update'
GO
CREATE PROCEDURE [dbo].[xasp_ARCostoUltimoEng_Update] (@DATA Datetime = Null, @CD_AR varchar(20) = NULL) 
As 
Declare @ESERCIZIO Varchar(4)
Declare @TIPO_COSTO Char(1)
Declare @DESCR_COSTO Varchar(50)
Declare @DESCR_COSTO_DB Varchar(50)
Declare @DECIMALI Tinyint 
Declare @VALORE Numeric(18,6)
DECLARE @INFO Varchar(MAX)

Select @DATA = IsNull(@DATA, GetDate()),
	@ESERCIZIO = dbo.afn_MGEsercizio(@DATA),
	@TIPO_COSTO ='U',
	@DESCR_COSTO = 'Costo Ultimo',
	@DESCR_COSTO_DB = 'DB a Costo Ultimo',
	@DECIMALI =IsNull((Select DecimaliPrzUn From VL Where Cd_VL= 'EUR'), 2)

Begin Tran
	If Not Exists(Select * From ARCosto Where TipoCosto = @TIPO_COSTO And Cd_MGEsercizio = @ESERCIZIO) 
	Begin
		Insert Into ARCosto(TipoCosto, DataVal, Cd_MGEsercizio,Descrizione)
		Values(@TIPO_COSTO, @DATA, @ESERCIZIO, @DESCR_COSTO)
	End

	If Not Exists(Select * From ARCostoDB Where TipoCosto = @TIPO_COSTO And Cd_MGEsercizio = @ESERCIZIO) 
	Begin
		Insert Into ARCostoDB(TipoCosto, DataVal, DataDB, Cd_MGEsercizio,Descrizione)
		Values(@TIPO_COSTO, @DATA, @DATA, @ESERCIZIO, @DESCR_COSTO_DB)
	End
	--IF ISNULL(@CD_AR, '') <> ''
	--BEGIN
		SELECT @VALORE = Round(ValoreE, @DECIMALI), @INFO = INFO
		FROM xARCostoUltimoEng(@DATA, @CD_AR)
		Where ValoreE > 0

		IF ISNULL(@VALORE, 0) > 0 AND ISNULL(@CD_AR, '') <> ''
		BEGIN
			Delete ARCostoItem Where TipoCosto = @TIPO_COSTO And Cd_MGEsercizio = @ESERCIZIO and cd_ar = @CD_AR
			Delete ARCostoDBItem Where TipoCosto = @TIPO_COSTO And Cd_MGEsercizio = @ESERCIZIO  and cd_ar = @CD_AR
	
			Insert Into ARCostoItem(TipoCosto, Cd_MGEsercizio, Cd_AR, Costo,Info)
			VALUES (@TIPO_COSTO, @ESERCIZIO, @CD_AR, @VALORE, @INFO)

			Insert Into ARCostoDBItem(TipoCosto, Cd_MGEsercizio, Cd_AR, CostoDB, CostoDbMateriale, CostoDbLavorazione, CostoDbAttrezzaggio)
			VALUES (@TIPO_COSTO, @ESERCIZIO, @CD_AR, @VALORE, @VALORE, 0, 0)
		END
	--END
Commit Tran
GO

exec asp_du_DropTrigger 'xDORig_trg_iu'
GO
CREATE Trigger [dbo].[xDORig_trg_iu] On [dbo].[DORig]
For Insert, Update, Delete
As Begin

	If Trigger_NestLevel() <= 2
	Begin
		declare @COD varchar(20), @DT as date
/*
		declare ART CURSOR FOR 
		SELECT DISTINCT CD_AR, DataDoc FROM
		(SELECT distinct isnull(inserted.CD_AR, deleted.Cd_AR) as CD_AR,
			isnull(inserted.CD_DO, deleted.CD_DO) as CD_DO, isnull(inserted.DataDoc, deleted.DataDoc) as DataDoc
			from inserted
			full outer join deleted on inserted.Cd_AR = deleted.Cd_AR
			and isnull(inserted.xCostoAcquisto, deleted.xCostoAcquisto) > 0) A
			inner join DO on A.cd_do = Do.cd_do and do.xAggiornaUltimoCosto = 1
*/		
		declare ART CURSOR FOR 
		SELECT DISTINCT CD_AR, DataDoc 
		FROM inserted inner join DO on inserted.cd_do = Do.cd_do and do.xAggiornaUltimoCosto = 1
		WHERE isnull(inserted.xCostoAcquisto, 0) > 0 and inserted.cd_ar is not null

		OPEN ART
		FETCH NEXT FROM ART
		INTO @COD, @DT
		WHILE @@FETCH_STATUS = 0  
		BEGIN
			exec xasp_ARCostoUltimoEng_Update @DT, @COD
			FETCH NEXT FROM ART
			INTO @COD, @DT
		END
		CLOSE ART  
		DEALLOCATE ART
	End
End
GO
EXEC sp_settriggerorder @triggername=N'[dbo].[xDORig_trg_iu]', @order=N'Last', @stmttype=N'INSERT'
GO
EXEC sp_settriggerorder @triggername=N'[dbo].[xDORig_trg_iu]', @order=N'Last', @stmttype=N'UPDATE'
GO
EXEC sp_settriggerorder @triggername=N'[dbo].[xDORig_trg_iu]', @order=N'Last', @stmttype=N'DELETE'
GO

----NUOVE PERSONALIZZAZIONI LUGLIO 2018
exec dbo.asp_du_AddAlterColumn 'DORig', 'xTotCosto', 'Numeric(18,6) null', '0', 'xTotCosto'
exec dbo.asp_du_AddAlterColumn 'AR', 'xPerc', 'Numeric(18,6) null', '0', 'Perc'
exec dbo.asp_du_AddAlterColumn 'DO', 'xAddRigaPerc', 'bit not null', '0', 'Add Riga Perc'
exec dbo.asp_du_AddAlterColumn 'DOTes', 'cd_xEmailAttach', 'varchar(20) null', '', 'Codice allegati'
exec dbo.asp_du_AddAlterColumn 'DoRig', 'xRigaPercRif', 'int null', '0', 'xRigaPercRif'

IF dbo.afn_du_IsTable('xEmailAttach') = 0
	EXEC asp_du_AddTable 'xEmailAttach', 20, 'Allegati per Email'

EXEC asp_du_AddAlterColumn 'xEmailAttach', 'Descrizione', 'VARCHAR(80) NOT NULL', '', 'Descrizione'

EXEC asp_du_DropIndex 'xEmailAttach', 'IX_xEmailAttach_Descrizione'
CREATE  INDEX IX_xEmailAttach_Descrizione ON xEmailAttach(Descrizione)

EXEC asp_du_DropConstraint 'xEmailAttach', 'CK_xEmailAttach_Cd_xEmailAttach'
ALTER TABLE xEmailAttach ADD CONSTRAINT CK_xEmailAttach_Cd_xEmailAttach CHECK ([Cd_xEmailAttach]<>'')

EXEC asp_du_DropConstraint 'DoTes', 'FK_DoTes_xEmailAttach'
ALTER TABLE DoTes ADD CONSTRAINT FK_DoTes_xEmailAttach FOREIGN KEY (Cd_xEmailAttach) REFERENCES xEmailAttach(Cd_xEmailAttach)

IF dbo.afn_du_IsTable('xEmailAttach_Dett') = 0
	EXEC asp_du_AddTable 'xEmailAttach_Dett', 0, 'xEmailAttach_Dett'

EXEC asp_du_AddAlterColumn 'xEmailAttach_Dett', 'Cd_xEmailAttach', 'VARCHAR(20) NOT NULL', '', 'Cd_xEmailAttach'
EXEC asp_du_AddAlterColumn 'xEmailAttach_Dett', 'Id_DmsDocument', 'INT NOT NULL', '', 'Id Dms'

EXEC asp_du_DropConstraint 'xEmailAttach_Dett', 'FK_xEmailAttach_Dett_DMSDOCUMENT'
ALTER TABLE xEmailAttach_Dett ADD CONSTRAINT FK_xEmailAttach_Dett_DMSDOCUMENT FOREIGN KEY (Id_DmsDocument) REFERENCES DmsDocument(Id_DmsDocument)

EXEC asp_du_DropConstraint 'xEmailAttach_Dett', 'FK_xEmailAttach_Dett_xEmailAttach'
ALTER TABLE xEmailAttach_Dett ADD CONSTRAINT FK_xEmailAttach_Dett_xEmailAttach FOREIGN KEY (Cd_xEmailAttach) REFERENCES xEmailAttach(Cd_xEmailAttach)

exec dbo.asp_du_AddAlterColumn 'DO', 'xBlocco_NumDoc', 'int null', '0', 'Numero Doc per Blocco'
exec dbo.asp_du_AddAlterColumn 'DO', 'xBlocco', 'bit null', '0', 'Bloccante o no'
exec dbo.asp_du_AddAlterColumn 'DOTes', 'xFatturaCliente', 'varchar(100) null', '', 'Fattura Cliente'
exec dbo.asp_du_AddAlterColumn 'DOTes', 'xID_FatturaCliente', 'INT null', '', 'ID Fattura Cliente'

EXEC asp_du_DropConstraint 'DOTes', 'FK_DOTes_DOTes_xFatCli'
ALTER TABLE DOTes ADD CONSTRAINT FK_DOTes_DOTes_xFatCli FOREIGN KEY (xID_FatturaCliente) REFERENCES DOTes(id_Dotes)

---MODIFICHE OTTOBRE
exec dbo.asp_du_AddAlterColumn 'CF', 'xNOControlloNumDOC', 'bit null', '0', 'Flag Controllo cliente per Numero DOC'

--MODIFICHE DEL 14-02-2019
exec dbo.asp_du_AddAlterColumn 'DO', 'xRigaTOT_MD', 'bit not null', '0', 'xRigaTOT_MD'



--MODIFICHE DEL 20-03-2019
Exec asp_du_AddAlterColumn 'DORig', 'xInserzione', 'varchar(20) null', '', 'Nr Inserzione'

--Modifica AR x visualizzare i prezzi di listino degli Articoli nell'elenco
Exec asp_du_AddAlterColumn 'LS', 'xMostraInElencoAR', 'bit not null', '0', 'Mostra In Elenco ARTICOLI'
Exec asp_du_dropfunction 'xfn_EnumeraStmtListini_Select'
Exec asp_du_dropfunction 'xfn_EnumeraStmtListini_From'
Go

Create Function xfn_EnumeraStmtListini_Select ()
Returns varchar(max)
As Begin
	Declare @Ret varchar(max)
	
	Select @Ret = ''
	
	Select @Ret = @Ret + Case When @Ret <> '' Then ', ' + CHAR(13) + CHAR(10) Else '' End +
					'[LS_' + rtrim(Convert(varchar(7), LS.Cd_LS)) + '].Prezzo As [xLS_' + rtrim(Convert(varchar(7), LS.Cd_LS)) + ']'
		From LS
		where xMostraInElencoAR = 1
		Order By LS.Cd_LS

	If @Ret = '' 
		Select @Ret = Null
		
	Return @Ret
End
Go

Grant Execute On xfn_EnumeraStmtListini_Select To Arca_Admins, Arca_PowerUsers, Arca_Users, Arca_Readers With Grant Option
Go

Create Function xfn_EnumeraStmtListini_From ()
Returns varchar(max) 
As Begin
	Declare @Ret varchar(max)
	
	Select @Ret = ''
	
	Select @Ret = @Ret + Case When @Ret <> '' Then CHAR(13) + CHAR(10) Else '' End +
					'Left Join LSArticolo [LS_' + rtrim(Convert(varchar(7), LS.Cd_LS)) + '] On [LS_' + rtrim(Convert(varchar(7), LS.Cd_LS)) + '].Id_LSRevisione = dbo.afn_GetLSRevisione(''' + Convert(varchar(7), LS.Cd_LS) + ''', GetDate()) And [LS_' + rtrim(Convert(varchar(7), LS.Cd_LS)) + '].Cd_AR = AR.Cd_AR'
		From LS
		where xMostraInElencoAR = 1
		Order By LS.Cd_LS

	If @Ret = '' 
		Select @Ret = Null
	
	Return @Ret
End
Go

Grant Execute On xfn_EnumeraStmtListini_From To Arca_Admins, Arca_PowerUsers, Arca_Users, Arca_Readers With Grant Option
Go

--MODIFICHE DEL 01-04-2019
exec dbo.asp_du_AddAlterColumn 'CF', 'xBlocco_NumDoc', 'int null', '0', 'Numero Doc per Blocco'

exec dbo.asp_du_AddAlterColumn 'DOTes', 'xRighe_Ribaltamento', 'int null', '0', 'Righe Ribaltamento'
exec dbo.asp_du_AddAlterColumn 'CGMovT', 'xRighe_Ribaltamento', 'int null', '0', 'Righe Ribaltamento'

exec dbo.asp_du_AddAlterColumn 'SC', 'xID_OC_Ribaltamento', 'int null', '', 'Id OC Creato'
exec dbo.asp_du_AddAlterColumn 'DORig', 'xID_DOC_Ribaltato', 'int null', '', 'Id DOC Ribaltato'
exec dbo.asp_du_AddAlterColumn 'DORig', 'xID_MOV_Ribaltato', 'int null', '', 'Id MOV Ribaltato'
exec dbo.asp_du_AddAlterColumn 'CGMovT', 'xID_OC_Ribaltamento', 'int null', '', 'Id OC Creato'
exec dbo.asp_du_AddAlterColumn 'CGConto', 'xCD_DOSottocommessa', 'varchar(20) null', '', 'Sottocommessa'
GO

EXEC asp_du_DropConstraint 'SC', 'xFK_SC_DOTes_Rib'
GO
ALTER TABLE SC ADD CONSTRAINT xFK_SC_DOTes_Rib FOREIGN KEY (xID_OC_Ribaltamento) REFERENCES DOTes(id_Dotes) on delete set default
GO

EXEC asp_du_DropConstraint 'CGMovT', 'xFK_CGMovT_DOTes_Rib'
GO
ALTER TABLE CGMovT ADD CONSTRAINT xFK_CGMovT_DOTes_Rib FOREIGN KEY (xID_OC_Ribaltamento) REFERENCES DOTes(id_Dotes)
GO

EXEC asp_du_DropConstraint 'DORig', 'xFK_DORig_DOTes_RibD'
GO
ALTER TABLE DORig ADD CONSTRAINT xFK_DORig_DOTes_RibD FOREIGN KEY (xID_DOC_Ribaltato) REFERENCES CGMovT(id_CGMovT)
GO

EXEC asp_du_DropConstraint 'DORig', 'xFK_DORig_DOTes_RibM'
GO
ALTER TABLE DORig ADD CONSTRAINT xFK_DORig_DOTes_RibM FOREIGN KEY (xID_MOV_Ribaltato) REFERENCES CGMovT(id_CGMovT)
GO

EXEC asp_du_DropConstraint 'CGConto', 'xFK_CGConto_DOSottocommessa'
GO
ALTER TABLE CGConto ADD CONSTRAINT xFK_CGConto_DOSottocommessa FOREIGN KEY (xCD_DOSottocommessa) REFERENCES DOSottocommessa(CD_DOSottocommessa)
GO

exec asp_du_DropTrigger 'xDOTes_trg_delRIB'
GO

CREATE Trigger [dbo].[xDOTes_trg_delRIB] On [dbo].[DOTes]
INSTEAD OF Delete
As Begin
	/*
	update DOTes
	set xRighe_Ribaltamento = xRighe_Ribaltamento - ISNULL(A.TOT, 0)
	from DOTes inner join
	(Select distinct DORig.xID_DOC_Ribaltato, count(*) as TOT
	from deleted
		inner join dorig on deleted.Id_DOTes = DORig.Id_DOTes
	group by DORig.xID_DOC_Ribaltato) A on DOTes.Id_DoTes = A.xID_DOC_Ribaltato
	*/
	update CGMovT
	set xRighe_Ribaltamento = xRighe_Ribaltamento - ISNULL(A.TOT, 0)
	from CGMovT inner join 
	(Select distinct DORig.xID_DOC_Ribaltato, count(*) as TOT
	from deleted
		inner join dorig on deleted.Id_DOTes = DORig.Id_DOTes
	group by DORig.xID_DOC_Ribaltato) A on CGMovT.Id_CGMovT = A.xID_DOC_Ribaltato

	update CGMovT
	set xRighe_Ribaltamento = xRighe_Ribaltamento - ISNULL(A.TOT, 0)
	from CGMovT inner join 
	(Select distinct DORig.xID_MOV_Ribaltato, count(*) as TOT
	from deleted
		inner join dorig on deleted.Id_DOTes = DORig.Id_DOTes
	group by DORig.xID_MOV_Ribaltato) A on CGMovT.Id_CGMovT = A.xID_MOV_Ribaltato

	update SC
	set xID_OC_Ribaltamento = NULL
	from SC inner join
		deleted on SC.xID_OC_Ribaltamento = deleted.Id_DOTes
		
	update CGMovT
	set xID_OC_Ribaltamento = NULL
	from CGMovT inner join
		deleted on CGMovT.xID_OC_Ribaltamento = deleted.Id_DOTes

	Delete DOtes where Id_DoTes in (select Id_DoTes from deleted)
End
GO

exec asp_du_DropTrigger 'xDOTes_trg_insOGG'
GO
CREATE Trigger [dbo].[xDOTes_trg_insOGG] On [dbo].[DOTes]
FOR Insert
As Begin
	DECLARE @NOTAVAL VARCHAR(max)
	DECLARE @NOTAXML INT
	DECLARE @ID INT
	DECLARE @nota VARCHAR(max)
	DECLARE @NotaX VARCHAR(max)

	declare Teste cursor for select id_dotes from inserted

	OPEN Teste  
  
	FETCH NEXT FROM Teste INTO @ID  
  
	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		select @nota = isnull(rtrim(ltrim(Nota)),'')
		from DoTesDoNota inner join DONota 
			on DoTesDoNota.Id_Nota = DONota.Id_Nota and DONota.Cd_Nota = 'OGG'  
		where Id_DoTes = @ID

		if len(@nota) > 0
		BEGIN
			SELECT @NotaX = @nota

			select @NOTAVAL = isnull(ltrim(rtrim(FTE_Xml.value('(/rows/row)[1]/@dg_causale', 'varchar(max)'))),'')
			from dotes 
			where Id_DoTes = @ID

			select @NOTAXML=count(*) FROM dotes where Id_DoTes = @ID and FTE_Xml is not null

			if @NOTAXML = 0
			BEGIN
				UPDATE DOTes SET FTE_Xml='<rows><row dg_causale=""></row></rows>' WHERE Id_DoTes = @ID
			END

			if len(@NOTAVAL) > 0
				SELECT @NotaX = @NotaX + ' ' + @NOTAVAL

			UPDATE DOTES 
			SET FTE_Xml.modify('replace value of (/rows/row)[1]/@dg_causale with sql:variable("@NotaX")') 
			WHERE Id_DoTes = @ID

		END
		
		FETCH NEXT FROM Teste INTO @ID 
	END   
	CLOSE Teste;  
	DEALLOCATE Teste;  
End
GO
EXEC sp_settriggerorder @triggername= 'xDOTes_trg_insOGG', @order='Last', @stmttype = 'INSERT';
GO

exec asp_du_DropTrigger 'xDORig_trg_RIB'
GO
CREATE Trigger [dbo].[xDORig_trg_RIB] On [dbo].[DORig]
FOR Insert
As Begin
	update DOTes
	set xRighe_Ribaltamento = ISNULL(A.TOT, 0)
	from DOTes inner join
	(Select distinct DORig.xID_DOC_Ribaltato, count(*) as TOT
	from DORig
		inner join inserted on inserted.xID_DOC_Ribaltato = DORig.xID_DOC_Ribaltato
	group by DORig.xID_DOC_Ribaltato) A on DOTes.Id_DoTes = A.xID_DOC_Ribaltato

	update CGMovT
	set xRighe_Ribaltamento = ISNULL(A.TOT, 0)
	from CGMovT inner join 
	(Select DORig.xID_MOV_Ribaltato, count(*) as TOT
	from DORig
		inner join inserted on inserted.xID_MOV_Ribaltato = DORig.xID_MOV_Ribaltato
	group by DORig.xID_MOV_Ribaltato) A on CGMovT.Id_CGMovT = A.xID_MOV_Ribaltato

End
GO


--MODIFICHE DEL 30/04/2019 PER SALVARE I CAMPI PREZZO E COSTO PRIMA DI AZZERARLI NELLA XASP_DO_COMMIT
exec dbo.asp_du_AddAlterColumn 'DORig', 'xCostoAcquisto_Copy', 'Numeric(18,6) null', '0', 'xCostoAcquisto Copia'
exec dbo.asp_du_AddAlterColumn 'DORig', 'xPrezzoUnitarioV_Copy', 'Numeric(18,6) null', '0', 'xPrezzoUnitarioV Copia'