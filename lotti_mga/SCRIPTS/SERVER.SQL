Exec asp_du_DropView 'xvw_ARKit'
Go

Create View xvw_ARKit
As
	Select Distinct
		M.Id_DORig,
		M.Id_DOTes,
		R.Cd_AR,
		M.Matricola
	From dbo.DoRigMatricola M
		Inner Join dbo.DORig R On R.Id_DORig = M.Id_DoRig
		Inner Join dbo.DOTes T On T.Id_DOTes = M.Id_DOTes
	Where T.Cd_DO = 'KC' And R.TipoPC = 'P'
Go

Exec asp_du_DropView 'xvw_ARKitMateriale'
Go

Create View xvw_ARKitMateriale
As
	Select Distinct
		K.Id_DORig As ID_Kit,
		ROW_NUMBER() Over (Partition By K.Id_DORig Order By K.Id_DORig, R.Cd_AR, R.Cd_ARLotto) As Sequenza,
		R.Cd_AR,
		R.Cd_ARLotto,
		K.Cd_AR As Cd_AR_Kit,
		K.Matricola
	From dbo.DoRigMatricola M
		Inner Join dbo.DOTes T On T.Id_DOTes = M.Id_DOTes
		Inner Join dbo.DORig MR On MR.Id_DORig = M.Id_DoRig
		Left Join dbo.DORig MRN On MRN.Id_DORig = (Select Top 1 P.Id_DORig From DORig P Where P.TipoPC <> 'C' And P.Id_DOTes = MR.Id_DOTes And P.Riga > MR.Riga Order By P.Riga)
		Inner Join dbo.DORig R On R.Id_DOTes = M.Id_DoTes And R.Riga > MR.Riga And (MRN.Riga Is Null Or R.Riga < MRN.Riga)
		Inner Join xvw_ARKit K On K.Cd_AR = MR.Cd_AR And K.Matricola = M.Matricola
	Where T.Cd_DO Like 'K[CI]' And MR.TipoPC = 'P' And R.TipoPC = 'C'
Go

Grant Select On xvw_ARKitMateriale To Arca_Admins, Arca_PowerUsers, Arca_Users, Arca_Readers, Public
Go

Exec asp_du_DropView 'xvw_ARKitMaterialeEx'
Go

Create View xvw_ARKitMaterialeEx
As
	Select Distinct
		K.Id_DORig As ID_Kit,
		ROW_NUMBER() Over (Partition By K.Id_DORig Order By K.Id_DORig, R.Cd_AR, R.Cd_ARLotto) As Sequenza,
		R.Id_DORig,
		R.Id_DOTes,
		R.Cd_AR,
		R.Cd_ARLotto,
		K.Cd_AR As Cd_AR_Kit,
		K.Matricola
	From dbo.DoRigMatricola M
		Inner Join dbo.DOTes T On T.Id_DOTes = M.Id_DOTes
		Inner Join dbo.DORig MR On MR.Id_DORig = M.Id_DoRig
		Left Join dbo.DORig MRN On MRN.Id_DORig = (Select Top 1 P.Id_DORig From DORig P Where P.TipoPC <> 'C' And P.Id_DOTes = MR.Id_DOTes And P.Riga > MR.Riga Order By P.Riga)
		Inner Join dbo.DORig R On R.Id_DOTes = M.Id_DoTes And R.Riga > MR.Riga And (MRN.Riga Is Null Or R.Riga < MRN.Riga)
		Inner Join xvw_ARKit K On K.Cd_AR = MR.Cd_AR And K.Matricola = M.Matricola
	Where T.Cd_DO Like 'K[CI]' And MR.TipoPC = 'P' And R.TipoPC = 'C'
Go

Grant Select On xvw_ARKitMaterialeEx To Arca_Admins, Arca_PowerUsers, Arca_Users, Arca_Readers, Public
Go

Exec asp_du_DropView 'xvw_MGMovLottiKit'
Go

Create View xvw_MGMovLottiKit
As
	Select
		K.Id_DORig As ID_Kit,
		MGMov.Id_MGMov,
		MR.Id_DORig As Id_DORig_Kit,
		DORig.Id_DORig As Id_DORig,
		DORig.Id_DOTes As Id_DOTes,
		MGMov.Cd_AR,
		MGMov.Cd_ARLotto,
		MR.Cd_AR As Cd_AR_Kit,
		M.Matricola
	From MGMov
		Inner Join DORig On DORig.Id_DORig = MGMov.Id_DORig
		Inner Join DORig MR On MR.Id_DORig = (Select Top 1 X.Id_DORig From DORig X Where X.Id_DOTes = DORig.Id_DOTes And X.Riga < DORig.Riga And X.TipoPC = 'P' Order By X.Riga Desc)
		Inner Join DORigMatricola M On M.Id_DORig = MR.Id_DORig
		Inner Join xvw_ARKit K On K.Cd_AR = MR.Cd_AR And K.Matricola = M.Matricola
	Where MGMov.PadreComponente = 'C'
Go

Grant Select On xvw_MGMovLottiKit To Arca_Admins, Arca_PowerUsers, Arca_Users, Arca_Readers, Public
Go

Exec asp_du_DropFunction 'xARKitMateriale_AllaData'
Go

Create Function xARKitMateriale_AllaData(@DataRif smalldatetime = null, @Kit varchar(20) = null, @Matricola varchar(80) = null, @Cd_MG char(5) = null, @RemoveZero bit = 0)
Returns Table
As Return
	Select 
		ROW_NUMBER() Over (Order By K.Id_KIT, K.Sequenza) As ID,
		K.ID_Kit,
		K.Sequenza,
		K.Cd_AR_Kit,
		K.Matricola,
		K.Cd_AR,
		K.Cd_ARLotto,
		L.DataScadenza,
		M.Cd_MG,
		Coalesce(Sum(M.Quantita * (M.Ini + M.Car + M.Ret - M.Sca)), Convert(Numeric(18, 6), 0)) As Giacenza
	From xvw_ARKitMateriale K
		Inner Join ARLotto L On L.Cd_AR = K.Cd_AR And L.Cd_ARLotto = K.Cd_ARLotto
		Inner Join MGEsercizio E On Coalesce(@DataRif, GetDate()) Between E.DtInizio And E.DtFine
		Left Join xvw_MGMovLottiKit MK On MK.ID_Kit = K.Id_Kit And MK.Cd_AR = K.Cd_AR And MK.Cd_ARLotto = K.Cd_ARLotto
		Left Join MGMov M On M.Id_MGMov = MK.Id_MGMov
	Where 
		M.Cd_MGEsercizio = E.Cd_MGEsercizio And 
		(@Cd_MG Is Null Or M.Cd_MG = @Cd_MG) And
		(@DataRif Is Null Or M.DataMov <= @DataRif) And
		(@Kit Is Null Or K.Cd_AR_Kit = @Kit) And
		(@Matricola Is Null Or K.Matricola = @Matricola)
	Group By
		K.ID_Kit,
		K.Sequenza,
		K.Cd_AR_Kit,
		K.Matricola,
		K.Cd_AR,
		K.Cd_ARLotto,
		L.DataScadenza,
		M.Cd_MG
	Having
		@RemoveZero = 0 Or Coalesce(Sum(M.Quantita * (M.Ini + M.Car + M.Ret - M.Sca)), Convert(Numeric(18, 6), 0)) <> 0
Go	

Grant Select On xARKitMateriale_AllaData To Arca_Admins, Arca_PowerUsers, Arca_Users, Arca_Readers, Public
Go

/*
Select * From xvw_ARKit
Select * From xvw_ARKitMateriale Order By ID_Kit, Sequenza
Select * From xvw_ARKitMaterialeEx Order By ID_Kit, Sequenza
Select * From xARKitMateriale_AllaData(default, default, default, default, default)
*/