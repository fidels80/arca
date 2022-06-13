---Gestione Email automatiche
--EXEC asp_du_DropTable 'xGestioneEmailAuto'
IF dbo.afn_du_IsTable('xGestioneEmailAuto') = 0
	EXEC asp_du_AddTable 'xGestioneEmailAuto', 0, 'Gestione Email Auto'

EXEC asp_du_AddAlterColumn 'xGestioneEmailAuto', 'CD_AR', 'VARCHAR(20) NOT NULL', '', 'Articolo'
EXEC asp_du_AddAlterColumn 'xGestioneEmailAuto', 'CD_Nazione', 'CHAR(2) NULL', '', 'Nazione'
EXEC asp_du_AddAlterColumn 'xGestioneEmailAuto', 'CD_Regione', 'CHAR(3) NULL', '', 'Regione'
EXEC asp_du_AddAlterColumn 'xGestioneEmailAuto', 'CD_Provincia', 'CHAR(3) NULL', '', 'Provincia'
EXEC asp_du_AddAlterColumn 'xGestioneEmailAuto', 'Contatti', 'VARCHAR(250) NOT NULL', '', 'Contatti'

EXEC asp_du_DropConstraint 'xGestioneEmailAuto', 'FK_xGestioneEmailAuto_cd_AR'
ALTER TABLE xGestioneEmailAuto ADD CONSTRAINT FK_xGestioneEmailAuto_cd_AR FOREIGN KEY (CD_AR) REFERENCES AR(CD_AR)

EXEC asp_du_DropConstraint 'xGestioneEmailAuto', 'FK_xGestioneEmailAuto_cd_Nazione'
ALTER TABLE xGestioneEmailAuto ADD CONSTRAINT FK_xGestioneEmailAuto_cd_Nazione FOREIGN KEY (CD_Nazione) REFERENCES Nazione(CD_Nazione)

EXEC asp_du_DropConstraint 'xGestioneEmailAuto', 'FK_xGestioneEmailAuto_Nazione_regione'
ALTER TABLE xGestioneEmailAuto ADD CONSTRAINT FK_xGestioneEmailAuto_Nazione_regione FOREIGN KEY (CD_Nazione,CD_Regione) REFERENCES Regione(CD_Nazione,CD_Regione)

EXEC asp_du_DropConstraint 'xGestioneEmailAuto', 'FK_xGestioneEmailAuto_Provincia_Nazione'
ALTER TABLE xGestioneEmailAuto ADD CONSTRAINT FK_xGestioneEmailAuto_Provincia_Nazione FOREIGN KEY (CD_Nazione,CD_Provincia) REFERENCES Provincia(CD_Nazione,CD_Provincia)

EXEC asp_du_AddAlterColumn 'AR', 'xEA_Lunedi', 'BIT NULL', '0', 'Lunedì'
EXEC asp_du_AddAlterColumn 'AR', 'xEA_Martedi', 'BIT NULL', '0', 'Martedì'
EXEC asp_du_AddAlterColumn 'AR', 'xEA_Mercoledi', 'BIT NULL', '0', 'Mercoledì'
EXEC asp_du_AddAlterColumn 'AR', 'xEA_Giovedi', 'BIT NULL', '0', 'Giovedì'
EXEC asp_du_AddAlterColumn 'AR', 'xEA_Venerdi', 'BIT NULL', '0', 'Venerdì'
EXEC asp_du_AddAlterColumn 'AR', 'xEA_Sabato', 'BIT NULL', '0', 'Sabato'
EXEC asp_du_AddAlterColumn 'AR', 'xEA_Domenica', 'BIT NULL', '0', 'Domenica'

--EXEC asp_du_DropTable 'xARFormato'
IF dbo.afn_du_IsTable('xARFormato') = 0
	EXEC asp_du_AddTable 'xARFormato', 0, 'Gestione Formati Articoli'

EXEC asp_du_AddAlterColumn 'xARFormato', 'CD_xARFormato', 'CHAR(10) NOT NULL', '', 'Formato'
EXEC asp_du_AddAlterColumn 'xARFormato', 'CD_AR', 'VARCHAR(20) NOT NULL', '', 'Articolo'
EXEC asp_du_AddAlterColumn 'xARFormato', 'Descrizione', 'VARCHAR(80) NOT NULL', '', 'Descrizione'

EXEC asp_du_DropConstraint 'DORIG', 'FK_DORIG_cd_xARFormato'
EXEC asp_du_DropConstraint 'xARFormato', 'FK_xARFormato_cd_AR'
EXEC asp_du_DropConstraint 'xARFormato', 'UK_xARFormato'
EXEC asp_du_DropConstraint 'xARFormato', 'UK_xARFormato_Formato_Articolo'

EXEC asp_du_AddAlterColumn 'DORIG', 'xEA_Inviata', 'smalldatetime NULL', '', 'Data Invio Email'
EXEC asp_du_AddAlterColumn 'DORIG', 'cd_xARFormato', 'CHAR(10) NULL', '', 'Formato Articolo'

ALTER TABLE xARFormato ADD CONSTRAINT FK_xARFormato_cd_AR FOREIGN KEY (CD_AR) REFERENCES AR(CD_AR)
Alter Table xARFormato Add Constraint UK_xARFormato_Formato_Articolo Unique Clustered (CD_xARFormato, Cd_AR)
ALTER TABLE DORIG ADD CONSTRAINT FK_DORIG_cd_xARFormato FOREIGN KEY (cd_xARFormato, CD_AR) REFERENCES xARFormato(cd_xARFormato, CD_AR)