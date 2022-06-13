exec dbo.asp_du_AddAlterColumn 'Preferenza', 'xGiorniScadenzaLotti', 'Int null', '0', 'Giorni alla scadenza per Lotti'


exec dbo.asp_du_DropProcedure 'xAsp_DO_Commit'
GO
CREATE Procedure [dbo].[xAsp_DO_Commit]
      @Phase tinyint,
      @Id_DOTes int,
      @InsertMode bit,
      @Options int = Null Output

As Begin
      -- Gestione Lotti non scaduti
	If @Phase = 0 
	Begin

		IF (SELECT COUNT(*) FROM DORig inner join ARLotto on DORig.cd_ar = ARLotto.cd_ar AND DORig.cd_arlotto = ARLotto.cd_arlotto
			left join ARLottoARLottoAttributo ARL On ARLotto.Id_ARLotto = ARL.Id_ARLotto 
			left join ARLottoAttributo ARLT on ARL.Id_Attributo = ARLT.Id_Attributo and ARLT.Descrizione = 'Obsoleti - Non Utilizzabili'
			WHERE DORig.Id_DOTes = @Id_DOTes AND (ARL.Id_ARLotto is Not null or ARLotto.DataScadenza < DORig.DataDoc)) > 0
		BEGIN
			declare @ARTICOLO AS VARCHAR(20), @LOTTO AS VARCHAR(20), @DESC as VARCHAR(MAX) = ''
			DECLARE CurDati CURSOR FOR   
			SELECT distinct DORig.cd_ar, DORig.cd_arlotto
			FROM DORig inner join ARLotto on DORig.cd_ar = ARLotto.cd_ar AND DORig.cd_arlotto = ARLotto.cd_arlotto
			left join ARLottoARLottoAttributo ARL On ARLotto.Id_ARLotto = ARL.Id_ARLotto 
			left join ARLottoAttributo ARLT on ARL.Id_Attributo = ARLT.Id_Attributo and ARLT.Descrizione = 'Obsoleti - Non Utilizzabili'
			WHERE DORig.Id_DOTes = @Id_DOTes AND (ARL.Id_ARLotto is Not null or ARLotto.DataScadenza < DORig.DataDoc);  

			set @DESC = 'Operazione terminata con ERRORE! Sono stati utilizzati i seguenti LOTTI SCADUTI:' + CHAR(13) + CHAR(10)

			OPEN CurDati
  
			FETCH NEXT FROM CurDati
			INTO @ARTICOLO, @LOTTO
  			WHILE @@FETCH_STATUS = 0  
			BEGIN
				SET @DESC = @DESC + 'Art. ' + @ARTICOLO + '/Lot. ' + @LOTTO + CHAR(13) + CHAR(10)

				FETCH NEXT FROM CurDati
				INTO @ARTICOLO, @LOTTO
			END
			CLOSE CurDati;  
			DEALLOCATE CurDati;

			RAISERROR (@DESC , 15, -1)
		END

	END
	Return 0
End
GO