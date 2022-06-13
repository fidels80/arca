exec dbo.asp_du_DropProcedure 'xAsp_Do_Commit'
go


CREATE Procedure xAsp_Do_Commit 
@Phase Tinyint, 
@Id_DoTes Int, 
@InsertMode Bit, 
@Options Int = Null Output
As

Declare @coddoc Varchar(3)
Declare @maxriga Numeric(9)
Declare @cd_cf Varchar(7)

Declare @w_tot_prezzo Numeric(15,6)
Declare @w_tot_costo Numeric(15,6)

Declare @w_iva Varchar(3)
Declare @w_ivaR Varchar(3)
Declare @w_mg_a Varchar(5)
Declare @w_cs Varchar(12)

Declare @w_esisteTOT INT
Declare @w_applica bit
Declare @w_righeMD bit

If @Phase = 0

Begin --1

Set @coddoc = (Select cd_do From Dotes Where DoTes.Id_Dotes = @Id_Dotes)
Set @cd_cf = (Select CliFor From Do Where CD_DO = @coddoc)				-- solo clienti
Set @w_applica =(Select xRigaTOT_MD From DO Where CD_DO = @coddoc)				-- 
Set @w_esisteTOT = (Select count(*) from DORig where Cd_AR = 'TOT' and Dorig.Id_Dotes = @Id_Dotes) --vedo se esiste riga TOT
Set @w_righeMD = (Select count(*) from DORig where prezzoTotaleV <> 0 and Cd_ARMisura = 'MD' and Id_Dotes = @Id_Dotes and cd_ar is not null) --vedo se esistono righe per riga TOT

If @w_applica = 1 and @cd_cf = 'C' and @w_esisteTOT = 0 and @w_righeMD > 0
	begin --2
	Set @maxriga = (Select max(riga) From Dorig Where Dorig.Id_Dotes = @Id_Dotes and dorig.Cd_AR not like 'TOT%') -- ultima riga
	select @w_cs = Cd_CGConto_2 from Impostazione where Cd_Impostazione = 'DEFAULT_RIGHE_DOC' 

	DECLARE CursorVar CURSOR FOR							-- creo cursore raggruppato con totali
	SELECT Cd_Aliquota, sum(prezzoTotaleV) as tot, sum(xTotCosto) as TotCosto
	From Dorig
	Where Id_Dotes = @Id_Dotes and cd_armisura = 'MD' and prezzoTotaleV <> 0 and cd_ar is not null
	group by Cd_Aliquota
	
	OPEN CursorVar
	FETCH NEXT FROM CursorVar INTO  @w_iva, @w_tot_prezzo, @w_tot_costo
	WHILE @@FETCH_STATUS = 0
	BEGIN	--3
	
	set @maxriga=@maxriga+1
	
	Insert Into Dorig (Id_DoTes, Cd_AR, Descrizione, Qta, QtaEvadibile, Cd_ARMisura,
				PrezzoUnitarioV, Cd_Aliquota, riga, xCostoAcquisto, xTotCosto, Cd_CGConto)
		Values (@Id_Dotes,'TOT','TOTALE QUOTIDIANI',1,1,'NR', @w_tot_prezzo, @w_iva, @Maxriga, @w_tot_costo, @w_tot_costo, @w_cs)
				
	    FETCH NEXT FROM CursorVar INTO @w_iva, @w_tot_prezzo, @w_tot_costo
	    
	END	--3

	CLOSE CursorVar
	DEALLOCATE CursorVar
	
	update dorig set xPrezzoUnitarioV_Copy = PrezzoUnitarioV, xCostoAcquisto_Copy = xCostoAcquisto 
		where Id_DOTes = @Id_Dotes and Cd_ARMisura = 'MD' and PrezzoUnitarioV <> 0

	update dorig set PrezzoUnitarioV = 0, PrezzoTotaleV = 0, xCostoAcquisto = 0, xTotCosto = 0 
		where Id_DOTes = @Id_Dotes and Cd_ARMisura = 'MD' and PrezzoUnitarioV <> 0

	end --2

end --1

-- Come valore di ritorno della sp torno sempre 0 per futuri ampliamenti.

Return 0

