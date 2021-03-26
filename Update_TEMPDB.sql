USE [master];
GO

IF DB_ID(N'TEMP_NAV') IS NOT NULL
BEGIN;
ALTER DATABASE [TEMP_NAV] set single_user with rollback immediate
DROP DATABASE [TEMP_NAV]
END;

BACKUP DATABASE [SEPNAVLIVE] TO  DISK = N'\\Srvsimeh-veeam\NAVSQL_Sicherungen$\TestDB_.bak' WITH COPY_ONLY, INIT,  NAME = N'Vollsicherung fuer Testdatenbank', STATS = 10
GO

RESTORE DATABASE [TEMP_NAV] FROM  DISK = N'\\Srvsimeh-veeam\NAVSQL_Sicherungen$\TestDB_.bak' WITH  FILE = 1,  MOVE N'Demo Database NAV (7-0)_Data' TO N'E:\MSSQL11.MSSQLSERVER\MSSQL\DATA\TEMP_NAV.mdf',  MOVE N'Demo Database NAV (7-0)_Log' TO N'F:\MSSQL11.MSSQLSERVER\MSSQL\DATA\TEMP_NAV.ldf',  NOUNLOAD,  STATS = 10
GO

-- ALTER DATABASE [TEMP_NAV] SET DISABLE_BROKER WITH ROLLBACK IMMEDIATE;
-- ALTER DATABASE [TEMP_NAV] SET NEW_BROKER WITH ROLLBACK IMMEDIATE;
ALTER DATABASE [TEMP_NAV] SET RECOVERY SIMPLE
GO

UPDATE [TEMP_NAV].[dbo].[30 Simplex Armaturen & Systeme$Company Information] --#FIXME:Allgemeine Mandantennamen
SET [System Indicator Style] = '1',[System Indicator] = '1',[Custom System Indicator Text] = N'ACHTUNG !!! TEST-Datenbank !!! Stand: ' + CONVERT(NVARCHAR(MAX),GETDATE(),104);
GO

UPDATE [TEMP_NAV].[dbo].[31 Seppelfricke Simplex Austri$Company Information] --#FIXME:Allgemeine Mandantennamen
SET [System Indicator Style] = '1',[System Indicator] = '1',[Custom System Indicator Text] = N'ACHTUNG !!! TEST-Datenbank !!! Stand: ' + CONVERT(NVARCHAR(MAX),GETDATE(),104);
GO

--Komm-Adapter auf inaktiv setzen
UPDATE [TEMP_NAV].[dbo].[30 Simplex Armaturen & Systeme$ESCM Com_ Adapter] --#FIXME:Allgemeine Mandantennamen
SET [Active] = 0
GO

--Komm Buchblatt Automatik deaktivieren
UPDATE [TEMP_NAV].[dbo].[30 Simplex Armaturen & Systeme$ESCM Com_ Journal] --#FIXME:Allgemeine Mandantennamen
SET [Posting Automation] = 0
   ,[Proposal Calc_ Automation] = 0
GO

--Bei Nachrichtenaustausch Komm-Adapter herausnehmen
UPDATE [TEMP_NAV].[dbo].[30 Simplex Armaturen & Systeme$ESCM Message Exchange] --#FIXME:Allgemeine Mandantennamen
SET [Com_ Adapter] = ''
GO

--In Aalberts Setup das Flag Test-Datenbank setzen
UPDATE [TEMP_NAV].[dbo].[30 Simplex Armaturen & Systeme$Aalberts Setup] --#FIXME:Allgemeine Mandantennamen
SET [Test Database] = 1
GO

--Archiv deaktivieren und auf manuelle Archivierung umstellen
UPDATE [TEMP_NAV].dbo.[30 Simplex Armaturen & Systeme$Document Archive Setup] --#FIXME:Allgemeine Mandantennamen
SET [Archive activ] = 0,
	[Archive Folder] = REPLACE([Archive Folder],'Produktiv','Test'),
    [Acknowledgment Folder] = REPLACE([Acknowledgment Folder],'Produktiv','Test'),
	[Acknowledgment Folder dlink] = REPLACE([Acknowledgment Folder dlink],'Produktiv','Test'), 
	[Arch_ Folder for ext_ Doc] = REPLACE([Arch_ Folder for ext_ Doc],'Produktiv','Test'),
	[Folder for Update Files] = REPLACE([Folder for Update Files],'Produktiv','Test'),
	[Archive without NAS] = 1
GO

--Änderungsprotokoll leeren
TRUNCATE TABLE [TEMP_NAV].[dbo].[30 Simplex Armaturen & Systeme$Change Log Entry] --#FIXME:Allgemeine Mandantennamen
GO
