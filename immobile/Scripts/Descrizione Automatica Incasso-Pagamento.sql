--MODIFICHE per Descrizione Automatica di INCASSO/PAGAMENTO
exec dbo.asp_du_AddAlterColumn 'CGCausale', 'xDescrizioneTipo', 'Char(1) null', '', 'Tipo Descrizione Auto - F o C'

exec dbo.asp_du_DropTrigger 'xCGMovR_Desc_ins'
GO
Create Trigger [dbo].[xCGMovR_Desc_ins] On [dbo].[CGMovR] For Insert
As Begin

	Update CGMovR
		Set Note_CGMovR = 'Pag Ft nr ' + ltrim(rtrim(Inserted.PartNum)) + ' di ' + ltrim(rtrim(CF.Descrizione))
	From Inserted
		inner join CGMovR on inserted.Id_CGMovR = CGMovR.Id_CGMovR 
		Inner Join CGMovT On CGMovR.Id_CGMovT = CGMovT.Id_CGMovT
		inner join CGCausale on CGMovT.Cd_CGCausale = CGCausale.Cd_CGCausale and CGCausale.xDescrizioneTipo = 'F'
		Inner join CF on CGMovR.Cd_CF = CF.Cd_CF and CGMovR.Cd_CF like 'F%'

	Update CGMovR
		Set Note_CGMovR = 'Inc Ft nr ' + ltrim(rtrim(CGMovR.PartNum)) + ' di ' + ltrim(rtrim(CF.Descrizione))
	From Inserted
		inner join CGMovR on inserted.Id_CGMovR = CGMovR.Id_CGMovR 
		Inner Join CGMovT On CGMovR.Id_CGMovT = CGMovT.Id_CGMovT
		inner join CGCausale on CGMovR.Cd_CGCausale = CGCausale.Cd_CGCausale and CGCausale.xDescrizioneTipo = 'C'
		Inner join CF on CGMovR.Cd_CF = CF.Cd_CF and CGMovR.Cd_CF like 'C%'

End
GO
--EXEC sp_settriggerorder @triggername= 'xCGMovR_Desc_ins', @order='Last', @stmttype = 'INSERT';
EXEC sp_settriggerorder @triggername= 'xCGMovR_Desc_ins', @order='NONE', @stmttype = 'INSERT';
GO
