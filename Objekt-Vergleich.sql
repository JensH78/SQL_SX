/*
Dies ist ein Objektvergleich zwischen einer TEST und LIVE-Datenbank
#TODO: Hier muss mal was gemacht werden!!!
#FIXME:Hier stimmt etwas nicht

Das kriegen wir schon hin...
*/
SELECT CASE WHEN [Test].[Date] < [Live].[Date] THEN 'Live aktueller'
            WHEN [Test].[Date] > [Live].[Date] THEN 'Test aktueller'
            WHEN [Test].[Time] <> [Live].[Time] THEN 'Zeit unterschiedlich'
			WHEN [Test].[Version List] <> [Live].[Version List] THEN 'Version unterschiedlich'
			WHEN [Test].[BLOB Size] <> [Live].[BLOB Size] THEN 'Größe unterschiedlich'
       END [Unterschied]
     , CASE [Live].[Type]
	     WHEN 1 THEN 'Table'
		 WHEN 2 THEN 'Form'
		 WHEN 3 THEN 'Report'
		 --#FIXME: Hier fehlt noch etwas
		 WHEN 5 THEN 'Codeunit'
		 --#FIXME: Hier fehlt noch etwas
		 WHEN 8 THEN 'Page'
		 WHEN 9 THEN 'Menusuite'
		 ELSE CONVERT(VARCHAR(MAX), [Live].[Type])
	   END [Type]
	 , [Live].ID
	 , [Live].Name
	 , [Live].[BLOB Size]
	 , CONVERT(VARCHAR(MAX), [Live].[Date],104) [Date]
	 , CONVERT(VARCHAR(MAX), [Live].[Time], 108) [Time]
     , CASE [Test].[Type]
	     WHEN 1 THEN 'Table'
		 WHEN 2 THEN 'Form'
		 WHEN 3 THEN 'Report'
		 --#FIXME: Hier fehlt noch etwas
		 WHEN 5 THEN 'Codeunit'
		 --#FIXME: Hier fehlt noch etwas
		 WHEN 8 THEN 'Page'
		 WHEN 9 THEN 'Menusuite'
		 ELSE CONVERT(varchar(MAX), [Test].[Type])
		END [Test Type]
	 , [Test].ID [Test ID]
	 , [Test].[BLOB Size] [Test BLOB Size]
	 , CONVERT(VARCHAR(MAX), [Test].[Date],104) [Test Date] 
	 , CONVERT(VARCHAR(MAX), [Test].[Time], 108) [Test Time]
	 ,Test.[Locked]
	 ,Live.[Locked]
FROM [SEPNAVLIVE].dbo.[Object] [Live] --#FIXME:Allgemeine Datenbank
FULL OUTER JOIN [TEMP_NAV].dbo.[Object] [Test] --#FIXME:Allgemeine Datenbank
ON [Live].[Type] = [Test].[Type] AND
   [Live].[ID] = [Test].[ID]
WHERE ([Live].[Type] > 0 AND
      ([Live].[Type] = [Test].[Type] AND
       [Live].[ID] = [Test].[ID] AND 
	   ([Test].[Date] <> [Live].[Date] OR
	   [Test].[Time] <> [Live].[Time] OR
	   [Test].[Version List] <> [Live].[Version List] OR
	   [Test].[BLOB Size] <> [Live].[BLOB Size]))) OR
	   ([Test].ID IS NULL) OR
	   ([Live].ID IS NULL)
ORDER BY [Live].[Type],
         [Live].[ID]
