--MODIFICHE per Descrizione Automatica di INCASSO/PAGAMENTO
exec dbo.asp_du_DropTrigger 'xCGMovR_ContoCHG'
GO
Create Trigger [dbo].[xCGMovR_ContoCHG] On [dbo].[CGMovR] For Update
As Begin

	Update DORIG
		Set Cd_CGConto = DIFF.Conto_NEW,
		Cd_CAVda = DIFF.Cd_CAVda,
		Cd_CACda = DIFF.Cd_CACda
	FROM DORig inner join
	(SELECT inserted.Cd_CGConto Conto_NEW, deleted.Cd_CGConto Conto_OLD, CGMovT.Id_DOTes, deleted.Cd_SottoCommessa, 
		inserted.Cd_CACda, inserted.Cd_CAVda
	From deleted
		inner join inserted on deleted.Id_CGMovR = inserted.Id_CGMovR and deleted.Cd_CGConto <> inserted.Cd_CGConto
		Inner Join CGMovT On inserted.Id_CGMovT = CGMovT.Id_CGMovT) DIFF
		ON DORig.Id_DOTes = DIFF.Id_DOTes AND DORig.Cd_CGConto = DIFF.Conto_OLD
			--AND ((DORig.Cd_CACda = DIFF.Cd_CACda) OR (DORig.Cd_CACda IS NULL AND DIFF.Cd_CACda IS NULL)) 
			--AND ((DORig.Cd_CAVda = DIFF.Cd_CAVda) OR (DORig.Cd_CAVda IS NULL AND DIFF.Cd_CAVda IS NULL)) 
			AND ((DORig.Cd_DOSottoCommessa = DIFF.Cd_SottoCommessa) OR (DORig.Cd_DOSottoCommessa IS NULL AND DIFF.Cd_SottoCommessa IS NULL))

End
GO
EXEC sp_settriggerorder @triggername= 'xCGMovR_ContoCHG', @order='NONE', @stmttype = 'UPDATE';
GO
