ALTER PROCEDURE [dbo].[ap_GetOrderInfo] (@PGrID1 VARCHAR(500) = '0', @PCatID VARCHAR(500) = '0', @StockID VARCHAR(500) = '0')
AS
BEGIN
/*
EXEC ap_GetOrderInfo '27, 28, 29, 63', '1-100', '4, 304'
*/


/*
DECLARE @PGrID1 VARCHAR(500) = '27, 28, 29, 63'
	   ,@PCatID VARCHAR(500) = '1-100'
	   ,@StockID VARCHAR(500) = '23,323'--'4, 304'
*/

DECLARE @BDate SMALLDATETIME = '20190501'
	   ,@EDate SMALLDATETIME = '20190618'


IF OBJECT_ID (N'tempdb..#result',N'U') IS NOT NULL DROP TABLE #result
CREATE TABLE #result
( PGrName1 VARCHAR(500)
 ,AltCode INT --CodePostavshika
 ,ProdID INT
 ,ProdName VARCHAR(1000)
 ,Weight NUMERIC(21,9)
 ,QtyInBox INT
 ,AtBeginQty INT
 ,RecQty INT
 ,InvQty INT
 ,ExpQty INT
 ,EppQty INT 
 ,RetQty INT
 ,ExcQtyOnStock INT
 ,ExcQtyFromStock INT
 ,AtEndQty INT
 ,Sales INT
 ,Shortage INT
 ,OrderQty INT
)

IF @StockID != '0'
BEGIN


DECLARE @heap TABLE
( ProdID INT
 ,Qty INT
 ,OperationID INT
)

INSERT INTO @heap
--�� ������.
SELECT q.ProdID, SUM(q.SumQty) Qty, 1
FROM
(
		-->>> �� ������ - ������ ������:
		SELECT rp.ProdID, SUM(d.Qty) SumQty
		FROM t_Rec m WITH(NOLOCK)
		JOIN t_RecD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		  WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - ������� ������ �� ����������:
		SELECT rp.ProdID, SUM(d.Qty) SumQty
		FROM t_Ret m WITH(NOLOCK)
		JOIN t_RetD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - ������� ������ ����������:
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_CRet m WITH(NOLOCK)
		JOIN t_CRetD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - ��������� ���������:
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_Inv m WITH(NOLOCK)
		JOIN t_InvD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - ��������� ��������:
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_Exp m WITH(NOLOCK)
		JOIN r_Ours r_Ours_105 WITH(NOLOCK) ON (m.OurID=r_Ours_105.OurID)
		JOIN t_ExpD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - ��������� �������� � ����� �������:
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_Epp m WITH(NOLOCK)
		JOIN t_EppD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - ����������� ������ (������):
		SELECT rp.ProdID, SUM(d.Qty) SumQty
		FROM t_Exc m WITH(NOLOCK)
		JOIN t_ExcD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.NewStockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - ����������� ������ (������):
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_Exc m WITH(NOLOCK)
		INNER JOIN t_ExcD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		INNER JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		INNER JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - �������������� ������ (������):
		SELECT rp.ProdID, SUM(d.NewQty) SumQty
		FROM t_Ven m WITH(NOLOCK)
		JOIN t_VenA tva WITH(NOLOCK) ON (m.ChID=tva.ChID)
		JOIN t_VenD d WITH(NOLOCK) ON (tva.ChID=d.ChID AND tva.ProdID=d.DetProdID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.DetProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - �������������� ������ (������):
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_Ven m WITH(NOLOCK)
		JOIN t_VenA tva WITH(NOLOCK) ON (m.ChID=tva.ChID)
		JOIN t_VenD d WITH(NOLOCK) ON (tva.ChID=d.ChID AND tva.ProdID=d.DetProdID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.DetProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - ���������� ��� ������� (������):
		SELECT rp.ProdID, SUM(d.Qty) SumQty
		FROM t_Est m WITH(NOLOCK)
		JOIN t_EstD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.NewPPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - ���������� ��� ������� (������):
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_Est m WITH(NOLOCK)
		JOIN t_EstD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - �������� ������� ������:
		SELECT rp.ProdID, SUM(m.Qty) SumQty
		FROM t_zInP m WITH(NOLOCK)
		JOIN t_PInP tp WITH(NOLOCK) ON (m.PPID=tp.PPID AND m.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - ������� ������ �� ����:
		SELECT rp.ProdID, SUM(d.Qty) SumQty
		FROM t_CRRet m WITH(NOLOCK)
		JOIN t_CRRetD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - ������� ������ ����������:
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_Sale m WITH(NOLOCK)
		JOIN t_SaleD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - ������������ ������ (������):
		SELECT rp.ProdID, SUM(tsra.Qty) SumQty
		FROM t_SRec m WITH(NOLOCK)
		JOIN t_SRecA tsra WITH(NOLOCK) ON (m.ChID=tsra.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (tsra.PPID=tp.PPID AND tsra.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ������ - ������������ ������ (������):
		SELECT rp.ProdID, SUM(0-(d.SubQty)) SumQty
		FROM t_SRec m WITH(NOLOCK)
		JOIN t_SRecA tsra WITH(NOLOCK) ON (m.ChID=tsra.ChID)
		JOIN t_SRecD d WITH(NOLOCK) ON (tsra.AChID=d.AChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.SubPPID=tp.PPID AND d.SubProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL

		-->>> �� ������ - ���������������� ������ (������):
		SELECT rp.ProdID, SUM(d.SubQty) SumQty
		FROM t_SExp m WITH(NOLOCK)
		JOIN t_SExpA tsea WITH(NOLOCK) ON (m.ChID=tsea.ChID)
		JOIN t_SExpD d WITH(NOLOCK) ON (tsea.AChID=d.AChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.SubPPID=tp.PPID AND d.SubProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL

		-->>> �� ������ - ���������������� ������ (������):
		SELECT rp.ProdID, SUM(0-(tsea.Qty)) SumQty
		FROM t_SExp m WITH(NOLOCK)
		JOIN t_SExpA tsea WITH(NOLOCK) ON (m.ChID=tsea.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (tsea.PPID=tp.PPID AND tsea.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
		   WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate < @BDate)
		GROUP BY rp.ProdID
) q
GROUP BY q.ProdID


INSERT INTO @heap
-->>> ������ - ������ ������:
SELECT rp.ProdID, SUM(d.Qty) SumQty, 2
FROM t_Rec m WITH(NOLOCK)
JOIN t_RecD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
  WHERE rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
		AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
		AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
		AND m.DocDate BETWEEN @BDate AND @EDate
GROUP BY rp.ProdID

INSERT INTO @heap
--���������
SELECT rp.ProdID, SUM(d.Qty) SumQty, 3
FROM t_Inv m WITH(NOLOCK)
JOIN t_InvD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
  WHERE rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
		AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
		AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
		AND m.DocDate BETWEEN @BDate AND @EDate
GROUP BY rp.ProdID

INSERT INTO @heap
--��
SELECT rp.ProdID, SUM(d.Qty) SumQty, 4
FROM t_Exp m WITH(NOLOCK)
JOIN t_ExpD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
  WHERE rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
        AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
		AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
		AND m.DocDate BETWEEN @BDate AND @EDate
GROUP BY rp.ProdID

INSERT INTO @heap
--�� � ��
SELECT rp.ProdID, SUM(d.Qty) SumQty, 5
FROM t_Epp m WITH(NOLOCK)
JOIN t_EppD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
  WHERE rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
        AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
		AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
		AND m.DocDate BETWEEN @BDate AND @EDate
GROUP BY rp.ProdID

INSERT INTO @heap
--������� �� ����������
SELECT rp.ProdID, SUM(d.Qty) SumQty, 6
FROM t_Ret m WITH(NOLOCK)
JOIN t_RetD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
  WHERE rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
        AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
		AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
		AND m.DocDate BETWEEN @BDate AND @EDate
GROUP BY rp.ProdID

INSERT INTO @heap
-->>> ����������� (�� �����) - ����������� ������ (������):
SELECT rp.ProdID, SUM(d.Qty) SumQty, 7
FROM t_Exc m WITH(NOLOCK)
JOIN t_ExcD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
  WHERE rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
		AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
		AND m.NewStockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
		AND m.DocDate BETWEEN @BDate AND @EDate
GROUP BY rp.ProdID

INSERT INTO @heap
-->>> ����������� (�� ������) - ����������� ������ (������):
SELECT rp.ProdID, SUM(d.Qty) SumQty, 8
FROM t_Exc m WITH(NOLOCK)
JOIN t_ExcD d WITH(NOLOCK) ON (m.ChID=d.ChID)
JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
  WHERE rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
		AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
		AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
		AND m.DocDate BETWEEN @BDate AND @EDate
GROUP BY rp.ProdID

INSERT INTO @heap
--�� �����
SELECT q.ProdID, SUM(q.SumQty) Qty, 9
FROM
(
		-->>> �� ����� - ������ ������:
		SELECT rp.ProdID, SUM(d.Qty) SumQty
		FROM t_Rec m WITH(NOLOCK)
		JOIN t_RecD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - ������� ������ �� ����������:
		SELECT rp.ProdID, SUM(d.Qty) SumQty
		FROM t_Ret m WITH(NOLOCK)
		JOIN t_RetD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - ������� ������ ����������:
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_CRet m WITH(NOLOCK)
		JOIN t_CRetD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - ��������� ���������:
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_Inv m WITH(NOLOCK)
		JOIN t_InvD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - ��������� ��������:
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_Exp m WITH(NOLOCK)
		JOIN t_ExpD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - ��������� �������� � ����� �������:
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_Epp m WITH(NOLOCK)
		JOIN t_EppD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		--!!!>>> �� ����� - ����������� ������ (������):
		SELECT rp.ProdID, SUM(d.Qty) SumQty
		FROM t_Exc m WITH(NOLOCK)
		JOIN t_ExcD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.NewStockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - ����������� ������ (������):
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_Exc m WITH(NOLOCK)
		JOIN t_ExcD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - �������������� ������ (������):
		SELECT rp.ProdID, SUM(d.NewQty) SumQty
		FROM t_Ven m WITH(NOLOCK)
		JOIN t_VenA tva WITH(NOLOCK) ON (m.ChID=tva.ChID)
		JOIN t_VenD d WITH(NOLOCK) ON (tva.ChID=d.ChID AND tva.ProdID=d.DetProdID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.DetProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - �������������� ������ (������):
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_Ven m WITH(NOLOCK)
		JOIN t_VenA tva WITH(NOLOCK) ON (m.ChID=tva.ChID)
		JOIN t_VenD d WITH(NOLOCK) ON (tva.ChID=d.ChID AND tva.ProdID=d.DetProdID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.DetProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - ���������� ��� ������� (������):
		SELECT rp.ProdID, SUM(d.Qty) SumQty
		FROM t_Est m WITH(NOLOCK)
		JOIN t_EstD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.NewPPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - ���������� ��� ������� (������):
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_Est m WITH(NOLOCK)
		JOIN t_EstD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - �������� ������� ������:
		SELECT rp.ProdID, SUM(m.Qty) SumQty
		FROM t_zInP m WITH(NOLOCK)
		JOIN t_PInP tp WITH(NOLOCK) ON (m.PPID=tp.PPID AND m.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - ������� ������ �� ����:
		SELECT rp.ProdID, SUM(d.Qty) SumQty
		FROM t_CRRet m WITH(NOLOCK)
		JOIN t_CRRetD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - ������� ������ ����������:
		SELECT rp.ProdID, SUM(0-(d.Qty)) SumQty
		FROM t_Sale m WITH(NOLOCK)
		JOIN t_SaleD d WITH(NOLOCK) ON (m.ChID=d.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.PPID=tp.PPID AND d.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - ������������ ������ (������):
		SELECT rp.ProdID, SUM(tsra.Qty) SumQty
		FROM t_SRec m WITH(NOLOCK)
		JOIN t_SRecA tsra WITH(NOLOCK) ON (m.ChID=tsra.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (tsra.PPID=tp.PPID AND tsra.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - ������������ ������ (������):
		SELECT rp.ProdID, SUM(0-(d.SubQty)) SumQty
		FROM t_SRec m WITH(NOLOCK)
		JOIN t_SRecA tsra WITH(NOLOCK) ON (m.ChID=tsra.ChID)
		JOIN t_SRecD d WITH(NOLOCK) ON (tsra.AChID=d.AChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.SubPPID=tp.PPID AND d.SubProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL


		-->>> �� ����� - ���������������� ������ (������):
		SELECT rp.ProdID, SUM(d.SubQty) SumQty
		FROM t_SExp m WITH(NOLOCK)
		JOIN t_SExpA tsea WITH(NOLOCK) ON (m.ChID=tsea.ChID)
		JOIN t_SExpD d WITH(NOLOCK) ON (tsea.AChID=d.AChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (d.SubPPID=tp.PPID AND d.SubProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
		--ORDER BY rp.ProdID
		UNION ALL

		-->>> �� ����� - ���������������� ������ (������):
		SELECT rp.ProdID, SUM(0-(tsea.Qty)) SumQty
		FROM t_SExp m WITH(NOLOCK)
		JOIN t_SExpA tsea WITH(NOLOCK) ON (m.ChID=tsea.ChID)
		JOIN t_PInP tp WITH(NOLOCK) ON (tsea.PPID=tp.PPID AND tsea.ProdID=tp.ProdID)
		JOIN r_Prods rp WITH(NOLOCK) ON (tp.ProdID=rp.ProdID)
			WHERE  rp.PGrID1 IN (SELECT AValue FROM zf_FilterToTable(@PGrID1))
				 AND rp.PCatID IN (SELECT AValue FROM zf_FilterToTable(@PCatID))
				 AND m.StockID IN (SELECT AValue FROM zf_FilterToTable(@StockID))
				 AND (m.DocDate <= @EDate)
		GROUP BY rp.ProdID
) q
GROUP BY q.ProdID

INSERT INTO #result
SELECT rpg1.PGrName1, 0, m.ProdID, m.ProdName, m.Weight, prmq.Qty, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
FROM r_Prods m
JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON rpg1.PGrID1 = m.PGrID1
JOIN r_ProdMQ prmq WITH(NOLOCK) ON prmq.ProdID = m.ProdID AND prmq.UM = '��.'
WHERE m.ProdID IN (SELECT DISTINCT ProdID FROM @heap)


UPDATE m SET AtBeginQty = ISNULL(h1.Qty, 0) --������� �� ������ �������
			,RecQty = ISNULL(h2.Qty, 0) --������
			,InvQty = ISNULL(h3.Qty, 0) --���������
			,ExpQty = ISNULL(h4.Qty, 0) --��
			,EppQty = ISNULL(h5.Qty, 0) --�� � ��
			,RetQty = ISNULL(h6.Qty, 0)	--������� �� ����������
			,ExcQtyOnStock = ISNULL(h7.Qty, 0) --����������� (�� �����)
			,ExcQtyFromStock = ISNULL(h8.Qty, 0) --����������� (�� ������)
			,AtEndQty = ISNULL(h9.Qty, 0) --������� �� ����� �������
FROM #result m
LEFT JOIN @heap h1 ON h1.ProdID = m.ProdID AND h1.OperationID = 1
LEFT JOIN @heap h2 ON h2.ProdID = m.ProdID AND h2.OperationID = 2
LEFT JOIN @heap h3 ON h3.ProdID = m.ProdID AND h3.OperationID = 3
LEFT JOIN @heap h4 ON h4.ProdID = m.ProdID AND h4.OperationID = 4
LEFT JOIN @heap h5 ON h5.ProdID = m.ProdID AND h5.OperationID = 5
LEFT JOIN @heap h6 ON h6.ProdID = m.ProdID AND h6.OperationID = 6
LEFT JOIN @heap h7 ON h7.ProdID = m.ProdID AND h7.OperationID = 7
LEFT JOIN @heap h8 ON h8.ProdID = m.ProdID AND h8.OperationID = 8
LEFT JOIN @heap h9 ON h9.ProdID = m.ProdID AND h9.OperationID = 9

UPDATE #result SET Sales = (InvQty + ExpQty + EppQty) - RetQty --�������

UPDATE #result SET Shortage = AtEndQty - Sales --�������

UPDATE #result SET OrderQty = CASE WHEN (Shortage%QtyInBox) = 0
								   THEN (Shortage/QtyInBox)*-1 ELSE (FLOOR( (Shortage*-1)/QtyInBox) + 1) * QtyInBox END --�����
WHERE Shortage < 0

END;

SELECT PGrName1			--��� ������ 1
	  ,AltCode			--��� ����������
	  ,ProdID			--�����
	  ,ProdName			--��� ������
	  ,Weight			--���
	  ,QtyInBox			--���-�� ���. � �����
	  ,AtBeginQty		--������� �� ������ �������
	  ,RecQty			--������
	  ,InvQty			--���������
	  ,ExpQty			--��
	  ,EppQty			--�� � ��
	  ,RetQty			--������� �� ����������
	  ,ExcQtyOnStock	--����������� (�� �����)
	  ,ExcQtyFromStock	--����������� (�� ������)
	  ,AtEndQty			--������� �� ����� �������
	  ,Sales			--�������
	  ,Shortage			--�������
	  ,OrderQty			--�����
FROM #result
ORDER BY PGrName1, ProdID

/*
SELECT 6%3

*/
END