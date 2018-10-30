/*
Ermittelt Unstimmigkeiten beim Lagerbestand über Menge<>Lagerbestand über Restmenge, Reservierte Menge>Lagerbestand und Lagerbestand<>Lagerplatzmenge
Mandant 30 Simplex Armaturen & Systeme
Mandant DSI-Getraenkearmaturen
*/

DECLARE @stmt AS VARCHAR(MAX),
        @company AS VARCHAR(MAX)

SET @company = '30 Simplex Armaturen & Systeme'

SET @stmt = 
'WITH Inventory AS(SELECT [Item No_] 
     , [Location Code]
	 , SUM([Quantity]) [Quantity]
	 , SUM([Remaining Quantity]) [Remaining Quantity]
FROM [dbo].['+@company+'$Item Ledger Entry] WITH (READUNCOMMITTED)
GROUP BY [Item No_]
       , [Location Code]),

Reservation AS (
SELECT [Item No_]
     , [Location Code]
	 , SUM([Quantity (Base)]) [Reserved Quantity]
FROM [dbo].['+@company+'$Reservation Entry] WITH (READUNCOMMITTED)
WHERE [Source Type] = 32 AND
      [Source Subtype] = 0 AND
	  [Reservation Status] = 0
GROUP BY [Item No_]
       , [Location Code]),

Warehouse AS (
SELECT [Item No_]
     , [Location Code]
	 , SUM([Qty_ (Base)]) [Quantity]
FROM [dbo].['+@company+'$Warehouse Entry] WITH (READUNCOMMITTED)
GROUP BY [Item No_]
       , [Location Code])

SELECT Item.[No_]
     , Inventory.[Location Code]
	 , Inventory.Quantity	 
	 , Inventory.[Remaining Quantity]
	 , Reservation.[Reserved Quantity]
     , Warehouse.Quantity [Warehouse Inventory]
FROM [dbo].['+@company+'$Item] Item WITH (READUNCOMMITTED)
LEFT OUTER JOIN Inventory
ON Item.[No_] = Inventory.[Item No_]
LEFT OUTER JOIN Reservation
ON Item.[No_] = Reservation.[Item No_] AND
   Inventory.[Location Code] = Reservation.[Location Code]
LEFT OUTER JOIN Warehouse
ON Item.[No_] = Warehouse.[Item No_] AND
   Inventory.[Location Code] = Warehouse.[Location Code]
WHERE (Inventory.Quantity-Reservation.[Reserved Quantity] < 0) OR
      (Inventory.Quantity <> Inventory.[Remaining Quantity]) OR
	  (Inventory.Quantity <> Warehouse.Quantity)'
      
EXEC(@stmt)
