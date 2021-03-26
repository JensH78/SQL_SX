/*
Ermittelt die Anzahl der Datensätze pro Tabelle für einen Mandanten

*/

DECLARE @stmt AS VARCHAR(MAX)
      , @CuTableName AS VARCHAR(MAX)
      , @CompanyName AS VARCHAR(MAX)

SET @CompanyName = '30 Simplex Armaturen & Systeme'

DECLARE TableCursor cursor FOR

SELECT REPLACE(REPLACE(REPLACE([Name],'/','_'),'.','_'),'%','_')
FROM dbo.[Object]
WHERE [Company Name] LIKE @CompanyName

CREATE TABLE #TableAnalyse
(        
    TableName CHAR(2000),
	Quantity INT     
);


OPEN TableCursor FETCH NEXT FROM TableCursor INTO @CuTableName
WHILE @@FETCH_STATUS = 0 BEGIN
SET @stmt =
'INSERT INTO #TableAnalyse
 SELECT '''+@CuTableName+''',
 COUNT(*)
 FROM [dbo].['+@CompanyName+'$' + @CuTableName + ']'

--PRINT(@stmt)
EXEC(@stmt)
FETCH NEXT FROM TableCursor INTO @CuTableName
END
CLOSE TableCursor
DEALLOCATE TableCursor

SELECT *
FROM #TableAnalyse
ORDER BY [Quantity] DESC
DROP TABLE #TableAnalyse
