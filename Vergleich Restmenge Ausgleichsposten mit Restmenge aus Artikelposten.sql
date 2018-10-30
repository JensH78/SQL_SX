/*
Herausfinden bei welchen Artikelposten die Restmenge nicht zu den Ausgleichsposten passt
*/

DECLARE @stmt AS VARCHAR(MAX),
        @company AS VARCHAR(MAX)


SET @company = '30 Simplex Armaturen & Systeme'

SET @stmt = 
'
SELECT ILE.[Entry No_] [Artikelposten Lfd. Nr.]     
     , MAX(ILE.[Item No_]) [Artikelnr.]
	 , ILE.[Location Code] [Lagerort]
     , ILE.[Document No_]
	 , SUM(ItemApply.[Quantity]) [Restmenge aus Ausgleichsposten]
	 , MAX(ILE.[Remaining Quantity]) [Restmenge aus Artikelposten]
from dbo.['+@company+'$Item Application Entry] [ItemApply] WITH (READUNCOMMITTED)
INNER JOIN dbo.['+@company+'$Item Ledger Entry] ILE WITH (READUNCOMMITTED)
ON [ItemApply].[Inbound Item Entry No_] = ILE.[Entry No_]      
GROUP BY ILE.[Entry No_]
     , ILE.[Document No_]
	 , ILE.[Location Code]
HAVING SUM(ItemApply.[Quantity]) <> MAX(ILE.[Remaining Quantity])
'
EXEC(@stmt)