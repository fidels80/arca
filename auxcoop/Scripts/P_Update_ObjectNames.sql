
If( Object_Id('Update_ObjectNames') Is Not Null)
begin 
Drop Procedure Update_ObjectNames
end 
Go



CREATE or alter Procedure [sft].[Update_ObjectNames] 
As

	-- Aggiorna la tabella dei nomi corretti per case necessaria all'ORM

	-- Colonne
	Insert sft.ObjectNames (ObjectType, ObjectName)
	Select Distinct 'CO', ColName From dbo.du_si_Columns(1) 
	Where ColName Not In (Select ObjectName From sft.ObjectNames Where ObjectType = 'CO')

	Delete From sft.ObjectNames 
	Where ObjectType = 'CO' And ObjectName Not In (Select Distinct ColName From dbo.du_si_Columns(1))

	-- Tabelle
	Insert sft.ObjectNames (ObjectType, ObjectName)
	Select Distinct 'U', TblName From dbo.du_si_Tables(1) 
	Where TblName Not In (Select ObjectName From sft.ObjectNames Where ObjectType = 'U')

	Delete -- Select *
	From sft.ObjectNames 
	Where ObjectType = 'U' And ObjectName Not In (Select Distinct TblName From dbo.du_si_Tables(1))

	-- View
	Insert sft.ObjectNames (ObjectType, ObjectName)
	Select Distinct 'V', VieName From dbo.du_si_Views(1) 
	Where VieName Not In (Select ObjectName From sft.ObjectNames Where ObjectType = 'V')

	Delete -- Select *
	From sft.ObjectNames 
	Where ObjectType = 'V' And ObjectName Not In (Select Distinct VieName From dbo.du_si_Views(1))



Go
