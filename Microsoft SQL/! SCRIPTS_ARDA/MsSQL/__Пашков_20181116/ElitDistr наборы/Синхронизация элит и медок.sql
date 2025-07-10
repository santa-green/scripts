--Синхронизация РН элит и медок
USE Elit


SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC
FROM ElitDistr.dbo.at_t_Medoc 
ORDER BY DNN , nnn, CAST(TAB1_A1 as int)


SELECT d.*, med.* FROM Elit.dbo.t_Inv m 
JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID
Join (SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC FROM ElitDistr.dbo.at_t_Medoc ) med 
on med.NNN = m.TaxDocID and med.DNN = TaxDocDate and med.Pos = d.SrcPosID

WHERE m.TaxDocID = t.NNN and m.TaxDocDate = t.DNN and d.ProdID = t.ProdID_Elit


SELECT TAB1_A1 Pos,TAB1_A13 ProdName, N2_11 NNN, N11 DNN, TAB1_A14 UM, TAB1_A15 Qty, TAB1_A16 Price,  TAB1_A10 SumCC FROM ElitDistr.dbo.at_t_Medoc med
WHERE not EXISTS (SELECT top 1 1 FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID JOIN Elit.dbo.r_Prods p ON p.ProdID = d.ProdID
			  WHERE med.N11 = m.TaxDocDate and med.N2_11 = m.TaxDocID and med.TAB1_A13 = p.Notes and med.TAB1_A1 = d.SrcPosID and med.TAB1_A15 = d.Qty)
and not EXISTS (SELECT top 1 1 FROM Elit.dbo.t_Inv m JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID JOIN Elit.dbo.r_Prods p ON p.ProdID = d.ProdID
			  WHERE med.N11 = m.TaxDocDate and med.N2_11 = m.TaxDocID and med.TAB1_A13 = (SELECT top 1 NameMedoc FROM ElitDistr.dbo.at_FindMedocNameD fmd where fmd.InUse = 1 and fmd.ProdID = d.ProdID) and med.TAB1_A1 = d.SrcPosID and med.TAB1_A15 = d.Qty)			  
ORDER BY DNN desc, nnn, CAST(TAB1_A1 as int)


SELECT p.Notes,d.*,m.* FROM Elit.dbo.t_Inv m
JOIN Elit.dbo.t_InvD d ON d.ChID = m.ChID
JOIN Elit.dbo.r_Prods p ON p.ProdID = d.ProdID
WHERE m.TaxDocID = 10282
and m.TaxDocDate = '2018-05-30 00:00:00.000'
 
ORDER BY SrcPosID

SELECT top 1 NameMedoc FROM ElitDistr.dbo.at_FindMedocNameD fmd where fmd.InUse = 1 and fmd.ProdID = 28602
SELECT top 1 NameMedoc FROM ElitDistr.dbo.at_FindMedocNameD fmd where fmd.Notes_ProdName = 'Кава "Бруно" в зернах Рікко 1 кг.*6  NV'

Кава "Бруно" в зернах Рікко 1 кг.*6  NV